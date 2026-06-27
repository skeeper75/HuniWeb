-- acryl-bysiz-rest-dryrun.sql — 아크릴 등록사이즈 모델 158~162 확대 DRY-RUN
-- 공유 공식 PRF_ACRYL_BYSIZ(157서 생성)에 신규 사이즈 단가행 8 추가 + 5개 바인딩.
-- 단가=면적표 도출 verbatim. 라이브 미변경(ROLLBACK).
BEGIN;
-- 신규 단가행(157의 SIZ_148/012 외 고유 사이즈만)
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note) VALUES
 ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000355',NULL,1,12700,'코스터 100x100원형 — 면적표 100x100'),
 ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000356',NULL,1,12700,'코스터 100x100사각 — 면적표 100x100'),
 ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000357',NULL,1,9900,'스탠드 120x60 — 면적표 120x60'),
 ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000358',NULL,1,13700,'스탠드 120x90 — 면적표 120x90'),
 ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000359',NULL,1,16700,'120x120 — 면적표 120x120'),
 ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000360',NULL,1,20700,'스탠드 120x150 — 면적표 120x160(ceiling)'),
 ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000361',NULL,1,22700,'120x180 — 면적표 120x180'),
 ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000364',NULL,1,10900,'포카스탠드 68x103 — 면적표 70x120(ceiling)');
-- 바인딩 5(158 포카키링·159 코스터·160 스탠드·161 판아크릴·162 포카스탠드)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note) VALUES
 ('PRD_000158','PRF_ACRYL_BYSIZ','2026-06-27','아크릴 포카키링 등록사이즈 모델'),
 ('PRD_000159','PRF_ACRYL_BYSIZ','2026-06-27','아크릴 코스터 등록사이즈 모델'),
 ('PRD_000160','PRF_ACRYL_BYSIZ','2026-06-27','아크릴자유형스탠드 등록사이즈 모델'),
 ('PRD_000161','PRF_ACRYL_BYSIZ','2026-06-27','판아크릴 등록사이즈 모델'),
 ('PRD_000162','PRF_ACRYL_BYSIZ','2026-06-27','아크릴포카스탠드 등록사이즈 모델');
\echo '===== AFTER: 6개 상품 사이즈별 가격(바인딩↔단가행 정합) ====='
SELECT pf.prd_cd, p.prd_nm, s.siz_nm, cp.unit_price
FROM t_prd_product_price_formulas pf
JOIN t_prd_products p ON p.prd_cd=pf.prd_cd
JOIN t_prd_product_sizes psz ON psz.prd_cd=pf.prd_cd AND COALESCE(psz.del_yn,'N')<>'Y'
JOIN t_prc_component_prices cp ON cp.comp_cd='COMP_ACRYL_3T_BYSIZ' AND cp.siz_cd=psz.siz_cd
JOIN t_siz_sizes s ON s.siz_cd=psz.siz_cd
WHERE pf.frm_cd='PRF_ACRYL_BYSIZ' ORDER BY pf.prd_cd, cp.unit_price;
DO $$ DECLARE v_bind int; v_uncov int; BEGIN
  SELECT count(*) INTO v_bind FROM t_prd_product_price_formulas WHERE frm_cd='PRF_ACRYL_BYSIZ';
  IF v_bind<>6 THEN RAISE EXCEPTION '바인딩 %개(기대 6)',v_bind; END IF;
  -- 모든 바인딩 상품의 모든 등록사이즈가 단가행 커버되는지(미커버=견적불가)
  SELECT count(*) INTO v_uncov FROM t_prd_product_price_formulas pf
   JOIN t_prd_product_sizes psz ON psz.prd_cd=pf.prd_cd AND COALESCE(psz.del_yn,'N')<>'Y'
   LEFT JOIN t_prc_component_prices cp ON cp.comp_cd='COMP_ACRYL_3T_BYSIZ' AND cp.siz_cd=psz.siz_cd
   WHERE pf.frm_cd='PRF_ACRYL_BYSIZ' AND cp.comp_price_id IS NULL;
  IF v_uncov>0 THEN RAISE EXCEPTION '미커버 사이즈 %건(견적불가 위험)',v_uncov; END IF;
  RAISE NOTICE 'DRY-RUN OK: 6상품 바인딩·전 등록사이즈 단가행 커버·미커버 0';
END $$;
ROLLBACK;
\echo '===== ROLLBACK 완료 ====='
