-- acryl-146-step2-undo.sql — 146 키링 Step2 역연산 (인간 승인 후만)
-- ★KEYRING comp/기존 고리 단가행·PRF_ACRYL_KEYRING 본체·고리 배선은 Step1 자산이라 미터치.
BEGIN;
-- 볼체인 배선 제거
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_KEYRING' AND comp_cd='COMP_ACRYL_KEYRING_BALLCHAIN';
-- 단가행 제거(Step2 신규분 39087~39097)
DELETE FROM t_prc_component_prices WHERE comp_price_id BETWEEN 39087 AND 39097;
-- 볼체인 comp 제거
DELETE FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_KEYRING_BALLCHAIN';
-- 옵션아이템·옵션·그룹·자재 제거(Step2 신규분만)
DELETE FROM t_prd_product_option_items WHERE prd_cd='PRD_000146' AND opt_cd BETWEEN 'OPV_000476' AND 'OPV_000483';
DELETE FROM t_prd_product_options WHERE prd_cd='PRD_000146' AND opt_cd BETWEEN 'OPV_000473' AND 'OPV_000483';
DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000146' AND opt_grp_cd='OPT_000079';
DELETE FROM t_prd_product_materials WHERE prd_cd='PRD_000146' AND mat_cd BETWEEN 'MAT_000202' AND 'MAT_000209' AND usage_cd='USAGE.07';
COMMIT;
