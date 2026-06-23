-- apply.sql — RC-2 추가물형(비BLOCKED) 적재 트랜잭션 래퍼 (FK 위상순서)
-- 대상: 메쉬현수막(139)·캔버스행잉(133)·린넨우드봉(134). PET(136)=HOLD-1 BLOCKED 제외.
-- 기본 DRY-RUN: 로더(apply.sh)가 끝에 ROLLBACK 주입. COMMIT은 commit 인자 + 인간 승인만.
-- FK 위상: 옵션(부모 그룹 실재) → comp use_dims → 단가행(opt_cd+RC4 siz) → 공식 바인딩(부모 frm/comp 실재)
\set ON_ERROR_STOP on
BEGIN;
  \i 01_options.sql
  \i 02_use_dims.sql
  \i 03_price_fill.sql
  \i 04_formula_components.sql
-- 기본 ROLLBACK(apply.sh 주입). 실제 적재는 commit 인자로만 COMMIT.
