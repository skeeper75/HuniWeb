-- S6 undo symmetry: baseline -> apply -> undo should return to baseline. BEGIN..ROLLBACK.
\set ON_ERROR_STOP on
BEGIN;
\echo '=== BASELINE fingerprint ==='
CREATE TEMP TABLE _b AS
  SELECT 'setwire:'||comp_cd v FROM t_prc_formula_components WHERE frm_cd='PRF_LEATHER_RINGBINDER_SET'
  UNION ALL SELECT 'ppf089:'||frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000089'
  UNION ALL SELECT 'proc088:'||proc_cd FROM t_prd_product_processes WHERE prd_cd='PRD_000088' AND del_yn='N'
  UNION ALL SELECT 'covercomp:'||comp_cd FROM t_prc_price_components WHERE comp_cd='COMP_LEATHER_RINGBINDER_COVER'
  UNION ALL SELECT 'coverfrm:'||frm_cd FROM t_prc_price_formulas WHERE frm_cd='PRF_LEATHER_RINGBINDER_COVER';
SELECT * FROM _b ORDER BY v;

\echo '=== APPLY ==='
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/088-redesign-260702/apply.sql
\echo '=== UNDO ==='
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/088-redesign-260702/undo.sql

\echo '=== AFTER undo fingerprint (must equal baseline) ==='
CREATE TEMP TABLE _a AS
  SELECT 'setwire:'||comp_cd v FROM t_prc_formula_components WHERE frm_cd='PRF_LEATHER_RINGBINDER_SET'
  UNION ALL SELECT 'ppf089:'||frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000089'
  UNION ALL SELECT 'proc088:'||proc_cd FROM t_prd_product_processes WHERE prd_cd='PRD_000088' AND del_yn='N'
  UNION ALL SELECT 'covercomp:'||comp_cd FROM t_prc_price_components WHERE comp_cd='COMP_LEATHER_RINGBINDER_COVER'
  UNION ALL SELECT 'coverfrm:'||frm_cd FROM t_prc_price_formulas WHERE frm_cd='PRF_LEATHER_RINGBINDER_COVER';
SELECT * FROM _a ORDER BY v;
\echo '=== DIFF (baseline symmetric-diff after-undo; expect ZERO rows) ==='
SELECT 'only_in_baseline' side, v FROM _b EXCEPT SELECT 'only_in_baseline', v FROM _a
UNION ALL
SELECT 'only_after_undo', v FROM _a EXCEPT SELECT 'only_after_undo', v FROM _b;

ROLLBACK;
\echo '=== ROLLBACK done ==='
