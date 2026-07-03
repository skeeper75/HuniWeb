-- 판형사이즈 오배선 교정 — 시트 등재 상품 전수(국4절 11 + 3절660 3) (2026-07-04)
-- 정본: 국4절=SIZ_499(316x467)·3절660=SIZ_475(330x660). 권위=판걸이수 시트.
-- 국4절 11상품: 오배선 판형행(완제품사이즈-as-plate·유사중복 315x467) 삭제 + 정본 SIZ_499 generic 삽입.
-- 3절660: SIZ_475 이미 올바른 크기·impos_yn='N'→'Y' 판형화(030/049/112 배선 정확).
\set ON_ERROR_STOP on
BEGIN;

\echo '=== PRE: 국4절 11상품 현재 판형행 ==='
SELECT count(*) FROM t_prd_product_plate_sizes WHERE del_yn='N' AND prd_cd IN
 ('PRD_000069','PRD_000068','PRD_000071','PRD_000072','PRD_000082','PRD_000077','PRD_000070','PRD_000037','PRD_000039','PRD_000025','PRD_000016');

-- 1) 국4절 11상품: 오배선 판형행 물리삭제(전 판형행·전부 오배선 or 중복)
DELETE FROM t_prd_product_plate_sizes WHERE prd_cd IN
 ('PRD_000069','PRD_000068','PRD_000071','PRD_000072','PRD_000082','PRD_000077','PRD_000070','PRD_000037','PRD_000039','PRD_000025','PRD_000016');

-- 2) 정본 SIZ_499 generic 삽입(item_siz_cd=''·국4절 OUTPUT_PAPER_TYPE.01·dflt='Y')
INSERT INTO t_prd_product_plate_sizes (prd_cd, siz_cd, item_siz_cd, output_paper_typ_cd, dflt_plt_yn, del_yn, reg_dt)
SELECT prd, 'SIZ_000499', '', 'OUTPUT_PAPER_TYPE.01', 'Y', 'N', now()
FROM (VALUES ('PRD_000069'),('PRD_000068'),('PRD_000071'),('PRD_000072'),('PRD_000082'),('PRD_000077'),('PRD_000070'),('PRD_000037'),('PRD_000039'),('PRD_000025'),('PRD_000016')) v(prd)
ON CONFLICT (prd_cd, siz_cd, item_siz_cd) DO UPDATE SET del_yn='N', dflt_plt_yn='Y', output_paper_typ_cd='OUTPUT_PAPER_TYPE.01';

-- 3) 3절660 SIZ_475 판형화(impos_yn='N'→'Y'·330x660 정본크기)
UPDATE t_siz_sizes SET impos_yn='Y' WHERE siz_cd='SIZ_000475' AND impos_yn IS DISTINCT FROM 'Y';

\echo '=== POST: 교정 결과 ==='
SELECT prd_cd, siz_cd, item_siz_cd, dflt_plt_yn FROM t_prd_product_plate_sizes
 WHERE del_yn='N' AND prd_cd IN ('PRD_000069','PRD_000068','PRD_000071','PRD_000072','PRD_000082','PRD_000077','PRD_000070','PRD_000037','PRD_000039','PRD_000025','PRD_000016') ORDER BY prd_cd;
\echo '=== SIZ_475 impos_yn ==='
SELECT siz_cd, siz_nm, impos_yn FROM t_siz_sizes WHERE siz_cd='SIZ_000475';
ROLLBACK;
