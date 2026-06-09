-- =====================================================================
-- step 06 — t_prd_product_options (13행 · OPV_000017~OPV_000029)
-- 멱등 가드 = (prd_cd, opt_grp_cd, opt_nm, del_yn='N') NOT EXISTS. opt_grp_cd = 그룹 이름으로 resolve(재실행 안전).
-- 코드=라이브 MAX(OPV_000016)+1 리터럴(`_` 통일·D3·re-code OP-*). 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000017', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='인쇄(도수)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', 'print_option opt_id 1. 설계 OP-DOSU-SINGLE.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='인쇄(도수)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000018', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='인쇄(도수)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', 'print_option opt_id 2. 설계 OP-DOSU-DOUBLE.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='인쇄(도수)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000019', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '별도설정', 'Y', 1, 'Y', '종이 차원 0행 — 하위 item BLOCKED(GAP-DEFER). 헤더만 적재. 설계 OP-JONGI-DEFAULT.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '별도설정' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000020', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '직각', 'Y', 1, 'Y', 'PROC_000027 (default 재단). 설계 OP-MOSEORI-JIKGAK.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '직각' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000021', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '둥근', 'N', 2, 'Y', 'PROC_000028 (R 라운딩). 설계 OP-MOSEORI-DUNGEUN.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '둥근' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000022', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '오시', 'N', 1, 'Y', 'PROC_000029 — 차원 0행 → 하위 item BLOCKED(GAP-DEFER). 설계 OP-HUGA-OSI.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '오시' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000023', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '미싱', 'N', 2, 'Y', 'PROC_000030 — 차원 0행 BLOCKED. 설계 OP-HUGA-MISING.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '미싱' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000024', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변텍스트', 'N', 3, 'Y', 'PROC_000031 — 차원 0행 BLOCKED. 설계 OP-HUGA-VARTEXT.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변텍스트' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000025', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변이미지', 'N', 4, 'Y', 'PROC_000032 — 차원 0행 BLOCKED. 설계 OP-HUGA-VARIMG.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변이미지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000026', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='추가상품(봉투)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '봉투없음', 'Y', 1, 'Y', '선택안함 센티넬 (option_item 0행). 설계 OP-CHUGA-NONE.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='추가상품(봉투)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '봉투없음' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000027', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='추가상품(봉투)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'OPP접착봉투 110x160 50장', 'N', 2, 'Y', 'addon → TMPL-000005(라이브 실재). 설계 OP-CHUGA-OPP-JEOPCHAK.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='추가상품(봉투)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'OPP접착봉투 110x160 50장' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000028', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='추가상품(봉투)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'OPP비접착봉투 110x160 50장', 'N', 3, 'Y', 'addon → TMPL-000006(라이브 실재). 설계 OP-CHUGA-OPP-BIJEOPCHAK.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='추가상품(봉투)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'OPP비접착봉투 110x160 50장' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000029', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='추가상품(봉투)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '카드봉투(화이트) 165x115 50장', 'N', 4, 'Y', 'addon → TMPL_000010(본 적재 mint). 설계 OP-CHUGA-CARD-WHITE.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='추가상품(봉투)' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '카드봉투(화이트) 165x115 50장' AND del_yn = 'N');
