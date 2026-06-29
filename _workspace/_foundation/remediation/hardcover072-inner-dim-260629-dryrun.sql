-- =====================================================================
-- 하드커버책자072 내지(PRD_000284) 차원 충전 — DRY-RUN (BEGIN/ROLLBACK)
--
-- ★목적: 284에 사이즈·출력판형·내지종이 자재·인쇄옵션 + 페이지가 공식(PRF_DGP_INNER)을
--   한 번에 충전해 종단 견적 가능화. Track B(공식·바인딩)는 ROLLBACK 상태라 본 SQL에 함께 포함.
--
-- ★권위(상품마스터 booklet-l1 하드커버책자 row38/39):
--   사이즈 A5(148x210)단면 + A4(210x297)양면 · 내지종이 *별도설정(택N) · 내지인쇄 단면/양면 · page 24~300/2 · 출력 PDF
--
-- ★search-before-mint(라이브 실측 완료·신규 mint 0):
--   SIZ_000170(A5정본)·SIZ_000172(A4정본)·SIZ_000499(국4절) · MAT 8종(국4절 단가행 전부 보유) ·
--   POPT_000001(단면)·POPT_000002(양면) · COMP_PRINT_DIGITAL_S1·COMP_PAPER · PRF_DGP_INNER(미존재→신설)
--
-- ★공정 충전 없음(내지=출력만·제본/코팅/박은 세트072/표지073 — 이중계상 방지).
--
-- ★★★ 자동 실행 금지 — 사람 검토 후 COMMIT. 기본 ROLLBACK(안전). ★★★
-- ★★★ COMMIT 후 post-COMMIT 골든: sim.simulate_set('PRD_000072', ...) 내지 member 가격>0 확인. ★★★
-- =====================================================================

\set ON_ERROR_STOP on
BEGIN;

-- 0) 선결 가시 검증 (재사용 코드 실재 + 차원 충전 전 현황 스냅샷·SELECT only) -----
SELECT '정본 A5(SIZ_000170)' t, count(*) n FROM t_siz_sizes WHERE siz_cd='SIZ_000170'              -- 1
UNION ALL SELECT '정본 A4(SIZ_000172)', count(*) FROM t_siz_sizes WHERE siz_cd='SIZ_000172'        -- 1
UNION ALL SELECT '국4절 plate(SIZ_000499)', count(*) FROM t_siz_sizes WHERE siz_cd='SIZ_000499'    -- 1
UNION ALL SELECT '내지종이8종 국4절 단가행', count(*) FROM t_prc_component_prices
  WHERE comp_cd='COMP_PAPER' AND plt_siz_cd='SIZ_000499'
    AND mat_cd IN ('MAT_000072','MAT_000073','MAT_000086','MAT_000087','MAT_000076','MAT_000077','MAT_000104','MAT_000105')  -- 8
UNION ALL SELECT 'POPT 단면/양면', count(*) FROM t_prt_print_options
  WHERE print_opt_cd IN ('POPT_000001','POPT_000002')                                              -- 2
UNION ALL SELECT 'PRF_DGP_INNER 기존(미존재 기대)', count(*) FROM t_prc_price_formulas
  WHERE frm_cd='PRF_DGP_INNER'                                                                     -- 0
UNION ALL SELECT '284 차원 충전 전(전부 0 기대)', (
  (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000284' AND del_yn='N')
  + (SELECT count(*) FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000284' AND del_yn='N')
  + (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000284' AND del_yn='N')
  + (SELECT count(*) FROM t_prd_product_print_options WHERE prd_cd='PRD_000284' AND del_yn='N'));   -- 0

-- =====================================================================
-- 1) 페이지가 공식 PRF_DGP_INNER (Track B 재포함·search-before-mint 부재확인) ----
-- =====================================================================
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_DGP_INNER',
       '디지털인쇄 책자 내지(인쇄비+용지비·출력매수 기준)',
       '책자류 내지 구성원 공식. 인쇄비(판수밴드×판수)+용지비(절가×출력매수). 위젯 qty=derive_inner_sheets(부수,page,pansu). 072/077/082/088 동형 공유.',
       'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_INNER');

-- 2) formula_components (인쇄비+용지비·둘 다 기존 comp·addtn_yn=Y 합산) -----------
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_DGP_INNER', 'COMP_PRINT_DIGITAL_S1', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_DGP_INNER' AND comp_cd='COMP_PRINT_DIGITAL_S1');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_DGP_INNER', 'COMP_PAPER', 2, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_DGP_INNER' AND comp_cd='COMP_PAPER');

-- =====================================================================
-- 3) 사이즈 (t_prd_product_sizes) — A5(단면·dflt)·A4(양면) -----------------------
-- =====================================================================
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000284', 'SIZ_000170', 'Y', 1, now(), 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes WHERE prd_cd='PRD_000284' AND siz_cd='SIZ_000170');

INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000284', 'SIZ_000172', 'N', 2, now(), 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes WHERE prd_cd='PRD_000284' AND siz_cd='SIZ_000172');

-- =====================================================================
-- 4) 출력판형 (t_prd_product_plate_sizes) — 국4절 (016 패턴 dflt_plt_yn=N) --------
-- =====================================================================
INSERT INTO t_prd_product_plate_sizes (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, output_file_typ, reg_dt, del_yn)
SELECT 'PRD_000284', 'SIZ_000499', 'N', 'OUTPUT_PAPER_TYPE.01', 'PDF', now(), 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000284' AND siz_cd='SIZ_000499');

