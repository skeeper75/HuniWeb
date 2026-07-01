\set ON_ERROR_STOP on
BEGIN;
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, del_yn, reg_dt)
VALUES ('PRD_000288','PROC_000004','Y',-1,'N',now()),
       ('PRD_000290','PROC_000004','Y',-1,'N',now()),
       ('PRD_000292','PROC_000004','Y',-1,'N',now());
COMMIT;
