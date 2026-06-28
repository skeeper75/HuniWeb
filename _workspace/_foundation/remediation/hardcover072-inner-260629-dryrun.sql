-- =====================================================================
-- 하드커버책자072 내지(PRD_000284) 디지털인쇄 페이지가 — DRY-RUN (BEGIN/ROLLBACK)
--
-- ★모델 판정(설계서 hardcover072-inner-page-design-260629.md):
--   072 내지 = 포토북식 단순 단가형(.01) **불가**(수량할인 72~73% 존재).
--   정답 = 디지털인쇄 합가형 B = COMP_PRINT_DIGITAL_S1(인쇄비·판수밴드) + COMP_PAPER(용지비·절가×출력매수).
--   엔진: derive_inner_sheets(부수,page,pansu)·plate_qty·fn_calc_pansu 이미 존재(pricing.py).
--
-- ★이 SQL이 하는 것: 슬림 내지 공식 PRF_DGP_INNER 신설 + 인쇄비/용지비 2 comp 배선 + 284 바인딩.
--   단가행은 COMP_PRINT_DIGITAL_S1(국4절 단면 53행)·COMP_PAPER(백색모조100g 국4절 30.73) = **전부 재사용**(신규 단가행 0).
--
-- ★★★ BLOCKED (이 SQL로 불가·dbmap 트랙·인간 승인) — 이것 없이는 바인딩만 COMMIT해도 0원:
--   ① 284 출력판형 plt_siz(국4절 SIZ_000499) 등록  ② 내지종이 자재(MAT_000072 등) 등록
--   ③ 내지사이즈 siz_cd(A5/A4) 등록(fn_calc_pansu 인자)  ④ 인쇄옵션 단면(POPT_000001) 등록
--   ⑤ `*별도설정` 다른 내지종이 국4절 절가 COMP_PAPER 단가행(백색모조100g 외)
--   → 차원 충전(dbmap) 선결 후라야 견적 산출. 이 SQL은 공식/배선/바인딩 그릇만.
--
-- ★★★ 자동 실행 금지 — 사람 검토 후 COMMIT. 기본 ROLLBACK(안전). ★★★
-- =====================================================================

\set ON_ERROR_STOP on
BEGIN;

-- 0) 선결조건 가시 검증 (재사용 단가행·차원 충전 현황) -------------------
--    이 블록은 SELECT만(INSERT 전 현황 스냅샷·날조 방지).
SELECT '재사용 인쇄비단가행(국4절단면)' t, count(*) n
  FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_DIGITAL_S1'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001'   -- 기대 53
UNION ALL SELECT '재사용 용지비단가행(백모조100g국4절)', count(*)
  FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER'
    AND plt_siz_cd='SIZ_000499' AND mat_cd='MAT_000072'          -- 기대 1(=30.73)
UNION ALL SELECT '284 출력판형(plt_siz) [BLOCKED]', count(*)
  FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000284' AND del_yn='N'  -- 0=차원미충전
UNION ALL SELECT '284 내지종이 자재 [BLOCKED]', count(*)
  FROM t_prd_product_materials WHERE prd_cd='PRD_000284' AND del_yn='N'    -- 0=차원미충전
UNION ALL SELECT '284 사이즈 [BLOCKED]', count(*)
  FROM t_prd_product_sizes WHERE prd_cd='PRD_000284' AND del_yn='N';       -- 0=차원미충전

-- 1) 슬림 내지 공식 PRF_DGP_INNER (신규·search-before-mint: 부재 확인됨) --
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_DGP_INNER',
       '디지털인쇄 책자 내지(인쇄비+용지비·출력매수 기준)',
       '책자류 내지 구성원 공식. 인쇄비(판수밴드×판수)+용지비(절가×출력매수). 위젯 qty=derive_inner_sheets(부수,page,pansu). 072/077/082/088 동형 공유.',
       'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_INNER');

-- 2) formula_components 배선 (둘 다 기존 comp 재사용·addtn_yn=Y 합산) ------
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_DGP_INNER', 'COMP_PRINT_DIGITAL_S1', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_DGP_INNER' AND comp_cd='COMP_PRINT_DIGITAL_S1');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_DGP_INNER', 'COMP_PAPER', 2, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_DGP_INNER' AND comp_cd='COMP_PAPER');

-- 3) 부모 내지(284) 바인딩 ------------------------------------------------
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000284', 'PRF_DGP_INNER', '2026-06-06',
       '하드커버책자 내지 구성원. 디지털 합가형(인쇄+용지). 차원 충전(plt_siz/자재/사이즈/인쇄옵션) 선결.',
       now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas
  WHERE prd_cd='PRD_000284' AND frm_cd='PRF_DGP_INNER' AND apply_bgn_ymd='2026-06-06');

-- 4) 검증 SELECT (COMMIT 전 눈으로 확인 — 기대값 우측) --------------------
SELECT 'INNER공식' t, count(*) n FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_INNER'  -- 1
UNION ALL SELECT '배선(인쇄+용지)', count(*) FROM t_prc_formula_components
  WHERE frm_cd='PRF_DGP_INNER' AND comp_cd IN ('COMP_PRINT_DIGITAL_S1','COMP_PAPER')  -- 2
UNION ALL SELECT '284 바인딩', count(*) FROM t_prd_product_price_formulas
  WHERE prd_cd='PRD_000284' AND frm_cd='PRF_DGP_INNER';  -- 1

-- ★★★ 위 검증이 기대대로(1/2/1)면 사람이 COMMIT 주석 해제. 아니면 ROLLBACK. ★★★
-- ★단, COMMIT해도 §BLOCKED 차원 충전(dbmap) 전엔 내지 견적 0원(plt_siz/mat 미선택→매칭0).
--   완전 견적 산출 = 차원 충전 + 임포지션/rounding C트랙 확정 + post-COMMIT simulate_set 골든.
-- COMMIT;
ROLLBACK;   -- 기본값 = 안전(롤백). 사람이 COMMIT 으로 바꿔 실행.


-- =====================================================================
-- UNDO (COMMIT 후 되돌리기) — FK 역위상.
-- =====================================================================
-- BEGIN;
-- DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000284' AND frm_cd='PRF_DGP_INNER' AND apply_bgn_ymd='2026-06-06';
-- DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_DGP_INNER';
-- DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_INNER';
-- -- COMMIT;
-- ROLLBACK;
