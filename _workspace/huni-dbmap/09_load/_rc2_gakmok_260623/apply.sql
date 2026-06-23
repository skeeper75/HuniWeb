-- apply.sql — RC-2 각목(현수막 마감봉) 적재 (멱등·단일 트랜잭션·BEGIN…COMMIT)
-- ============================================================================
-- 대상 = 일반현수막(PRD_000138) 각목 옵션. 후보 C·보수안(§3.3 2 comp 유지).
-- 권위[HARD]: 인쇄상품 가격표 「포스터사인」 r249/250 verbatim(4000/8000)·라이브 4698/4700 verbatim.
-- 채택안 = 보수안(2 comp 유지·comp 병합 회피) — 직전 끈/큐방 CONFIRM-resolved 동형 패턴 계승.
--   끈(STRING)·큐방(QBANG)도 OPT_000004 택1 그룹의 별도 comp 유지+opt_cd 충전+각 바인딩으로 라이브 검증됨.
--   comp 병합(행 comp_cd 이관)은 가격사슬 구조 변경=불필요 리스크. always-add 해소는 opt_cd 충전만으로 양안 동등.
-- 멱등: UPDATE=IS DISTINCT FROM 가드 / INSERT=NOT EXISTS 가드.  단가 verbatim(날조 0).
-- apply_ymd='2026-06-01' 고정(4698/4700·끈/큐방 동일 — 분기 금지=이중계상 방지).
-- FK 위상: ①그룹 → ②옵션(신규/재라벨) → ③comp use_dims → ④단가행 opt_cd 충전 → ⑤좀비 use_yn=N → ⑥바인딩.
-- ★실 COMMIT은 dbm-validator R1~R6 GO + 인간 승인 후 hbd-load-executor. 빌더 COMMIT 금지.
-- ============================================================================
BEGIN;

-- ────────────────────────────────────────────────────────────────────────
-- STEP 1 — CPQ 옵션 그룹 선행 (t_prd_product_option_groups)
--   OPT_000063 "각목 부착 변"(SEL_TYPE.01 택1·0/1·mand N·disp_seq=3). 그룹 disp_seq MAX=2(del_yn=N 기준).
-- ────────────────────────────────────────────────────────────────────────
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000138', 'OPT_000063', '각목 부착 변', 'SEL_TYPE.01', 0, 1, 'N', 3, 'Y', 'N'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
   WHERE prd_cd='PRD_000138' AND opt_grp_cd='OPT_000063'
);

-- ────────────────────────────────────────────────────────────────────────
-- STEP 2 — CPQ 옵션 (t_prd_product_options)
-- ────────────────────────────────────────────────────────────────────────
-- 2a. 신규 세로/가로(부착 변) 2개 — 가격 영향 0·순수 생산정보 CPQ. (FK: OPT_000063 선행 = STEP1)
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000138', 'OPV_000432', 'OPT_000063', '세로변 부착(좌우)', 'N', 1, 'Y', 'N'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_cd='OPV_000432'
);
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000138', 'OPV_000433', 'OPT_000063', '가로변 부착(상하)', 'N', 2, 'Y', 'N'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000138' AND opt_cd='OPV_000433'
);

-- 2b. 재라벨 OPV_000015/016 — 가격표 r249/250 verbatim. 그룹/dflt/disp_seq/환원행 불변.
--     "각목(세로)+끈(4개) 추가" → "각목(900mm이하)+끈(4개) 추가"  (가격 판별 enum ≤900=4000)
UPDATE t_prd_product_options
   SET opt_nm = '각목(900mm이하)+끈(4개) 추가'
 WHERE prd_cd='PRD_000138' AND opt_cd='OPV_000015'
   AND opt_nm IS DISTINCT FROM '각목(900mm이하)+끈(4개) 추가';
--     "각목(가로)+끈(4개) 추가" → "각목(900mm 초과)+끈(4개) 추가"  (가격 판별 enum >900=8000)
UPDATE t_prd_product_options
   SET opt_nm = '각목(900mm 초과)+끈(4개) 추가'
 WHERE prd_cd='PRD_000138' AND opt_cd='OPV_000016'
   AND opt_nm IS DISTINCT FROM '각목(900mm 초과)+끈(4개) 추가';

