-- =====================================================================
-- Print Auto-Quote Service: INTEGRATED SCHEMA (PostgreSQL)
-- =====================================================================
-- Author: schema-integrator
-- Date: 2026-05-07
-- Source: 02_product / 03_pricing / 04_order / 05_widget / 06_production
--
-- This is a single-file migration that consolidates all 5 domain schemas.
-- Deduplicated:
--   - pgcrypto extension (declared once)
--   - set_updated_at() trigger function (declared once)
--   - users table (single canonical definition)
--   - system_configs table (moved to common section)
--
-- Fixed:
--   - product_spec_options.extra_cost_modifier: NUMERIC(4,4) -> NUMERIC(6,4)
--     Reason: NUMERIC(4,4) max value is 0.9999, cannot store 1.0000 default
--             or any modifier > 1 (e.g. 1.1500 = +15% surcharge).
--
-- Cross-domain FKs concentrated in SECTION 8.
-- All performance indexes grouped in SECTION 9 (in addition to those
-- inlined per table for clarity).
-- =====================================================================


-- =====================================================================
-- SECTION 0: EXTENSIONS
-- =====================================================================
CREATE EXTENSION IF NOT EXISTS "pgcrypto";  -- gen_random_uuid()


-- =====================================================================
-- SECTION 1: SHARED TRIGGER FUNCTION
-- =====================================================================
-- WHY single source: avoids drift between domains. All updated_at
-- triggers below reuse this function.
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =====================================================================
-- SECTION 2: COMMON TABLES
-- =====================================================================
-- Tables referenced across multiple domains:
--   - users         (orders, payments, artwork_files, production_jobs,
--                    job_stage_status, qc_checkpoints, material_usage_log)
--   - system_configs (pricing engine VAT_RATE / CURRENCY)
-- =====================================================================

-- ---------------------------------------------------------------------
-- 2.1 users (consolidated from 04_order_schema.sql + 06_production_schema.sql)
-- ---------------------------------------------------------------------
-- WHY single table for customer/operator/admin/guest:
--   - Order, payment, file, production, and QC FKs all reference users.id.
--   - Role polymorphism stays in the application layer.
--   - Guests carry guest_token; authenticated users carry email.
CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email           VARCHAR(255) UNIQUE,                     -- nullable for guests
    name            VARCHAR(100),
    phone           VARCHAR(20),
    role            VARCHAR(16) NOT NULL DEFAULT 'customer',
    customer_grade  VARCHAR(16) NOT NULL DEFAULT 'normal',
    guest_token     VARCHAR(100) UNIQUE,                     -- nullable for members
    last_login_at   TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,                             -- soft delete (5-year legal retention)

    CONSTRAINT chk_users_role
        CHECK (role IN ('customer', 'operator', 'admin')),
    CONSTRAINT chk_users_customer_grade
        CHECK (customer_grade IN ('normal', 'silver', 'gold', 'vip')),
    CONSTRAINT chk_users_identity_present
        CHECK (email IS NOT NULL OR guest_token IS NOT NULL)
);

CREATE INDEX idx_users_role_active ON users (role) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_grade       ON users (customer_grade) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_created_at  ON users (created_at DESC);

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- ---------------------------------------------------------------------
-- 2.2 system_configs (moved here from 03_pricing_schema.sql)
-- ---------------------------------------------------------------------
CREATE TABLE system_configs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    config_key      VARCHAR(100) NOT NULL UNIQUE,
    config_value    TEXT NOT NULL,
    description     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_system_configs_key ON system_configs (config_key);

CREATE TRIGGER trg_system_configs_updated_at
    BEFORE UPDATE ON system_configs
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SECTION 3: PRODUCT SCHEMA
-- =====================================================================

-- 3.1 product_categories (3-tier self-join hierarchy)
CREATE TABLE product_categories (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id       UUID,
    code            VARCHAR(64) NOT NULL UNIQUE,
    name            VARCHAR(128) NOT NULL,
    slug            VARCHAR(128) NOT NULL UNIQUE,
    depth           SMALLINT NOT NULL DEFAULT 1,
    path            VARCHAR(512),
    sort_order      INTEGER NOT NULL DEFAULT 0,
    description     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_product_categories_parent
        FOREIGN KEY (parent_id) REFERENCES product_categories(id) ON DELETE RESTRICT,
    CONSTRAINT chk_product_categories_depth
        CHECK (depth BETWEEN 1 AND 4),
    CONSTRAINT chk_product_categories_root_no_parent
        CHECK ((depth = 1 AND parent_id IS NULL) OR (depth > 1 AND parent_id IS NOT NULL))
);

CREATE INDEX idx_product_categories_parent     ON product_categories (parent_id);
CREATE INDEX idx_product_categories_depth_sort ON product_categories (depth, sort_order) WHERE is_active = TRUE;
CREATE INDEX idx_product_categories_path       ON product_categories (path);

CREATE TRIGGER trg_product_categories_updated_at
    BEFORE UPDATE ON product_categories
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 3.2 products
CREATE TABLE products (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id         UUID NOT NULL,
    code                VARCHAR(64) NOT NULL UNIQUE,
    name                VARCHAR(128) NOT NULL,
    slug                VARCHAR(128) NOT NULL UNIQUE,
    short_description   VARCHAR(255),
    description         TEXT,
    thumbnail_url       VARCHAR(512),
    pricing_strategy    VARCHAR(32) NOT NULL DEFAULT 'lookup',
    min_order_qty       INTEGER NOT NULL DEFAULT 1,
    max_order_qty       INTEGER,
    base_lead_time_days SMALLINT NOT NULL DEFAULT 1,
    sort_order          INTEGER NOT NULL DEFAULT 0,
    metadata            JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES product_categories(id) ON DELETE RESTRICT,
    CONSTRAINT chk_products_pricing_strategy
        CHECK (pricing_strategy IN ('lookup', 'formula', 'hybrid')),
    CONSTRAINT chk_products_qty_range
        CHECK (min_order_qty >= 1 AND (max_order_qty IS NULL OR max_order_qty >= min_order_qty))
);

CREATE INDEX idx_products_category_active ON products (category_id, is_active);
CREATE INDEX idx_products_active_sort     ON products (is_active, sort_order);
CREATE INDEX idx_products_metadata_gin    ON products USING GIN (metadata);

CREATE TRIGGER trg_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 3.3 product_specifications
CREATE TABLE product_specifications (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      UUID NOT NULL,
    name            VARCHAR(64) NOT NULL,
    display_name    VARCHAR(128) NOT NULL,
    description     TEXT,
    input_type      VARCHAR(16) NOT NULL,
    is_required     BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order      INTEGER NOT NULL DEFAULT 0,
    min_value       NUMERIC(12,2),
    max_value       NUMERIC(12,2),
    step_value      NUMERIC(12,2),
    unit            VARCHAR(16),
    placeholder     VARCHAR(128),
    help_text       TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_product_specifications_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT chk_product_specifications_input_type
        CHECK (input_type IN ('select', 'radio', 'number', 'slider', 'text')),
    CONSTRAINT uq_product_specifications_product_name
        UNIQUE (product_id, name)
);

CREATE INDEX idx_product_specifications_product_active ON product_specifications (product_id, is_active);
CREATE INDEX idx_product_specifications_product_sort   ON product_specifications (product_id, sort_order);

CREATE TRIGGER trg_product_specifications_updated_at
    BEFORE UPDATE ON product_specifications
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 3.4 product_spec_options
-- FIX: extra_cost_modifier NUMERIC(4,4) -> NUMERIC(6,4)
--      NUMERIC(4,4) holds max 0.9999, cannot store 1.0000 default or any
--      modifier > 1 (e.g. 1.1500). Bumping to NUMERIC(6,4) supports
--      modifiers up to 99.9999.
CREATE TABLE product_spec_options (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    spec_id             UUID NOT NULL,
    value               VARCHAR(128) NOT NULL,
    display_name        VARCHAR(128) NOT NULL,
    description         TEXT,
    extra_cost_modifier NUMERIC(6,4) NOT NULL DEFAULT 1.0000,   -- FIXED (was 4,4)
    image_url           VARCHAR(512),
    sort_order          INTEGER NOT NULL DEFAULT 0,
    is_default          BOOLEAN NOT NULL DEFAULT FALSE,
    metadata            JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_product_spec_options_spec
        FOREIGN KEY (spec_id) REFERENCES product_specifications(id) ON DELETE CASCADE,
    CONSTRAINT chk_product_spec_options_modifier_positive
        CHECK (extra_cost_modifier > 0),
    CONSTRAINT uq_product_spec_options_spec_value
        UNIQUE (spec_id, value)
);

CREATE INDEX idx_product_spec_options_spec_sort   ON product_spec_options (spec_id, sort_order);
CREATE INDEX idx_product_spec_options_spec_active ON product_spec_options (spec_id, is_active);
CREATE UNIQUE INDEX uq_product_spec_options_default_per_spec
    ON product_spec_options (spec_id) WHERE is_default = TRUE;

