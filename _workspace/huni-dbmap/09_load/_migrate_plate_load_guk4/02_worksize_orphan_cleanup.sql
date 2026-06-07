-- =====================================================================
-- 02_worksize_orphan_cleanup.sql
--   국4절 32상품 plate 교정 후 무참조가 된 작업사이즈 siz soft-delete (del_yn='Y').
--   범위 한정(32상품): 전체38 ORPHAN 62 ≠ 32범위 53.
--     제외 siz = 3절·투명 6상품(PRD_000019/025/030/039/049/112)이 여전히 참조하거나
--     그 6상품 전용인 siz(118/120/144/142/143/186/188/190/292 등). 본 라운드 미교정.
--   [HARD] §5.2 NOT EXISTS 3중 가드가 실권위 — 후보 목록이 어긋나도 잘못 삭제될 siz 0.
--   soft-delete만(del_yn 토글·물리삭제 아님) → 롤백 복원 가능, 무손실.
--   반드시 01(plate DELETE) *후* 실행해야 plate_refs=0 (FK plate→siz RESTRICT).
-- =====================================================================

UPDATE t_siz_sizes
SET del_yn = 'Y', del_dt = now()
WHERE siz_cd IN (
    'SIZ_000023', 'SIZ_000024', 'SIZ_000112', 'SIZ_000116', 'SIZ_000117',
    'SIZ_000121', 'SIZ_000122', 'SIZ_000123', 'SIZ_000125', 'SIZ_000128',
    'SIZ_000130', 'SIZ_000131', 'SIZ_000134', 'SIZ_000136', 'SIZ_000138',
    'SIZ_000140', 'SIZ_000141', 'SIZ_000145', 'SIZ_000146', 'SIZ_000149',
    'SIZ_000150', 'SIZ_000151', 'SIZ_000152', 'SIZ_000153', 'SIZ_000154',
    'SIZ_000155', 'SIZ_000156', 'SIZ_000158', 'SIZ_000159', 'SIZ_000160',
    'SIZ_000161', 'SIZ_000162', 'SIZ_000163', 'SIZ_000164', 'SIZ_000165',
    'SIZ_000166', 'SIZ_000167', 'SIZ_000168', 'SIZ_000169', 'SIZ_000177',
    'SIZ_000178', 'SIZ_000182', 'SIZ_000184', 'SIZ_000282', 'SIZ_000283',
    'SIZ_000284', 'SIZ_000285', 'SIZ_000286', 'SIZ_000287', 'SIZ_000288',
    'SIZ_000289', 'SIZ_000290', 'SIZ_000291'
  )
  AND del_yn = 'N'   -- [R1] 멱등: 2회차 이미 'Y' → 0행
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_plate_sizes x WHERE x.siz_cd = t_siz_sizes.siz_cd AND x.del_yn='N')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_sizes      x WHERE x.siz_cd = t_siz_sizes.siz_cd)
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices   x WHERE x.siz_cd = t_siz_sizes.siz_cd);

