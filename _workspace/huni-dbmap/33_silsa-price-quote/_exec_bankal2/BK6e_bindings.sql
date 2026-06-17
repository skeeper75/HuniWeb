-- BK6e · 058~061 → PRF_STK_FIXED 바인딩 (062/063 동형) — t_prd_product_price_formulas
-- 출처: bankal-058-064-deepcheck §5.2 (A5/A4 단가 적재 후 가격 연결)
--   058 반칼원형·059 반칼정사각·060 반칼직사각·061 반칼띠지 → PRF_STK_FIXED
--   가격 = A5(SIZ_170·col1)·A4반칼(SIZ_520·col2) 단가 매칭. 형상(조각)=칼틀·가격 무관.
-- 멱등: PK=(prd_cd,apply_bgn_ymd) NOT EXISTS. apply_bgn_ymd='2026-06-01'(052~063 sibling).
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, reg_dt)
SELECT v.prd_cd, 'PRF_STK_FIXED', '2026-06-01', now()
FROM (VALUES ('PRD_000058'),('PRD_000059'),('PRD_000060'),('PRD_000061')) AS v(prd_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas pf
   WHERE pf.prd_cd=v.prd_cd AND pf.apply_bgn_ymd='2026-06-01'
);
