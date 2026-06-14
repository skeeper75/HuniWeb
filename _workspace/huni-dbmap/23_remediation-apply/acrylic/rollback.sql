-- =====================================================================
-- 아크릴 라이브 정정 롤백 (rollback.sql) · round-13 / 2026-06-14
-- apply.sql 즉시적용분(AW-CAT 단품형 14상품 카테고리 재연결)을 적용 전 원문으로 복원.
-- 디지털인쇄 패턴(23_remediation-apply/digital-print/rollback.sql) 계승. 인간 실행용.
-- 원문 상태: 146~159 → CAT_000299(단품형·고아 upr=NULL) main_cat_yn='Y' 단일 연결.
-- =====================================================================

BEGIN;

-- 1. 정정으로 추가한 정상 lvl2 노드 연결 제거 (적용 전엔 없던 행 → DELETE 복원)
DELETE FROM t_prd_product_categories
 WHERE (prd_cd,cat_cd) IN (
   ('PRD_000146','CAT_000140'),
   ('PRD_000147','CAT_000141'),
   ('PRD_000148','CAT_000142'),
   ('PRD_000149','CAT_000143'),
   ('PRD_000150','CAT_000144'),
   ('PRD_000151','CAT_000145'),
   ('PRD_000152','CAT_000146'),
   ('PRD_000153','CAT_000147'),
   ('PRD_000154','CAT_000153'),
   ('PRD_000155','CAT_000148'),
   ('PRD_000156','CAT_000149'),
   ('PRD_000157','CAT_000150'),
   ('PRD_000158','CAT_000151'),
   ('PRD_000159','CAT_000152')
 );

-- 2. 고아 299(단품형) 연결 메인 복원 (강등 N → 원래 Y)
UPDATE t_prd_product_categories
   SET main_cat_yn='Y', upd_dt=now(), note=NULL
 WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000159'
   AND cat_cd='CAT_000299';

COMMIT;
