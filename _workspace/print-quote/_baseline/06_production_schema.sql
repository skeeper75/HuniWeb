-- =====================================================================
-- Print Auto-Quote Service: Production Domain Schema (PostgreSQL)
-- =====================================================================
-- Author: production-specialist
-- Date: 2026-05-07
-- Source: _workspace/print-quote/01_research_report.md (Section 5)
-- Depends on: 02_product_schema.sql  (products)
--             04_order_schema.sql    (users, orders, order_items)
--
-- Design philosophy:
--   1. Order ↔ ProductionJob is N:M (research §5.3 gang printing).
--      Multiple order_items sharing (paper × coating × method × due) are
--      grouped onto one production_jobs row to amortize plate/setup cost.
--      The junction is production_job_items; order_item_id is UNIQUE in
--      the junction so a single line item cannot be double-printed across
--      two jobs.
--   2. Stage status is a separate table, not a column.
--      Six stages (PREPRESS → SHIPPING) each progress independently and
--      need their own timestamps + operator. Modeling them as rows in
--      job_stage_status keeps the schema flexible (skip stages, parallel
--      stages later) without ALTERing production_jobs.
--   3. business_calendar is the source of truth for 영업일.
--      Korean holidays + custom company off-days vary year by year. A
--      calendar table beats hard-coded weekday math; business_days_from_now()
--      consults it directly so callers never reinvent the rule.
-- =====================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =====================================================================
-- 1. production_stage_types  (6단계 마스터)
-- =====================================================================
-- WHY immutable reference data: the 6-stage pipeline is the contract
-- between operations dashboards, ERP, and customer-facing trackers.
-- Stages are inserted once via seed data and only `is_active` flips.
CREATE TABLE production_stage_types (
    id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code                     VARCHAR(20) NOT NULL UNIQUE,
    name                     VARCHAR(50) NOT NULL,
    expected_duration_hours  NUMERIC(4,1),
    sort_order               INT NOT NULL,
    is_skippable             BOOLEAN NOT NULL DEFAULT FALSE,
    created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active                BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_stage_types_code CHECK (
        code IN ('PREPRESS','PRINTING','FINISHING','CUTTING','PACKAGING','SHIPPING')
    )
);

CREATE INDEX idx_stage_types_sort ON production_stage_types (sort_order) WHERE is_active = TRUE;


-- =====================================================================
-- 2. equipment_configs  (인쇄/후가공 설비)
-- =====================================================================
CREATE TABLE equipment_configs (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name             VARCHAR(100) NOT NULL,
    equipment_type   VARCHAR(20) NOT NULL,
    max_width_mm     INT,
    max_height_mm    INT,
    max_color_count  INT NOT NULL DEFAULT 4,
    status           VARCHAR(16) NOT NULL DEFAULT 'active',
    notes            TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active        BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_equipment_type CHECK (
        equipment_type IN ('offset','digital','wide_format','finishing')
    ),
    CONSTRAINT chk_equipment_status CHECK (
        status IN ('active','maintenance','offline')
    )
);

CREATE INDEX idx_equipment_status ON equipment_configs (status) WHERE is_active = TRUE;

CREATE TRIGGER trg_equipment_updated_at
    BEFORE UPDATE ON equipment_configs
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 3. production_jobs  (배치 작업 단위)
-- =====================================================================
-- WHY job_number not order_number: a job can hold N orders (gang run),
-- so it needs its own human-readable identifier (PJ-YYYYMMDD-NNN) for
-- shop-floor tracking independent of customer-facing order numbers.
CREATE TABLE production_jobs (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_number        VARCHAR(20) NOT NULL UNIQUE,
    print_method      VARCHAR(20) NOT NULL,
    equipment_id      UUID,
    operator_id       UUID,
    planned_start_at  TIMESTAMPTZ,
    planned_end_at    TIMESTAMPTZ,
    actual_start_at   TIMESTAMPTZ,
    actual_end_at     TIMESTAMPTZ,
    status            VARCHAR(20) NOT NULL DEFAULT 'queued',
    batch_notes       TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_jobs_equipment
        FOREIGN KEY (equipment_id) REFERENCES equipment_configs(id) ON DELETE SET NULL,
    CONSTRAINT fk_jobs_operator
        FOREIGN KEY (operator_id) REFERENCES users(id) ON DELETE SET NULL,

    CONSTRAINT chk_jobs_print_method CHECK (
        print_method IN ('offset','digital','wide_format')
    ),
    CONSTRAINT chk_jobs_status CHECK (
        status IN ('queued','in_progress','on_hold','completed','cancelled')
    ),
    CONSTRAINT chk_jobs_planned_window CHECK (
        planned_end_at IS NULL OR planned_start_at IS NULL
        OR planned_end_at >= planned_start_at
    )
);

