-- =====================================================================
-- step 06 — t_prd_product_options (스티커 4상품 · 22행)
-- 멱등 가드 = (prd_cd, opt_nm, opt_grp resolve, del_yn='N') NOT EXISTS. 코드=라이브 MAX(OPV_000016)+1 → OPV_000017~ (`_`).
--   opt_grp_cd = opt_grp_nm resolve(05 선행, 같은 트랜잭션). opt_nm = 차원행 사람읽는 라벨.
-- 트리거 없음. reg_dt 생략→DEFAULT now(). use_yn/del_yn NOT NULL. 손편집 금지.
-- =====================================================================

-- ===== PRD_000052 종이(5) =====
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000052','OPV_000017',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='종이' AND del_yn='N'),'유포스티커','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='유포스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000052','OPV_000018',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='종이' AND del_yn='N'),'비코팅스티커','N',2,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='비코팅스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000052','OPV_000019',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='종이' AND del_yn='N'),'무광코팅스티커','N',3,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='무광코팅스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000052','OPV_000020',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='종이' AND del_yn='N'),'유광코팅스티커','N',4,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='유광코팅스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000052','OPV_000021',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='종이' AND del_yn='N'),'미색스티커','N',5,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='미색스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
-- PRD_000052 인쇄(1)
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000052','OPV_000022',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='인쇄' AND del_yn='N'),'단면','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='인쇄' AND del_yn='N') AND del_yn='N');
-- PRD_000052 커팅(1)
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000052','OPV_000023',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='커팅' AND del_yn='N'),'반칼(자유형)','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='반칼(자유형)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='커팅' AND del_yn='N') AND del_yn='N');

-- ===== PRD_000053 종이(1)·인쇄(1)·화이트별색(2)·커팅(1) =====
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000053','OPV_000024',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='종이' AND del_yn='N'),'투명스티커','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='투명스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000053','OPV_000025',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='인쇄' AND del_yn='N'),'단면','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='인쇄' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000053','OPV_000026',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='화이트별색' AND del_yn='N'),'화이트없음','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='화이트없음' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='화이트별색' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000053','OPV_000027',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='화이트별색' AND del_yn='N'),'화이트인쇄','N',2,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='화이트인쇄' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='화이트별색' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000053','OPV_000028',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='커팅' AND del_yn='N'),'반칼(자유형)','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='반칼(자유형)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='커팅' AND del_yn='N') AND del_yn='N');

-- ===== PRD_000055 종이(1)·인쇄(1)·커팅(1) =====
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000055','OPV_000029',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000055' AND opt_grp_nm='종이' AND del_yn='N'),'유포지','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000055' AND opt_nm='유포지' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000055' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000055','OPV_000030',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000055' AND opt_grp_nm='인쇄' AND del_yn='N'),'단면','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000055' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000055' AND opt_grp_nm='인쇄' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000055','OPV_000031',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000055' AND opt_grp_nm='커팅' AND del_yn='N'),'완칼(자유형)','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000055' AND opt_nm='완칼(자유형)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000055' AND opt_grp_nm='커팅' AND del_yn='N') AND del_yn='N');

-- ===== PRD_000066 종이(6)·인쇄(1) =====
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000066','OPV_000032',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N'),'유포스티커','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='유포스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000066','OPV_000033',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N'),'비코팅스티커','N',2,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='비코팅스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000066','OPV_000034',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N'),'무광코팅스티커','N',3,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='무광코팅스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000066','OPV_000035',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N'),'유광코팅스티커','N',4,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='유광코팅스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000066','OPV_000036',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N'),'투명데드롱스티커','N',5,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='투명데드롱스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000066','OPV_000037',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N'),'은데드롱스티커','N',6,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='은데드롱스티커' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N') AND del_yn='N');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000066','OPV_000038',(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='인쇄' AND del_yn='N'),'단면','Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='인쇄' AND del_yn='N') AND del_yn='N');
