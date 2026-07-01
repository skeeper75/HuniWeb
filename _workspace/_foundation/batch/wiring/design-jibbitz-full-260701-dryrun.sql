-- 아크릴지비츠(PRD_000156) 제대로된 가격설계 — DRY-RUN (BEGIN…ROLLBACK)
-- 설계=design-jibbitz-full-260701.md · 실 COMMIT 아님(인간 승인 후 §7)
-- 단가 verbatim(가격표 260527 B04: 투명200/스핀600) · 채번 라이브 MAX+1 실측(2026-07-01)
--   opt_grp OPT_000083 · opt OPV_000493/494 · comp_price_id 79166/79167
-- 재사용(mint 0): DSC_ACR_QTY(권위 정확일치)·opt_cd 엔진경로·아크릴 사이즈5
BEGIN;

-- 1) 공식 신설 --------------------------------------------------------------
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
VALUES ('PRF_ZIBITZ_ACRYL', '아크릴지비츠 가공단가',
        '가공(투명/스핀) opt_cd 단가 × 수량. 사이즈 무관. 수량할인=DSC_ACR_QTY', 'Y', now())
ON CONFLICT (frm_cd) DO NOTHING;

-- 2) 구성요소 신설(단가형·opt_cd 판별) --------------------------------------
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn, reg_dt)
VALUES ('COMP_ACRYL_ZIBITZ', '아크릴지비츠 가공(투명/스핀) 완제품가', NULL,
        'PRICE_TYPE.01', '["opt_cd", "min_qty", "opt_grp:OPT_000083"]'::jsonb, 'Y', 'N', now())
ON CONFLICT (comp_cd) DO NOTHING;

-- 3) 배선 formula_components ------------------------------------------------
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_ZIBITZ_ACRYL', 'COMP_ACRYL_ZIBITZ', 1, 'N', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- 4) 옵션그룹/옵션(opt_cd 드롭다운 소스·택1 필수) --------------------------
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES ('PRD_000156', 'OPT_000083', '가공', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', 'N', now())
ON CONFLICT (prd_cd, opt_grp_cd) DO NOTHING;

INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES
  ('PRD_000156', 'OPV_000493', 'OPT_000083', '투명', 'Y', 1, 'Y', 'N', now()),
  ('PRD_000156', 'OPV_000494', 'OPT_000083', '스핀', 'N', 2, 'Y', 'N', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;

-- 5) 단가행(verbatim 200/600·수량할인은 t_dsc가 적용) -----------------------
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, opt_cd, min_qty, unit_price, apply_ymd, note, reg_dt)
VALUES
  (79166, 'COMP_ACRYL_ZIBITZ', 'OPV_000493', 1, 200, '2026-07-01', '가격표 B04 아크릴지비츠 투명', now()),
  (79167, 'COMP_ACRYL_ZIBITZ', 'OPV_000494', 1, 600, '2026-07-01', '가격표 B04 아크릴지비츠 스핀', now())
ON CONFLICT (comp_price_id) DO NOTHING;

-- 6) 상품↔공식 재바인딩(placeholder→실공식) --------------------------------
UPDATE t_prd_product_price_formulas
   SET frm_cd = 'PRF_ZIBITZ_ACRYL', upd_dt = now()
 WHERE prd_cd = 'PRD_000156' AND frm_cd = 'PRF_ACRYL_ZIBITZ_TBD';

-- 7) 상품↔수량구간할인 링크(DSC_ACR_QTY 재사용) ----------------------------
INSERT INTO t_prd_product_discount_tables (prd_cd, dsc_tbl_cd, apply_bgn_ymd, note, reg_dt)
VALUES ('PRD_000156', 'DSC_ACR_QTY', '2026-06-01', '아크릴 카테고리 수량구간할인 재사용', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- 8) 상품 보정(비규격 증가1·기본수량) --------------------------------------
UPDATE t_prd_products
   SET nonspec_width_incr = 1, nonspec_height_incr = 1,
       dflt_qty = COALESCE(dflt_qty, 100), upd_dt = now()
 WHERE prd_cd = 'PRD_000156';

-- 9) (활성화 — §7 최종 단계·검증 통과 후 선택 실행) -------------------------
-- UPDATE t_prd_products SET use_yn='Y', upd_dt=now() WHERE prd_cd='PRD_000156';

-- ── DRY-RUN 검증 SELECT ───────────────────────────────────────────────────
\echo === 바인딩 ===
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000156';
\echo === 공식-구성요소 ===
SELECT frm_cd, comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components WHERE frm_cd='PRF_ZIBITZ_ACRYL';
\echo === 단가행 ===
SELECT comp_price_id, comp_cd, opt_cd, min_qty, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_ZIBITZ' ORDER BY comp_price_id;
\echo === 옵션 ===
SELECT opt_cd, opt_grp_cd, opt_nm, dflt_yn FROM t_prd_product_options WHERE prd_cd='PRD_000156' ORDER BY disp_seq;
\echo === 할인 링크 ===
SELECT prd_cd, dsc_tbl_cd, apply_bgn_ymd FROM t_prd_product_discount_tables WHERE prd_cd='PRD_000156';
\echo === 상품 보정 ===
SELECT prd_cd, nonspec_width_incr, nonspec_height_incr, dflt_qty, use_yn FROM t_prd_products WHERE prd_cd='PRD_000156';

-- 골든 재계산(SQL 예시·엔진 실호출은 검증가): 투명100 = 200*100*(1-0.20)=16000 · 스핀100=48000
\echo === 골든 산식 확인(투명/스핀 × 100개 · 20%) ===
SELECT 'clear100' AS g, 200*100*(1-0.20) AS expect UNION ALL SELECT 'spin100', 600*100*(1-0.20);

ROLLBACK;
