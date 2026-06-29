-- 하드커버책자072 내지 완성 UNDO (COMMIT 직전=284 차원/공식 전부 부재). PRF_DGP_INNER는 이때 신설이라 안전 삭제.
BEGIN;
DELETE FROM t_prd_product_print_options WHERE prd_cd='PRD_000284' AND print_opt_cd IN ('POPT_000001','POPT_000002');
DELETE FROM t_prd_product_materials     WHERE prd_cd='PRD_000284' AND mat_cd IN ('MAT_000072','MAT_000073','MAT_000086','MAT_000087','MAT_000076','MAT_000077','MAT_000104','MAT_000105','MAT_000095');
DELETE FROM t_prd_product_plate_sizes   WHERE prd_cd='PRD_000284' AND siz_cd='SIZ_000499';
DELETE FROM t_prd_product_sizes         WHERE prd_cd='PRD_000284' AND siz_cd IN ('SIZ_000170','SIZ_000380','SIZ_000172');
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000284' AND frm_cd='PRF_DGP_INNER';
DELETE FROM t_prc_formula_components     WHERE frm_cd='PRF_DGP_INNER';
DELETE FROM t_prc_price_formulas         WHERE frm_cd='PRF_DGP_INNER';
COMMIT;
