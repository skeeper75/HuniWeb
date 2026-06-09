-- =====================================================================
-- step 07 — t_prd_product_option_items (BUNDLE 자재.03 + 공정.04 · 18행)
-- [중요] 본 패키지가 자재 mint+링크(01/03)·열재단 mint+링크(02/04)를 선행하므로,
--   prior _exec_silsa_banner 에서 BLOCKED 였던 자재 seq(.03 8행)+열재단(.04 1행)이 본 트랜잭션에서 INSERTABLE 승격.
--   18행 = 공정 seq(.04) 10 [열재단1·타공3·부착5·봉제1] + 자재 seq(.03) 8 [양면069·봉제사·큐방·끈070·각목338·각목339 + 끈×2(각목LE/GT 동반)].
-- 트리거 fn_chk_opt_item_ref 가 행단위 차원행 EXISTS 검사 → 03/04 선적재가 선행조건(같은 트랜잭션 내 순서로 충족).
-- 멱등 가드 = (prd_cd, opt_cd, item_seq) NOT EXISTS. opt_cd=opt_nm resolve·mat_cd/proc_cd=이름 resolve(재실행 안전).
-- ref_key1 NOT NULL(트리거 소스 확인). reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='열재단' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', (SELECT proc_cd FROM t_proc_processes WHERE proc_nm='열재단' AND del_yn='N' ORDER BY proc_cd LIMIT 1), NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='열재단' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='타공(4개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000079', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='타공(4개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='타공(6개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000079', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='타공(6개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='타공(8개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000079', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='타공(8개)' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='양면테입' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.03', 'MAT_000069', 'USAGE.07', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='양면테입' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='양면테입' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 2, 'OPT_REF_DIM.04', 'PROC_000081', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='양면테입' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 2);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='봉미싱' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.03', (SELECT mat_cd FROM t_mat_materials WHERE mat_nm='봉제사' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1), 'USAGE.07', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='봉미싱' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='봉미싱' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 2, 'OPT_REF_DIM.04', 'PROC_000080', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='봉미싱' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 2);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='큐방(4개)추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.03', (SELECT mat_cd FROM t_mat_materials WHERE mat_nm='큐방' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1), 'USAGE.07', 4, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='큐방(4개)추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='큐방(4개)추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 2, 'OPT_REF_DIM.04', 'PROC_000081', NULL, 4, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='큐방(4개)추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 2);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='끈(4개)추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.03', 'MAT_000070', 'USAGE.07', 4, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='끈(4개)추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='끈(4개)추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 2, 'OPT_REF_DIM.04', 'PROC_000081', NULL, 4, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='끈(4개)추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 2);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900이하)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.03', (SELECT mat_cd FROM t_mat_materials WHERE mat_nm='각목(900이하)' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1), 'USAGE.07', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900이하)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900이하)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 2, 'OPT_REF_DIM.03', 'MAT_000070', 'USAGE.07', 4, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900이하)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 2);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900이하)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 3, 'OPT_REF_DIM.04', 'PROC_000081', NULL, 4, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900이하)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 3);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900초과)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.03', (SELECT mat_cd FROM t_mat_materials WHERE mat_nm='각목(900초과)' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1), 'USAGE.07', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900초과)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900초과)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 2, 'OPT_REF_DIM.03', 'MAT_000070', 'USAGE.07', 4, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900초과)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 2);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000138', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900초과)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1), 3, 'OPT_REF_DIM.04', 'PROC_000081', NULL, 4, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd = 'PRD_000138' AND opt_cd = (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_nm='각목(900초과)+끈(4개) 추가' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq = 3);
