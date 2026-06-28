-- ============================================================================
-- paper-missing-fill-260629-dryrun.sql
-- 목적: COMP_PAPER(용지비) 가격구성요소를 쓰는 PRF_DGP_* 공식 바인딩 상품의
--       선택 가능 자재 중 COMP_PAPER 단가행이 없는 자재를 권위 종이표
--       "가격(국4절)" verbatim 으로 충전(FILL).
-- 권위: _workspace/huni-dbmap/06_extract/import-paper-l1.csv (가격\n(국4절))
-- 형식: 기존 57개 COMP_PAPER 행과 동형 — plt_siz_cd='SIZ_000499'·min_qty=1·apply_ymd='2026-06-01'.
-- ★ DRY-RUN 전용: BEGIN ... ROLLBACK. 실 COMMIT 금지(인간 승인 후 별도).
-- ★ 멱등: NOT EXISTS 가드. comp_price_id = MAX+offset (행마다 +1,+2,+3 고유).
-- ============================================================================
BEGIN;

-- 충전 전 기준 행수
SELECT 'BEFORE' AS phase, COUNT(*) AS comp_paper_rows
FROM t_prc_component_prices WHERE comp_cd = 'COMP_PAPER';

-- MAT_000149 아이보리 -> 권위 "아이보리" 300g · 국4절=153 [HIGH]
INSERT INTO t_prc_component_prices
  (comp_price_id, comp_cd, apply_ymd, plt_siz_cd, mat_cd, min_qty, unit_price)
SELECT (SELECT COALESCE(MAX(comp_price_id),0)+1 FROM t_prc_component_prices),
       'COMP_PAPER', '2026-06-01', 'SIZ_000499', 'MAT_000149', 1, 153
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PAPER' AND mat_cd='MAT_000149');

-- MAT_000240 스타드림(다이아) 240g -> 권위 "스타드림(다이아몬드) 240g" · 국4절=407.5 [MEDIUM-HIGH]
INSERT INTO t_prc_component_prices
  (comp_price_id, comp_cd, apply_ymd, plt_siz_cd, mat_cd, min_qty, unit_price)
SELECT (SELECT COALESCE(MAX(comp_price_id),0)+1 FROM t_prc_component_prices),
       'COMP_PAPER', '2026-06-01', 'SIZ_000499', 'MAT_000240', 1, 407.5
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PAPER' AND mat_cd='MAT_000240');

-- MAT_000241 스타드림(로츠쿼츠) 240g -> 권위 "스타드림(로즈쿼츠) 240g" · 국4절=524 [MEDIUM]
INSERT INTO t_prc_component_prices
  (comp_price_id, comp_cd, apply_ymd, plt_siz_cd, mat_cd, min_qty, unit_price)
SELECT (SELECT COALESCE(MAX(comp_price_id),0)+1 FROM t_prc_component_prices),
       'COMP_PAPER', '2026-06-01', 'SIZ_000499', 'MAT_000241', 1, 524
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PAPER' AND mat_cd='MAT_000241');

-- 충전 후 확인
SELECT 'AFTER' AS phase, COUNT(*) AS comp_paper_rows
FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER';

-- 충전된 3행 검증
SELECT comp_price_id, comp_cd, plt_siz_cd, mat_cd, min_qty, unit_price, apply_ymd
FROM t_prc_component_prices
WHERE comp_cd='COMP_PAPER' AND mat_cd IN ('MAT_000149','MAT_000240','MAT_000241')
ORDER BY mat_cd;

-- PK 충돌(중복 id) 0 확인
SELECT 'DUP_PK' AS check_name, COUNT(*) AS dup_count FROM (
  SELECT comp_price_id FROM t_prc_component_prices
  GROUP BY comp_price_id HAVING COUNT(*) > 1
) d;

ROLLBACK;
