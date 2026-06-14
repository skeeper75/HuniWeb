-- =====================================================================
-- step 05 — t_prd_product_option_groups (14상품 옵션그룹)
-- 멱등 가드 = (prd_cd, opt_grp_nm) NOT EXISTS. 코드=라이브 MAX+1 리터럴(OPT_000005+).
-- disp_seq=L1 옵션성 컬럼 등장순서 권위. 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPT_000005', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000016' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPT_000006', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 21종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000016' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPT_000007', '모서리', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '모서리 택1 선택. L1 ''후가공_모서리'' 직각/둥근. ref .04 공정 027/028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000016' AND opt_grp_nm = '모서리' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPT_000008', '후가공', 'SEL_TYPE.02', 0, 4, 'N', 4, 'Y', '후가공 택N 다중(4종 동시선택 L1 실증). ref .04 공정. 줄수/개수=GAP-PARAM(보존불가).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000016' AND opt_grp_nm = '후가공' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPT_000009', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000017' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPT_000010', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 2종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000017' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPT_000011', '코팅', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '코팅 택1 선택(코팅없음 센티넬 min0). L1 ''코팅(옵션)'' 유광/무광. ref .04 공정. 단/양면 면구분=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000017' AND opt_grp_nm = '코팅' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPT_000012', '모서리', 'SEL_TYPE.01', 0, 1, 'N', 4, 'Y', '모서리 택1 선택. L1 ''후가공_모서리'' 직각/둥근. ref .04 공정 027/028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000017' AND opt_grp_nm = '모서리' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPT_000013', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000018' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPT_000014', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 7종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000018' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPT_000015', '모서리', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '모서리 택1 선택. L1 ''후가공_모서리'' 직각/둥근. ref .04 공정 027/028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000018' AND opt_grp_nm = '모서리' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPT_000016', '후가공', 'SEL_TYPE.02', 0, 4, 'N', 4, 'Y', '후가공 택N 다중(4종 동시선택 L1 실증). ref .04 공정. 줄수/개수=GAP-PARAM(보존불가).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000018' AND opt_grp_nm = '후가공' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPT_000017', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000024' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPT_000018', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 1종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000024' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPT_000019', '코팅', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '코팅 택1 선택(코팅없음 센티넬 min0). L1 ''코팅(옵션)'' 유광/무광. ref .04 공정. 단/양면 면구분=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000024' AND opt_grp_nm = '코팅' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPT_000020', '모서리', 'SEL_TYPE.01', 0, 1, 'N', 4, 'Y', '모서리 택1 선택. L1 ''후가공_모서리'' 직각/둥근. ref .04 공정 027/028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000024' AND opt_grp_nm = '모서리' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPT_000021', '화이트별색', 'SEL_TYPE.01', 0, 1, 'N', 5, 'Y', '화이트별색 택1 선택. L1 ''별색인쇄(옵션)_화이트'' 화이트인쇄(단면). ref .04 공정 — BLOCKED(라이브 미링크).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000024' AND opt_grp_nm = '화이트별색' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000025', 'OPT_000022', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000025' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000025', 'OPT_000023', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 1종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000025' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000025', 'OPT_000024', '모서리', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '모서리 택1 선택. L1 ''후가공_모서리'' 직각/둥근. ref .04 공정 027/028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000025' AND opt_grp_nm = '모서리' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000025', 'OPT_000025', '화이트별색', 'SEL_TYPE.01', 0, 1, 'N', 4, 'Y', '화이트별색 택1 선택. L1 ''별색인쇄(옵션)_화이트'' 화이트인쇄(단면). ref .04 공정 — BLOCKED(라이브 미링크).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000025' AND opt_grp_nm = '화이트별색' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000026', 'OPT_000026', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000026' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000026', 'OPT_000027', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 1종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000026' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000026', 'OPT_000028', '코팅', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '코팅 택1 선택(코팅없음 센티넬 min0). L1 ''코팅(옵션)'' 유광/무광. ref .04 공정. 단/양면 면구분=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000026' AND opt_grp_nm = '코팅' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPT_000029', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000027' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPT_000030', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 14종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000027' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPT_000031', '후가공', 'SEL_TYPE.02', 0, 2, 'N', 3, 'Y', '후가공 택N 다중(2종 동시선택 L1 실증). ref .04 공정. 줄수/개수=GAP-PARAM(보존불가).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000027' AND opt_grp_nm = '후가공' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPT_000032', '접지', 'SEL_TYPE.01', 1, 1, 'Y', 4, 'Y', '접지 택1 필수. L1 ''접지(옵션)''. ref .04 공정 — BLOCKED(라이브 process 접지공정 065~068 미링크).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000027' AND opt_grp_nm = '접지' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPT_000033', '박칼라', 'SEL_TYPE.01', 0, 1, 'N', 5, 'Y', '박칼라 택1 선택(박없음 센티넬 min0). L1 ''박/형압_박칼라'' 8종. ref .04 공정. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000027' AND opt_grp_nm = '박칼라' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPT_000034', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000029' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPT_000035', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 14종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000029' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPT_000036', '후가공', 'SEL_TYPE.02', 0, 2, 'N', 3, 'Y', '후가공 택N 다중(2종 동시선택 L1 실증). ref .04 공정. 줄수/개수=GAP-PARAM(보존불가).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000029' AND opt_grp_nm = '후가공' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPT_000037', '접지', 'SEL_TYPE.01', 1, 1, 'Y', 4, 'Y', '접지 택1 필수. L1 ''접지(옵션)''. ref .04 공정 — BLOCKED(라이브 process 접지공정 065~068 미링크).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000029' AND opt_grp_nm = '접지' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPT_000038', '박칼라', 'SEL_TYPE.01', 0, 1, 'N', 5, 'Y', '박칼라 택1 선택(박없음 센티넬 min0). L1 ''박/형압_박칼라'' 8종. ref .04 공정. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000029' AND opt_grp_nm = '박칼라' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPT_000039', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000031' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPT_000040', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 16종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000031' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPT_000041', '모서리', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '모서리 택1 선택. L1 ''후가공_모서리'' 직각/둥근. ref .04 공정 027/028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000031' AND opt_grp_nm = '모서리' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPT_000042', '후가공', 'SEL_TYPE.02', 0, 2, 'N', 4, 'Y', '후가공 택N 다중(2종 동시선택 L1 실증). ref .04 공정. 줄수/개수=GAP-PARAM(보존불가).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000031' AND opt_grp_nm = '후가공' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPT_000043', '박칼라', 'SEL_TYPE.01', 0, 1, 'N', 5, 'Y', '박칼라 택1 선택(박없음 센티넬 min0). L1 ''박/형압_박칼라'' 8종. ref .04 공정. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000031' AND opt_grp_nm = '박칼라' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPT_000044', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000032' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPT_000045', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 2종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000032' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPT_000046', '코팅', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '코팅 택1 선택(코팅없음 센티넬 min0). L1 ''코팅(옵션)'' 유광/무광. ref .04 공정. 단/양면 면구분=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000032' AND opt_grp_nm = '코팅' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPT_000047', '모서리', 'SEL_TYPE.01', 0, 1, 'N', 4, 'Y', '모서리 택1 선택. L1 ''후가공_모서리'' 직각/둥근. ref .04 공정 027/028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000032' AND opt_grp_nm = '모서리' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPT_000048', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000033' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPT_000049', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 5종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000033' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPT_000050', '모서리', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '모서리 택1 선택. L1 ''후가공_모서리'' 직각/둥근. ref .04 공정 027/028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000033' AND opt_grp_nm = '모서리' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPT_000051', '후가공', 'SEL_TYPE.02', 0, 2, 'N', 4, 'Y', '후가공 택N 다중(2종 동시선택 L1 실증). ref .04 공정. 줄수/개수=GAP-PARAM(보존불가).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000033' AND opt_grp_nm = '후가공' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPT_000052', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000041' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPT_000053', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 4종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000041' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPT_000054', '후가공', 'SEL_TYPE.02', 0, 4, 'N', 3, 'Y', '후가공 택N 다중(4종 동시선택 L1 실증). ref .04 공정. 줄수/개수=GAP-PARAM(보존불가).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000041' AND opt_grp_nm = '후가공' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPT_000055', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000042' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPT_000056', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 8종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000042' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPT_000057', '후가공', 'SEL_TYPE.02', 0, 4, 'N', 3, 'Y', '후가공 택N 다중(4종 동시선택 L1 실증). ref .04 공정. 줄수/개수=GAP-PARAM(보존불가).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000042' AND opt_grp_nm = '후가공' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPT_000058', '박칼라', 'SEL_TYPE.01', 0, 1, 'N', 4, 'Y', '박칼라 택1 선택(박없음 센티넬 min0). L1 ''박/형압_박칼라'' 8종. ref .04 공정. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000042' AND opt_grp_nm = '박칼라' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPT_000059', '인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '인쇄(도수) 택1 필수. L1 ''인쇄(옵션)'' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000047' AND opt_grp_nm = '인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPT_000060', '종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '종이(자재) 택1 필수. L1 ''종이(필수)''. 47종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000047' AND opt_grp_nm = '종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPT_000061', '코팅', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', '코팅 택1 선택(코팅없음 센티넬 min0). L1 ''코팅(옵션)'' 유광/무광. ref .04 공정. 단/양면 면구분=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000047' AND opt_grp_nm = '코팅' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPT_000062', '후가공', 'SEL_TYPE.02', 0, 2, 'N', 4, 'Y', '후가공 택N 다중(2종 동시선택 L1 실증). ref .04 공정. 줄수/개수=GAP-PARAM(보존불가).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000047' AND opt_grp_nm = '후가공' AND del_yn = 'N');
