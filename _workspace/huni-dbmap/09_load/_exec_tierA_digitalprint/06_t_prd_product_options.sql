-- =====================================================================
-- step 06 — t_prd_product_options (14상품 옵션)
-- 멱등 가드 = (prd_cd, opt_grp_cd, opt_nm) NOT EXISTS. opt_grp_cd=그룹 이름 resolve(재실행 안전).
-- 코드=라이브 MAX+1 리터럴(OPV_000017+). 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000017', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000018', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', '도수 opt_id=2 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000019', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000074', 'Y', 1, 'Y', '종이 자재 MAT_000074(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000074' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000020', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000082', 'Y', 2, 'Y', '종이 자재 MAT_000082(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000082' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000021', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000092', 'N', 3, 'Y', '종이 자재 MAT_000092(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000092' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000022', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000101', 'N', 4, 'Y', '종이 자재 MAT_000101(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000101' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000023', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000109', 'N', 5, 'Y', '종이 자재 MAT_000109(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000109' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000024', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000113', 'N', 6, 'Y', '종이 자재 MAT_000113(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000113' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000025', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000114', 'N', 7, 'Y', '종이 자재 MAT_000114(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000114' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000026', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000115', 'N', 8, 'Y', '종이 자재 MAT_000115(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000115' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000027', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000116', 'N', 9, 'Y', '종이 자재 MAT_000116(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000116' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000028', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000117', 'N', 10, 'Y', '종이 자재 MAT_000117(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000117' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000029', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000118', 'N', 11, 'Y', '종이 자재 MAT_000118(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000118' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000030', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000120', 'N', 12, 'Y', '종이 자재 MAT_000120(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000120' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000031', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000121', 'N', 13, 'Y', '종이 자재 MAT_000121(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000121' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000032', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000123', 'N', 14, 'Y', '종이 자재 MAT_000123(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000123' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000033', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000124', 'N', 15, 'Y', '종이 자재 MAT_000124(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000124' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000034', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000125', 'N', 16, 'Y', '종이 자재 MAT_000125(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000125' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000035', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000126', 'N', 17, 'Y', '종이 자재 MAT_000126(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000126' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000036', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000127', 'N', 18, 'Y', '종이 자재 MAT_000127(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000127' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000037', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000128', 'N', 19, 'Y', '종이 자재 MAT_000128(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000128' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000038', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000129', 'N', 20, 'Y', '종이 자재 MAT_000129(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000129' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000039', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000130', 'N', 21, 'Y', '종이 자재 MAT_000130(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000130' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000040', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '직각', 'Y', 1, 'Y', '모서리 직각 공정 PROC_000027.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '직각' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000041', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '둥근', 'N', 2, 'Y', '모서리 둥근 공정 PROC_000028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '둥근' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000042', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '오시', 'N', 1, 'Y', '후가공 오시 공정 PROC_000029. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '오시' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000043', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '미싱', 'N', 2, 'Y', '후가공 미싱 공정 PROC_000030. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '미싱' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000044', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변텍스트', 'N', 3, 'Y', '후가공 가변텍스트 공정 PROC_000031. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변텍스트' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000016', 'OPV_000045', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변이미지', 'N', 4, 'Y', '후가공 가변이미지 공정 PROC_000032. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000016' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변이미지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPV_000046', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000017' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPV_000047', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', '도수 opt_id=2 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000017' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPV_000048', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000081', 'Y', 1, 'Y', '종이 자재 MAT_000081(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000017' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000081' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPV_000049', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000082', 'Y', 2, 'Y', '종이 자재 MAT_000082(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000017' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000082' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPV_000050', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '코팅없음', 'Y', 1, 'Y', '선택안함 센티넬(option_item 0행).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000017' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '코팅없음' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPV_000051', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '유광', 'N', 2, 'Y', '코팅 유광 공정 PROC_000014.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000017' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPV_000052', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '무광', 'N', 3, 'Y', '코팅 무광 공정 PROC_000015.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000017' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '무광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPV_000053', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '직각', 'Y', 1, 'Y', '모서리 직각 공정 PROC_000027.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000017' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '직각' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000017', 'OPV_000054', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '둥근', 'N', 2, 'Y', '모서리 둥근 공정 PROC_000028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000017' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000017' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '둥근' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000055', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000056', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', '도수 opt_id=2 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000057', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000074', 'Y', 1, 'Y', '종이 자재 MAT_000074(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000074' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000058', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000080', 'N', 2, 'Y', '종이 자재 MAT_000080(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000080' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000059', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000081', 'N', 3, 'Y', '종이 자재 MAT_000081(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000081' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000060', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000082', 'N', 4, 'Y', '종이 자재 MAT_000082(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000082' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000061', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000090', 'N', 5, 'Y', '종이 자재 MAT_000090(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000090' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000062', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000091', 'N', 6, 'Y', '종이 자재 MAT_000091(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000091' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000063', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000092', 'N', 7, 'Y', '종이 자재 MAT_000092(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000092' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000064', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '직각', 'Y', 1, 'Y', '모서리 직각 공정 PROC_000027.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '직각' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000065', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '둥근', 'N', 2, 'Y', '모서리 둥근 공정 PROC_000028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '둥근' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000066', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '오시', 'N', 1, 'Y', '후가공 오시 공정 PROC_000029. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '오시' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000067', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '미싱', 'N', 2, 'Y', '후가공 미싱 공정 PROC_000030. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '미싱' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000068', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변텍스트', 'N', 3, 'Y', '후가공 가변텍스트 공정 PROC_000031. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변텍스트' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000018', 'OPV_000069', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변이미지', 'N', 4, 'Y', '후가공 가변이미지 공정 PROC_000032. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000018' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000018' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변이미지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPV_000070', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000024' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPV_000071', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', '도수 opt_id=2 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000024' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPV_000072', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000082', 'Y', 1, 'Y', '종이 자재 MAT_000082(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000024' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000082' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPV_000073', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '코팅없음', 'Y', 1, 'Y', '선택안함 센티넬(option_item 0행).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000024' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '코팅없음' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPV_000074', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '유광', 'N', 2, 'Y', '코팅 유광 공정 PROC_000014.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000024' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPV_000075', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '무광', 'N', 3, 'Y', '코팅 무광 공정 PROC_000015.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000024' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '무광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPV_000076', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '직각', 'Y', 1, 'Y', '모서리 직각 공정 PROC_000027.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000024' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '직각' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPV_000077', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '둥근', 'N', 2, 'Y', '모서리 둥근 공정 PROC_000028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000024' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '둥근' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000024', 'OPV_000078', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='화이트별색' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '화이트인쇄(단면)', 'N', 1, 'Y', '화이트별색 공정 — BLOCKED(차원행 부재, 화이트 별색공정 미링크).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000024' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000024' AND opt_grp_nm='화이트별색' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '화이트인쇄(단면)' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000025', 'OPV_000079', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000025' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000025' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000025' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000025', 'OPV_000080', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000025' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000178', 'Y', 1, 'Y', '종이 자재 MAT_000178(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000025' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000025' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000178' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000025', 'OPV_000081', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000025' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '직각', 'Y', 1, 'Y', '모서리 직각 공정 PROC_000027.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000025' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000025' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '직각' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000025', 'OPV_000082', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000025' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '둥근', 'N', 2, 'Y', '모서리 둥근 공정 PROC_000028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000025' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000025' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '둥근' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000025', 'OPV_000083', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000025' AND opt_grp_nm='화이트별색' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '화이트인쇄(단면)', 'N', 1, 'Y', '화이트별색 공정 — BLOCKED(차원행 부재, 화이트 별색공정 미링크).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000025' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000025' AND opt_grp_nm='화이트별색' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '화이트인쇄(단면)' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000026', 'OPV_000084', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000026' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000026', 'OPV_000085', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', '도수 opt_id=2 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000026' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000026', 'OPV_000086', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000082', 'Y', 1, 'Y', '종이 자재 MAT_000082(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000026' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000082' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000026', 'OPV_000087', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '코팅없음', 'Y', 1, 'Y', '선택안함 센티넬(option_item 0행).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000026' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '코팅없음' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000026', 'OPV_000088', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '유광', 'N', 2, 'Y', '코팅 유광 공정 PROC_000014.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000026' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000026', 'OPV_000089', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '무광', 'N', 3, 'Y', '코팅 무광 공정 PROC_000015.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000026' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000026' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '무광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000090', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'Y', 1, 'Y', '도수 opt_id=1 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000091', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000074', 'Y', 1, 'Y', '종이 자재 MAT_000074(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000074' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000092', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000081', 'N', 2, 'Y', '종이 자재 MAT_000081(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000081' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000093', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000082', 'N', 3, 'Y', '종이 자재 MAT_000082(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000082' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000094', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000091', 'N', 4, 'Y', '종이 자재 MAT_000091(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000091' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000095', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000092', 'N', 5, 'Y', '종이 자재 MAT_000092(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000092' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000096', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000101', 'N', 6, 'Y', '종이 자재 MAT_000101(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000101' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000097', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000108', 'N', 7, 'Y', '종이 자재 MAT_000108(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000108' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000098', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000109', 'N', 8, 'Y', '종이 자재 MAT_000109(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000109' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000099', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000113', 'N', 9, 'Y', '종이 자재 MAT_000113(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000113' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000100', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000114', 'N', 10, 'Y', '종이 자재 MAT_000114(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000114' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000101', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000115', 'N', 11, 'Y', '종이 자재 MAT_000115(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000115' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000102', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000116', 'N', 12, 'Y', '종이 자재 MAT_000116(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000116' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000103', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000123', 'N', 13, 'Y', '종이 자재 MAT_000123(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000123' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000104', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000125', 'N', 14, 'Y', '종이 자재 MAT_000125(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000125' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000105', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변텍스트', 'N', 1, 'Y', '후가공 가변텍스트 공정 PROC_000031. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변텍스트' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000106', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변이미지', 'N', 2, 'Y', '후가공 가변이미지 공정 PROC_000032. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변이미지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000107', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='접지' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '2단 가로접지', 'Y', 1, 'Y', '접지 2단 가로접지 공정 PROC_000065. BLOCKED(차원행 부재 — 사이즈연동 동적 freeze는 GAP-B).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='접지' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '2단 가로접지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000108', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='접지' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '2단 세로접지', 'N', 2, 'Y', '접지 2단 세로접지 공정 PROC_000066. BLOCKED(차원행 부재 — 사이즈연동 동적 freeze는 GAP-B).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='접지' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '2단 세로접지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000109', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '박없음', 'Y', 1, 'Y', '선택안함 센티넬(option_item 0행).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '박없음' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000110', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '홀로그램', 'N', 2, 'Y', '박칼라 홀로그램 공정 PROC_000037. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '홀로그램' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000111', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '금유광', 'N', 3, 'Y', '박칼라 금유광 공정 PROC_000038. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '금유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000112', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '은유광', 'N', 4, 'Y', '박칼라 은유광 공정 PROC_000039. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '은유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000113', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '먹유광', 'N', 5, 'Y', '박칼라 먹유광 공정 PROC_000040. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '먹유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000114', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '동박', 'N', 6, 'Y', '박칼라 동박 공정 PROC_000041. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '동박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000115', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '적박', 'N', 7, 'Y', '박칼라 적박 공정 PROC_000042. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '적박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000116', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '청박', 'N', 8, 'Y', '박칼라 청박 공정 PROC_000043. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '청박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000027', 'OPV_000117', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '트윙클', 'N', 9, 'Y', '박칼라 트윙클 공정 PROC_000044. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000027' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000027' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '트윙클' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000118', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'Y', 1, 'Y', '도수 opt_id=1 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000119', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000074', 'Y', 1, 'Y', '종이 자재 MAT_000074(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000074' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000120', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000081', 'N', 2, 'Y', '종이 자재 MAT_000081(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000081' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000121', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000082', 'N', 3, 'Y', '종이 자재 MAT_000082(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000082' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000122', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000091', 'N', 4, 'Y', '종이 자재 MAT_000091(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000091' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000123', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000092', 'N', 5, 'Y', '종이 자재 MAT_000092(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000092' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000124', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000101', 'N', 6, 'Y', '종이 자재 MAT_000101(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000101' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000125', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000108', 'N', 7, 'Y', '종이 자재 MAT_000108(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000108' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000126', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000109', 'N', 8, 'Y', '종이 자재 MAT_000109(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000109' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000127', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000113', 'N', 9, 'Y', '종이 자재 MAT_000113(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000113' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000128', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000114', 'N', 10, 'Y', '종이 자재 MAT_000114(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000114' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000129', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000115', 'N', 11, 'Y', '종이 자재 MAT_000115(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000115' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000130', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000116', 'N', 12, 'Y', '종이 자재 MAT_000116(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000116' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000131', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000123', 'N', 13, 'Y', '종이 자재 MAT_000123(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000123' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000132', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000125', 'N', 14, 'Y', '종이 자재 MAT_000125(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000125' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000133', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변텍스트', 'N', 1, 'Y', '후가공 가변텍스트 공정 PROC_000031. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변텍스트' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000134', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변이미지', 'N', 2, 'Y', '후가공 가변이미지 공정 PROC_000032. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변이미지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000135', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='접지' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '3단 가로접지', 'Y', 1, 'Y', '접지 3단 가로접지 공정 PROC_000067. BLOCKED(차원행 부재 — 사이즈연동 동적 freeze는 GAP-B).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='접지' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '3단 가로접지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000136', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='접지' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '3단 세로접지', 'N', 2, 'Y', '접지 3단 세로접지 공정 PROC_000068. BLOCKED(차원행 부재 — 사이즈연동 동적 freeze는 GAP-B).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='접지' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '3단 세로접지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000137', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '박없음', 'Y', 1, 'Y', '선택안함 센티넬(option_item 0행).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '박없음' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000138', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '홀로그램', 'N', 2, 'Y', '박칼라 홀로그램 공정 PROC_000037. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '홀로그램' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000139', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '금유광', 'N', 3, 'Y', '박칼라 금유광 공정 PROC_000038. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '금유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000140', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '은유광', 'N', 4, 'Y', '박칼라 은유광 공정 PROC_000039. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '은유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000141', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '먹유광', 'N', 5, 'Y', '박칼라 먹유광 공정 PROC_000040. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '먹유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000142', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '동박', 'N', 6, 'Y', '박칼라 동박 공정 PROC_000041. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '동박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000143', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '적박', 'N', 7, 'Y', '박칼라 적박 공정 PROC_000042. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '적박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000144', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '청박', 'N', 8, 'Y', '박칼라 청박 공정 PROC_000043. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '청박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000029', 'OPV_000145', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '트윙클', 'N', 9, 'Y', '박칼라 트윙클 공정 PROC_000044. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000029' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000029' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '트윙클' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000146', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000147', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', '도수 opt_id=2 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000148', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000099', 'Y', 1, 'Y', '종이 자재 MAT_000099(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000099' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000149', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000101', 'N', 2, 'Y', '종이 자재 MAT_000101(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000101' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000150', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000102', 'N', 3, 'Y', '종이 자재 MAT_000102(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000102' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000151', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000108', 'N', 4, 'Y', '종이 자재 MAT_000108(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000108' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000152', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000109', 'N', 5, 'Y', '종이 자재 MAT_000109(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000109' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000153', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000113', 'N', 6, 'Y', '종이 자재 MAT_000113(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000113' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000154', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000114', 'N', 7, 'Y', '종이 자재 MAT_000114(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000114' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000155', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000115', 'N', 8, 'Y', '종이 자재 MAT_000115(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000115' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000156', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000116', 'N', 9, 'Y', '종이 자재 MAT_000116(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000116' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000157', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000117', 'N', 10, 'Y', '종이 자재 MAT_000117(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000117' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000158', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000118', 'N', 11, 'Y', '종이 자재 MAT_000118(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000118' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000159', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000119', 'N', 12, 'Y', '종이 자재 MAT_000119(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000119' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000160', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000123', 'N', 13, 'Y', '종이 자재 MAT_000123(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000123' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000161', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000124', 'N', 14, 'Y', '종이 자재 MAT_000124(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000124' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000162', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000125', 'N', 15, 'Y', '종이 자재 MAT_000125(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000125' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000163', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000126', 'N', 16, 'Y', '종이 자재 MAT_000126(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000126' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000164', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '직각', 'Y', 1, 'Y', '모서리 직각 공정 PROC_000027.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '직각' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000165', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '둥근', 'N', 2, 'Y', '모서리 둥근 공정 PROC_000028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '둥근' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000166', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변텍스트', 'N', 1, 'Y', '후가공 가변텍스트 공정 PROC_000031. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변텍스트' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000167', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변이미지', 'N', 2, 'Y', '후가공 가변이미지 공정 PROC_000032. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변이미지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000168', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '박없음', 'Y', 1, 'Y', '선택안함 센티넬(option_item 0행).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '박없음' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000169', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '홀로그램', 'N', 2, 'Y', '박칼라 홀로그램 공정 PROC_000037. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '홀로그램' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000170', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '금유광', 'N', 3, 'Y', '박칼라 금유광 공정 PROC_000038. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '금유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000171', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '은유광', 'N', 4, 'Y', '박칼라 은유광 공정 PROC_000039. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '은유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000172', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '먹유광', 'N', 5, 'Y', '박칼라 먹유광 공정 PROC_000040. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '먹유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000173', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '동박', 'N', 6, 'Y', '박칼라 동박 공정 PROC_000041. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '동박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000174', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '적박', 'N', 7, 'Y', '박칼라 적박 공정 PROC_000042. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '적박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000175', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '청박', 'N', 8, 'Y', '박칼라 청박 공정 PROC_000043. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '청박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000031', 'OPV_000176', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '트윙클', 'N', 9, 'Y', '박칼라 트윙클 공정 PROC_000044. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000031' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000031' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '트윙클' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPV_000177', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000032' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPV_000178', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', '도수 opt_id=2 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000032' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPV_000179', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000081', 'Y', 1, 'Y', '종이 자재 MAT_000081(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000032' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000081' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPV_000180', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000082', 'Y', 2, 'Y', '종이 자재 MAT_000082(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000032' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000082' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPV_000181', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '코팅없음', 'Y', 1, 'Y', '선택안함 센티넬(option_item 0행).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000032' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '코팅없음' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPV_000182', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '유광', 'N', 2, 'Y', '코팅 유광 공정 PROC_000014.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000032' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPV_000183', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '무광', 'N', 3, 'Y', '코팅 무광 공정 PROC_000015.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000032' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '무광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPV_000184', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '직각', 'Y', 1, 'Y', '모서리 직각 공정 PROC_000027.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000032' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '직각' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000032', 'OPV_000185', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '둥근', 'N', 2, 'Y', '모서리 둥근 공정 PROC_000028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000032' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000032' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '둥근' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPV_000186', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000033' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPV_000187', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', '도수 opt_id=2 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000033' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPV_000188', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000074', 'Y', 1, 'Y', '종이 자재 MAT_000074(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000033' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000074' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPV_000189', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000081', 'Y', 2, 'Y', '종이 자재 MAT_000081(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000033' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000081' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPV_000190', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000082', 'Y', 3, 'Y', '종이 자재 MAT_000082(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000033' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000082' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPV_000191', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000091', 'Y', 4, 'Y', '종이 자재 MAT_000091(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000033' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000091' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPV_000192', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000092', 'Y', 5, 'Y', '종이 자재 MAT_000092(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000033' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000092' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPV_000193', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '직각', 'Y', 1, 'Y', '모서리 직각 공정 PROC_000027.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000033' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '직각' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPV_000194', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '둥근', 'N', 2, 'Y', '모서리 둥근 공정 PROC_000028.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000033' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='모서리' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '둥근' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPV_000195', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변텍스트', 'N', 1, 'Y', '후가공 가변텍스트 공정 PROC_000031. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000033' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변텍스트' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000033', 'OPV_000196', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변이미지', 'N', 2, 'Y', '후가공 가변이미지 공정 PROC_000032. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000033' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000033' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변이미지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPV_000197', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000041' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPV_000198', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', '도수 opt_id=2 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000041' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPV_000199', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000072', 'Y', 1, 'Y', '종이 자재 MAT_000072(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000041' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000072' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPV_000200', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000078', 'Y', 2, 'Y', '종이 자재 MAT_000078(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000041' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000078' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPV_000201', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000088', 'Y', 3, 'Y', '종이 자재 MAT_000088(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000041' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000088' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPV_000202', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000105', 'Y', 4, 'Y', '종이 자재 MAT_000105(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000041' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000105' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPV_000203', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '오시', 'N', 1, 'Y', '후가공 오시 공정 PROC_000029. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000041' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '오시' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPV_000204', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '미싱', 'N', 2, 'Y', '후가공 미싱 공정 PROC_000030. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000041' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '미싱' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPV_000205', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변텍스트', 'N', 3, 'Y', '후가공 가변텍스트 공정 PROC_000031. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000041' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변텍스트' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000041', 'OPV_000206', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변이미지', 'N', 4, 'Y', '후가공 가변이미지 공정 PROC_000032. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000041' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000041' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변이미지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000207', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000208', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', '도수 opt_id=2 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000209', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000107', 'Y', 1, 'Y', '종이 자재 MAT_000107(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000107' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000210', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000118', 'Y', 2, 'Y', '종이 자재 MAT_000118(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000118' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000211', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000121', 'Y', 3, 'Y', '종이 자재 MAT_000121(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000121' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000212', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000125', 'Y', 4, 'Y', '종이 자재 MAT_000125(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000125' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000213', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000128', 'Y', 5, 'Y', '종이 자재 MAT_000128(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000128' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000214', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000129', 'Y', 6, 'Y', '종이 자재 MAT_000129(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000129' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000215', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000240', 'Y', 7, 'Y', '종이 자재 MAT_000240(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000240' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000216', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000241', 'Y', 8, 'Y', '종이 자재 MAT_000241(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000241' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000217', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '오시', 'N', 1, 'Y', '후가공 오시 공정 PROC_000029. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '오시' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000218', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '미싱', 'N', 2, 'Y', '후가공 미싱 공정 PROC_000030. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '미싱' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000219', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변텍스트', 'N', 3, 'Y', '후가공 가변텍스트 공정 PROC_000031. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변텍스트' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000220', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변이미지', 'N', 4, 'Y', '후가공 가변이미지 공정 PROC_000032. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변이미지' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000221', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '박없음', 'Y', 1, 'Y', '선택안함 센티넬(option_item 0행).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '박없음' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000222', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '홀로그램', 'N', 2, 'Y', '박칼라 홀로그램 공정 PROC_000037. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '홀로그램' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000223', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '금유광', 'N', 3, 'Y', '박칼라 금유광 공정 PROC_000038. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '금유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000224', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '은유광', 'N', 4, 'Y', '박칼라 은유광 공정 PROC_000039. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '은유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000225', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '먹유광', 'N', 5, 'Y', '박칼라 먹유광 공정 PROC_000040. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '먹유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000226', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '동박', 'N', 6, 'Y', '박칼라 동박 공정 PROC_000041. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '동박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000227', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '적박', 'N', 7, 'Y', '박칼라 적박 공정 PROC_000042. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '적박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000228', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '청박', 'N', 8, 'Y', '박칼라 청박 공정 PROC_000043. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '청박' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000042', 'OPV_000229', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '트윙클', 'N', 9, 'Y', '박칼라 트윙클 공정 PROC_000044. 박크기=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000042' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000042' AND opt_grp_nm='박칼라' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '트윙클' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000230', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'Y', 1, 'Y', '도수 opt_id=1 단면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '단면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000231', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면', 'N', 2, 'Y', '도수 opt_id=2 양면(라이브 print_options 실측).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000232', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000072', 'Y', 1, 'Y', '종이 자재 MAT_000072(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000072' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000233', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000073', 'N', 2, 'Y', '종이 자재 MAT_000073(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000073' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000234', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000074', 'N', 3, 'Y', '종이 자재 MAT_000074(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000074' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000235', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000076', 'N', 4, 'Y', '종이 자재 MAT_000076(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000076' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000236', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000077', 'N', 5, 'Y', '종이 자재 MAT_000077(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000077' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000237', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000078', 'N', 6, 'Y', '종이 자재 MAT_000078(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000078' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000238', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000079', 'N', 7, 'Y', '종이 자재 MAT_000079(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000079' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000239', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000080', 'N', 8, 'Y', '종이 자재 MAT_000080(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000080' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000240', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000081', 'N', 9, 'Y', '종이 자재 MAT_000081(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000081' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000241', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000082', 'N', 10, 'Y', '종이 자재 MAT_000082(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000082' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000242', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000086', 'N', 11, 'Y', '종이 자재 MAT_000086(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000086' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000243', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000087', 'N', 12, 'Y', '종이 자재 MAT_000087(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000087' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000244', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000088', 'N', 13, 'Y', '종이 자재 MAT_000088(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000088' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000245', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000089', 'N', 14, 'Y', '종이 자재 MAT_000089(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000089' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000246', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000090', 'N', 15, 'Y', '종이 자재 MAT_000090(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000090' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000247', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000091', 'N', 16, 'Y', '종이 자재 MAT_000091(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000091' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000248', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000092', 'N', 17, 'Y', '종이 자재 MAT_000092(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000092' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000249', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000095', 'N', 18, 'Y', '종이 자재 MAT_000095(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000095' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000250', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000096', 'N', 19, 'Y', '종이 자재 MAT_000096(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000096' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000251', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000097', 'N', 20, 'Y', '종이 자재 MAT_000097(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000097' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000252', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000098', 'N', 21, 'Y', '종이 자재 MAT_000098(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000098' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000253', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000099', 'N', 22, 'Y', '종이 자재 MAT_000099(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000099' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000254', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000101', 'N', 23, 'Y', '종이 자재 MAT_000101(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000101' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000255', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000102', 'N', 24, 'Y', '종이 자재 MAT_000102(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000102' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000256', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000104', 'N', 25, 'Y', '종이 자재 MAT_000104(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000104' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000257', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000105', 'N', 26, 'Y', '종이 자재 MAT_000105(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000105' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000258', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000106', 'N', 27, 'Y', '종이 자재 MAT_000106(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000106' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000259', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000107', 'N', 28, 'Y', '종이 자재 MAT_000107(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000107' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000260', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000108', 'N', 29, 'Y', '종이 자재 MAT_000108(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000108' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000261', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000109', 'N', 30, 'Y', '종이 자재 MAT_000109(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000109' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000262', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000113', 'N', 31, 'Y', '종이 자재 MAT_000113(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000113' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000263', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000114', 'N', 32, 'Y', '종이 자재 MAT_000114(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000114' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000264', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000115', 'N', 33, 'Y', '종이 자재 MAT_000115(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000115' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000265', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000116', 'N', 34, 'Y', '종이 자재 MAT_000116(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000116' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000266', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000117', 'N', 35, 'Y', '종이 자재 MAT_000117(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000117' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000267', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000118', 'N', 36, 'Y', '종이 자재 MAT_000118(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000118' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000268', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000119', 'N', 37, 'Y', '종이 자재 MAT_000119(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000119' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000269', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000120', 'N', 38, 'Y', '종이 자재 MAT_000120(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000120' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000270', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000121', 'N', 39, 'Y', '종이 자재 MAT_000121(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000121' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000271', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000123', 'N', 40, 'Y', '종이 자재 MAT_000123(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000123' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000272', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000124', 'N', 41, 'Y', '종이 자재 MAT_000124(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000124' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000273', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000125', 'N', 42, 'Y', '종이 자재 MAT_000125(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000125' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000274', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000126', 'N', 43, 'Y', '종이 자재 MAT_000126(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000126' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000275', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000127', 'N', 44, 'Y', '종이 자재 MAT_000127(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000127' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000276', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000128', 'N', 45, 'Y', '종이 자재 MAT_000128(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000128' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000277', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000129', 'N', 46, 'Y', '종이 자재 MAT_000129(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000129' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000278', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), 'MAT_000130', 'N', 47, 'Y', '종이 자재 MAT_000130(라이브 materials USAGE.07). opt_nm=mat_cd(이름키).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = 'MAT_000130' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000279', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '코팅없음', 'Y', 1, 'Y', '선택안함 센티넬(option_item 0행).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '코팅없음' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000280', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '유광', 'N', 2, 'Y', '코팅 유광 공정 PROC_000014.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '유광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000281', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '무광', 'N', 3, 'Y', '코팅 무광 공정 PROC_000015.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '무광' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000282', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변텍스트', 'N', 1, 'Y', '후가공 가변텍스트 공정 PROC_000031. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변텍스트' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000047', 'OPV_000283', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '가변이미지', 'N', 2, 'Y', '후가공 가변이미지 공정 PROC_000032. 다중. 줄수/개수=GAP-PARAM.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000047' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000047' AND opt_grp_nm='후가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '가변이미지' AND del_yn = 'N');
