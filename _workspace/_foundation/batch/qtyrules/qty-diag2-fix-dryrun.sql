-- qty_diag2 교정 제안 DRY-RUN (2026-07-02) — 실행 승인 전 검증 전용, 종결자 ROLLBACK
-- 근거: qty_diag2.py 진단 → fix-candidates.csv
--   FIX_SIZE_MIN: 0건 (SIZE_TRAP NEW 0 — FOIL 6상품=제약트랙 보류·미니 2상품=실무진 컨펌 보류)
--   FIX_MAX_SIZE: 2건 — 프리미엄엽서(PRD_000016) 사이즈 max_qty 1000 → 권위 10000 (verbatim)
--     권위: 상품마스터 260610 digital-print 시트 "제작수량(필수)_최대"
--       73 x 98 mm  = 15/10000/15  (live: 15/1000/15)
--       98 x 98 mm  = 12/10000/12  (live: 12/1000/12)
BEGIN;

-- [사전 상태 확인]
SELECT prd_cd, siz_cd, min_qty, max_qty, qty_incr
  FROM t_prd_product_sizes
 WHERE prd_cd = 'PRD_000016' AND siz_cd IN ('SIZ_000001','SIZ_000002');

-- FIX_MAX_SIZE 1/2: 프리미엄엽서 73x98 (SIZ_000001) max 1000 → 10000
UPDATE t_prd_product_sizes
   SET max_qty = 10000, upd_dt = now()
 WHERE prd_cd = 'PRD_000016' AND siz_cd = 'SIZ_000001'
   AND max_qty = 1000;   -- 멱등 가드(이미 교정됐으면 0행)

-- FIX_MAX_SIZE 2/2: 프리미엄엽서 98x98 (SIZ_000002) max 1000 → 10000
UPDATE t_prd_product_sizes
   SET max_qty = 10000, upd_dt = now()
 WHERE prd_cd = 'PRD_000016' AND siz_cd = 'SIZ_000002'
   AND max_qty = 1000;

-- [사후 검증] 기대: 두 행 모두 max_qty=10000, min/incr 불변(15/15, 12/12)
SELECT prd_cd, siz_cd, min_qty, max_qty, qty_incr
  FROM t_prd_product_sizes
 WHERE prd_cd = 'PRD_000016' AND siz_cd IN ('SIZ_000001','SIZ_000002');

ROLLBACK;  -- DRY-RUN — 실 COMMIT은 인간 승인 후 별도(qty-diag2-fix-undo.sql 보유)
