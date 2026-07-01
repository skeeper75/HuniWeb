-- UNDO: 088 레더링바인더 가격 구성 되돌리기.
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000088' AND frm_cd='PRF_LEATHER_RINGBINDER_SET';
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_LEATHER_RINGBINDER_SET';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_LEATHER_RINGBINDER_SET';
UPDATE t_prd_products SET use_yn='N' WHERE prd_cd='PRD_000088';  -- 숨김 상태로 복귀
COMMIT;
