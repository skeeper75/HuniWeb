-- 040 자재 정정 원복 (2026-06-30): 화이트(MAT_000361) 매핑 복원
BEGIN;
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL, upd_dt=now()
  WHERE prd_cd='PRD_000040' AND mat_cd='MAT_000361';
COMMIT;
