-- =====================================================================
-- 스티커 라이브 정정 롤백 (rollback.sql) · round-13 / 2026-06-14
-- apply.sql 즉시적용분(S-01 자재유형·S-02 063 화이트·S-03 066 빈 옵션그룹)을
-- 적용 전 원문으로 복원. 인간 실행용.
-- 디지털인쇄 패턴(23_remediation-apply/digital-print/rollback.sql) 계승.
-- 원문 상태:
--   S-01: MAT_000084/242/243 mat_typ_cd='MAT_TYPE.01'
--   S-02: PRD_000063 에 PROC_000008 행 없음(적용 전엔 없던 행 → DELETE 복원)
--   S-03: PRD_000066 OPT-000004 use_yn='Y'·del_yn='N'·del_dt=NULL
-- =====================================================================

BEGIN;

-- S-01 복원: 자재유형 .11 → .01 (정정 note 흔적 제거)
UPDATE t_mat_materials
   SET mat_typ_cd='MAT_TYPE.01', upd_dt=now(),
       note=REPLACE(COALESCE(note,''),' | 정정 2026-06-14: 자재유형 종이(.01)→스티커(.11) 점착지','')
 WHERE mat_cd IN ('MAT_000084','MAT_000242','MAT_000243')
   AND mat_typ_cd='MAT_TYPE.11';

-- S-02 복원: 정정으로 추가한 063 화이트 행 제거 (적용 전엔 없던 행)
DELETE FROM t_prd_product_processes
 WHERE prd_cd='PRD_000063' AND proc_cd='PROC_000008';

-- S-03 복원: 066 빈 옵션그룹 논리삭제 해제 (N→Y·del 복원)
UPDATE t_prd_product_option_groups
   SET use_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now(),
       note=REPLACE(COALESCE(note,''),' | 정정 2026-06-14: 빈 옵션그룹 잔재 논리삭제(items 0행·형상=size로 표현)','')
 WHERE prd_cd='PRD_000066' AND opt_grp_cd='OPT-000004';

COMMIT;