CREATE TRIGGER trg_product_spec_options_updated_at
    BEFORE UPDATE ON product_spec_options
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 3.5 product_spec_rules
CREATE TABLE product_spec_rules (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id          UUID NOT NULL,
    name                VARCHAR(128),
    condition_spec_id   UUID NOT NULL,
    condition_option_id UUID NOT NULL,
    target_spec_id      UUID NOT NULL,
    target_option_id    UUID,
    rule_type           VARCHAR(16) NOT NULL,
    priority            SMALLINT NOT NULL DEFAULT 100,
    message             TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_product_spec_rules_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_spec_rules_condition_spec
        FOREIGN KEY (condition_spec_id) REFERENCES product_specifications(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_spec_rules_condition_option
        FOREIGN KEY (condition_option_id) REFERENCES product_spec_options(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_spec_rules_target_spec
        FOREIGN KEY (target_spec_id) REFERENCES product_specifications(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_spec_rules_target_option
        FOREIGN KEY (target_option_id) REFERENCES product_spec_options(id) ON DELETE CASCADE,
    CONSTRAINT chk_product_spec_rules_rule_type
        CHECK (rule_type IN ('enable', 'disable', 'require')),
    CONSTRAINT chk_product_spec_rules_no_self_target
        CHECK (condition_spec_id <> target_spec_id OR condition_option_id <> target_option_id)
);

CREATE INDEX idx_product_spec_rules_product_active ON product_spec_rules (product_id, is_active);
CREATE INDEX idx_product_spec_rules_condition      ON product_spec_rules (condition_spec_id, condition_option_id);
CREATE INDEX idx_product_spec_rules_target         ON product_spec_rules (target_spec_id, target_option_id);

CREATE TRIGGER trg_product_spec_rules_updated_at
    BEFORE UPDATE ON product_spec_rules
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 3.6 product_templates
CREATE TABLE product_templates (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id          UUID NOT NULL,
    code                VARCHAR(64) NOT NULL,
    name                VARCHAR(128) NOT NULL,
    description         TEXT,
    selected_options    JSONB NOT NULL DEFAULT '{}'::jsonb,
    is_featured         BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order          INTEGER NOT NULL DEFAULT 0,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_product_templates_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT uq_product_templates_product_code
        UNIQUE (product_id, code)
);

CREATE INDEX idx_product_templates_product_active ON product_templates (product_id, is_active);
CREATE INDEX idx_product_templates_featured       ON product_templates (is_featured) WHERE is_featured = TRUE;
CREATE INDEX idx_product_templates_options_gin    ON product_templates USING GIN (selected_options);

CREATE TRIGGER trg_product_templates_updated_at
    BEFORE UPDATE ON product_templates
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SECTION 4: PRICING SCHEMA
-- =====================================================================

-- 4.1 price_tables
CREATE TABLE price_tables (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      UUID NOT NULL,
    name            VARCHAR(128) NOT NULL,
    print_method    VARCHAR(16) NOT NULL,
    currency        CHAR(3) NOT NULL DEFAULT 'KRW',
    valid_from      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    valid_to        TIMESTAMPTZ,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    notes           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- FK to products added in SECTION 8
    CONSTRAINT chk_price_tables_print_method
        CHECK (print_method IN ('offset', 'digital', 'wide_format')),
    CONSTRAINT chk_price_tables_validity_window
        CHECK (valid_to IS NULL OR valid_to > valid_from)
);

CREATE INDEX idx_price_tables_product_method_active ON price_tables (product_id, print_method, is_active);
CREATE INDEX idx_price_tables_validity ON price_tables (product_id, valid_from, valid_to);

CREATE TRIGGER trg_price_tables_updated_at
    BEFORE UPDATE ON price_tables
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 4.2 quantity_price_breaks
CREATE TABLE quantity_price_breaks (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    price_table_id  UUID NOT NULL,
    qty_from        INT NOT NULL,
    qty_to          INT,
    unit_price      NUMERIC(12,2) NOT NULL,
    setup_fee       NUMERIC(12,2) NOT NULL DEFAULT 0,
    sort_order      INTEGER NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_quantity_price_breaks_table
        FOREIGN KEY (price_table_id) REFERENCES price_tables(id) ON DELETE CASCADE,
    CONSTRAINT chk_quantity_price_breaks_range
        CHECK (qty_from >= 1 AND (qty_to IS NULL OR qty_to >= qty_from)),
    CONSTRAINT chk_quantity_price_breaks_amounts
        CHECK (unit_price >= 0 AND setup_fee >= 0)
);

CREATE INDEX idx_quantity_price_breaks_table_range ON quantity_price_breaks (price_table_id, qty_from, qty_to);

CREATE TRIGGER trg_quantity_price_breaks_updated_at
    BEFORE UPDATE ON quantity_price_breaks
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 4.3 spec_option_surcharges
CREATE TABLE spec_option_surcharges (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    price_table_id      UUID NOT NULL,
    spec_option_id      UUID NOT NULL,
    cost_type           VARCHAR(16) NOT NULL,
    cost_value          NUMERIC(12,4) NOT NULL,
    description         VARCHAR(255),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_spec_option_surcharges_table
        FOREIGN KEY (price_table_id) REFERENCES price_tables(id) ON DELETE CASCADE,
    -- FK to product_spec_options added in SECTION 8
    CONSTRAINT chk_spec_option_surcharges_cost_type
        CHECK (cost_type IN ('per_unit', 'fixed', 'percentage')),
    CONSTRAINT chk_spec_option_surcharges_value
        CHECK (cost_value >= 0),
    CONSTRAINT uq_spec_option_surcharges_table_option
        UNIQUE (price_table_id, spec_option_id)
);

CREATE INDEX idx_spec_option_surcharges_table  ON spec_option_surcharges (price_table_id);
CREATE INDEX idx_spec_option_surcharges_option ON spec_option_surcharges (spec_option_id);

CREATE TRIGGER trg_spec_option_surcharges_updated_at
    BEFORE UPDATE ON spec_option_surcharges
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 4.4 surcharge_rules
CREATE TABLE surcharge_rules (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                VARCHAR(128) NOT NULL,
    condition_type      VARCHAR(32) NOT NULL,
    condition_value     JSONB NOT NULL DEFAULT '{}'::jsonb,
    surcharge_type      VARCHAR(16) NOT NULL,
    surcharge_value     NUMERIC(12,2) NOT NULL,
    priority            INT NOT NULL DEFAULT 100,
    valid_from          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    valid_to            TIMESTAMPTZ,
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,
    description         TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_surcharge_rules_surcharge_type CHECK (surcharge_type IN ('percentage', 'fixed')),
    CONSTRAINT chk_surcharge_rules_value          CHECK (surcharge_value >= 0),
    CONSTRAINT chk_surcharge_rules_validity       CHECK (valid_to IS NULL OR valid_to > valid_from)
);

CREATE INDEX idx_surcharge_rules_active_priority      ON surcharge_rules (is_active, priority) WHERE is_active = TRUE;
CREATE INDEX idx_surcharge_rules_condition_type       ON surcharge_rules (condition_type) WHERE is_active = TRUE;
CREATE INDEX idx_surcharge_rules_condition_value_gin  ON surcharge_rules USING GIN (condition_value);

CREATE TRIGGER trg_surcharge_rules_updated_at
    BEFORE UPDATE ON surcharge_rules
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 4.5 discount_policies
CREATE TABLE discount_policies (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                    VARCHAR(128) NOT NULL,
    discount_type           VARCHAR(16) NOT NULL,
    discount_value          NUMERIC(12,2) NOT NULL,
    min_order_amount        NUMERIC(12,2) NOT NULL DEFAULT 0,
    max_discount_amount     NUMERIC(12,2),
    customer_grade          VARCHAR(16) NOT NULL DEFAULT 'normal',
    valid_from              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    valid_to                TIMESTAMPTZ,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    description             TEXT,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_discount_policies_discount_type
        CHECK (discount_type IN ('percentage', 'fixed', 'free_shipping')),
    CONSTRAINT chk_discount_policies_customer_grade
        CHECK (customer_grade IN ('normal', 'silver', 'gold', 'vip')),
    CONSTRAINT chk_discount_policies_amounts
        CHECK (discount_value >= 0 AND min_order_amount >= 0
               AND (max_discount_amount IS NULL OR max_discount_amount >= 0)),
    CONSTRAINT chk_discount_policies_validity
        CHECK (valid_to IS NULL OR valid_to > valid_from)
);

CREATE INDEX idx_discount_policies_grade_active ON discount_policies (customer_grade, is_active) WHERE is_active = TRUE;
CREATE INDEX idx_discount_policies_validity     ON discount_policies (valid_from, valid_to) WHERE is_active = TRUE;

CREATE TRIGGER trg_discount_policies_updated_at
    BEFORE UPDATE ON discount_policies
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 4.6 shipping_fee_rules
CREATE TABLE shipping_fee_rules (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    region_group            VARCHAR(32) NOT NULL,
    min_amount_for_free     NUMERIC(12,2) NOT NULL DEFAULT 0,
    base_fee                NUMERIC(12,2) NOT NULL,
    express_surcharge       NUMERIC(12,2) NOT NULL DEFAULT 0,
    valid_from              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    valid_to                TIMESTAMPTZ,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    description             TEXT,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_shipping_fee_rules_amounts
        CHECK (min_amount_for_free >= 0 AND base_fee >= 0 AND express_surcharge >= 0),
    CONSTRAINT chk_shipping_fee_rules_validity
        CHECK (valid_to IS NULL OR valid_to > valid_from),
    CONSTRAINT uq_shipping_fee_rules_region_active
        UNIQUE (region_group, valid_from)
);

CREATE INDEX idx_shipping_fee_rules_region_active
    ON shipping_fee_rules (region_group, is_active) WHERE is_active = TRUE;

CREATE TRIGGER trg_shipping_fee_rules_updated_at
    BEFORE UPDATE ON shipping_fee_rules
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SECTION 5: ORDER SCHEMA
-- =====================================================================

-- 5.1 quotes
CREATE TABLE quotes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID,
    quote_number    VARCHAR(20) NOT NULL UNIQUE,
    product_id      UUID NOT NULL,
    spec_snapshot   JSONB NOT NULL,
    price_breakdown JSONB NOT NULL,
    total_amount    NUMERIC(12,2) NOT NULL,
    vat_amount      NUMERIC(12,2) NOT NULL,
    grand_total     NUMERIC(12,2) NOT NULL,
    status          VARCHAR(16) NOT NULL DEFAULT 'active',
    expires_at      TIMESTAMPTZ NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_quotes_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_quotes_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    CONSTRAINT chk_quotes_status
        CHECK (status IN ('active', 'converted', 'expired', 'cancelled')),
    CONSTRAINT chk_quotes_amounts
        CHECK (total_amount >= 0 AND vat_amount >= 0 AND grand_total >= 0),
    CONSTRAINT chk_quotes_expiry
        CHECK (expires_at > created_at)
);

CREATE INDEX idx_quotes_user_created   ON quotes (user_id, created_at DESC);
CREATE INDEX idx_quotes_status_expires ON quotes (status, expires_at) WHERE status = 'active';
CREATE INDEX idx_quotes_product        ON quotes (product_id);

CREATE TRIGGER trg_quotes_updated_at
    BEFORE UPDATE ON quotes
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 5.2 orders (17-state machine)
CREATE TABLE orders (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                     UUID,
    quote_id                    UUID,
    order_number                VARCHAR(20) NOT NULL UNIQUE,
    status                      VARCHAR(32) NOT NULL DEFAULT 'draft',

    subtotal                    NUMERIC(12,2) NOT NULL DEFAULT 0,
    finishing_total             NUMERIC(12,2) NOT NULL DEFAULT 0,
    setup_fee                   NUMERIC(12,2) NOT NULL DEFAULT 0,
    surcharge_total             NUMERIC(12,2) NOT NULL DEFAULT 0,
    discount_total              NUMERIC(12,2) NOT NULL DEFAULT 0,
    shipping_fee                NUMERIC(12,2) NOT NULL DEFAULT 0,
    total_amount                NUMERIC(12,2) NOT NULL DEFAULT 0,
    vat_amount                  NUMERIC(12,2) NOT NULL DEFAULT 0,
    grand_total                 NUMERIC(12,2) NOT NULL DEFAULT 0,

    requested_delivery_date     DATE,
    confirmed_delivery_date     DATE,
    notes                       TEXT,

    cancelled_at                TIMESTAMPTZ,
    cancel_reason               TEXT,

    created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at                  TIMESTAMPTZ,

    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_orders_quote
        FOREIGN KEY (quote_id) REFERENCES quotes(id) ON DELETE SET NULL,
    CONSTRAINT chk_orders_status CHECK (status IN (
        'draft','quote_confirmed','payment_pending','payment_done',
        'file_pending','file_review','file_approved','file_rejected',
        'in_production','qc_pass','shipped','delivered','completed',
        'cancelled','refund_requested','refunding','refunded'
    )),
    CONSTRAINT chk_orders_amounts CHECK (
        subtotal >= 0 AND finishing_total >= 0 AND setup_fee >= 0
        AND surcharge_total >= 0 AND discount_total >= 0 AND shipping_fee >= 0
        AND total_amount >= 0 AND vat_amount >= 0 AND grand_total >= 0
    ),
    CONSTRAINT chk_orders_delivery_dates CHECK (
        confirmed_delivery_date IS NULL
        OR requested_delivery_date IS NULL
        OR confirmed_delivery_date >= requested_delivery_date - INTERVAL '7 days'
    ),
    CONSTRAINT chk_orders_cancel_consistency CHECK (
        (cancelled_at IS NULL AND status NOT IN ('cancelled'))
        OR (cancelled_at IS NOT NULL)
    )
);

CREATE INDEX idx_orders_user_created   ON orders (user_id, created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_orders_status_created ON orders (status, created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_orders_quote          ON orders (quote_id) WHERE quote_id IS NOT NULL;

CREATE TRIGGER trg_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 5.3 order_items
CREATE TABLE order_items (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id                UUID NOT NULL,
    product_id              UUID NOT NULL,
    product_name_snapshot   VARCHAR(200) NOT NULL,
    spec_snapshot           JSONB NOT NULL,
    price_snapshot          JSONB NOT NULL,
    quantity                INT NOT NULL,
    unit_price              NUMERIC(12,2) NOT NULL,
    total_price             NUMERIC(12,2) NOT NULL,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    CONSTRAINT chk_order_items_quantity CHECK (quantity > 0),
    CONSTRAINT chk_order_items_prices   CHECK (unit_price >= 0 AND total_price >= 0)
);

CREATE INDEX idx_order_items_order    ON order_items (order_id);
CREATE INDEX idx_order_items_product  ON order_items (product_id);
CREATE INDEX idx_order_items_spec_gin ON order_items USING GIN (spec_snapshot);


-- 5.4 order_status_history
CREATE TABLE order_status_history (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        UUID NOT NULL,
    from_status     VARCHAR(32),
    to_status       VARCHAR(32) NOT NULL,
    changed_by      UUID,
    changed_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    reason          TEXT,
    metadata        JSONB NOT NULL DEFAULT '{}'::jsonb,

    CONSTRAINT fk_order_status_history_order
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_status_history_user
        FOREIGN KEY (changed_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_order_status_history_to_status CHECK (to_status IN (
        'draft','quote_confirmed','payment_pending','payment_done',
        'file_pending','file_review','file_approved','file_rejected',
        'in_production','qc_pass','shipped','delivered','completed',
        'cancelled','refund_requested','refunding','refunded'
    ))
);

CREATE INDEX idx_order_status_history_order_time ON order_status_history (order_id, changed_at DESC);
CREATE INDEX idx_order_status_history_to_time    ON order_status_history (to_status, changed_at DESC);


-- 5.5 artwork_files
CREATE TABLE artwork_files (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_item_id       UUID NOT NULL,
    original_filename   VARCHAR(500) NOT NULL,
    storage_key         VARCHAR(1000) NOT NULL,
    file_size_bytes     BIGINT,
    mime_type           VARCHAR(100),
    status              VARCHAR(16) NOT NULL DEFAULT 'pending',
    uploaded_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    reviewed_at         TIMESTAMPTZ,
    reviewer_id         UUID,
    rejection_reason    TEXT,
    retry_count         INT NOT NULL DEFAULT 0,
    prepress_notes      TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_artwork_files_order_item
        FOREIGN KEY (order_item_id) REFERENCES order_items(id) ON DELETE CASCADE,
    CONSTRAINT fk_artwork_files_reviewer
        FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_artwork_files_status
        CHECK (status IN ('pending', 'reviewing', 'approved', 'rejected')),
    CONSTRAINT chk_artwork_files_file_size
        CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0),
    CONSTRAINT chk_artwork_files_retry
        CHECK (retry_count >= 0),
    CONSTRAINT chk_artwork_files_rejection_consistency CHECK (
        status <> 'rejected'
        OR (reviewed_at IS NOT NULL AND rejection_reason IS NOT NULL)
    )
);

CREATE INDEX idx_artwork_files_item_status  ON artwork_files (order_item_id, status);
CREATE INDEX idx_artwork_files_status_queue ON artwork_files (status, uploaded_at)
    WHERE status IN ('pending', 'reviewing');
CREATE INDEX idx_artwork_files_reviewer     ON artwork_files (reviewer_id) WHERE reviewer_id IS NOT NULL;


-- 5.6 payments
CREATE TABLE payments (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id            UUID NOT NULL,
    pg_provider         VARCHAR(50) NOT NULL,
    pg_transaction_id   VARCHAR(200) NOT NULL UNIQUE,
    payment_method      VARCHAR(20) NOT NULL,
    amount              NUMERIC(12,2) NOT NULL,
    paid_at             TIMESTAMPTZ,
    status              VARCHAR(20) NOT NULL DEFAULT 'pending',
    failure_reason      TEXT,
    receipt_url         TEXT,
    refund_amount       NUMERIC(12,2) NOT NULL DEFAULT 0,
    refunded_at         TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE RESTRICT,
    CONSTRAINT chk_payments_method CHECK (payment_method IN (
        'card', 'bank_transfer', 'virtual_account', 'kakao_pay', 'naver_pay'
    )),
    CONSTRAINT chk_payments_status CHECK (status IN (
        'pending', 'completed', 'failed', 'refunded', 'partial_refund'
    )),
    CONSTRAINT chk_payments_amount CHECK (amount >= 0),
    CONSTRAINT chk_payments_refund CHECK (refund_amount >= 0 AND refund_amount <= amount),
    CONSTRAINT chk_payments_completion_consistency CHECK (
        status NOT IN ('completed', 'refunded', 'partial_refund')
        OR paid_at IS NOT NULL
    )
);

CREATE INDEX idx_payments_order          ON payments (order_id);
CREATE INDEX idx_payments_status_paid_at ON payments (status, paid_at DESC);


-- 5.7 shipping_info
CREATE TABLE shipping_info (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id                UUID NOT NULL UNIQUE,
    carrier                 VARCHAR(100),
    tracking_number         VARCHAR(200),
    recipient_name          VARCHAR(100) NOT NULL,
    recipient_phone         VARCHAR(20) NOT NULL,
    address_road            VARCHAR(500) NOT NULL,
    address_detail          VARCHAR(200),
    postal_code             VARCHAR(10) NOT NULL,
    shipped_at              TIMESTAMPTZ,
    estimated_delivery      DATE,
    actual_delivery         TIMESTAMPTZ,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_shipping_info_order
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT chk_shipping_info_delivery_order CHECK (
        actual_delivery IS NULL OR shipped_at IS NULL OR actual_delivery >= shipped_at
    )
);

CREATE INDEX idx_shipping_info_tracking   ON shipping_info (tracking_number) WHERE tracking_number IS NOT NULL;
CREATE INDEX idx_shipping_info_shipped_at ON shipping_info (shipped_at DESC) WHERE shipped_at IS NOT NULL;

CREATE TRIGGER trg_shipping_info_updated_at
    BEFORE UPDATE ON shipping_info
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SECTION 6: WIDGET SCHEMA
-- =====================================================================

-- 6.1 widget_configs
CREATE TABLE widget_configs (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id                  UUID NOT NULL,
    name                        VARCHAR(128) NOT NULL,
    layout_type                 VARCHAR(16) NOT NULL DEFAULT 'stepped',
    preview_enabled             BOOLEAN NOT NULL DEFAULT TRUE,
    realtime_price_enabled      BOOLEAN NOT NULL DEFAULT TRUE,
    debounce_ms                 SMALLINT NOT NULL DEFAULT 300,
    description                 TEXT,
    metadata                    JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active                   BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_widget_configs_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT uq_widget_configs_product UNIQUE (product_id),
    CONSTRAINT chk_widget_configs_layout_type
        CHECK (layout_type IN ('stepped', 'single_page', 'sidebar')),
    CONSTRAINT chk_widget_configs_debounce_range
        CHECK (debounce_ms BETWEEN 0 AND 2000)
);

CREATE INDEX idx_widget_configs_active ON widget_configs (is_active) WHERE is_active = TRUE;

CREATE TRIGGER trg_widget_configs_updated_at
    BEFORE UPDATE ON widget_configs
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 6.2 widget_steps
CREATE TABLE widget_steps (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    widget_id               UUID NOT NULL,
    step_number             INTEGER NOT NULL,
    title_i18n_key          VARCHAR(100) NOT NULL,
    description_i18n_key    VARCHAR(100),
    is_required             BOOLEAN NOT NULL DEFAULT TRUE,
    skip_condition          JSONB,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_widget_steps_widget
        FOREIGN KEY (widget_id) REFERENCES widget_configs(id) ON DELETE CASCADE,
    CONSTRAINT chk_widget_steps_step_number_positive CHECK (step_number > 0),
    CONSTRAINT uq_widget_steps_widget_step_number UNIQUE (widget_id, step_number)
);

CREATE INDEX idx_widget_steps_widget_active ON widget_steps (widget_id, is_active);

CREATE TRIGGER trg_widget_steps_updated_at
    BEFORE UPDATE ON widget_steps
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 6.3 widget_step_fields
CREATE TABLE widget_step_fields (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    step_id             UUID NOT NULL,
    field_key           VARCHAR(100) NOT NULL,
    field_type          VARCHAR(16) NOT NULL,
    spec_id             UUID,
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
        FOREIGN KEY (step_id) REFERENCES widget_steps(id) ON DELETE CASCADE,
    CONSTRAINT fk_widget_step_fields_spec
        FOREIGN KEY (spec_id) REFERENCES product_specifications(id) ON DELETE SET NULL,
    CONSTRAINT chk_widget_step_fields_field_type
        CHECK (field_type IN ('select', 'radio', 'number', 'slider', 'date', 'text', 'file')),
    CONSTRAINT uq_widget_step_fields_step_field_key UNIQUE (step_id, field_key)
);

CREATE INDEX idx_widget_step_fields_step_sort ON widget_step_fields (step_id, sort_order);
CREATE INDEX idx_widget_step_fields_spec      ON widget_step_fields (spec_id) WHERE spec_id IS NOT NULL;

CREATE TRIGGER trg_widget_step_fields_updated_at
    BEFORE UPDATE ON widget_step_fields
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 6.4 widget_conditional_rules
CREATE TABLE widget_conditional_rules (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    widget_id               UUID NOT NULL,
    name                    VARCHAR(128),
    condition_field_key     VARCHAR(100) NOT NULL,
    condition_operator      VARCHAR(8)  NOT NULL,
    condition_value         JSONB NOT NULL,
    action_type             VARCHAR(16) NOT NULL,
    target_field_key        VARCHAR(100) NOT NULL,
    action_payload          JSONB,
    priority                INTEGER NOT NULL DEFAULT 100,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_widget_conditional_rules_widget
        FOREIGN KEY (widget_id) REFERENCES widget_configs(id) ON DELETE CASCADE,
    CONSTRAINT chk_widget_conditional_rules_operator
        CHECK (condition_operator IN ('eq', 'neq', 'in', 'gte', 'lte')),
    CONSTRAINT chk_widget_conditional_rules_action
        CHECK (action_type IN ('show', 'hide', 'enable', 'disable', 'set_value', 'require'))
);

CREATE INDEX idx_widget_conditional_rules_widget_active   ON widget_conditional_rules (widget_id, is_active);
CREATE INDEX idx_widget_conditional_rules_widget_priority ON widget_conditional_rules (widget_id, priority);
CREATE INDEX idx_widget_conditional_rules_condition_field ON widget_conditional_rules (widget_id, condition_field_key);

CREATE TRIGGER trg_widget_conditional_rules_updated_at
    BEFORE UPDATE ON widget_conditional_rules
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 6.5 preview_templates
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
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT chk_preview_templates_template_type
        CHECK (template_type IN ('svg', 'canvas', 'image'))
);

CREATE INDEX idx_preview_templates_product_active ON preview_templates (product_id, is_active);

CREATE TRIGGER trg_preview_templates_updated_at
    BEFORE UPDATE ON preview_templates
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 6.6 ui_translations
CREATE TABLE ui_translations (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    i18n_key    VARCHAR(200) NOT NULL,
    locale      VARCHAR(10) NOT NULL,
    value       TEXT NOT NULL,
    context     TEXT,
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_ui_translations_key_locale UNIQUE (i18n_key, locale)
);

CREATE INDEX idx_ui_translations_key_locale ON ui_translations (i18n_key, locale);

CREATE TRIGGER trg_ui_translations_updated_at
    BEFORE UPDATE ON ui_translations
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 6.7 widget_analytics (append-only)
CREATE TABLE widget_analytics (
    id              BIGSERIAL PRIMARY KEY,
    session_id      UUID NOT NULL,
    widget_id       UUID NOT NULL,
    step_id         UUID,
    event_type      VARCHAR(16) NOT NULL,
    field_key       VARCHAR(100),
    field_value     TEXT,
    metadata        JSONB,
    occurred_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_widget_analytics_widget
        FOREIGN KEY (widget_id) REFERENCES widget_configs(id) ON DELETE CASCADE,
    CONSTRAINT fk_widget_analytics_step
        FOREIGN KEY (step_id) REFERENCES widget_steps(id) ON DELETE SET NULL,
    CONSTRAINT chk_widget_analytics_event_type
        CHECK (event_type IN ('view', 'interact', 'complete', 'abandon'))
);

CREATE INDEX idx_widget_analytics_widget_occurred ON widget_analytics (widget_id, occurred_at DESC);
CREATE INDEX idx_widget_analytics_session         ON widget_analytics (session_id);
CREATE INDEX idx_widget_analytics_widget_event    ON widget_analytics (widget_id, event_type, occurred_at DESC);


-- =====================================================================
-- SECTION 7: PRODUCTION SCHEMA
-- =====================================================================

-- 7.1 production_stage_types
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


-- 7.2 equipment_configs
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

    CONSTRAINT chk_equipment_type   CHECK (equipment_type IN ('offset','digital','wide_format','finishing')),
    CONSTRAINT chk_equipment_status CHECK (status IN ('active','maintenance','offline'))
);

CREATE INDEX idx_equipment_status ON equipment_configs (status) WHERE is_active = TRUE;

CREATE TRIGGER trg_equipment_updated_at
    BEFORE UPDATE ON equipment_configs
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 7.3 production_jobs
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
    CONSTRAINT chk_jobs_print_method
        CHECK (print_method IN ('offset','digital','wide_format')),
    CONSTRAINT chk_jobs_status
        CHECK (status IN ('queued','in_progress','on_hold','completed','cancelled')),
    CONSTRAINT chk_jobs_planned_window
        CHECK (planned_end_at IS NULL OR planned_start_at IS NULL OR planned_end_at >= planned_start_at)
);

CREATE INDEX idx_jobs_status_planned ON production_jobs (status, planned_start_at);
CREATE INDEX idx_jobs_equipment      ON production_jobs (equipment_id) WHERE equipment_id IS NOT NULL;

CREATE TRIGGER trg_jobs_updated_at
    BEFORE UPDATE ON production_jobs
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 7.4 production_job_items (N:M junction)
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


-- 7.5 job_stage_status
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
    CONSTRAINT chk_stage_status
        CHECK (status IN ('pending','in_progress','completed','skipped','failed')),
    CONSTRAINT chk_stage_status_window
        CHECK (completed_at IS NULL OR started_at IS NULL OR completed_at >= started_at)
);

