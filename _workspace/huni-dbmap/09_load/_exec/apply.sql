-- apply.sql — 상품마스터 적재 단일 트랜잭션 래퍼 (round-5)
-- BEGIN 으로 열고 COMMIT/ROLLBACK 은 apply.sh 가 주입. 기본 = DRY-RUN(ROLLBACK).
-- FK 위상정렬: 00a proc → 00b siz(코드행) → 05 materials → 06 processes → 09 bundle → 09b 정정 bundle → 90 update-set.
-- 차단/GAP(레이저커팅 의존 14·addon 4·디자인캘린더 18·goods-pouch GAP·uv/excl update-set)는 미포함.

\set ON_ERROR_STOP on
BEGIN;

\echo '>> 00_proc_processes.sql (1 stmts)'
\i 00_proc_processes.sql

\echo '>> 00_siz_sizes.sql (10 stmts)'
\i 00_siz_sizes.sql

\echo '>> 05_t_prd_product_materials.sql (316 stmts)'
\i 05_t_prd_product_materials.sql

\echo '>> 06_t_prd_product_processes.sql (62 stmts)'
\i 06_t_prd_product_processes.sql

\echo '>> 09_t_prd_product_bundle_qtys.sql (6 stmts)'
\i 09_t_prd_product_bundle_qtys.sql

\echo '>> 09b_correction_bundle_qtys.sql (18 stmts · 정정 SIZE_NAME_NOISE GO · 9상품)'
\i 09b_correction_bundle_qtys.sql

\echo '>> 90_update_set.sql (289 stmts)'
\i 90_update_set.sql

-- COMMIT/ROLLBACK 미포함 — apply.sh 가 모드에 따라 주입.
