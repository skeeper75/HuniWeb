-- =====================================================================
-- 디자인캘린더 라이브 정정 롤백 (rollback.sql) · round-13 / 2026-06-14
-- apply.sql 즉시적용분(editor_yn·MES)을 적용 전 원문으로 복원. 인간 실행용.
-- 디지털인쇄 패턴(23_remediation-apply/digital-print/rollback.sql) 계승.
-- 원문 상태(2026-06-14 백업 실측·backup-before-commit.txt):
--   108/109/111/112 editor_yn='N' · 110 editor_yn='N'(불변)
--   5상품 전부 "MES_ITEM_CD" IS NULL
-- =====================================================================

BEGIN;

-- 1. editor_yn 복원 (Y → 원래 N)
UPDATE t_prd_products SET editor_yn='N', upd_dt=now()
 WHERE prd_cd IN ('PRD_000108','PRD_000109','PRD_000111','PRD_000112')
   AND editor_yn IS DISTINCT FROM 'N';

-- 2. MES_ITEM_CD 복원 (007-000X → 원래 NULL)
UPDATE t_prd_products SET "MES_ITEM_CD"=NULL, upd_dt=now()
 WHERE prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112')
   AND "MES_ITEM_CD" IS NOT NULL;

COMMIT;
