-- 판형 오배선 2차 교정 — 스티커·문구·봉투(1차에서 임의 제외했던 것 전수 교정) (2026-07-04)
-- 정의: 판형사이즈=impos_yn='Y' OR 판걸이수 시트. item-size as-plate=결함.
-- 스티커 정본 판형=SIZ_521(330x470·OUTPUT_PAPER_TYPE.02·반칼11상품 convention).
\set ON_ERROR_STOP on
BEGIN;

\echo '=== PRE: 오배선 결함 수(전 상품) ==='
SELECT count(*) FROM t_prd_product_plate_sizes pps JOIN t_siz_sizes s ON s.siz_cd=pps.siz_cd
 WHERE pps.del_yn='N' AND s.impos_yn IS DISTINCT FROM 'Y';

-- (A) 스티커 die-cut(합판도무송066·타투067): 완제품 as-plate → 스티커 판형 SIZ_521
DELETE FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000066','PRD_000067');
INSERT INTO t_prd_product_plate_sizes (prd_cd,siz_cd,item_siz_cd,output_paper_typ_cd,dflt_plt_yn,del_yn,reg_dt)
 SELECT prd,'SIZ_000521','','OUTPUT_PAPER_TYPE.02','Y','N',now() FROM (VALUES ('PRD_000066'),('PRD_000067')) v(prd)
 ON CONFLICT (prd_cd,siz_cd,item_siz_cd) DO UPDATE SET del_yn='N',dflt_plt_yn='Y',output_paper_typ_cd='OUTPUT_PAPER_TYPE.02';

-- (B) 낱장 자유형 055/056: A4(SIZ_050) garbage만 제거(유효 A3/A2 유지)·A3를 dflt로
DELETE FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000055','PRD_000056') AND siz_cd='SIZ_000050';
UPDATE t_prd_product_plate_sizes SET dflt_plt_yn='Y' WHERE prd_cd IN ('PRD_000055','PRD_000056') AND siz_cd='SIZ_000052';

-- (C) 대형 자유형 057: 400x600(대형인쇄·imposition 없음) garbage 제거
DELETE FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000057' AND siz_cd='SIZ_000199';

-- (D) 문구 셋트7 + 봉투제작: 부모 판형 불요(내지 멤버 인쇄·making 공식)·garbage 전부 제거
DELETE FROM t_prd_product_plate_sizes WHERE prd_cd IN
 ('PRD_000179','PRD_000176','PRD_000181','PRD_000177','PRD_000178','PRD_000172','PRD_000173','PRD_000050');

\echo '=== POST: 오배선 결함 수(0 이어야 정합) ==='
SELECT count(*) 잔존결함 FROM t_prd_product_plate_sizes pps JOIN t_siz_sizes s ON s.siz_cd=pps.siz_cd
 WHERE pps.del_yn='N' AND s.impos_yn IS DISTINCT FROM 'Y';
\echo '=== POST: 스티커 교정 결과 ==='
SELECT prd_cd, siz_cd, dflt_plt_yn FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000066','PRD_000067','PRD_000055','PRD_000056','PRD_000057') AND del_yn='N' ORDER BY prd_cd, siz_cd;
ROLLBACK;
