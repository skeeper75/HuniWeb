-- =====================================================================
-- 카테고리 잔존고아 마무리 — 롤백 (rollback.sql) · 2026-06-14
-- apply.sql 적용분(명함10·상품권2 = 12상품) 정정 전 원문 복원.
-- 복원 = ① 정상노드에 새로 INSERT한 12행 DELETE ② 고아 294/295 연결 main_cat_yn='Y' 복귀.
-- 무손실: 정정 전 상태(고아 노드 main=Y·정상노드 비어있음)로 정확히 되돌림.
-- =====================================================================

BEGIN;

-- ① 정상 동명노드에 추가한 메인 연결 12행 삭제
DELETE FROM t_prd_product_categories
 WHERE (prd_cd, cat_cd) IN (
   ('PRD_000031','CAT_000048'),('PRD_000032','CAT_000049'),('PRD_000033','CAT_000050'),
   ('PRD_000034','CAT_000051'),('PRD_000035','CAT_000054'),('PRD_000036','CAT_000055'),
   ('PRD_000037','CAT_000056'),('PRD_000038','CAT_000057'),('PRD_000039','CAT_000052'),
   ('PRD_000040','CAT_000053'),('PRD_000041','CAT_000063'),('PRD_000042','CAT_000064')
 );

-- ② 고아 노드(294 명함·295 상품권) 연결 main_cat_yn='Y' 복귀
UPDATE t_prd_product_categories
   SET main_cat_yn='Y', upd_dt=now()
 WHERE prd_cd IN ('PRD_000031','PRD_000032','PRD_000033','PRD_000034','PRD_000035',
                  'PRD_000036','PRD_000037','PRD_000038','PRD_000039','PRD_000040')
   AND cat_cd='CAT_000294';

UPDATE t_prd_product_categories
   SET main_cat_yn='Y', upd_dt=now()
 WHERE prd_cd IN ('PRD_000041','PRD_000042')
   AND cat_cd='CAT_000295';

COMMIT;
