-- =====================================================================
-- 포토북(PRD_000100) 완제품가 가격공식 설계 — DRY-RUN (BEGIN/ROLLBACK)
-- 094 엽서북(PRF_PCB_FIXED) 동형. 표지타입 = opt_cd 차원(라이브 컨벤션 OPV_NNNNNN).
--   하드커버=OPV_000484 / 레더하드커버=OPV_000485 / 소프트커버=OPV_000486
--   (전역 OPV MAX=483 → MAX+1 채번. opt_cd는 component_prices에 FK 없음.
--    단, t_prd_product_options 옵션값 코드 네임스페이스라 OPV 표준 준수.)
-- ★OI-3: 시뮬레이터/위젯이 표지타입을 set_selections.opt_cd 로 보내려면 PRD_000100 에
--   표지타입 옵션그룹(OPV_000484~486) 등록 필요(dbmap CPQ 트랙·미해결). 단가행만으론 부족.
-- page 추가가 = 미반영(BLOCKED·열린 이슈). 기본24P만 정확 적재.
--
-- 안전: 이 파일은 BEGIN ... ROLLBACK 으로 끝나 실제 변경 0.
--       "행이 정확히 생성됨 + PK충돌 0" 만 검증한다.
-- 가격 정합은 권위 매트릭스 ↔ 단가행 수기 대조(설계 문서)로 입증.
-- =====================================================================

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------
-- 1. 가격공식 (t_prc_price_formulas)  PK=frm_cd
--    멱등: NOT EXISTS 가드.
-- ---------------------------------------------------------------------
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_PHOTOBOOK_FIXED',
       '포토북 사이즈/표지타입별 기본가(24P)',
       '포토북 완제품가. 사이즈·표지타입별 기본24P 단가 × 부수. page추가가 미반영(열린 이슈).',
       'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOBOOK_FIXED');

-- ---------------------------------------------------------------------
-- 2. 가격구성요소 (t_prc_price_components)  PK=comp_cd
--    comp_typ=.06(094 완제품가 동일), prc_typ=.01(단가형 → unit_price×copies).
--    use_dims = siz_cd + opt_cd(표지타입) + min_qty(수량밴드, 단일밴드).
-- ---------------------------------------------------------------------
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT 'COMP_PHOTOBOOK_BASE',
       '포토북 완제품가 기본24P(사이즈·표지타입별)',
       'PRC_COMPONENT_TYPE.06',
       'PRICE_TYPE.01',
       '["siz_cd", "opt_cd", "min_qty"]'::jsonb,
       'Y', 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_PHOTOBOOK_BASE');

-- ---------------------------------------------------------------------
-- 3. 공식↔구성요소 배선 (t_prc_formula_components)  PK=(frm_cd,comp_cd)
--    addtn_yn=Y (094 동형). 단일 구성요소.
-- ---------------------------------------------------------------------
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_PHOTOBOOK_FIXED', 'COMP_PHOTOBOOK_BASE', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_PHOTOBOOK_FIXED' AND comp_cd='COMP_PHOTOBOOK_BASE');

-- ---------------------------------------------------------------------
-- 4. 단가행 (t_prc_component_prices)  PK=comp_price_id(IDENTITY)
--    ★DRY-RUN 주의: IDENTITY 시퀀스가 stale(last_value 40329 < MAX 40332).
--      DRY-RUN에서는 시퀀스를 건드리지 않으려고 comp_price_id를 명시 부여
--      (MAX+row_number)한다. 이는 PK충돌 0 + 행 정확 생성 검증 목적.
--      ★fix.sql(COMMIT)에서는 setval 동기화 후 IDENTITY 자동채번이 정석.
--    11개 조합(권위 verbatim). 10x10 소프트커버는 권위 빈칸 → 생성 안 함(BLOCKED).
--    opt_cd 코드값: OPV_000484(하드)/OPV_000485(레더하드)/OPV_000486(소프트) — 라이브 OPV 컨벤션.
--    apply_ymd='2026-06-06'(094 정합), min_qty=1(단일 수량밴드·copies 1 이상).
--    unit_price = 권위 기본24P. prc_typ .01 → engine: unit_price × copies.
--    멱등: (comp_cd,siz_cd,opt_cd,min_qty,apply_ymd) 동일행 NOT EXISTS 가드.
-- ---------------------------------------------------------------------
INSERT INTO t_prc_component_prices
  (comp_price_id, comp_cd, apply_ymd, siz_cd, opt_cd, min_qty, unit_price, note, reg_dt)
