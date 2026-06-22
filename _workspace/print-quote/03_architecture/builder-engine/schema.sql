-- =====================================================================
-- Print-Quote (후니프린팅 리뉴얼) — Neon PG 통합 스키마 v0.1
-- =====================================================================
-- Author: pq-architect
-- Date: 2026-05-27
-- Base: _baseline/07_integrated_schema.sql (38 tables) — 베이스 보존
-- Target: PostgreSQL 14+ (Neon serverless 호환)
--
-- 변경 영역 ⭐:
--   - 빌더 도메인 신규 9테이블 (pages / sections / columns / blocks
--                              widgets / templates / design_tokens
--                              page_revisions / block_revisions)
--   - products 확장 (mes_item_cd, editor_mode, ps_code, shopby_product_no)
--   - quotes 확장 (session_id, widget_state, edicus_project_id)
--   - 신규: quote_lines, addresses, carts, cart_items, coupons,
--           coupon_usages, loyalty_points, loyalty_transactions
--   - 신규: design_projects, design_documents, editor_templates
--           vdp_datasets, edicus_order_mapping, shopby_order_mapping
--   - 신규: proof_cycles (교정 사이클)
--
-- 베이스라인 호환 정책:
--   - 38 테이블 컬럼·제약 변경 없음 (FK 추가만 가능)
--   - 신규 컬럼은 DEFAULT 또는 NULLABLE → migration 무중단
-- =====================================================================


-- =====================================================================
-- SECTION 0: EXTENSIONS & TRIGGERS (베이스라인과 동일)
-- =====================================================================
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";    -- ⭐ 검색용 GIN 인덱스

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =====================================================================
-- SECTION 1: BASELINE 38 TABLES (변경 없음, 참조만)
-- =====================================================================
-- 다음 38 테이블은 _baseline/07_integrated_schema.sql에서 그대로 가져옴.
-- 본 파일에서는 ⭐ 컬럼 추가·FK 추가만 ALTER로 표시. 전체 정의는 베이스라인 참조.
--
--  [Common]      users, system_configs
--  [Product]     product_categories, products, product_specifications,
--                product_spec_options, product_spec_rules, product_templates
--  [Pricing]     price_tables, quantity_price_breaks, spec_option_surcharges,
--                surcharge_rules, discount_policies, shipping_fee_rules
--  [Order]       quotes, orders, order_items, order_status_history,
--                artwork_files, payments, shipping_info
--  [Widget]      widget_configs, widget_steps, widget_step_fields,
--                widget_conditional_rules, preview_templates, ui_translations,
--                widget_analytics
--  [Production]  production_stage_types, equipment_configs, production_jobs,
--                production_job_items, job_stage_status, print_materials,
--                material_usage_log, business_calendar, production_specs,
--                qc_checkpoints
-- =====================================================================


-- =====================================================================
-- SECTION 2: BUILDER DOMAIN (신규 9 테이블) ⭐
-- =====================================================================

-- 2.1 design_tokens — 디자인 토큰 (Huni v6.0 + edicus.man CssPreset)
-- ⭐ 신규. edicus.man `custom-css.ts` CssPreset 흡수 + 어드민 편집 가능.
CREATE TABLE design_tokens (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_key       VARCHAR(128) NOT NULL,
    token_type      VARCHAR(16) NOT NULL,
    value           TEXT NOT NULL,
    theme           VARCHAR(32) NOT NULL DEFAULT 'default',
    description     TEXT,
    is_deprecated   BOOLEAN NOT NULL DEFAULT FALSE,
    metadata        JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_design_tokens_type CHECK (token_type IN (
        'color', 'spacing', 'typography', 'radius', 'shadow', 'motion', 'breakpoint'
    )),
    CONSTRAINT uq_design_tokens_theme_key UNIQUE (theme, token_key)
);

CREATE INDEX idx_design_tokens_theme_type ON design_tokens (theme, token_type) WHERE is_deprecated = FALSE;

CREATE TRIGGER trg_design_tokens_updated_at
    BEFORE UPDATE ON design_tokens
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 2.2 widgets — 위젯 카탈로그 마스터
-- ⭐ 신규. block-schema.md §2의 14 V1 위젯 등록.
CREATE TABLE widgets (
    code            VARCHAR(64) PRIMARY KEY,
    display_name    VARCHAR(128) NOT NULL,
    category        VARCHAR(32) NOT NULL,
    icon            VARCHAR(255),
    prop_schema     JSONB NOT NULL,
    default_props   JSONB NOT NULL DEFAULT '{}'::jsonb,
    component_path  VARCHAR(255) NOT NULL,
    ssr_mode        VARCHAR(16) NOT NULL DEFAULT 'rsc',
    schema_version  VARCHAR(16) NOT NULL DEFAULT '1.0.0',
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_widgets_category CHECK (category IN (
        'layout', 'content', 'commerce', 'print_quote', 'form'
    )),
    CONSTRAINT chk_widgets_ssr_mode CHECK (ssr_mode IN ('rsc', 'client', 'hybrid'))
);

CREATE INDEX idx_widgets_category_active ON widgets (category, is_active);

