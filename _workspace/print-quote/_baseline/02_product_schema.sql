-- =====================================================================
-- Print Auto-Quote Service: Product Domain Schema (PostgreSQL)
-- =====================================================================
-- Author: product-specialist
-- Date: 2026-05-07
-- Source: _workspace/print-quote/01_research_report.md
--
-- Design philosophy:
--   1. Data-driven specs: spec structures live in tables, not code.
--      A new product type (현수막, 스티커, 책자 ...) is added via INSERTs,
--      no schema or application code change required.
--   2. SKU explosion control: instead of materializing 1,600+ SKUs per
--      product, valid combinations are constrained by `product_spec_rules`.
--      The widget/quote engine evaluates rules at runtime.
--   3. Per-product spec ownership: `product_specifications` is keyed by
--      product_id (not a global spec catalog), because the same display
--      label "사이즈" means different things for 명함 (90×50 라디오) vs
--      현수막 (자유 mm 입력). Sharing across products would force EAV.
--   4. Heterogeneous input types: `input_type` (select/radio/number/
--      slider/text) lets the widget pick the right UI per spec without
--      hardcoding per product.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Extensions
-- ---------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "pgcrypto";  -- gen_random_uuid()


-- ---------------------------------------------------------------------
-- updated_at trigger function (shared across tables)
-- ---------------------------------------------------------------------
-- WHY: Avoids application-level clock skew and forgotten updates.
--      Single function reused by all tables in this domain.
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =====================================================================
-- 1. product_categories  (3-tier hierarchy via self-join)
-- =====================================================================
-- WHY self-join over fixed L1/L2/L3 columns:
--   - Research shows 6~8 대분류, 30~50 중분류, 100~200 소분류.
--     A flat self-referencing tree allows arbitrary depth if business
--     later introduces 4th tier (e.g., subcategory by use-case).
--   - `depth` is denormalized for cheap "WHERE depth=1" queries
--     (top-level menu rendering) without recursive CTE.
--   - `path` (materialized path) speeds breadcrumb queries.
-- =====================================================================
CREATE TABLE product_categories (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id       UUID,
    code            VARCHAR(64) NOT NULL UNIQUE,    -- e.g., 'CARD', 'CARD_GENERAL'
    name            VARCHAR(128) NOT NULL,           -- 대분류/중분류/소분류 한글명
    slug            VARCHAR(128) NOT NULL UNIQUE,    -- URL-safe identifier
    depth           SMALLINT NOT NULL DEFAULT 1,     -- 1=대, 2=중, 3=소
    path            VARCHAR(512),                    -- materialized path '/CARD/CARD_GENERAL'
    sort_order      INTEGER NOT NULL DEFAULT 0,
    description     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_product_categories_parent
        FOREIGN KEY (parent_id) REFERENCES product_categories(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_product_categories_depth
        CHECK (depth BETWEEN 1 AND 4),

    CONSTRAINT chk_product_categories_root_no_parent
        CHECK ((depth = 1 AND parent_id IS NULL) OR (depth > 1 AND parent_id IS NOT NULL))
);

CREATE INDEX idx_product_categories_parent      ON product_categories (parent_id);
CREATE INDEX idx_product_categories_depth_sort  ON product_categories (depth, sort_order) WHERE is_active = TRUE;
CREATE INDEX idx_product_categories_path        ON product_categories (path);

CREATE TRIGGER trg_product_categories_updated_at
    BEFORE UPDATE ON product_categories
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 2. products  (master catalog)
-- =====================================================================
-- WHY a thin master record:
--   - Heavy variability (specs, prices, rules) lives in child tables.
--     The product row stays cheap to read for catalog grids.
--   - `pricing_strategy` flags which downstream pricing engine to use
--     (lookup table for 명함 vs formula for 현수막). Pricing domain
--     reads it; product domain only stores it.
--   - `min_order_qty` / `max_order_qty` are MOQ guards surfaced by the
--     widget before submitting to the quote engine.
-- =====================================================================
CREATE TABLE products (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id         UUID NOT NULL,
    code                VARCHAR(64) NOT NULL UNIQUE,        -- e.g., 'CARD_GENERAL_STD'
    name                VARCHAR(128) NOT NULL,
    slug                VARCHAR(128) NOT NULL UNIQUE,
    short_description   VARCHAR(255),
    description         TEXT,
    thumbnail_url       VARCHAR(512),
    pricing_strategy    VARCHAR(32) NOT NULL DEFAULT 'lookup',
    min_order_qty       INTEGER NOT NULL DEFAULT 1,
    max_order_qty       INTEGER,
    base_lead_time_days SMALLINT NOT NULL DEFAULT 1,        -- 영업일 기준 기본 납기
    sort_order          INTEGER NOT NULL DEFAULT 0,
    metadata            JSONB NOT NULL DEFAULT '{}'::jsonb, -- 자유형 확장(아이콘, 태그 등)
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES product_categories(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_products_pricing_strategy
        CHECK (pricing_strategy IN ('lookup', 'formula', 'hybrid')),

    CONSTRAINT chk_products_qty_range
        CHECK (min_order_qty >= 1 AND (max_order_qty IS NULL OR max_order_qty >= min_order_qty))
);

CREATE INDEX idx_products_category_active   ON products (category_id, is_active);
CREATE INDEX idx_products_active_sort       ON products (is_active, sort_order);
CREATE INDEX idx_products_metadata_gin      ON products USING GIN (metadata);

CREATE TRIGGER trg_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 3. product_specifications  (per-product spec definitions)
-- =====================================================================
-- WHY scoped to product (not global):
--   - 명함 사이즈(규격 라디오) ≠ 현수막 사이즈(자유 mm 입력).
--     A global spec table would force conditional fields on the option
--     side or push us into EAV. Per-product specs keep semantics clean.
-- WHY input_type CHECK over ENUM:
--   - Adding 'color_picker' or 'file_upload' later requires only a
--     CHECK alteration, not an ALTER TYPE migration.
-- =====================================================================
CREATE TABLE product_specifications (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      UUID NOT NULL,
    name            VARCHAR(64) NOT NULL,        -- machine name: 'size','paper','coating'
    display_name    VARCHAR(128) NOT NULL,       -- 사용자 표시: '사이즈','용지','코팅'
    description     TEXT,
    input_type      VARCHAR(16) NOT NULL,        -- select/radio/number/slider/text
    is_required     BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order      INTEGER NOT NULL DEFAULT 0,
    -- numeric/slider 전용 보조 컬럼 (input_type=number|slider 일 때만 의미)
    min_value       NUMERIC(12,2),
    max_value       NUMERIC(12,2),
    step_value      NUMERIC(12,2),
    unit            VARCHAR(16),                 -- 'mm','㎡','매'
    placeholder     VARCHAR(128),
    help_text       TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_product_specifications_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_product_specifications_input_type
        CHECK (input_type IN ('select', 'radio', 'number', 'slider', 'text')),

    CONSTRAINT uq_product_specifications_product_name
        UNIQUE (product_id, name)
);

CREATE INDEX idx_product_specifications_product_active  ON product_specifications (product_id, is_active);
CREATE INDEX idx_product_specifications_product_sort    ON product_specifications (product_id, sort_order);

CREATE TRIGGER trg_product_specifications_updated_at
    BEFORE UPDATE ON product_specifications
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 4. product_spec_options  (selectable values per spec)
-- =====================================================================
-- WHY extra_cost_modifier as NUMERIC(4,4) multiplier:
--   - Stored as a multiplier (1.0000 = no change, 1.1500 = +15%, 0.9000
--     = -10%) lets the pricing engine compose modifiers from independent
--     specs. Absolute price deltas live in the pricing domain, not here.
--   - 4 fractional digits accommodate fine-grained 0.05% steps.
-- WHY value as TEXT:
--   - Options can be a paper code ('art_250'), a size string ('90x50'),
--     or a number string ('100'). One column avoids polymorphic columns.
-- =====================================================================
CREATE TABLE product_spec_options (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    spec_id             UUID NOT NULL,
    value               VARCHAR(128) NOT NULL,           -- machine value
    display_name        VARCHAR(128) NOT NULL,           -- 사용자 표시 라벨
    description         TEXT,
    extra_cost_modifier NUMERIC(4,4) NOT NULL DEFAULT 1.0000,
    image_url           VARCHAR(512),                    -- 카드형 라디오용 미리보기
    sort_order          INTEGER NOT NULL DEFAULT 0,
    is_default          BOOLEAN NOT NULL DEFAULT FALSE,
    metadata            JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_product_spec_options_spec
        FOREIGN KEY (spec_id) REFERENCES product_specifications(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_product_spec_options_modifier_positive
        CHECK (extra_cost_modifier > 0),

    CONSTRAINT uq_product_spec_options_spec_value
        UNIQUE (spec_id, value)
);

CREATE INDEX idx_product_spec_options_spec_sort     ON product_spec_options (spec_id, sort_order);
CREATE INDEX idx_product_spec_options_spec_active   ON product_spec_options (spec_id, is_active);
-- Partial unique index: at most one default per spec
CREATE UNIQUE INDEX uq_product_spec_options_default_per_spec
    ON product_spec_options (spec_id) WHERE is_default = TRUE;

CREATE TRIGGER trg_product_spec_options_updated_at
    BEFORE UPDATE ON product_spec_options
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 5. product_spec_rules  (dependency / exclusion rules)
-- =====================================================================
-- WHY this table replaces materialized SKUs:
--   - 1,600 SKUs per product become impractical to seed and audit.
--     Rules express "투명PVC 선택시 코팅 disable" once, regardless of
--     수량/도수 explosion.
--   - rule_type='enable' acts as a whitelist (only valid when the
--     condition holds), 'disable' as a blacklist (forbidden when the
--     condition holds), 'require' enforces co-selection.
-- WHY no GLOBAL fallback:
--   - All rules are scoped to a product to keep evaluation O(rules
--     per product) and avoid cross-product side effects.
-- =====================================================================
CREATE TABLE product_spec_rules (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id          UUID NOT NULL,
    name                VARCHAR(128),                       -- human-readable rule label
    condition_spec_id   UUID NOT NULL,
    condition_option_id UUID NOT NULL,
    target_spec_id      UUID NOT NULL,
    target_option_id    UUID,                               -- NULL = applies to entire target spec
    rule_type           VARCHAR(16) NOT NULL,               -- enable/disable/require
    priority            SMALLINT NOT NULL DEFAULT 100,      -- lower = evaluated first
    message             TEXT,                               -- 위젯이 사용자에게 보여줄 안내문
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_product_spec_rules_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_product_spec_rules_condition_spec
        FOREIGN KEY (condition_spec_id) REFERENCES product_specifications(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_product_spec_rules_condition_option
        FOREIGN KEY (condition_option_id) REFERENCES product_spec_options(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_product_spec_rules_target_spec
        FOREIGN KEY (target_spec_id) REFERENCES product_specifications(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_product_spec_rules_target_option
        FOREIGN KEY (target_option_id) REFERENCES product_spec_options(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_product_spec_rules_rule_type
        CHECK (rule_type IN ('enable', 'disable', 'require')),

    CONSTRAINT chk_product_spec_rules_no_self_target
        CHECK (condition_spec_id <> target_spec_id OR condition_option_id <> target_option_id)
);

CREATE INDEX idx_product_spec_rules_product_active  ON product_spec_rules (product_id, is_active);
CREATE INDEX idx_product_spec_rules_condition       ON product_spec_rules (condition_spec_id, condition_option_id);
CREATE INDEX idx_product_spec_rules_target          ON product_spec_rules (target_spec_id, target_option_id);

CREATE TRIGGER trg_product_spec_rules_updated_at
    BEFORE UPDATE ON product_spec_rules
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 6. product_templates  (preset configurations)
-- =====================================================================
-- WHY a JSONB blob for selected_options instead of a join table:
--   - Templates are read-mostly snapshots ("명함 기본 세트"). They are
--     denormalized intentionally — if a referenced option is later
--     deleted, the template still renders historical context.
--   - The widget reads it once on "기본 세트 적용" click, no joins.
-- =====================================================================
CREATE TABLE product_templates (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id          UUID NOT NULL,
    code                VARCHAR(64) NOT NULL,
    name                VARCHAR(128) NOT NULL,        -- '명함 기본 세트'
    description         TEXT,
    -- spec_id => option_id mapping snapshot, plus literal values for
    -- numeric specs (e.g., quantity:500). Example:
    -- {"spec:size":"opt:90x50","spec:paper":"opt:art_250","quantity":500}
    selected_options    JSONB NOT NULL DEFAULT '{}'::jsonb,
    is_featured         BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order          INTEGER NOT NULL DEFAULT 0,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_product_templates_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_product_templates_product_code
        UNIQUE (product_id, code)
);

CREATE INDEX idx_product_templates_product_active   ON product_templates (product_id, is_active);
CREATE INDEX idx_product_templates_featured         ON product_templates (is_featured) WHERE is_featured = TRUE;
CREATE INDEX idx_product_templates_options_gin      ON product_templates USING GIN (selected_options);

CREATE TRIGGER trg_product_templates_updated_at
    BEFORE UPDATE ON product_templates
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SEED DATA: 일반명함 (Standard Business Card)
-- =====================================================================
-- Demonstrates the full spec tree and one disable rule:
--   투명PVC 용지 선택 시 코팅 spec 전체 disable.
-- All UUIDs are generated inline via gen_random_uuid() and captured in
-- a CTE so seed inserts can reference each other without app-side IDs.
-- =====================================================================

DO $$
DECLARE
    v_cat_l1_id     UUID := gen_random_uuid();   -- 명함류 (대분류)
    v_cat_l2_id     UUID := gen_random_uuid();   -- 일반명함 (중분류)
    v_product_id    UUID := gen_random_uuid();

    -- spec ids
    v_spec_size     UUID := gen_random_uuid();
    v_spec_paper    UUID := gen_random_uuid();
    v_spec_coating  UUID := gen_random_uuid();
    v_spec_print    UUID := gen_random_uuid();
    v_spec_qty      UUID := gen_random_uuid();

    -- option ids (size)
    v_opt_size_90   UUID := gen_random_uuid();
    v_opt_size_86   UUID := gen_random_uuid();

    -- option ids (paper)
    v_opt_paper_art UUID := gen_random_uuid();
    v_opt_paper_snw UUID := gen_random_uuid();
    v_opt_paper_pvc UUID := gen_random_uuid();

    -- option ids (coating)
    v_opt_coat_none UUID := gen_random_uuid();
    v_opt_coat_glos UUID := gen_random_uuid();
    v_opt_coat_matt UUID := gen_random_uuid();
    v_opt_coat_uv   UUID := gen_random_uuid();

    -- option ids (print)
    v_opt_prn_4_2   UUID := gen_random_uuid();
    v_opt_prn_4_1   UUID := gen_random_uuid();
    v_opt_prn_1_1   UUID := gen_random_uuid();

    -- option ids (qty) -- representative steps; full table lives in pricing
    v_opt_qty_100   UUID := gen_random_uuid();
    v_opt_qty_500   UUID := gen_random_uuid();
    v_opt_qty_1000  UUID := gen_random_uuid();
BEGIN
    -- Categories
    INSERT INTO product_categories (id, parent_id, code, name, slug, depth, path, sort_order)
    VALUES
        (v_cat_l1_id, NULL,         'CARD',         '명함류',   'card',         1, '/CARD',                 10),
        (v_cat_l2_id, v_cat_l1_id,  'CARD_GENERAL', '일반명함', 'card-general', 2, '/CARD/CARD_GENERAL',    10);

    -- Product
    INSERT INTO products (id, category_id, code, name, slug, short_description,
                          pricing_strategy, min_order_qty, base_lead_time_days, sort_order)
    VALUES (v_product_id, v_cat_l2_id, 'CARD_GENERAL_STD', '일반명함', 'card-general-std',
            '표준 규격 일반명함 (90×50 / 86×54)', 'lookup', 100, 1, 10);

    -- Specifications
    INSERT INTO product_specifications (id, product_id, name, display_name, input_type, is_required, sort_order) VALUES
        (v_spec_size,    v_product_id, 'size',         '사이즈',     'radio',  TRUE, 10),
        (v_spec_paper,   v_product_id, 'paper',        '용지',       'radio',  TRUE, 20),
        (v_spec_coating, v_product_id, 'coating',      '코팅',       'select', TRUE, 30),
        (v_spec_print,   v_product_id, 'print_color',  '인쇄도수',   'radio',  TRUE, 40);

    -- Quantity spec uses slider input
    INSERT INTO product_specifications (id, product_id, name, display_name, input_type, is_required, sort_order,
                                        min_value, max_value, step_value, unit)
    VALUES (v_spec_qty, v_product_id, 'quantity', '수량', 'slider', TRUE, 50,
            100, 20000, 100, '매');

    -- Size options
    INSERT INTO product_spec_options (id, spec_id, value, display_name, extra_cost_modifier, sort_order, is_default) VALUES
        (v_opt_size_90, v_spec_size, '90x50', '90 × 50 mm (표준)', 1.0000, 10, TRUE),
        (v_opt_size_86, v_spec_size, '86x54', '86 × 54 mm (국제규격)', 1.0500, 20, FALSE);

    -- Paper options
    INSERT INTO product_spec_options (id, spec_id, value, display_name, extra_cost_modifier, sort_order, is_default) VALUES
        (v_opt_paper_art, v_spec_paper, 'art_250',          '아트지 250g',          1.0000, 10, TRUE),
        (v_opt_paper_snw, v_spec_paper, 'snow_white_300',   '스노우화이트 300g',    1.1500, 20, FALSE),
        (v_opt_paper_pvc, v_spec_paper, 'transparent_pvc',  '투명 PVC',             1.8000, 30, FALSE);

    -- Coating options
    INSERT INTO product_spec_options (id, spec_id, value, display_name, extra_cost_modifier, sort_order, is_default) VALUES
        (v_opt_coat_none, v_spec_coating, 'none',   '코팅 없음', 1.0000, 10, TRUE),
        (v_opt_coat_glos, v_spec_coating, 'glossy', '유광 라미', 1.0800, 20, FALSE),
        (v_opt_coat_matt, v_spec_coating, 'matte',  '무광 라미', 1.1000, 30, FALSE),
        (v_opt_coat_uv,   v_spec_coating, 'uv',     'UV 코팅',   1.1500, 40, FALSE);

    -- Print color options
    INSERT INTO product_spec_options (id, spec_id, value, display_name, extra_cost_modifier, sort_order, is_default) VALUES
        (v_opt_prn_4_2, v_spec_print, 'duplex_4',  '양면 4도(컬러)', 1.0000, 10, TRUE),
        (v_opt_prn_4_1, v_spec_print, 'simplex_4', '단면 4도(컬러)', 0.7000, 20, FALSE),
        (v_opt_prn_1_1, v_spec_print, 'simplex_1', '단면 1도(흑백)', 0.5000, 30, FALSE);

    -- Quantity options (representative; pricing engine owns the full curve)
    INSERT INTO product_spec_options (id, spec_id, value, display_name, extra_cost_modifier, sort_order, is_default) VALUES
        (v_opt_qty_100,  v_spec_qty, '100',  '100매',   1.0000, 10, TRUE),
        (v_opt_qty_500,  v_spec_qty, '500',  '500매',   1.0000, 20, FALSE),
        (v_opt_qty_1000, v_spec_qty, '1000', '1,000매', 1.0000, 30, FALSE);

    -- Rule: 투명 PVC 선택 시 코팅 전체 disable
    -- (target_option_id NULL → spec 단위로 비활성)
    INSERT INTO product_spec_rules (product_id, name, condition_spec_id, condition_option_id,
                                    target_spec_id, target_option_id, rule_type, priority, message)
    VALUES (v_product_id,
            '투명 PVC 선택 시 코팅 비활성',
            v_spec_paper, v_opt_paper_pvc,
            v_spec_coating, NULL,
            'disable', 10,
            '투명 PVC 용지는 표면 자체가 PET 코팅 처리되어 있어 추가 코팅을 적용할 수 없습니다.');

    -- Template: 명함 기본 세트
    INSERT INTO product_templates (product_id, code, name, description, selected_options, is_featured, sort_order)
    VALUES (v_product_id,
            'CARD_BASIC',
            '명함 기본 세트',
            '90×50 / 아트지 250g / 무광 라미 / 양면 4도 / 500매',
            jsonb_build_object(
                v_spec_size::text,    v_opt_size_90::text,
                v_spec_paper::text,   v_opt_paper_art::text,
                v_spec_coating::text, v_opt_coat_matt::text,
                v_spec_print::text,   v_opt_prn_4_2::text,
                v_spec_qty::text,     v_opt_qty_500::text
            ),
            TRUE, 10);
END $$;

-- =====================================================================
-- End of product domain schema
-- =====================================================================
