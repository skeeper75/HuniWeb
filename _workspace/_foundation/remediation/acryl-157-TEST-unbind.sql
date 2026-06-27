-- [테스트 종료] 157 임시 바인딩 제거(원상복구)
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000157' AND frm_cd='PRF_CLR_ACRYL';
COMMIT;
