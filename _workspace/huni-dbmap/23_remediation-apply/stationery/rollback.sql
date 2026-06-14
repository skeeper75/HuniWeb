-- =====================================================================
-- 문구(stationery) 라이브 정정 롤백 (rollback.sql) · round-13 / 2026-06-14
-- apply.sql 즉시적용분(카테고리 재연결 + 종이 용도)을 적용 전 원문으로 복원. 인간 실행용.
-- 디지털인쇄 GO 양식(23_remediation-apply/digital-print/rollback.sql) 계승.
-- 원문 상태: 172~176 → CAT_000300(플래너·고아) main='Y' 단일 연결 / 백모조 USAGE.07 del_yn='N'.
-- =====================================================================

BEGIN;

-- 1. 정정으로 추가한 정상 노드 연결 제거 (적용 전엔 없던 행 → DELETE 복원)
DELETE FROM t_prd_product_categories
 WHERE (prd_cd,cat_cd) IN (
   ('PRD_000172','CAT_000121'),
   ('PRD_000173','CAT_000122'),
   ('PRD_000174','CAT_000120'),
   ('PRD_000175','CAT_000119'),
   ('PRD_000176','CAT_000123')
 );

-- 2. 고아 300 연결 메인 복원 (강등 N → 원래 Y, note 제거)
UPDATE t_prd_product_categories
   SET main_cat_yn='Y', upd_dt=now(), note=NULL
 WHERE prd_cd IN ('PRD_000172','PRD_000173','PRD_000174','PRD_000175','PRD_000176')
   AND cat_cd='CAT_000300';

-- 3. 정정으로 추가한 종이 .01 내지행 제거 (적용 전엔 없던 행)
DELETE FROM t_prd_product_materials
 WHERE (prd_cd) IN ('PRD_000176','PRD_000177','PRD_000178','PRD_000179','PRD_000181')
   AND mat_cd='MAT_000072' AND usage_cd='USAGE.01' AND dflt_yn='Y';

-- 4. 논리삭제한 .07 공통행 복원 (del_yn 'Y'→'N', del_dt 제거)
UPDATE t_prd_product_materials
   SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE mat_cd IN ('MAT_000072','MAT_000073') AND usage_cd='USAGE.07'
   AND prd_cd IN ('PRD_000176','PRD_000177','PRD_000178','PRD_000179','PRD_000181','PRD_000097');

COMMIT;

-- 주의: 종이 .01 행이 적용 전에도 이미 있던 상품(중복 INSERT가 ON CONFLICT로 무동작한 경우)은
--       3번 DELETE가 그 기존행까지 지울 수 있음 → 적용 전 백업(backup-before-commit.txt) 대조 권장.
