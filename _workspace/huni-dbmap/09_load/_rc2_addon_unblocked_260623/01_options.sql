-- 01_options.sql — RC-2 추가물형 신규 CPQ 옵션 INSERT (멱등 NOT EXISTS 가드)
-- PK=(prd_cd,opt_cd). reg_dt DEFAULT now()·use_yn DEFAULT Y·del_yn DEFAULT N (명시 생략 가능하나 명시).

-- src: spec §1 #1; live opt MAX OPV_000424; grp OPT_000023 disp MAX=1
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
SELECT 'PRD_000139', 'OPV_000425', 'OPT_000023', '큐방(4개)추가', 'N', 2, 'Y', 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000139' AND opt_cd='OPV_000425');

-- src: spec §1 #2; grp OPT_000023
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
SELECT 'PRD_000139', 'OPV_000426', 'OPT_000023', '끈(4개)추가', 'N', 3, 'Y', 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000139' AND opt_cd='OPV_000426');

-- src: spec §1 #5; grp OPT_000012 disp MAX=1
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
SELECT 'PRD_000133', 'OPV_000429', 'OPT_000012', '우드행거+면끈 추가', 'N', 2, 'Y', 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000133' AND opt_cd='OPV_000429');

-- src: spec §1 #6; grp OPT_000014 disp MAX=1
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
SELECT 'PRD_000134', 'OPV_000430', 'OPT_000014', '우드봉+면끈 추가', 'N', 2, 'Y', 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000134' AND opt_cd='OPV_000430');

