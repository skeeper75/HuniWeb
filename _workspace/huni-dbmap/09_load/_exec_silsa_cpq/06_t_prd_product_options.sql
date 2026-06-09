-- =====================================================================
-- step 06 — t_prd_product_options (11 options · OPV_000006~000016)
-- 멱등 가드 = (prd_cd, opt_grp_cd, opt_nm) NOT EXISTS. opt_grp_cd = 그룹 이름으로 resolve(재실행 안전).
-- 코드=라이브 MAX(OPV-000005)+1 → OPV_000006+(`_` 통일·D3). 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPV_000006', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '열재단', 'Y', 1, 'Y', 'process-only (천 자체 열절단·추가자재 없음). item=mint PROC_000084 (.04 seq1). 본 적재에서 열재단 링크 선적재→INSERTABLE.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000138' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '열재단' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPV_000007', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '타공(4개)', 'N', 2, 'Y', 'PROCESS-ONLY [bare-hole·D①]: 구멍만·아일렛 안 끼움. 공정 타공 PROC_000079 {구수:4}(.04 seq1).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000138' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '타공(4개)' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPV_000008', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '타공(6개)', 'N', 3, 'Y', 'PROCESS-ONLY [bare-hole]: 공정 타공 PROC_000079 {구수:6}(.04 seq1).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000138' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '타공(6개)' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPV_000009', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '타공(8개)', 'N', 4, 'Y', 'PROCESS-ONLY [bare-hole]: 공정 타공 PROC_000079 {구수:8}(.04 seq1).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000138' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '타공(8개)' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPV_000010', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '양면테입', 'N', 5, 'Y', 'BUNDLE: 자재 양면테입 MAT_000069(seq1 .03) + 공정 부착 PROC_000081 {대상:테입}(seq2 .04).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000138' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '양면테입' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPV_000011', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '봉미싱', 'N', 6, 'Y', 'BUNDLE [D② 실=자재]: 자재 봉제사(mint MAT_000340 seq1 .03) + 공정 봉제 PROC_000080 {유형:봉미싱}(seq2 .04).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000138' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='가공' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '봉미싱' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPV_000012', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '추가없음', 'Y', 1, 'Y', '선택안함 센티넬 (option_item 0행).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000138' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '추가없음' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPV_000013', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '큐방(4개)추가', 'N', 2, 'Y', 'BUNDLE: 자재 큐방(mint MAT_000337 seq1 .03) + 공정 부착 PROC_000081(seq2 .04). 부착 enum 큐방 부재 [CONFIRM 잔존].'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000138' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '큐방(4개)추가' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPV_000014', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '끈(4개)추가', 'N', 3, 'Y', 'BUNDLE: 자재 끈 MAT_000070(seq1 .03) + 공정 부착 PROC_000081 {대상:끈}(seq2 .04).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000138' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '끈(4개)추가' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPV_000015', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '각목(900이하)+끈(4개) 추가', 'N', 4, 'Y', 'MULTI-BUNDLE: 자재 각목900이하(mint MAT_000338 seq1) + 끈 MAT_000070(seq2) + 공정 부착 PROC_000081(seq3).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000138' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '각목(900이하)+끈(4개) 추가' AND del_yn = 'N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPV_000016', (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1), '각목(900초과)+끈(4개) 추가', 'N', 5, 'Y', 'MULTI-BUNDLE: 자재 각목900초과(mint MAT_000339 seq1) + 끈 MAT_000070(seq2) + 공정 부착 PROC_000081(seq3).'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
  WHERE prd_cd = 'PRD_000138' AND opt_grp_cd = (SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138' AND opt_grp_nm='추가' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND opt_nm = '각목(900초과)+끈(4개) 추가' AND del_yn = 'N');
