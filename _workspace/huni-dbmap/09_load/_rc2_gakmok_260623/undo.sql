-- undo.sql — RC-2 각목 적재 원복 (멱등·단일 트랜잭션·BEGIN…COMMIT)
-- ============================================================================
-- apply.sql 역순 원복. 라이브 적재 전 상태(2026-06-23 실측 baseline)로 복귀.
--   baseline: OPV_000015="각목(세로)+끈(4개) 추가"·016="각목(가로)+끈(4개) 추가"
--             _LE/_GT use_dims=[]·use_yn=Y / 부모 _900_4 use_yn=Y
--             4698 opt_cd NULL·4700 opt_cd NULL / GAKMOK 바인딩 0건 / OPT_000063·432/433 부재
-- ★실 원복 COMMIT은 인간 승인 후에만.
-- ============================================================================
BEGIN;

-- STEP 7 역 — 바인딩 제거
DELETE FROM t_prc_formula_components
 WHERE frm_cd='PRF_POSTER_BANNER_N'
   AND comp_cd IN ('COMP_POPT_BNR_GAKMOK_STR_900_4_LE','COMP_POPT_BNR_GAKMOK_STR_900_4_GT');

-- STEP 6 역 — 부모 껍데기 use_yn 복귀(Y)
UPDATE t_prc_price_components
   SET use_yn='Y'
 WHERE comp_cd='COMP_POPT_BNR_GAKMOK_STR_900_4'
   AND use_yn IS DISTINCT FROM 'Y';

-- STEP 5 역 — 단가행 opt_cd NULL 복귀(단가 verbatim 불변)
UPDATE t_prc_component_prices
   SET opt_cd=NULL
 WHERE comp_price_id=4698 AND comp_cd='COMP_POPT_BNR_GAKMOK_STR_900_4_LE'
   AND opt_cd='OPV_000015';
UPDATE t_prc_component_prices
   SET opt_cd=NULL
 WHERE comp_price_id=4700 AND comp_cd='COMP_POPT_BNR_GAKMOK_STR_900_4_GT'
   AND opt_cd='OPV_000016';

-- STEP 4 역 — comp use_dims []로 복귀
UPDATE t_prc_price_components
   SET use_dims='[]'::jsonb
 WHERE comp_cd IN ('COMP_POPT_BNR_GAKMOK_STR_900_4_LE','COMP_POPT_BNR_GAKMOK_STR_900_4_GT')
   AND use_dims IS DISTINCT FROM '[]'::jsonb;

-- STEP 2b 역 — 재라벨 원복
UPDATE t_prd_product_options
   SET opt_nm='각목(세로)+끈(4개) 추가'
 WHERE prd_cd='PRD_000138' AND opt_cd='OPV_000015'
   AND opt_nm IS DISTINCT FROM '각목(세로)+끈(4개) 추가';
UPDATE t_prd_product_options
   SET opt_nm='각목(가로)+끈(4개) 추가'
 WHERE prd_cd='PRD_000138' AND opt_cd='OPV_000016'
   AND opt_nm IS DISTINCT FROM '각목(가로)+끈(4개) 추가';

-- STEP 2a 역 — 신규 세로/가로 옵션 제거
DELETE FROM t_prd_product_options
 WHERE prd_cd='PRD_000138' AND opt_cd IN ('OPV_000432','OPV_000433');

-- STEP 1 역 — 신규 그룹 제거 (자식 옵션 선삭제 후)
DELETE FROM t_prd_product_option_groups
 WHERE prd_cd='PRD_000138' AND opt_grp_cd='OPT_000063';

COMMIT;
