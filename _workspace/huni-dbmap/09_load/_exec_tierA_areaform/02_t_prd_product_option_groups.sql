-- =====================================================================
-- step 02 — t_prd_product_option_groups (OPT_000005~)
-- 멱등 가드 = (prd_cd, opt_grp_nm) NOT EXISTS. 코드=라이브 MAX+1 리터럴(OPT_000005~).
-- 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000118', 'OPT_000005', '코팅', 'SEL_TYPE.01', 0, 1, 'N', 1, 'Y', '코팅 택1 선택'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000118' AND opt_grp_nm='코팅' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000120', 'OPT_000006', '코팅', 'SEL_TYPE.01', 0, 1, 'N', 1, 'Y', '코팅 택1 선택'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000120' AND opt_grp_nm='코팅' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000121', 'OPT_000007', '코팅', 'SEL_TYPE.01', 0, 1, 'N', 1, 'Y', '코팅 택1 선택'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000121' AND opt_grp_nm='코팅' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000122', 'OPT_000008', '화이트별색', 'SEL_TYPE.01', 0, 1, 'N', 1, 'Y', '화이트 underbase 별색 선택'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000122' AND opt_grp_nm='화이트별색' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000124', 'OPT_000009', '가공', 'SEL_TYPE.01', 0, 1, 'N', 1, 'Y', '봉제 가공 (유형 param=GAP-PARAM)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000124' AND opt_grp_nm='가공' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000125', 'OPT_000010', '가공', 'SEL_TYPE.01', 0, 1, 'N', 1, 'Y', '오버로크 봉제 가공'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000125' AND opt_grp_nm='가공' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000133', 'OPT_000011', '가공', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '오버로크 봉제 필수'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000133' AND opt_grp_nm='가공' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000133', 'OPT_000012', '추가', 'SEL_TYPE.01', 0, 1, 'N', 2, 'Y', '우드행거 추가 선택'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000133' AND opt_grp_nm='추가' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000134', 'OPT_000013', '가공', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '오버로크+봉미싱 봉제 필수 (복합유형=2 item)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000134' AND opt_grp_nm='가공' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000134', 'OPT_000014', '추가', 'SEL_TYPE.01', 0, 1, 'N', 2, 'Y', '우드봉 추가 선택'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000134' AND opt_grp_nm='추가' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000135', 'OPT_000015', '가공', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '족자제작 필수 (모양 param=GAP)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000135' AND opt_grp_nm='가공' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000135', 'OPT_000016', '추가', 'SEL_TYPE.01', 0, 1, 'N', 2, 'Y', '천정형고리 추가 선택'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000135' AND opt_grp_nm='추가' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000136', 'OPT_000017', '코팅', 'SEL_TYPE.01', 0, 1, 'N', 1, 'Y', '코팅 택1 선택'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000136' AND opt_grp_nm='코팅' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000136', 'OPT_000018', '가공', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '4구타공 필수 (구수 param=GAP)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000136' AND opt_grp_nm='가공' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000136', 'OPT_000019', '추가', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '배너거치대 추가 (template·BLOCKED)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000136' AND opt_grp_nm='추가' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000137', 'OPT_000020', '가공', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '4구타공 필수 (구수 param=GAP)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000137' AND opt_grp_nm='가공' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000137', 'OPT_000021', '추가', 'SEL_TYPE.01', 0, 1, 'N', 2, 'Y', '배너거치대 추가 (template·BLOCKED)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000137' AND opt_grp_nm='추가' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000139', 'OPT_000022', '가공', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '타공 필수 (구수 param=GAP). 재단만=L1 LINK 의존 BLOCKED'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000139' AND opt_grp_nm='가공' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000139', 'OPT_000023', '추가', 'SEL_TYPE.01', 0, 1, 'N', 2, 'Y', '끈추가=L1 LINK 의존 BLOCKED. 추가없음만 INSERTABLE'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000139' AND opt_grp_nm='추가' AND del_yn='N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000145', 'OPT_000024', '코팅', 'SEL_TYPE.01', 0, 1, 'N', 1, 'Y', '코팅 택1 선택'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000145' AND opt_grp_nm='코팅' AND del_yn='N');
