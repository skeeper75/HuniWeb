-- BK-1/BK-2 · 반칼팬시(062)·반칼팬시투명(063) → PRF_STK_FIXED 바인딩 — 가격행 추가 0
-- 출처: bankal-shapes-resolution §4.1 (062/063 = B01 반칼 사이즈 124x186/90x190 + 소재 정합)
--   062 반칼팬시스티커     → B01 124x186(SIZ_059)·90x190(SIZ_060) + 유포/비코팅/미색/무광/유광 (252행 적재됨·재사용)
--   063 반칼팬시투명스티커 → B01 124x186·90x190 + 투명162 (적재됨·재사용)
-- 형상(팬시) = 반칼 칼틀(도무송 목형)·가격축 아님 → 같은 사이즈/소재면 B01과 동일 단가. 가격행 INSERT 0.
-- BLOCKED(별 파일 blocked-and-gaps.md): 058~061(A5/A4 격자 미보유)·064(소형반칼 단가 부재)·062/063 100x140(SIZ_058 미적재).
-- 멱등: PK=(prd_cd,apply_bgn_ymd) → 해당 (prd,'2026-06-01') 부재 시만 INSERT. apply_bgn_ymd='2026-06-01'(052~057 sibling).
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, reg_dt)
SELECT v.prd_cd, 'PRF_STK_FIXED', '2026-06-01', now()
FROM (VALUES ('PRD_000062'),('PRD_000063')) AS v(prd_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas pf
   WHERE pf.prd_cd=v.prd_cd AND pf.apply_bgn_ymd='2026-06-01'
);
