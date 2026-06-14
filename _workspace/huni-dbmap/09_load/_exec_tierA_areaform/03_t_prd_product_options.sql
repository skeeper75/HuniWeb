-- =====================================================================
-- step 03 — t_prd_product_options (OPV_000017~)
-- 멱등 가드 = (prd_cd, opt_grp_cd, opt_nm) NOT EXISTS. opt_grp_cd = 그룹 이름 resolve(재실행 안전).
-- 코드=라이브 MAX+1 리터럴(OPV_000017~). BLOCKED 옵션은 미적재(_blocked 기록). reg_dt 생략. 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000118', 'OPV_000017', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000118' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '코팅없음', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000118' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000118' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='코팅없음' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000118', 'OPV_000018', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000118' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '무광코팅', 'N', 2, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000118' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000118' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='무광코팅' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000118', 'OPV_000019', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000118' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '유광코팅', 'N', 3, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000118' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000118' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='유광코팅' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000120', 'OPV_000020', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000120' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '무광코팅', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000120' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000120' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='무광코팅' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000120', 'OPV_000021', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000120' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '유광코팅', 'N', 2, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000120' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000120' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='유광코팅' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000121', 'OPV_000022', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000121' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '무광코팅', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000121' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000121' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='무광코팅' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000121', 'OPV_000023', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000121' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '유광코팅', 'N', 2, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000121' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000121' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='유광코팅' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000122', 'OPV_000024', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000122' AND opt_grp_nm='화이트별색' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '단면', 'N', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000122' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000122' AND opt_grp_nm='화이트별색' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='단면' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000124', 'OPV_000025', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000124' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '오버로크', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000124' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000124' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='오버로크' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000124', 'OPV_000026', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000124' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '말아박기', 'N', 2, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000124' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000124' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='말아박기' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000124', 'OPV_000027', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000124' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '봉미싱(7cm)', 'N', 3, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000124' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000124' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='봉미싱(7cm)' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000125', 'OPV_000028', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000125' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '오버로크', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000125' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000125' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='오버로크' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000133', 'OPV_000029', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000133' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '오버로크', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000133' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000133' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='오버로크' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000133', 'OPV_000030', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000133' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '출력만', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000133' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000133' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='출력만' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000134', 'OPV_000031', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000134' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '오버로크+봉미싱(4cm)', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000134' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000134' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='오버로크+봉미싱(4cm)' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000134', 'OPV_000032', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000134' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '출력만', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000134' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000134' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='출력만' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000135', 'OPV_000033', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000135' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '사각족자', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000135' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000135' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='사각족자' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000135', 'OPV_000034', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000135' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '원형족자', 'N', 2, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000135' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000135' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='원형족자' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000135', 'OPV_000035', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000135' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '추가없음', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000135' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000135' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='추가없음' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000136', 'OPV_000036', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000136' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '무광코팅', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000136' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000136' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='무광코팅' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000136', 'OPV_000037', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000136' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '유광코팅', 'N', 2, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000136' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000136' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='유광코팅' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000136', 'OPV_000038', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000136' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '4구타공', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000136' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000136' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='4구타공' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000136', 'OPV_000039', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000136' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '거치대없음', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000136' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000136' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='거치대없음' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000137', 'OPV_000040', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000137' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '4구타공', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000137' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000137' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='4구타공' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000137', 'OPV_000041', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000137' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '거치대없음', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000137' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000137' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='거치대없음' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000139', 'OPV_000042', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000139' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '타공(4개)', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000139' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000139' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='타공(4개)' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000139', 'OPV_000043', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000139' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '타공(6개)', 'N', 2, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000139' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000139' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='타공(6개)' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000139', 'OPV_000044', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000139' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '타공(8개)', 'N', 3, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000139' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000139' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='타공(8개)' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000139', 'OPV_000045', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000139' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '추가없음', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000139' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000139' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='추가없음' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000145', 'OPV_000046', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000145' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '무광코팅', 'Y', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000145' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000145' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='무광코팅' AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
SELECT 'PRD_000145', 'OPV_000047', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000145' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '유광코팅', 'N', 2, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options
  WHERE prd_cd='PRD_000145' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000145' AND opt_grp_nm='코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm='유광코팅' AND del_yn='N');
