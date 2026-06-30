-- 굿즈 자재 오염 정리 원복 (2026-06-30)
BEGIN;
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL, upd_dt=now()
WHERE (prd_cd,mat_cd) IN (
  ('PRD_000037','MAT_000138'),('PRD_000037','MAT_000139'),('PRD_000037','MAT_000140'),('PRD_000037','MAT_000141'),
  ('PRD_000047','MAT_000129'),('PRD_000048','MAT_000129'),
  ('PRD_000072','MAT_000003'),('PRD_000077','MAT_000003'),('PRD_000082','MAT_000003'));
COMMIT;
