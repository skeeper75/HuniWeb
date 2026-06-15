-- apply.sql — 아크릴 가격사슬 연결 멱등 적재 (round-5 load-execution)
-- 단일 트랜잭션 · FK 위상순서 · ON_ERROR_STOP. NEVER COMMIT.
-- COMMIT/ROLLBACK은 로더(apply.sh)가 주입 — 기본 ROLLBACK(DRY-RUN).
-- 권위: 31_acrylic-price-link/acrylic-chain-design.md (재설계 금지·실행본화만)
--
-- FK 위상순서(부모→자식):
--   01 t_prc_price_formulas        (부모)
--   02 t_prc_price_components       (부모)
--   03 t_prc_formula_components     (자식: frm_cd→01, comp_cd→02·기존 CLEAR3T/MIRROR3T)
--   04 t_prd_product_price_formulas (자식: frm_cd→01, prd_cd→t_prd_products[실재])
--
-- 단가행(t_prc_component_prices) 재적재 0 — 라이브 골든 보존(CLEAR3T 84·MIRROR3T 37).
-- CPQ 옵션레이어는 별 트랙(cpq.sql 미동봉 — round-6 영역·후가공 opt 포함).
-- BLOCKED(미동봉): CLR 배선 메타보정(Q-ACR-7)·미러 바인딩(Q-ACR-9)·코롯토/카라비너 단가행. blocked.md 참조.

\set ON_ERROR_STOP on
BEGIN;
  \echo '== 01 price_formulas =='
  \i 01_prc_price_formulas.sql
  \echo '== 02 price_components =='
  \i 02_prc_price_components.sql
  \echo '== 03 formula_components =='
  \i 03_prc_formula_components.sql
  \echo '== 04 product_price_formulas =='
  \i 04_prd_product_price_formulas.sql
-- 트랜잭션 종료(COMMIT/ROLLBACK)는 로더가 주입. 파일 자체엔 미포함(중첩 금지·기본 ROLLBACK).
