-- =====================================================================
-- 01_comp_paper_gap.sql — 디지털 국4절 종이비 GAP 멱등 적재
--   대상: t_prc_component_prices, comp_cd='COMP_PAPER'
--   행수: 7 (즉시 채움 GAP — 자연키 동시매칭 0 실측 확인)
--
--   ★ 멱등 방식 = INSERT … SELECT … WHERE NOT EXISTS (NULL-safe 자연키 가드)
--      이유: 자연키 UNIQUE 인덱스 ux_t_prc_comp_prices_nat_key 는 NULLS DISTINCT
--      (pg_index.indnullsnotdistinct = f). 자연키 10컬럼 중 6컬럼(clr/proc/opt/
--      coat_side_cnt/bdl_qty/min_qty)이 NULL 이므로 ON CONFLICT 가 발화하지 않는다
--      (라이브 DRY-RUN 실증: ON CONFLICT 2회차 → 중복 2행 = 멱등 깨짐).
--      → NOT EXISTS 가드로 NULL-safe 멱등 보장(2회차 INSERT 0 0 실증).
--      값 정정이 필요하면 별도 UPDATE 로 처리(현 GAP은 신규 채움이라 INSERT만).
--
--   reg_dt 생략(DEFAULT now() 발화·명시 NULL 금지) · comp_price_id IDENTITY 비명시(자동 채번)
--
--   apply_ymd = '2026-06-01' 고정 (기존 세대 합류 — 사용자 확정)
--     단가행은 엔진 _latest 미적용 → 적용일 분기 시 중복 매칭 위험 → 신규 개정일 금지.
--   siz_cd = SIZ_000499 (316x467 국4절 출력용지규격, round-7 교정 완료·재사용)
--   clr/proc/opt/coat_side_cnt/bdl_qty/min_qty = NULL (용지비는 색·공정·옵션·수량 무관)
--   prc_typ는 component_prices에 컬럼 없음 — comp_cd=COMP_PAPER가 price_components에서
--     PRICE_TYPE.01(단가형)로 이미 정의됨(상속). 이 단가행은 차원+unit_price만.
--
--   provenance: 단가 = 가격표 출력소재(IMPORT) 시트 I열(국4절가) 실값.
--     ★ unit_price = numeric(12,2) — 소수 셋째자리는 round-half-up 으로 둘째자리 저장.
--       라이브 49 RU 전체가 동일 관례(가격표 36.875 → RU 36.88, 54.865 → 54.87).
--       무손실 위반 아님 = 컬럼 제약 honor. 가격표값(권위) → 라이브 저장값:
--     | mat_cd     | mat_nm            | 가격표 행 | I(국4절) | 라이브 저장 |
--     | MAT_000096 | 앙상블 130g       | R22       | 71.33    | 71.33       |
--     | MAT_000097 | 앙상블 160g       | R23       | 87.795   | 87.80       |
--     | MAT_000098 | 앙상블 190g       | R24       | 104.24   | 104.24      |
--     | MAT_000099 | 앙상블 210g       | R25       | 115.23   | 115.23      |
--     | MAT_000119 | 리브스디자인 250g | R40       | 500      | 500.00      |
--     | MAT_000123 | 띤또레또 200g     | R43       | 245      | 245.00      |
--     | MAT_000124 | 띤또레또 250g     | R44       | 306      | 306.00      |
--
--   ★ 정정: output-material-import-decompose.md §5 A "8행"은 클래식스티플 270g을
--     8번째로 포함했으나, 라이브 실측 결과 클래식 크래스트 스티플 270g(MAT_000118)은
--     이미 COMP_PAPER에 480.00으로 적재된 RU(GAP 아님) → 즉시 채움 GAP = 7행으로 정정.
--     (decomposition.md §5.2 GAP 표와 정합. live existence is authority.)
-- =====================================================================
\set ON_ERROR_STOP on

-- 멱등 INSERT 헬퍼: 자연키(10컬럼) NOT EXISTS 가드. 같은 자연키 행이 이미 있으면 0행.
-- 각 행을 개별 SELECT…WHERE NOT EXISTS 로 적재(7행).

-- (1) 앙상블 130g  MAT_000096  R22  71.33
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty, min_qty, unit_price)
SELECT 'COMP_PAPER','2026-06-01','SIZ_000499',NULL::varchar,'MAT_000096',NULL::varchar,NULL::varchar,NULL::int,NULL::int,NULL::int,71.33
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_PAPER' AND x.apply_ymd='2026-06-01' AND x.siz_cd='SIZ_000499'
    AND x.clr_cd IS NULL AND x.mat_cd='MAT_000096' AND x.proc_cd IS NULL AND x.opt_cd IS NULL
    AND x.coat_side_cnt IS NULL AND x.bdl_qty IS NULL AND x.min_qty IS NULL);

