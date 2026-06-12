-- W3 product-accessory schema-anchor re-measurement (read-only). Source via .env.local RAILWAY_DB_*.
-- 0. identity: 15 부자재 PRD_000001~015 prd_typ_cd=PRD_TYPE.03, use_yn, MES
SELECT prd_cd, prd_nm, prd_typ_cd, use_yn, "MES_ITEM_CD" FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015' ORDER BY prd_cd;
-- 1. category orphan: all 15 -> CAT_000293 (upr NULL lvl3)
SELECT pc.prd_cd, pc.cat_cd FROM t_prd_product_categories pc WHERE pc.prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015' ORDER BY pc.prd_cd;
SELECT cat_cd, upr_cat_cd, cat_lvl FROM t_cat_categories WHERE cat_cd IN ('CAT_000293','CAT_000276','CAT_000285','CAT_000287','CAT_000012') ORDER BY 1;
-- 2. color materials MAT_TYPE.10 with mat_cd (006/007/010/015) + count per product
SELECT pm.prd_cd, m.mat_cd, m.mat_nm, m.mat_typ_cd, pm.usage_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd IN ('PRD_000006','PRD_000007','PRD_000010','PRD_000015') ORDER BY pm.prd_cd, m.mat_cd;
SELECT pm.prd_cd, count(*), string_agg(DISTINCT m.mat_typ_cd,',') FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd IN ('PRD_000006','PRD_000007','PRD_000010','PRD_000012','PRD_000015') GROUP BY pm.prd_cd ORDER BY 1;
-- 3. wood holder material MAT_000222 (우드거치대=자재)
SELECT mat_cd, mat_nm, mat_typ_cd FROM t_mat_materials WHERE mat_cd='MAT_000222';
SELECT pm.prd_cd, pm.mat_cd, pm.usage_cd FROM t_prd_product_materials pm WHERE pm.prd_cd IN ('PRD_000012','PRD_000013','PRD_000014') ORDER BY pm.prd_cd, pm.mat_cd;
-- 4. mat_typ_cd column existence (anchor)
SELECT column_name FROM information_schema.columns WHERE table_name='t_mat_materials' AND column_name='mat_typ_cd';
-- 5. bundle_qtys: 001/002 loaded with QTY_UNIT; 006/007/008/010/012-015 = 0 rows
SELECT pb.prd_cd, count(*) FROM t_prd_product_bundle_qtys pb WHERE pb.prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015' GROUP BY pb.prd_cd ORDER BY 1;
SELECT prd_cd, bdl_qty, qty_unit_cd FROM t_prd_product_bundle_qtys WHERE prd_cd IN ('PRD_000001','PRD_000002') ORDER BY prd_cd;
-- 6. templates del_yn: TMPL-000004~009 (page: 005/006/009 active, 004/007/008+001~003 del_yn=Y)
SELECT tmpl_cd, base_prd_cd, del_yn FROM t_prd_templates WHERE tmpl_cd LIKE 'TMPL-00000%' ORDER BY tmpl_cd;
-- 7. addons (page: 엽서 PRD_000016->TMPL-000005 1행) + sets (page: 0행 for accessory, 28 total)
SELECT count(*) FROM t_prd_product_addons;
SELECT prd_cd, addon_prd_cd, tmpl_cd FROM t_prd_product_addons WHERE addon_prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015' OR prd_cd IN ('PRD_000043','PRD_000044','PRD_000016') ORDER BY prd_cd;
SELECT count(*) FROM t_prd_product_sets;
SELECT count(*) FROM t_prd_product_sets WHERE prd_cd IN ('PRD_000043','PRD_000044');
-- 8. option_groups: test residue PRD_000001/002 only among 001~015; global option_items count
SELECT prd_cd, opt_grp_cd, opt_grp_nm FROM t_prd_product_option_groups WHERE prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015' ORDER BY prd_cd;
SELECT count(*) FROM t_prd_product_option_items;
-- 9. ref_dim_cd column existence (anchor for CPQ-002)
SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_product_option_items' AND column_name='ref_dim_cd';
-- 10. price chain 0 rows: price_formulas + component_prices + template_prices
SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015';
SELECT to_regclass('public.t_prd_template_prices') AS tmpl_price_table;
SELECT to_regclass('public.t_prc_component_prices') AS comp_price_table;
-- 11. ID double-register: 004 .03 / 281/282/283 .05
SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products WHERE prd_cd IN ('PRD_000004','PRD_000281','PRD_000282','PRD_000283') ORDER BY prd_cd;
SELECT prd_cd, cat_cd FROM t_prd_product_categories WHERE prd_cd='PRD_000283';
