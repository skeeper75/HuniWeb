-- goods-pouch-pilot-undo.sql — 시범 역연산: 사이즈 6연결 제거 + M/L 소재 재활성(del_yn='N')
BEGIN;
DELETE FROM t_prd_product_sizes WHERE (prd_cd,siz_cd) IN
 (('PRD_000230','SIZ_000433'),('PRD_000230','SIZ_000434'),
  ('PRD_000231','SIZ_000435'),('PRD_000231','SIZ_000436'),
  ('PRD_000232','SIZ_000437'),('PRD_000232','SIZ_000438'));
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL
 WHERE prd_cd IN ('PRD_000230','PRD_000231','PRD_000232') AND mat_cd IN ('MAT_000319','MAT_000320');
COMMIT;
