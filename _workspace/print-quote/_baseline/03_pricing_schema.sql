-- =====================================================================
-- Print Auto-Quote Service: Pricing Domain Schema (PostgreSQL)
-- =====================================================================
-- Author: pricing-specialist
-- Date: 2026-05-07
-- Source: _workspace/print-quote/01_research_report.md (Section 2)
-- Depends on: 02_product_schema.sql  (products, product_spec_options)
--
-- Pricing formula (research §2.1):
--   견적금액 = (기본단가 × 수량) + 후가공비 + 셋업비 + 할증 - 할인 + 배송비
--   부가세는 공급가액 × VAT_RATE (system_configs)
--
-- Design philosophy:
--   1. Time-versioned tables (valid_from / valid_to) so historical orders
--      can always be re-priced. Past quotes never break when prices change.
--   2. Method-aware: digital (no setup), offset (setup_fee per qty break),
--      wide_format (area-based) all share the same price_tables backbone.
--   3. Step pricing: quantity_price_breaks uses [qty_from, qty_to] ranges
--      with qty_to NULL meaning "and above". Research §2.2 shows step
--      pricing is the Korean industry standard, not interpolation.
--   4. Surcharge/discount as data, not code: condition_value JSONB lets
--      ops add new rules ("주말 배송 +15%", "VIP 추가 5%") via INSERT.
--   5. Money is NUMERIC(12,2). cost_value for spec_option_surcharges uses
--      NUMERIC(12,4) because percentage type stores 0.0500 (= 5%).
-- =====================================================================

-- ---------------------------------------------------------------------
-- updated_at trigger function (created in product schema; guard re-run)
-- ---------------------------------------------------------------------
-- WHY guarded: this domain may be deployed standalone or after the
-- product domain. CREATE OR REPLACE is idempotent for the function;
-- triggers themselves are created per-table below.
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =====================================================================
-- 0. system_configs  (global runtime constants)
-- =====================================================================
-- WHY a key/value table over hardcoded constants:
--   - VAT can change (e.g. 한국 VAT 10% → law-driven adjustments).
--     Keeping it in DB lets accounting flip the rate without redeploys.
--   - CURRENCY is a single source of truth for the pricing engine; if a
--     subsidiary ever ships in JPY, only this row + FX table change.
-- =====================================================================
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
-- 1. price_tables  (master: product × print_method × validity window)
-- =====================================================================
-- WHY one row per (product, print_method, validity period):
--   - Same product (일반명함) is priced very differently under digital
--     (no setup) vs offset (15,000원 판비). The print method must be a
--     first-class dimension, not an attribute on each break row.
--   - valid_from / valid_to enable historical re-pricing for refunds and
--     audits. is_active is a soft-disable flag for promotional tables.
-- WHY no UNIQUE on (product_id, print_method):
--   - Multiple overlapping tables can be valid (e.g., a promo table that
--     supersedes the standard one). Selection logic picks the most
--     specific by valid_from DESC, is_active=TRUE.
-- =====================================================================
CREATE TABLE price_tables (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      UUID NOT NULL,
    name            VARCHAR(128) NOT NULL,
    print_method    VARCHAR(16) NOT NULL,
    currency        CHAR(3) NOT NULL DEFAULT 'KRW',
    valid_from      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    valid_to        TIMESTAMPTZ,                          -- NULL = open-ended
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    notes           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_price_tables_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_price_tables_print_method
        CHECK (print_method IN ('offset', 'digital', 'wide_format')),

    CONSTRAINT chk_price_tables_validity_window
        CHECK (valid_to IS NULL OR valid_to > valid_from)
);

CREATE INDEX idx_price_tables_product_method_active
    ON price_tables (product_id, print_method, is_active);
CREATE INDEX idx_price_tables_validity
    ON price_tables (product_id, valid_from, valid_to);

