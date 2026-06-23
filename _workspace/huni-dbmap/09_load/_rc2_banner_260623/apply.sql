-- apply.sql — RC-2 일반현수막 옵션 바인딩 트랜잭션 래퍼 (FK 위상순서)
-- 기본 DRY-RUN: 로더(apply.sh)가 끝에 ROLLBACK 주입. COMMIT은 --commit 인간 승인만.
-- 순서: price_components(use_dims) → component_prices(opt_cd) → formula_components(바인딩)
\set ON_ERROR_STOP on
BEGIN;
  \i 01_use_dims.sql
  \i 02_opt_fill.sql
  \i 03_formula_components.sql
-- 기본 ROLLBACK(apply.sh 주입). 실제 적재는 --commit 으로만 COMMIT.