CREATE INDEX idx_jobs_status_planned ON production_jobs (status, planned_start_at);
CREATE INDEX idx_jobs_equipment      ON production_jobs (equipment_id) WHERE equipment_id IS NOT NULL;

CREATE TRIGGER trg_jobs_updated_at
    BEFORE UPDATE ON production_jobs
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 4. production_job_items  (N:M junction — gang printing)
-- =====================================================================
-- WHY order_item_id UNIQUE: an order_item must belong to exactly one
-- job. Two jobs printing the same line item would double-bill production
-- cost and confuse QC. The compound UNIQUE(job_id, order_item_id) is a
-- safety net; the standalone UNIQUE on order_item_id is the real rule.
CREATE TABLE production_job_items (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id             UUID NOT NULL,
    order_item_id      UUID NOT NULL UNIQUE,
    quantity           INT NOT NULL,
    position_in_batch  INT,
    added_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_job_items_job
        FOREIGN KEY (job_id) REFERENCES production_jobs(id) ON DELETE CASCADE,
    CONSTRAINT fk_job_items_order_item
        FOREIGN KEY (order_item_id) REFERENCES order_items(id) ON DELETE RESTRICT,

    CONSTRAINT uq_job_items_job_oi UNIQUE (job_id, order_item_id),
    CONSTRAINT chk_job_items_qty CHECK (quantity > 0)
);

CREATE INDEX idx_job_items_job ON production_job_items (job_id);


-- =====================================================================
-- 5. job_stage_status  (단계별 진행)
-- =====================================================================
CREATE TABLE job_stage_status (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id         UUID NOT NULL,
    stage_type_id  UUID NOT NULL,
    status         VARCHAR(16) NOT NULL DEFAULT 'pending',
    started_at     TIMESTAMPTZ,
    completed_at   TIMESTAMPTZ,
    operator_id    UUID,
    notes          TEXT,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_stage_status_job
        FOREIGN KEY (job_id) REFERENCES production_jobs(id) ON DELETE CASCADE,
    CONSTRAINT fk_stage_status_stage
        FOREIGN KEY (stage_type_id) REFERENCES production_stage_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_stage_status_operator
        FOREIGN KEY (operator_id) REFERENCES users(id) ON DELETE SET NULL,

    CONSTRAINT uq_stage_status_job_stage UNIQUE (job_id, stage_type_id),
    CONSTRAINT chk_stage_status CHECK (
        status IN ('pending','in_progress','completed','skipped','failed')
    ),
    CONSTRAINT chk_stage_status_window CHECK (
        completed_at IS NULL OR started_at IS NULL OR completed_at >= started_at
    )
);

CREATE INDEX idx_stage_status_job_status ON job_stage_status (job_id, status);


-- =====================================================================
-- 6. print_materials  (자재 재고)
-- =====================================================================
CREATE TABLE print_materials (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    material_type    VARCHAR(20) NOT NULL,
    name             VARCHAR(200) NOT NULL,
    sku              VARCHAR(100) NOT NULL UNIQUE,
    unit             VARCHAR(10) NOT NULL,
    current_stock    NUMERIC(10,2) NOT NULL DEFAULT 0,
    min_stock_alert  NUMERIC(10,2) NOT NULL DEFAULT 0,
    unit_cost        NUMERIC(10,2),
    supplier         VARCHAR(200),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active        BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_material_type CHECK (
        material_type IN ('paper','ink','coating_film','laminate','other')
    ),
    CONSTRAINT chk_material_unit CHECK (
        unit IN ('sheet','kg','ml','roll','piece')
    ),
    CONSTRAINT chk_material_stock CHECK (current_stock >= 0 AND min_stock_alert >= 0)
);

-- Partial index for low-stock alert dashboard (research §5.5).
CREATE INDEX idx_materials_low_stock ON print_materials (material_type)
    WHERE is_active = TRUE AND current_stock <= min_stock_alert;

