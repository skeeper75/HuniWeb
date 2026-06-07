-- =====================================================================
-- undo.sql — 디지털인쇄 가격엔진 적재 역연산 (멱등 INSERT 되돌리기)
--   적재한 신규 키만 정밀 DELETE. FK 의존 역순(자식 먼저, 부모 나중):
--     04 component_prices(용지비) → 03 formula_components → 05 bindings
--       → 02 components(COMP_PAPER) → 01 formulas(PRF_DGP_*)
--   기존 라이브 행은 절대 건드리지 않음(신규 키 한정 WHERE).
--   단일 트랜잭션 BEGIN…COMMIT. undo.sh DRY-RUN 이 COMMIT→ROLLBACK 치환.
--
--   멱등성: 이미 삭제됐으면 0행 DELETE (DELETE 는 본질적으로 멱등).
--   주의: t_prc_component_prices.comp_cd → ON DELETE CASCADE 이므로
--         02 의 COMP_PAPER DELETE 시 용지비가 동반 삭제될 수 있으나,
--         아래는 04 를 먼저 명시 DELETE 하여 순서를 일관되게 보존(가시성).
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;

-- 04 용지비 단가 (COMP_PAPER × SIZ_000499, 적재한 자연키 한정)
DELETE FROM t_prc_component_prices
 WHERE comp_cd = 'COMP_PAPER' AND siz_cd = 'SIZ_000499' AND apply_ymd = '2026-06-01';

-- 03 공식↔구성요소 배선 (DGP 공식 한정)
DELETE FROM t_prc_formula_components
 WHERE frm_cd LIKE 'PRF_DGP_%';

-- 05 상품↔공식 바인딩 (DGP 공식 한정 = 적재한 19 바인딩)
DELETE FROM t_prd_product_price_formulas
 WHERE frm_cd LIKE 'PRF_DGP_%';

-- 02 신규 component COMP_PAPER (위 04/03 삭제 후라 RESTRICT FK 안전)
DELETE FROM t_prc_price_components
 WHERE comp_cd = 'COMP_PAPER';

-- 01 신규 공식 헤더 PRF_DGP_* (위 03/05 삭제 후라 RESTRICT FK 안전)
DELETE FROM t_prc_price_formulas
 WHERE frm_cd LIKE 'PRF_DGP_%';

COMMIT;
