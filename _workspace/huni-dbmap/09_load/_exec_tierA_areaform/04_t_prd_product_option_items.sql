-- =====================================================================
-- step 04 — t_prd_product_option_items (.03 자재 / .04 공정 — polymorphic)
-- 트리거 fn_chk_opt_item_ref 행단위 차원행 EXISTS 검사 → step 01 LINK 선행이 139 끈추가 충족.
-- 멱등 가드 = (prd_cd, opt_cd, item_seq) NOT EXISTS. opt_cd=opt_nm resolve(재실행 안전).
-- ref_key1 NOT NULL. 센티넬(코팅없음/추가없음/출력만)=item 0행. BLOCKED 옵션=미적재. reg_dt 생략. 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000118', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000118' AND opt_nm='무광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000015', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000118' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000118' AND opt_nm='무광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000118', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000118' AND opt_nm='유광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000014', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000118' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000118' AND opt_nm='유광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000120', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000120' AND opt_nm='무광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000015', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000120' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000120' AND opt_nm='무광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000120', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000120' AND opt_nm='유광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000014', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000120' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000120' AND opt_nm='유광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000121', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000121' AND opt_nm='무광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000015', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000121' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000121' AND opt_nm='무광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000121', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000121' AND opt_nm='유광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000014', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000121' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000121' AND opt_nm='유광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000122', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000122' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000008', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000122' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000122' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000124', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000124' AND opt_nm='오버로크' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000080', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000124' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000124' AND opt_nm='오버로크' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000124', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000124' AND opt_nm='말아박기' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000080', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000124' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000124' AND opt_nm='말아박기' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000124', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000124' AND opt_nm='봉미싱(7cm)' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000080', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000124' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000124' AND opt_nm='봉미싱(7cm)' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000125', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000125' AND opt_nm='오버로크' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000080', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000125' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000125' AND opt_nm='오버로크' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000133', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000133' AND opt_nm='오버로크' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000080', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000133' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000133' AND opt_nm='오버로크' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000134', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000134' AND opt_nm='오버로크+봉미싱(4cm)' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000080', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000134' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000134' AND opt_nm='오버로크+봉미싱(4cm)' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000135', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000135' AND opt_nm='사각족자' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000082', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000135' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000135' AND opt_nm='사각족자' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000135', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000135' AND opt_nm='원형족자' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000082', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000135' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000135' AND opt_nm='원형족자' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000136', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000136' AND opt_nm='무광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000015', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000136' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000136' AND opt_nm='무광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000136', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000136' AND opt_nm='유광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000014', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000136' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000136' AND opt_nm='유광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000136', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000136' AND opt_nm='4구타공' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000079', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000136' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000136' AND opt_nm='4구타공' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000137', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000137' AND opt_nm='4구타공' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000079', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000137' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000137' AND opt_nm='4구타공' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000139', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000139' AND opt_nm='타공(4개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000079', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000139' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000139' AND opt_nm='타공(4개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000139', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000139' AND opt_nm='타공(6개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000079', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000139' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000139' AND opt_nm='타공(6개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000139', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000139' AND opt_nm='타공(8개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000079', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000139' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000139' AND opt_nm='타공(8개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000145', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000145' AND opt_nm='무광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000015', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000145' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000145' AND opt_nm='무광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000145', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000145' AND opt_nm='유광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000014', NULL, 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000145' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000145' AND opt_nm='유광코팅' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