CREATE TRIGGER trg_materials_updated_at
    BEFORE UPDATE ON print_materials
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 7. material_usage_log  (자재 사용 이력)
-- =====================================================================
CREATE TABLE material_usage_log (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id          UUID NOT NULL,
    material_id     UUID NOT NULL,
    quantity_used   NUMERIC(10,2) NOT NULL,
    used_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    operator_id     UUID,
    notes           TEXT,

    CONSTRAINT fk_usage_job
        FOREIGN KEY (job_id) REFERENCES production_jobs(id) ON DELETE CASCADE,
    CONSTRAINT fk_usage_material
        FOREIGN KEY (material_id) REFERENCES print_materials(id) ON DELETE RESTRICT,
    CONSTRAINT fk_usage_operator
        FOREIGN KEY (operator_id) REFERENCES users(id) ON DELETE SET NULL,

    CONSTRAINT chk_usage_qty CHECK (quantity_used > 0)
);

CREATE INDEX idx_usage_job      ON material_usage_log (job_id);
CREATE INDEX idx_usage_material ON material_usage_log (material_id, used_at DESC);


-- =====================================================================
-- 8. business_calendar  (영업일/공휴일 — 납기 계산의 단일 진실)
-- =====================================================================
CREATE TABLE business_calendar (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    date              DATE NOT NULL UNIQUE,
    is_business_day   BOOLEAN NOT NULL,
    calendar_type     VARCHAR(16) NOT NULL DEFAULT 'normal',
    note              VARCHAR(200),

    CONSTRAINT chk_calendar_type CHECK (
        calendar_type IN ('normal','holiday','half_day')
    )
);

CREATE INDEX idx_calendar_date ON business_calendar (date);


-- =====================================================================
-- 9. production_specs  (제품별 기술 사양 — 파일 검수 기준)
-- =====================================================================
-- WHY product_id UNIQUE: each product has exactly one prepress spec
-- (bleed, DPI, color profile). Joining 1:1 keeps the products table
-- free of production-only attributes.
CREATE TABLE production_specs (
    id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id           UUID NOT NULL UNIQUE,
    bleed_mm             NUMERIC(4,1) NOT NULL DEFAULT 3.0,
    safe_zone_mm         NUMERIC(4,1) NOT NULL DEFAULT 3.0,
    min_resolution_dpi   INT NOT NULL DEFAULT 300,
    color_profile        VARCHAR(100),
    accepted_formats     TEXT[],
    min_production_days  INT NOT NULL DEFAULT 1,
    max_file_size_mb     INT NOT NULL DEFAULT 100,
    notes                TEXT,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_specs_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT chk_specs_positive CHECK (
        bleed_mm >= 0 AND safe_zone_mm >= 0
        AND min_resolution_dpi > 0 AND min_production_days >= 0
        AND max_file_size_mb > 0
    )
);

CREATE TRIGGER trg_specs_updated_at
    BEFORE UPDATE ON production_specs
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 10. qc_checkpoints  (단계별 품질 검사 기록)
-- =====================================================================
CREATE TABLE qc_checkpoints (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id         UUID NOT NULL,
    stage_type_id  UUID NOT NULL,
    inspector_id   UUID,
    inspected_at   TIMESTAMPTZ,
    result         VARCHAR(20) NOT NULL,
    defect_type    VARCHAR(100),
    defect_count   INT NOT NULL DEFAULT 0,
    action_taken   TEXT,
    notes          TEXT,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_qc_job
        FOREIGN KEY (job_id) REFERENCES production_jobs(id) ON DELETE CASCADE,
    CONSTRAINT fk_qc_stage
        FOREIGN KEY (stage_type_id) REFERENCES production_stage_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_qc_inspector
        FOREIGN KEY (inspector_id) REFERENCES users(id) ON DELETE SET NULL,

    CONSTRAINT chk_qc_result CHECK (
        result IN ('pass','fail','conditional_pass')
    ),
    CONSTRAINT chk_qc_defect_count CHECK (defect_count >= 0)
);

CREATE INDEX idx_qc_job   ON qc_checkpoints (job_id, inspected_at DESC);
CREATE INDEX idx_qc_stage ON qc_checkpoints (stage_type_id, result);


-- =====================================================================
-- Function: business_days_from_now(n)
-- =====================================================================
-- Returns the date that is `n` business days after CURRENT_DATE,
-- consulting business_calendar. Day 0 = today (if business day).
-- Raises if calendar coverage is insufficient — failing loud beats
-- silently returning a non-business-day.
CREATE OR REPLACE FUNCTION business_days_from_now(n INT)
RETURNS DATE AS $$
DECLARE
    v_result DATE;
