-- qty_diag2 교정 UNDO (2026-07-02) — fix 적용분 원복(라이브 사전값 verbatim)
-- 사전값 근거: _db2/product_sizes.csv 스냅샷 (2026-07-02)
BEGIN;

UPDATE t_prd_product_sizes
   SET max_qty = 1000, upd_dt = now()
 WHERE prd_cd = 'PRD_000016' AND siz_cd = 'SIZ_000001'
   AND max_qty = 10000;

UPDATE t_prd_product_sizes
   SET max_qty = 1000, upd_dt = now()
 WHERE prd_cd = 'PRD_000016' AND siz_cd = 'SIZ_000002'
   AND max_qty = 10000;

SELECT prd_cd, siz_cd, min_qty, max_qty, qty_incr
  FROM t_prd_product_sizes
 WHERE prd_cd = 'PRD_000016' AND siz_cd IN ('SIZ_000001','SIZ_000002');

COMMIT;
