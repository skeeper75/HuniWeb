-- =====================================================================
-- step 05 — t_prd_product_option_groups (책자 4상품)
-- 멱등 가드 = (prd_cd, opt_grp_nm, del_yn='N') NOT EXISTS. 코드=라이브 MAX(5)+1, `_` separator.
-- 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000068', 'OPT_000006', '사이즈', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '사이즈 택1 필수. L1 disp 1.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000068' AND opt_grp_nm = '사이즈' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000068', 'OPT_000007', '내지종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '내지종이 택1 필수 (자재 usage 내지). L1 disp 2.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000068' AND opt_grp_nm = '내지종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000068', 'OPT_000008', '내지인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 3, 'Y', '내지인쇄 택1 필수 (도수). L1 disp 3.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000068' AND opt_grp_nm = '내지인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000068', 'OPT_000009', '표지종이', 'SEL_TYPE.01', 1, 1, 'Y', 4, 'Y', '표지종이 택1 필수 (자재 usage 표지). L1 disp 4.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000068' AND opt_grp_nm = '표지종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000068', 'OPT_000010', '표지인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 5, 'Y', '표지인쇄 택1 필수. 도수 차원 내지와 공유(GAP-DOSU-USAGE). L1 disp 5.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000068' AND opt_grp_nm = '표지인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000068', 'OPT_000011', '표지코팅', 'SEL_TYPE.01', 0, 1, 'N', 6, 'Y', '표지코팅 택1 선택 (코팅없음 센티넬 min0). L1 disp 6.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000068' AND opt_grp_nm = '표지코팅' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000068', 'OPT_000012', '제본', 'SEL_TYPE.01', 1, 1, 'Y', 9, 'Y', '제본 택1 필수 (택일그룹·excl 흡수). L1 disp 9 필수.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000068' AND opt_grp_nm = '제본' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000069', 'OPT_000013', '사이즈', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '사이즈 택1 필수.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000069' AND opt_grp_nm = '사이즈' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000069', 'OPT_000014', '내지종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '내지종이 택1 필수.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000069' AND opt_grp_nm = '내지종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000069', 'OPT_000015', '내지인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 3, 'Y', '내지인쇄 택1 필수.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000069' AND opt_grp_nm = '내지인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000069', 'OPT_000016', '표지종이', 'SEL_TYPE.01', 1, 1, 'Y', 4, 'Y', '표지종이 택1 필수.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000069' AND opt_grp_nm = '표지종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000069', 'OPT_000017', '표지인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 5, 'Y', '표지인쇄 택1 필수. 도수 공유(GAP-DOSU-USAGE).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000069' AND opt_grp_nm = '표지인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000069', 'OPT_000018', '표지코팅', 'SEL_TYPE.01', 0, 1, 'N', 6, 'Y', '표지코팅 택1 선택 (코팅없음 min0).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000069' AND opt_grp_nm = '표지코팅' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000069', 'OPT_000019', '박/형압', 'SEL_TYPE.02', 0, 10, 'N', 8, 'Y', '박/형압 다중 선택 (SEL_TYPE.02 max10). 크기 param=GAP-PARAM(미반영). L1 disp 8.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000069' AND opt_grp_nm = '박/형압' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000069', 'OPT_000020', '제본', 'SEL_TYPE.01', 1, 1, 'Y', 9, 'Y', '제본 택1 필수 (택일그룹).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000069' AND opt_grp_nm = '제본' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000071', 'OPT_000021', '사이즈', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '사이즈 택1 필수 (4종).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000071' AND opt_grp_nm = '사이즈' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000071', 'OPT_000022', '내지종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '내지종이 택1 필수.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000071' AND opt_grp_nm = '내지종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000071', 'OPT_000023', '내지인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 3, 'Y', '내지인쇄 택1 필수.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000071' AND opt_grp_nm = '내지인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000071', 'OPT_000024', '표지종이', 'SEL_TYPE.01', 1, 1, 'Y', 4, 'Y', '표지종이 택1 필수.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000071' AND opt_grp_nm = '표지종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000071', 'OPT_000025', '표지인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 5, 'Y', '표지인쇄 택1 필수. 도수 공유(GAP-DOSU-USAGE).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000071' AND opt_grp_nm = '표지인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000071', 'OPT_000026', '표지코팅', 'SEL_TYPE.01', 0, 1, 'N', 6, 'Y', '표지코팅 택1 선택 (min0).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000071' AND opt_grp_nm = '표지코팅' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000071', 'OPT_000027', '투명커버', 'SEL_TYPE.01', 0, 1, 'N', 7, 'Y', '투명커버 택1 선택 (투명커버없음 min0). 자재 USAGE.05(필름). L1 disp 7.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000071' AND opt_grp_nm = '투명커버' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000071', 'OPT_000028', '제본', 'SEL_TYPE.01', 1, 1, 'Y', 9, 'Y', '제본 택1 필수 (택일그룹).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000071' AND opt_grp_nm = '제본' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000071', 'OPT_000029', '링컬러', 'SEL_TYPE.01', 1, 1, 'Y', 10, 'Y', '링컬러 택1 필수. 자재 USAGE.07(금속). L1 disp 10. color-chip 후보(hex 부재).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000071' AND opt_grp_nm = '링컬러' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000094', 'OPT_000030', '사이즈', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '사이즈 택1 필수 (3종).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000094' AND opt_grp_nm = '사이즈' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000094', 'OPT_000031', '내지종이', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', '내지종이 택1 필수 (몽블랑240 1종).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000094' AND opt_grp_nm = '내지종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000094', 'OPT_000032', '내지인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 3, 'Y', '내지인쇄 택1 필수.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000094' AND opt_grp_nm = '내지인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000094', 'OPT_000033', '표지종이', 'SEL_TYPE.01', 1, 1, 'Y', 4, 'Y', '표지종이 택1 필수 (스노우300 1종).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000094' AND opt_grp_nm = '표지종이' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000094', 'OPT_000034', '표지인쇄', 'SEL_TYPE.01', 1, 1, 'Y', 5, 'Y', '표지인쇄 택1 필수. 도수 공유(GAP-DOSU-USAGE).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000094' AND opt_grp_nm = '표지인쇄' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000094', 'OPT_000035', '표지코팅', 'SEL_TYPE.01', 0, 1, 'N', 6, 'Y', '표지코팅 택1 선택 (무광 1종, min0).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000094' AND opt_grp_nm = '표지코팅' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000094', 'OPT_000036', '제본', 'SEL_TYPE.01', 1, 1, 'Y', 9, 'Y', '제본 택1 필수 (떡제본 택일그룹).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000094' AND opt_grp_nm = '제본' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000094', 'OPT_000037', '셋트구성', 'SEL_TYPE.01', 0, 1, 'N', 11, 'Y', '엽서북 BOM 구성 (내지+표지 sub_prd). CONFIRM §5.4: BOM vs 사용자옵션·미노출 hidden 후보(GAP-HIDDEN).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000094' AND opt_grp_nm = '셋트구성' AND del_yn = 'N');