CREATE INDEX idx_stage_status_job_status ON job_stage_status (job_id, status);


-- 7.6 print_materials
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

    CONSTRAINT chk_material_type
        CHECK (material_type IN ('paper','ink','coating_film','laminate','other')),
    CONSTRAINT chk_material_unit
        CHECK (unit IN ('sheet','kg','ml','roll','piece')),
    CONSTRAINT chk_material_stock
        CHECK (current_stock >= 0 AND min_stock_alert >= 0)
);

CREATE INDEX idx_materials_low_stock ON print_materials (material_type)
    WHERE is_active = TRUE AND current_stock <= min_stock_alert;

CREATE TRIGGER trg_materials_updated_at
    BEFORE UPDATE ON print_materials
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- 7.7 material_usage_log
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


-- 7.8 business_calendar
CREATE TABLE business_calendar (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    date              DATE NOT NULL UNIQUE,
    is_business_day   BOOLEAN NOT NULL,
    calendar_type     VARCHAR(16) NOT NULL DEFAULT 'normal',
    note              VARCHAR(200),

    CONSTRAINT chk_calendar_type
        CHECK (calendar_type IN ('normal','holiday','half_day'))
);

CREATE INDEX idx_calendar_date ON business_calendar (date);


-- 7.9 production_specs
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


