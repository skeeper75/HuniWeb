-- S6 DRY-RUN: apply 088 twice (idempotency) inside BEGIN...ROLLBACK. NEVER commits.
\set ON_ERROR_STOP on
BEGIN;

\echo '=== BEFORE counts ==='
SELECT 'comp_LRC' k, count(*) c FROM t_prc_price_components WHERE comp_cd='COMP_LEATHER_RINGBINDER_COVER'
UNION ALL SELECT 'cprice_LRC', count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_LEATHER_RINGBINDER_COVER'
UNION ALL SELECT 'frm_LRC', count(*) FROM t_prc_price_formulas WHERE frm_cd='PRF_LEATHER_RINGBINDER_COVER'
UNION ALL SELECT 'fc_LRCwire', count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_LEATHER_RINGBINDER_COVER'
UNION ALL SELECT 'ppf_089', count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000089'
UNION ALL SELECT 'setwire', count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_LEATHER_RINGBINDER_SET'
UNION ALL SELECT 'proc_088', count(*) FROM t_prd_product_processes WHERE prd_cd='PRD_000088' AND del_yn='N'
UNION ALL SELECT 'hcmuseon_wires', count(*) FROM t_prc_formula_components WHERE comp_cd='COMP_HC_MUSEON_COVERBIND';

\echo '=== APPLY PASS 1 ==='
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/088-redesign-260702/apply.sql

\echo '=== snapshot after PASS 1 ==='
SELECT count(*) AS fc_total_pass1 FROM t_prc_formula_components;
SELECT frm_cd, comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components WHERE frm_cd IN ('PRF_LEATHER_RINGBINDER_SET','PRF_LEATHER_RINGBINDER_COVER') ORDER BY frm_cd, comp_cd;
SELECT comp_cd, apply_ymd, min_qty, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_LEATHER_RINGBINDER_COVER';
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000088','PRD_000089') ORDER BY prd_cd;
SELECT prd_cd, proc_cd, mand_proc_yn FROM t_prd_product_processes WHERE prd_cd='PRD_000088' AND del_yn='N';
\echo '--- HC_MUSEON_COVERBIND wires after pass1 (PRF_HC_MUSEON_SET must survive) ---'
SELECT frm_cd FROM t_prc_formula_components WHERE comp_cd='COMP_HC_MUSEON_COVERBIND' ORDER BY frm_cd;

\echo '=== capture row-count fingerprint before PASS 2 ==='
CREATE TEMP TABLE _fp1 AS
  SELECT 'cp' t, count(*) c FROM t_prc_price_components
  UNION ALL SELECT 'cpp', count(*) FROM t_prc_component_prices
  UNION ALL SELECT 'pf', count(*) FROM t_prc_price_formulas
  UNION ALL SELECT 'fc', count(*) FROM t_prc_formula_components
  UNION ALL SELECT 'ppf', count(*) FROM t_prd_product_price_formulas
  UNION ALL SELECT 'pp', count(*) FROM t_prd_product_processes;

\echo '=== APPLY PASS 2 (idempotency) ==='
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/088-redesign-260702/apply.sql

\echo '=== DELTA pass2 - pass1 (MUST all be 0) ==='
SELECT 'cp'  t, (SELECT count(*) FROM t_prc_price_components)        - (SELECT c FROM _fp1 WHERE t='cp')  AS delta
UNION ALL SELECT 'cpp',(SELECT count(*) FROM t_prc_component_prices)  - (SELECT c FROM _fp1 WHERE t='cpp')
UNION ALL SELECT 'pf', (SELECT count(*) FROM t_prc_price_formulas)    - (SELECT c FROM _fp1 WHERE t='pf')
UNION ALL SELECT 'fc', (SELECT count(*) FROM t_prc_formula_components)- (SELECT c FROM _fp1 WHERE t='fc')
UNION ALL SELECT 'ppf',(SELECT count(*) FROM t_prd_product_price_formulas)-(SELECT c FROM _fp1 WHERE t='ppf')
UNION ALL SELECT 'pp', (SELECT count(*) FROM t_prd_product_processes) - (SELECT c FROM _fp1 WHERE t='pp');

\echo '=== duplicate SSABARI band guard: COMP_BIND_SSABARI@PROC_000098 rows per min_qty (each must be 1) ==='
SELECT min_qty, count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_BIND_SSABARI' AND proc_cd='PROC_000098' GROUP BY min_qty ORDER BY min_qty;

ROLLBACK;
\echo '=== ROLLBACK done — DB unchanged ==='
