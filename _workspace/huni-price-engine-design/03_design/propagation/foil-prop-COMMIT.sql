-- foil-prop-COMMIT.sql — 박류 동형 전파 실 적재 (인간 승인 2026-06-30·지니)
-- 원본 적재본 foil-prop-load.sql(ROLLBACK)의 COMMIT 실행본. body는 절대경로 참조(cwd 무관).
-- 단일 psql 세션·단일 트랜잭션·ON_ERROR_STOP(에러 시 자동 ABORT=무변경). undo=foil-prop-undo.sql.
-- 기대 INSERT: comps 3·단가행 7,168(512/3328/3328)·formulas 5·formula_components 38·bindings 6 = 7,220.
\set ON_ERROR_STOP on
SET client_min_messages = warning;
BEGIN;

\i /Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/propagation/foil-prop-body.sql

-- 사후검증 (트랜잭션 내·COMMIT 전 확인):
SELECT comp_cd, count(*) AS rows
  FROM t_prc_component_prices
 WHERE comp_cd LIKE 'COMP_FOIL_%LARGE%'
 GROUP BY comp_cd ORDER BY comp_cd;

COMMIT;

-- 사후검증 (COMMIT 후·바인딩):
SELECT prd_cd, frm_cd, apply_bgn_ymd
  FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000027','PRD_000029','PRD_000034','PRD_000042','PRD_000069','PRD_000070')
   AND apply_bgn_ymd='2026-07-01'
 ORDER BY prd_cd;
