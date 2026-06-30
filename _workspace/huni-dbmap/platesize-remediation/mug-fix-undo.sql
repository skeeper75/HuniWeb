-- 머그컵 판형 삭제 undo
BEGIN;
UPDATE t_prd_product_plate_sizes SET del_yn='N', del_dt=NULL WHERE prd_cd='PRD_000193' AND siz_cd='SIZ_000392';
-- COMMIT;
ROLLBACK;