CREATE TRIGGER trg_widgets_updated_at
    BEFORE UPDATE ON widgets
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 2.3 templates — 페이지·섹션·블록 템플릿
-- ⭐ 신규.
CREATE TABLE templates (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code            VARCHAR(64) NOT NULL UNIQUE,
    scope           VARCHAR(16) NOT NULL,
    title           VARCHAR(255) NOT NULL,
    category        VARCHAR(32),
    tree            JSONB NOT NULL,
    thumbnail_url   VARCHAR(512),
    is_global       BOOLEAN NOT NULL DEFAULT FALSE,
    product_id      UUID,          -- NULL if global, else attaches to a product
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_templates_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL,
    CONSTRAINT chk_templates_scope CHECK (scope IN ('page', 'section', 'block'))
);

CREATE INDEX idx_templates_scope_active ON templates (scope, is_active);
CREATE INDEX idx_templates_product ON templates (product_id) WHERE product_id IS NOT NULL;
CREATE INDEX idx_templates_tree_gin ON templates USING GIN (tree);

CREATE TRIGGER trg_templates_updated_at
    BEFORE UPDATE ON templates
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 2.4 pages — 빌더 페이지 (홈/상품/카테고리/에디토리얼 등)
-- ⭐ 신규. As-Is WP page CPT 대체.
CREATE TABLE pages (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug            VARCHAR(128) NOT NULL UNIQUE,
    title           VARCHAR(255) NOT NULL,
    page_type       VARCHAR(32) NOT NULL,
    status          VARCHAR(16) NOT NULL DEFAULT 'draft',
    version         INT NOT NULL DEFAULT 1,
    template_id     UUID,
    seo_meta        JSONB NOT NULL DEFAULT '{}'::jsonb,
    published_at    TIMESTAMPTZ,
    published_by    UUID,
    metadata        JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,

    CONSTRAINT fk_pages_template
        FOREIGN KEY (template_id) REFERENCES templates(id) ON DELETE SET NULL,
    CONSTRAINT fk_pages_publisher
        FOREIGN KEY (published_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_pages_page_type CHECK (page_type IN (
        'landing', 'product_detail', 'category', 'editorial', 'legal', 'system'
    )),
    CONSTRAINT chk_pages_status CHECK (status IN ('draft', 'published', 'archived')),
    CONSTRAINT chk_pages_publish_consistency CHECK (
        status <> 'published' OR (published_at IS NOT NULL AND published_by IS NOT NULL)
    )
);

CREATE INDEX idx_pages_slug_status ON pages (slug) WHERE deleted_at IS NULL;
CREATE INDEX idx_pages_status_type ON pages (status, page_type) WHERE deleted_at IS NULL;
CREATE INDEX idx_pages_seo_gin ON pages USING GIN (seo_meta);

CREATE TRIGGER trg_pages_updated_at
    BEFORE UPDATE ON pages
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 2.5 sections — 페이지 내 수직 슬라이스
-- ⭐ 신규.
CREATE TABLE sections (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    page_id         UUID NOT NULL,
    sort_order      INT NOT NULL DEFAULT 0,
    settings        JSONB NOT NULL DEFAULT '{}'::jsonb,
    visibility      JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_sections_page
        FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE
);

CREATE INDEX idx_sections_page_sort ON sections (page_id, sort_order);

CREATE TRIGGER trg_sections_updated_at
    BEFORE UPDATE ON sections
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 2.6 columns — Section 내 수평 칸 (12-grid)
-- ⭐ 신규.
CREATE TABLE columns (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    section_id      UUID NOT NULL,
    sort_order      INT NOT NULL DEFAULT 0,
    span            SMALLINT NOT NULL DEFAULT 12,
    span_tablet     SMALLINT,
    span_mobile     SMALLINT,
    settings        JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_columns_section
        FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE,
    CONSTRAINT chk_columns_span CHECK (span BETWEEN 1 AND 12),
    CONSTRAINT chk_columns_span_tablet CHECK (span_tablet IS NULL OR span_tablet BETWEEN 1 AND 12),
    CONSTRAINT chk_columns_span_mobile CHECK (span_mobile IS NULL OR span_mobile BETWEEN 1 AND 12)
);

CREATE INDEX idx_columns_section_sort ON columns (section_id, sort_order);

CREATE TRIGGER trg_columns_updated_at
    BEFORE UPDATE ON columns
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 2.7 blocks — 빌더 트리의 핵심 노드 (위젯 인스턴스)
-- ⭐ 신규. block-schema.md §1.1 BlockSchema 직렬화.
CREATE TABLE blocks (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    column_id           UUID,                       -- top-level block
    parent_block_id     UUID,                       -- nested (Tabs 안의 Tab 등)
    widget_code         VARCHAR(64) NOT NULL,
    sort_order          INT NOT NULL DEFAULT 0,
    props               JSONB NOT NULL DEFAULT '{}'::jsonb,
    bindings            JSONB NOT NULL DEFAULT '{}'::jsonb,
    style               JSONB NOT NULL DEFAULT '{}'::jsonb,
    condition           JSONB,
    schema_version      INT NOT NULL DEFAULT 1,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_blocks_column
        FOREIGN KEY (column_id) REFERENCES columns(id) ON DELETE CASCADE,
    CONSTRAINT fk_blocks_parent
        FOREIGN KEY (parent_block_id) REFERENCES blocks(id) ON DELETE CASCADE,
    CONSTRAINT fk_blocks_widget
        FOREIGN KEY (widget_code) REFERENCES widgets(code) ON DELETE RESTRICT,
    CONSTRAINT chk_blocks_parent_xor CHECK (
        (column_id IS NOT NULL AND parent_block_id IS NULL) OR
        (column_id IS NULL AND parent_block_id IS NOT NULL)
    )
);

CREATE INDEX idx_blocks_column_sort ON blocks (column_id, sort_order) WHERE column_id IS NOT NULL;
CREATE INDEX idx_blocks_parent_sort ON blocks (parent_block_id, sort_order) WHERE parent_block_id IS NOT NULL;
CREATE INDEX idx_blocks_widget ON blocks (widget_code);
CREATE INDEX idx_blocks_props_gin ON blocks USING GIN (props);
CREATE INDEX idx_blocks_bindings_gin ON blocks USING GIN (bindings);

CREATE TRIGGER trg_blocks_updated_at
    BEFORE UPDATE ON blocks
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 2.8 page_revisions — 페이지 발행 이력 (immutable snapshot)
-- ⭐ 신규.
CREATE TABLE page_revisions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    page_id         UUID NOT NULL,
    version         INT NOT NULL,
    snapshot        JSONB NOT NULL,         -- 전체 tree (sections+columns+blocks) 직렬화
    created_by      UUID,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    comment         TEXT,

    CONSTRAINT fk_page_revisions_page
        FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE,
    CONSTRAINT fk_page_revisions_user
        FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT uq_page_revisions_page_version UNIQUE (page_id, version)
);

