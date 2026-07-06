-- UNDO: 아크릴 7상품 수량할인 배선 되돌리기 (acryl-discount-wire-260706-load.sql)
-- 대상 7상품은 적재 전 배선 0행이었음(사전 확인 완료) → 이 7행 삭제로 원상복구.
BEGIN;

DELETE FROM t_prd_product_discount_tables
WHERE dsc_tbl_cd = 'DSC_ACR_QTY'
  AND apply_bgn_ymd = '2026-06-01'
  AND prd_cd IN ('PRD_000152','PRD_000148','PRD_000157','PRD_000150','PRD_000151','PRD_000159','PRD_000158');

SELECT prd_cd FROM t_prd_product_discount_tables
WHERE prd_cd IN ('PRD_000152','PRD_000148','PRD_000157','PRD_000150','PRD_000151','PRD_000159','PRD_000158');
-- (0행이어야 원상복구)

COMMIT;
