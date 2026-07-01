-- ============================================================================
-- poster-banner-undo.sql — poster-banner-fix COMMIT 후 원상복구
-- 2026-07-02 · 실제로 COMMIT 했을 때만 실행. dryrun(ROLLBACK)만 돌렸으면 불필요.
-- 백업 원상태 = poster-banner-backup-260701.csv. BEGIN…COMMIT 로 감싸 실행.
-- ============================================================================
BEGIN;

-- [1] 폼보드 되돌리기
DELETE FROM t_prc_formula_components
 WHERE frm_cd='PRF_POSTER_FOAMBOARD' AND comp_cd='COMP_POSTER_FOAMBOARD_BOARD';
DELETE FROM t_prc_component_prices
 WHERE comp_cd='COMP_POSTER_FOAMBOARD_BOARD';
DELETE FROM t_prc_price_components
 WHERE comp_cd='COMP_POSTER_FOAMBOARD_BOARD';
UPDATE t_prd_product_option_groups
   SET sel_typ_cd=NULL, mand_yn='N', min_sel_cnt=NULL, max_sel_cnt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000129' AND opt_grp_cd='OPT-000045';
UPDATE t_prd_product_options SET dflt_yn='N', upd_dt=now()
 WHERE prd_cd='PRD_000129' AND opt_cd='OPV-000092';
UPDATE t_prd_product_option_groups SET sel_typ_cd=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000129' AND opt_grp_cd='OPT-000044';

-- [2] 무광시트커팅 재키잉 되돌리기 (신 사이즈코드 3행만 제거)
DELETE FROM t_prc_component_prices
 WHERE comp_cd='COMP_POSTER_SHEETCUT_MATTE'
   AND siz_cd IN ('SIZ_000258','SIZ_000315','SIZ_000198');

-- [3] PET배너 거치대 되돌리기
DELETE FROM t_prc_formula_components
 WHERE frm_cd='PRF_POSTER_PET_BANNER' AND comp_cd='COMP_POSTEROPT_PET_BANNER_STAND_SEL';
DELETE FROM t_prc_component_prices
 WHERE comp_cd='COMP_POSTEROPT_PET_BANNER_STAND_SEL';
DELETE FROM t_prc_price_components
 WHERE comp_cd='COMP_POSTEROPT_PET_BANNER_STAND_SEL';

-- [4/5] 표시 sel_typ 되돌리기
UPDATE t_prd_product_option_groups
   SET sel_typ_cd=NULL, min_sel_cnt=NULL, max_sel_cnt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000118' AND opt_grp_cd='OPT-000043';
UPDATE t_prd_product_options SET dflt_yn='N', upd_dt=now()
 WHERE prd_cd='PRD_000118' AND opt_cd='OPV-000089';
UPDATE t_prd_product_option_groups SET sel_typ_cd=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000143' AND opt_grp_cd='OPT-000046';

COMMIT;
-- ============================================================================
-- 주의: [2] 시트커팅 구 사이즈행(172/174/197)은 fix 가 건드리지 않았으므로 복구 불필요.
--       폼보드 base WHITE(174/197/293)·BLACK(315/317) 컴포넌트도 fix 가 미변경 → 복구 불필요.
-- ============================================================================
