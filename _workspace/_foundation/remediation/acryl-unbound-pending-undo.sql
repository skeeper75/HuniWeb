-- acryl-unbound-pending-undo.sql — 7종 시그널 역연산 (인간 승인 후만)
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE frm_cd LIKE 'PRF_ACRYL_%_TBD';
DELETE FROM t_prc_formula_components WHERE frm_cd LIKE 'PRF_ACRYL_%_TBD';
DELETE FROM t_prc_price_formulas WHERE frm_cd LIKE 'PRF_ACRYL_%_TBD';
DELETE FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_PENDING_TBD';
COMMIT;
