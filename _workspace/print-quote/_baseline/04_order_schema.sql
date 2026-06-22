-- =====================================================================
-- Print Auto-Quote Service: Order Domain Schema (PostgreSQL)
-- =====================================================================
-- Author: order-specialist
-- Date: 2026-05-07
-- Source: _workspace/print-quote/01_research_report.md (Section 3)
-- Depends on: 02_product_schema.sql  (products)
--             03_pricing_schema.sql  (system_configs)
--
-- Design philosophy:
--   1. Snapshot strategy (RESEARCH §6.2):
--      Master data (products, prices, specs) evolves continuously.
--      Past orders MUST remain immutable for receipts, audits, refunds,
--      and tax filings. Therefore order_items stores `spec_snapshot` and
--      `price_snapshot` as JSONB at the moment of order creation. The
--      product_id FK is kept for navigation only — it must NEVER be
--      dereferenced to recompute price or spec for a historical order.
--   2. Soft delete for legal retention:
--      Orders and users carry `deleted_at TIMESTAMPTZ`. Korean commerce
--      law (전자상거래법) requires order retention for 5 years. Hard
--      delete would violate this; soft delete preserves the row while
--      hiding it from default queries (WHERE deleted_at IS NULL).
--   3. State machine as data, not code:
--      The 17-state lifecycle (research §3.1) is enforced via a CHECK
--      constraint on orders.status, and every transition is recorded in
--      order_status_history. This gives us an audit trail without
--      requiring an event-sourcing rewrite.
--   4. PCI-DSS compliance:
--      The `payments` table stores ONLY PG transaction tokens
--      (pg_transaction_id) and a payment_method enum. Card numbers, CVV,
--      and expiry dates are NEVER stored. The PG provider holds the PAN.
--   5. Idempotent payment callbacks:
--      pg_transaction_id is UNIQUE — duplicate webhook deliveries from
--      the PG (a common reality) cannot create duplicate payment rows.
--   6. Guest order support (research §3.4):
--      `users.guest_token` is a UUID-derived opaque token issued to a
--      non-member checkout. user_id remains the FK in orders/quotes; the
--      `role` and `email` are nullable so a single users row can serve
--      both authenticated customers and guests.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Extensions / shared trigger function (idempotent re-declaration)
-- ---------------------------------------------------------------------
-- WHY guarded: this domain may run after the product/pricing schemas or
-- standalone. CREATE OR REPLACE keeps the function single-sourced.
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =====================================================================
-- 1. users  (customers + operators + guests, single table)
-- =====================================================================
-- WHY one table for all actor types:
--   - Order/payment/file FKs all reference a single users.id, so role
--     based polymorphism stays in the application layer. A separate
--     `operators` table would force every audit FK to be a CHECK-on-two-
--     tables polymorphic mess.
-- WHY email and guest_token both nullable:
--   - Authenticated customer: email NOT NULL, guest_token NULL.
--   - Guest checkout: email NULL (or filled at checkout), guest_token
--     NOT NULL — used by the non-member 주문조회 flow (이메일 + 주문번호).
--   - Operator: email NOT NULL, guest_token NULL.
-- WHY customer_grade lives here (mirrors discount_policies grades):
--   - Pricing domain references the same grade vocabulary
--     ('normal','silver','gold','vip'). Keeping the enum identical means
--     the discount rule engine joins users.customer_grade ->
--     discount_policies.customer_grade with no translation layer.
-- =====================================================================
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
    deleted_at      TIMESTAMPTZ,                             -- soft delete

    CONSTRAINT chk_users_role
        CHECK (role IN ('customer', 'operator', 'admin')),

    CONSTRAINT chk_users_customer_grade
        CHECK (customer_grade IN ('normal', 'silver', 'gold', 'vip')),

    -- Either an email-bearing account or a guest token must exist.
    -- Operators always have email; guests always have a token.
    CONSTRAINT chk_users_identity_present
        CHECK (email IS NOT NULL OR guest_token IS NOT NULL)
);