-- 7.10 qc_checkpoints
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
    CONSTRAINT chk_qc_result        CHECK (result IN ('pass','fail','conditional_pass')),
    CONSTRAINT chk_qc_defect_count  CHECK (defect_count >= 0)
);

CREATE INDEX idx_qc_job   ON qc_checkpoints (job_id, inspected_at DESC);
CREATE INDEX idx_qc_stage ON qc_checkpoints (stage_type_id, result);


-- 7.11 business_days_from_now()
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
-- SECTION 8: CROSS-DOMAIN FOREIGN KEYS
-- =====================================================================
-- These FKs cross domain boundaries. Concentrating them here makes the
-- domain dependency map explicit and lets a future schema split (e.g.
-- separate per-domain databases) drop them in one block.
-- =====================================================================

-- pricing -> product
ALTER TABLE price_tables
    ADD CONSTRAINT fk_price_tables_product
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT;

ALTER TABLE spec_option_surcharges
    ADD CONSTRAINT fk_spec_option_surcharges_option
    FOREIGN KEY (spec_option_id) REFERENCES product_spec_options(id) ON DELETE CASCADE;

-- (widget -> product FKs are inlined above because widget_configs.product_id
--  carries a UNIQUE constraint that must exist at table creation time.
--  widget_step_fields.spec_id -> product_specifications is also inlined.)

