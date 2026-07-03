-- B그룹 아크릴 부속 3상품 undo — apply.sql 역연산.
BEGIN;
-- 공식 원복 (부속 → 본체전용)
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_CLR_ACRYL', upd_dt=now()
 WHERE prd_cd IN ('PRD_000147','PRD_000149','PRD_000154') AND apply_bgn_ymd='2026-06-28'
   AND frm_cd IN ('PRF_ACRYL_MAGNET','PRF_ACRYL_CLIP','PRF_ACRYL_HAIRBAND');
-- 신규 옵션/그룹 제거 (방금 INSERT한 행 역연산)
DELETE FROM t_prd_product_options WHERE (prd_cd,opt_cd) IN
 (('PRD_000147','OPV_000465'),('PRD_000149','OPV_000468'),('PRD_000154','OPV-000028'));
DELETE FROM t_prd_product_option_groups WHERE (prd_cd,opt_grp_cd) IN
 (('PRD_000147','OPT_000074'),('PRD_000149','OPT_000076'),('PRD_000154','OPT-000014'));
COMMIT;
