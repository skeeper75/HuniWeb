-- ============================================================================
-- backup.sql — 엽서북(PRD_000094) 셋트 보정 적재 물리 백업 (시점 스냅샷)
-- 생성: hsp-load-executor · 시점 = 2026-06-24 06:00 (suffix _setbuild_20260624_0600)
-- 영향 행만 스냅샷: t_prd_product_sets(94의 셋트행 2개) · t_prd_products(94 행)
-- undo 복원의 원천. 백업 테이블은 t_* 도메인 밖(bak_* 접두) — 적재 대상 아님.
-- ============================================================================

-- [1] 셋트행 백업 (94 → 95·96)
CREATE TABLE IF NOT EXISTS bak_t_prd_product_sets_setbuild_20260624_0600 AS
SELECT * FROM t_prd_product_sets WHERE prd_cd = 'PRD_000094';

-- [2] 부모 상품행 백업 (94)
CREATE TABLE IF NOT EXISTS bak_t_prd_products_setbuild_20260624_0600 AS
SELECT * FROM t_prd_products WHERE prd_cd = 'PRD_000094';

-- 백업 행수 검증
SELECT 'bak_sets'  AS tbl, count(*) AS rows FROM bak_t_prd_product_sets_setbuild_20260624_0600
UNION ALL
SELECT 'bak_prod' AS tbl, count(*) AS rows FROM bak_t_prd_products_setbuild_20260624_0600;
