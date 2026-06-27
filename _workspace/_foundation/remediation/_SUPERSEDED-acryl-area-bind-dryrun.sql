-- acryl-area-bind-dryrun.sql — 위 fix의 검증용(ROLLBACK). 라이브 미변경.
-- 엔진 ceiling 매칭을 SQL로 충실 재현해 13 등록사이즈 정답가를 사후상태에서 입증 + 어서션.
BEGIN;

-- (fix와 동일 변경)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000157' AND frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_component_prices       WHERE comp_cd='COMP_ACRYL_3T_BYSIZ';
DELETE FROM t_prc_formula_components      WHERE frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_price_formulas          WHERE frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_price_components        WHERE comp_cd='COMP_ACRYL_3T_BYSIZ';
DELETE FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000160','PRD_000161','PRD_000162')
   AND frm_cd='PRF_CLR_ACRYL';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note) VALUES
 ('PRD_000157','PRF_CLR_ACRYL','2026-06-27','아크릴네임택'),
 ('PRD_000158','PRF_CLR_ACRYL','2026-06-27','아크릴 포카키링'),
 ('PRD_000159','PRF_CLR_ACRYL','2026-06-27','아크릴 코스터'),
 ('PRD_000160','PRF_CLR_ACRYL','2026-06-27','아크릴자유형스탠드'),
 ('PRD_000161','PRF_CLR_ACRYL','2026-06-27','판아크릴'),
 ('PRD_000162','PRF_CLR_ACRYL','2026-06-27','아크릴포카스탠드');

\echo '===== AFTER: 13 등록사이즈 엔진 ceiling 매칭 → 정답가(MAT_043) ====='
WITH prod_sizes AS (
   SELECT ps.prd_cd, ps.siz_cd, s.cut_width cw, s.cut_height ch, s.siz_nm
   FROM t_prd_product_price_formulas pf
   JOIN t_prd_product_sizes ps ON ps.prd_cd=pf.prd_cd AND COALESCE(ps.del_yn,'N')<>'Y'
   JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
   WHERE pf.frm_cd='PRF_CLR_ACRYL'
     AND pf.prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000160','PRD_000161','PRD_000162')),
 tw AS (SELECT DISTINCT siz_width v FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043'),
 th AS (SELECT DISTINCT siz_height v FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043'),
 sel AS (SELECT ps.*, (SELECT MIN(v) FROM tw WHERE v>=ps.cw) sw, (SELECT MIN(v) FROM th WHERE v>=ps.ch) sh FROM prod_sizes ps)
SELECT sel.prd_cd, sel.siz_nm, sel.cw||'x'||sel.ch cut, sel.sw||'x'||sel.sh ceil_cell, cp.unit_price engine_price
FROM sel LEFT JOIN t_prc_component_prices cp
  ON cp.comp_cd='COMP_ACRYL_CLEAR3T' AND cp.mat_cd='MAT_000043' AND cp.siz_width=sel.sw AND cp.siz_height=sel.sh
ORDER BY sel.prd_cd, sel.cw, sel.ch;

DO $$ DECLARE v_bind int; v_bysiz int; v_uncov int; BEGIN
  -- 6개 바인딩 존재
  SELECT count(*) INTO v_bind FROM t_prd_product_price_formulas
   WHERE frm_cd='PRF_CLR_ACRYL' AND prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000160','PRD_000161','PRD_000162');
  IF v_bind<>6 THEN RAISE EXCEPTION '면적바인딩 %개(기대 6)',v_bind; END IF;
  -- BYSIZ 임시모델 완전 폐기
  SELECT (SELECT count(*) FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_BYSIZ')
        +(SELECT count(*) FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_3T_BYSIZ')
        +(SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_3T_BYSIZ')
   INTO v_bysiz;
  IF v_bysiz<>0 THEN RAISE EXCEPTION 'BYSIZ 잔재 %건(기대 0)',v_bysiz; END IF;
  -- 전 등록사이즈가 ceiling 셀 가격 보유(미커버=견적불가)
  WITH prod_sizes AS (
     SELECT ps.prd_cd, s.cut_width cw, s.cut_height ch FROM t_prd_product_price_formulas pf
     JOIN t_prd_product_sizes ps ON ps.prd_cd=pf.prd_cd AND COALESCE(ps.del_yn,'N')<>'Y'
     JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
     WHERE pf.frm_cd='PRF_CLR_ACRYL' AND pf.prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000160','PRD_000161','PRD_000162')),
   tw AS (SELECT DISTINCT siz_width v FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043'),
   th AS (SELECT DISTINCT siz_height v FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043'),
   sel AS (SELECT ps.*, (SELECT MIN(v) FROM tw WHERE v>=ps.cw) sw, (SELECT MIN(v) FROM th WHERE v>=ps.ch) sh FROM prod_sizes ps)
  SELECT count(*) INTO v_uncov FROM sel LEFT JOIN t_prc_component_prices cp
    ON cp.comp_cd='COMP_ACRYL_CLEAR3T' AND cp.mat_cd='MAT_000043' AND cp.siz_width=sel.sw AND cp.siz_height=sel.sh
   WHERE cp.comp_price_id IS NULL OR sel.sw IS NULL OR sel.sh IS NULL;
  IF v_uncov>0 THEN RAISE EXCEPTION '미커버 사이즈 %건(견적불가)',v_uncov; END IF;
  RAISE NOTICE 'DRY-RUN OK: 면적바인딩 6·BYSIZ폐기·13사이즈 전부 정답셀 커버·미커버 0';
END $$;

ROLLBACK;
\echo '===== ROLLBACK 완료 (라이브 미변경) ====='
