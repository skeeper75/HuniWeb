-- ─────────────────────────────────────────────────────────────────────
-- 투명엽서019 PET 용지비 미적재 교정 — DRY-RUN (ROLLBACK·미영속)
-- 권위: 인쇄상품 가격표 260527 "투명 PET 260g" 가격(국4절)=1,100 (verbatim)
--   증명: COMP_PAPER.unit_price = 가격(국4절) 컬럼 그대로
--         (백모조 100g→30.73·120g→36.88·220g→70.64 전부 라이브 일치)
-- 대상: COMP_PAPER(용지비·use_dims=[plt_siz_cd,mat_cd]) × PET(MAT_000178)
--   plt_siz_cd=SIZ_000499(316x467 전지)·min_qty=1 (COMP_PAPER 컨벤션)
-- [HARD] 실 COMMIT 아님. 적재 가능성·멱등성 검증 후 ROLLBACK.
-- ─────────────────────────────────────────────────────────────────────
BEGIN;

INSERT INTO t_prc_component_prices
       (comp_price_id, comp_cd, plt_siz_cd, mat_cd, min_qty, unit_price, apply_ymd)
SELECT (SELECT COALESCE(MAX(comp_price_id), 0) + 1 FROM t_prc_component_prices),
       'COMP_PAPER', 'SIZ_000499', 'MAT_000178', 1, 1100, '2026-06-01'
WHERE NOT EXISTS (
    SELECT 1 FROM t_prc_component_prices
    WHERE comp_cd = 'COMP_PAPER' AND mat_cd = 'MAT_000178'
      AND plt_siz_cd = 'SIZ_000499' AND min_qty = 1);

-- 검증: PET 용지비 행이 1건 생겼는가
SELECT comp_cd, plt_siz_cd, mat_cd, min_qty, unit_price, apply_ymd
  FROM t_prc_component_prices
 WHERE comp_cd = 'COMP_PAPER' AND mat_cd = 'MAT_000178';

ROLLBACK;
