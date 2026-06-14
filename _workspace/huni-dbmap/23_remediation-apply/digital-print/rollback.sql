-- =====================================================================
-- 디지털인쇄 라이브 정정 롤백 (rollback.sql) · round-13 / 2026-06-14
-- apply.sql 즉시적용분(카테고리 재연결)을 적용 전 원문으로 복원. 인간 실행용.
-- 레더 패턴(23_remediation-apply/leather/rollback.sql) 계승.
-- 원문 상태: 043/044/045/046 → CAT_000296(배경지·고아) main_cat_yn='Y' 단일 연결.
-- =====================================================================

BEGIN;

-- 1. 정정으로 추가한 정상 노드 연결 제거 (적용 전엔 없던 행 → DELETE 복원)
DELETE FROM t_prd_product_categories
 WHERE (prd_cd,cat_cd) IN (
   ('PRD_000043','CAT_000273'),
   ('PRD_000044','CAT_000274'),
   ('PRD_000045','CAT_000275'),
   ('PRD_000046','CAT_000283')
 );

-- 2. 고아 296 연결 메인 복원 (강등 N → 원래 Y)
UPDATE t_prd_product_categories
   SET main_cat_yn='Y', upd_dt=now(),
       note=NULL
 WHERE prd_cd IN ('PRD_000043','PRD_000044','PRD_000045','PRD_000046')
   AND cat_cd='CAT_000296';

COMMIT;