-- ────────────────────────────────────────────────────────────────────────
-- STEP 3 — option_item 환원 (t_prd_product_option_items)
--   신규 환원행 0. OPV_000015/016 기존 환원행 유지(트리거 통과 상태·MAT_000338/070·PROC_000081).
--   세로/가로(432/433) 환원 = HOLD-G-ITEM(폴리모픽 차원에 "변 방향" 슬롯 부재·트리거 REJECT 회피).
--   → 본 STEP 적재 없음(의도적 생략·가격/견적 무영향).
-- ────────────────────────────────────────────────────────────────────────

-- ────────────────────────────────────────────────────────────────────────
-- STEP 4 — comp use_dims 충전 (t_prc_price_components) — always-add 해소 핵심
--   []→["opt_cd","opt_grp:OPT_000004"] (끈/큐방 동형 — 라이브 검증 패턴).
--   opt_cd 차원 도입 → 단가행 opt_cd가 selections와 매칭돼야만 가산 = 미선택 0가산 보장.
-- ────────────────────────────────────────────────────────────────────────
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "opt_grp:OPT_000004"]'::jsonb
 WHERE comp_cd = 'COMP_POPT_BNR_GAKMOK_STR_900_4_LE'
   AND use_dims IS DISTINCT FROM '["opt_cd", "opt_grp:OPT_000004"]'::jsonb;
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "opt_grp:OPT_000004"]'::jsonb
 WHERE comp_cd = 'COMP_POPT_BNR_GAKMOK_STR_900_4_GT'
   AND use_dims IS DISTINCT FROM '["opt_cd", "opt_grp:OPT_000004"]'::jsonb;

-- ────────────────────────────────────────────────────────────────────────
-- STEP 5 — 단가행 opt_cd 충전 (t_prc_component_prices) — 단가 verbatim 불변·행 이관 없음
--   4698(_LE·4000): opt_cd NULL → OPV_000015 (각목 900이하).  unit_price=4000 WHERE 가드(미변경).
--   4700(_GT·8000): opt_cd NULL → OPV_000016 (각목 900초과).  comp_cd 이관 없음(보수안).
-- ────────────────────────────────────────────────────────────────────────
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000015'
 WHERE comp_price_id = 4698
   AND comp_cd = 'COMP_POPT_BNR_GAKMOK_STR_900_4_LE'
   AND apply_ymd = '2026-06-01'
   AND unit_price = 4000.00
   AND opt_cd IS DISTINCT FROM 'OPV_000015';
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000016'
 WHERE comp_price_id = 4700
   AND comp_cd = 'COMP_POPT_BNR_GAKMOK_STR_900_4_GT'
   AND apply_ymd = '2026-06-01'
   AND unit_price = 8000.00
   AND opt_cd IS DISTINCT FROM 'OPV_000016';

-- ────────────────────────────────────────────────────────────────────────
-- STEP 6 — 좀비 차단 (t_prc_price_components)
--   부모 껍데기 _900_4(단가행 0건·빈 컨테이너) → use_yn=N. _LE/_GT는 use_yn=Y 유지(보수안·각각 가산 경로).
-- ────────────────────────────────────────────────────────────────────────
UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POPT_BNR_GAKMOK_STR_900_4'
   AND use_yn IS DISTINCT FROM 'N';

-- ────────────────────────────────────────────────────────────────────────
-- STEP 7 — 공식 바인딩 (t_prc_formula_components) — addtn_yn=Y·NOT EXISTS 가드
--   GAKMOK 바인딩 현행 0건. PRF_POSTER_BANNER_N 기존 disp_seq MAX=7 → _LE=8·_GT=9.
-- ────────────────────────────────────────────────────────────────────────
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_BANNER_N', 'COMP_POPT_BNR_GAKMOK_STR_900_4_LE', 8, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components
   WHERE frm_cd='PRF_POSTER_BANNER_N' AND comp_cd='COMP_POPT_BNR_GAKMOK_STR_900_4_LE'
);
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_BANNER_N', 'COMP_POPT_BNR_GAKMOK_STR_900_4_GT', 9, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components
   WHERE frm_cd='PRF_POSTER_BANNER_N' AND comp_cd='COMP_POPT_BNR_GAKMOK_STR_900_4_GT'
);

-- STEP 8(선택·HOLD) — 부착 변 종속 제약(JSONLogic)은 HOLD-G-CONSTRAINT(미적재·가격 무영향).

COMMIT;
