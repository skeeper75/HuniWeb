-- =====================================================================
-- namecard-special-undo.sql — 롤백 전용 (namecard-special-fix.sql 역연산)
-- 생성 2026-06-27 · hpe-engine-designer · 인간 승인 후에만 실행
-- 안전: 단일 트랜잭션. 역위상 = 바인딩 → 배선 → PRF → use_dims → 태깅.
--   ★단가값(unit_price)은 fix가 미변경이므로 undo도 미변경. print_opt_cd 태깅·use_dims만 원복.
--   ★주의: 태깅 원복(print_opt_cd→NULL)은 fix가 채운 12행만 대상. STD 등 원래 채워진 행은 무관.
-- =====================================================================
BEGIN;

\echo '== UNDO 1/5: 바인딩 4 삭제(apply_bgn_ymd=2026-06-27) =='
DELETE FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000035','PRD_000036','PRD_000037','PRD_000039')
   AND apply_bgn_ymd = '2026-06-27'
   AND frm_cd IN ('PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE',
                  'PRF_NAMECARD_FOIL','PRF_NAMECARD_CLEAR');

\echo '== UNDO 2/5: 배선 9 삭제 =='
DELETE FROM t_prc_formula_components
 WHERE frm_cd IN ('PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE','PRF_NAMECARD_FOIL',
                  'PRF_NAMECARD_CLEAR','PRF_NAMECARD_PEARL');

\echo '== UNDO 3/5: 전용 PRF 5 삭제 =='
DELETE FROM t_prc_price_formulas
 WHERE frm_cd IN ('PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE','PRF_NAMECARD_FOIL',
                  'PRF_NAMECARD_CLEAR','PRF_NAMECARD_PEARL');

\echo '== UNDO 4/5: use_dims에서 print_opt_cd 제거(10 comp) =='
UPDATE t_prc_price_components
   SET use_dims = (use_dims - 'print_opt_cd'), upd_dt = now()
 WHERE comp_cd IN (
         'COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2',
         'COMP_NAMECARD_MINISHAPE_S1','COMP_NAMECARD_MINISHAPE_S2',
         'COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2',
         'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL',
         'COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL')
   AND (use_dims ? 'print_opt_cd');

\echo '== UNDO 5/5: print_opt_cd 태깅 원복(NULL, 12행) — fix가 채운 명함특수 comp만 =='
UPDATE t_prc_component_prices
   SET print_opt_cd = NULL, upd_dt = now()
 WHERE comp_cd IN (
         'COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2',
         'COMP_NAMECARD_MINISHAPE_S1','COMP_NAMECARD_MINISHAPE_S2',
         'COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2',
         'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL',
         'COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL')
   AND print_opt_cd IN ('POPT_000001','POPT_000002');

\echo '== UNDO VERIFY: 잔여 기대 0 / 태깅 원복 / 단가 불변 =='
SELECT 'binding' AS scope, count(*) AS remain FROM t_prd_product_price_formulas
 WHERE frm_cd LIKE 'PRF_NAMECARD_%' AND frm_cd<>'PRF_NAMECARD_FIXED' AND apply_bgn_ymd='2026-06-27'
UNION ALL SELECT 'wiring', count(*) FROM t_prc_formula_components
 WHERE frm_cd IN ('PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE','PRF_NAMECARD_FOIL','PRF_NAMECARD_CLEAR','PRF_NAMECARD_PEARL')
UNION ALL SELECT 'formula', count(*) FROM t_prc_price_formulas
 WHERE frm_cd IN ('PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE','PRF_NAMECARD_FOIL','PRF_NAMECARD_CLEAR','PRF_NAMECARD_PEARL')
UNION ALL SELECT 'tagged_remain', count(*) FROM t_prc_component_prices
 WHERE comp_cd LIKE 'COMP_NAMECARD_SHAPE_%' AND print_opt_cd IS NOT NULL;

COMMIT;
