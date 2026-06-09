-- =====================================================================
-- step 05 — t_prd_product_option_groups (5행 · OPT_000005~OPT_000009)
-- 멱등 가드 = (prd_cd, opt_grp_nm, del_yn='N') NOT EXISTS. 코드=라이브 MAX(OPT_000004)+1 리터럴(`_` 통일·D3).
-- 설계 시맨틱 코드(OG-*) DEPRECATED → surrogate 재코드. 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPT_000005', '인쇄(도수)', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '단/양면 택1 필수 (print_option opt_id 1/2). 설계 OG-DOSU 재코드→OPT_000005.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000016' AND opt_grp_nm = '인쇄(도수)' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPT_000006', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이=*별도설정 material 0행 → 하위 item BLOCKED(GAP-DEFER). 헤더는 적재 가능. 설계 OG-JONGI→OPT_000006.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000016' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPT_000007', '모서리', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '직각/둥근 택1 (PROC_000027/028). 설계 OG-MOSEORI→OPT_000007.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000016' AND opt_grp_nm = '모서리' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPT_000008', '후가공', 'SEL_TYPE.02', 0, 4, 'N', 4, 'Y', '오시/미싱/가변텍스트/가변이미지 다중(max4) — L1 row2~4 4종 동시. 029~032 process 0행 → 하위 item BLOCKED. 설계 OG-HUGAGONG→OPT_000008.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000016' AND opt_grp_nm = '후가공' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPT_000009', '추가상품(봉투)', 'SEL_TYPE.01', 0, 1, 'N', 5, 'Y', '봉투 add-on은 template 경유(ref_dim 아님·option_item 0행). 설계 OG-CHUGA→OPT_000009.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000016' AND opt_grp_nm = '추가상품(봉투)' AND del_yn = 'N');
