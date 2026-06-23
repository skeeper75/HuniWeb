-- apply.sql — RC-2 CONFIRM 확정 3건 적재 트랜잭션 래퍼 (FK 위상순서)
-- 대상: 린넨마감(124)·타공 데이터(138/139)·족자(135). ★각목(CONFIRM-4)=범위 밖·미접촉.
-- 기본 DRY-RUN: 로더(apply.sh)가 끝에 ROLLBACK 주입. COMMIT은 commit 인자 + 인간 승인(dbm-validator R1~R6 GO)만.
-- FK 위상: 옵션(부모 그룹 실재) → comp use_dims → 단가행(opt_cd/proc_cd 충전·재배선) → 공식 바인딩(부모 frm/comp 실재) → 좀비 정리
\set ON_ERROR_STOP on
BEGIN;
  \i 01_options.sql
  \i 02_use_dims.sql
  \i 03_price_fill.sql
  \i 04_formula_components.sql
  \i 05_zombie_cleanup.sql
-- 기본 ROLLBACK(apply.sh 주입). 실제 적재는 commit 인자로만 COMMIT.