-- (production -> product FK is inlined: production_specs.product_id UNIQUE.)

-- (production -> users / production -> order_items FKs are inlined.)

-- (order -> product / order -> users FKs are inlined inside SECTION 5.)


-- =====================================================================
-- SECTION 9: ADDITIONAL CROSS-DOMAIN PERFORMANCE INDEXES
-- =====================================================================
-- Per-table indexes already declared inline. The following composite
-- indexes serve cross-domain query patterns identified in research §6.3.
-- =====================================================================

-- Gang printing candidate scan (production §5.3): group order_items by
-- (paper × coating × method × due_date). spec_snapshot is JSONB; a GIN
-- index already exists; add a btree on order_id for join-back.
-- (idx_order_items_spec_gin already declared in SECTION 5.)

-- Pricing lookup: (product_id, print_method, valid_from) for "newest
-- active price table" — already covered by idx_price_tables_validity +
-- idx_price_tables_product_method_active.

-- Order dashboard partition-friendly index for last-30-days slice:
CREATE INDEX idx_orders_created_recent ON orders (created_at DESC)
    WHERE deleted_at IS NULL AND created_at > '2026-01-01';

-- Production queue depth by equipment + status:
CREATE INDEX idx_jobs_equipment_status ON production_jobs (equipment_id, status)
    WHERE equipment_id IS NOT NULL;

-- Surcharge rules condition_value JSONB lookup is already covered by
-- idx_surcharge_rules_condition_value_gin.


-- =====================================================================
-- SECTION 10: SEED DATA (in dependency order)
-- =====================================================================

-- ---------------------------------------------------------------------
-- 10.1 system_configs
-- ---------------------------------------------------------------------
INSERT INTO system_configs (config_key, config_value, description) VALUES
    ('VAT_RATE', '0.1',  '한국 부가가치세율 (공급가 × 0.1 = 부가세)'),
    ('CURRENCY', 'KRW',  '기본 통화 코드 (ISO 4217)');

-- ---------------------------------------------------------------------
-- 10.2 production_stage_types (6단계 마스터)
-- ---------------------------------------------------------------------
INSERT INTO production_stage_types (code, name, expected_duration_hours, sort_order, is_skippable) VALUES
    ('PREPRESS',  '프리프레스',  2.0, 1, FALSE),
    ('PRINTING',  '인쇄',        4.0, 2, FALSE),
    ('FINISHING', '후가공',      3.0, 3, TRUE),
    ('CUTTING',   '재단',        1.5, 4, FALSE),
    ('PACKAGING', '패키징',      1.0, 5, FALSE),
    ('SHIPPING',  '출고',        0.5, 6, FALSE);

-- ---------------------------------------------------------------------
-- 10.3 equipment_configs
-- ---------------------------------------------------------------------
INSERT INTO equipment_configs (name, equipment_type, max_width_mm, max_height_mm, max_color_count, status, notes) VALUES
    ('하이델베르크 옵셋 인쇄기 #1', 'offset',  720, 1020, 5, 'active', '4도+별색 1도 지원, gang run 주력기'),
    ('Xerox iGen 디지털 인쇄기',    'digital', 364,  660, 4, 'active', '소량/단납기 전용');

-- ---------------------------------------------------------------------
-- 10.4 business_calendar (representative 2026-05/06)
-- ---------------------------------------------------------------------
INSERT INTO business_calendar (date, is_business_day, calendar_type, note) VALUES
    ('2026-05-07', TRUE,  'normal',  '목'),
    ('2026-05-08', TRUE,  'normal',  '금 (어버이날)'),
    ('2026-05-09', FALSE, 'normal',  '토'),
    ('2026-05-10', FALSE, 'normal',  '일'),
    ('2026-05-11', TRUE,  'normal',  '월'),
    ('2026-05-15', TRUE,  'normal',  '금 (스승의날)'),
    ('2026-05-22', TRUE,  'normal',  '금'),
    ('2026-05-25', TRUE,  'normal',  '월'),
    ('2026-06-03', FALSE, 'holiday', '제8회 전국동시지방선거'),
    ('2026-06-06', FALSE, 'holiday', '현충일'),
    ('2026-06-08', TRUE,  'normal',  '월'),
    ('2026-06-15', TRUE,  'normal',  '월'),
    ('2026-06-22', TRUE,  'normal',  '월'),
    ('2026-06-29', TRUE,  'normal',  '월'),
    ('2026-06-30', TRUE,  'normal',  '화');

