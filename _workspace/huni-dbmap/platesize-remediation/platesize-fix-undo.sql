-- 판형 교정 undo
\set ON_ERROR_STOP on
BEGIN;
UPDATE t_prd_product_plate_sizes SET siz_cd='SIZ_000195', upd_dt=now() WHERE prd_cd='PRD_000051' AND siz_cd='SIZ_000499' AND del_yn='N';
-- COMMIT;
ROLLBACK;
