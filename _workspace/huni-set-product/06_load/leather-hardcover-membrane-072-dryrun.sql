-- ═══════════════════════════════════════════════════════════════════════════
-- 072 면지 통합 재설계 — 롤백전용 DRY-RUN (BEGIN…ROLLBACK)
-- 멱등(2회 apply delta 0)·제약/트리거 통과·예상 카운트·골든 무손상 실증.
-- 실행: psql ... -f 이 파일  (apply.sql은 \i로 인라인, 이 파일이 트랜잭션 래핑)
-- ═══════════════════════════════════════════════════════════════════════════
\set ON_ERROR_STOP on
BEGIN;

\echo '--- [사전] 골든 원자 (COVERBIND 티어, apply 전) ---'
SELECT min_qty, unit_price FROM t_prc_component_prices
 WHERE comp_cd LIKE '%HC_MUSEON_COVERBIND%' AND min_qty IN (1,10,100) ORDER BY min_qty;

\echo '--- 1차 apply ---'
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/leather-hardcover-membrane-redesign-260703/apply.sql

\echo '--- [1차 후] 상태 실측 ---'
SELECT '074_mat'   k, count(*) v FROM t_prd_product_materials     WHERE prd_cd='PRD_000074' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT '074_optgrp', count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000074' AND opt_grp_cd='OPT_000064' AND del_yn='N'
UNION ALL SELECT '074_opt',    count(*) FROM t_prd_product_options       WHERE prd_cd='PRD_000074' AND opt_grp_cd='OPT_000064' AND del_yn='N'
UNION ALL SELECT '074_optitem',count(*) FROM t_prd_product_option_items  WHERE prd_cd='PRD_000074' AND opt_cd IN ('OPV_000434','OPV_000435','OPV_000436') AND del_yn='N'
UNION ALL SELECT '072_USAGE03_active', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000072' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT '072_OPT064_active',  count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000072' AND opt_grp_cd='OPT_000064' AND del_yn='N'
UNION ALL SELECT '072_sets_active',    count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000072' AND del_yn='N'
UNION ALL SELECT '075_076_use_yn_Y',   count(*) FROM t_prd_products WHERE prd_cd IN ('PRD_000075','PRD_000076') AND use_yn='Y'
ORDER BY k;

\echo '--- 2차 apply (멱등) ---'
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/leather-hardcover-membrane-redesign-260703/apply.sql

\echo '--- [2차 후] 상태 실측 (1차와 동일해야 delta 0) ---'
SELECT '074_mat'   k, count(*) v FROM t_prd_product_materials     WHERE prd_cd='PRD_000074' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT '072_sets_active', count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000072' AND del_yn='N'
UNION ALL SELECT '072_USAGE03_active', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000072' AND usage_cd='USAGE.03' AND del_yn='N'
ORDER BY k;

\echo '--- [사후] 골든 원자 (COVERBIND 티어, apply 후 — 불변 확인) ---'
SELECT min_qty, unit_price, (unit_price*min_qty) AS final_est FROM t_prc_component_prices
 WHERE comp_cd LIKE '%HC_MUSEON_COVERBIND%' AND min_qty IN (1,10,100) ORDER BY min_qty;

\echo '--- FK 고아 스윕 (072 활성 링크 sub_prd_cd 실재) ---'
SELECT s.sub_prd_cd, (p.prd_cd IS NOT NULL) AS exists_in_products
  FROM t_prd_product_sets s LEFT JOIN t_prd_products p ON p.prd_cd=s.sub_prd_cd
 WHERE s.prd_cd='PRD_000072' AND s.del_yn='N' ORDER BY s.sub_prd_cd;

ROLLBACK;

\echo '--- [롤백 후] 074 이관분 비영속 확인 (0이어야 원상복귀) ---'
SELECT count(*) AS post_rollback_074_mat FROM t_prd_product_materials WHERE prd_cd='PRD_000074' AND usage_cd='USAGE.03' AND del_yn='N';
