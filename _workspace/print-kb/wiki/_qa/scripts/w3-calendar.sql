-- W3 calendar schema-anchor re-measurement (read-only). Source via .env.local RAILWAY_DB_*.
-- 0. identity
SELECT prd_cd, prd_typ_cd, editor_yn, file_upload_yn, "MES_ITEM_CD" FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000108' AND 'PRD_000112' ORDER BY prd_cd;
-- 1. sub counts (sizes/mats/print/plate/proc/page_rules/option_groups/addons/prices)
SELECT p.prd_cd,
 (SELECT count(*) FROM t_prd_product_sizes s WHERE s.prd_cd=p.prd_cd) sz,
 (SELECT count(*) FROM t_prd_product_materials m WHERE m.prd_cd=p.prd_cd) mat,
 (SELECT count(*) FROM t_prd_product_print_options o WHERE o.prd_cd=p.prd_cd) prnt,
 (SELECT count(*) FROM t_prd_product_plate_sizes pl WHERE pl.prd_cd=p.prd_cd) plate,
 (SELECT count(*) FROM t_prd_product_processes pr WHERE pr.prd_cd=p.prd_cd) proc,
 (SELECT count(*) FROM t_prd_product_page_rules pg WHERE pg.prd_cd=p.prd_cd) pgrul,
 (SELECT count(*) FROM t_prd_product_option_groups og WHERE og.prd_cd=p.prd_cd) ogrp,
 (SELECT count(*) FROM t_prd_product_addons ad WHERE ad.prd_cd=p.prd_cd) addon,
 (SELECT count(*) FROM t_prd_product_prices px WHERE px.prd_cd=p.prd_cd) price
FROM t_prd_products p WHERE p.prd_cd BETWEEN 'PRD_000108' AND 'PRD_000112' ORDER BY p.prd_cd;
-- 2. material usage_cd + mat_typ on calendar (W3: USAGE.07 + tripod/ring MAT_TYPE.07)
SELECT pm.prd_cd, pm.mat_cd, pm.usage_cd, mm.mat_nm, mm.mat_typ_cd FROM t_prd_product_materials pm JOIN t_mat_materials mm ON pm.mat_cd=mm.mat_cd WHERE pm.prd_cd BETWEEN 'PRD_000108' AND 'PRD_000112' ORDER BY pm.prd_cd, pm.mat_cd;
-- 3. plate output_paper_typ_cd values (W3: .01/.03)
SELECT prd_cd, output_paper_typ_cd FROM t_prd_product_plate_sizes WHERE prd_cd BETWEEN 'PRD_000108' AND 'PRD_000112' ORDER BY prd_cd;
SELECT output_paper_typ_cd, count(*) FROM t_prd_product_plate_sizes GROUP BY 1 ORDER BY 1;
-- 4. processes (W3: PROC_000021 twin-ring / 079 punch / 076 packing; tripod absent)
SELECT prd_cd, proc_cd FROM t_prd_product_processes WHERE prd_cd BETWEEN 'PRD_000108' AND 'PRD_000112' ORDER BY prd_cd, proc_cd;
SELECT proc_cd, proc_nm FROM t_proc_processes WHERE proc_nm ILIKE '%삼각대%' OR proc_nm ILIKE '%거치%';
-- 5. excl_groups Phase11 deletion + addons column drift + editor_yn anchor
SELECT to_regclass('public.t_prd_product_process_excl_groups') AS excl_table;
SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_product_addons' ORDER BY 1;
SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_products' AND column_name IN ('editor_yn','file_upload_yn');
-- 6. envelope addon product PRD_000005
SELECT prd_cd, prd_typ_cd, "MES_ITEM_CD" FROM t_prd_products WHERE prd_cd='PRD_000005';
-- 7. category nodes (orphan 0)
SELECT cat_cd, upr_cat_cd, cat_lvl FROM t_cat_categories WHERE cat_cd IN ('CAT_000112','CAT_000113','CAT_000114','CAT_000115','CAT_000007') ORDER BY 1;
SELECT prd_cd, cat_cd FROM t_prd_product_categories WHERE prd_cd BETWEEN 'PRD_000108' AND 'PRD_000112' ORDER BY 1;
-- 8. option_groups global (W3: only PRD_000001/002/066/138)
SELECT prd_cd, count(*) FROM t_prd_product_option_groups GROUP BY 1 ORDER BY 1;
-- 9. price_formulas calendar (0 rows)
SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd BETWEEN 'PRD_000108' AND 'PRD_000112';