CREATE INDEX idx_page_revisions_page_created ON page_revisions (page_id, created_at DESC);


-- 2.9 bindings — 데이터 바인딩 표현식 카탈로그
-- ⭐ 신규. block-schema.md §4 Binding 마스터.
CREATE TABLE bindings (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(64) NOT NULL UNIQUE,
    source          VARCHAR(32) NOT NULL,
    expression      TEXT NOT NULL,
    return_type     VARCHAR(32) NOT NULL,
    description     TEXT,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_bindings_source CHECK (source IN (
        'product', 'quote', 'cart', 'member', 'cms', 'system'
    )),
    CONSTRAINT chk_bindings_return_type CHECK (return_type IN (
        'string', 'number', 'boolean', 'object', 'list', 'date'
    ))
);

CREATE INDEX idx_bindings_source_active ON bindings (source, is_active);

CREATE TRIGGER trg_bindings_updated_at
    BEFORE UPDATE ON bindings
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SECTION 3: PRODUCT DOMAIN EXTENSIONS ⭐
-- =====================================================================
-- 베이스라인 `products` 등 6테이블은 그대로 유지하고, 컬럼만 추가.

-- 3.1 products 확장 (MES ITEM_CD + Edicus + Shopby 매핑)
-- MES 외부 시스템이 코드 부여 (D-PM-01 Decided 2026-05-28).
-- 신규 빌더는 자동발급하지 않으며, MES 동기화 전 mes_item_cd는 NULL.
-- 가격 엔진 lookup은 internal product_id(primary) + mes_item_cd(secondary) 양쪽 지원.
ALTER TABLE products
    ADD COLUMN mes_item_cd          VARCHAR(8),           -- ⭐ "001-0001" 형식, MES 외부 부여 (NULL 허용)
    ADD COLUMN mes_internal_id      INT,                  -- ⭐ xlsx ID (14529 등)
    ADD COLUMN mes_sync_status      VARCHAR(20),          -- ⭐ D-PM-01: 'pending'|'synced'|'failed'
    ADD COLUMN mes_synced_at        TIMESTAMPTZ,          -- ⭐ D-PM-01: 마지막 동기화 시각
    ADD COLUMN editor_mode          VARCHAR(16) DEFAULT 'iframe',  -- ⭐ ADR-002 D4
    ADD COLUMN ps_code              VARCHAR(64),          -- ⭐ Edicus 상품 코드
    ADD COLUMN shopby_product_no    VARCHAR(64),          -- ⭐ Shopby 그림자 상품
    ADD COLUMN widget_page_id       UUID,                 -- ⭐ 상품 상세 페이지 빌더 산출물
    ADD CONSTRAINT chk_products_mes_item_cd_format
        CHECK (mes_item_cd IS NULL OR mes_item_cd ~ '^[0-9]{3}-[0-9]{4}$'),
    ADD CONSTRAINT chk_products_mes_sync_status
        CHECK (mes_sync_status IS NULL OR mes_sync_status IN ('pending', 'synced', 'failed')),
    ADD CONSTRAINT chk_products_editor_mode
        CHECK (editor_mode IN ('iframe', 'passive', 'lite', 'upload_only', 'vdp')),
    ADD CONSTRAINT fk_products_widget_page
        FOREIGN KEY (widget_page_id) REFERENCES pages(id) ON DELETE SET NULL;

