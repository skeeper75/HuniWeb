-- acryl-bind-safe6-dryrun.sql — 검증(ROLLBACK). 골든 재현(엔진 ceiling 매칭 SQL) + 바인딩 어서션.
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000157' AND frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_component_prices       WHERE comp_cd='COMP_ACRYL_3T_BYSIZ';
DELETE FROM t_prc_formula_components      WHERE frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_price_formulas          WHERE frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_price_components        WHERE comp_cd='COMP_ACRYL_3T_BYSIZ';
DELETE FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000161','PRD_000162') AND frm_cd='PRF_CLR_ACRYL';
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000164' AND frm_cd='PRF_COROTTO_ACRYL';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note) VALUES
 ('PRD_000157','PRF_CLR_ACRYL','2026-06-28','네임택'),('PRD_000158','PRF_CLR_ACRYL','2026-06-28','포카키링'),
 ('PRD_000159','PRF_CLR_ACRYL','2026-06-28','코스터'),('PRD_000161','PRF_CLR_ACRYL','2026-06-28','판아크릴'),
 ('PRD_000162','PRF_CLR_ACRYL','2026-06-28','포카스탠드'),('PRD_000164','PRF_COROTTO_ACRYL','2026-06-28','코롯토');

\echo '===== 골든: nonspec=N 5상품 등록사이즈 → ceiling 매칭(MAT_043) 정답가 ====='
WITH ps AS (
  SELECT pf.prd_cd, s.cut_width cw, s.cut_height ch, s.siz_nm FROM t_prd_product_price_formulas pf
  JOIN t_prd_product_sizes z ON z.prd_cd=pf.prd_cd AND COALESCE(z.del_yn,'N')<>'Y'
  JOIN t_siz_sizes s ON s.siz_cd=z.siz_cd
  WHERE pf.frm_cd='PRF_CLR_ACRYL' AND pf.prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000161','PRD_000162')),
 tw AS (SELECT DISTINCT siz_width v FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043'),
 th AS (SELECT DISTINCT siz_height v FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043'),
 sel AS (SELECT ps.*, (SELECT MIN(v) FROM tw WHERE v>=ps.cw) sw, (SELECT MIN(v) FROM th WHERE v>=ps.ch) sh FROM ps)
SELECT sel.prd_cd, sel.siz_nm, sel.cw||'x'||sel.ch cut, sel.sw||'x'||sel.sh cell, cp.unit_price price
FROM sel LEFT JOIN t_prc_component_prices cp ON cp.comp_cd='COMP_ACRYL_CLEAR3T' AND cp.mat_cd='MAT_000043' AND cp.siz_width=sel.sw AND cp.siz_height=sel.sh
ORDER BY sel.prd_cd, sel.cw;

DO $$ DECLARE v_clr int; v_cor int; v_bysiz int; v_uncov int; BEGIN
  SELECT count(*) INTO v_clr FROM t_prd_product_price_formulas WHERE frm_cd='PRF_CLR_ACRYL' AND prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000161','PRD_000162');
  SELECT count(*) INTO v_cor FROM t_prd_product_price_formulas WHERE frm_cd='PRF_COROTTO_ACRYL' AND prd_cd='PRD_000164';
  SELECT (SELECT count(*) FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_BYSIZ')+(SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_3T_BYSIZ') INTO v_bysiz;
  IF v_clr<>5 THEN RAISE EXCEPTION 'CLR 바인딩 %(기대5)',v_clr; END IF;
  IF v_cor<>1 THEN RAISE EXCEPTION 'COROTTO 바인딩 %(기대1)',v_cor; END IF;
  IF v_bysiz<>0 THEN RAISE EXCEPTION 'BYSIZ 잔재 %',v_bysiz; END IF;
  -- nonspec=N 5상품 전 등록사이즈 ceiling 셀 커버(미커버=견적불가)
  WITH ps AS (SELECT pf.prd_cd, s.cut_width cw, s.cut_height ch FROM t_prd_product_price_formulas pf
    JOIN t_prd_product_sizes z ON z.prd_cd=pf.prd_cd AND COALESCE(z.del_yn,'N')<>'Y' JOIN t_siz_sizes s ON s.siz_cd=z.siz_cd
    WHERE pf.frm_cd='PRF_CLR_ACRYL' AND pf.prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000161','PRD_000162')),
   tw AS (SELECT DISTINCT siz_width v FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043'),
   th AS (SELECT DISTINCT siz_height v FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043'),
   sel AS (SELECT ps.*, (SELECT MIN(v) FROM tw WHERE v>=ps.cw) sw, (SELECT MIN(v) FROM th WHERE v>=ps.ch) sh FROM ps)
  SELECT count(*) INTO v_uncov FROM sel LEFT JOIN t_prc_component_prices cp ON cp.comp_cd='COMP_ACRYL_CLEAR3T' AND cp.mat_cd='MAT_000043' AND cp.siz_width=sel.sw AND cp.siz_height=sel.sh WHERE cp.comp_price_id IS NULL OR sel.sw IS NULL OR sel.sh IS NULL;
  IF v_uncov>0 THEN RAISE EXCEPTION '미커버 %건',v_uncov; END IF;
  RAISE NOTICE 'DRY-RUN OK: CLR5+COROTTO1 바인딩·BYSIZ폐기·전 등록사이즈 커버·미커버0';
END $$;
ROLLBACK;
\echo '===== ROLLBACK 완료 ====='
