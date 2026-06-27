-- acryl-area-bind-undo.sql — fix 역연산. 157~162 면적바인딩 제거 + 157 BYSIZ 임시모델 복원.
-- 주의: 면적바인딩만 제거하면 157~162는 다시 미바인딩(157은 BYSIZ도 사라진 상태).
--       BYSIZ 모델 복원이 필요하면 acryl-bysiz-157-fix.sql 재실행으로 157 임시모델 재생성.
BEGIN;
-- 면적바인딩 6 제거
DELETE FROM t_prd_product_price_formulas
 WHERE frm_cd='PRF_CLR_ACRYL'
   AND prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000160','PRD_000161','PRD_000162');
COMMIT;
-- ↑ 여기까지가 fix의 2단계 역연산. 1단계(BYSIZ 폐기) 복원은 별도:
--   psql -f acryl-bysiz-157-fix.sql  (157 BYSIZ 구성요소·공식·배선·단가행2·바인딩 재생성)
