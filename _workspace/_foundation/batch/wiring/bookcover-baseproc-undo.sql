\set ON_ERROR_STOP on
BEGIN;
DELETE FROM t_prd_product_processes
 WHERE prd_cd IN ('PRD_000288','PRD_000290','PRD_000292') AND proc_cd='PROC_000004';
COMMIT;
