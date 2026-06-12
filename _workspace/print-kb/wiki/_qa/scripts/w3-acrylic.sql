-- W3 acrylic schema-anchor re-measurement (read-only). Source via .env.local RAILWAY_DB_*.
-- Acrylic prd range PRD_000146..PRD_000169 (167 결번)
\echo === identity: prd_typ_cd distribution + count ===
SELECT prd_typ_cd, count(*) FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' GROUP BY prd_typ_cd ORDER BY 1;
\echo === active count (use_yn) ===
SELECT use_yn, count(*) FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' GROUP BY use_yn ORDER BY 1;
\echo === W3-A: print_side UV mis-load count (claim=20 products) ===
SELECT count(DISTINCT prd_cd) print_opt_products FROM t_prd_product_print_options WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';
SELECT prd_cd, print_side, count(*) FROM t_prd_product_print_options WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' GROUP BY prd_cd, print_side ORDER BY prd_cd;
\echo === W3-B: UV process PROC_000002 linked count (claim=14) ===
SELECT count(DISTINCT prd_cd) uv_products FROM t_prd_product_processes WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' AND proc_cd='PROC_000002';
SELECT prd_cd FROM t_prd_product_processes WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' AND proc_cd='PROC_000002' ORDER BY prd_cd;
\echo === W3-C: 완칼 PROC_000053/054/055 acrylic count (claim=0) ===
SELECT proc_cd, count(*) FROM t_prd_product_processes WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' AND proc_cd IN ('PROC_000053','PROC_000054','PROC_000055') GROUP BY proc_cd ORDER BY 1;
\echo === W3-D: 부착 PROC_000081 acrylic (claim=맥세이프151+마그넷147 only) ===
SELECT prd_cd FROM t_prd_product_processes WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' AND proc_cd='PROC_000081' ORDER BY prd_cd;
\echo === W3-E: 두께 자재 MAT_000042/043/044/192/195/196 existence ===
SELECT mat_cd, mat_typ_cd FROM t_mat_materials WHERE mat_cd IN ('MAT_000042','MAT_000043','MAT_000044','MAT_000192','MAT_000195','MAT_000196') ORDER BY 1;
\echo === W3-F: usage_cd distribution on acrylic materials (claim=all USAGE.07, 33 rows) ===
SELECT usage_cd, count(*) FROM t_prd_product_materials WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' GROUP BY usage_cd ORDER BY 1;
\echo === W3-G: addon for 키링146/포카키링158 (claim=0 rows REMOVED) ===
SELECT prd_cd, count(*) FROM t_prd_product_addons WHERE prd_cd IN ('PRD_000146','PRD_000158') GROUP BY prd_cd ORDER BY 1;
\echo === W3-H: addons table columns (claim=addon_prd_cd->tmpl_cd restructure) ===
SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_product_addons' ORDER BY ordinal_position;
\echo === W3-I: PRD_000006 볼체인 master existence ===
SELECT prd_cd, use_yn FROM t_prd_products WHERE prd_cd='PRD_000006';
\echo === W3-J: CPQ option_items acrylic (claim=0 rows) ===
SELECT count(*) acrylic_opt_items FROM t_prd_product_option_items oi JOIN t_prd_product_option_groups og ON oi.opt_grp_cd=og.opt_grp_cd WHERE og.prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';
\echo === W3-K: print_side column existence (claim sql/01b anchor) ===
SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_product_print_options' AND column_name LIKE '%side%';
\echo === W3-L: PROC_000002 / PROC_000053 / PROC_000081 master existence ===
SELECT proc_cd, proc_nm FROM t_proc_processes WHERE proc_cd IN ('PROC_000002','PROC_000053','PROC_000081') ORDER BY 1;
\echo === W3-M: bundle_qtys 자유형스탠드160/미니파츠163 (claim=adapted rows) ===
SELECT prd_cd, count(*) FROM t_prd_product_bundle_qtys WHERE prd_cd IN ('PRD_000160','PRD_000163') GROUP BY prd_cd ORDER BY 1;
\echo === W3-N: t_prc_price_components prc_typ_cd distribution (claim=all .01) ===
SELECT prc_typ_cd, count(*) FROM t_prc_price_components GROUP BY prc_typ_cd ORDER BY 1;
\echo === W3-O: category 009 existence ===
SELECT cat_cd, cat_nm FROM t_cat_categories WHERE cat_nm LIKE '%아크릴%' ORDER BY 1;
