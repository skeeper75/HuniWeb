-- =============================================================================
-- namecard037-undo.sql  (역연산 · 단일 트랜잭션)
-- ★스코프: namecard037-fix.sql 의 박명함 PRD_000037 배선만 역전.
-- 물리 백업(pre-state) = _workspace/_foundation/batch/wiring/_backup/namecard037-20260701-025840/
--   (formula_components 2행·component_prices 38행·price_components 6행·print_options/opt_grp/options 0행)
-- 역 FK 위상순: formula_components → use_dims/단가행 → options → opt_grp → print_options.
-- 사용: 사후검증 골든 불일치 시 즉시 실행. 단가 unit_price 는 fix 가 변경 0이라 복원 불필요.
-- =============================================================================
BEGIN;

-- A-5 역전: 추가 배선 4건 삭제 (S1_STD/SETUP_S1 = 사전존재 → 보존)
DELETE FROM t_prc_formula_components
 WHERE frm_cd='PRF_NAMECARD_FOIL'
   AND comp_cd IN ('COMP_NAMECARD_FOIL_S1_HOLO','COMP_NAMECARD_FOIL_S2_STD',
                   'COMP_NAMECARD_FOIL_S2_HOLO','COMP_NAMECARD_FOIL_SETUP_S2_STD');

-- A-4 역전: use_dims 원복(body 4=["min_qty"]·SETUP_S1=["min_qty"]·SETUP_S2=[])
UPDATE t_prc_price_components SET use_dims='["min_qty"]', upd_dt=now()
  WHERE comp_cd IN ('COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S1_HOLO',
                    'COMP_NAMECARD_FOIL_S2_STD','COMP_NAMECARD_FOIL_S2_HOLO')
    AND use_dims = '["print_opt_cd","opt_cd","min_qty","opt_grp:OPT_000080"]';
UPDATE t_prc_price_components SET use_dims='["min_qty"]', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_SETUP_S1_STD' AND use_dims='["print_opt_cd","min_qty"]';
UPDATE t_prc_price_components SET use_dims='[]', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_SETUP_S2_STD' AND use_dims='["print_opt_cd"]';

-- A-3 역전: 단가행 판별차원 NULL 환원(fix 가 충전한 값에 한정)
UPDATE t_prc_component_prices SET print_opt_cd=NULL, opt_cd=NULL, upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_S1_STD'  AND print_opt_cd='POPT_000001' AND opt_cd='OPV_000487';
UPDATE t_prc_component_prices SET print_opt_cd=NULL, opt_cd=NULL, upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_S1_HOLO' AND print_opt_cd='POPT_000001' AND opt_cd='OPV_000488';
UPDATE t_prc_component_prices SET print_opt_cd=NULL, opt_cd=NULL, upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_S2_STD'  AND print_opt_cd='POPT_000002' AND opt_cd='OPV_000487';
UPDATE t_prc_component_prices SET print_opt_cd=NULL, opt_cd=NULL, upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_S2_HOLO' AND print_opt_cd='POPT_000002' AND opt_cd='OPV_000488';
UPDATE t_prc_component_prices SET print_opt_cd=NULL, upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_SETUP_S1_STD' AND print_opt_cd='POPT_000001';
UPDATE t_prc_component_prices SET print_opt_cd=NULL, upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_SETUP_S2_STD' AND print_opt_cd='POPT_000002';

-- A-2 역전: mint 옵션/옵션그룹 삭제 (물리삭제 — fix 가 신규 생성분)
DELETE FROM t_prd_product_options
 WHERE prd_cd='PRD_000037' AND opt_cd IN ('OPV_000487','OPV_000488');
DELETE FROM t_prd_product_option_groups
 WHERE prd_cd='PRD_000037' AND opt_grp_cd='OPT_000080';

-- A-1 역전: print_options 삭제 (fix 가 신규 생성분)
DELETE FROM t_prd_product_print_options
 WHERE prd_cd='PRD_000037' AND print_opt_cd IN ('POPT_000001','POPT_000002');

COMMIT;