CREATE INDEX idx_users_role_active        ON users (role) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_grade              ON users (customer_grade) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_created_at         ON users (created_at DESC);

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 2. quotes  (견적 — pre-order, expires in 24h)
-- =====================================================================
-- WHY quotes are separate from orders:
--   - Research §3.1: 견적은 주문 이전 단계(DRAFT → QUOTE_CONFIRMED).
--     Many quotes never convert; mixing them in `orders` would inflate
--     the table and pollute reporting. Conversion flips `status` to
--     'converted' and inserts a related `orders` row referencing it.
-- WHY 24h expiry:
--   - Pricing tables (price_tables.valid_to) and surcharge rules can
--     change overnight. A short TTL forces re-computation, preventing
--     stale-price fraud (저장된 견적을 한 달 뒤 결제하는 시나리오).
-- WHY price_breakdown JSONB:
--   - Storing the full computed breakdown (subtotal_print,
--     subtotal_finishing, surcharges, discounts, shipping_fee, vat) lets
--     the customer reload the quote without re-running the pricing
--     engine, and lets us show the exact same numbers when they convert.
-- =====================================================================
CREATE TABLE quotes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID,                                    -- nullable: guest quotes allowed
    quote_number    VARCHAR(20) NOT NULL UNIQUE,             -- e.g., 'QT-20260507-0001'
    product_id      UUID NOT NULL,
    spec_snapshot   JSONB NOT NULL,                          -- {size:..., paper:..., coating:..., qty:...}
    price_breakdown JSONB NOT NULL,                          -- {subtotal_print:..., finishing:..., surcharge:..., discount:..., shipping:..., vat:...}
    total_amount    NUMERIC(12,2) NOT NULL,                  -- 공급가 (pre-VAT)
    vat_amount      NUMERIC(12,2) NOT NULL,
    grand_total     NUMERIC(12,2) NOT NULL,                  -- total_amount + vat_amount
    status          VARCHAR(16) NOT NULL DEFAULT 'active',
    expires_at      TIMESTAMPTZ NOT NULL,                    -- typically NOW() + INTERVAL '24 hours'
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_quotes_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_quotes_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_quotes_status
        CHECK (status IN ('active', 'converted', 'expired', 'cancelled')),

    CONSTRAINT chk_quotes_amounts
        CHECK (total_amount >= 0 AND vat_amount >= 0 AND grand_total >= 0),

    CONSTRAINT chk_quotes_expiry
        CHECK (expires_at > created_at)
);

CREATE INDEX idx_quotes_user_created     ON quotes (user_id, created_at DESC);
CREATE INDEX idx_quotes_status_expires   ON quotes (status, expires_at) WHERE status = 'active';
CREATE INDEX idx_quotes_product          ON quotes (product_id);

