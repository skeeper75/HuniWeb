-- =====================================================================
-- Print Auto-Quote Service: Widget (UI) Domain Schema (PostgreSQL)
-- =====================================================================
-- Author: widget-specialist
-- Date: 2026-05-07
-- Source: _workspace/print-quote/01_research_report.md (Section 4)
-- Depends on: 02_product_schema.sql (products, product_specifications,
--             product_spec_options, set_updated_at())
--
-- Design philosophy:
--   1. Data-driven UI: every step, field, and visibility rule lives in
--      tables. Adding a new step or rule is an INSERT, not a deploy.
--   2. i18n-by-key: text content is referenced via i18n_key strings, with
--      actual translations in ui_translations. Multiple locales coexist
--      without schema changes.
--   3. Decoupled from product specs: widget_step_fields.spec_id is
--      nullable so widgets can include UX-only fields (납기 캘린더, 파일
--      업로드) that have no product_specifications counterpart.
--   4. Two layers of conditional logic:
--        - widget_steps.skip_condition  (skip an entire step)
--        - widget_conditional_rules     (per-field show/hide/require/...)
--      Keep them separate so step-level navigation and field-level UI
--      rules can be reasoned about independently.
--   5. Append-only analytics: widget_analytics has no updated_at and is
--      indexed for time-range queries. Funnel analysis is the only
--      consumer; mutations are never expected.
-- =====================================================================


-- ---------------------------------------------------------------------
-- Reuse set_updated_at() from product schema if present, else create.
-- ---------------------------------------------------------------------
-- WHY: product domain (02_product_schema.sql) defines this trigger
--      function. We guard with CREATE OR REPLACE so this file is also
--      runnable standalone (e.g., CI rebuilds widget tests in isolation).
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =====================================================================
-- 1. widget_configs  (one widget per product)
-- =====================================================================
-- WHY product_id UNIQUE:
--   - Research shows each product owns a single configurator. A/B testing
--     of UI variants is handled by versioning rows (is_active flag) and
--     swapping at deploy time, not by allowing multiple active widgets
--     per product. UNIQUE on product_id enforces this invariant in DB.
-- WHY layout_type is CHECK, not ENUM:
--   - Adding new layout shapes (wizard_modal, accordion, ...) is a CHECK
--     alter, not an ALTER TYPE migration that locks the table.
-- =====================================================================
CREATE TABLE widget_configs (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id                  UUID NOT NULL,
    name                        VARCHAR(128) NOT NULL,
    layout_type                 VARCHAR(16) NOT NULL DEFAULT 'stepped',
    preview_enabled             BOOLEAN NOT NULL DEFAULT TRUE,
    realtime_price_enabled      BOOLEAN NOT NULL DEFAULT TRUE,
    debounce_ms                 SMALLINT NOT NULL DEFAULT 300, -- research §4.3 권장 200~400ms
    description                 TEXT,
    metadata                    JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active                   BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_widget_configs_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_widget_configs_product
        UNIQUE (product_id),

    CONSTRAINT chk_widget_configs_layout_type
        CHECK (layout_type IN ('stepped', 'single_page', 'sidebar')),

    CONSTRAINT chk_widget_configs_debounce_range
        CHECK (debounce_ms BETWEEN 0 AND 2000)
);

CREATE INDEX idx_widget_configs_active ON widget_configs (is_active) WHERE is_active = TRUE;