-- (2) 앙상블 160g  MAT_000097  R23  87.795
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty, min_qty, unit_price)
SELECT 'COMP_PAPER','2026-06-01','SIZ_000499',NULL::varchar,'MAT_000097',NULL::varchar,NULL::varchar,NULL::int,NULL::int,NULL::int,87.795
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_PAPER' AND x.apply_ymd='2026-06-01' AND x.siz_cd='SIZ_000499'
    AND x.clr_cd IS NULL AND x.mat_cd='MAT_000097' AND x.proc_cd IS NULL AND x.opt_cd IS NULL
    AND x.coat_side_cnt IS NULL AND x.bdl_qty IS NULL AND x.min_qty IS NULL);

-- (3) 앙상블 190g  MAT_000098  R24  104.24
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty, min_qty, unit_price)
SELECT 'COMP_PAPER','2026-06-01','SIZ_000499',NULL::varchar,'MAT_000098',NULL::varchar,NULL::varchar,NULL::int,NULL::int,NULL::int,104.24
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_PAPER' AND x.apply_ymd='2026-06-01' AND x.siz_cd='SIZ_000499'
    AND x.clr_cd IS NULL AND x.mat_cd='MAT_000098' AND x.proc_cd IS NULL AND x.opt_cd IS NULL
    AND x.coat_side_cnt IS NULL AND x.bdl_qty IS NULL AND x.min_qty IS NULL);

-- (4) 앙상블 210g  MAT_000099  R25  115.23
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty, min_qty, unit_price)
SELECT 'COMP_PAPER','2026-06-01','SIZ_000499',NULL::varchar,'MAT_000099',NULL::varchar,NULL::varchar,NULL::int,NULL::int,NULL::int,115.23
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_PAPER' AND x.apply_ymd='2026-06-01' AND x.siz_cd='SIZ_000499'
    AND x.clr_cd IS NULL AND x.mat_cd='MAT_000099' AND x.proc_cd IS NULL AND x.opt_cd IS NULL
    AND x.coat_side_cnt IS NULL AND x.bdl_qty IS NULL AND x.min_qty IS NULL);

-- (5) 리브스디자인 250g  MAT_000119  R40  500
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty, min_qty, unit_price)
SELECT 'COMP_PAPER','2026-06-01','SIZ_000499',NULL::varchar,'MAT_000119',NULL::varchar,NULL::varchar,NULL::int,NULL::int,NULL::int,500
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_PAPER' AND x.apply_ymd='2026-06-01' AND x.siz_cd='SIZ_000499'
    AND x.clr_cd IS NULL AND x.mat_cd='MAT_000119' AND x.proc_cd IS NULL AND x.opt_cd IS NULL
    AND x.coat_side_cnt IS NULL AND x.bdl_qty IS NULL AND x.min_qty IS NULL);

-- (6) 띤또레또 200g  MAT_000123  R43  245
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty, min_qty, unit_price)
SELECT 'COMP_PAPER','2026-06-01','SIZ_000499',NULL::varchar,'MAT_000123',NULL::varchar,NULL::varchar,NULL::int,NULL::int,NULL::int,245
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_PAPER' AND x.apply_ymd='2026-06-01' AND x.siz_cd='SIZ_000499'
    AND x.clr_cd IS NULL AND x.mat_cd='MAT_000123' AND x.proc_cd IS NULL AND x.opt_cd IS NULL
    AND x.coat_side_cnt IS NULL AND x.bdl_qty IS NULL AND x.min_qty IS NULL);

-- (7) 띤또레또 250g  MAT_000124  R44  306
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty, min_qty, unit_price)
SELECT 'COMP_PAPER','2026-06-01','SIZ_000499',NULL::varchar,'MAT_000124',NULL::varchar,NULL::varchar,NULL::int,NULL::int,NULL::int,306
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_PAPER' AND x.apply_ymd='2026-06-01' AND x.siz_cd='SIZ_000499'
    AND x.clr_cd IS NULL AND x.mat_cd='MAT_000124' AND x.proc_cd IS NULL AND x.opt_cd IS NULL
    AND x.coat_side_cnt IS NULL AND x.bdl_qty IS NULL AND x.min_qty IS NULL);
