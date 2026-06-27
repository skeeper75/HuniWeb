-- acryl-163-minipart-pending-undo.sql — 163 미니파츠 시그널 역연산 (인간 승인 후만)
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000163' AND frm_cd='PRF_ACRYL_MINIPART';
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_MINIPART';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_MINIPART';
DELETE FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_MINIPART_TBD';
COMMIT;
