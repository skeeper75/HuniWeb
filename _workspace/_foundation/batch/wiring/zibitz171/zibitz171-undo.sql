BEGIN;

DELETE FROM t_prd_product_options WHERE prd_cd='PRD_000171' AND opt_cd IN ('OPV_000493','OPV_000494');
DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000171' AND opt_grp_cd='OPT_000083';

UPDATE t_prd_product_price_formulas SET frm_cd = 'PRF_ACRYL_ZIBITZ2_TBD'
WHERE prd_cd = 'PRD_000171' AND frm_cd = 'PRF_ZIBITZ_ACRYL';

UPDATE t_prd_products SET
  nonspec_yn = 'N',
  nonspec_width_min = NULL, nonspec_width_max = NULL, nonspec_width_incr = NULL,
  nonspec_height_min = NULL, nonspec_height_max = NULL, nonspec_height_incr = NULL,
  use_yn = 'N'
WHERE prd_cd = 'PRD_000171';

UPDATE t_prd_products SET use_yn = 'N' WHERE prd_cd = 'PRD_000156';

COMMIT;
