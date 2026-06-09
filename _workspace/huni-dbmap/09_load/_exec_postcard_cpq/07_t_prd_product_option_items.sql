-- =====================================================================
-- step 07 — t_prd_product_option_items (INSERTABLE 4행: 도수2 .06 + 모서리2 .04)
-- 트리거 fn_chk_opt_item_ref 행단위: .06→print_options(opt_id 1/2 실재) · .04→processes(PROC_000027/028 실재).
-- BLOCKED(후가공 PROC_000029~032·종이 material 0행) = 차원행 부재→트리거 REJECT → _blocked/(적재 대상 아님).
-- 멱등 가드 = (prd_cd, opt_cd, item_seq) 자연키. opt_cd=opt_nm resolve(재실행 안전). ref_key1 NOT NULL.
-- ref_key2(도수/공정) 미사용=NULL. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000016', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000016' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '1', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000016' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000016' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000016', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000016' AND opt_nm='양면' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '2', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000016' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000016' AND opt_nm='양면' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000016', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000016' AND opt_nm='직각' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000027', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000016' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000016' AND opt_nm='직각' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000016', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000016' AND opt_nm='둥근' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000028', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000016' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000016' AND opt_nm='둥근' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
