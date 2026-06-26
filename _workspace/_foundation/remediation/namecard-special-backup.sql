-- =====================================================================
-- namecard-special-backup.sql — 적용 전 상태 스냅샷 (롤백 근거)
-- 생성 2026-06-27 · hpe-engine-designer · 읽기전용 SELECT(변경 0)
-- 용도: namecard-special-fix.sql(print_opt 보강) 적용 전 상태 캡처. undo 후 동일성·드리프트 검증.
-- 기대 baseline(2026-06-27): 6 상품 바인딩 0행·신규 PRF/배선 0행·태깅대상 단가행 print_opt_cd=NULL·
--   use_dims에 print_opt_cd 미포함.
-- =====================================================================

\echo '== BACKUP 1/5: 6 상품 바인딩(기대 0행) =='
SELECT prd_cd, frm_cd, apply_bgn_ymd, note FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000034','PRD_000035','PRD_000036','PRD_000037','PRD_000039','PRD_000040')
 ORDER BY prd_cd, apply_bgn_ymd;

\echo '== BACKUP 2/5: 신규 PRF 존재(기대 0행) =='
SELECT frm_cd, frm_nm, use_yn FROM t_prc_price_formulas
 WHERE frm_cd IN ('PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE','PRF_NAMECARD_FOIL',
                  'PRF_NAMECARD_CLEAR','PRF_NAMECARD_PEARL') ORDER BY frm_cd;

\echo '== BACKUP 3/5: 신규 PRF 배선(기대 0행) =='
SELECT frm_cd, comp_cd FROM t_prc_formula_components
 WHERE frm_cd IN ('PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE','PRF_NAMECARD_FOIL',
                  'PRF_NAMECARD_CLEAR','PRF_NAMECARD_PEARL') ORDER BY frm_cd, disp_seq;

\echo '== BACKUP 4/5: 태깅 대상 단가행 print_opt_cd(기대 전부 NULL) + 단가값(불변 기준) =='
SELECT comp_cd, mat_cd, siz_cd, print_opt_cd, min_qty, unit_price
  FROM t_prc_component_prices
 WHERE comp_cd IN (
   'COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2','COMP_NAMECARD_MINISHAPE_S1',
   'COMP_NAMECARD_MINISHAPE_S2','COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2',
   'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL',
   'COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL')
 ORDER BY comp_cd, min_qty;

\echo '== BACKUP 5/5: 보강 대상 comp use_dims(기대 print_opt_cd 미포함) =='
SELECT comp_cd, use_dims FROM t_prc_price_components
 WHERE comp_cd IN (
   'COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2','COMP_NAMECARD_MINISHAPE_S1',
   'COMP_NAMECARD_MINISHAPE_S2','COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2',
   'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL',
   'COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL')
 ORDER BY comp_cd;
