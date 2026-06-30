BEGIN;
-- 1) COAT 단가행 print_opt 보정 (S1=단면 001, S2=양면 002) — STD 동형, 더블카운트 방지
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000001', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_COAT_S1' AND print_opt_cd IS NULL;
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000002', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_COAT_S2' AND print_opt_cd IS NULL;

-- 2) PRF_NAMECARD_COAT 공식 신설 (멱등 가드)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
  SELECT 'PRF_NAMECARD_COAT','코팅명함 면/소재/수량별 단가(용지포함)','§29 명함 배선교정 260630',  'Y'
  WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_COAT');

-- 3) formula_components 배선 (S1 seq1 단면, S2 seq2 양면, addtn Y)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
  SELECT 'PRF_NAMECARD_COAT', v.comp_cd, v.seq, 'Y'
  FROM (VALUES ('COMP_NAMECARD_COAT_S1',1),('COMP_NAMECARD_COAT_S2',2)) v(comp_cd,seq)
  WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd='PRF_NAMECARD_COAT' AND fc.comp_cd=v.comp_cd);

-- 4) 032 rebind FIXED→COAT
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000032' AND frm_cd='PRF_NAMECARD_FIXED';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
  SELECT 'PRD_000032','PRF_NAMECARD_COAT','2026-06-01','§29 배선교정 260630 — 스탠다드 저청구 해소'
  WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000032' AND frm_cd='PRF_NAMECARD_COAT');

\echo '--- 사후상태: 032 바인딩 ---'
SELECT prd_cd,frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000032';
\echo '--- 사후상태: COAT 단가행 print_opt ---'
SELECT comp_cd,mat_cd,print_opt_cd,unit_price FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_NAMECARD_COAT%' ORDER BY comp_cd,unit_price;
\echo '--- 사후상태: PRF_NAMECARD_COAT formula_components ---'
SELECT frm_cd,comp_cd,disp_seq,addtn_yn FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_COAT' ORDER BY disp_seq;
\echo '--- 무회귀: 033 스탠다드/031 프리미엄 바인딩 불변 확인 ---'
SELECT prd_cd,frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000033','PRD_000031') ORDER BY prd_cd,frm_cd;
COMMIT;
\echo '=== ROLLBACK 완료 (COMMIT 완료·실변경) ==='
