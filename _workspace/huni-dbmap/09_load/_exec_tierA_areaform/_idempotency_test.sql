-- 멱등 2회차 + L2-순수(L1 미생성) 검증 (BEGIN → L2 apply×2 → 행수 동일 → ROLLBACK). NEVER COMMIT.
-- [FINDING-1] _l1_link_preload.sql 미포함 — apply.sql(L2 순수)이 L1 차원행을 생성하지 않음을 재확인.
BEGIN;
-- L1 baseline 측정 (139 product-materials/processes — L2 적재 전후 불변이어야)
\echo '=== L1 baseline (139 LINK) BEFORE L2 apply ==='
SELECT 'l1_139_mat' AS t, count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000139'
UNION ALL SELECT 'l1_139_proc', count(*) FROM t_prd_product_processes WHERE prd_cd='PRD_000139';

\i 02_t_prd_product_option_groups.sql
\i 03_t_prd_product_options.sql
\i 04_t_prd_product_option_items.sql
\i 05_t_prd_product_constraints.sql
\echo '=== PASS 2 (멱등 재실행 — 모든 INSERT 0행이어야 함) ==='
\i 02_t_prd_product_option_groups.sql
\i 03_t_prd_product_options.sql
\i 04_t_prd_product_option_items.sql
\i 05_t_prd_product_constraints.sql

\echo '=== L1 (139 LINK) AFTER L2 apply — baseline 과 동일해야(L2 가 L1 미생성) ==='
SELECT 'l1_139_mat' AS t, count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000139'
UNION ALL SELECT 'l1_139_proc', count(*) FROM t_prd_product_processes WHERE prd_cd='PRD_000139';

\echo '=== 최종 L2 적재 행수 (1회차==2회차 동일) ==='
SELECT 'option_groups' AS t, count(*) FROM t_prd_product_option_groups WHERE prd_cd IN ('PRD_000118','PRD_000120','PRD_000121','PRD_000122','PRD_000124','PRD_000125','PRD_000133','PRD_000134','PRD_000135','PRD_000136','PRD_000137','PRD_000139','PRD_000145') AND del_yn='N'
UNION ALL SELECT 'options', count(*) FROM t_prd_product_options WHERE prd_cd IN ('PRD_000118','PRD_000120','PRD_000121','PRD_000122','PRD_000124','PRD_000125','PRD_000133','PRD_000134','PRD_000135','PRD_000136','PRD_000137','PRD_000139','PRD_000145') AND del_yn='N'
UNION ALL SELECT 'option_items', count(*) FROM t_prd_product_option_items WHERE prd_cd IN ('PRD_000118','PRD_000120','PRD_000121','PRD_000122','PRD_000124','PRD_000125','PRD_000133','PRD_000134','PRD_000135','PRD_000136','PRD_000137','PRD_000139','PRD_000145')
UNION ALL SELECT 'constraints', count(*) FROM t_prd_product_constraints WHERE prd_cd IN ('PRD_000118','PRD_000120','PRD_000121','PRD_000122','PRD_000124','PRD_000125','PRD_000133','PRD_000134','PRD_000135','PRD_000136','PRD_000137','PRD_000139','PRD_000145') AND use_yn='Y';
ROLLBACK;
