BEGIN;

-- 1) 부모(094/097/100)에 잘못 걸린 완제품 사이즈 값(19건) 논리삭제
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now()
WHERE prd_cd IN ('PRD_000094','PRD_000097','PRD_000100') AND del_yn='N';

-- 2) 내지 구성원(095/098/101)에 올바른 판형(국전지4절 SIZ_000499) 등록
INSERT INTO t_prd_product_plate_sizes (prd_cd, siz_cd, dflt_plt_yn, output_file_typ, note)
VALUES
  ('PRD_000095', 'SIZ_000499', 'Y', 'PDF', '엽서북 내지 판형 국4절 등록(260701 교정)'),
  ('PRD_000098', 'SIZ_000499', 'Y', 'PDF', '떡메모지 내지 판형 국4절 등록(260701 교정)'),
  ('PRD_000101', 'SIZ_000499', 'Y', 'PDF', '포토북 내지 판형 국4절 등록(260701 교정)');

-- 검증
\echo '=== VERIFY: 094/097/100 부모 (전부 del_yn=Y 여야 함) ==='
SELECT prd_cd, siz_cd, del_yn FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000094','PRD_000097','PRD_000100');
\echo '=== VERIFY: 095/098/101 내지 신규 등록 ==='
SELECT prd_cd, siz_cd, dflt_plt_yn, note FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000095','PRD_000098','PRD_000101');
\echo '=== VERIFY: 부모 가격공식 그대로인지 ==='
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000094','PRD_000097','PRD_000100');

ROLLBACK;
