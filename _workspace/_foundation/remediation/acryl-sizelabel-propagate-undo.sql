-- acryl-sizelabel-propagate-undo.sql — 4종 사이즈 라벨 옵션 역연산 (인간 승인 후만)
BEGIN;
DELETE FROM t_prd_product_option_items WHERE prd_cd IN('PRD_000157','PRD_000158','PRD_000161','PRD_000162') AND opt_cd BETWEEN 'OPV_000467' AND 'OPV_000472';
DELETE FROM t_prd_product_options WHERE prd_cd IN('PRD_000157','PRD_000158','PRD_000161','PRD_000162') AND opt_cd BETWEEN 'OPV_000467' AND 'OPV_000472';
DELETE FROM t_prd_product_option_groups WHERE prd_cd IN('PRD_000157','PRD_000158','PRD_000161','PRD_000162') AND opt_grp_cd BETWEEN 'OPT_000075' AND 'OPT_000078';
COMMIT;
