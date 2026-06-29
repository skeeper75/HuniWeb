-- =====================================================================
-- 문구(가격포함) 8 단품 가격공식 DRY-RUN (260629)
-- 설계: stationery-price-design-260629.md · 권위: stationery-l1.csv verbatim
-- 모델: 고정 per-unit 단가형(.06/.01) + siz_cd 차원 + DSC_STAT_QTY(기존)
-- [HARD] BEGIN/ROLLBACK — 실 COMMIT 아님. 단가 verbatim(날조0). 멱등(NOT EXISTS 가드).
--   comp_price_id = IDENTITY 자동생성(명시 안 함·setval 충돌 회피).
--   실행: psql -f stationery-price-260629-dryrun.sql  (종결자 ROLLBACK 확인)
-- =====================================================================
BEGIN;

-- ── 1) 가격공식 (8) ──────────────────────────────────────────────────
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, reg_dt)
SELECT v.frm_cd, v.frm_nm, 'Y', now()
FROM (VALUES
  ('PRF_STN_DIARY_SOFT',   '만년다이어리(소프트커버) 완제품가'),
  ('PRF_STN_DIARY_HARD',   '만년다이어리(하드커버) 완제품가'),
  ('PRF_STN_DIARY_LHARD',  '만년다이어리(레더하드커버) 완제품가'),
  ('PRF_STN_DIARY_LSOFT',  '만년다이어리(레더소프트커버) 완제품가'),
  ('PRF_STN_MONTHLY',      '먼슬리플래너 완제품가'),
  ('PRF_STN_SPRINGNOTE',   '스프링노트 완제품가'),
  ('PRF_STN_SPRINGNOTEBK', '스프링수첩 완제품가'),
  ('PRF_STN_MEMOPAD',      '메모패드 완제품가'),
  ('PRF_STN_JUNGCHEOL',    '중철노트 완제품가')
) AS v(frm_cd, frm_nm)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd = v.frm_cd);

-- ── 2) 가격구성요소 (8) · comp_typ .06(완제품가) · prc_typ .01(단가형) ──
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn, reg_dt)
SELECT v.comp_cd, v.comp_nm, 'PRC_COMPONENT_TYPE.06', 'PRICE_TYPE.01',
       '["siz_cd", "min_qty"]'::jsonb, 'Y', 'N', now()
FROM (VALUES
  ('COMP_STN_DIARY_SOFT',   '만년다이어리(소프트커버) 완제품가'),
  ('COMP_STN_DIARY_HARD',   '만년다이어리(하드커버) 완제품가'),
  ('COMP_STN_DIARY_LHARD',  '만년다이어리(레더하드커버) 완제품가'),
  ('COMP_STN_DIARY_LSOFT',  '만년다이어리(레더소프트커버) 완제품가'),
  ('COMP_STN_MONTHLY',      '먼슬리플래너 완제품가'),
  ('COMP_STN_SPRINGNOTE',   '스프링노트 완제품가'),
  ('COMP_STN_SPRINGNOTEBK', '스프링수첩 완제품가'),
  ('COMP_STN_MEMOPAD',      '메모패드 완제품가'),
  ('COMP_STN_JUNGCHEOL',    '중철노트 완제품가')
) AS v(comp_cd, comp_nm)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components c WHERE c.comp_cd = v.comp_cd);

-- ── 3) 공식↔구성요소 배선 (8) · disp_seq 1 · addtn_yn Y ────────────────
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT v.frm_cd, v.comp_cd, 1, 'Y', now()
FROM (VALUES
  ('PRF_STN_DIARY_SOFT',   'COMP_STN_DIARY_SOFT'),
  ('PRF_STN_DIARY_HARD',   'COMP_STN_DIARY_HARD'),
  ('PRF_STN_DIARY_LHARD',  'COMP_STN_DIARY_LHARD'),
  ('PRF_STN_DIARY_LSOFT',  'COMP_STN_DIARY_LSOFT'),
  ('PRF_STN_MONTHLY',      'COMP_STN_MONTHLY'),
  ('PRF_STN_SPRINGNOTE',   'COMP_STN_SPRINGNOTE'),
  ('PRF_STN_SPRINGNOTEBK', 'COMP_STN_SPRINGNOTEBK'),
  ('PRF_STN_MEMOPAD',      'COMP_STN_MEMOPAD'),
  ('PRF_STN_JUNGCHEOL',    'COMP_STN_JUNGCHEOL')
) AS v(frm_cd, comp_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components fc
  WHERE fc.frm_cd = v.frm_cd AND fc.comp_cd = v.comp_cd);

