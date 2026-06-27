-- 157 시범 역연산(구성요소·공식·배선·단가행·바인딩 제거)
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000157' AND frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_3T_BYSIZ';
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_3T_BYSIZ';
COMMIT;