-- ---------------------------------------------------------------------
-- 10.5 Product domain seed: 일반명함 + specs + options + rule + template
-- ---------------------------------------------------------------------
DO $$
DECLARE
    v_cat_l1_id     UUID := gen_random_uuid();
    v_cat_l2_id     UUID := gen_random_uuid();
    v_product_id    UUID := gen_random_uuid();

    v_spec_size     UUID := gen_random_uuid();
    v_spec_paper    UUID := gen_random_uuid();
    v_spec_coating  UUID := gen_random_uuid();
    v_spec_print    UUID := gen_random_uuid();
    v_spec_qty      UUID := gen_random_uuid();

    v_opt_size_90   UUID := gen_random_uuid();
    v_opt_size_86   UUID := gen_random_uuid();

    v_opt_paper_art UUID := gen_random_uuid();
    v_opt_paper_snw UUID := gen_random_uuid();
    v_opt_paper_pvc UUID := gen_random_uuid();

    v_opt_coat_none UUID := gen_random_uuid();
    v_opt_coat_glos UUID := gen_random_uuid();
    v_opt_coat_matt UUID := gen_random_uuid();
    v_opt_coat_uv   UUID := gen_random_uuid();

    v_opt_prn_4_2   UUID := gen_random_uuid();
    v_opt_prn_4_1   UUID := gen_random_uuid();
    v_opt_prn_1_1   UUID := gen_random_uuid();

    v_opt_qty_100   UUID := gen_random_uuid();
    v_opt_qty_500   UUID := gen_random_uuid();
    v_opt_qty_1000  UUID := gen_random_uuid();
BEGIN
    INSERT INTO product_categories (id, parent_id, code, name, slug, depth, path, sort_order)
    VALUES
        (v_cat_l1_id, NULL,         'CARD',         '명함류',   'card',         1, '/CARD',                 10),
        (v_cat_l2_id, v_cat_l1_id,  'CARD_GENERAL', '일반명함', 'card-general', 2, '/CARD/CARD_GENERAL',    10);

    INSERT INTO products (id, category_id, code, name, slug, short_description,
                          pricing_strategy, min_order_qty, base_lead_time_days, sort_order)
    VALUES (v_product_id, v_cat_l2_id, 'CARD_GENERAL_STD', '일반명함', 'card-general-std',
            '표준 규격 일반명함 (90×50 / 86×54)', 'lookup', 100, 1, 10);

    INSERT INTO product_specifications (id, product_id, name, display_name, input_type, is_required, sort_order) VALUES
        (v_spec_size,    v_product_id, 'size',         '사이즈',     'radio',  TRUE, 10),
        (v_spec_paper,   v_product_id, 'paper',        '용지',       'radio',  TRUE, 20),
        (v_spec_coating, v_product_id, 'coating',      '코팅',       'select', TRUE, 30),
        (v_spec_print,   v_product_id, 'print_color',  '인쇄도수',   'radio',  TRUE, 40);

    INSERT INTO product_specifications (id, product_id, name, display_name, input_type, is_required, sort_order,
                                        min_value, max_value, step_value, unit)
    VALUES (v_spec_qty, v_product_id, 'quantity', '수량', 'slider', TRUE, 50,
            100, 20000, 100, '매');

    INSERT INTO product_spec_options (id, spec_id, value, display_name, extra_cost_modifier, sort_order, is_default) VALUES
        (v_opt_size_90, v_spec_size, '90x50', '90 × 50 mm (표준)',     1.0000, 10, TRUE),
        (v_opt_size_86, v_spec_size, '86x54', '86 × 54 mm (국제규격)', 1.0500, 20, FALSE);

    INSERT INTO product_spec_options (id, spec_id, value, display_name, extra_cost_modifier, sort_order, is_default) VALUES
        (v_opt_paper_art, v_spec_paper, 'art_250',          '아트지 250g',          1.0000, 10, TRUE),
        (v_opt_paper_snw, v_spec_paper, 'snow_white_300',   '스노우화이트 300g',    1.1500, 20, FALSE),
        (v_opt_paper_pvc, v_spec_paper, 'transparent_pvc',  '투명 PVC',             1.8000, 30, FALSE);

    INSERT INTO product_spec_options (id, spec_id, value, display_name, extra_cost_modifier, sort_order, is_default) VALUES
        (v_opt_coat_none, v_spec_coating, 'none',   '코팅 없음', 1.0000, 10, TRUE),
        (v_opt_coat_glos, v_spec_coating, 'glossy', '유광 라미', 1.0800, 20, FALSE),
        (v_opt_coat_matt, v_spec_coating, 'matte',  '무광 라미', 1.1000, 30, FALSE),
        (v_opt_coat_uv,   v_spec_coating, 'uv',     'UV 코팅',   1.1500, 40, FALSE);

    INSERT INTO product_spec_options (id, spec_id, value, display_name, extra_cost_modifier, sort_order, is_default) VALUES
        (v_opt_prn_4_2, v_spec_print, 'duplex_4',  '양면 4도(컬러)', 1.0000, 10, TRUE),
        (v_opt_prn_4_1, v_spec_print, 'simplex_4', '단면 4도(컬러)', 0.7000, 20, FALSE),
        (v_opt_prn_1_1, v_spec_print, 'simplex_1', '단면 1도(흑백)', 0.5000, 30, FALSE);

    INSERT INTO product_spec_options (id, spec_id, value, display_name, extra_cost_modifier, sort_order, is_default) VALUES
        (v_opt_qty_100,  v_spec_qty, '100',  '100매',   1.0000, 10, TRUE),
        (v_opt_qty_500,  v_spec_qty, '500',  '500매',   1.0000, 20, FALSE),
        (v_opt_qty_1000, v_spec_qty, '1000', '1,000매', 1.0000, 30, FALSE);

    INSERT INTO product_spec_rules (product_id, name, condition_spec_id, condition_option_id,
                                    target_spec_id, target_option_id, rule_type, priority, message)
    VALUES (v_product_id,
            '투명 PVC 선택 시 코팅 비활성',
            v_spec_paper, v_opt_paper_pvc,
            v_spec_coating, NULL,
            'disable', 10,
            '투명 PVC 용지는 표면 자체가 PET 코팅 처리되어 있어 추가 코팅을 적용할 수 없습니다.');

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


-- ---------------------------------------------------------------------
-- 10.6 Pricing seed: 일반명함 digital price table + breaks + surcharges
-- ---------------------------------------------------------------------
DO $$
DECLARE
    v_product_id        UUID;
    v_price_table_id    UUID := gen_random_uuid();

    v_opt_coat_glos     UUID;
    v_opt_coat_matt     UUID;
    v_opt_coat_uv       UUID;
BEGIN
    SELECT id INTO v_product_id FROM products WHERE code = 'CARD_GENERAL_STD';
    IF v_product_id IS NULL THEN
        RAISE EXCEPTION 'Seed prerequisite missing: product CARD_GENERAL_STD';
    END IF;

    SELECT o.id INTO v_opt_coat_glos
    FROM product_spec_options o
    JOIN product_specifications s ON s.id = o.spec_id
    WHERE s.product_id = v_product_id AND s.name = 'coating' AND o.value = 'glossy';
    SELECT o.id INTO v_opt_coat_matt
    FROM product_spec_options o
    JOIN product_specifications s ON s.id = o.spec_id
    WHERE s.product_id = v_product_id AND s.name = 'coating' AND o.value = 'matte';
    SELECT o.id INTO v_opt_coat_uv
    FROM product_spec_options o
    JOIN product_specifications s ON s.id = o.spec_id
    WHERE s.product_id = v_product_id AND s.name = 'coating' AND o.value = 'uv';

    INSERT INTO price_tables (id, product_id, name, print_method, currency, valid_from, is_active, notes)
    VALUES (v_price_table_id, v_product_id,
            '일반명함 디지털 표준 단가표 (2026)',
            'digital', 'KRW', NOW(), TRUE,
            '디지털 인쇄 기준 / 셋업비 0원 / 양면 4도 기본');

    INSERT INTO quantity_price_breaks (price_table_id, qty_from, qty_to, unit_price, setup_fee, sort_order) VALUES
        (v_price_table_id,    1,    50, 200.00, 0, 10),
        (v_price_table_id,   51,   100,  80.00, 0, 20),
        (v_price_table_id,  101,   500,  50.00, 0, 30),
        (v_price_table_id,  501,  1000,  35.00, 0, 40),
        (v_price_table_id, 1001,  NULL,  28.00, 0, 50);

    INSERT INTO spec_option_surcharges (price_table_id, spec_option_id, cost_type, cost_value, description) VALUES
        (v_price_table_id, v_opt_coat_glos, 'per_unit', 2.0000, '유광 라미네이팅 +2원/장'),
        (v_price_table_id, v_opt_coat_matt, 'per_unit', 3.0000, '무광 라미네이팅 +3원/장'),
        (v_price_table_id, v_opt_coat_uv,   'per_unit', 5.0000, 'UV 코팅 +5원/장');
