-- 상품악세사리 Phase 1 — 34 활성 템플릿 가격 적재 (t_prd_template_prices)
-- 권위 = 상품마스터 260702(=260610 변경0) 엑셀 `가격` verbatim. 매핑 = template-price-mapping-260703.md
-- 멱등 UPSERT · PK=(tmpl_cd, apply_ymd) · apply_ymd='2026-07-03'(효력=오늘·pricing.py _latest_ymd <= as_of)
-- 기본 ROLLBACK(DRY-RUN). 실 COMMIT은 apply.sh 가 ROLLBACK→COMMIT 치환(인간 승인 후).
\set ON_ERROR_STOP on
BEGIN;

-- 사전 상태(악세사리 템플릿 가격 = 0행 기대)
\echo '=== PRE: 악세사리 34 템플릿 중 priced 개수 ==='
SELECT count(*) AS pre_priced
FROM t_prd_template_prices tp
JOIN t_prd_templates t ON t.tmpl_cd=tp.tmpl_cd
WHERE t.base_prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015';

-- UPSERT 34행
INSERT INTO t_prd_template_prices (tmpl_cd, apply_ymd, unit_price, note, reg_dt, upd_dt) VALUES
  ('TMPL-000005','2026-07-03', 1200,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000029','2026-07-03', 1400,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000006','2026-07-03', 1200,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000012','2026-07-03',  600,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000030','2026-07-03',  900,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000038','2026-07-03', 1000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000039','2026-07-03', 1500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000040','2026-07-03', 2500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000041','2026-07-03', 2400,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000056','2026-07-03', 1000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000057','2026-07-03', 1000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000058','2026-07-03', 1000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000059','2026-07-03', 1000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000060','2026-07-03', 1000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000061','2026-07-03', 1000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000062','2026-07-03', 1000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000063','2026-07-03', 1000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000064','2026-07-03',  500,'상품악세사리 가격적재 260703(엑셀 verbatim·메탈=실버)', now(), now()),
  ('TMPL-000065','2026-07-03',  500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000066','2026-07-03',  500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000042','2026-07-03', 3000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000043','2026-07-03', 3000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000044','2026-07-03', 3500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000045','2026-07-03', 4000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000046','2026-07-03', 7000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000047','2026-07-03', 9800,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000048','2026-07-03',12000,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000049','2026-07-03', 2500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000050','2026-07-03', 2500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000051','2026-07-03', 2500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000052','2026-07-03', 2500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000053','2026-07-03', 2500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000054','2026-07-03', 2500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now()),
  ('TMPL-000055','2026-07-03', 2500,'상품악세사리 가격적재 260703(엑셀 verbatim)', now(), now())
ON CONFLICT (tmpl_cd, apply_ymd) DO UPDATE
  SET unit_price = EXCLUDED.unit_price,
      note       = EXCLUDED.note,
      upd_dt     = now();

-- 사후 검증 1: 적재 후 priced 개수 = 34 기대
\echo '=== POST: 악세사리 priced 개수 (34 기대) ==='
SELECT count(*) AS post_priced
FROM t_prd_template_prices tp
JOIN t_prd_templates t ON t.tmpl_cd=tp.tmpl_cd
WHERE t.base_prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015';

-- 사후 검증 2: 이번 적재행 34건 + unit_price 합계 (엑셀 합계와 대조: 아래 참조)
\echo '=== POST: 이번 apply_ymd=2026-07-03 적재행수·단가합 ==='
SELECT count(*) AS rows_260703, sum(unit_price) AS sum_unit_price
FROM t_prd_template_prices
WHERE apply_ymd='2026-07-03'
  AND tmpl_cd IN ('TMPL-000005','TMPL-000029','TMPL-000006','TMPL-000012','TMPL-000030',
    'TMPL-000038','TMPL-000039','TMPL-000040','TMPL-000041','TMPL-000056','TMPL-000057',
    'TMPL-000058','TMPL-000059','TMPL-000060','TMPL-000061','TMPL-000062','TMPL-000063',
    'TMPL-000064','TMPL-000065','TMPL-000066','TMPL-000042','TMPL-000043','TMPL-000044',
    'TMPL-000045','TMPL-000046','TMPL-000047','TMPL-000048','TMPL-000049','TMPL-000050',
    'TMPL-000051','TMPL-000052','TMPL-000053','TMPL-000054','TMPL-000055');
-- 기대: rows=34, sum_unit_price = 82,000
--   검산: 봉투(OPP접착2,600+OPP비접착2,700+카드2,500+캘린더4,900=12,700) + 볼체인8×1,000=8,000
--   + 와이어3×500=1,500 + 투명3(3,000+3,000+3,500=9,500) + 우드거치대4,000
--   + 우드봉(7,000+9,800+12,000=28,800) + 리필7×2,500=17,500 = 82,000

ROLLBACK;
