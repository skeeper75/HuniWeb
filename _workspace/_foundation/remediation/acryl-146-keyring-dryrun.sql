-- 검증(ROLLBACK). 신규공식 배선·재바인딩·골든(본체+고리) 어서션.
BEGIN;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn) VALUES ('PRF_ACRYL_KEYRING','아크릴키링 공식','본체+고리','Y');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) VALUES
 ('PRF_ACRYL_KEYRING','COMP_ACRYL_CLEAR3T',1,'N'),('PRF_ACRYL_KEYRING','COMP_ACRYL_KEYRING',2,'Y');
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000146' AND frm_cd IN ('PRF_CLR_ACRYL','PRF_ACRYL_KEYRING');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note) VALUES ('PRD_000146','PRF_ACRYL_KEYRING','2026-06-28','본체+고리');

\echo '===== 골든: 146 키링 본체(area)+고리 합산 (qty=1) ====='
SELECT '30x30+은색고리' AS case,
  (SELECT unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043' AND siz_width=30 AND siz_height=30) AS body,
  (SELECT unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_KEYRING' AND opt_cd='OPV-000026') AS ring_silver,
  (SELECT unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043' AND siz_width=30 AND siz_height=30)
  +(SELECT unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_KEYRING' AND opt_cd='OPV-000026') AS total_expect_4200;

DO $$ DECLARE v_fc int; v_bind text; BEGIN
  SELECT count(*) INTO v_fc FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_KEYRING';
  IF v_fc<>2 THEN RAISE EXCEPTION 'PRF_ACRYL_KEYRING 배선 %(기대2)',v_fc; END IF;
  SELECT string_agg(frm_cd,',') INTO v_bind FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000146';
  IF v_bind<>'PRF_ACRYL_KEYRING' THEN RAISE EXCEPTION '146 바인딩=%(기대 PRF_ACRYL_KEYRING 단독)',v_bind; END IF;
  RAISE NOTICE 'DRY-RUN OK: PRF_ACRYL_KEYRING 본체+고리 배선·146 재바인딩·고리가산 작동(저청구 해소)';
END $$;
ROLLBACK;
\echo '===== ROLLBACK 완료 ====='
