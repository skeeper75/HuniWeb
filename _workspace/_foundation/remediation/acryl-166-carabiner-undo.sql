-- acryl-166-carabiner-undo.sql — 166 카라비너 적재 역연산 (인간 승인 후만)
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000166' AND frm_cd='PRF_ACRYL_CARABINER';
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_CARABINER';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_CARABINER';
DELETE FROM t_prc_component_prices WHERE comp_price_id BETWEEN 39098 AND 39101;
DELETE FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_CARABINER';
COMMIT;
