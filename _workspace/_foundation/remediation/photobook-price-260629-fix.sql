-- =====================================================================
-- 포토북(PRD_000100) 완제품가 가격공식 — COMMIT 버전 (★사람 검토용)
--
-- ★★★ 이 파일을 절대 자동 실행하지 마라. 사람이 검토 후 수동 실행. ★★★
--
-- 094 엽서북(PRF_PCB_FIXED) 동형. 표지타입 = opt_cd 차원(FK 없음·자유 코드값).
-- page 추가가 = 미반영(BLOCKED·열린 이슈·저청구 위험 — 설계서 §page-model 참조).
-- 기본24P만 정확 적재. 단가 = 권위 가격표(260610) verbatim.
--
-- 신규 생성물: 공식 1 · 구성요소 1 · 배선 1 · 단가행 11 · 바인딩 1.
-- 10x10 소프트커버 = 권위 빈칸 → 단가행 생성 안 함(미제공·BLOCKED).
--
-- DRY-RUN(photobook-price-260629-dryrun.sql) 검증 완료:
--   PK충돌 0 · 단가행 11행 · 멱등(2차 재실행 0행 추가).
-- 가격 정합 = 권위 ↔ 단가행 수기 대조 11/11 일치(설계서 §검산표).
--
-- ★실 simulate_set 가격검증은 COMMIT 후 사람이 수행:
--   H.HuniSim().simulate_set('PRD_000100', members=[표지구성원 택1...],
--                            set_selections={'siz_cd':'SIZ_000172','opt_cd':'CVR_HARD'},
--                            copies=1) → set_eval contribution = 16000 기대.
-- =====================================================================

\set ON_ERROR_STOP on
BEGIN;

-- 1. 가격공식
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_PHOTOBOOK_FIXED',
       '포토북 사이즈/표지타입별 기본가(24P)',
       '포토북 완제품가. 사이즈·표지타입별 기본24P 단가 × 부수. page추가가 미반영(열린 이슈).',
       'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOBOOK_FIXED');

-- 2. 가격구성요소 (comp_typ .06 / prc_typ .01 단가형 / use_dims=siz_cd,opt_cd,min_qty)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT 'COMP_PHOTOBOOK_BASE',
       '포토북 완제품가 기본24P(사이즈·표지타입별)',
       'PRC_COMPONENT_TYPE.06', 'PRICE_TYPE.01',
       '["siz_cd", "opt_cd", "min_qty"]'::jsonb, 'Y', 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_PHOTOBOOK_BASE');

-- 3. 공식↔구성요소 배선
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_PHOTOBOOK_FIXED', 'COMP_PHOTOBOOK_BASE', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_PHOTOBOOK_FIXED' AND comp_cd='COMP_PHOTOBOOK_BASE');

-- 4. IDENTITY 시퀀스 동기화 (stale 가드 — last_value < MAX 함정 방지).
--    setval 은 트랜잭션 롤백 영향을 안 받지만, 정상 채번을 위해 선행.
SELECT setval('public.t_prc_component_prices_comp_price_id_seq',
              (SELECT MAX(comp_price_id) FROM t_prc_component_prices), true);

-- 4b. 단가행 11개 (권위 verbatim). comp_price_id = IDENTITY 자동채번(미명시).
--     10x10 소프트커버 = 권위 빈칸 → 행 없음(미제공·BLOCKED).
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, opt_cd, min_qty, unit_price, note, reg_dt)
SELECT v.comp_cd, v.apply_ymd, v.siz_cd, v.opt_cd, v.min_qty, v.unit_price, v.note, now()
FROM (VALUES
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000269','CVR_HARD',  1, 15000.00, '8x8 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000269','CVR_LHARD', 1, 23000.00, '8x8 레더하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000269','CVR_SOFT',  1, 12000.00, '8x8 소프트커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000274','CVR_HARD',  1, 22000.00, '10x10 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000274','CVR_LHARD', 1, 32000.00, '10x10 레더하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000170','CVR_HARD',  1, 12000.00, 'A5 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000170','CVR_LHARD', 1, 19000.00, 'A5 레더하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000170','CVR_SOFT',  1, 10000.00, 'A5 소프트커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000172','CVR_HARD',  1, 16000.00, 'A4 하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000172','CVR_LHARD', 1, 26000.00, 'A4 레더하드커버 기본24P'),
  ('COMP_PHOTOBOOK_BASE','2026-06-06','SIZ_000172','CVR_SOFT',  1, 13000.00, 'A4 소프트커버 기본24P')
) AS v(comp_cd, apply_ymd, siz_cd, opt_cd, min_qty, unit_price, note)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
  WHERE cp.comp_cd=v.comp_cd AND cp.apply_ymd=v.apply_ymd
    AND cp.siz_cd=v.siz_cd AND cp.opt_cd=v.opt_cd AND cp.min_qty=v.min_qty);

-- 5. 상품↔공식 바인딩
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000100', 'PRF_PHOTOBOOK_FIXED', '2026-06-06',
       '포토북 완제품가(셋트 set_eval). 기본24P만 정확·page추가가 미반영(저청구·열린 이슈).',
       now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas
  WHERE prd_cd='PRD_000100' AND apply_bgn_ymd='2026-06-06');

-- 검증 SELECT (COMMIT 전 눈으로 확인)
SELECT 'formula' t, count(*) n FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOBOOK_FIXED'
UNION ALL SELECT 'component', count(*) FROM t_prc_price_components WHERE comp_cd='COMP_PHOTOBOOK_BASE'
UNION ALL SELECT 'wiring', count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_PHOTOBOOK_FIXED'
UNION ALL SELECT 'dprice', count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PHOTOBOOK_BASE'
UNION ALL SELECT 'binding', count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000100' AND frm_cd='PRF_PHOTOBOOK_FIXED';
-- 기대: formula 1 / component 1 / wiring 1 / dprice 11 / binding 1

-- ★★★ 위 검증이 기대대로면 아래 주석을 풀고 COMMIT. 아니면 ROLLBACK. ★★★
-- COMMIT;
ROLLBACK;   -- 기본값 = 안전(롤백). 사람이 COMMIT 으로 바꿔 실행.


-- =====================================================================
-- UNDO (적용 후 되돌리기) — 위 INSERT 가 COMMIT 된 뒤에만 사용.
--   삭제 순서 = FK 역위상(바인딩 → 단가행 → 배선 → 구성요소 → 공식).
-- =====================================================================
-- BEGIN;
-- DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000100' AND frm_cd='PRF_PHOTOBOOK_FIXED' AND apply_bgn_ymd='2026-06-06';
-- DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_PHOTOBOOK_BASE';
-- DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_PHOTOBOOK_FIXED' AND comp_cd='COMP_PHOTOBOOK_BASE';
-- DELETE FROM t_prc_price_components WHERE comp_cd='COMP_PHOTOBOOK_BASE';
-- DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOBOOK_FIXED';
-- -- COMMIT;
-- ROLLBACK;
