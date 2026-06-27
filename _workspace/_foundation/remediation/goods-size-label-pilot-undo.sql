-- 230 라벨 옵션 역연산(물리삭제 — 방금 추가분 한정)
BEGIN;
DELETE FROM t_prd_product_option_items WHERE prd_cd='PRD_000230' AND opt_cd IN ('OPV_000463','OPV_000464');
DELETE FROM t_prd_product_options WHERE prd_cd='PRD_000230' AND opt_cd IN ('OPV_000463','OPV_000464');
DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000230' AND opt_grp_cd='OPT_000073';
COMMIT;
