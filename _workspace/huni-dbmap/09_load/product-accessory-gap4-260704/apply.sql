-- 상품악세사리 GAP-4 — 누락 24 variant 템플릿 신규 mint + 가격 적재
-- 권위 = 상품마스터 260702 엑셀 verbatim. 봉투 누락치수17 + 행택끈3 + 자석고무판1 + 우드행거3 = 24.
-- 채번 TMPL-000067~090(라이브 max=066 이후 연속). 값=스크립트 도출(손전사 0). 멱등 UPSERT.
\set ON_ERROR_STOP on
BEGIN;
\echo '=== PRE: 대상 24 tmpl_cd 존재수(0 기대) ==='
SELECT count(*) pre_tmpl FROM t_prd_templates WHERE tmpl_cd IN ('TMPL-000067','TMPL-000068','TMPL-000069','TMPL-000070','TMPL-000071','TMPL-000072','TMPL-000073','TMPL-000074','TMPL-000075','TMPL-000076','TMPL-000077','TMPL-000078','TMPL-000079','TMPL-000080','TMPL-000081','TMPL-000082','TMPL-000083','TMPL-000084','TMPL-000085','TMPL-000086','TMPL-000087','TMPL-000088','TMPL-000089','TMPL-000090');

-- 1) 템플릿 mint 24
INSERT INTO t_prd_templates (tmpl_cd, base_prd_cd, tmpl_nm, use_yn, del_yn, tags, reg_dt) VALUES
  ('TMPL-000067','PRD_000001','OPP접착봉투 70 x 200 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000068','PRD_000001','OPP접착봉투 80 x 100 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000069','PRD_000001','OPP접착봉투 80 x 120 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000070','PRD_000001','OPP접착봉투 80 x 180 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000071','PRD_000001','OPP접착봉투 90 x 120 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000072','PRD_000001','OPP접착봉투 100 x 100 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000073','PRD_000001','OPP접착봉투 100 x 200 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000074','PRD_000001','OPP접착봉투 160 x 230 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000075','PRD_000001','OPP접착봉투 230 x 350 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000076','PRD_000002','OPP비접착봉투 80 x 100 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000077','PRD_000002','OPP비접착봉투 80 x 120 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000078','PRD_000002','OPP비접착봉투 80 x 180 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000079','PRD_000002','OPP비접착봉투 110 x 250 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000080','PRD_000002','OPP비접착봉투 140 x 180 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000081','PRD_000002','OPP비접착봉투 140 x 200 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000082','PRD_000002','OPP비접착봉투 150 x 150 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000083','PRD_000002','OPP비접착봉투 160 x 250 mm (50장)','Y','N','[]'::jsonb, now()),
  ('TMPL-000084','PRD_000010','행택끈 사각검정 (100개)','Y','N','[]'::jsonb, now()),
  ('TMPL-000085','PRD_000010','행택끈 사각백색 (100개)','Y','N','[]'::jsonb, now()),
  ('TMPL-000086','PRD_000010','행택끈 사각마사 (100개)','Y','N','[]'::jsonb, now()),
  ('TMPL-000087','PRD_000011','자석고정용고무판 20 x 20 (20개입)','Y','N','[]'::jsonb, now()),
  ('TMPL-000088','PRD_000014','우드행거 230mm + 면끈','Y','N','[]'::jsonb, now()),
  ('TMPL-000089','PRD_000014','우드행거 320mm + 면끈','Y','N','[]'::jsonb, now()),
  ('TMPL-000090','PRD_000014','우드행거 440mm + 면끈','Y','N','[]'::jsonb, now())
ON CONFLICT (tmpl_cd) DO UPDATE SET base_prd_cd=EXCLUDED.base_prd_cd, tmpl_nm=EXCLUDED.tmpl_nm, use_yn='Y', del_yn='N', upd_dt=now();

-- 2) 가격 24
INSERT INTO t_prd_template_prices (tmpl_cd, apply_ymd, unit_price, note, reg_dt, upd_dt) VALUES
  ('TMPL-000067','2026-07-03', 1100,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000068','2026-07-03', 1100,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000069','2026-07-03', 1100,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000070','2026-07-03', 1100,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000071','2026-07-03', 1100,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000072','2026-07-03', 1100,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000073','2026-07-03', 1200,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000074','2026-07-03', 1500,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000075','2026-07-03', 3250,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000076','2026-07-03', 1000,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000077','2026-07-03', 1000,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000078','2026-07-03', 1100,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000079','2026-07-03', 1300,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000080','2026-07-03', 1400,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000081','2026-07-03', 1400,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000082','2026-07-03', 1300,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000083','2026-07-03', 1500,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000084','2026-07-03', 3000,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000085','2026-07-03', 3000,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000086','2026-07-03', 4000,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000087','2026-07-03', 1000,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000088','2026-07-03', 16000,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000089','2026-07-03', 18000,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now()),
  ('TMPL-000090','2026-07-03', 20000,'상품악세사리 GAP-4 신규치수 260704(엑셀 verbatim)', now(), now())
ON CONFLICT (tmpl_cd, apply_ymd) DO UPDATE SET unit_price=EXCLUDED.unit_price, note=EXCLUDED.note, upd_dt=now();

\echo '=== POST: 템플릿 24·가격 24 기대 ==='
SELECT (SELECT count(*) FROM t_prd_templates WHERE tmpl_cd IN ('TMPL-000067','TMPL-000068','TMPL-000069','TMPL-000070','TMPL-000071','TMPL-000072','TMPL-000073','TMPL-000074','TMPL-000075','TMPL-000076','TMPL-000077','TMPL-000078','TMPL-000079','TMPL-000080','TMPL-000081','TMPL-000082','TMPL-000083','TMPL-000084','TMPL-000085','TMPL-000086','TMPL-000087','TMPL-000088','TMPL-000089','TMPL-000090')) tmpl_cnt, (SELECT count(*) FROM t_prd_template_prices WHERE apply_ymd='2026-07-03' AND tmpl_cd IN ('TMPL-000067','TMPL-000068','TMPL-000069','TMPL-000070','TMPL-000071','TMPL-000072','TMPL-000073','TMPL-000074','TMPL-000075','TMPL-000076','TMPL-000077','TMPL-000078','TMPL-000079','TMPL-000080','TMPL-000081','TMPL-000082','TMPL-000083','TMPL-000084','TMPL-000085','TMPL-000086','TMPL-000087','TMPL-000088','TMPL-000089','TMPL-000090')) price_cnt, (SELECT sum(unit_price) FROM t_prd_template_prices WHERE apply_ymd='2026-07-03' AND tmpl_cd IN ('TMPL-000067','TMPL-000068','TMPL-000069','TMPL-000070','TMPL-000071','TMPL-000072','TMPL-000073','TMPL-000074','TMPL-000075','TMPL-000076','TMPL-000077','TMPL-000078','TMPL-000079','TMPL-000080','TMPL-000081','TMPL-000082','TMPL-000083','TMPL-000084','TMPL-000085','TMPL-000086','TMPL-000087','TMPL-000088','TMPL-000089','TMPL-000090')) sum_price;
-- 기대: tmpl_cnt=24, price_cnt=24, sum_price=87550
ROLLBACK;
