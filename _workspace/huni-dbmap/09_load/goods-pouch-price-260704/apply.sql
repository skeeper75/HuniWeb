-- 굿즈파우치 Phase 1 — 미적재 단일가 33상품 base 단가 적재 (t_prd_product_prices)
-- 권위 = 상품마스터 260702(=260610 변경0) 엑셀 `가격` verbatim. §21 GP-1 base 패턴 동형(pricing.py:470 unit_price×qty).
-- 멱등 UPSERT · PK=(prd_cd,apply_ymd) · apply_ymd='2026-06-10'(권위 vintage·기존 GP-1 26행과 정합). 값=스크립트 도출(손전사 0).
\set ON_ERROR_STOP on
BEGIN;
\echo '=== PRE: 대상 33상품 중 direct 단가 보유 개수(0 기대) ==='
SELECT count(*) pre FROM t_prd_product_prices WHERE prd_cd IN ('PRD_000183','PRD_000184','PRD_000188','PRD_000189','PRD_000190','PRD_000191','PRD_000192','PRD_000197','PRD_000206','PRD_000208','PRD_000209','PRD_000213','PRD_000214','PRD_000221','PRD_000227','PRD_000228','PRD_000234','PRD_000241','PRD_000242','PRD_000250','PRD_000255','PRD_000261','PRD_000262','PRD_000264','PRD_000267','PRD_000268','PRD_000269','PRD_000270','PRD_000271','PRD_000276','PRD_000277','PRD_000278','PRD_000279');
INSERT INTO t_prd_product_prices (prd_cd, apply_ymd, unit_price, note, reg_dt, upd_dt) VALUES
  ('PRD_000183','2026-06-10', 3000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000184','2026-06-10', 3600,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000188','2026-06-10', 3300,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000189','2026-06-10', 3000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000190','2026-06-10', 7000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000191','2026-06-10', 4500,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000192','2026-06-10', 5000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000197','2026-06-10', 16000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000206','2026-06-10', 12000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000208','2026-06-10', 12000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000209','2026-06-10', 35000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000213','2026-06-10', 3600,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000214','2026-06-10', 2500,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000221','2026-06-10', 10000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000227','2026-06-10', 4500,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000228','2026-06-10', 8500,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000234','2026-06-10', 15000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000241','2026-06-10', 8500,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000242','2026-06-10', 7000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000250','2026-06-10', 15000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000255','2026-06-10', 10000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000261','2026-06-10', 7500,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000262','2026-06-10', 9000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000264','2026-06-10', 58000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000267','2026-06-10', 28000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000268','2026-06-10', 17600,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000269','2026-06-10', 16500,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000270','2026-06-10', 35200,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000271','2026-06-10', 59500,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000276','2026-06-10', 22500,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000277','2026-06-10', 28000,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000278','2026-06-10', 20500,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now()),
  ('PRD_000279','2026-06-10', 25500,'GP-1 base 단일고정가 260702 verbatim 적재260704', now(), now())
ON CONFLICT (prd_cd, apply_ymd) DO UPDATE SET unit_price=EXCLUDED.unit_price, note=EXCLUDED.note, upd_dt=now();
\echo '=== POST: 대상 33 direct 보유(33 기대)·단가합 ==='
SELECT count(*) post, sum(unit_price) sum_price FROM t_prd_product_prices WHERE apply_ymd='2026-06-10' AND prd_cd IN ('PRD_000183','PRD_000184','PRD_000188','PRD_000189','PRD_000190','PRD_000191','PRD_000192','PRD_000197','PRD_000206','PRD_000208','PRD_000209','PRD_000213','PRD_000214','PRD_000221','PRD_000227','PRD_000228','PRD_000234','PRD_000241','PRD_000242','PRD_000250','PRD_000255','PRD_000261','PRD_000262','PRD_000264','PRD_000267','PRD_000268','PRD_000269','PRD_000270','PRD_000271','PRD_000276','PRD_000277','PRD_000278','PRD_000279');
-- 기대: post=33, sum_price=516800
ROLLBACK;