CREATE TRIGGER trg_quotes_updated_at
    BEFORE UPDATE ON quotes
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 3. orders  (주문 마스터)
-- =====================================================================
-- WHY money is split across multiple columns (subtotal, finishing, ...):
--   - The receipt and tax invoice (세금계산서) must show each line. Re-
--     deriving them from a single grand_total + JSONB blob would force
--     a JSON parse on every receipt query. Materializing the line items
--     as columns gives O(1) reads and lets indexes / sums work.
-- WHY 17-state CHECK constraint:
--   - The state machine in research §3.1 is the contract between
--     customer-facing UI, ops dashboards, ERP, and the production team.
--     Enforcing it in the DB blocks application bugs from writing
--     non-existent statuses (e.g., 'PROCESSING') that would silently
--     break dashboards.
-- WHY soft delete (deleted_at):
--   - 전자상거래법 requires 5-year order retention. Cancelled orders are
--     marked status='cancelled', not removed; deleted_at is reserved
--     for true admin-initiated removals (e.g., GDPR-style requests),
--     and even then the row is hidden, not erased.
-- =====================================================================
CREATE TABLE orders (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                     UUID,                        -- nullable: guest orders
    quote_id                    UUID,                        -- nullable: direct order without quote
    order_number                VARCHAR(20) NOT NULL UNIQUE, -- 'PQ-YYYYMMDD-NNNN'
    status                      VARCHAR(32) NOT NULL DEFAULT 'draft',

    -- Money breakdown (research §2.1). All NUMERIC(12,2) = up to 9,999,999,999.99 KRW.
    subtotal                    NUMERIC(12,2) NOT NULL DEFAULT 0,    -- 본 인쇄비
    finishing_total             NUMERIC(12,2) NOT NULL DEFAULT 0,    -- 후가공비
    setup_fee                   NUMERIC(12,2) NOT NULL DEFAULT 0,    -- 옵셋 판비
    surcharge_total             NUMERIC(12,2) NOT NULL DEFAULT 0,    -- 할증
    discount_total              NUMERIC(12,2) NOT NULL DEFAULT 0,    -- 할인 (양수로 저장, 차감)
    shipping_fee                NUMERIC(12,2) NOT NULL DEFAULT 0,
    total_amount                NUMERIC(12,2) NOT NULL DEFAULT 0,    -- 공급가 합계
    vat_amount                  NUMERIC(12,2) NOT NULL DEFAULT 0,
    grand_total                 NUMERIC(12,2) NOT NULL DEFAULT 0,    -- 결제금액 = total + vat

    requested_delivery_date     DATE,
    confirmed_delivery_date     DATE,
    notes                       TEXT,

    cancelled_at                TIMESTAMPTZ,
    cancel_reason               TEXT,

    created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at                  TIMESTAMPTZ,                 -- soft delete

    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_orders_quote
        FOREIGN KEY (quote_id) REFERENCES quotes(id)
        ON DELETE SET NULL,

    -- 17-state machine (research §3.1)
    CONSTRAINT chk_orders_status CHECK (status IN (
        'draft',
        'quote_confirmed',
        'payment_pending',
        'payment_done',
        'file_pending',
        'file_review',
        'file_approved',
        'file_rejected',
        'in_production',
        'qc_pass',
        'shipped',
        'delivered',
        'completed',
        'cancelled',
        'refund_requested',
        'refunding',
        'refunded'
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

-- Hot-path indexes
CREATE INDEX idx_orders_user_created     ON orders (user_id, created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_orders_status_created   ON orders (status, created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_orders_quote            ON orders (quote_id) WHERE quote_id IS NOT NULL;
-- order_number is already UNIQUE → implicit btree index

CREATE TRIGGER trg_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- 4. order_items  (주문 라인 — snapshots are the source of truth)
-- =====================================================================
-- WHY product_name_snapshot is a real column (not just inside JSONB):
--   - Order list views ("내 주문 목록") read this column directly.
--     Pulling it out of JSONB keeps the listing query as a single index
--     scan, no JSON path operators required.
-- WHY price_snapshot stores the full breakdown:
--   - Refund calculations (research §3.3) need to know what each
--     component cost: e.g. "PREFLIGHT_DONE 이후 환불 시 CTP/판비 차감"
--     means we must subtract setup_fee from refund. The breakdown lives
--     here so refund logic can find it without re-querying pricing.
-- WHY quantity is a separate column (not inside spec_snapshot):
--   - Production batching (gang printing, research §5.3) groups by
--     (paper × coating × method × due_date) and SUMs quantity. A SQL
--     SUM(quantity) is far cheaper than SUM(spec_snapshot->'qty').
-- =====================================================================
CREATE TABLE order_items (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id                UUID NOT NULL,
    product_id              UUID NOT NULL,                   -- navigation only, NOT for re-pricing
    product_name_snapshot   VARCHAR(200) NOT NULL,
    spec_snapshot           JSONB NOT NULL,                  -- full spec object at order time
    price_snapshot          JSONB NOT NULL,                  -- full price breakdown at order time
    quantity                INT NOT NULL,
    unit_price              NUMERIC(12,2) NOT NULL,
    total_price             NUMERIC(12,2) NOT NULL,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_order_items_quantity CHECK (quantity > 0),
    CONSTRAINT chk_order_items_prices CHECK (
        unit_price >= 0 AND total_price >= 0
    )
);

CREATE INDEX idx_order_items_order        ON order_items (order_id);
CREATE INDEX idx_order_items_product      ON order_items (product_id);
-- GIN on spec_snapshot lets the production team find "all line items
-- using 무광 라미 within the cutoff window" without scanning every row.
CREATE INDEX idx_order_items_spec_gin     ON order_items USING GIN (spec_snapshot);


-- =====================================================================
-- 5. order_status_history  (audit trail for the state machine)
-- =====================================================================
-- WHY a dedicated table instead of a generic audit log:
--   - State transitions are a first-class business concern (refund
--     eligibility, ops SLAs, ERP integration). A specialized table with
--     typed columns makes "show me all orders that sat in FILE_REVIEW
--     for >4h" a one-shot query.
-- WHY changed_by is nullable:
--   - Some transitions are system-driven: cron expiring DRAFT quotes,
--     PG webhook flipping PAYMENT_PENDING -> PAYMENT_DONE. These rows
--     have changed_by NULL with metadata->>'source' = 'system' or 'pg'.
-- WHY metadata JSONB:
--   - Carries free-form context per transition (PG response payload,
--     QC inspector notes, retry counts) without requiring schema
--     changes for every new transition reason.
-- =====================================================================
CREATE TABLE order_status_history (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        UUID NOT NULL,
    from_status     VARCHAR(32),                             -- NULL on initial 'draft' insert
    to_status       VARCHAR(32) NOT NULL,
    changed_by      UUID,                                    -- nullable: system transitions
    changed_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    reason          TEXT,
    metadata        JSONB NOT NULL DEFAULT '{}'::jsonb,

    CONSTRAINT fk_order_status_history_order
        FOREIGN KEY (order_id) REFERENCES orders(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_order_status_history_user
        FOREIGN KEY (changed_by) REFERENCES users(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_order_status_history_to_status CHECK (to_status IN (
        'draft','quote_confirmed','payment_pending','payment_done',
        'file_pending','file_review','file_approved','file_rejected',
        'in_production','qc_pass','shipped','delivered','completed',
        'cancelled','refund_requested','refunding','refunded'
    ))
);

CREATE INDEX idx_order_status_history_order_time   ON order_status_history (order_id, changed_at DESC);
CREATE INDEX idx_order_status_history_to_time      ON order_status_history (to_status, changed_at DESC);


-- =====================================================================
-- 6. artwork_files  (디자인 파일 — 검수 흐름 포함)
-- =====================================================================
-- WHY a separate table from `orders` (1:N from order_items, not orders):
--   - Multi-line orders (예: 명함 + 봉투 한 번에) need per-line files
--     with independent review status. Attaching files to order_items
--     mirrors the production reality.
-- WHY storage_key (not file path on disk):
--   - Files live in object storage (S3/MinIO). storage_key is the
--     opaque object key; the app server resolves it to a presigned URL.
--     Storing a filesystem path would tie the schema to a single host.
-- WHY status flow pending -> reviewing -> approved/rejected:
--   - Mirrors research §3.2 review SLA. retry_count tracks how many
--     rejection cycles a line has gone through, surfacing problem
--     orders to the prepress lead.
-- =====================================================================
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
    prepress_notes      TEXT,                                -- 자동 검수 결과(해상도, 컬러모드 등)
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_artwork_files_order_item
        FOREIGN KEY (order_item_id) REFERENCES order_items(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_artwork_files_reviewer
        FOREIGN KEY (reviewer_id) REFERENCES users(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_artwork_files_status
        CHECK (status IN ('pending', 'reviewing', 'approved', 'rejected')),
    CONSTRAINT chk_artwork_files_file_size
        CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0),
    CONSTRAINT chk_artwork_files_retry
        CHECK (retry_count >= 0),
    -- A rejection requires both a reviewed_at and a reason.
    CONSTRAINT chk_artwork_files_rejection_consistency CHECK (
        status <> 'rejected'
        OR (reviewed_at IS NOT NULL AND rejection_reason IS NOT NULL)
    )
);

CREATE INDEX idx_artwork_files_item_status   ON artwork_files (order_item_id, status);
CREATE INDEX idx_artwork_files_status_queue  ON artwork_files (status, uploaded_at)
    WHERE status IN ('pending', 'reviewing');
CREATE INDEX idx_artwork_files_reviewer      ON artwork_files (reviewer_id)
    WHERE reviewer_id IS NOT NULL;


-- =====================================================================
-- 7. payments  (PG transactions — PCI-DSS scope minimization)
-- =====================================================================
-- WHY no card-level columns:
--   - PCI-DSS forbids storage of PAN/CVV/expiry outside certified
--     environments. We are NOT a PG; we delegate to one. The only proof
--     of payment we keep is the PG-side transaction id and a payment
--     method category for analytics.
-- WHY pg_transaction_id UNIQUE:
--   - PG webhooks frequently retry. Without a unique constraint, a
--     duplicate "payment_completed" callback would create two rows and
--     double-credit the order. The constraint converts retry into a
--     no-op INSERT ON CONFLICT.
-- WHY status includes 'partial_refund':
--   - Research §3.3: "FILE_APPROVED 이후 검수비 차감 환불". The order is
--     not fully refunded; the payment row tracks the actual refunded
--     amount via refund_amount.
-- =====================================================================
CREATE TABLE payments (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id            UUID NOT NULL,
    pg_provider         VARCHAR(50) NOT NULL,                -- 'toss', 'iamport', 'kakaopay', ...
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
        FOREIGN KEY (order_id) REFERENCES orders(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_payments_method CHECK (payment_method IN (
        'card', 'bank_transfer', 'virtual_account', 'kakao_pay', 'naver_pay'
    )),
    CONSTRAINT chk_payments_status CHECK (status IN (
        'pending', 'completed', 'failed', 'refunded', 'partial_refund'
    )),
    CONSTRAINT chk_payments_amount CHECK (amount >= 0),
    CONSTRAINT chk_payments_refund CHECK (
        refund_amount >= 0 AND refund_amount <= amount
    ),
    -- Completed payments must have a paid_at timestamp.
    CONSTRAINT chk_payments_completion_consistency CHECK (
        status NOT IN ('completed', 'refunded', 'partial_refund')
        OR paid_at IS NOT NULL
    )
);

CREATE INDEX idx_payments_order              ON payments (order_id);
CREATE INDEX idx_payments_status_paid_at     ON payments (status, paid_at DESC);
-- pg_transaction_id is already UNIQUE → idempotency lookups use that index.


-- =====================================================================
-- 8. shipping_info  (배송 — 1:1 with orders)
-- =====================================================================
-- WHY 1:1 (UNIQUE on order_id):
--   - The current scope is single-shipment-per-order. Split shipments
--     (분할배송) would require this to become 1:N — left as a future
--     migration so the simple case stays simple.
-- WHY recipient_* are duplicated even though users.name/phone exist:
--   - The recipient may differ from the buyer (선물 발송, 사무실 배송).
--     Snapshotting at order time also protects against the buyer later
--     editing their profile and corrupting the shipping label trail.
-- =====================================================================
CREATE TABLE shipping_info (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id                UUID NOT NULL UNIQUE,            -- 1:1 enforced
    carrier                 VARCHAR(100),
    tracking_number         VARCHAR(200),
    recipient_name          VARCHAR(100) NOT NULL,
    recipient_phone         VARCHAR(20) NOT NULL,
    address_road            VARCHAR(500) NOT NULL,           -- 도로명 주소
    address_detail          VARCHAR(200),
    postal_code             VARCHAR(10) NOT NULL,
    shipped_at              TIMESTAMPTZ,
    estimated_delivery      DATE,
    actual_delivery         TIMESTAMPTZ,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_shipping_info_order
        FOREIGN KEY (order_id) REFERENCES orders(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_shipping_info_delivery_order CHECK (
        actual_delivery IS NULL
        OR shipped_at IS NULL
        OR actual_delivery >= shipped_at
    )
);

CREATE INDEX idx_shipping_info_tracking      ON shipping_info (tracking_number)
    WHERE tracking_number IS NOT NULL;
CREATE INDEX idx_shipping_info_shipped_at    ON shipping_info (shipped_at DESC)
    WHERE shipped_at IS NOT NULL;

CREATE TRIGGER trg_shipping_info_updated_at
    BEFORE UPDATE ON shipping_info
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- =====================================================================
-- SEED DATA: 명함 1,000장 — 결제완료 / 파일승인 시점의 완전 주문 한 건
-- =====================================================================
-- This seed mirrors the SAMPLE PRICING QUERY in 03_pricing_schema.sql:
--   일반명함 1,000장, 양면 4도, 아트지 250g, 유광 라미.
-- Numbers (38,500 + 2,000 = 40,500 supply, 4,050 vat, 44,550 total)
-- match the formula in the price comment, with a Gold 5% discount applied:
--   subtotal_print     = 35,000
--   finishing_total    =  2,000   (유광 +2/장 × 1000)
--   discount_total     =  1,850   (5% of 37,000 = 1,850)
--   shipping_fee       =  3,000   (37,000 - 1,850 = 35,150 ≥ 30,000 → free? no: free threshold uses pre-discount supply 37,000 ≥ 30,000 → free=0)
--   For seed simplicity we set shipping_fee = 0 (>=30,000 free).
--   total_amount(공급) = 35,000 + 2,000 - 1,850 + 0 = 35,150
--   vat                = 3,515
--   grand_total        = 38,665
-- =====================================================================
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
    -- Resolve the seeded 일반명함 product (from 02_product_schema.sql)
    SELECT id INTO v_product_id FROM products WHERE code = 'CARD_GENERAL_STD';

    IF v_product_id IS NULL THEN
        RAISE EXCEPTION 'Seed prerequisite missing: product CARD_GENERAL_STD (run 02_product_schema.sql first)';
    END IF;

    -- 1) Customer (Gold tier)
    INSERT INTO users (id, email, name, phone, role, customer_grade, last_login_at)
    VALUES (
        v_user_id,
        'jiny@example.com',
        '지니',
        '010-1234-5678',
        'customer',
        'gold',
        v_now
    );

    -- 2) Quote (already converted)
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
            'size',      jsonb_build_object('value','90x50','label','90 × 50 mm (표준)'),
            'paper',     jsonb_build_object('value','art_250','label','아트지 250g'),
            'coating',   jsonb_build_object('value','glossy','label','유광 라미'),
            'print',     jsonb_build_object('value','duplex_4','label','양면 4도(컬러)'),
            'quantity',  1000
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

    -- 3) Order (status: file_approved — 파일 검수 통과, 생산 직전)
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

    -- 4) Order item (snapshots are the source of truth)
    INSERT INTO order_items (
        id, order_id, product_id, product_name_snapshot,
        spec_snapshot, price_snapshot,
        quantity, unit_price, total_price, created_at
    ) VALUES (
        v_order_item_id, v_order_id, v_product_id, '일반명함',
        jsonb_build_object(
            'product_code', 'CARD_GENERAL_STD',
            'product_name', '일반명함',
            'size',      jsonb_build_object('value','90x50','label','90 × 50 mm (표준)'),
            'paper',     jsonb_build_object('value','art_250','label','아트지 250g'),
            'coating',   jsonb_build_object('value','glossy','label','유광 라미'),
            'print',     jsonb_build_object('value','duplex_4','label','양면 4도(컬러)'),
            'quantity',  1000,
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

    -- 5) Status history (draft -> payment_done -> file_approved)
    INSERT INTO order_status_history (order_id, from_status, to_status, changed_by, changed_at, reason, metadata) VALUES
        (v_order_id, NULL,             'draft',          v_user_id, v_now - INTERVAL '90 minutes',
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

    -- 6) Artwork file (approved)
    INSERT INTO artwork_files (
        order_item_id, original_filename, storage_key,
        file_size_bytes, mime_type, status,
        uploaded_at, reviewed_at, reviewer_id,
        rejection_reason, retry_count, prepress_notes
    ) VALUES (
        v_order_item_id,
        'jiny_card_v2.pdf',
        'artwork/2026/05/07/jiny_card_v2_8c4f.pdf',
        4_823_119,
        'application/pdf',
        'approved',
        v_now - INTERVAL '60 minutes',
        v_now - INTERVAL '20 minutes',
        NULL,                                                -- reviewer is operator; left NULL in seed
        NULL,
        0,
        '해상도 300dpi / CMYK / 재단여백 3mm / 폰트 아웃라인 변환 OK'
    );

    -- 7) Payment (completed, idempotent token)
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

    -- 8) Shipping info (label not yet generated — file_approved only)
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
-- End of order domain schema
-- =====================================================================
