-- =====================================================================
-- _blocked/apply_blocked_options.sql — [v2] 자재 seq BUNDLE 활성화 (인간 승인 후)
--   [HARD] 기본 apply.sql 경로 밖. 자재 mint(master-data)·자재 링크=인간 승인 후에만.
--   [의존] B04 자재 seq item 은 옵션헤더(t_prd_product_options) FK 필요 → 주 적재(06/07) 선행.
--     본 스크립트는 자체완결 위해 06/07(멱등) 선포함(주 적재 후 실행 시 no-op).
--   FK 위상정렬: 옵션그룹(06)→옵션(07)→자재 mint(B03a 제안)→자재 링크(B03b)→자재 seq item(B04).
--   끈/양면테입 = mint 불요(링크만) → B03b live분 + B04 live분이 즉시 멱등 적재.
--   큐방/각목/봉제사 = mint 채번 후 placeholder 치환 필요(B03a/B03b/B04 주석분).
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;
  \echo '>> [blocked-opt] 06/07 옵션헤더 선행(멱등 — 주 적재 후 no-op)'
  \i ../06_t_prd_product_option_groups.sql
  \i ../07_t_prd_product_options.sql
  \echo '>> [blocked-opt] B03a t_mat_materials mint (제안·주석 — 채번 후 활성화)'
  \i B03a_t_mat_materials_MINT.sql
  \echo '>> [blocked-opt] B03b t_prd_product_materials link (끈/양면테입 live + mint분 주석)'
  \i B03b_t_prd_product_materials_LINK.sql
  \echo '>> [blocked-opt] B04 t_prd_product_option_items 자재 seq (끈/양면테입 live + mint분 주석)'
  \i B04_t_prd_product_option_items_MAT.sql
-- 기본 ROLLBACK. 실제 적재는 인간 승인 --commit.
