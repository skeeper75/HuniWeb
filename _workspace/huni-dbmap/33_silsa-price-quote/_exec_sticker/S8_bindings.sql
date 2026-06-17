-- S8 · 상품↔공식 바인딩 (GAP-WIRE-1) — 즉시 가능분 3상품만
-- 출처: sticker-3axis-design §2.4/§4.4 (가격 미구성 13상품 중 단가행 매칭 확정분)
--   056 낱장투명 → PRF_STK_FIXED (B03 투명 162 단가행)
--   057 대형     → PRF_STK_FIXED (B04 400x600 SIZ_000199 라이브 단가행 실존)
--   054 홀로그램 → PRF_STK_FIXED (B01 홀로 163 단가행 = S1 채운 후 매칭·단일 트랜잭션 내 선행)
-- BLOCKED(별 파일 blocked-and-gaps.md): 058~064 반칼변형(Q-STK-8)·065 팩(Q-STK-3)·066 합판(범위외)·067 타투(Q-STK-1)
-- 멱등: PK=(prd_cd,apply_bgn_ymd) → 해당 (prd_cd,'2026-06-01') 행 부재 시만 INSERT (PK 충돌·중복바인딩 0).
-- apply_bgn_ymd=sibling 관행 '2026-06-01'(052/053/055 기존 바인딩과 동일).
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, reg_dt)
SELECT v.prd_cd, 'PRF_STK_FIXED', '2026-06-01', now()
FROM (VALUES ('PRD_000054'),('PRD_000056'),('PRD_000057')) AS v(prd_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas pf
   WHERE pf.prd_cd=v.prd_cd AND pf.apply_bgn_ymd='2026-06-01'
);
