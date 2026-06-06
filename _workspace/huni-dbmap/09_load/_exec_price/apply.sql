-- apply.sql — 가격(t_prc_*) 적재 단일 트랜잭션 래퍼 (round-5)
-- BEGIN 으로 열고, COMMIT/ROLLBACK 은 apply.sh(로더)가 주입.
-- 기본 = DRY-RUN(ROLLBACK). 실제 COMMIT 은 --commit(인간 승인)만.
-- FK 위상정렬: 00 코드행 → 01 공식 → 02 구성요소 → 03 배선 → 04 단가 → 05 바인딩.

\set ON_ERROR_STOP on
BEGIN;

\echo '>> 00_prc_component_type.sql (1 stmts)'
\i 00_prc_component_type.sql

\echo '>> 01_prc_price_formulas.sql (10 stmts)'
\i 01_prc_price_formulas.sql

\echo '>> 02_prc_price_components.sql (143 stmts)'
\i 02_prc_price_components.sql

\echo '>> 03_prc_formula_components.sql (13 stmts)'
\i 03_prc_formula_components.sql

\echo '>> 04_prc_component_prices.sql (2988 stmts)'
\i 04_prc_component_prices.sql

\echo '>> 05_prd_product_price_formulas.sql (45 stmts)'
\i 05_prd_product_price_formulas.sql

-- COMMIT/ROLLBACK 은 여기 미포함 — apply.sh 가 모드에 따라 주입.
