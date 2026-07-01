-- 111/108/109 디지털인쇄 base 공정(PROC_000004) 필수 바인딩 -- 2026-07-01 (기존 18+2+2건과 동형)
BEGIN;
INSERT INTO t_prd_product_processes (prd_cd,proc_cd,mand_proc_yn,disp_seq,reg_dt,del_yn)
SELECT v.prd_cd,'PROC_000004','Y','-1',now(),'N' FROM (VALUES ('PRD_000111'),('PRD_000108'),('PRD_000109')) AS v(prd_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes WHERE prd_cd=v.prd_cd AND proc_cd='PROC_000004');
COMMIT;
