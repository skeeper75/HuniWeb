-- acryl-154-hairband-undo.sql — 154 머리끈 적재 역연산 (인간 승인 후만)
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000154' AND frm_cd='PRF_ACRYL_HAIRBAND';
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_HAIRBAND';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_HAIRBAND';
DELETE FROM t_prc_component_prices WHERE comp_price_id=39086;
COMMIT;
