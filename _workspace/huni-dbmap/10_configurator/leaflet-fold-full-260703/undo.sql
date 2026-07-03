-- UNDO: 접지리플렛·와이드 접지리플렛 완전 견적 종단 적재 되돌리기(논리삭제)
BEGIN;
-- 공식 원복(048): PRF_DGP_E → PRF_FOLD_SUM
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_FOLD_SUM',upd_dt=now() WHERE prd_cd='PRD_000048';
-- L1 processes/sizes 논리삭제(추가분만)
UPDATE t_prd_product_processes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND proc_cd='PROC_000107';
UPDATE t_prd_product_processes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND proc_cd='PROC_000060';
UPDATE t_prd_product_processes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND proc_cd='PROC_000071';
UPDATE t_prd_product_processes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND proc_cd='PROC_000106';
UPDATE t_prd_product_processes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND proc_cd='PROC_000004';
UPDATE t_prd_product_sizes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND siz_cd='SIZ_000049';
UPDATE t_prd_product_sizes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND siz_cd='SIZ_000051';
UPDATE t_prd_product_sizes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND siz_cd='SIZ_000054';
UPDATE t_prd_product_processes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND proc_cd='PROC_000106';
-- 접지 옵션그룹 논리삭제
UPDATE t_prd_product_option_items SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND opt_cd IN (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000048' AND opt_grp_cd='OPT_000155');
UPDATE t_prd_product_options SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND opt_grp_cd='OPT_000155';
UPDATE t_prd_product_option_groups SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND opt_grp_cd='OPT_000155';
UPDATE t_prd_product_option_items SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND opt_cd IN (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000049' AND opt_grp_cd='OPT_000156');
UPDATE t_prd_product_options SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND opt_grp_cd='OPT_000156';
UPDATE t_prd_product_option_groups SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND opt_grp_cd='OPT_000156';
-- 옵션 레이어(인쇄/종이/코팅/후가공) + 코팅 제약 논리삭제
UPDATE t_prd_product_option_items SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND opt_cd IN (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000048' AND opt_grp_cd IN ('OPT_000147','OPT_000148','OPT_000149','OPT_000150'));
UPDATE t_prd_product_options SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND opt_grp_cd IN ('OPT_000147','OPT_000148','OPT_000149','OPT_000150');
UPDATE t_prd_product_option_groups SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND opt_grp_cd IN ('OPT_000147','OPT_000148','OPT_000149','OPT_000150');
UPDATE t_prd_product_constraints SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND rule_cd='R_EXCL_COATING_THIN_PAPER';
UPDATE t_prd_product_option_items SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND opt_cd IN (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000049' AND opt_grp_cd IN ('OPT_000151','OPT_000152','OPT_000153','OPT_000154'));
UPDATE t_prd_product_options SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND opt_grp_cd IN ('OPT_000151','OPT_000152','OPT_000153','OPT_000154');
UPDATE t_prd_product_option_groups SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND opt_grp_cd IN ('OPT_000151','OPT_000152','OPT_000153','OPT_000154');
UPDATE t_prd_product_constraints SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND rule_cd='R_EXCL_COATING_THIN_PAPER';
COMMIT;
