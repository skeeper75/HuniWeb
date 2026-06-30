BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000032' AND frm_cd='PRF_NAMECARD_COAT';
INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note)
  SELECT 'PRD_000032','PRF_NAMECARD_FIXED','2026-06-01','코팅명함→면/소재/수량'
  WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000032' AND frm_cd='PRF_NAMECARD_FIXED');
UPDATE t_prc_component_prices SET print_opt_cd=NULL WHERE comp_cd IN ('COMP_NAMECARD_COAT_S1','COMP_NAMECARD_COAT_S2');
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_COAT';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_COAT';
COMMIT;