-- =====================================================================
-- 5) 내지종이 자재 (t_prd_product_materials) — *별도설정 → 책자 내지 8종(USAGE.07) ---
--    전부 COMP_PAPER 국4절 단가행 보유(견적0 방지). MAT_000072=기본(probe 오라클).
-- =====================================================================
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000284', v.mat_cd, 'USAGE.07', v.dflt, v.seq, now(), 'N'
FROM (VALUES
  ('MAT_000072','Y',1),  -- 백색모조지 100g (기본)
  ('MAT_000073','N',2),  -- 백색모조지 120g
  ('MAT_000086','N',3),  -- 스노우지 100g
  ('MAT_000087','N',4),  -- 스노우지 120g
  ('MAT_000076','N',5),  -- 아트지 100g
  ('MAT_000077','N',6),  -- 아트지 120g
  ('MAT_000104','N',7),  -- 몽블랑 100g
  ('MAT_000105','N',8)   -- 몽블랑 130g
) AS v(mat_cd, dflt, seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials m
  WHERE m.prd_cd='PRD_000284' AND m.mat_cd=v.mat_cd AND m.usage_cd='USAGE.07');

-- =====================================================================
-- 6) 인쇄옵션 (t_prd_product_print_options) — 단면(dflt)·양면 (016 패턴) ----------
-- =====================================================================
INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn)
SELECT 'PRD_000284', 1, '단면', 'CLR_000005', 'CLR_000001', 'Y', 1, 'POPT_000001', now(), 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options WHERE prd_cd='PRD_000284' AND opt_id=1);

INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn)
SELECT 'PRD_000284', 2, '양면', 'CLR_000005', 'CLR_000005', 'N', 2, 'POPT_000002', now(), 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options WHERE prd_cd='PRD_000284' AND opt_id=2);

-- =====================================================================
-- 7) 부모 내지(284) 가격공식 바인딩 ---------------------------------------------
-- =====================================================================
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000284', 'PRF_DGP_INNER', '2026-06-06',
       '하드커버책자 내지 구성원. 디지털 합가형(인쇄+용지). 차원 충전(A5/A4·국4절·내지종이8·단면/양면) 동시 적재.',
       now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas
  WHERE prd_cd='PRD_000284' AND frm_cd='PRF_DGP_INNER' AND apply_bgn_ymd='2026-06-06');

-- =====================================================================
-- 8) 검증 SELECT (COMMIT 전 눈으로 — 기대값 우측) -------------------------------
-- =====================================================================
SELECT 'PRF_DGP_INNER 공식' t, count(*) n FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_INNER'  -- 1
UNION ALL SELECT '배선(인쇄+용지)', count(*) FROM t_prc_formula_components
  WHERE frm_cd='PRF_DGP_INNER'                                                                    -- 2
UNION ALL SELECT '284 사이즈(A5/A4)', count(*) FROM t_prd_product_sizes
  WHERE prd_cd='PRD_000284' AND del_yn='N'                                                        -- 2
UNION ALL SELECT '284 출력판형(국4절)', count(*) FROM t_prd_product_plate_sizes
  WHERE prd_cd='PRD_000284' AND del_yn='N'                                                        -- 1
UNION ALL SELECT '284 내지종이(8종)', count(*) FROM t_prd_product_materials
  WHERE prd_cd='PRD_000284' AND del_yn='N'                                                        -- 8
UNION ALL SELECT '284 인쇄옵션(단면/양면)', count(*) FROM t_prd_product_print_options
  WHERE prd_cd='PRD_000284' AND del_yn='N'                                                        -- 2
UNION ALL SELECT '284 가격공식 바인딩', count(*) FROM t_prd_product_price_formulas
  WHERE prd_cd='PRD_000284' AND frm_cd='PRF_DGP_INNER';                                           -- 1

-- 기대 결과: 1 / 2 / 2 / 1 / 8 / 2 / 1

-- ★★★ 위 검증이 1/2/2/1/8/2/1 이면 사람이 COMMIT 으로 바꿔 실행. 아니면 ROLLBACK. ★★★
-- COMMIT;
ROLLBACK;   -- 기본값 = 안전(롤백). 사람이 COMMIT 으로 바꿔 실행.


-- =====================================================================
-- UNDO (COMMIT 후 되돌리기) — FK 역위상.
-- =====================================================================
-- BEGIN;
-- DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000284' AND frm_cd='PRF_DGP_INNER' AND apply_bgn_ymd='2026-06-06';
-- DELETE FROM t_prd_product_print_options WHERE prd_cd='PRD_000284' AND opt_id IN (1,2);
-- DELETE FROM t_prd_product_materials WHERE prd_cd='PRD_000284' AND usage_cd='USAGE.07'
--   AND mat_cd IN ('MAT_000072','MAT_000073','MAT_000086','MAT_000087','MAT_000076','MAT_000077','MAT_000104','MAT_000105');
-- DELETE FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000284' AND siz_cd='SIZ_000499';
-- DELETE FROM t_prd_product_sizes WHERE prd_cd='PRD_000284' AND siz_cd IN ('SIZ_000170','SIZ_000172');
-- DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_DGP_INNER';
-- DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_INNER';
-- -- COMMIT;
-- ROLLBACK;
