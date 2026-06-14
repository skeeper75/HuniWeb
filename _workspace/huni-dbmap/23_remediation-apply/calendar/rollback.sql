-- =====================================================================
-- 캘린더 라이브 정정 롤백 (rollback.sql) · round-13 / 2026-06-14
-- apply.sql 즉시적용분(MES 채움)을 적용 전 원문(NULL)으로 복원. 인간 실행용.
-- 디지털인쇄 패턴(23_remediation-apply/digital-print/rollback.sql) 계승.
-- 원문 상태: PRD_000108~112 MES_ITEM_CD = NULL (load_master L261 None 하드코딩).
-- 무손실: t_prd_products 에 note 없음 → upd_dt만 갱신, 데이터 손실 0.
-- =====================================================================

BEGIN;

-- MES 채움 복원 (정정 후 007-000N → 원문 NULL)
UPDATE t_prd_products SET "MES_ITEM_CD"=NULL, upd_dt=now()
 WHERE prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112')
   AND "MES_ITEM_CD" IN ('007-0001','007-0002','007-0003','007-0004','007-0005');

COMMIT;
