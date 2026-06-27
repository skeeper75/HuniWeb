-- acryl-146-keyring-undo.sql — 146 교정 역연산(원상복구: PRF_CLR_ACRYL 본체전용 재바인딩·신규공식 제거)
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000146' AND frm_cd='PRF_ACRYL_KEYRING';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note) VALUES ('PRD_000146','PRF_CLR_ACRYL','2026-06-15','원복');
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_KEYRING';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_KEYRING';
COMMIT;
