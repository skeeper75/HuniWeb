-- 112(와이드벽걸이캘린더) 디지털인쇄 base 공정(PROC_000004) 필수 바인딩 -- 2026-07-01 (기존 18+2건과 동형)
BEGIN;
INSERT INTO t_prd_product_processes (prd_cd,proc_cd,mand_proc_yn,disp_seq,reg_dt,del_yn)
SELECT 'PRD_000112','PROC_000004','Y','-1',now(),'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes WHERE prd_cd='PRD_000112' AND proc_cd='PROC_000004');
COMMIT;
