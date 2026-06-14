-- =====================================================================
-- 포토북 라이브 정정 롤백 (rollback.sql) · round-13 / 2026-06-14
-- apply.sql 즉시적용분(무광 공정 연결 + PUR 필수화)을 적용 전 원문으로 복원. 인간 실행용.
-- 디지털인쇄 rollback.sql 양식 계승.
-- 원문 상태(DRY-RUN 실측 2026-06-14): PRD_000100 공정 = PROC_000020 PUR mand=N 단일행.
-- =====================================================================

BEGIN;

-- 1. 정정으로 추가한 무광 공정 연결 제거 (적용 전엔 없던 행 → DELETE 복원)
DELETE FROM t_prd_product_processes
 WHERE prd_cd='PRD_000100' AND proc_cd='PROC_000015';

-- 2. PUR제본 필수 복원 (Y → 원래 N)
UPDATE t_prd_product_processes
   SET mand_proc_yn='N', upd_dt=now()
 WHERE prd_cd='PRD_000100' AND proc_cd='PROC_000020';

COMMIT;
