-- =============================================================================
-- jibbitz156-undo.sql (롤백본 — jibbitz156-fix.sql 되돌리기)
-- 원본(backup): nonspec_width/height_incr=NULL·dflt_qty=NULL·binding=PRF_ACRYL_ZIBITZ_TBD·use_yn=N
-- ★물리 DELETE (신규 mint한 공식/구성요소/옵션/단가행/할인링크 — 사전상태엔 없었음).
-- =============================================================================
BEGIN;

-- 역: 상품 보정 원복
UPDATE t_prd_products
   SET nonspec_width_incr=NULL, nonspec_height_incr=NULL, dflt_qty=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000156';

-- 역: 할인 링크 제거
DELETE FROM t_prd_product_discount_tables
 WHERE prd_cd='PRD_000156' AND dsc_tbl_cd='DSC_ACR_QTY' AND apply_bgn_ymd='2026-06-01';

-- 역: 바인딩 원복(_TBD)
UPDATE t_prd_product_price_formulas
   SET frm_cd='PRF_ACRYL_ZIBITZ_TBD', upd_dt=now()
 WHERE prd_cd='PRD_000156' AND frm_cd='PRF_ZIBITZ_ACRYL';

-- 역: 단가행·배선·구성요소·공식·옵션·옵션그룹 제거
DELETE FROM t_prc_component_prices WHERE comp_price_id IN (79166,79167);
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_ZIBITZ_ACRYL' AND comp_cd='COMP_ACRYL_ZIBITZ';
DELETE FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_ZIBITZ';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_ZIBITZ_ACRYL';
DELETE FROM t_prd_product_options WHERE prd_cd='PRD_000156' AND opt_cd IN ('OPV_000493','OPV_000494');
DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000156' AND opt_grp_cd='OPT_000083';

COMMIT;
