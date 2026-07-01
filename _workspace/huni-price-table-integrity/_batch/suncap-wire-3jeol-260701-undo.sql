-- UNDO — 썬캡 3절 이관 취소 (2026-07-01)
BEGIN;
DELETE FROM t_prc_component_prices WHERE plt_siz_cd='SIZ_000535';
DELETE FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000051' AND siz_cd='SIZ_000535';
UPDATE t_prd_product_plate_sizes SET del_yn='N', del_dt='' WHERE prd_cd='PRD_000051' AND siz_cd='SIZ_000499';
COMMIT;
-- 공정 바인딩 취소
DELETE FROM t_prd_product_processes WHERE prd_cd='PRD_000051' AND proc_cd='PROC_000004';
