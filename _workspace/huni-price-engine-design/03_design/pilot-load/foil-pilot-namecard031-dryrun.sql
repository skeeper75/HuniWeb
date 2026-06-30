-- foil-pilot-namecard031-dryrun.sql — 멱등성·무결성 DRY-RUN (BEGIN…ROLLBACK·읽기 안전)
-- 목적: foil-pilot-namecard031-load.sql 의 INSERT 본문을 2회 적용해 (1) FK·제약 위반 없음
--       (2) 2nd 패스 0행(멱등) 을 트랜잭션 안에서 실증하고 ROLLBACK 으로 되돌린다.
--       라이브에 아무것도 남기지 않는다(COMMIT 절대 없음).
-- 실행: psql ... -v ON_ERROR_STOP=1 -f foil-pilot-namecard031-dryrun.sql
--       (이 파일은 load.sql 의 INSERT 들을 \i 하지 않고, load 본문을 BEGIN/ROLLBACK 없이 분리한
--        foil-pilot-namecard031-body.sql 을 2회 include 한다.)
\set ON_ERROR_STOP on
SET client_min_messages = warning;

BEGIN;

\echo '===== PASS 1 (신규 삽입 기대) ====='
\i foil-pilot-namecard031-body.sql

\echo '----- PASS 1 결과 카운트 -----'
SELECT comp_cd, count(*) AS rows
  FROM t_prc_component_prices
 WHERE comp_cd LIKE 'COMP_FOIL_%SMALL%'
 GROUP BY comp_cd ORDER BY comp_cd;
SELECT 'price_components' AS t, count(*) FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_FOIL_%SMALL%'
UNION ALL SELECT 'formula', count(*) FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_FIXED_FOIL'
UNION ALL SELECT 'formula_components', count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_FIXED_FOIL'
UNION ALL SELECT 'binding(031,2026-07-01)', count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000031' AND apply_bgn_ymd='2026-07-01';

\echo '===== PASS 2 (멱등 — 0행 추가 기대) ====='
-- 적용 직후 카운트를 임시로 기억
CREATE TEMP TABLE _pre AS
  SELECT (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOIL_%SMALL%') AS cp,
         (SELECT count(*) FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_FOIL_%SMALL%') AS pc,
         (SELECT count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_FIXED_FOIL') AS fc,
         (SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000031' AND apply_bgn_ymd='2026-07-01') AS bd;

\i foil-pilot-namecard031-body.sql

\echo '----- 멱등 판정 (delta=0 이어야 PASS) -----'
SELECT
  (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOIL_%SMALL%') - _pre.cp AS d_comp_prices,
  (SELECT count(*) FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_FOIL_%SMALL%') - _pre.pc AS d_components,
  (SELECT count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_FIXED_FOIL') - _pre.fc AS d_formula_comps,
  (SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000031' AND apply_bgn_ymd='2026-07-01') - _pre.bd AS d_binding,
  CASE WHEN
       (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOIL_%SMALL%') = _pre.cp
   AND (SELECT count(*) FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_FOIL_%SMALL%') = _pre.pc
   AND (SELECT count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_FIXED_FOIL') = _pre.fc
       THEN 'IDEMPOTENT: PASS' ELSE 'IDEMPOTENT: FAIL' END AS verdict
  FROM _pre;

\echo '===== ROLLBACK (라이브 무변경) ====='
ROLLBACK;
