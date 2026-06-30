-- ================================================================
-- 069 무선·070 PUR 소프트커버책자 완전 동작화 적재 — 물리 백업(시점 스냅샷)
-- 생성: hsp-load-executor 2026-07-01 02:04 · 영향 테이블 영향 행 복제(COMMIT 전 선행)
-- 타임스탬프: 20260701_0204
-- 적재 대상: 신규 반제품 289/290/291/292 + 069/070 셋트행 + 부모 제본 바인딩 NO-OP
-- 백업 범위: 069/070/289~292가 PK/FK로 닿는 t_prd_* 행만(영향 행 한정 스냅샷).
--   ★289~292는 신규 mint(현재 0행)이므로 백업은 빈 스냅샷 = undo 시 "존재하면 삭제" 기준점.
--   ★069/070 셋트행·부모공식 바인딩은 현행 행 보존(멱등 UPDATE 시 원복용).
-- ================================================================

-- 1) t_prd_products (289~292 신규·069/070 부모)
DROP TABLE IF EXISTS bak_t_prd_products_setbuild_20260701_0204;
CREATE TABLE bak_t_prd_products_setbuild_20260701_0204 AS
SELECT * FROM t_prd_products
WHERE prd_cd IN ('PRD_000069','PRD_000070','PRD_000289','PRD_000290','PRD_000291','PRD_000292');

-- 2) t_prd_product_sets (069/070 셋트행 — 현재 0행 baseline)
DROP TABLE IF EXISTS bak_t_prd_product_sets_setbuild_20260701_0204;
CREATE TABLE bak_t_prd_product_sets_setbuild_20260701_0204 AS
SELECT * FROM t_prd_product_sets
WHERE prd_cd IN ('PRD_000069','PRD_000070');

-- 3) t_prd_product_sizes
DROP TABLE IF EXISTS bak_t_prd_product_sizes_setbuild_20260701_0204;
CREATE TABLE bak_t_prd_product_sizes_setbuild_20260701_0204 AS
SELECT * FROM t_prd_product_sizes
WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');

-- 4) t_prd_product_print_options
DROP TABLE IF EXISTS bak_t_prd_product_print_options_setbuild_20260701_0204;
CREATE TABLE bak_t_prd_product_print_options_setbuild_20260701_0204 AS
SELECT * FROM t_prd_product_print_options
WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');

-- 5) t_prd_product_materials
DROP TABLE IF EXISTS bak_t_prd_product_materials_setbuild_20260701_0204;
CREATE TABLE bak_t_prd_product_materials_setbuild_20260701_0204 AS
SELECT * FROM t_prd_product_materials
WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');

-- 6) t_prd_product_plate_sizes
DROP TABLE IF EXISTS bak_t_prd_product_plate_sizes_setbuild_20260701_0204;
CREATE TABLE bak_t_prd_product_plate_sizes_setbuild_20260701_0204 AS
SELECT * FROM t_prd_product_plate_sizes
WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');

-- 7) t_prd_product_processes (표지 코팅 290/292)
DROP TABLE IF EXISTS bak_t_prd_product_processes_setbuild_20260701_0204;
CREATE TABLE bak_t_prd_product_processes_setbuild_20260701_0204 AS
SELECT * FROM t_prd_product_processes
WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');

-- 8) t_prd_product_price_formulas (289/290/291/292 + 069/070 부모 제본 바인딩)
DROP TABLE IF EXISTS bak_t_prd_product_price_formulas_setbuild_20260701_0204;
CREATE TABLE bak_t_prd_product_price_formulas_setbuild_20260701_0204 AS
SELECT * FROM t_prd_product_price_formulas
WHERE prd_cd IN ('PRD_000069','PRD_000070','PRD_000289','PRD_000290','PRD_000291','PRD_000292');

-- 백업 행수 확인
SELECT 'products' tbl, count(*) FROM bak_t_prd_products_setbuild_20260701_0204
UNION ALL SELECT 'sets', count(*) FROM bak_t_prd_product_sets_setbuild_20260701_0204
UNION ALL SELECT 'sizes', count(*) FROM bak_t_prd_product_sizes_setbuild_20260701_0204
UNION ALL SELECT 'print_options', count(*) FROM bak_t_prd_product_print_options_setbuild_20260701_0204
UNION ALL SELECT 'materials', count(*) FROM bak_t_prd_product_materials_setbuild_20260701_0204
UNION ALL SELECT 'plate_sizes', count(*) FROM bak_t_prd_product_plate_sizes_setbuild_20260701_0204
UNION ALL SELECT 'processes', count(*) FROM bak_t_prd_product_processes_setbuild_20260701_0204
UNION ALL SELECT 'price_formulas', count(*) FROM bak_t_prd_product_price_formulas_setbuild_20260701_0204
ORDER BY tbl;