END $$;

-- surcharge_rules
INSERT INTO surcharge_rules (name, condition_type, condition_value,
                             surcharge_type, surcharge_value, priority, description)
VALUES
    ('긴급납기 할증 (당일)',
     'rush_delivery',
     jsonb_build_object('lead_time_days', 0),
     'percentage', 20.00, 10,
     '당일 납기 요청 시 본 인쇄비의 20% 할증'),
    ('토요일 납기 할증',
     'weekend_delivery',
     jsonb_build_object('day_of_week', jsonb_build_array(6)),
     'percentage', 15.00, 20,
     '토요일 작업 / 출고 요청 시 15% 할증');

-- discount_policies
INSERT INTO discount_policies (name, discount_type, discount_value,
                                min_order_amount, max_discount_amount,
                                customer_grade, description)
VALUES
    ('Gold 회원 5% 할인', 'percentage',  5.00, 0, NULL, 'gold', 'Gold 등급 회원 자동 적용 5% 할인'),
    ('VIP 회원 10% 할인', 'percentage', 10.00, 0, NULL, 'vip',  'VIP 등급 회원 자동 적용 10% 할인');

-- shipping_fee_rules
INSERT INTO shipping_fee_rules (region_group, min_amount_for_free, base_fee, express_surcharge, description)
VALUES
    ('default', 30000.00, 3000.00, 5000.00,
     '전국 공통 / 30,000원 이상 무료 / 미만 3,000원 / 퀵배송 +5,000원');


-- ---------------------------------------------------------------------
-- 10.7 production_specs for 일반명함
-- ---------------------------------------------------------------------
DO $$
DECLARE
    v_product_id UUID;
BEGIN
    SELECT id INTO v_product_id FROM products WHERE code = 'CARD_GENERAL_STD';
    IF v_product_id IS NULL THEN
        RAISE NOTICE 'Skipping production_specs seed.';
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
        1, 200,
        '명함 90×50 / 양면 4도 / CMYK / 폰트 아웃라인 변환 필수'
    );
END $$;


-- ---------------------------------------------------------------------
-- 10.8 Widget seed: 일반명함 5-step widget
-- ---------------------------------------------------------------------
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
    SELECT id INTO v_product_id FROM products WHERE code = 'CARD_GENERAL_STD';
    IF v_product_id IS NULL THEN
        RAISE NOTICE 'Skipping widget seed.';
        RETURN;
    END IF;

    SELECT id INTO v_spec_size    FROM product_specifications WHERE product_id = v_product_id AND name = 'size';
    SELECT id INTO v_spec_paper   FROM product_specifications WHERE product_id = v_product_id AND name = 'paper';
    SELECT id INTO v_spec_coating FROM product_specifications WHERE product_id = v_product_id AND name = 'coating';
    SELECT id INTO v_spec_qty     FROM product_specifications WHERE product_id = v_product_id AND name = 'quantity';

    INSERT INTO widget_configs (id, product_id, name, layout_type,
                                preview_enabled, realtime_price_enabled, debounce_ms)
    VALUES (v_widget_id, v_product_id, '일반명함 견적 위젯', 'sidebar', TRUE, TRUE, 300);

    INSERT INTO widget_steps (id, widget_id, step_number, title_i18n_key, description_i18n_key, is_required) VALUES
        (v_step_size,    v_widget_id, 1, 'widget.card.step.size.title',    'widget.card.step.size.desc',    TRUE),
        (v_step_paper,   v_widget_id, 2, 'widget.card.step.paper.title',   'widget.card.step.paper.desc',   TRUE),
        (v_step_coating, v_widget_id, 3, 'widget.card.step.coating.title', 'widget.card.step.coating.desc', TRUE),
        (v_step_qty,     v_widget_id, 4, 'widget.card.step.qty.title',     'widget.card.step.qty.desc',     TRUE),
        (v_step_due,     v_widget_id, 5, 'widget.card.step.due.title',     'widget.card.step.due.desc',     TRUE);

    INSERT INTO widget_step_fields (step_id, field_key, field_type, spec_id,
                                    label_i18n_key, validation_rules, display_options, sort_order, is_required)
    VALUES
        (v_step_size, 'size', 'radio', v_spec_size,
            'widget.card.field.size.label',
            jsonb_build_object('required', true),
            jsonb_build_object('layout', 'card', 'columns', 2, 'showImage', true),
            10, TRUE),
        (v_step_paper, 'paper', 'select', v_spec_paper,
            'widget.card.field.paper.label',
            jsonb_build_object('required', true),
            jsonb_build_object('showImage', true, 'showWeight', true),
            10, TRUE),
        (v_step_coating, 'coating', 'radio', v_spec_coating,
            'widget.card.field.coating.label',
            jsonb_build_object('required', true),
            jsonb_build_object('layout', 'inline'),
            10, TRUE),
        (v_step_qty, 'quantity', 'slider', v_spec_qty,
            'widget.card.field.qty.label',
            jsonb_build_object('required', true, 'min', 100, 'max', 20000, 'step', 100),
            jsonb_build_object('showPerUnitPrice', true, 'showTooltip', true,
                               'breakpoints', jsonb_build_array(100, 200, 500, 1000, 2000, 5000, 10000)),
            10, TRUE),
        (v_step_due, 'due_date', 'date', NULL,
            'widget.card.field.due.label',
            jsonb_build_object('required', true),
            jsonb_build_object(
                'mode', 'preset',
                'options', jsonb_build_array(
                    jsonb_build_object('key', 'D1', 'label_i18n_key', 'widget.card.due.d1', 'surcharge_pct', 20),
                    jsonb_build_object('key', 'D2', 'label_i18n_key', 'widget.card.due.d2', 'surcharge_pct', 10),
                    jsonb_build_object('key', 'D3', 'label_i18n_key', 'widget.card.due.d3', 'surcharge_pct',  0)
                ),
                'showPriceDelta', true
            ),
            10, TRUE);

    INSERT INTO widget_conditional_rules (widget_id, name,
                                          condition_field_key, condition_operator, condition_value,
                                          action_type, target_field_key, action_payload, priority)
    VALUES (v_widget_id,
            '투명PVC 용지 선택시 코팅 단계 숨김',
            'paper', 'eq', '"transparent_pvc"'::jsonb,
            'hide', 'coating',
            jsonb_build_object('reason_i18n_key', 'widget.card.rule.pvc_no_coating'),
            10);

    INSERT INTO ui_translations (i18n_key, locale, value) VALUES
        ('widget.card.step.size.title',     'ko', '사이즈 선택'),
        ('widget.card.step.paper.title',    'ko', '용지 선택'),
        ('widget.card.step.coating.title',  'ko', '코팅 선택'),
        ('widget.card.step.qty.title',      'ko', '수량 선택'),
        ('widget.card.step.due.title',      'ko', '납기 선택'),
        ('widget.card.step.size.desc',      'ko', '명함 사이즈를 선택해주세요'),
        ('widget.card.step.paper.desc',     'ko', '인쇄에 사용할 용지를 선택해주세요'),
        ('widget.card.step.coating.desc',   'ko', '표면 코팅 방식을 선택해주세요'),
        ('widget.card.step.qty.desc',       'ko', '주문 수량을 선택해주세요'),
        ('widget.card.step.due.desc',       'ko', '희망 납기일을 선택해주세요'),
        ('widget.card.field.size.label',    'ko', '사이즈'),
        ('widget.card.field.paper.label',   'ko', '용지'),
        ('widget.card.field.coating.label', 'ko', '코팅'),
        ('widget.card.field.qty.label',     'ko', '수량'),
        ('widget.card.field.due.label',     'ko', '납기'),
        ('widget.card.due.d1',              'ko', '익일 출고 (할증 +20%)'),
        ('widget.card.due.d2',              'ko', 'D+2 출고 (할증 +10%)'),
        ('widget.card.due.d3',              'ko', 'D+3 일반 (할증 없음)'),
        ('widget.card.rule.pvc_no_coating', 'ko', '투명 PVC 용지는 별도 코팅이 적용되지 않습니다'),

        ('widget.card.step.size.title',     'en', 'Choose Size'),
        ('widget.card.step.paper.title',    'en', 'Choose Paper'),
        ('widget.card.step.coating.title',  'en', 'Choose Coating'),
        ('widget.card.step.qty.title',      'en', 'Choose Quantity'),
        ('widget.card.step.due.title',      'en', 'Choose Due Date'),
        ('widget.card.step.size.desc',      'en', 'Pick a business card size'),
        ('widget.card.step.paper.desc',     'en', 'Pick the paper to print on'),
        ('widget.card.step.coating.desc',   'en', 'Pick a surface coating finish'),
        ('widget.card.step.qty.desc',       'en', 'Pick the order quantity'),
        ('widget.card.step.due.desc',       'en', 'Pick your preferred delivery date'),
        ('widget.card.field.size.label',    'en', 'Size'),
        ('widget.card.field.paper.label',   'en', 'Paper'),
        ('widget.card.field.coating.label', 'en', 'Coating'),
        ('widget.card.field.qty.label',     'en', 'Quantity'),
        ('widget.card.field.due.label',     'en', 'Due Date'),
        ('widget.card.due.d1',              'en', 'Next-day (+20% rush)'),
        ('widget.card.due.d2',              'en', 'D+2 (+10% rush)'),
        ('widget.card.due.d3',              'en', 'D+3 standard (no surcharge)'),
        ('widget.card.rule.pvc_no_coating', 'en', 'Transparent PVC stock cannot accept additional coating');
