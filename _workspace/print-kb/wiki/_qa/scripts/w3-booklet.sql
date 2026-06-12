-- W3 booklet schema-anchor re-measurement (read-only). Source via .env.local RAILWAY_DB_*.
-- identity
SELECT prd_typ_cd, count(*) FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000068' AND 'PRD_000098' GROUP BY prd_typ_cd;
-- formula bindings (booklet range)
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd BETWEEN 'PRD_000068' AND 'PRD_000098' ORDER BY prd_cd;
-- TTEOKME formula existence (W3 finding: code absent)
SELECT count(*) tteokme_formula FROM t_prd_product_price_formulas WHERE frm_cd ILIKE '%TTEOK%';
-- COMP_BIND row counts
SELECT comp_cd, count(*) FROM t_prc_component_prices WHERE comp_cd ILIKE 'COMP_BIND%' GROUP BY comp_cd ORDER BY 1;
-- BK-CAT orphans
SELECT cc.cat_cd, cc.cat_nm, count(pc.prd_cd) FROM t_cat_categories cc LEFT JOIN t_prd_product_categories pc ON cc.cat_cd=pc.cat_cd WHERE cc.cat_cd IN ('CAT_000100','CAT_000101','CAT_000102','CAT_000103','CAT_000105','CAT_000106','CAT_000107') GROUP BY 1,2 ORDER BY 1;
-- BK-2 mis-loaded 078
SELECT prd_cd, usage_cd, mat_cd FROM t_prd_product_materials WHERE prd_cd='PRD_000078' ORDER BY usage_cd;
-- column-name anchors (W3 findings)
SELECT 't_mat_materials' t, column_name FROM information_schema.columns WHERE table_name='t_mat_materials' AND column_name LIKE '%typ%';
SELECT 't_prd_product_bundle_qtys' t, column_name FROM information_schema.columns WHERE table_name='t_prd_product_bundle_qtys' AND column_name LIKE 'bdl_unit%';
