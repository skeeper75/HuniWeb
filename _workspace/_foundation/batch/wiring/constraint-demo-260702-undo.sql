-- 제약조건데모 undo (2026-07-02) — 물리 DELETE (데모 신규행이므로 안전; 사전 백업 확인됨: 두 상품 제약 0행)
BEGIN;
DELETE FROM t_prd_product_constraints
WHERE prd_cd IN ('PRD_000129','PRD_000130') AND rule_cd = 'R_DEMO_MATSIZ';
COMMIT;
