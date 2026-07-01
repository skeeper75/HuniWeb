\set ON_ERROR_STOP on
BEGIN;
UPDATE t_prc_component_prices SET proc_cd='PROC_000090'
 WHERE comp_cd='COMP_PP_CREASE_1L' AND proc_cd='PROC_000029';
UPDATE t_prc_component_prices SET proc_cd='PROC_000086'
 WHERE comp_cd='COMP_PP_PERF_1L' AND proc_cd='PROC_000030';
COMMIT;