-- ── 4) 단가행 (9) · apply_ymd 2026-06-01 · min_qty=1 · 단가 verbatim ────
--      comp_price_id = IDENTITY 자동(명시 안 함). 단가형 .01 → unit_price × qty.
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, min_qty, unit_price, note, reg_dt)
SELECT v.comp_cd, '2026-06-01', v.siz_cd, 1, v.unit_price, v.note, now()
FROM (VALUES
  ('COMP_STN_DIARY_SOFT',   'SIZ_000375',  9000.00, '만년다이어리(소프트커버)/130x190'),
  ('COMP_STN_DIARY_HARD',   'SIZ_000375', 12000.00, '만년다이어리(하드커버)/130x190'),
  ('COMP_STN_DIARY_LHARD',  'SIZ_000375', 15000.00, '만년다이어리(레더하드커버)/130x190'),
  ('COMP_STN_DIARY_LSOFT',  'SIZ_000375', 15000.00, '만년다이어리(레더소프트커버)/130x190'),
  ('COMP_STN_MONTHLY',      'SIZ_000170', 12000.00, '먼슬리플래너/A5 148x210'),
  ('COMP_STN_SPRINGNOTE',   'SIZ_000170',  4500.00, '스프링노트/A5 148x210'),
  ('COMP_STN_SPRINGNOTEBK', 'SIZ_000377',  3000.00, '스프링수첩/90x145'),
  ('COMP_STN_MEMOPAD',      'SIZ_000379',  5000.00, '메모패드/144x206'),
  ('COMP_STN_MEMOPAD',      'SIZ_000380',  6000.00, '메모패드/B5 182x257'),
  ('COMP_STN_JUNGCHEOL',    'SIZ_000196',  2500.00, '중철노트/A6 105x148')
) AS v(comp_cd, siz_cd, unit_price, note)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
  WHERE cp.comp_cd = v.comp_cd AND cp.apply_ymd = '2026-06-01'
    AND cp.siz_cd = v.siz_cd AND cp.min_qty = 1);

-- ── 5) 상품↔공식 바인딩 (8) · apply_bgn_ymd 2026-06-06 ─────────────────
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, reg_dt)
SELECT v.prd_cd, v.frm_cd, '2026-06-06', now()
FROM (VALUES
  ('PRD_000172', 'PRF_STN_DIARY_SOFT'),
  ('PRD_000173', 'PRF_STN_DIARY_HARD'),
  ('PRD_000174', 'PRF_STN_DIARY_LHARD'),
  ('PRD_000175', 'PRF_STN_DIARY_LSOFT'),
  ('PRD_000176', 'PRF_STN_MONTHLY'),
  ('PRD_000177', 'PRF_STN_SPRINGNOTE'),
  ('PRD_000178', 'PRF_STN_SPRINGNOTEBK'),
  ('PRD_000179', 'PRF_STN_MEMOPAD'),
  ('PRD_000181', 'PRF_STN_JUNGCHEOL')
) AS v(prd_cd, frm_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas b
  WHERE b.prd_cd = v.prd_cd AND b.frm_cd = v.frm_cd);

-- ── 검증 SELECT (기대: 공식8·구성요소8·배선8·단가행9·바인딩8) ──────────
SELECT 'formulas'    AS what, count(*) FROM t_prc_price_formulas      WHERE frm_cd LIKE 'PRF_STN_%';
SELECT 'components'  AS what, count(*) FROM t_prc_price_components     WHERE comp_cd LIKE 'COMP_STN_%';
SELECT 'wirings'     AS what, count(*) FROM t_prc_formula_components   WHERE frm_cd LIKE 'PRF_STN_%';
SELECT 'price_rows'  AS what, count(*) FROM t_prc_component_prices     WHERE comp_cd LIKE 'COMP_STN_%';
SELECT 'bindings'    AS what, count(*) FROM t_prd_product_price_formulas
                              WHERE frm_cd LIKE 'PRF_STN_%';
-- 단가행 verbatim 확인
SELECT comp_cd, siz_cd, min_qty, unit_price
FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_STN_%' ORDER BY comp_cd, siz_cd;
-- 수량할인 연결 현황(레더 174/175 미연결=Q1)
SELECT prd_cd, dsc_tbl_cd FROM t_prd_product_discount_tables
WHERE prd_cd IN ('PRD_000172','PRD_000173','PRD_000174','PRD_000175','PRD_000176',
                 'PRD_000177','PRD_000178','PRD_000179','PRD_000181') ORDER BY prd_cd;

-- ★COMMIT (인간 승인 2026-06-29). UNDO=stationery-price-260629-UNDO.sql.
COMMIT;
