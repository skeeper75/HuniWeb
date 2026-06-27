-- acryl-154-hairband-fix.sql — 154 아크릴 머리끈 견적불가 해소 (라이브 COMMIT 후보)
-- 결함: COMP_ACRYL_BLACK_HAIR_BAND 빈 껍데기(단가행 0) + PRD_000154 바인딩 0 = 견적불가.
-- 교정: HAIR_BAND 단가행 충전(500) + 전용공식 PRF_ACRYL_HAIRBAND(본체 CLEAR3T 재사용 + 머리끈 가산) + 바인딩.
-- 권위: 상품마스터 아크릴 시트(154 머리끈=블랙헤어끈 500) + 가격표 B04b. 단가 verbatim. [[base-master-code-no-delete]].
-- 채번: comp_price_id 39086(라이브 MAX 39085+1). 옵션/그룹/자재 기존(OPV-000028·OPT-000014·MAT_000057) 재사용.
-- 멱등: 전부 NOT EXISTS 가드. 단일 트랜잭션. ★실 COMMIT은 인간 승인 후. dryrun은 ROLLBACK+골든.
\set ON_ERROR_STOP on
BEGIN;

-- [1] HAIR_BAND 단가행 충전 (opt_cd 판별차원·always-add 가드·단가형 장당가)
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, opt_cd, min_qty, unit_price)
SELECT 39086::bigint, 'COMP_ACRYL_BLACK_HAIR_BAND', '2026-06-28', 'OPV-000028', 1, 500::numeric
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_ACRYL_BLACK_HAIR_BAND' AND opt_cd='OPV-000028' AND apply_ymd='2026-06-28'
);

-- [2] 전용공식 (본체 면적 + 머리끈 가산)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT 'PRF_ACRYL_HAIRBAND', '아크릴머리끈 공식', '본체 면적 + 머리끈 가산(addon)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_HAIRBAND');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT v.frm_cd, v.comp_cd, v.disp_seq, v.addtn_yn
FROM (VALUES
  ('PRF_ACRYL_HAIRBAND','COMP_ACRYL_CLEAR3T',1,'N'),
  ('PRF_ACRYL_HAIRBAND','COMP_ACRYL_BLACK_HAIR_BAND',2,'Y')
) AS v(frm_cd, comp_cd, disp_seq, addtn_yn)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd=v.frm_cd AND fc.comp_cd=v.comp_cd
);

-- [3] 상품-공식 바인딩
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000154', 'PRF_ACRYL_HAIRBAND', '2026-06-28', 'addon — 본체+머리끈 가산(견적불가 해소)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000154' AND frm_cd='PRF_ACRYL_HAIRBAND'
);

COMMIT;
