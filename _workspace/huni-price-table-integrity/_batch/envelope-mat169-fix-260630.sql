-- 봉투제작(PRD_000050) MAT_169(레자크줄무늬백색) 단가행 누락 교정 (2026-06-30)
-- 진단: dim_conformance.py MISSING-HIGH (자재 3종 노출인데 단가행 2종)
-- 권위: price-envelope-l1.csv C열 "레자크체크백색 110g / 레자크줄무늬백색 110g" = 동일단가 1셀
--       (라이브 MAT_168 note에도 "[레자크체크=줄무늬 동일단가]" 명시 — 줄무늬만 적재 누락)
-- 교정: MAT_168(체크) 20행(4siz×5minq)을 MAT_169(줄무늬)로 동일단가 복제. comp_price_id=MAX+seq.
BEGIN;
INSERT INTO t_prc_component_prices
  (comp_price_id, comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note, reg_dt)
SELECT (SELECT MAX(comp_price_id) FROM t_prc_component_prices)
         + row_number() OVER (ORDER BY siz_cd, min_qty),
       comp_cd, apply_ymd, siz_cd, 'MAT_000169', min_qty, unit_price,
       replace(note, '레자크체크백색 110g / 레자크줄무늬백색', '레자크줄무늬백색(=체크)'),
       now()
FROM t_prc_component_prices src
WHERE src.comp_cd = 'COMP_ENV_MAKING' AND src.mat_cd = 'MAT_000168'
  AND NOT EXISTS (
    SELECT 1 FROM t_prc_component_prices x
    WHERE x.comp_cd = 'COMP_ENV_MAKING' AND x.mat_cd = 'MAT_000169'
      AND x.siz_cd = src.siz_cd AND x.min_qty = src.min_qty);

\echo '--- 사후: MAT_169 단가행 (체크와 동일단가) ---'
SELECT siz_cd, min_qty, unit_price
  FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_ENV_MAKING' AND mat_cd = 'MAT_000169'
  ORDER BY siz_cd, min_qty;
\echo '--- 대조: 체크(168) vs 줄무늬(169) 행수 ---'
SELECT mat_cd, count(*), min(unit_price), max(unit_price)
  FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_ENV_MAKING' AND mat_cd IN ('MAT_000168','MAT_000169')
  GROUP BY mat_cd ORDER BY mat_cd;
ROLLBACK;
\echo '=== ROLLBACK (DRY-RUN) ==='
