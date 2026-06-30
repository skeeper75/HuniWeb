-- ================================================================
-- 롤백전용 DRY-RUN — leather-hardcover-077 적재본 (멱등·제약위반·예상 카운트 실증)
-- BEGIN…ROLLBACK 래핑 (라이브 쓰기 0). 적재 SQL 자체에는 BEGIN/COMMIT 미내장.
-- ================================================================
BEGIN;

\echo '=== [1회차] 적재 SQL 적용 ==='
\i :loadsql

\echo '=== [1회차 후] 예상 카운트 ==='
SELECT 'set_rows_077' AS chk, count(*) AS n FROM t_prd_product_sets WHERE prd_cd='PRD_000077' AND del_yn='N'
UNION ALL SELECT 'formula_077', count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000077'
UNION ALL SELECT 'formula_285', count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000285'
UNION ALL SELECT 'product_285', count(*) FROM t_prd_products WHERE prd_cd='PRD_000285'
UNION ALL SELECT 'sizes_285', count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000285' AND del_yn='N'
UNION ALL SELECT 'popt_285', count(*) FROM t_prd_product_print_options WHERE prd_cd='PRD_000285' AND del_yn='N'
UNION ALL SELECT 'mat_285', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000285' AND del_yn='N'
UNION ALL SELECT 'plate_285', count(*) FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000285' AND del_yn='N'
ORDER BY chk;

\echo '=== disp_seq 단조성 (1~5 기대) ==='
SELECT sub_prd_cd, disp_seq, sub_prd_qty, min_cnt, max_cnt, cnt_incr FROM t_prd_product_sets WHERE prd_cd='PRD_000077' AND del_yn='N' ORDER BY disp_seq;

\echo '=== [2회차] 멱등 재적용 (delta 0 기대) ==='
\i :loadsql

\echo '=== [2회차 후] 카운트 불변 확인 (1회차와 동일해야 멱등) ==='
SELECT 'set_rows_077' AS chk, count(*) AS n FROM t_prd_product_sets WHERE prd_cd='PRD_000077' AND del_yn='N'
UNION ALL SELECT 'formula_077', count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000077'
UNION ALL SELECT 'formula_285', count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000285'
UNION ALL SELECT 'product_285', count(*) FROM t_prd_products WHERE prd_cd='PRD_000285'
ORDER BY chk;

\echo '=== 복합PK 중복 검사 (077 셋트행·0 기대) ==='
SELECT sub_prd_cd, count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000077' GROUP BY sub_prd_cd HAVING count(*)>1;

\echo '=== ROLLBACK (라이브 쓰기 0) ==='
ROLLBACK;

\echo '=== ROLLBACK 후 baseline 복귀 확인 (077=4행·285 부재 기대) ==='
SELECT 'set_rows_077_after_rb' AS chk, count(*) AS n FROM t_prd_product_sets WHERE prd_cd='PRD_000077' AND del_yn='N'
UNION ALL SELECT 'product_285_after_rb', count(*) FROM t_prd_products WHERE prd_cd='PRD_000285'
ORDER BY chk;
