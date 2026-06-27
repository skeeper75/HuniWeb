-- acryl-bind-safe6-undo.sql — 안전6 바인딩 역연산. (157 BYSIZ 복원은 acryl-bysiz-157-fix.sql 재실행)
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000161','PRD_000162') AND frm_cd='PRF_CLR_ACRYL';
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000164' AND frm_cd='PRF_COROTTO_ACRYL';
COMMIT;
