-- =====================================================================
-- 포토북(PRD_000100) 세트 완제품가 — DRY-RUN 버전 (BEGIN/ROLLBACK·검증용)
--
-- ★★★ 이 파일을 자동 실행하지 마라. 사람이 검토 후 COMMIT 주석 해제하여 수동 실행. ★★★
--
-- 권위 공식(상품마스터 photobook-l1, verbatim):
--   총가 = 부수 × ( 기본24P[사이즈·표지타입] + 추가2P당[사이즈] × ⌈(page−24)/2⌉ )
--
-- 세트 2-레이어 설계(evaluate_set_price = 구성원별 qty 가격 + 부모 세트공식):
--   ① 부모 세트공식 PRF_PHOTOBOOK_FIXED ← COMP_PHOTOBOOK_BASE
--        기본24P[siz_cd × opt_cd(표지타입)] × 부수. 단가행 11(10x10 소프트=권위빈칸 제외).
--        표지타입 opt_cd = 라이브 컨벤션 OPV_NNNNNN (하드484/레더하드485/소프트486).
--   ② 내지 구성원 PRD_000101 ← PRF_PHOTOBOOK_INNER ← COMP_PHOTOBOOK_PAGE
--        추가2P당[siz_cd] × 내지qty. 단가행 4(사이즈별·표지타입 무관). prc_typ .01(unit×qty).
--        ★위젯/시뮬레이터 계약(OI-PAGE): 내지 구성원 qty_mode='manual',
--          qty = 부수 × ⌈(page−24)/2⌉ (page≤24 → 0 → 내지 기여 0=기본만). selections={siz_cd}.
--
-- ★OI-3(표지타입 위젯연결): 시뮬레이터 opt_cd 드롭다운은 TPrdProductOptions(prd_cd=100)에서
--   채우는데 현재 0개 → 단가행 적재 후 "표지타입" 옵션그룹+OPV_000484~486 등록(dbmap CPQ) 선결.
--   (미등록 시 표지타입 미선택→11행 동시매칭 ERR_AMBIGUOUS.)
--
-- DRY-RUN(photobook-price-260629-dryrun.sql) 선검증: PK충돌0·base11·page4·멱등(2차 0행).
-- 수기검산(설계서 §검산): A4하드 page50 copies1 = base16000 + 600×13 = 23,800 = 권위 일치.
--
-- ★실 simulate_set 가격검증 = COMMIT + OI-3 옵션그룹 등록 후 사람이 수행:
--   sim.simulate_set('PRD_000100',
--     members=[{'sub_prd_cd':'PRD_000101','qty_mode':'manual',
--               'qty': copies*ceil((page-24)/2), 'siz_cd':'SIZ_000172'}],
--     set_selections={'siz_cd':'SIZ_000172','opt_cd':'OPV_000484'}, copies=1)
--   → page50: set_eval 16000 + 내지 7800 = final 23,800 기대.
-- =====================================================================

\set ON_ERROR_STOP on
BEGIN;

-- ① 부모 세트공식 ----------------------------------------------------
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_PHOTOBOOK_FIXED', '포토북 기본가(24P·사이즈/표지타입별)',
       '포토북 세트 부모공식. 기본24P × 부수. 페이지 추가가는 내지 구성원(PRF_PHOTOBOOK_INNER).',
       'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOBOOK_FIXED');

INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT 'COMP_PHOTOBOOK_BASE', '포토북 완제품가 기본24P(사이즈·표지타입별)',
       'PRC_COMPONENT_TYPE.06', 'PRICE_TYPE.01',
       '["siz_cd", "opt_cd", "min_qty"]'::jsonb, 'Y', 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_PHOTOBOOK_BASE');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_PHOTOBOOK_FIXED', 'COMP_PHOTOBOOK_BASE', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_PHOTOBOOK_FIXED' AND comp_cd='COMP_PHOTOBOOK_BASE');

-- ② 내지 구성원 페이지 공식 (★신규·추가2P당) ------------------------
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_PHOTOBOOK_INNER', '포토북 내지 추가페이지가(2P당·사이즈별)',
       '포토북 내지 구성원(101) 공식. 추가2P당[사이즈] × 내지qty(=부수×⌈(page−24)/2⌉).',
       'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOBOOK_INNER');

INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT 'COMP_PHOTOBOOK_PAGE', '포토북 추가2P당(사이즈별)',
       'PRC_COMPONENT_TYPE.06', 'PRICE_TYPE.01',
       '["siz_cd", "min_qty"]'::jsonb, 'Y', 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_PHOTOBOOK_PAGE');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_PHOTOBOOK_INNER', 'COMP_PHOTOBOOK_PAGE', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_PHOTOBOOK_INNER' AND comp_cd='COMP_PHOTOBOOK_PAGE');

-- 시퀀스 동기화(stale 가드) → 단가행 IDENTITY 자동채번
SELECT setval('public.t_prc_component_prices_comp_price_id_seq',
              (SELECT MAX(comp_price_id) FROM t_prc_component_prices), true);