CREATE UNIQUE INDEX idx_products_mes_item_cd ON products (mes_item_cd) WHERE mes_item_cd IS NOT NULL;
CREATE UNIQUE INDEX idx_products_ps_code ON products (ps_code) WHERE ps_code IS NOT NULL;
CREATE INDEX idx_products_shopby_no ON products (shopby_product_no) WHERE shopby_product_no IS NOT NULL;


-- 3.2 option_groups — 복수 spec 묶음 (UI grouping)
-- ⭐ 신규. domain-model.md §2.6.
CREATE TABLE option_groups (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      UUID NOT NULL,
    code            VARCHAR(64) NOT NULL,
    display_name    VARCHAR(128) NOT NULL,
    spec_ids        UUID[] NOT NULL,         -- 묶인 specifications (순서 유지)
    layout          VARCHAR(16) NOT NULL DEFAULT 'inline',
    sort_order      INT NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_option_groups_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT chk_option_groups_layout CHECK (layout IN ('inline', 'card_grid', 'swatch', 'tabs')),
    CONSTRAINT uq_option_groups_product_code UNIQUE (product_id, code)
);

CREATE INDEX idx_option_groups_product_sort ON option_groups (product_id, sort_order);

CREATE TRIGGER trg_option_groups_updated_at
    BEFORE UPDATE ON option_groups
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SECTION 4: QUOTE DOMAIN EXTENSIONS ⭐
-- =====================================================================

-- 4.1 quotes 확장
ALTER TABLE quotes
    ADD COLUMN session_id           VARCHAR(64),          -- ⭐ 게스트 견적 세션
    ADD COLUMN widget_state         JSONB,                -- ⭐ 위젯 입력 원본 (재진입 시 복원)
    ADD COLUMN edicus_project_id    VARCHAR(64);          -- ⭐ Edicus 매핑 (디자인 진입 시 연결)

CREATE INDEX idx_quotes_session ON quotes (session_id) WHERE session_id IS NOT NULL;
CREATE INDEX idx_quotes_edicus_project ON quotes (edicus_project_id) WHERE edicus_project_id IS NOT NULL;


-- 4.2 quote_lines — 견적 다건화
-- ⭐ 신규. _baseline quotes는 단일 상품, 카트(여러 견적 묶음)를 위해 분리.
CREATE TABLE quote_lines (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quote_id            UUID NOT NULL,
    product_id          UUID NOT NULL,
    sort_order          INT NOT NULL DEFAULT 0,
    spec_snapshot       JSONB NOT NULL,
    quantity            INT NOT NULL,
    price_breakdown     JSONB NOT NULL,
    unit_price          NUMERIC(12,2) NOT NULL,
    line_subtotal       NUMERIC(12,2) NOT NULL,
    line_total          NUMERIC(12,2) NOT NULL,
    edicus_project_id   VARCHAR(64),                       -- 라인별 디자인 프로젝트
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_quote_lines_quote
        FOREIGN KEY (quote_id) REFERENCES quotes(id) ON DELETE CASCADE,
    CONSTRAINT fk_quote_lines_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    CONSTRAINT chk_quote_lines_quantity CHECK (quantity > 0),
    CONSTRAINT chk_quote_lines_amounts CHECK (
        unit_price >= 0 AND line_subtotal >= 0 AND line_total >= 0
    )
);

CREATE INDEX idx_quote_lines_quote ON quote_lines (quote_id, sort_order);
CREATE INDEX idx_quote_lines_product ON quote_lines (product_id);
CREATE INDEX idx_quote_lines_edicus ON quote_lines (edicus_project_id) WHERE edicus_project_id IS NOT NULL;

CREATE TRIGGER trg_quote_lines_updated_at
    BEFORE UPDATE ON quote_lines
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SECTION 5: MEMBER-ORDER DOMAIN ⭐
-- =====================================================================

-- 5.1 users 확장 (Shopby + Edicus 매핑)
ALTER TABLE users
    ADD COLUMN shopby_member_no     VARCHAR(64),          -- ⭐ Shopby 회원 (O-001 잠정)
    ADD COLUMN auth_provider        VARCHAR(16) NOT NULL DEFAULT 'local',  -- ⭐
    ADD COLUMN ci                   VARCHAR(88),          -- ⭐ 본인인증 (한국)
    ADD COLUMN edicus_uid           VARCHAR(64),          -- ⭐ Edicus 호출의 uid
    ADD CONSTRAINT chk_users_auth_provider
        CHECK (auth_provider IN ('local', 'shopby', 'naver', 'kakao', 'google', 'guest'));

CREATE UNIQUE INDEX idx_users_shopby_no ON users (shopby_member_no) WHERE shopby_member_no IS NOT NULL;
CREATE UNIQUE INDEX idx_users_edicus_uid ON users (edicus_uid) WHERE edicus_uid IS NOT NULL;
CREATE INDEX idx_users_ci ON users (ci) WHERE ci IS NOT NULL;


