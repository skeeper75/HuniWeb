-- ═══════════════════════════════════════════════════════════════════════════
-- 082 하드커버 링책자 면지 통합 재설계 — 롤백전용 DRY-RUN (BEGIN…ROLLBACK)
-- 멱등(2회 apply delta 0)·제약/트리거 통과·예상 카운트·★USAGE.07 링자재 불변 실증.
-- 실행: psql ... -f 이 파일 (apply-082.sql은 \i로 인라인, 이 파일이 트랜잭션 래핑)
-- 072/077 파일럿 동형 전파 · 매핑: 077→082 · 079→084 · 080/081→085/086/087(+1) · OPT_065→OPT_066.
-- ═══════════════════════════════════════════════════════════════════════════
\set ON_ERROR_STOP on
BEGIN;

\echo '--- [사전] USAGE.07 링자재 (불가침, apply 전) ---'
SELECT mat_cd, del_yn FROM t_prd_product_materials
 WHERE prd_cd='PRD_000082' AND usage_cd='USAGE.07' ORDER BY mat_cd;

\echo '--- 1차 apply ---'
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/leather-hardcover-membrane-redesign-260703/082/apply-082.sql

\echo '--- [1차 후] 상태 실측 ---'
SELECT '084_mat'   k, count(*) v FROM t_prd_product_materials     WHERE prd_cd='PRD_000084' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT '084_optgrp', count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000084' AND opt_grp_cd='OPT_000066' AND del_yn='N'
UNION ALL SELECT '084_opt',    count(*) FROM t_prd_product_options       WHERE prd_cd='PRD_000084' AND opt_grp_cd='OPT_000066' AND del_yn='N'
UNION ALL SELECT '084_optitem',count(*) FROM t_prd_product_option_items  WHERE prd_cd='PRD_000084' AND opt_cd IN ('OPV_000440','OPV_000441','OPV_000442','OPV_000443') AND del_yn='N'
UNION ALL SELECT '082_USAGE03_active', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000082' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT '082_USAGE07_ring_active', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000082' AND usage_cd='USAGE.07' AND del_yn='N'
UNION ALL SELECT '082_OPT066_active',  count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000082' AND opt_grp_cd='OPT_000066' AND del_yn='N'
UNION ALL SELECT '082_sets_active',    count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000082' AND del_yn='N'
UNION ALL SELECT '085_87_use_yn_Y',    count(*) FROM t_prd_products WHERE prd_cd IN ('PRD_000085','PRD_000086','PRD_000087') AND use_yn='Y'
ORDER BY k;

\echo '--- 2차 apply (멱등) ---'
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/leather-hardcover-membrane-redesign-260703/082/apply-082.sql

\echo '--- [2차 후] 상태 실측 (1차와 동일해야 delta 0) ---'
SELECT '084_mat'   k, count(*) v FROM t_prd_product_materials     WHERE prd_cd='PRD_000084' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT '082_sets_active', count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000082' AND del_yn='N'
UNION ALL SELECT '082_USAGE03_active', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000082' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT '082_USAGE07_ring_active', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000082' AND usage_cd='USAGE.07' AND del_yn='N'
ORDER BY k;

\echo '--- [사후] USAGE.07 링자재 (불가침, apply 후 — 활성 3 불변 확인) ---'
SELECT mat_cd, del_yn FROM t_prd_product_materials
 WHERE prd_cd='PRD_000082' AND usage_cd='USAGE.07' ORDER BY mat_cd;

\echo '--- FK 고아 스윕 (082 활성 링크 sub_prd_cd 실재) ---'
SELECT s.sub_prd_cd, (p.prd_cd IS NOT NULL) AS exists_in_products
  FROM t_prd_product_sets s LEFT JOIN t_prd_products p ON p.prd_cd=s.sub_prd_cd
 WHERE s.prd_cd='PRD_000082' AND s.del_yn='N' ORDER BY s.sub_prd_cd;

ROLLBACK;

\echo '--- [롤백 후] 084 이관분·082 USAGE.07 원상복귀 확인 ---'
SELECT 'post_rollback_084_mat' k, count(*) v FROM t_prd_product_materials WHERE prd_cd='PRD_000084' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT 'post_rollback_082_U03', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000082' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT 'post_rollback_082_U07_ring', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000082' AND usage_cd='USAGE.07' AND del_yn='N'
UNION ALL SELECT 'post_rollback_082_sets', count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000082' AND del_yn='N'
ORDER BY k;
