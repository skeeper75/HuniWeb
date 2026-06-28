-- =====================================================================
-- 하드커버책자(PRD_000072) 표지+제본 합산가 — 세트 부모공식 (COMMIT 버전)
-- ★사용자 directive(이전사이트서 별도/합산 확인) 반영 = 합산(combined).
-- 이전사이트 pcode=40 하드커버무선 실측(2026-06-29·읽기전용):
--   표지종이 손님선택이나 가격 무관(백모220/아트300/몽블랑240 전부 동일) → 표지+제본=합산 고정가.
--   price_02(표지+제본) per-book 밴드: qty1=34,100 · qty100=796,900(/100=7,969). 라이브 재확인.
-- 모델: 단일 합산 comp(표지+제본·표지종이 무관) on 072 세트 부모공식. prc_typ .01(unit×copies).
--   set_eval qty=copies → 표지+제본 = per-book 밴드단가 × copies.
-- ★내지(PRD_000284 디지털인쇄 페이지가)는 별도 §18(포토북 내지 동형) — 본 SQL 범위 밖.
--   즉 이 COMMIT 후 072 set_eval=표지+제본만 산출(내지는 구성원 트랙 완결 후 종단).
-- 멱등(NOT EXISTS). 기본 ROLLBACK(검증). COMMIT은 주석 해제.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;

INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_HC_MUSEON_SET', '하드커버무선 표지+제본 합산가(세트 부모)',
       '하드커버책자 세트 부모공식. 표지+제본 합산(표지종이 무관·이전사이트 실측) × 부수. 내지=구성원 별도.',
       'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_HC_MUSEON_SET');

INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT 'COMP_HC_MUSEON_COVERBIND', '하드커버무선 표지+제본 합산(권당)',
       'PRC_COMPONENT_TYPE.06', 'PRICE_TYPE.01', '["min_qty"]'::jsonb, 'Y', 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_HC_MUSEON_COVERBIND');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_HC_MUSEON_SET', 'COMP_HC_MUSEON_COVERBIND', 1, 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_HC_MUSEON_SET' AND comp_cd='COMP_HC_MUSEON_COVERBIND');

SELECT setval('public.t_prc_component_prices_comp_price_id_seq',
              (SELECT MAX(comp_price_id) FROM t_prc_component_prices), true);

-- 표지+제본 합산 per-book 밴드 6 (이전사이트 price_02 실측·verbatim)
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, reg_dt)
SELECT v.comp_cd, v.apply_ymd, v.min_qty, v.unit_price, v.note, now()
FROM (VALUES
  ('COMP_HC_MUSEON_COVERBIND','2026-06-06',   1, 34100.00, '표지+제본 권당(밴드1)'),
  ('COMP_HC_MUSEON_COVERBIND','2026-06-06',   4, 22425.00, '표지+제본 권당(밴드4)'),
  ('COMP_HC_MUSEON_COVERBIND','2026-06-06',  10, 15910.00, '표지+제본 권당(밴드10)'),
  ('COMP_HC_MUSEON_COVERBIND','2026-06-06',  50, 10170.00, '표지+제본 권당(밴드50)'),
  ('COMP_HC_MUSEON_COVERBIND','2026-06-06', 100,  7969.00, '표지+제본 권당(밴드100)'),
  ('COMP_HC_MUSEON_COVERBIND','2026-06-06',1000,  6368.40, '표지+제본 권당(밴드1000)')
) AS v(comp_cd, apply_ymd, min_qty, unit_price, note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices cp
  WHERE cp.comp_cd=v.comp_cd AND cp.apply_ymd=v.apply_ymd AND cp.min_qty=v.min_qty
    AND cp.siz_cd IS NULL AND cp.opt_cd IS NULL);

INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000072', 'PRF_HC_MUSEON_SET', '2026-06-06',
       '하드커버책자 표지+제본 합산(이전사이트 실측). 내지는 구성원(284 §18) 별도 종단.', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas
  WHERE prd_cd='PRD_000072' AND frm_cd='PRF_HC_MUSEON_SET' AND apply_bgn_ymd='2026-06-06');

SELECT 'formula' t, count(*) n FROM t_prc_price_formulas WHERE frm_cd='PRF_HC_MUSEON_SET'
UNION ALL SELECT 'component', count(*) FROM t_prc_price_components WHERE comp_cd='COMP_HC_MUSEON_COVERBIND'
UNION ALL SELECT 'wiring', count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_HC_MUSEON_SET'
UNION ALL SELECT 'prices', count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_HC_MUSEON_COVERBIND'
UNION ALL SELECT 'binding', count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000072' AND frm_cd='PRF_HC_MUSEON_SET';
-- 기대: 1/1/1/6/1

-- COMMIT;
ROLLBACK;
-- UNDO: DELETE binding→prices→wiring→component→formula (FK 역위상).
