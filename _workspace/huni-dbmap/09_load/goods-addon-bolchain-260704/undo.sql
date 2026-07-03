-- 볼체인 addon 배선 UNDO
\set ON_ERROR_STOP on
BEGIN;
DELETE FROM t_prd_product_addons WHERE prd_cd IN ('PRD_000221','PRD_000223') AND tmpl_cd BETWEEN 'TMPL-000056' AND 'TMPL-000063';
COMMIT;
