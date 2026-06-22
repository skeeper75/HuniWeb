-- =====================================================================
-- dryrun_evaluate.sql — 포토카드 V3 교정 DRY-RUN (라이브 트랜잭션 + evaluate_price 로직 SQL 재현 + ROLLBACK)
-- §21 카탈로그 정합 · 2026-06-23 · huni-catalog-conformance/09_load/_overcharge_photocard_260623
--
-- 폴백 사유: 시스템 python에 Django/psycopg 미설치·webadmin venv 부재(foldcard와 동일).
--   → pricing.py:_evaluate_formula(:537-596) 충실 재현으로 base 합산 실증.
--
-- ★재현 충실성(pricing.py 인용):
--   - evaluate_price(:412-419): BIND(TPrdProductPriceFormulas)에서 prd_cd의 frm_cd 조회 → _evaluate_formula(frm_cd).
--   - _evaluate_formula(:551): TPrcFormulaComponents.filter(frm_cd=frm_cd) — ★그 공식의 FC만 가져옴.
--   - 포토카드 comp는 비수량 판별축 전무·차원(siz/bdl/min) 동일 매칭 → included → subtotal 합산(:591-595).
--   → base 합산 = SELECT sum over (BIND→공식의 FC)→component_prices(min_qty=1 구간). qty=1 가정.
--
-- ★핵심: 공식 분리는 판별축 불요 — 공식 자체가 어느 comp를 보는지 결정. 부분교정 함정(P8-1) 없음.
-- =====================================================================

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------
-- BEFORE: 현 라이브 (024·025 둘 다 PRF_PHOTOCARD_FIXED → SET+CLEAR_SET 둘 다 매칭)
-- ---------------------------------------------------------------------
\echo '=== BEFORE 교정 (현 라이브·둘 다 PRF_PHOTOCARD_FIXED) ==='
SELECT b.prd_cd,
       b.frm_cd,
       string_agg(cp.comp_cd || '=' || cp.unit_price, ' + ' ORDER BY cp.comp_cd) AS comps,
       sum(cp.unit_price) AS base_amount_qty1
FROM t_prd_product_price_formulas b
JOIN t_prc_formula_components fc ON fc.frm_cd = b.frm_cd
JOIN t_prc_component_prices cp ON cp.comp_cd = fc.comp_cd AND cp.min_qty = 1
WHERE b.prd_cd IN ('PRD_000024','PRD_000025')
GROUP BY b.prd_cd, b.frm_cd
ORDER BY b.prd_cd;
-- 기대: 024·025 둘 다 base=14500 (6000+8500 silent 합산)

-- ---------------------------------------------------------------------
-- 교정 적용 (apply.sql Phase A~D 동등)
-- ---------------------------------------------------------------------
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES ('PRF_PHOTOCARD_NORMAL','일반포토카드 세트 고정가','dryrun','Y') ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES ('PRF_PHOTOCARD_CLEAR','투명포토카드 세트 고정가','dryrun','Y') ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_PHOTOCARD_NORMAL','COMP_PHOTOCARD_SET',1,'Y') ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_PHOTOCARD_CLEAR','COMP_PHOTOCARD_CLEAR_SET',1,'Y') ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_PHOTOCARD_NORMAL'
WHERE prd_cd='PRD_000024' AND apply_bgn_ymd='2026-06-01';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_PHOTOCARD_CLEAR'
WHERE prd_cd='PRD_000025' AND apply_bgn_ymd='2026-06-01';
UPDATE t_prc_price_formulas SET use_yn='N' WHERE frm_cd='PRF_PHOTOCARD_FIXED';

-- ---------------------------------------------------------------------
-- AFTER: 교정 후 (024→NORMAL=SET만·025→CLEAR=CLEAR_SET만)
-- ---------------------------------------------------------------------
\echo '=== AFTER 교정 (024→NORMAL·025→CLEAR·공식이 자기 comp만 봄) ==='
SELECT b.prd_cd,
       b.frm_cd,
       string_agg(cp.comp_cd || '=' || cp.unit_price, ' + ' ORDER BY cp.comp_cd) AS comps,
       sum(cp.unit_price) AS base_amount_qty1
FROM t_prd_product_price_formulas b
JOIN t_prc_formula_components fc ON fc.frm_cd = b.frm_cd
JOIN t_prc_component_prices cp ON cp.comp_cd = fc.comp_cd AND cp.min_qty = 1
WHERE b.prd_cd IN ('PRD_000024','PRD_000025')
GROUP BY b.prd_cd, b.frm_cd
ORDER BY b.prd_cd;
-- 기대: 024 base=6000(SET만)·025 base=8500(CLEAR_SET만)

-- ---------------------------------------------------------------------
-- 자동 판정 (14500→6000·14500→8500·verbatim)
-- ---------------------------------------------------------------------
DO $$
DECLARE v24 numeric; v25 numeric; vset numeric; vclr numeric;
BEGIN
  SELECT sum(cp.unit_price) INTO v24
  FROM t_prd_product_price_formulas b
  JOIN t_prc_formula_components fc ON fc.frm_cd=b.frm_cd
  JOIN t_prc_component_prices cp ON cp.comp_cd=fc.comp_cd AND cp.min_qty=1
  WHERE b.prd_cd='PRD_000024';
  SELECT sum(cp.unit_price) INTO v25
  FROM t_prd_product_price_formulas b
  JOIN t_prc_formula_components fc ON fc.frm_cd=b.frm_cd
  JOIN t_prc_component_prices cp ON cp.comp_cd=fc.comp_cd AND cp.min_qty=1
  WHERE b.prd_cd='PRD_000025';
  SELECT sum(unit_price) INTO vset FROM t_prc_component_prices WHERE comp_cd='COMP_PHOTOCARD_SET';
  SELECT sum(unit_price) INTO vclr FROM t_prc_component_prices WHERE comp_cd='COMP_PHOTOCARD_CLEAR_SET';

  RAISE NOTICE '024 AFTER base = % (기대 6000)', v24;
  RAISE NOTICE '025 AFTER base = % (기대 8500)', v25;
  RAISE NOTICE 'verbatim: SET 합=% (기대 6000) · CLEAR_SET 합=% (기대 8500)', vset, vclr;

  IF v24 <> 6000 THEN RAISE EXCEPTION 'FAIL: 024 base % <> 6000', v24; END IF;
  IF v25 <> 8500 THEN RAISE EXCEPTION 'FAIL: 025 base % <> 8500', v25; END IF;
  IF vset <> 6000 OR vclr <> 8500 THEN RAISE EXCEPTION 'FAIL verbatim: SET=% CLEAR=%', vset, vclr; END IF;
  RAISE NOTICE '✅ DRY-RUN PASS: 14500→6000(024)·14500→8500(025)·verbatim 불변';
END $$;

ROLLBACK;
