-- =====================================================================
-- load.sql — price-211 slice C1 (STICKER F4 + NAMECARD F5) 멱등 적재
--   설계 권위: mapping.md. 신규 component_prices 0행(기존 재사용·재적재 금지).
--   적재물: price_formulas 1 mint + formula_components 18 배선 + product_price_formulas 16 바인딩 = 35행.
--
--   [HARD] 본 파일은 BEGIN…COMMIT 트랜잭션으로 감싼 멱등 INSERT 만 포함.
--          실제 COMMIT 은 인간 승인(DRY-RUN 은 dryrun-plan.md 참조 — COMMIT→ROLLBACK 치환).
--          reg_dt/upd_dt OMIT → DEFAULT now() 발화(R5 reg_dt NOT NULL 함정 회피).
--          멱등: PK ON CONFLICT DO NOTHING (재실행 0행).
--   FK 위상정렬: price_formulas → formula_components → product_price_formulas.
--   부모 선존재(read-only 확인): COMP_NAMECARD_*(27), COMP_STK_PACK, PRF_STK_FIXED,
--          PRF_NAMECARD_FIXED, FRM_TYPE.02, PRD_* 16종.
-- =====================================================================
BEGIN;

-- ---------------------------------------------------------------------
-- [단계 1] t_prc_price_formulas — 신규 mint 1행 (스티커팩 세트가 전용 공식)
--   src: load/t_prc_price_formulas.csv
-- ---------------------------------------------------------------------
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_STK_PACK_FIXED', '스티커팩 세트 고정가', 'FRM_TYPE.02',
        '단순형: 스티커팩(54장 1세트) 세트 단가. COMP_STK_PACK 재사용(75x110·4000). price-sticker-l1 B07.', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- ---------------------------------------------------------------------
-- [단계 2] t_prc_formula_components — 배선 18행
--   NAMECARD: PRF_NAMECARD_FIXED 에 7무가격 상품 components wire (disp_seq 3~19, 기존 STD 1,2 뒤).
--   STICKER : PRF_STK_PACK_FIXED ← COMP_STK_PACK (disp_seq 1).
--   addtn_yn='Y' = round-5 STD 컨벤션(FRM_TYPE.02 단순형은 단가 lookup; 박명함 base+setup 은 실합산).
--   src: load/t_prc_formula_components.csv
-- ---------------------------------------------------------------------
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) VALUES
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_PEARL_S1',          3,  'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_PEARL_S2',          4,  'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_SHAPE_S1',          5,  'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_SHAPE_S2',          6,  'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_MINISHAPE_S1',      7,  'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_MINISHAPE_S2',      8,  'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_CLEAR_S1',          9,  'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_WHITE_S1W_NOCL',    10, 'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_WHITE_S1W_CL',      11, 'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_WHITE_S2W_NOCL',    12, 'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_WHITE_S2W_CL',      13, 'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_FOIL_S1_STD',       14, 'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_FOIL_S1_HOLO',      15, 'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_FOIL_S2_STD',       16, 'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_FOIL_S2_HOLO',      17, 'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_FOIL_SETUP_S1_STD', 18, 'Y'),
  ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_FOIL_SETUP_S2_STD', 19, 'Y'),
  ('PRF_STK_PACK_FIXED',  'COMP_STK_PACK',                  1,  'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ---------------------------------------------------------------------
-- [단계 3] t_prd_product_price_formulas — 바인딩 16행 (INSERTABLE)
--   apply_bgn_ymd = nullable 메모(표준 일자 채움). reg_dt/upd_dt OMIT.
--   src: load/t_prd_product_price_formulas.csv
-- ---------------------------------------------------------------------
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note) VALUES
  ('PRD_000058', 'PRF_STK_FIXED',      '2026-06-01', '반칼원형스티커 — 반칼규격 매트릭스(B01) 공유'),
  ('PRD_000059', 'PRF_STK_FIXED',      '2026-06-01', '반칼정사각스티커 — B01'),
  ('PRD_000060', 'PRF_STK_FIXED',      '2026-06-01', '반칼직사각스티커 — B01'),
  ('PRD_000061', 'PRF_STK_FIXED',      '2026-06-01', '반칼띠지스티커 — B01'),
  ('PRD_000062', 'PRF_STK_FIXED',      '2026-06-01', '반칼팬시스티커 — B01'),
  ('PRD_000063', 'PRF_STK_FIXED',      '2026-06-01', '반칼팬시투명스티커 — B01 투명/홀로그램 그룹가'),
  ('PRD_000054', 'PRF_STK_FIXED',      '2026-06-01', '반칼 자유형 홀로그램스티커 — B01 투명/홀로그램 그룹가'),
  ('PRD_000057', 'PRF_STK_FIXED',      '2026-06-01', '대형 자유형 스티커 — B04 대형완칼(400x600) 재사용'),
  ('PRD_000056', 'PRF_STK_FIXED',      '2026-06-01', '낱장 자유형 투명스티커 — B03 낱장완칼 투명 재사용'),
  ('PRD_000065', 'PRF_STK_PACK_FIXED', '2026-06-01', '스티커팩 — B07 세트가(COMP_STK_PACK)'),
  ('PRD_000034', 'PRF_NAMECARD_FIXED', '2026-06-01', '펄명함 — PEARL S1/S2(B04)'),
  ('PRD_000035', 'PRF_NAMECARD_FIXED', '2026-06-01', '모양명함 — SHAPE S1/S2(B07·90x50)'),
  ('PRD_000036', 'PRF_NAMECARD_FIXED', '2026-06-01', '미니모양명함 — MINISHAPE S1/S2(B08·50x50)'),
  ('PRD_000039', 'PRF_NAMECARD_FIXED', '2026-06-01', '투명명함 — CLEAR S1(B05·단면)'),
  ('PRD_000040', 'PRF_NAMECARD_FIXED', '2026-06-01', '화이트인쇄명함 — WHITE 4종(B06·큐리어스스킨)'),
  ('PRD_000037', 'PRF_NAMECARD_FIXED', '2026-06-01', '오리지널박명함 — FOIL base(.06)+SETUP(.05) 합산(B09)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- 신규 t_prc_component_prices 0행 (기존 단가 재사용 — 재적재 금지. load/t_prc_component_prices.csv 헤더만).

COMMIT;  -- DRY-RUN: 이 라인을 ROLLBACK; 으로 치환(dryrun-plan.md 참조). 실 COMMIT 은 인간 승인.