-- ①-단가행: 기본24P 11행 (권위 verbatim·10x10 소프트=빈칸 제외)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, opt_cd, min_qty, unit_price, note, reg_dt)
SELECT v.comp_cd, v.apply_ymd, v.siz_cd, v.opt_cd, v.min_qty, v.unit_price, v.note, now()
FROM (VALUES
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000269','OPV_000484',1, 15000.00, '8x8 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000269','OPV_000485',1, 23000.00, '8x8 레더하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000269','OPV_000486',1, 12000.00, '8x8 소프트커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000274','OPV_000484',1, 22000.00, '10x10 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000274','OPV_000485',1, 32000.00, '10x10 레더하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000170','OPV_000484',1, 12000.00, 'A5 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000170','OPV_000485',1, 19000.00, 'A5 레더하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000170','OPV_000486',1, 10000.00, 'A5 소프트커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000172','OPV_000484',1, 16000.00, 'A4 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000172','OPV_000485',1, 26000.00, 'A4 레더하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000172','OPV_000486',1, 13000.00, 'A4 소프트커버 기본24P')
) AS v(comp_cd, apply_ymd, siz_cd, opt_cd, min_qty, unit_price, note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices cp
  WHERE cp.comp_cd=v.comp_cd AND cp.apply_ymd=v.apply_ymd
    AND cp.siz_cd=v.siz_cd AND cp.opt_cd=v.opt_cd AND cp.min_qty=v.min_qty);

-- ②-단가행: 추가2P당 4행 (권위 verbatim·사이즈별·표지타입 무관)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, min_qty, unit_price, note, reg_dt)
SELECT v.comp_cd, v.apply_ymd, v.siz_cd, v.min_qty, v.unit_price, v.note, now()
FROM (VALUES
  ('COMP_PHOTOBOOK_PAGE','2026-06-06','SIZ_000269',1,  500.00, '8x8 추가2P당'),
  ('COMP_PHOTOBOOK_PAGE','2026-06-06','SIZ_000274',1, 1000.00, '10x10 추가2P당'),
  ('COMP_PHOTOBOOK_PAGE','2026-06-06','SIZ_000170',1,  300.00, 'A5 추가2P당'),
  ('COMP_PHOTOBOOK_PAGE','2026-06-06','SIZ_000172',1,  600.00, 'A4 추가2P당')
) AS v(comp_cd, apply_ymd, siz_cd, min_qty, unit_price, note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices cp
  WHERE cp.comp_cd=v.comp_cd AND cp.apply_ymd=v.apply_ymd
    AND cp.siz_cd=v.siz_cd AND cp.min_qty=v.min_qty AND cp.opt_cd IS NULL);

-- 바인딩: 부모(100)←FIXED · 내지(101)←INNER
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000100', 'PRF_PHOTOBOOK_FIXED', '2026-06-06',
       '포토북 세트 부모(기본24P). 페이지 추가가는 내지 구성원(PRF_PHOTOBOOK_INNER).', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas
  WHERE prd_cd='PRD_000100' AND frm_cd='PRF_PHOTOBOOK_FIXED' AND apply_bgn_ymd='2026-06-06');

INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000101', 'PRF_PHOTOBOOK_INNER', '2026-06-06',
       '포토북 내지 구성원. 추가2P당×내지qty(=부수×페이지스텝·위젯 계약).', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas
  WHERE prd_cd='PRD_000101' AND frm_cd='PRF_PHOTOBOOK_INNER' AND apply_bgn_ymd='2026-06-06');

-- 검증 SELECT (COMMIT 전 눈으로 확인 — 기대값 우측)
SELECT 'FIXED공식' t, count(*) n FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOBOOK_FIXED'  -- 1
UNION ALL SELECT 'INNER공식', count(*) FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOBOOK_INNER'  -- 1
UNION ALL SELECT 'BASE구성요소', count(*) FROM t_prc_price_components WHERE comp_cd='COMP_PHOTOBOOK_BASE'  -- 1
UNION ALL SELECT 'PAGE구성요소', count(*) FROM t_prc_price_components WHERE comp_cd='COMP_PHOTOBOOK_PAGE'  -- 1
UNION ALL SELECT 'BASE단가행', count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PHOTOBOOK_BASE'  -- 11
UNION ALL SELECT 'PAGE단가행', count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PHOTOBOOK_PAGE'  -- 4
UNION ALL SELECT '바인딩', count(*) FROM t_prd_product_price_formulas
  WHERE frm_cd IN ('PRF_PHOTOBOOK_FIXED','PRF_PHOTOBOOK_INNER') AND prd_cd IN ('PRD_000100','PRD_000101');  -- 2

-- ★★★ 위 검증이 기대대로(1/1/1/1/11/4/2)면 아래 COMMIT 주석 해제. 아니면 ROLLBACK. ★★★
-- COMMIT;
ROLLBACK;   -- 기본값 = 안전(롤백). 사람이 COMMIT 으로 바꿔 실행.


-- =====================================================================
-- UNDO (COMMIT 후 되돌리기) — FK 역위상.
-- =====================================================================
-- BEGIN;
-- DELETE FROM t_prd_product_price_formulas WHERE frm_cd IN ('PRF_PHOTOBOOK_FIXED','PRF_PHOTOBOOK_INNER') AND prd_cd IN ('PRD_000100','PRD_000101') AND apply_bgn_ymd='2026-06-06';
-- DELETE FROM t_prc_component_prices WHERE comp_cd IN ('COMP_PHOTOBOOK_BASE','COMP_PHOTOBOOK_PAGE');
-- DELETE FROM t_prc_formula_components WHERE frm_cd IN ('PRF_PHOTOBOOK_FIXED','PRF_PHOTOBOOK_INNER');
-- DELETE FROM t_prc_price_components WHERE comp_cd IN ('COMP_PHOTOBOOK_BASE','COMP_PHOTOBOOK_PAGE');
-- DELETE FROM t_prc_price_formulas WHERE frm_cd IN ('PRF_PHOTOBOOK_FIXED','PRF_PHOTOBOOK_INNER');
-- -- COMMIT;
-- ROLLBACK;
