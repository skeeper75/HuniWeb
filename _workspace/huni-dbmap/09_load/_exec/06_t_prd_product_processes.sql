-- 06_t_prd_product_processes.sql
-- 단계06 상품-공정 — PK t_prd_product_processes_pkey(prd_cd, proc_cd). 라이브 excl_grp_cd 컬럼 부재 → INSERT 에서 제외(적재본 전건 공란, 손실 0).
-- 생성: gen_load_sql.py (손편집 금지). BEGIN/COMMIT 미포함 — apply.sql 가 래핑.

-- src: 06_t_prd_product_processes.csv:row2 PRD_000018/PROC_000029
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000018', 'PROC_000029', 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row3 PRD_000018/PROC_000030
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000018', 'PROC_000030', 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row4 PRD_000018/PROC_000031
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000018', 'PROC_000031', 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row5 PRD_000018/PROC_000032
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000018', 'PROC_000032', 'N', 13, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row6 PRD_000041/PROC_000029
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000041', 'PROC_000029', 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row7 PRD_000041/PROC_000030
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000041', 'PROC_000030', 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row8 PRD_000041/PROC_000031
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000041', 'PROC_000031', 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row9 PRD_000041/PROC_000032
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000041', 'PROC_000032', 'N', 13, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row10 PRD_000042/PROC_000029
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000042', 'PROC_000029', 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row11 PRD_000042/PROC_000030
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000042', 'PROC_000030', 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row12 PRD_000042/PROC_000031
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000042', 'PROC_000031', 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row13 PRD_000042/PROC_000032
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000042', 'PROC_000032', 'N', 13, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row14 PRD_000027/PROC_000031
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'PROC_000031', 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row15 PRD_000027/PROC_000032
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'PROC_000032', 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row16 PRD_000029/PROC_000031
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'PROC_000031', 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row17 PRD_000029/PROC_000032
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'PROC_000032', 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row18 PRD_000031/PROC_000031
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'PROC_000031', 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row19 PRD_000031/PROC_000032
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'PROC_000032', 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row20 PRD_000033/PROC_000031
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000033', 'PROC_000031', 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row21 PRD_000033/PROC_000032
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000033', 'PROC_000032', 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row22 PRD_000047/PROC_000031
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'PROC_000031', 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row23 PRD_000047/PROC_000032
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'PROC_000032', 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row24 PRD_000048/PROC_000031
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'PROC_000031', 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row25 PRD_000048/PROC_000032
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'PROC_000032', 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row26 PRD_000049/PROC_000031
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000049', 'PROC_000031', 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row27 PRD_000049/PROC_000032
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000049', 'PROC_000032', 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row28 PRD_000069/PROC_000051
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'PROC_000051', 'N', 51, DEFAULT, NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row29 PRD_000069/PROC_000052
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'PROC_000052', 'N', 52, DEFAULT, NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row30 PRD_000070/PROC_000051
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000070', 'PROC_000051', 'N', 51, DEFAULT, NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row31 PRD_000070/PROC_000052
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000070', 'PROC_000052', 'N', 52, DEFAULT, NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row32 PRD_000173/PROC_000023
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000173', 'PROC_000023', 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row33 PRD_000174/PROC_000023
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000174', 'PROC_000023', 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row34 PRD_000177/PROC_000021
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000177', 'PROC_000021', 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row35 PRD_000178/PROC_000021
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000178', 'PROC_000021', 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row36 PRD_000179/PROC_000022
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000179', 'PROC_000022', 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row37 PRD_000181/PROC_000018
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000181', 'PROC_000018', 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row38 PRD_000172/PROC_000015
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000172', 'PROC_000015', 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row39 PRD_000173/PROC_000015
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000173', 'PROC_000015', 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row40 PRD_000176/PROC_000015
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000176', 'PROC_000015', 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row41 PRD_000177/PROC_000015
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000177', 'PROC_000015', 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row42 PRD_000178/PROC_000015
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000178', 'PROC_000015', 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row43 PRD_000179/PROC_000015
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000179', 'PROC_000015', 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row44 PRD_000181/PROC_000015
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000181', 'PROC_000015', 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row45 PRD_000053/PROC_000008
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000053', 'PROC_000008', 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row46 PRD_000054/PROC_000008
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000054', 'PROC_000008', 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row47 PRD_000056/PROC_000008
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000056', 'PROC_000008', 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row48 PRD_000122/PROC_000008
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000122', 'PROC_000008', 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row49 PRD_000146/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000146', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row50 PRD_000147/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000147', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row51 PRD_000147/PROC_000081
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000147', 'PROC_000081', 'N', 19, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row52 PRD_000148/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000148', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row53 PRD_000149/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000149', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row54 PRD_000150/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000150', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row55 PRD_000151/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000151', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row56 PRD_000152/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000152', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row57 PRD_000155/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000155', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row58 PRD_000157/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000157', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row59 PRD_000158/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000158', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row60 PRD_000160/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000160', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row61 PRD_000161/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000161', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row62 PRD_000162/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000162', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- src: 06_t_prd_product_processes.csv:row63 PRD_000163/PROC_000002
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000163', 'PROC_000002', 'Y', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
