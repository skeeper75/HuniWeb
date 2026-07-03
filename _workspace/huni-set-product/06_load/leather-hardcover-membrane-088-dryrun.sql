-- ═══════════════════════════════════════════════════════════════════════════
-- 088 레더 링바인더 면지 통합 재설계 — 롤백전용 DRY-RUN (BEGIN…ROLLBACK)
-- 멱등(2회 apply delta 0)·제약/트리거 통과·예상 카운트·★USAGE.07 D링자재 불변 실증.
-- 실행: psql ... -f 이 파일 (apply-088.sql은 \i로 인라인, 이 파일이 트랜잭션 래핑)
-- 072/077/082 파일럿 동형 전파 · 매핑: 082→088 · 084→090 · 085/086/087→091/092/093 · OPT_066→OPT_067.
-- ═══════════════════════════════════════════════════════════════════════════
\set ON_ERROR_STOP on
BEGIN;

\echo '--- [사전] USAGE.07 D링자재 (불가침, apply 전) ---'
SELECT mat_cd, del_yn FROM t_prd_product_materials
 WHERE prd_cd='PRD_000088' AND usage_cd='USAGE.07' ORDER BY mat_cd;

\echo '--- 1차 apply ---'
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/leather-hardcover-membrane-redesign-260703/088/apply-088.sql

\echo '--- [1차 후] 상태 실측 ---'
SELECT '090_mat'   k, count(*) v FROM t_prd_product_materials     WHERE prd_cd='PRD_000090' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT '090_optgrp', count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000090' AND opt_grp_cd='OPT_000067' AND del_yn='N'
UNION ALL SELECT '090_opt',    count(*) FROM t_prd_product_options       WHERE prd_cd='PRD_000090' AND opt_grp_cd='OPT_000067' AND del_yn='N'
UNION ALL SELECT '090_optitem',count(*) FROM t_prd_product_option_items  WHERE prd_cd='PRD_000090' AND opt_cd IN ('OPV_000444','OPV_000445','OPV_000446','OPV_000447') AND del_yn='N'
UNION ALL SELECT '088_USAGE03_active', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000088' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT '088_USAGE07_dring_active', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000088' AND usage_cd='USAGE.07' AND del_yn='N'
UNION ALL SELECT '088_OPT067_active',  count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000088' AND opt_grp_cd='OPT_000067' AND del_yn='N'
UNION ALL SELECT '088_sets_active',    count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000088' AND del_yn='N'
UNION ALL SELECT '091_93_use_yn_Y',    count(*) FROM t_prd_products WHERE prd_cd IN ('PRD_000091','PRD_000092','PRD_000093') AND use_yn='Y'
ORDER BY k;

\echo '--- 2차 apply (멱등) ---'
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/leather-hardcover-membrane-redesign-260703/088/apply-088.sql

\echo '--- [2차 후] 상태 실측 (1차와 동일해야 delta 0) ---'
SELECT '090_mat'   k, count(*) v FROM t_prd_product_materials     WHERE prd_cd='PRD_000090' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT '088_sets_active', count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000088' AND del_yn='N'
UNION ALL SELECT '088_USAGE03_active', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000088' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT '088_USAGE07_dring_active', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000088' AND usage_cd='USAGE.07' AND del_yn='N'
ORDER BY k;

\echo '--- [사후] USAGE.07 D링자재 (불가침, apply 후 — 활성 3 불변 확인) ---'
SELECT mat_cd, del_yn FROM t_prd_product_materials
 WHERE prd_cd='PRD_000088' AND usage_cd='USAGE.07' ORDER BY mat_cd;

\echo '--- FK 고아 스윕 (088 활성 링크 sub_prd_cd 실재) ---'
SELECT s.sub_prd_cd, (p.prd_cd IS NOT NULL) AS exists_in_products
  FROM t_prd_product_sets s LEFT JOIN t_prd_products p ON p.prd_cd=s.sub_prd_cd
 WHERE s.prd_cd='PRD_000088' AND s.del_yn='N' ORDER BY s.sub_prd_cd;

ROLLBACK;

\echo '--- [롤백 후] 090 이관분·088 USAGE.07 원상복귀 확인 ---'
SELECT 'post_rollback_090_mat' k, count(*) v FROM t_prd_product_materials WHERE prd_cd='PRD_000090' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT 'post_rollback_088_U03', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000088' AND usage_cd='USAGE.03' AND del_yn='N'
UNION ALL SELECT 'post_rollback_088_U07_dring', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000088' AND usage_cd='USAGE.07' AND del_yn='N'
UNION ALL SELECT 'post_rollback_088_sets', count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000088' AND del_yn='N'
ORDER BY k;