-- 5.2 addresses — 회원 주소록
-- ⭐ 신규.
CREATE TABLE addresses (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL,
    label           VARCHAR(64),
    recipient_name  VARCHAR(100) NOT NULL,
    recipient_phone VARCHAR(20) NOT NULL,
    postal_code     VARCHAR(10) NOT NULL,
    address_road    VARCHAR(500) NOT NULL,
    address_detail  VARCHAR(200),
    is_default      BOOLEAN NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,

    CONSTRAINT fk_addresses_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_addresses_user_default ON addresses (user_id, is_default) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX idx_addresses_user_one_default ON addresses (user_id) WHERE is_default = TRUE AND deleted_at IS NULL;

CREATE TRIGGER trg_addresses_updated_at
    BEFORE UPDATE ON addresses
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 5.3 carts — 카트 (옵션 C 결정에 따라 자체 카트)
-- ⭐ 신규.
CREATE TABLE carts (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID,
    session_id      VARCHAR(64),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_carts_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_carts_identity CHECK (user_id IS NOT NULL OR session_id IS NOT NULL)
);

CREATE INDEX idx_carts_user ON carts (user_id) WHERE user_id IS NOT NULL;
CREATE INDEX idx_carts_session ON carts (session_id) WHERE session_id IS NOT NULL;

CREATE TRIGGER trg_carts_updated_at
    BEFORE UPDATE ON carts
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 5.4 cart_items
-- ⭐ 신규.
CREATE TABLE cart_items (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cart_id             UUID NOT NULL,
    quote_id            UUID NOT NULL,
    quote_line_id       UUID,
    edicus_project_id   VARCHAR(64),
    quantity            INT NOT NULL DEFAULT 1,
    sort_order          INT NOT NULL DEFAULT 0,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_cart_items_cart
        FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_items_quote
        FOREIGN KEY (quote_id) REFERENCES quotes(id) ON DELETE RESTRICT,
    CONSTRAINT fk_cart_items_quote_line
        FOREIGN KEY (quote_line_id) REFERENCES quote_lines(id) ON DELETE SET NULL,
    CONSTRAINT chk_cart_items_quantity CHECK (quantity > 0)
);

CREATE INDEX idx_cart_items_cart_sort ON cart_items (cart_id, sort_order);


-- 5.5 orders 확장 (Shopby + Edicus + payment_provider)
ALTER TABLE orders
    ADD COLUMN shopby_order_no      VARCHAR(64),       -- ⭐
    ADD COLUMN edicus_order_id      VARCHAR(64),       -- ⭐ ADR-002 D7
    ADD COLUMN payment_provider     VARCHAR(32);       -- ⭐ toss / naverpay / kakaopay / shopby_pg

CREATE INDEX idx_orders_shopby_no ON orders (shopby_order_no) WHERE shopby_order_no IS NOT NULL;
CREATE INDEX idx_orders_edicus_id ON orders (edicus_order_id) WHERE edicus_order_id IS NOT NULL;


-- 5.6 coupons — 쿠폰 마스터
-- ⭐ 신규. (O-001에서 Shopby 위임 가능성 — 자체 마스터일 경우)
CREATE TABLE coupons (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code                    VARCHAR(32) NOT NULL UNIQUE,
    name                    VARCHAR(128) NOT NULL,
    discount_type           VARCHAR(16) NOT NULL,
    discount_value          NUMERIC(12,4) NOT NULL,
    min_order_amount        NUMERIC(12,2) NOT NULL DEFAULT 0,
    max_discount_amount     NUMERIC(12,2),
    applicable_categories   UUID[],
    applicable_products     UUID[],
    valid_from              TIMESTAMPTZ NOT NULL,
    valid_to                TIMESTAMPTZ NOT NULL,
    usage_limit             INT,
    usage_limit_per_user    INT,
    stack_policy            VARCHAR(16) NOT NULL DEFAULT 'exclusive',
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_coupons_discount_type CHECK (discount_type IN ('percentage', 'fixed')),
    CONSTRAINT chk_coupons_stack_policy CHECK (stack_policy IN ('exclusive', 'stackable')),
    CONSTRAINT chk_coupons_validity CHECK (valid_to > valid_from)
);

CREATE INDEX idx_coupons_code_active ON coupons (code) WHERE is_active = TRUE;
CREATE INDEX idx_coupons_validity ON coupons (valid_from, valid_to) WHERE is_active = TRUE;

CREATE TRIGGER trg_coupons_updated_at
    BEFORE UPDATE ON coupons
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 5.7 coupon_usages — 쿠폰 사용 이력
CREATE TABLE coupon_usages (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    coupon_id       UUID NOT NULL,
    user_id         UUID NOT NULL,
    order_id        UUID NOT NULL,
    discount_amount NUMERIC(12,2) NOT NULL,
    used_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_coupon_usages_coupon
        FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE RESTRICT,
    CONSTRAINT fk_coupon_usages_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_coupon_usages_order
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE INDEX idx_coupon_usages_coupon ON coupon_usages (coupon_id);
CREATE INDEX idx_coupon_usages_user ON coupon_usages (user_id);
CREATE INDEX idx_coupon_usages_order ON coupon_usages (order_id);


-- 5.8 loyalty_points — 적립금 잔액 (1:1 with users)
-- ⭐ 신규.
CREATE TABLE loyalty_points (
    user_id         UUID PRIMARY KEY,
    balance         NUMERIC(12,2) NOT NULL DEFAULT 0,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_loyalty_points_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_loyalty_points_balance CHECK (balance >= 0)
);

CREATE TRIGGER trg_loyalty_points_updated_at
    BEFORE UPDATE ON loyalty_points
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 5.9 loyalty_transactions — 적립/사용 이력
CREATE TABLE loyalty_transactions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL,
    transaction_type VARCHAR(16) NOT NULL,
    amount          NUMERIC(12,2) NOT NULL,
    order_id        UUID,
    description     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_loyalty_tx_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_loyalty_tx_order
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
    CONSTRAINT chk_loyalty_tx_type CHECK (transaction_type IN ('earn', 'use', 'expire', 'admin_adjust'))
);

CREATE INDEX idx_loyalty_tx_user_created ON loyalty_transactions (user_id, created_at DESC);


-- 5.10 payments 확장
ALTER TABLE payments
    ADD COLUMN provider_payment_key VARCHAR(200);        -- ⭐ Toss paymentKey, NaverPay reserveId 등


-- =====================================================================
-- SECTION 6: DESIGN-ASSET DOMAIN ⭐
-- =====================================================================

-- 6.1 design_projects — Edicus 프로젝트 매핑
-- ⭐ 신규. edicus.man EdicusProject 흡수 + 내부 ID.
CREATE TABLE design_projects (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    edicus_project_id   VARCHAR(64) NOT NULL UNIQUE,
    user_id             UUID,
    product_id          UUID NOT NULL,
    quote_id            UUID,
    status              VARCHAR(16) NOT NULL DEFAULT 'editing',
    title               VARCHAR(255),
    template_uri        VARCHAR(512),
    content_uri         VARCHAR(512),
    preview_urls        TEXT[] NOT NULL DEFAULT '{}',
    metadata            JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_design_projects_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_design_projects_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    CONSTRAINT fk_design_projects_quote
        FOREIGN KEY (quote_id) REFERENCES quotes(id) ON DELETE SET NULL,
    CONSTRAINT chk_design_projects_status CHECK (status IN ('editing', 'ordering', 'ordered'))
);

CREATE INDEX idx_design_projects_user ON design_projects (user_id, updated_at DESC);
CREATE INDEX idx_design_projects_status ON design_projects (status);
CREATE INDEX idx_design_projects_quote ON design_projects (quote_id) WHERE quote_id IS NOT NULL;

CREATE TRIGGER trg_design_projects_updated_at
    BEFORE UPDATE ON design_projects
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 6.2 design_documents — 프로젝트 내 페이지/시트
CREATE TABLE design_documents (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id      UUID NOT NULL,
    page_index      INT NOT NULL,
    canvas_uri      VARCHAR(512),
    thumbnail_url   VARCHAR(512),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_design_documents_project
        FOREIGN KEY (project_id) REFERENCES design_projects(id) ON DELETE CASCADE,
    CONSTRAINT chk_design_documents_page_index CHECK (page_index >= 1),
    CONSTRAINT uq_design_documents_project_page UNIQUE (project_id, page_index)
);

CREATE INDEX idx_design_documents_project ON design_documents (project_id, page_index);

CREATE TRIGGER trg_design_documents_updated_at
    BEFORE UPDATE ON design_documents
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 6.3 editor_templates — Edicus 템플릿 카탈로그 (캐시)
-- ⭐ 신규. edicus.man EdicusTemplate.
CREATE TABLE editor_templates (
    resource_id     VARCHAR(64) PRIMARY KEY,
    title           VARCHAR(255) NOT NULL,
    ps_code         VARCHAR(64) NOT NULL,
    product_id      UUID,
    template_uri    VARCHAR(512) NOT NULL,
    category        VARCHAR(64),
    thumbnail_url   VARCHAR(512),
    metadata        JSONB NOT NULL DEFAULT '{}'::jsonb,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    synced_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_editor_templates_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL
);

CREATE INDEX idx_editor_templates_ps_code ON editor_templates (ps_code, is_active);
CREATE INDEX idx_editor_templates_product ON editor_templates (product_id) WHERE product_id IS NOT NULL;
CREATE INDEX idx_editor_templates_category ON editor_templates (category) WHERE is_active = TRUE;


-- 6.4 edicus_order_mapping — Edicus order_id 매핑
-- ⭐ 신규. ADR-002 D7, ADR-003 A6.
CREATE TABLE edicus_order_mapping (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    internal_order_id   UUID NOT NULL,
    edicus_order_id     VARCHAR(64) NOT NULL UNIQUE,
    edicus_project_id   VARCHAR(64) NOT NULL,
    synced_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_edicus_order_mapping_order
        FOREIGN KEY (internal_order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE INDEX idx_edicus_order_mapping_internal ON edicus_order_mapping (internal_order_id);
CREATE INDEX idx_edicus_order_mapping_project ON edicus_order_mapping (edicus_project_id);


-- 6.5 shopby_order_mapping — Shopby 주문 매핑
-- ⭐ 신규. ADR-003 A7.
CREATE TABLE shopby_order_mapping (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    internal_order_id   UUID NOT NULL,
    shopby_order_no     VARCHAR(64) NOT NULL UNIQUE,
    shopby_member_no    VARCHAR(64),
    synced_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_shopby_order_mapping_order
        FOREIGN KEY (internal_order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE INDEX idx_shopby_order_mapping_internal ON shopby_order_mapping (internal_order_id);


-- 6.6 vdp_datasets — 가변 데이터 인쇄(VDP)
-- ⭐ 신규. edicus.man VdpField 흡수.
CREATE TABLE vdp_datasets (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id          UUID NOT NULL,
    field_definitions   JSONB NOT NULL,    -- [{key, label, type, required, defaultValue}]
    rows                JSONB NOT NULL,    -- varMap[] -- [{name:"홍길동",...}]
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_vdp_datasets_project
        FOREIGN KEY (project_id) REFERENCES design_projects(id) ON DELETE CASCADE
);

CREATE INDEX idx_vdp_datasets_project ON vdp_datasets (project_id);

CREATE TRIGGER trg_vdp_datasets_updated_at
    BEFORE UPDATE ON vdp_datasets
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SECTION 7: PRODUCTION DOMAIN EXTENSIONS ⭐
-- =====================================================================

-- 7.1 proof_cycles — 교정 사이클
-- ⭐ 신규. Aurora 분석 03_print-fit §한계 3 ("교정 워크플로 부재") 대응.
CREATE TABLE proof_cycles (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_item_id       UUID NOT NULL,
    cycle_number        INT NOT NULL,
    requested_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    proof_file_key      VARCHAR(500),
    proof_thumbnail_url VARCHAR(512),
    customer_decision   VARCHAR(16),
    customer_notes      TEXT,
    operator_id         UUID,
    decided_at          TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_proof_cycles_order_item
        FOREIGN KEY (order_item_id) REFERENCES order_items(id) ON DELETE CASCADE,
    CONSTRAINT fk_proof_cycles_operator
        FOREIGN KEY (operator_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_proof_cycles_decision CHECK (
        customer_decision IS NULL OR
        customer_decision IN ('approved', 'revise', 'cancel')
    ),
    CONSTRAINT chk_proof_cycles_cycle CHECK (cycle_number >= 1),
    CONSTRAINT uq_proof_cycles_item_cycle UNIQUE (order_item_id, cycle_number)
);

CREATE INDEX idx_proof_cycles_item ON proof_cycles (order_item_id, cycle_number);
CREATE INDEX idx_proof_cycles_pending ON proof_cycles (order_item_id) WHERE customer_decision IS NULL;

CREATE TRIGGER trg_proof_cycles_updated_at
    BEFORE UPDATE ON proof_cycles
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SECTION 8: SHOPBY MEMBER CACHE (Refresh Token 등) ⭐
-- =====================================================================

-- 8.1 shopby_member_tokens — Shopby refresh token 암호화 저장
-- ⭐ 신규. BFF가 refresh로 access 재발급 시 사용.
CREATE TABLE shopby_member_tokens (
    user_id                     UUID PRIMARY KEY,
    refresh_token_encrypted     TEXT NOT NULL,
    expires_at                  TIMESTAMPTZ NOT NULL,
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_shopby_member_tokens_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TRIGGER trg_shopby_member_tokens_updated_at
    BEFORE UPDATE ON shopby_member_tokens
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SECTION 9: AUDIT & GUEST SESSION ⭐
-- =====================================================================

-- 9.1 guest_sessions — 게스트 견적 세션 (24h TTL)
-- ⭐ 신규.
CREATE TABLE guest_sessions (
    guest_token         VARCHAR(64) PRIMARY KEY,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at          TIMESTAMPTZ NOT NULL,
    metadata            JSONB NOT NULL DEFAULT '{}'::jsonb,
    last_seen_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_guest_sessions_expiry CHECK (expires_at > created_at)
);

CREATE INDEX idx_guest_sessions_expires ON guest_sessions (expires_at);


-- 9.2 audit_logs — BFF 외부 호출 audit
-- ⭐ 신규.
CREATE TABLE audit_logs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trace_id        UUID NOT NULL,
    actor_user_id   UUID,
    actor_session   VARCHAR(64),
    action          VARCHAR(64) NOT NULL,
    target_type     VARCHAR(32),
    target_id       VARCHAR(64),
    payload         JSONB NOT NULL DEFAULT '{}'::jsonb,
    external_system VARCHAR(32),
    status_code     INT,
    duration_ms     INT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_audit_logs_user
        FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_audit_logs_external_system CHECK (
        external_system IS NULL OR
        external_system IN ('shopby', 'edicus', 'pg_toss', 'pg_naverpay', 'pg_kakaopay', 'firebase')
    )
);

CREATE INDEX idx_audit_logs_trace ON audit_logs (trace_id);
CREATE INDEX idx_audit_logs_user_created ON audit_logs (actor_user_id, created_at DESC) WHERE actor_user_id IS NOT NULL;
CREATE INDEX idx_audit_logs_action_created ON audit_logs (action, created_at DESC);
CREATE INDEX idx_audit_logs_external ON audit_logs (external_system, created_at DESC) WHERE external_system IS NOT NULL;

-- 파티셔닝 권장: created_at 월별 partition (대용량 운영 시)


-- =====================================================================
-- SECTION 10: BASELINE FK SUPPLEMENT (베이스라인 누락 FK 추가)
-- =====================================================================
-- 베이스라인 _baseline/07_integrated_schema.sql SECTION 8 (Cross-domain FKs)에서
-- 이미 추가된 FK는 보존. 본 섹션에서는 ⭐ 신규 도메인이 베이스라인과 맺는 추가 FK만 정의.

-- products.widget_page_id → pages.id  ← Section 3.1에서 ALTER로 추가됨
-- templates.product_id → products.id  ← Section 2.3에서 정의됨


-- =====================================================================
-- SECTION 11: SEED DATA (V1 위젯 카탈로그 14건)
-- =====================================================================
INSERT INTO widgets (code, display_name, category, icon, prop_schema, component_path, ssr_mode) VALUES
    ('section',         '섹션',           'layout',      'layout-section', '{}'::jsonb, '@/widgets/Section',       'rsc'),
    ('column',          '컬럼',           'layout',      'layout-column',  '{}'::jsonb, '@/widgets/Column',        'rsc'),
    ('text',            '텍스트',         'content',     'type',           '{}'::jsonb, '@/widgets/Text',          'rsc'),
    ('image',           '이미지',         'content',     'image',          '{}'::jsonb, '@/widgets/Image',         'rsc'),
    ('button',          '버튼',           'content',     'mouse-pointer',  '{}'::jsonb, '@/widgets/Button',        'client'),
    ('product_gallery', '상품 갤러리',     'commerce',    'grid',           '{}'::jsonb, '@/widgets/ProductGallery','hybrid'),
    ('option_panel',    '옵션 패널',       'print_quote', 'sliders',        '{}'::jsonb, '@/widgets/OptionPanel',   'client'),
    ('quote_preview',   '견적 미리보기',   'print_quote', 'receipt',        '{}'::jsonb, '@/widgets/QuotePreview',  'client'),
    ('form_field',      '폼 필드',        'form',        'form-input',     '{}'::jsonb, '@/widgets/FormField',     'client'),
    ('media_slider',    '미디어 슬라이더', 'content',     'film',           '{}'::jsonb, '@/widgets/MediaSlider',   'client'),
    ('tabs',            '탭',             'layout',      'tabs',           '{}'::jsonb, '@/widgets/Tabs',          'client'),
    ('mega_menu',       '메가 메뉴',       'layout',     'menu',           '{}'::jsonb, '@/widgets/MegaMenu',      'client'),
    ('edicus_slot',     '디자인 에디터',   'print_quote', 'pen-tool',       '{}'::jsonb, '@/widgets/EdicusSlot',    'client'),
    ('rich_card',       '리치 카드',       'content',     'card',           '{}'::jsonb, '@/widgets/RichCard',      'rsc');


-- =====================================================================
-- SECTION 12: SEED DATA (system_configs)
-- =====================================================================
INSERT INTO system_configs (config_key, config_value, description) VALUES
    ('VAT_RATE',          '0.10',        '부가가치세율 (10%)'),
    ('VAT_INCLUSIVE',     'included',    '부가세 표시 정책 (included|separate) — As-Is woocommerce_calc_taxes=yes 호환'),
    ('CURRENCY',          'KRW',         '기본 통화'),
    ('CURRENCY_DECIMALS', '0',           '소수점 자릿수 (KRW=0)'),
    ('GUEST_SESSION_TTL_HOURS', '24',    '게스트 견적 세션 만료 시간'),
    ('QUOTE_TTL_HOURS',   '24',          '견적 만료 시간'),
    ('PRICING_CACHE_TTL_SEC', '5',       '가격 산출 결과 캐시 TTL'),
    ('CATALOG_CACHE_TTL_SEC', '60',      'PricingCatalog 캐시 TTL')
ON CONFLICT (config_key) DO NOTHING;


-- =====================================================================
-- 마이그레이션 변경 영역 표 (베이스라인 → 신규)
-- =====================================================================
--
-- ⭐ 신규 테이블 (24개):
--    Builder(9):       pages, sections, columns, blocks, widgets, templates,
--                      design_tokens, page_revisions, bindings
--    Member-Order(8):  addresses, carts, cart_items, coupons, coupon_usages,
--                      loyalty_points, loyalty_transactions, shopby_member_tokens
--    Quote(2):         quote_lines, option_groups
--    Design(5):        design_projects, design_documents, editor_templates,
--                      edicus_order_mapping, shopby_order_mapping, vdp_datasets
--    Production(1):    proof_cycles
--    Audit(2):         guest_sessions, audit_logs
--
-- ⭐ 베이스라인 ALTER (5개 테이블):
--    products:  +mes_item_cd, mes_internal_id, editor_mode, ps_code,
--               shopby_product_no, widget_page_id
--    users:     +shopby_member_no, auth_provider, ci, edicus_uid
--    quotes:    +session_id, widget_state, edicus_project_id
--    orders:    +shopby_order_no, edicus_order_id, payment_provider
--    payments:  +provider_payment_key
--
-- 베이스라인 38 테이블의 컬럼·제약·인덱스는 변경 없음. 신규 컬럼은 모두 NULLABLE 또는
-- DEFAULT 보유 → 무중단 마이그레이션 가능.
--
-- 총 테이블 수: 베이스라인 38 + 신규 27 = 65 테이블
-- =====================================================================

-- END OF SCHEMA v0.1
