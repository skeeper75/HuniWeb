-- sticker-stage2b-055-optitem-fix.sql — 055 옵션아이템 자재 오매핑 교정 (단계5 NO-GO 라우팅)
-- 근본: 055=옵션그룹 보유 → 시뮬레이터가 option_items.ref_key1(손님선택값)을 봄. OPV_000029 유포지=MAT_154(단가행0).
--       단가행은 MAT_153(유포스티커)에 5사이즈 완비 → ref_key1 154→153 (product_materials는 이미 153 교정됨).
\set ON_ERROR_STOP on
BEGIN;
DROP TABLE IF EXISTS bak_sticker_055_optitem_260628;
CREATE TABLE bak_sticker_055_optitem_260628 AS
  SELECT * FROM t_prd_product_option_items WHERE prd_cd='PRD_000055' AND opt_cd='OPV_000029';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000153', upd_dt=now()
 WHERE prd_cd='PRD_000055' AND opt_cd='OPV_000029' AND ref_key1='MAT_000154';
\echo '== 교정 후: OPV_000029 ref_key1 + 단가행수(기대 153·>0) =='
SELECT ref_key1, (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd=ref_key1) rows
FROM t_prd_product_option_items WHERE prd_cd='PRD_000055' AND opt_cd='OPV_000029';
COMMIT;
\echo '== 055 옵션아이템 COMMIT 완료 (undo=bak_sticker_055_optitem_260628) =='
