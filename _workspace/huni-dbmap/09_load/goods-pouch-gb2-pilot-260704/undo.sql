-- UNDO: 굿즈파우치 GB-2 파일럿(240) 완전 되돌리기
-- 파일럿 시점 PRF/COMP는 240 전용이므로 전부 제거. 오적재 자재 링크 복원.
\set ON_ERROR_STOP on
BEGIN;
-- 역순 제거
DELETE FROM t_prd_product_option_items WHERE prd_cd='PRD_000240' AND opt_cd IN('OPV_000667','OPV_000668');
DELETE FROM t_prd_product_options WHERE prd_cd='PRD_000240' AND opt_cd IN('OPV_000667','OPV_000668');
DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000240' AND opt_grp_cd='OPT_000172';
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000240' AND frm_cd='PRF_GOODS_FIXED_SIZ';
DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_GOODS_FIXED_SIZ' AND siz_cd IN('SIZ_000562','SIZ_000563');
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_GOODS_FIXED_SIZ' AND comp_cd='COMP_GOODS_FIXED_SIZ';
DELETE FROM t_prc_price_components WHERE comp_cd='COMP_GOODS_FIXED_SIZ';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_GOODS_FIXED_SIZ';
DELETE FROM t_prd_product_sizes WHERE prd_cd='PRD_000240' AND siz_cd IN('SIZ_000562','SIZ_000563');
DELETE FROM t_siz_sizes WHERE siz_cd IN('SIZ_000562','SIZ_000563');
-- 자재 링크 복원
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL
 WHERE prd_cd='PRD_000240' AND mat_cd IN('MAT_000319','MAT_000320') AND usage_cd='USAGE.07';
\echo '=== UNDO 후 240 (formula 0·active_mat 3 기대) ==='
SELECT (SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000240') formula,
       (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000240' AND del_yn='N') active_mat;
ROLLBACK;
