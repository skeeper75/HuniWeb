-- foil-prop-dryrun.sql — 박 동형전파 멱등 DRY-RUN (라이브 BEGIN…body 2회…ROLLBACK·무변경)
-- R1 멱등성 + R5 제약위반 0 증명: body 를 한 트랜잭션 안에서 2회 \i 하고, 2회차 delta=0 을 판정한 뒤 ROLLBACK.
-- [HARD] COMMIT 없음 — 라이브 무변경(롤백전용). 자격증명은 psql -v 또는 환경에서.
\set ON_ERROR_STOP on
SET client_min_messages = warning;
BEGIN;

-- 적재 전 기준 카운트
SELECT 'BASELINE' AS phase,
  (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOIL_%LARGE%')          AS large_prices,
  (SELECT count(*) FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_FOIL_%LARGE%')           AS large_comps,
  (SELECT count(*) FROM t_prc_price_formulas WHERE frm_cd LIKE '%_FOIL' AND frm_cd <> 'PRF_NAMECARD_FIXED_FOIL') AS foil_formulas,
  (SELECT count(*) FROM t_prc_formula_components WHERE frm_cd LIKE '%_FOIL' AND frm_cd <> 'PRF_NAMECARD_FIXED_FOIL') AS foil_fc,
  (SELECT count(*) FROM t_prd_product_price_formulas WHERE apply_bgn_ymd='2026-07-01' AND prd_cd IN ('PRD_000027','PRD_000029','PRD_000034','PRD_000042','PRD_000069','PRD_000070')) AS bindings
\gset base_

-- ===== PASS 1: 신규 삽입 =====
\echo '--- PASS 1 (insert) ---'
\i foil-prop-body.sql

SELECT 'AFTER_PASS1' AS phase,
  (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOIL_%LARGE%')          AS large_prices,
  (SELECT count(*) FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_FOIL_%LARGE%')           AS large_comps,
  (SELECT count(*) FROM t_prc_price_formulas WHERE frm_cd LIKE '%_FOIL' AND frm_cd <> 'PRF_NAMECARD_FIXED_FOIL') AS foil_formulas,
  (SELECT count(*) FROM t_prc_formula_components WHERE frm_cd LIKE '%_FOIL' AND frm_cd <> 'PRF_NAMECARD_FIXED_FOIL') AS foil_fc,
  (SELECT count(*) FROM t_prd_product_price_formulas WHERE apply_bgn_ymd='2026-07-01' AND prd_cd IN ('PRD_000027','PRD_000029','PRD_000034','PRD_000042','PRD_000069','PRD_000070')) AS bindings
\gset p1_

-- 적재 행수 검증 (대형 단가행 7168 = 512 + 3328 + 3328·comps 3·formulas 3·fc 38·bindings 6)
SELECT comp_cd, count(*) AS rows FROM t_prc_component_prices
 WHERE comp_cd LIKE 'COMP_FOIL_%LARGE%' GROUP BY comp_cd ORDER BY comp_cd;

-- ===== PASS 2: 재적용 (멱등 — 0행 영향 기대) =====
\echo '--- PASS 2 (re-apply: expect 0 changes) ---'
\i foil-prop-body.sql

SELECT 'AFTER_PASS2' AS phase,
  (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOIL_%LARGE%')          AS large_prices,
  (SELECT count(*) FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_FOIL_%LARGE%')           AS large_comps,
  (SELECT count(*) FROM t_prc_price_formulas WHERE frm_cd LIKE '%_FOIL' AND frm_cd <> 'PRF_NAMECARD_FIXED_FOIL') AS foil_formulas,
  (SELECT count(*) FROM t_prc_formula_components WHERE frm_cd LIKE '%_FOIL' AND frm_cd <> 'PRF_NAMECARD_FIXED_FOIL') AS foil_fc,
  (SELECT count(*) FROM t_prd_product_price_formulas WHERE apply_bgn_ymd='2026-07-01' AND prd_cd IN ('PRD_000027','PRD_000029','PRD_000034','PRD_000042','PRD_000069','PRD_000070')) AS bindings
\gset p2_

-- ===== 멱등 판정 (PASS1 == PASS2) =====
SELECT
  (:'p2_large_prices'::int - :'p1_large_prices'::int) AS d_prices,
  (:'p2_large_comps'::int  - :'p1_large_comps'::int)  AS d_comps,
  (:'p2_foil_formulas'::int - :'p1_foil_formulas'::int) AS d_formulas,
  (:'p2_foil_fc'::int - :'p1_foil_fc'::int)           AS d_fc,
  (:'p2_bindings'::int - :'p1_bindings'::int)         AS d_bindings,
  CASE WHEN (:'p2_large_prices'::int - :'p1_large_prices'::int)=0
        AND (:'p2_large_comps'::int  - :'p1_large_comps'::int)=0
        AND (:'p2_foil_formulas'::int - :'p1_foil_formulas'::int)=0
        AND (:'p2_foil_fc'::int - :'p1_foil_fc'::int)=0
        AND (:'p2_bindings'::int - :'p1_bindings'::int)=0
       THEN 'IDEMPOTENT: PASS' ELSE 'IDEMPOTENT: FAIL' END AS verdict;

-- [HARD] 라이브 무변경 — 롤백전용.
ROLLBACK;
