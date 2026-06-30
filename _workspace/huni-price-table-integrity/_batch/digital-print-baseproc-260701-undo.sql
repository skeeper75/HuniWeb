-- UNDO — digital-print-baseproc-260701-load.sql 되돌리기(추가분 논리삭제)
BEGIN;
UPDATE t_prd_product_processes SET del_yn='Y', del_dt=now(), upd_dt=now()
WHERE proc_cd='PROC_000004'
  AND prd_cd IN ('PRD_000017','PRD_000018','PRD_000021','PRD_000022','PRD_000026',
                 'PRD_000027','PRD_000028','PRD_000029','PRD_000041','PRD_000042',
                 'PRD_000043','PRD_000044','PRD_000045','PRD_000046','PRD_000047','PRD_000284');
COMMIT;
