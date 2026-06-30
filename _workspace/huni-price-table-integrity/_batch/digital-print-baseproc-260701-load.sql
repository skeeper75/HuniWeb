-- 디지털인쇄 base 공정(PROC_000004) 누락 교정 — LOAD (COMMIT) · 인간 승인 후 실행
-- 명세: digital-print-baseproc-260701.md · 기준점 016(mand='Y',disp_seq=-1) 미러 · 16상품
BEGIN;
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, del_yn, reg_dt, upd_dt)
SELECT v.prd_cd, 'PROC_000004', 'Y', -1, 'N', now(), now()
FROM (VALUES
  ('PRD_000017'),('PRD_000018'),('PRD_000021'),('PRD_000022'),('PRD_000026'),
  ('PRD_000027'),('PRD_000028'),('PRD_000029'),('PRD_000041'),('PRD_000042'),
  ('PRD_000043'),('PRD_000044'),('PRD_000045'),('PRD_000046'),('PRD_000047'),
  ('PRD_000284')
) AS v(prd_cd)
ON CONFLICT (prd_cd, proc_cd) DO UPDATE
  SET mand_proc_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();
COMMIT;
