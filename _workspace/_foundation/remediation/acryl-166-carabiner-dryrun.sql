-- acryl-166-carabiner-dryrun.sql — 166 카라비너 적재 DRY-RUN (ROLLBACK 전용·골든)
-- fix 본문 + 어서션 + ROLLBACK. 라이브 미변경. 종결자=ROLLBACK 확인.
\set ON_ERROR_STOP on
BEGIN;

INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT 'COMP_ACRYL_CARABINER','아크릴카라비너 본체(3T+3T접합)','PRC_COMPONENT_TYPE.01','PRICE_TYPE.02',
       jsonb_build_array('siz_cd','min_qty'),'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_CARABINER');

INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, min_qty, unit_price)
SELECT v.comp_price_id, 'COMP_ACRYL_CARABINER', '2026-06-28', v.siz_cd, 1, v.unit_price
FROM (VALUES (39098::bigint,'SIZ_000366',5800::numeric),(39099,'SIZ_000367',5800),
             (39100,'SIZ_000368',6300),(39101,'SIZ_000369',6900)) AS v(comp_price_id, siz_cd, unit_price)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices p
  WHERE p.comp_cd='COMP_ACRYL_CARABINER' AND p.siz_cd=v.siz_cd AND p.apply_ymd='2026-06-28');

INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT 'PRF_ACRYL_CARABINER','아크릴카라비너 공식','형상별 고정가(3T+3T 접합·by-siz_cd)','Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_CARABINER');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_ACRYL_CARABINER','COMP_ACRYL_CARABINER',1,'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_CARABINER' AND comp_cd='COMP_ACRYL_CARABINER');

INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000166','PRF_ACRYL_CARABINER','2026-06-28','고정가형 by-siz_cd(완전 미적재 해소·R1)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000166' AND frm_cd='PRF_ACRYL_CARABINER');

\echo '== 골든: 카라비너 형상별 고정가(siz_cd 정확매칭·verbatim) =='
WITH g(label, siz_cd, expect) AS (VALUES
  ('자물쇠 40x69',  'SIZ_000366',5800::numeric),
  ('하트자물쇠 43x71','SIZ_000367',5800),
  ('하트 59x54',    'SIZ_000368',6300),
  ('원형 68x70',    'SIZ_000369',6900)
)
SELECT g.label, p.unit_price AS loaded, g.expect,
       CASE WHEN p.unit_price=g.expect THEN 'PASS' ELSE 'FAIL' END AS verdict
FROM g JOIN t_prc_component_prices p
  ON p.comp_cd='COMP_ACRYL_CARABINER' AND p.siz_cd=g.siz_cd AND p.apply_ymd='2026-06-28'
ORDER BY g.label;

\echo '== 그릇 무결성: comp/공식/배선/바인딩 + siz_cd 4 등록사이즈 정합 =='
SELECT 'comp' k, count(*)::text v FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_CARABINER'
UNION ALL SELECT 'price_rows', count(*)::text FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CARABINER' AND apply_ymd='2026-06-28'
UNION ALL SELECT 'bind', count(*)::text FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000166' AND frm_cd='PRF_ACRYL_CARABINER'
UNION ALL SELECT 'siz_match', count(*)::text FROM t_prc_component_prices p
  WHERE p.comp_cd='COMP_ACRYL_CARABINER' AND p.apply_ymd='2026-06-28'
    AND EXISTS (SELECT 1 FROM t_prd_product_sizes s WHERE s.prd_cd='PRD_000166' AND s.siz_cd=p.siz_cd);

ROLLBACK;
\echo '== ROLLBACK 완료 — 라이브 미변경 =='
