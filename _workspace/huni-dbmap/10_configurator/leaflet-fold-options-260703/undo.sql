-- UNDO: 접지리플렛/와이드 접지리플렛 옵션 레이어 논리삭제(물리 DELETE 금지)
BEGIN;
UPDATE t_prd_product_option_items SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND opt_cd IN (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000048' AND opt_grp_cd IN ('OPT_000147','OPT_000148','OPT_000149','OPT_000150'));
UPDATE t_prd_product_options SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND opt_grp_cd IN ('OPT_000147','OPT_000148','OPT_000149','OPT_000150');
UPDATE t_prd_product_option_groups SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND opt_grp_cd IN ('OPT_000147','OPT_000148','OPT_000149','OPT_000150');
UPDATE t_prd_product_constraints SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND rule_cd='R_EXCL_COATING_THIN_PAPER';
UPDATE t_prd_product_option_items SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND opt_cd IN (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000049' AND opt_grp_cd IN ('OPT_000151','OPT_000152','OPT_000153','OPT_000154'));
UPDATE t_prd_product_options SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND opt_grp_cd IN ('OPT_000151','OPT_000152','OPT_000153','OPT_000154');
UPDATE t_prd_product_option_groups SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND opt_grp_cd IN ('OPT_000151','OPT_000152','OPT_000153','OPT_000154');
UPDATE t_prd_product_constraints SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND rule_cd='R_EXCL_COATING_THIN_PAPER';
COMMIT;
