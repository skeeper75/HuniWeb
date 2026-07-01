BEGIN;

UPDATE t_prd_product_option_items SET ref_key1='MAT_000001' WHERE prd_cd='PRD_000072' AND opt_cd='OPV_000434';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000002' WHERE prd_cd='PRD_000072' AND opt_cd='OPV_000435';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000003' WHERE prd_cd='PRD_000072' AND opt_cd='OPV_000436';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000001' WHERE prd_cd='PRD_000077' AND opt_cd='OPV_000437';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000002' WHERE prd_cd='PRD_000077' AND opt_cd='OPV_000438';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000003' WHERE prd_cd='PRD_000077' AND opt_cd='OPV_000439';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000001' WHERE prd_cd='PRD_000082' AND opt_cd='OPV_000440';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000002' WHERE prd_cd='PRD_000082' AND opt_cd='OPV_000441';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000003' WHERE prd_cd='PRD_000082' AND opt_cd='OPV_000442';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000004' WHERE prd_cd='PRD_000082' AND opt_cd='OPV_000443';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000001' WHERE prd_cd='PRD_000088' AND opt_cd='OPV_000444';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000002' WHERE prd_cd='PRD_000088' AND opt_cd='OPV_000445';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000003' WHERE prd_cd='PRD_000088' AND opt_cd='OPV_000446';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000004' WHERE prd_cd='PRD_000088' AND opt_cd='OPV_000447';

DELETE FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088') AND mat_cd IN ('MAT_000382','MAT_000383','MAT_000384','MAT_000385');

COMMIT;
