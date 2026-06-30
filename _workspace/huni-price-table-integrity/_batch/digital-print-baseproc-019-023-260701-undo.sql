BEGIN;
UPDATE t_prd_product_processes SET del_yn='Y', del_dt=now(), upd_dt=now()
WHERE proc_cd='PROC_000004' AND prd_cd IN ('PRD_000019','PRD_000023');
COMMIT;