BEGIN
    IF n < 0 THEN
        RAISE EXCEPTION 'n must be >= 0';
    END IF;

    SELECT date INTO v_result
    FROM (
        SELECT date,
               ROW_NUMBER() OVER (ORDER BY date) - 1 AS day_offset
        FROM business_calendar
        WHERE date >= CURRENT_DATE
          AND is_business_day = TRUE
    ) bd
    WHERE day_offset = n;

    IF v_result IS NULL THEN
        RAISE EXCEPTION 'business_calendar lacks coverage for % business days from %', n, CURRENT_DATE;
    END IF;

    RETURN v_result;
END;
$$ LANGUAGE plpgsql STABLE;


-- =====================================================================
-- SEED DATA
-- =====================================================================

-- 1) 6 production stage types
INSERT INTO production_stage_types (code, name, expected_duration_hours, sort_order, is_skippable) VALUES
    ('PREPRESS',  '프리프레스',  2.0, 1, FALSE),
    ('PRINTING',  '인쇄',        4.0, 2, FALSE),
    ('FINISHING', '후가공',      3.0, 3, TRUE),
    ('CUTTING',   '재단',        1.5, 4, FALSE),
    ('PACKAGING', '패키징',      1.0, 5, FALSE),
    ('SHIPPING',  '출고',        0.5, 6, FALSE);

-- 2) 2 equipment examples
INSERT INTO equipment_configs (name, equipment_type, max_width_mm, max_height_mm, max_color_count, status, notes) VALUES
    ('하이델베르크 옵셋 인쇄기 #1', 'offset',  720, 1020, 5, 'active', '4도+별색 1도 지원, gang run 주력기'),
    ('Xerox iGen 디지털 인쇄기',    'digital', 364,  660, 4, 'active', '소량/단납기 전용');

-- 3) business_calendar — 2026-05-07 ~ 2026-06-30 representative sample.
--    어린이날(5/5) is past today, but 현충일(6/6 = 토요일 → 그래도 holiday flag), 지방선거일(6/3) 등 포함.
INSERT INTO business_calendar (date, is_business_day, calendar_type, note) VALUES
    ('2026-05-07', TRUE,  'normal',  '목'),
    ('2026-05-08', TRUE,  'normal',  '금 (어버이날)'),
    ('2026-05-09', FALSE, 'normal',  '토'),
    ('2026-05-10', FALSE, 'normal',  '일'),
    ('2026-05-11', TRUE,  'normal',  '월'),
    ('2026-05-15', TRUE,  'normal',  '금 (스승의날)'),
    ('2026-05-16', FALSE, 'normal',  '토'),
    ('2026-05-17', FALSE, 'normal',  '일'),
    ('2026-05-22', TRUE,  'normal',  '금'),
    ('2026-05-25', TRUE,  'normal',  '월 (부처님오신날 대체 안함)'),
    ('2026-06-03', FALSE, 'holiday', '제8회 전국동시지방선거'),
    ('2026-06-04', TRUE,  'normal',  '목'),
    ('2026-06-05', TRUE,  'normal',  '금'),
    ('2026-06-06', FALSE, 'holiday', '현충일'),
    ('2026-06-07', FALSE, 'normal',  '일'),
    ('2026-06-08', TRUE,  'normal',  '월'),
    ('2026-06-15', TRUE,  'normal',  '월'),
    ('2026-06-22', TRUE,  'normal',  '월'),
    ('2026-06-29', TRUE,  'normal',  '월'),
    ('2026-06-30', TRUE,  'normal',  '화');

-- 4) production_specs for 일반명함
DO $$
DECLARE
    v_product_id UUID;
BEGIN
    SELECT id INTO v_product_id FROM products WHERE code = 'CARD_GENERAL_STD';

    IF v_product_id IS NULL THEN
        RAISE NOTICE 'Skipping production_specs seed — product CARD_GENERAL_STD not found.';
        RETURN;
    END IF;

    INSERT INTO production_specs (
        product_id, bleed_mm, safe_zone_mm, min_resolution_dpi,
        color_profile, accepted_formats, min_production_days,
        max_file_size_mb, notes
    ) VALUES (
        v_product_id, 3.0, 3.0, 300,
        'ISO Coated v2 (ECI)',
        ARRAY['.pdf','.ai','.psd'],
        1,
        200,
        '명함 90×50 / 양면 4도 / CMYK / 폰트 아웃라인 변환 필수'
    );
END $$;

-- =====================================================================
-- End of production domain schema
-- =====================================================================
