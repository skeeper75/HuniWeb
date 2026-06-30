-- ================================================================
-- 실 COMMIT 래핑본 — leather-hardcover-077 적재본 (단일 트랜잭션·인간 승인 완료)
-- BEGIN…COMMIT 외부 래핑. ON_ERROR_STOP=1 → 부분실패 시 전체 자동 ROLLBACK.
-- ================================================================
BEGIN;
\i :loadsql
\echo '=== COMMIT 직전 검증 (077=5행·285 mint·바인딩 2) ==='
SELECT 'set_rows_077' AS chk, count(*) AS n FROM t_prd_product_sets WHERE prd_cd='PRD_000077' AND del_yn='N'
UNION ALL SELECT 'formula_bind', count(*) FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000077','PRD_000285')
UNION ALL SELECT 'product_285', count(*) FROM t_prd_products WHERE prd_cd='PRD_000285'
ORDER BY chk;
COMMIT;
\echo '=== COMMIT 완료 ==='
