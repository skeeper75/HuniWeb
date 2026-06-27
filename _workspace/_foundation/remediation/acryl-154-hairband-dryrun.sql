-- acryl-154-hairband-dryrun.sql — 154 머리끈 적재 DRY-RUN (ROLLBACK 전용·골든)
-- fix 본문을 BEGIN…어서션…ROLLBACK 으로 감쌈. 라이브 미변경. 종결자=ROLLBACK 확인.
\set ON_ERROR_STOP on
BEGIN;

INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, opt_cd, min_qty, unit_price)
SELECT 39086::bigint, 'COMP_ACRYL_BLACK_HAIR_BAND', '2026-06-28', 'OPV-000028', 1, 500::numeric
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_ACRYL_BLACK_HAIR_BAND' AND opt_cd='OPV-000028' AND apply_ymd='2026-06-28');

INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT 'PRF_ACRYL_HAIRBAND', '아크릴머리끈 공식', '본체 면적 + 머리끈 가산(addon)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_HAIRBAND');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT v.frm_cd, v.comp_cd, v.disp_seq, v.addtn_yn
FROM (VALUES ('PRF_ACRYL_HAIRBAND','COMP_ACRYL_CLEAR3T',1,'N'),
             ('PRF_ACRYL_HAIRBAND','COMP_ACRYL_BLACK_HAIR_BAND',2,'Y')) AS v(frm_cd, comp_cd, disp_seq, addtn_yn)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd=v.frm_cd AND fc.comp_cd=v.comp_cd);

INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000154', 'PRF_ACRYL_HAIRBAND', '2026-06-28', 'addon — 본체+머리끈 가산(견적불가 해소)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000154' AND frm_cd='PRF_ACRYL_HAIRBAND');

\echo '== G12 골든: 154 머리끈 20x20 = 본체2500 + 머리끈500 = 3000 =='
WITH body AS (
  SELECT unit_price AS body_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043' AND siz_width=20 AND siz_height=20 AND min_qty=1
), addp AS (
  SELECT unit_price AS add_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_ACRYL_BLACK_HAIR_BAND' AND opt_cd='OPV-000028' AND apply_ymd='2026-06-28'
)
SELECT b.body_price, a.add_price, (b.body_price+a.add_price) AS calc, 3000 AS expect,
       CASE WHEN (b.body_price+a.add_price)=3000 THEN 'PASS' ELSE 'FAIL' END AS verdict
FROM body b CROSS JOIN addp a;

\echo '== 바인딩/공식/always-add 가드 =='
SELECT 'bind' k, prd_cd::text v FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000154' AND frm_cd='PRF_ACRYL_HAIRBAND'
UNION ALL SELECT 'fc_count', count(*)::text FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_HAIRBAND'
UNION ALL SELECT 'has_opt_cd', (use_dims @> '["opt_cd"]'::jsonb)::text FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_BLACK_HAIR_BAND';

ROLLBACK;
\echo '== ROLLBACK 완료 — 라이브 미변경 =='
