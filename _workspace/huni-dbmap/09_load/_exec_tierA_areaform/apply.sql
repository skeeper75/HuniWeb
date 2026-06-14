-- =====================================================================
-- apply.sql — Tier A 면적형 13상품 CPQ 옵션레이어(L2 순수) 멱등 적재 (FK 위상순)
--   생성물: gen_load_sql.py (손편집 금지). 권위: tierA/areaform-option-layer.md
--   [HARD] 단일 트랜잭션. 로더(apply.sh)가 BEGIN…ROLLBACK(기본 DRY-RUN). NEVER COMMIT by default.
--   [FINDING-1 보정] L1 차원 LINK(product-materials/processes INSERT)는 _l1_link_preload.sql 로 분리·비포함.
--     본 트랜잭션은 L1 차원행을 생성하지 않는 순수 L2 옵션레이어 적재(groups/options/items/constraints).
--   순서: 00 markers → 02 groups → 03 options → 04 items → 05 constraints
-- =====================================================================
BEGIN;

\echo '--- step 00: markers (L1 LINK 분리됨·apply.sql 비포함) ---'
\i 00_preload_markers.sql

\echo '--- step 02: option_groups (OPT_000005~) ---'
\i 02_t_prd_product_option_groups.sql

\echo '--- step 03: options (OPV_000017~) ---'
\i 03_t_prd_product_options.sql

\echo '--- step 04: option_items (.03 자재 / .04 공정) ---'
\i 04_t_prd_product_option_items.sql

\echo '--- step 05: constraints (R-SIZE-NONSPEC × 7) ---'
\i 05_t_prd_product_constraints.sql

\echo '--- verify: 적재 행수 (Tier A 13상품) ---'
SELECT 'option_groups' AS t, count(*) FROM t_prd_product_option_groups
  WHERE prd_cd IN ('PRD_000118','PRD_000120','PRD_000121','PRD_000122','PRD_000124','PRD_000125','PRD_000133','PRD_000134','PRD_000135','PRD_000136','PRD_000137','PRD_000139','PRD_000145') AND del_yn='N'
UNION ALL SELECT 'options', count(*) FROM t_prd_product_options
  WHERE prd_cd IN ('PRD_000118','PRD_000120','PRD_000121','PRD_000122','PRD_000124','PRD_000125','PRD_000133','PRD_000134','PRD_000135','PRD_000136','PRD_000137','PRD_000139','PRD_000145') AND del_yn='N'
UNION ALL SELECT 'option_items', count(*) FROM t_prd_product_option_items
  WHERE prd_cd IN ('PRD_000118','PRD_000120','PRD_000121','PRD_000122','PRD_000124','PRD_000125','PRD_000133','PRD_000134','PRD_000135','PRD_000136','PRD_000137','PRD_000139','PRD_000145')
UNION ALL SELECT 'constraints', count(*) FROM t_prd_product_constraints
  WHERE prd_cd IN ('PRD_000118','PRD_000120','PRD_000121','PRD_000122','PRD_000124','PRD_000125','PRD_000133','PRD_000134','PRD_000135','PRD_000136','PRD_000137','PRD_000139','PRD_000145') AND use_yn='Y';

-- 트랜잭션 종료(COMMIT/ROLLBACK)는 apply.sh 가 -c 로 주입. NEVER COMMIT by default.