CREATE TRIGGER trg_widget_configs_updated_at
    BEFORE UPDATE ON widget_configs
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 2. widget_steps  (ordered steps inside a widget)
-- =====================================================================
-- WHY title via i18n_key (not inline text):
--   - Research §6.4 requires multi-locale support. Inline text would
--     duplicate Korean strings across rows and force migrations to add
--     English. i18n_key + ui_translations row-per-locale is the standard.
-- WHY skip_condition as JSONB:
--   - Step skipping is rare and varies in shape (single field eq, multi
--     field AND/OR). A typed schema would over-specify; JSONB lets the
--     widget runtime evaluate the same expression DSL used elsewhere.
--     Example: {"any":[{"field":"paper_type","op":"eq","value":"transparent_pvc"}]}
-- =====================================================================
CREATE TABLE widget_steps (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    widget_id               UUID NOT NULL,
    step_number             INTEGER NOT NULL,
    title_i18n_key          VARCHAR(100) NOT NULL,
    description_i18n_key    VARCHAR(100),
    is_required             BOOLEAN NOT NULL DEFAULT TRUE,
    skip_condition          JSONB,                          -- nullable; runtime DSL
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_widget_steps_widget
        FOREIGN KEY (widget_id) REFERENCES widget_configs(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_widget_steps_step_number_positive
        CHECK (step_number > 0),

    CONSTRAINT uq_widget_steps_widget_step_number
        UNIQUE (widget_id, step_number)
);

-- WHY (widget_id, step_number): primary read pattern is "render all steps
--      for widget X in order". The unique constraint above already creates
--      a btree index, so we annotate but do not duplicate it.
-- (uq_widget_steps_widget_step_number serves the (widget_id, step_number) index)
CREATE INDEX idx_widget_steps_widget_active ON widget_steps (widget_id, is_active);

CREATE TRIGGER trg_widget_steps_updated_at
    BEFORE UPDATE ON widget_steps
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 3. widget_step_fields  (input fields inside a step)
-- =====================================================================
-- WHY spec_id is nullable:
--   - Most fields bind to a product_specifications row (사이즈, 용지, ...)
--     so the widget's option list and pricing engine share a source of
--     truth. But納期(date), 파일업로드, 메모 등 UX-only fields do not.
--     Nullable spec_id covers both cases without a polymorphic table.
-- WHY field_type CHECK:
--   - Mirrors product_specifications.input_type but adds 'file' which is
--     UI-only (file upload step). Independent CHECK so widget evolution
--     does not destabilize the product schema.
-- WHY validation_rules / display_options as JSONB:
--   - Validation shape varies per field_type (number: {min,max,step};
--     text: {pattern,maxLength}; file: {accept,maxSize}). JSONB avoids a
--     wide sparse table and keeps runtime parsing in one place.
-- =====================================================================
CREATE TABLE widget_step_fields (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    step_id             UUID NOT NULL,
    field_key           VARCHAR(100) NOT NULL,           -- machine name unique within widget
    field_type          VARCHAR(16) NOT NULL,
    spec_id             UUID,                            -- FK → product_specifications, optional
    label_i18n_key      VARCHAR(100) NOT NULL,
    placeholder_i18n_key VARCHAR(100),
    help_i18n_key       VARCHAR(100),
    validation_rules    JSONB NOT NULL DEFAULT '{}'::jsonb,
    display_options     JSONB NOT NULL DEFAULT '{}'::jsonb,
    sort_order          INTEGER NOT NULL DEFAULT 0,
    is_required         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_widget_step_fields_step
        FOREIGN KEY (step_id) REFERENCES widget_steps(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_widget_step_fields_spec
        FOREIGN KEY (spec_id) REFERENCES product_specifications(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_widget_step_fields_field_type
        CHECK (field_type IN ('select', 'radio', 'number', 'slider', 'date', 'text', 'file')),

    CONSTRAINT uq_widget_step_fields_step_field_key
        UNIQUE (step_id, field_key)
);

CREATE INDEX idx_widget_step_fields_step_sort   ON widget_step_fields (step_id, sort_order);
CREATE INDEX idx_widget_step_fields_spec        ON widget_step_fields (spec_id) WHERE spec_id IS NOT NULL;

CREATE TRIGGER trg_widget_step_fields_updated_at
    BEFORE UPDATE ON widget_step_fields
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 4. widget_conditional_rules  (per-field UI rules)
-- =====================================================================
-- WHY field_key strings instead of UUID FKs:
--   - Rules reference fields by stable machine names (e.g., "paper_type")
--     so administrators can author rules in JSON before the targeted
--     fields exist (or reorder fields without breaking refs). Trade-off:
--     no FK integrity — runtime must validate keys. Acceptable because
--     rule authoring tooling validates against widget_step_fields at save.
-- WHY action_type CHECK:
--   - Six actions cover everything in research §4.4 ('show','hide',
--     'enable','disable','set_value','require'). Add new actions via
--     CHECK alter when a new UX pattern emerges.
-- WHY priority INT (lower = first):
--   - When two rules contradict (e.g., one shows, one hides), priority
--     resolves the conflict. Lower priority evaluates last so it "wins".
-- =====================================================================
CREATE TABLE widget_conditional_rules (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    widget_id               UUID NOT NULL,
    name                    VARCHAR(128),                       -- human label for admins
    condition_field_key     VARCHAR(100) NOT NULL,
    condition_operator      VARCHAR(8)  NOT NULL,
    condition_value         JSONB NOT NULL,                     -- scalar or array (for 'in')
    action_type             VARCHAR(16) NOT NULL,
    target_field_key        VARCHAR(100) NOT NULL,
    action_payload          JSONB,                              -- nullable: e.g., {"value": "..."} for set_value, {"message":"..."} for disable
    priority                INTEGER NOT NULL DEFAULT 100,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_widget_conditional_rules_widget
        FOREIGN KEY (widget_id) REFERENCES widget_configs(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_widget_conditional_rules_operator
        CHECK (condition_operator IN ('eq', 'neq', 'in', 'gte', 'lte')),

    CONSTRAINT chk_widget_conditional_rules_action
        CHECK (action_type IN ('show', 'hide', 'enable', 'disable', 'set_value', 'require'))
);

CREATE INDEX idx_widget_conditional_rules_widget_active
    ON widget_conditional_rules (widget_id, is_active);
CREATE INDEX idx_widget_conditional_rules_widget_priority
    ON widget_conditional_rules (widget_id, priority);
CREATE INDEX idx_widget_conditional_rules_condition_field
    ON widget_conditional_rules (widget_id, condition_field_key);

CREATE TRIGGER trg_widget_conditional_rules_updated_at
    BEFORE UPDATE ON widget_conditional_rules
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 5. preview_templates  (live preview templates per product)
-- =====================================================================
-- WHY template_data is JSONB (not template-engine-specific blob):
--   - svg/canvas/image renderers need different layout payloads (svg:
--     layer list with positions; canvas: command list; image: mockup
--     map). One JSONB column avoids three union tables and a discriminator
--     column tells consumers which schema to expect.
-- WHY product_id is FK (not UNIQUE):
--   - A product can have multiple preview templates (e.g., catalog mock
--     + spec mock + 3D, per research §4.5). Active selection is by
--     is_active + sort_order at runtime.
-- =====================================================================
CREATE TABLE preview_templates (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      UUID NOT NULL,
    name            VARCHAR(128) NOT NULL,
    template_type   VARCHAR(16) NOT NULL,
    template_data   JSONB NOT NULL DEFAULT '{}'::jsonb,
    thumbnail_url   TEXT,
    sort_order      INTEGER NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_preview_templates_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_preview_templates_template_type
        CHECK (template_type IN ('svg', 'canvas', 'image'))
);

CREATE INDEX idx_preview_templates_product_active
    ON preview_templates (product_id, is_active);

CREATE TRIGGER trg_preview_templates_updated_at
    BEFORE UPDATE ON preview_templates
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 6. ui_translations  (i18n value store)
-- =====================================================================
-- WHY (i18n_key, locale) UNIQUE:
--   - Same key resolves once per locale. Composite UNIQUE doubles as the
--     hot lookup index for "give me the value of key X in locale Y".
-- WHY no FK to keys:
--   - Keys are referenced from many places (widget_steps, widget_step_fields,
--     and future product/email templates). A central key registry would
--     introduce write-amplification on every field update. We accept
--     orphan-key risk and let admin tooling lint references.
-- =====================================================================
CREATE TABLE ui_translations (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    i18n_key    VARCHAR(200) NOT NULL,
    locale      VARCHAR(10) NOT NULL,    -- e.g., 'ko','en','ja','zh-CN'
    value       TEXT NOT NULL,
    context     TEXT,                    -- translator notes
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_ui_translations_key_locale
        UNIQUE (i18n_key, locale)
);

-- WHY explicit (i18n_key, locale) index even though UNIQUE creates one:
--   - Spec asks for it; this is a documented lookup path. Keeping the
--     same expression as the index name makes intent obvious in EXPLAIN.
CREATE INDEX idx_ui_translations_key_locale ON ui_translations (i18n_key, locale);

CREATE TRIGGER trg_ui_translations_updated_at
    BEFORE UPDATE ON ui_translations
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 7. widget_analytics  (append-only event log)
-- =====================================================================
-- WHY no updated_at:
--   - Events are immutable facts. An updated_at column invites buggy
--     mutations. Funnel analysis (view → interact → complete/abandon)
--     reads (widget_id, occurred_at) ranges and groups by event_type.
-- WHY step_id and field_key both nullable:
--   - 'view' events fire at widget level (no step yet); 'complete'/
--     'abandon' fire at widget level too. 'interact' carries both.
-- WHY field_value as TEXT (not JSONB):
--   - Most analytics consumers compare cardinalities of selected values
--     ("코팅: 무광 70%, 유광 20%, 없음 10%"). Plain text is faster to
--     aggregate and avoids JSON casting in dashboards.
-- =====================================================================
CREATE TABLE widget_analytics (
    id              BIGSERIAL PRIMARY KEY,
    session_id      UUID NOT NULL,
    widget_id       UUID NOT NULL,
    step_id         UUID,
    event_type      VARCHAR(16) NOT NULL,
    field_key       VARCHAR(100),
    field_value     TEXT,
    metadata        JSONB,                          -- e.g., {"price": 18000}, {"reason":"timeout"}
    occurred_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_widget_analytics_widget
        FOREIGN KEY (widget_id) REFERENCES widget_configs(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_widget_analytics_step
        FOREIGN KEY (step_id) REFERENCES widget_steps(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_widget_analytics_event_type
        CHECK (event_type IN ('view', 'interact', 'complete', 'abandon'))
);

-- WHY (widget_id, occurred_at): primary funnel query is a time range per
--      widget. BRIN would also work for huge tables; we use btree because
--      analytics dashboards also need recent-N row scans.
CREATE INDEX idx_widget_analytics_widget_occurred ON widget_analytics (widget_id, occurred_at DESC);
CREATE INDEX idx_widget_analytics_session         ON widget_analytics (session_id);
CREATE INDEX idx_widget_analytics_widget_event    ON widget_analytics (widget_id, event_type, occurred_at DESC);


-- =====================================================================
-- SEED DATA: 일반명함 위젯 (5단계)
-- =====================================================================
-- Constructs a complete widget over the 일반명함 product seeded by
-- 02_product_schema.sql. Steps: 사이즈 → 용지 → 코팅 → 수량 → 납기.
-- Includes one conditional rule (투명PVC → coating step hide).
-- All translations are inserted in Korean and English for every step
-- title and key UI string.
-- =====================================================================
DO $$
DECLARE
    v_product_id    UUID;
    v_spec_size     UUID;
    v_spec_paper    UUID;
    v_spec_coating  UUID;
    v_spec_qty      UUID;

    v_widget_id     UUID := gen_random_uuid();
    v_step_size     UUID := gen_random_uuid();
    v_step_paper    UUID := gen_random_uuid();
    v_step_coating  UUID := gen_random_uuid();
    v_step_qty      UUID := gen_random_uuid();
    v_step_due      UUID := gen_random_uuid();
BEGIN
    -- Resolve product + spec ids by code/name
    SELECT id INTO v_product_id FROM products WHERE code = 'CARD_GENERAL_STD';

    IF v_product_id IS NULL THEN
        RAISE NOTICE 'Skipping widget seed: product CARD_GENERAL_STD not found (run 02_product_schema.sql first).';
        RETURN;
    END IF;

    SELECT id INTO v_spec_size    FROM product_specifications WHERE product_id = v_product_id AND name = 'size';
    SELECT id INTO v_spec_paper   FROM product_specifications WHERE product_id = v_product_id AND name = 'paper';
    SELECT id INTO v_spec_coating FROM product_specifications WHERE product_id = v_product_id AND name = 'coating';
    SELECT id INTO v_spec_qty     FROM product_specifications WHERE product_id = v_product_id AND name = 'quantity';

    -- Widget config (single row per product enforced by UNIQUE)
    INSERT INTO widget_configs (id, product_id, name, layout_type,
                                preview_enabled, realtime_price_enabled, debounce_ms)
    VALUES (v_widget_id, v_product_id, '일반명함 견적 위젯', 'sidebar',
            TRUE, TRUE, 300);

    -- Steps (1..5)
    INSERT INTO widget_steps (id, widget_id, step_number, title_i18n_key, description_i18n_key, is_required) VALUES
        (v_step_size,    v_widget_id, 1, 'widget.card.step.size.title',    'widget.card.step.size.desc',    TRUE),
        (v_step_paper,   v_widget_id, 2, 'widget.card.step.paper.title',   'widget.card.step.paper.desc',   TRUE),
        (v_step_coating, v_widget_id, 3, 'widget.card.step.coating.title', 'widget.card.step.coating.desc', TRUE),
        (v_step_qty,     v_widget_id, 4, 'widget.card.step.qty.title',     'widget.card.step.qty.desc',     TRUE),
        (v_step_due,     v_widget_id, 5, 'widget.card.step.due.title',     'widget.card.step.due.desc',     TRUE);

    -- Step 1: 사이즈 (radio, links to size spec)
    INSERT INTO widget_step_fields (step_id, field_key, field_type, spec_id,
                                    label_i18n_key, validation_rules, display_options, sort_order, is_required)
    VALUES (v_step_size, 'size', 'radio', v_spec_size,
            'widget.card.field.size.label',
            jsonb_build_object('required', true),
            jsonb_build_object('layout', 'card', 'columns', 2, 'showImage', true),
            10, TRUE);

    -- Step 2: 용지 (select, links to paper spec)
    INSERT INTO widget_step_fields (step_id, field_key, field_type, spec_id,
                                    label_i18n_key, validation_rules, display_options, sort_order, is_required)
    VALUES (v_step_paper, 'paper', 'select', v_spec_paper,
            'widget.card.field.paper.label',
            jsonb_build_object('required', true),
            jsonb_build_object('showImage', true, 'showWeight', true),
            10, TRUE);

    -- Step 3: 코팅 (radio, links to coating spec)
    INSERT INTO widget_step_fields (step_id, field_key, field_type, spec_id,
                                    label_i18n_key, validation_rules, display_options, sort_order, is_required)
    VALUES (v_step_coating, 'coating', 'radio', v_spec_coating,
            'widget.card.field.coating.label',
            jsonb_build_object('required', true),
            jsonb_build_object('layout', 'inline'),
            10, TRUE);

    -- Step 4: 수량 (slider, links to quantity spec, display per-unit price)
    INSERT INTO widget_step_fields (step_id, field_key, field_type, spec_id,
                                    label_i18n_key, validation_rules, display_options, sort_order, is_required)
    VALUES (v_step_qty, 'quantity', 'slider', v_spec_qty,
            'widget.card.field.qty.label',
            jsonb_build_object('required', true, 'min', 100, 'max', 20000, 'step', 100),
            jsonb_build_object('showPerUnitPrice', true, 'showTooltip', true,
                               'breakpoints', jsonb_build_array(100, 200, 500, 1000, 2000, 5000, 10000)),
            10, TRUE);

    -- Step 5: 납기 (date with predefined options; UX-only field, spec_id NULL)
    INSERT INTO widget_step_fields (step_id, field_key, field_type, spec_id,
                                    label_i18n_key, validation_rules, display_options, sort_order, is_required)
    VALUES (v_step_due, 'due_date', 'date', NULL,
            'widget.card.field.due.label',
            jsonb_build_object('required', true),
            jsonb_build_object(
                'mode', 'preset',
                'options', jsonb_build_array(
                    jsonb_build_object('key', 'D1', 'label_i18n_key', 'widget.card.due.d1', 'surcharge_pct', 20),
                    jsonb_build_object('key', 'D2', 'label_i18n_key', 'widget.card.due.d2', 'surcharge_pct', 10),
                    jsonb_build_object('key', 'D3', 'label_i18n_key', 'widget.card.due.d3', 'surcharge_pct', 0)
                ),
                'showPriceDelta', true
            ),
            10, TRUE);

    -- Conditional rule: paper == 'transparent_pvc' → hide coating step's field
    -- WHY hide instead of disable: research §4.4 says "투명명함은 PET 자체 표면"
    --     so the coating step is meaningless. Hiding the field collapses the
    --     entire step (widget runtime: empty step → auto-skip).
    INSERT INTO widget_conditional_rules (widget_id, name,
                                          condition_field_key, condition_operator, condition_value,
                                          action_type, target_field_key, action_payload, priority)
    VALUES (v_widget_id,
            '투명PVC 용지 선택시 코팅 단계 숨김',
            'paper', 'eq', '"transparent_pvc"'::jsonb,
            'hide', 'coating',
            jsonb_build_object('reason_i18n_key', 'widget.card.rule.pvc_no_coating'),
            10);

    -- Translations (Korean + English) for all step titles + key labels + rule reason
    INSERT INTO ui_translations (i18n_key, locale, value) VALUES
        -- Step titles (Korean)
        ('widget.card.step.size.title',    'ko', '사이즈 선택'),
        ('widget.card.step.paper.title',   'ko', '용지 선택'),
        ('widget.card.step.coating.title', 'ko', '코팅 선택'),
        ('widget.card.step.qty.title',     'ko', '수량 선택'),
        ('widget.card.step.due.title',     'ko', '납기 선택'),
        -- Step descriptions (Korean)
        ('widget.card.step.size.desc',     'ko', '명함 사이즈를 선택해주세요'),
        ('widget.card.step.paper.desc',    'ko', '인쇄에 사용할 용지를 선택해주세요'),
        ('widget.card.step.coating.desc',  'ko', '표면 코팅 방식을 선택해주세요'),
        ('widget.card.step.qty.desc',      'ko', '주문 수량을 선택해주세요'),
        ('widget.card.step.due.desc',      'ko', '희망 납기일을 선택해주세요'),
        -- Field labels (Korean)
        ('widget.card.field.size.label',    'ko', '사이즈'),
        ('widget.card.field.paper.label',   'ko', '용지'),
        ('widget.card.field.coating.label', 'ko', '코팅'),
        ('widget.card.field.qty.label',     'ko', '수량'),
        ('widget.card.field.due.label',     'ko', '납기'),
        -- Due options (Korean)
        ('widget.card.due.d1', 'ko', '익일 출고 (할증 +20%)'),
        ('widget.card.due.d2', 'ko', 'D+2 출고 (할증 +10%)'),
        ('widget.card.due.d3', 'ko', 'D+3 일반 (할증 없음)'),
        -- Rule reason (Korean)
        ('widget.card.rule.pvc_no_coating', 'ko', '투명 PVC 용지는 별도 코팅이 적용되지 않습니다'),

        -- Step titles (English)
        ('widget.card.step.size.title',    'en', 'Choose Size'),
        ('widget.card.step.paper.title',   'en', 'Choose Paper'),
        ('widget.card.step.coating.title', 'en', 'Choose Coating'),
        ('widget.card.step.qty.title',     'en', 'Choose Quantity'),
        ('widget.card.step.due.title',     'en', 'Choose Due Date'),
        -- Step descriptions (English)
        ('widget.card.step.size.desc',     'en', 'Pick a business card size'),
        ('widget.card.step.paper.desc',    'en', 'Pick the paper to print on'),
        ('widget.card.step.coating.desc',  'en', 'Pick a surface coating finish'),
        ('widget.card.step.qty.desc',      'en', 'Pick the order quantity'),
        ('widget.card.step.due.desc',      'en', 'Pick your preferred delivery date'),
        -- Field labels (English)
        ('widget.card.field.size.label',    'en', 'Size'),
        ('widget.card.field.paper.label',   'en', 'Paper'),
        ('widget.card.field.coating.label', 'en', 'Coating'),
        ('widget.card.field.qty.label',     'en', 'Quantity'),
        ('widget.card.field.due.label',     'en', 'Due Date'),
        -- Due options (English)
        ('widget.card.due.d1', 'en', 'Next-day (+20% rush)'),
        ('widget.card.due.d2', 'en', 'D+2 (+10% rush)'),
        ('widget.card.due.d3', 'en', 'D+3 standard (no surcharge)'),
        -- Rule reason (English)
        ('widget.card.rule.pvc_no_coating', 'en', 'Transparent PVC stock cannot accept additional coating');
END $$;

-- =====================================================================
-- End of widget domain schema
-- =====================================================================
