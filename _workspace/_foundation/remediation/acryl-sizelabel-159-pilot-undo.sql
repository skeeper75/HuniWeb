-- acryl-sizelabel-159-pilot-undo.sql — 159 사이즈 라벨 옵션 역연산 (인간 승인 후만)
BEGIN;
DELETE FROM t_prd_product_option_items WHERE prd_cd='PRD_000159' AND opt_cd IN('OPV_000465','OPV_000466');
DELETE FROM t_prd_product_options WHERE prd_cd='PRD_000159' AND opt_cd IN('OPV_000465','OPV_000466');
DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000159' AND opt_grp_cd='OPT_000074';
COMMIT;
