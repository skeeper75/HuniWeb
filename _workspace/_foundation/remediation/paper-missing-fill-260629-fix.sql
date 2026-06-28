-- ============================================================================
-- paper-missing-fill-260629-fix.sql  (COMMIT · 인간 승인 2026-06-29: 3건 전부)
-- COMP_PAPER 미적재 자재 3건 충전 — 권위 가격표 "가격(국4절)" verbatim.
-- DRY-RUN 선검증 완료(paper-missing-fill-260629-dryrun.sql · BEFORE57→AFTER60 · DUP_PK 0).
-- ============================================================================
BEGIN;

-- MAT_000149 아이보리 -> 권위 "아이보리" · 국4절=153
INSERT INTO t_prc_component_prices
  (comp_price_id, comp_cd, apply_ymd, plt_siz_cd, mat_cd, min_qty, unit_price)
SELECT (SELECT COALESCE(MAX(comp_price_id),0)+1 FROM t_prc_component_prices),
       'COMP_PAPER', '2026-06-01', 'SIZ_000499', 'MAT_000149', 1, 153
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PAPER' AND mat_cd='MAT_000149');

-- MAT_000240 스타드림(다이아) 240g -> 권위 "스타드림(다이아몬드) 240g" · 국4절=407.5
INSERT INTO t_prc_component_prices
  (comp_price_id, comp_cd, apply_ymd, plt_siz_cd, mat_cd, min_qty, unit_price)
SELECT (SELECT COALESCE(MAX(comp_price_id),0)+1 FROM t_prc_component_prices),
       'COMP_PAPER', '2026-06-01', 'SIZ_000499', 'MAT_000240', 1, 407.5
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PAPER' AND mat_cd='MAT_000240');

-- MAT_000241 스타드림(로츠쿼츠) 240g -> 권위 "스타드림(로즈쿼츠) 240g" · 국4절=524
--   ※ 로츠쿼츠↔로즈쿼츠 1글자차(오타 판단)·사용자 승인 3건 전부. 색상 상이 시 실무진 교정.
INSERT INTO t_prc_component_prices
  (comp_price_id, comp_cd, apply_ymd, plt_siz_cd, mat_cd, min_qty, unit_price)
SELECT (SELECT COALESCE(MAX(comp_price_id),0)+1 FROM t_prc_component_prices),
       'COMP_PAPER', '2026-06-01', 'SIZ_000499', 'MAT_000241', 1, 524
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PAPER' AND mat_cd='MAT_000241');

SELECT comp_cd, mat_cd, unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_PAPER' AND mat_cd IN ('MAT_000149','MAT_000240','MAT_000241') ORDER BY mat_cd;

COMMIT;

-- UNDO: DELETE FROM t_prc_component_prices
--        WHERE comp_cd='COMP_PAPER' AND mat_cd IN ('MAT_000149','MAT_000240','MAT_000241') AND plt_siz_cd='SIZ_000499';
