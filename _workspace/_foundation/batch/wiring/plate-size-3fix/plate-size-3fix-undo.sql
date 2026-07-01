BEGIN;

DELETE FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000095','PRD_000098','PRD_000101') AND siz_cd='SIZ_000499';

UPDATE t_prd_product_plate_sizes SET del_yn='N', del_dt=NULL
WHERE prd_cd IN ('PRD_000094','PRD_000097','PRD_000100');

COMMIT;
