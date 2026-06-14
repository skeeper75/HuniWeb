-- =====================================================================
-- apply.sql — 안전 GO분 적재 (BLOCKED 차원 선적재 + 더미 정리)
--   단일 트랜잭션. COMMIT/ROLLBACK 는 apply.sh 가 -c 로 주입(기본 ROLLBACK).
--   포함: 01_dim_preload(139 끈/재단 3 + 접지 027/029 4 = 7 LINK 멱등)
--         02_cleanup_dummy(016 더미 hard-delete · 025 RULE_001 · 066 고아 soft-delete)
--   제외: 가격 배선(떡메/엽서북 — 컨펌 미해소) · 화이트별색 · 복합끈/거치대 (보류)
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;

\echo '── 01 BLOCKED 차원 선적재 ──'
\ir 01_dim_preload.sql

\echo '── 02 테스트 더미 정리 ──'
\ir 02_cleanup_dummy.sql

\echo '── 적재 후 검증 (트랜잭션 내) ──'
-- 선적재 7행 실재
SELECT '139 proc 084' k, count(*) v FROM t_prd_product_processes WHERE prd_cd='PRD_000139' AND proc_cd='PROC_000084'
UNION ALL SELECT '139 proc 081', count(*) FROM t_prd_product_processes WHERE prd_cd='PRD_000139' AND proc_cd='PROC_000081'
UNION ALL SELECT '139 mat 070', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000139' AND mat_cd='MAT_000070'
UNION ALL SELECT '027 접지 065/066', count(*) FROM t_prd_product_processes WHERE prd_cd='PRD_000027' AND proc_cd IN ('PROC_000065','PROC_000066')
UNION ALL SELECT '029 접지 067/068', count(*) FROM t_prd_product_processes WHERE prd_cd='PRD_000029' AND proc_cd IN ('PROC_000067','PROC_000068')
UNION ALL SELECT '016 더미 grp(0기대)', count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_cd='OPT-000005'
UNION ALL SELECT '016 더미 opts(0기대)', count(*) FROM t_prd_product_options WHERE prd_cd='PRD_000016' AND opt_cd IN ('OPV-000007','OPV-000008','OPV-000009','OPV-000010')
UNION ALL SELECT '016 더미 items(0기대)', count(*) FROM t_prd_product_option_items WHERE prd_cd='PRD_000016' AND opt_cd IN ('OPV-000007','OPV-000008','OPV-000009','OPV-000010')
UNION ALL SELECT '025 RULE_001(0기대)', count(*) FROM t_prd_product_constraints WHERE prd_cd='PRD_000025' AND rule_cd='RULE_001'
UNION ALL SELECT '066 고아 active(0기대)', count(*) FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_cd='OPV-000006' AND del_yn='N'
UNION ALL SELECT '016 정식 옵션그룹(4보존)', count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_cd LIKE 'OPT\_%';

-- COMMIT/ROLLBACK 은 apply.sh 가 주입
