-- S064b · 064 → PRF_STK_FIXED 바인딩 (058~063 동형)
-- 출처: 사용자 결정(064 우선 등록). 가격 = S064a 소형 7siz 단가행 매칭.
-- 멱등: PK=(prd_cd,apply_bgn_ymd) NOT EXISTS. apply_bgn_ymd='2026-06-01'(052~063 sibling).
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, reg_dt)
SELECT 'PRD_000064','PRF_STK_FIXED','2026-06-01',now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas pf
   WHERE pf.prd_cd='PRD_000064' AND pf.apply_bgn_ymd='2026-06-01'
);
