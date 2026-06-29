-- 문구 9상품 가격공식 신설 UNDO (2026-06-29 COMMIT 직전=라이브 부재). 할인테이블 DSC_STAT_QTY 바인딩은 기존이라 미터치.
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE frm_cd LIKE 'PRF_STN_%';
DELETE FROM t_prc_component_prices       WHERE comp_cd LIKE 'COMP_STN_%';
DELETE FROM t_prc_formula_components     WHERE frm_cd LIKE 'PRF_STN_%';
DELETE FROM t_prc_price_components       WHERE comp_cd LIKE 'COMP_STN_%';
DELETE FROM t_prc_price_formulas         WHERE frm_cd LIKE 'PRF_STN_%';
COMMIT;
