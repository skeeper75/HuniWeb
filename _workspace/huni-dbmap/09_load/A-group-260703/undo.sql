-- A그룹 undo (2026-07-03) — apply.sql 역연산. 문제 시 실행.
-- 궁극 폴백 = backup/*.csv (삭제 전 del_yn 상태).
BEGIN;

-- ① 캘린더 부속 6행 복원 (방금 삭제한 정확한 6쌍만)
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL
 WHERE (prd_cd,mat_cd) IN (
   ('PRD_000108','MAT_000252'),('PRD_000108','MAT_000253'),
   ('PRD_000109','MAT_000254'),('PRD_000109','MAT_000253'),
   ('PRD_000111','MAT_000253'),('PRD_000112','MAT_000253'))
  AND del_yn='Y';

-- ② 146 키링 자재 원복
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000146' AND mat_cd='MAT_000043' AND usage_cd='USAGE.07';
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL WHERE prd_cd='PRD_000146' AND mat_cd='MAT_000386' AND usage_cd='USAGE.07';

-- ③ 151 바인딩 제거 (방금 INSERT한 신규 행 역연산)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000151' AND frm_cd='PRF_CLR_ACRYL' AND apply_bgn_ymd='2026-06-28';

COMMIT;
