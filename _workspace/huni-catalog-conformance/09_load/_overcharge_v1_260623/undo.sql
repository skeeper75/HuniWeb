-- =====================================================================
-- undo.sql — V1 과대청구 교정 되돌리기 (가역·논리 무손실)
-- §21 카탈로그 정합 · 2026-06-23 · 되돌릴 경우에만 실행 (평시 미실행).
--
-- 원복 대상(backup-*.sql 기준값):
--   t_prc_component_prices.print_opt_cd → NULL (전 대상행)
--   t_prc_price_components.use_dims     → print_opt_cd 토큰 제거(원래값)
--     명함: ["mat_cd","min_qty"] · PCB: ["siz_cd","min_qty"]
-- 단가값(unit_price) 미변경 — 교정도 undo도 단가 불변.
-- 기본 ROLLBACK(검증 모드). 실제 되돌리려면 마지막 ROLLBACK→COMMIT.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;

-- print_opt_cd → NULL 원복
UPDATE t_prc_component_prices SET print_opt_cd = NULL
WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_PCB_S1_20P','COMP_PCB_S2_20P')
  AND print_opt_cd IS NOT NULL;

-- use_dims 토큰 제거(원래값 복원)
UPDATE t_prc_price_components SET use_dims = '["mat_cd","min_qty"]'::jsonb
WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2')
  AND use_dims IS DISTINCT FROM '["mat_cd","min_qty"]'::jsonb;
UPDATE t_prc_price_components SET use_dims = '["siz_cd","min_qty"]'::jsonb
WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P')
  AND use_dims IS DISTINCT FROM '["siz_cd","min_qty"]'::jsonb;

\echo '--- undo 후 상태 (print_opt_cd NULL·use_dims 원복 기대) ---'
SELECT comp_cd, COALESCE(print_opt_cd,'<NULL>'), count(*)
FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_PCB_S1_20P','COMP_PCB_S2_20P')
GROUP BY 1,2 ORDER BY 1;
SELECT comp_cd, use_dims::text FROM t_prc_price_components
WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_PCB_S1_20P','COMP_PCB_S2_20P')
ORDER BY comp_cd;

-- 기본 ROLLBACK. 실제 되돌릴 때만 아래를 COMMIT 으로 교체.
ROLLBACK;