CREATE TRIGGER trg_price_tables_updated_at
    BEFORE UPDATE ON price_tables
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 2. quantity_price_breaks  (step pricing: qty range -> unit price)
-- =====================================================================
-- WHY [qty_from, qty_to] range with qty_to nullable:
--   - Research §2.2 shows Korean print prices follow stepwise quantity
--     curves: 1-50@200, 51-100@80, 101-500@50, ... NULL upper bound is
--     "and above" — avoiding a sentinel like 999_999_999.
-- WHY setup_fee per break (not per table):
--   - Offset setup is paid once per job; digital is 0. Some products
--     differentiate setup by quantity (very small runs may waive it).
--     Storing it on the break row keeps the model flexible.
-- =====================================================================
CREATE TABLE quantity_price_breaks (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    price_table_id  UUID NOT NULL,
    qty_from        INT NOT NULL,
    qty_to          INT,                                   -- NULL = unlimited
    unit_price      NUMERIC(12,2) NOT NULL,                -- 원/장
    setup_fee       NUMERIC(12,2) NOT NULL DEFAULT 0,      -- 옵셋 판비
    sort_order      INTEGER NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_quantity_price_breaks_table
        FOREIGN KEY (price_table_id) REFERENCES price_tables(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_quantity_price_breaks_range
        CHECK (qty_from >= 1 AND (qty_to IS NULL OR qty_to >= qty_from)),

    CONSTRAINT chk_quantity_price_breaks_amounts
        CHECK (unit_price >= 0 AND setup_fee >= 0)
);

-- Lookup pattern: given (price_table_id, qty), find the break whose
-- range contains qty. Composite index serves WHERE price_table_id=? AND
-- qty_from <= ? AND (qty_to IS NULL OR qty_to >= ?).
CREATE INDEX idx_quantity_price_breaks_table_range
    ON quantity_price_breaks (price_table_id, qty_from, qty_to);

CREATE TRIGGER trg_quantity_price_breaks_updated_at
    BEFORE UPDATE ON quantity_price_breaks
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 3. spec_option_surcharges  (per-spec-option price modifiers)
-- =====================================================================
-- WHY cost_type with three modes:
--   - per_unit: 코팅 +2원/장 (multiplied by quantity)
--   - fixed:    박 판비 +5,000원 (one-time charge)
--   - percentage: 친환경지 +30% (applied to base 인쇄비)
--   These three cover every finishing/spec surcharge in research §2.3.
-- WHY NUMERIC(12,4) for cost_value (not 12,2):
--   - per_unit values are whole won; fixed values are whole won; but
--     percentage values are stored as 0.3000 (= 30%). 4 fractional
--     digits accommodate fine percentages without precision loss.
-- =====================================================================
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
        FOREIGN KEY (price_table_id) REFERENCES price_tables(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_spec_option_surcharges_option
        FOREIGN KEY (spec_option_id) REFERENCES product_spec_options(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_spec_option_surcharges_cost_type
        CHECK (cost_type IN ('per_unit', 'fixed', 'percentage')),

    CONSTRAINT chk_spec_option_surcharges_value
        CHECK (cost_value >= 0),

    CONSTRAINT uq_spec_option_surcharges_table_option
        UNIQUE (price_table_id, spec_option_id)
);

CREATE INDEX idx_spec_option_surcharges_table   ON spec_option_surcharges (price_table_id);
CREATE INDEX idx_spec_option_surcharges_option  ON spec_option_surcharges (spec_option_id);

CREATE TRIGGER trg_spec_option_surcharges_updated_at
    BEFORE UPDATE ON spec_option_surcharges
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 4. surcharge_rules  (conditional surcharges: rush, weekend, etc.)
-- =====================================================================
-- WHY condition_value as JSONB:
--   - Conditions are heterogeneous: "due_date == today" needs a date,
--     "delivery_day_of_week IN (6)" needs an array. JSONB lets a single
--     rules engine evaluate any condition shape via condition_type as
--     dispatch key (e.g. 'rush_delivery', 'weekend_delivery', 'holiday',
--     'oversized', 'spot_color'). New types = new dispatch case in app
--     code, no migration.
-- WHY priority INT (lower = first):
--   - Multiple surcharges can match. Priority decides evaluation order
--     and prevents stacking surprises (e.g. apply 긴급 before 토요일).
-- =====================================================================
CREATE TABLE surcharge_rules (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                VARCHAR(128) NOT NULL,
    condition_type      VARCHAR(32) NOT NULL,             -- e.g. 'rush_delivery'
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

    CONSTRAINT chk_surcharge_rules_surcharge_type
        CHECK (surcharge_type IN ('percentage', 'fixed')),

    CONSTRAINT chk_surcharge_rules_value
        CHECK (surcharge_value >= 0),

    CONSTRAINT chk_surcharge_rules_validity
        CHECK (valid_to IS NULL OR valid_to > valid_from)
);

CREATE INDEX idx_surcharge_rules_active_priority
    ON surcharge_rules (is_active, priority) WHERE is_active = TRUE;
CREATE INDEX idx_surcharge_rules_condition_type
    ON surcharge_rules (condition_type) WHERE is_active = TRUE;
CREATE INDEX idx_surcharge_rules_condition_value_gin
    ON surcharge_rules USING GIN (condition_value);

CREATE TRIGGER trg_surcharge_rules_updated_at
    BEFORE UPDATE ON surcharge_rules
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 5. discount_policies  (membership / coupon / threshold discounts)
-- =====================================================================
-- WHY customer_grade as a CHECK column on discount, not on customer:
--   - Discount eligibility is a property of the discount policy, not the
--     customer. A customer's tier lives in customer/account schemas; the
--     policy only declares "this discount applies if grade >= silver".
-- WHY discount_type 'free_shipping' alongside percentage/fixed:
--   - Research §2.4 shows free shipping is a common promotional shape.
--     Modeling it as a discount type lets the same engine handle it
--     (set discount_value = base_fee at pricing time).
-- =====================================================================
CREATE TABLE discount_policies (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                    VARCHAR(128) NOT NULL,
    discount_type           VARCHAR(16) NOT NULL,
    discount_value          NUMERIC(12,2) NOT NULL,
    min_order_amount        NUMERIC(12,2) NOT NULL DEFAULT 0,
    max_discount_amount     NUMERIC(12,2),                       -- NULL = no cap
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
        CHECK (discount_value >= 0
               AND min_order_amount >= 0
               AND (max_discount_amount IS NULL OR max_discount_amount >= 0)),

    CONSTRAINT chk_discount_policies_validity
        CHECK (valid_to IS NULL OR valid_to > valid_from)
);

CREATE INDEX idx_discount_policies_grade_active
    ON discount_policies (customer_grade, is_active) WHERE is_active = TRUE;
CREATE INDEX idx_discount_policies_validity
    ON discount_policies (valid_from, valid_to) WHERE is_active = TRUE;

CREATE TRIGGER trg_discount_policies_updated_at
    BEFORE UPDATE ON discount_policies
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 6. shipping_fee_rules  (region × free-threshold × base × express)
-- =====================================================================
-- WHY region_group (not raw zip code):
--   - Korean shipping is tiered by region group: 수도권 / 지방 / 도서산간.
--     Mapping zip -> region_group is an app concern; the table stores
--     the canonical groups so ops can change fees per region in one row.
-- WHY express_surcharge as a column (not a separate row):
--   - Express is always a delta on top of base, never standalone. A
--     column makes the relationship explicit and avoids three-join
--     fee math at quote time.
-- =====================================================================
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
        CHECK (min_amount_for_free >= 0
               AND base_fee >= 0
               AND express_surcharge >= 0),

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
-- SEED DATA
-- =====================================================================
-- Seeds assume the product schema seed (일반명함) has already populated
-- products.code = 'CARD_GENERAL_STD' and the four coating options
-- (none/glossy/matte/uv). UUIDs are looked up by stable codes/values.
-- =====================================================================

-- ---------------------------------------------------------------------
-- system_configs
-- ---------------------------------------------------------------------
INSERT INTO system_configs (config_key, config_value, description) VALUES
    ('VAT_RATE', '0.1',  '한국 부가가치세율 (공급가 × 0.1 = 부가세)'),
    ('CURRENCY', 'KRW',  '기본 통화 코드 (ISO 4217)');


-- ---------------------------------------------------------------------
-- 일반명함 × digital 가격표 + 수량 구간 + 코팅 단가 + 할증/할인/배송비
-- ---------------------------------------------------------------------
DO $$
DECLARE
    v_product_id        UUID;
    v_price_table_id    UUID := gen_random_uuid();

    v_opt_coat_glos     UUID;
    v_opt_coat_matt     UUID;
    v_opt_coat_uv       UUID;
BEGIN
    -- Resolve product
    SELECT id INTO v_product_id
    FROM products WHERE code = 'CARD_GENERAL_STD';

    IF v_product_id IS NULL THEN
        RAISE EXCEPTION 'Seed prerequisite missing: product CARD_GENERAL_STD (run product schema seed first)';
    END IF;

    -- Resolve coating options (joined via product_specifications)
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

    -- price_tables (digital, no setup)
    INSERT INTO price_tables (id, product_id, name, print_method, currency, valid_from, is_active, notes)
    VALUES (v_price_table_id, v_product_id,
            '일반명함 디지털 표준 단가표 (2026)',
            'digital', 'KRW', NOW(), TRUE,
            '디지털 인쇄 기준 / 셋업비 0원 / 양면 4도 기본');

    -- quantity_price_breaks (research §2.2 + skill seed)
    INSERT INTO quantity_price_breaks (price_table_id, qty_from, qty_to, unit_price, setup_fee, sort_order) VALUES
        (v_price_table_id,    1,    50, 200.00, 0, 10),
        (v_price_table_id,   51,   100,  80.00, 0, 20),
        (v_price_table_id,  101,   500,  50.00, 0, 30),
        (v_price_table_id,  501,  1000,  35.00, 0, 40),
        (v_price_table_id, 1001,  NULL,  28.00, 0, 50);

    -- spec_option_surcharges (코팅 추가비)
    INSERT INTO spec_option_surcharges (price_table_id, spec_option_id, cost_type, cost_value, description) VALUES
        (v_price_table_id, v_opt_coat_glos, 'per_unit', 2.0000, '유광 라미네이팅 +2원/장'),
        (v_price_table_id, v_opt_coat_matt, 'per_unit', 3.0000, '무광 라미네이팅 +3원/장'),
        (v_price_table_id, v_opt_coat_uv,   'per_unit', 5.0000, 'UV 코팅 +5원/장');
END $$;


-- ---------------------------------------------------------------------
-- surcharge_rules (할증)
-- ---------------------------------------------------------------------
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


-- ---------------------------------------------------------------------
-- discount_policies (할인)
-- ---------------------------------------------------------------------
INSERT INTO discount_policies (name, discount_type, discount_value,
                                min_order_amount, max_discount_amount,
                                customer_grade, description)
VALUES
    ('Gold 회원 5% 할인',
     'percentage', 5.00,  0, NULL, 'gold',
     'Gold 등급 회원 자동 적용 5% 할인'),

    ('VIP 회원 10% 할인',
     'percentage', 10.00, 0, NULL, 'vip',
     'VIP 등급 회원 자동 적용 10% 할인');


-- ---------------------------------------------------------------------
-- shipping_fee_rules (배송비)
-- ---------------------------------------------------------------------
INSERT INTO shipping_fee_rules (region_group, min_amount_for_free, base_fee, express_surcharge, description)
VALUES
    ('default', 30000.00, 3000.00, 5000.00,
     '전국 공통 / 30,000원 이상 무료 / 미만 3,000원 / 퀵배송 +5,000원');


-- =====================================================================
-- SAMPLE PRICING QUERY
-- =====================================================================
-- Goal: 일반명함 1,000장 + 유광코팅, digital, 일반 회원, 수도권 배송 견적
--
-- Pricing formula breakdown (research §2.1):
--   subtotal_print     = unit_price × qty                 (수량 구간)
--   subtotal_finishing = Σ surcharge per spec option       (코팅)
--   setup              = setup_fee from break              (digital = 0)
--   surcharge          = subtotal × surcharge_rule.value   (적용 시)
--   discount           = subtotal × discount.value         (적용 시)
--   shipping_fee       = base_fee or 0 (free threshold)
--   supply_amount      = subtotal_print + subtotal_finishing + setup
--                        + surcharge - discount + shipping_fee
--   vat                = supply_amount × VAT_RATE
--   total              = supply_amount + vat
-- =====================================================================

-- The query below returns a single row with the full price breakdown.
-- Replace :qty and :customer_grade as desired.

WITH params AS (
    SELECT
        'CARD_GENERAL_STD'::VARCHAR AS product_code,
        'digital'::VARCHAR          AS print_method,
        1000::INT                   AS qty,
        ARRAY['glossy']::VARCHAR[]  AS coating_values,
        'normal'::VARCHAR           AS customer_grade,
        'default'::VARCHAR          AS region_group,
        FALSE::BOOLEAN              AS is_rush,
        FALSE::BOOLEAN              AS is_express
),
resolved AS (
    SELECT
        p.id  AS product_id,
        pt.id AS price_table_id,
        params.qty,
        params.coating_values,
        params.customer_grade,
        params.region_group,
        params.is_rush,
        params.is_express
    FROM params
    JOIN products p     ON p.code = params.product_code
    JOIN price_tables pt
         ON pt.product_id = p.id
        AND pt.print_method = params.print_method
        AND pt.is_active = TRUE
        AND pt.valid_from <= NOW()
        AND (pt.valid_to IS NULL OR pt.valid_to > NOW())
),
qty_break AS (
    SELECT r.*, qpb.unit_price, qpb.setup_fee
    FROM resolved r
    JOIN quantity_price_breaks qpb
         ON qpb.price_table_id = r.price_table_id
        AND qpb.qty_from <= r.qty
        AND (qpb.qty_to IS NULL OR qpb.qty_to >= r.qty)
),
finishing AS (
    SELECT
        qb.price_table_id,
        COALESCE(SUM(
            CASE sos.cost_type
                WHEN 'per_unit'   THEN sos.cost_value * qb.qty
                WHEN 'fixed'      THEN sos.cost_value
                WHEN 'percentage' THEN qb.unit_price * qb.qty * sos.cost_value
            END
        ), 0)::NUMERIC(12,2) AS finishing_total
    FROM qty_break qb
    LEFT JOIN spec_option_surcharges sos
           ON sos.price_table_id = qb.price_table_id
    LEFT JOIN product_spec_options pso ON pso.id = sos.spec_option_id
    LEFT JOIN product_specifications ps ON ps.id = pso.spec_id
    WHERE pso.value = ANY ((SELECT coating_values FROM resolved)::TEXT[])
       OR pso.id IS NULL
    GROUP BY qb.price_table_id
),
calc AS (
    SELECT
        qb.qty,
        qb.unit_price,
        qb.setup_fee,
        (qb.unit_price * qb.qty)::NUMERIC(12,2)              AS subtotal_print,
        COALESCE(f.finishing_total, 0)                        AS subtotal_finishing,
        qb.customer_grade,
        qb.region_group,
        qb.is_rush
    FROM qty_break qb
    LEFT JOIN finishing f ON f.price_table_id = qb.price_table_id
),
with_surcharge AS (
    SELECT
        c.*,
        CASE WHEN c.is_rush THEN
            ROUND(c.subtotal_print * (
                SELECT surcharge_value / 100.0
                FROM surcharge_rules
                WHERE condition_type = 'rush_delivery' AND is_active = TRUE
                LIMIT 1
            ), 2)
        ELSE 0::NUMERIC(12,2) END AS surcharge_amount
    FROM calc c
),
with_discount AS (
    SELECT
        ws.*,
        COALESCE((
            SELECT ROUND(
                (ws.subtotal_print + ws.subtotal_finishing) * (dp.discount_value / 100.0),
                2)
            FROM discount_policies dp
            WHERE dp.customer_grade = ws.customer_grade
              AND dp.is_active = TRUE
              AND dp.discount_type = 'percentage'
              AND dp.valid_from <= NOW()
              AND (dp.valid_to IS NULL OR dp.valid_to > NOW())
            ORDER BY dp.discount_value DESC
            LIMIT 1
        ), 0)::NUMERIC(12,2) AS discount_amount
    FROM with_surcharge ws
),
with_shipping AS (
    SELECT
        wd.*,
        (
            SELECT CASE
                WHEN (wd.subtotal_print + wd.subtotal_finishing
                      + wd.setup_fee + wd.surcharge_amount - wd.discount_amount)
                     >= sfr.min_amount_for_free THEN 0::NUMERIC(12,2)
                ELSE sfr.base_fee
            END
            FROM shipping_fee_rules sfr
            WHERE sfr.region_group = wd.region_group
              AND sfr.is_active = TRUE
            LIMIT 1
        ) AS shipping_fee
    FROM with_discount wd
)
SELECT
    qty,
    unit_price,
    subtotal_print,
    subtotal_finishing,
    setup_fee,
    surcharge_amount,
    discount_amount,
    shipping_fee,
    (subtotal_print + subtotal_finishing + setup_fee
       + surcharge_amount - discount_amount + shipping_fee)::NUMERIC(12,2) AS supply_amount,
    ROUND(
        (subtotal_print + subtotal_finishing + setup_fee
         + surcharge_amount - discount_amount + shipping_fee)
        * (SELECT config_value::NUMERIC FROM system_configs WHERE config_key = 'VAT_RATE'),
        2)::NUMERIC(12,2) AS vat,
    ROUND(
        (subtotal_print + subtotal_finishing + setup_fee
         + surcharge_amount - discount_amount + shipping_fee)
        * (1 + (SELECT config_value::NUMERIC FROM system_configs WHERE config_key = 'VAT_RATE')),
        2)::NUMERIC(12,2) AS total_amount
FROM with_shipping;

-- Expected for 명함 1,000장 + 유광코팅 (digital, 일반회원, 수도권):
--   unit_price          = 35.00
--   subtotal_print      = 35,000.00     (35 × 1000)
--   subtotal_finishing  = 2,000.00      (유광 2원/장 × 1000)
--   setup_fee           = 0
--   surcharge_amount    = 0             (긴급 아님)
--   discount_amount     = 0             (normal 등급)
--   shipping_fee        = 0             (37,000 ≥ 30,000 무료)
--   supply_amount       = 37,000.00
--   vat                 = 3,700.00
--   total_amount        = 40,700.00

-- =====================================================================
-- End of pricing domain schema
-- =====================================================================