END $$;


-- ---------------------------------------------------------------------
-- 10.9 Order seed: full order including user, quote, items, history,
--      artwork, payment, shipping
-- ---------------------------------------------------------------------
DO $$
DECLARE
    v_user_id           UUID := gen_random_uuid();
    v_quote_id          UUID := gen_random_uuid();
    v_order_id          UUID := gen_random_uuid();
    v_order_item_id     UUID := gen_random_uuid();

    v_product_id        UUID;
    v_now               TIMESTAMPTZ := NOW();
    v_order_number      VARCHAR(20) := 'PQ-20260507-0001';
    v_quote_number      VARCHAR(20) := 'QT-20260507-0001';
BEGIN
    SELECT id INTO v_product_id FROM products WHERE code = 'CARD_GENERAL_STD';
    IF v_product_id IS NULL THEN
        RAISE EXCEPTION 'Seed prerequisite missing: product CARD_GENERAL_STD';
    END IF;

    INSERT INTO users (id, email, name, phone, role, customer_grade, last_login_at)
    VALUES (v_user_id, 'jiny@example.com', '지니', '010-1234-5678', 'customer', 'gold', v_now);

    INSERT INTO quotes (
        id, user_id, quote_number, product_id,
        spec_snapshot, price_breakdown,
        total_amount, vat_amount, grand_total,
        status, expires_at, created_at, updated_at
    ) VALUES (
        v_quote_id, v_user_id, v_quote_number, v_product_id,
        jsonb_build_object(
            'product_code', 'CARD_GENERAL_STD',
            'product_name', '일반명함',
            'size',     jsonb_build_object('value','90x50','label','90 × 50 mm (표준)'),
            'paper',    jsonb_build_object('value','art_250','label','아트지 250g'),
            'coating',  jsonb_build_object('value','glossy','label','유광 라미'),
            'print',    jsonb_build_object('value','duplex_4','label','양면 4도(컬러)'),
            'quantity', 1000
        ),
        jsonb_build_object(
            'subtotal_print',     35000.00,
            'subtotal_finishing',  2000.00,
            'setup_fee',              0.00,
            'surcharge_total',        0.00,
            'discount_total',      1850.00,
            'shipping_fee',           0.00,
            'total_amount',       35150.00,
            'vat_amount',          3515.00,
            'grand_total',        38665.00,
            'currency',           'KRW'
        ),
        35150.00, 3515.00, 38665.00,
        'converted',
        v_now + INTERVAL '24 hours',
        v_now - INTERVAL '2 hours',
        v_now
    );

    INSERT INTO orders (
        id, user_id, quote_id, order_number, status,
        subtotal, finishing_total, setup_fee, surcharge_total,
        discount_total, shipping_fee, total_amount, vat_amount, grand_total,
        requested_delivery_date, confirmed_delivery_date, notes,
        created_at, updated_at
    ) VALUES (
        v_order_id, v_user_id, v_quote_id, v_order_number, 'file_approved',
        35000.00, 2000.00, 0, 0,
        1850.00, 0, 35150.00, 3515.00, 38665.00,
        (v_now + INTERVAL '3 days')::DATE,
        (v_now + INTERVAL '3 days')::DATE,
        '명함 표면이 균일하게 나오도록 부탁드립니다.',
        v_now - INTERVAL '90 minutes',
        v_now
    );

    INSERT INTO order_items (
        id, order_id, product_id, product_name_snapshot,
        spec_snapshot, price_snapshot,
        quantity, unit_price, total_price, created_at
    ) VALUES (
        v_order_item_id, v_order_id, v_product_id, '일반명함',
        jsonb_build_object(
            'product_code', 'CARD_GENERAL_STD',
            'product_name', '일반명함',
            'size',     jsonb_build_object('value','90x50','label','90 × 50 mm (표준)'),
            'paper',    jsonb_build_object('value','art_250','label','아트지 250g'),
            'coating',  jsonb_build_object('value','glossy','label','유광 라미'),
            'print',    jsonb_build_object('value','duplex_4','label','양면 4도(컬러)'),
            'quantity', 1000,
            'print_method', 'digital'
        ),
        jsonb_build_object(
            'unit_price',         35.00,
            'subtotal_print',     35000.00,
            'subtotal_finishing',  2000.00,
            'setup_fee',              0.00,
            'pricing_engine_version', '2026.04.01',
            'price_table_name',  '일반명함 디지털 표준 단가표 (2026)'
        ),
        1000, 35.00, 37000.00,
        v_now - INTERVAL '90 minutes'
    );

    INSERT INTO order_status_history (order_id, from_status, to_status, changed_by, changed_at, reason, metadata) VALUES
        (v_order_id, NULL,             'draft',           v_user_id, v_now - INTERVAL '90 minutes',
         '주문 생성',
         jsonb_build_object('source','user','quote_number',v_quote_number)),
        (v_order_id, 'draft',          'quote_confirmed', v_user_id, v_now - INTERVAL '85 minutes',
         '견적 확정',
         jsonb_build_object('source','user')),
        (v_order_id, 'quote_confirmed','payment_pending', v_user_id, v_now - INTERVAL '80 minutes',
         '결제 진입',
         jsonb_build_object('source','user','pg_provider','toss')),
        (v_order_id, 'payment_pending','payment_done',    NULL,      v_now - INTERVAL '75 minutes',
         'PG 결제 콜백 수신',
         jsonb_build_object('source','pg','pg_transaction_id','toss_txn_20260507_0001')),
        (v_order_id, 'payment_done',   'file_pending',    NULL,      v_now - INTERVAL '74 minutes',
         '결제 완료 자동 전이',
         jsonb_build_object('source','system')),
        (v_order_id, 'file_pending',   'file_review',     v_user_id, v_now - INTERVAL '60 minutes',
         '디자인 파일 업로드 완료',
         jsonb_build_object('source','user','file_count',1)),
        (v_order_id, 'file_review',    'file_approved',   NULL,      v_now - INTERVAL '20 minutes',
         '프리프레스 검수 통과',
         jsonb_build_object('source','operator','dpi',300,'color_mode','CMYK','bleed_mm',3));

    INSERT INTO artwork_files (
        order_item_id, original_filename, storage_key,
        file_size_bytes, mime_type, status,
        uploaded_at, reviewed_at, reviewer_id,
        rejection_reason, retry_count, prepress_notes
    ) VALUES (
        v_order_item_id,
        'jiny_card_v2.pdf',
        'artwork/2026/05/07/jiny_card_v2_8c4f.pdf',
        4823119,
        'application/pdf',
        'approved',
        v_now - INTERVAL '60 minutes',
        v_now - INTERVAL '20 minutes',
        NULL, NULL, 0,
        '해상도 300dpi / CMYK / 재단여백 3mm / 폰트 아웃라인 변환 OK'
    );

    INSERT INTO payments (
        order_id, pg_provider, pg_transaction_id, payment_method,
        amount, paid_at, status, receipt_url, created_at
    ) VALUES (
        v_order_id, 'toss', 'toss_txn_20260507_0001', 'card',
        38665.00,
        v_now - INTERVAL '75 minutes',
        'completed',
        'https://receipts.toss.example/r/20260507_0001',
        v_now - INTERVAL '76 minutes'
    );

    INSERT INTO shipping_info (
        order_id, recipient_name, recipient_phone,
        address_road, address_detail, postal_code,
        estimated_delivery
    ) VALUES (
        v_order_id, '지니', '010-1234-5678',
        '서울특별시 강남구 테헤란로 123', '4층 401호', '06234',
        (v_now + INTERVAL '3 days')::DATE
    );
END $$;


-- =====================================================================
-- End of integrated schema
-- =====================================================================
