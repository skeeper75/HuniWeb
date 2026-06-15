-- ============================================================
-- WIRE 통합 배선 실행본 — apply.sql (단일 트랜잭션 래퍼)
-- 기본 = DRY-RUN: BEGIN으로 열고 ROLLBACK/COMMIT은 apply_loader.sh가 주입(파일엔 미포함).
-- FK 위상정렬: 00 공식 → 01 배선(공식 FK) → 02 바인딩(공식 FK) → 03 단가행 복제(comp FK·독립).
-- ON_ERROR_STOP on → 임의 문 실패 시 전체 롤백(원자성 R2). 중간 COMMIT 0.
-- ============================================================
\set ON_ERROR_STOP on
BEGIN;
  \echo '>> step 00: 공식분리 신규 PRF_* (NAMECARD PREMIUM/COAT · SILSA BANNER_NORMAL)'
  \i 00_formulas.sql
  \echo '>> step 01: 공식↔구성요소 배선 (NAMECARD 12 · SILSA 1 · PHOTOCARD BULK 1)'
  \i 01_formula_components.sql
  \echo '>> step 02: 상품↔공식 바인딩 교체 (031 PREMIUM · 032 COAT · 138 BANNER_NORMAL)'
  \i 02_bindings.sql
  \echo '>> step 03: 명함 033 MATGROUP 대표가 verbatim 복제 (074->081/091 · 082->092)'
  \i 03_matgroup_copy.sql
-- 기본 ROLLBACK (apply_loader.sh 주입). 실 COMMIT은 --commit 인간 승인 + 엔진 동시배포 선결.