SELECT (SELECT MAX(comp_price_id) FROM t_prc_component_prices)
         + row_number() OVER (ORDER BY v.siz_cd, v.opt_cd),
       v.comp_cd, v.apply_ymd, v.siz_cd, v.opt_cd, v.min_qty, v.unit_price, v.note, now()
FROM (VALUES
  -- 8x8 (SIZ_000269)
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000269','OPV_000484', 1, 15000.00, '8x8 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000269','OPV_000485', 1, 23000.00, '8x8 레더하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000269','OPV_000486', 1, 12000.00, '8x8 소프트커버 기본24P'),
  -- 10x10 (SIZ_000274) — 소프트커버 권위 빈칸 → 행 없음
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000274','OPV_000484', 1, 22000.00, '10x10 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000274','OPV_000485', 1, 32000.00, '10x10 레더하드커버 기본24P'),
  -- A5 (SIZ_000170)
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000170','OPV_000484', 1, 12000.00, 'A5 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000170','OPV_000485', 1, 19000.00, 'A5 레더하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000170','OPV_000486', 1, 10000.00, 'A5 소프트커버 기본24P'),
  -- A4 (SIZ_000172)
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000172','OPV_000484', 1, 16000.00, 'A4 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000172','OPV_000485', 1, 26000.00, 'A4 레더하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000172','OPV_000486', 1, 13000.00, 'A4 소프트커버 기본24P')
) AS v(comp_cd, apply_ymd, siz_cd, opt_cd, min_qty, unit_price, note)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
  WHERE cp.comp_cd=v.comp_cd AND cp.apply_ymd=v.apply_ymd
    AND cp.siz_cd=v.siz_cd AND cp.opt_cd=v.opt_cd
    AND cp.min_qty=v.min_qty);

-- ---------------------------------------------------------------------
-- 5. 상품↔공식 바인딩 (t_prd_product_price_formulas)  PK=(prd_cd,apply_bgn_ymd)
-- ---------------------------------------------------------------------
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000100', 'PRF_PHOTOBOOK_FIXED', '2026-06-06',
       '포토북 완제품가(셋트 set_eval). 기본24P만 정확·page추가가 미반영(저청구·열린 이슈).',
       now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas
  WHERE prd_cd='PRD_000100' AND apply_bgn_ymd='2026-06-06');

-- =====================================================================
-- 검증 SELECT — 행수 + PK충돌 0 확인
-- =====================================================================
\echo '--- 1) 공식 (기대 1행) ---'
SELECT frm_cd, frm_nm, use_yn FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOBOOK_FIXED';

\echo '--- 2) 구성요소 (기대 1행, use_dims=siz_cd/opt_cd/min_qty) ---'
SELECT comp_cd, comp_typ_cd, prc_typ_cd, use_dims FROM t_prc_price_components WHERE comp_cd='COMP_PHOTOBOOK_BASE';

\echo '--- 3) 배선 (기대 1행) ---'
SELECT frm_cd, comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components WHERE frm_cd='PRF_PHOTOBOOK_FIXED';

\echo '--- 4) 단가행 (기대 11행, 권위 verbatim) ---'
SELECT siz_cd, opt_cd, min_qty, unit_price, note
FROM t_prc_component_prices WHERE comp_cd='COMP_PHOTOBOOK_BASE'
ORDER BY siz_cd, opt_cd;
\echo '--- 단가행 카운트 (기대 11) ---'
SELECT count(*) AS dprice_rows FROM t_prc_component_prices WHERE comp_cd='COMP_PHOTOBOOK_BASE';

\echo '--- 5) 바인딩 (기대 1행) ---'
SELECT prd_cd, frm_cd, apply_bgn_ymd, note FROM t_prd_product_price_formulas
WHERE prd_cd='PRD_000100' AND frm_cd='PRF_PHOTOBOOK_FIXED';

\echo '--- PK충돌 가드 검증: 멱등 재실행 시 추가 0행이어야 함(NOT EXISTS) ---'
-- (재실행 동등성은 fix.sql/COMMIT 후 사람이 2회 실행으로 확인)

ROLLBACK;
\echo '=== ROLLBACK 완료 — 실제 변경 0 ==='
