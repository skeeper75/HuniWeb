-- UNDO: 스티커 4상품 사이즈 복원 + 자재단가 클론 (260702) 되돌리기.
-- 문제 발생 시에만 사용. 백업=sticker-size-restore-backup-260702.csv.
\set ON_ERROR_STOP on
BEGIN;

-- 1. 클론한 단가행 정확 삭제(마커 note로 식별)
DELETE FROM t_prc_component_prices WHERE note LIKE 'STK-RESTORE-260702%';

-- 2. 사이즈 del_yn 원복 (fix 반대 방향)
-- 2a. 정규코드 다시 논리삭제 (N→Y·복원 취소)
UPDATE t_prd_product_sizes SET del_yn='Y', del_dt=now()
 WHERE (prd_cd,siz_cd) IN (
   ('PRD_000052','SIZ_000520'),('PRD_000052','SIZ_000170'),
   ('PRD_000053','SIZ_000520'),('PRD_000053','SIZ_000170'),
   ('PRD_000058','SIZ_000520'),('PRD_000058','SIZ_000170'),
   ('PRD_000055','SIZ_000172'),('PRD_000055','SIZ_000174'),('PRD_000055','SIZ_000197')
 );
-- 2b. 중복코드 다시 활성 (Y→N)
UPDATE t_prd_product_sizes SET del_yn='N', del_dt=NULL
 WHERE (prd_cd,siz_cd) IN (
   ('PRD_000052','SIZ_000258'),('PRD_000052','SIZ_000426'),
   ('PRD_000053','SIZ_000258'),('PRD_000053','SIZ_000426'),
   ('PRD_000058','SIZ_000258'),('PRD_000058','SIZ_000426'),
   ('PRD_000055','SIZ_000258'),('PRD_000055','SIZ_000315'),('PRD_000055','SIZ_000198')
 );
-- 2c. dflt_yn 은 백업 CSV 기준 수동 복구 필요(원상태 다수 dflt=Y·비정상이었음).

COMMIT;
\echo '=== UNDO 완료 ==='
