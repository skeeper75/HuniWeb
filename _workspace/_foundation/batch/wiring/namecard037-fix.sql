-- =============================================================================
-- namecard037-fix.sql  (COMMIT · 멱등 · 단일 트랜잭션)
-- ★스코프: 박명함 PRD_000037 배선만 (블록 A). 화이트명함 040·기타 절대 제외.
-- 출처: design-namecard-dryrun.sql 블록 A verbatim 추출 (ROLLBACK→COMMIT).
-- 게이트 GO(gate-design-260701.md): 골든 16케이스 verbatim 일치·disjoint PASS.
-- 단가 verbatim(unit_price 변경 0건, 판별차원 컬럼/use_dims만 충전).
-- 인간 승인: 사용자 2026-07-01 (박명함 037 배선만 COMMIT).
-- FK 위상순: print_options → opt_grp → opv → 단가행 충전 → use_dims → formula_components.
-- =============================================================================
BEGIN;

-- A-1. 선택수단: print_options (단/양면) — 없으면 배선 무효 [HARD]
INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, del_yn, reg_dt)
SELECT 'PRD_000037', 1, '단면', 'CLR_000005', 'CLR_000001', 'Y', 1, 'POPT_000001', 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options
                  WHERE prd_cd='PRD_000037' AND print_opt_cd='POPT_000001');
INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, del_yn, reg_dt)
SELECT 'PRD_000037', 2, '양면', 'CLR_000005', 'CLR_000005', 'N', 2, 'POPT_000002', 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options
                  WHERE prd_cd='PRD_000037' AND print_opt_cd='POPT_000002');

-- A-2. 선택수단: 박종류 옵션그룹 + 옵션 (mint: OPT_000080 / OPV_000487·488)
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000037', 'OPT_000080', '박종류', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', 'N',
       '박명함 박종류 택1(일반박/홀로). opt_cd 판별차원 선택수단. mint MAX+1.', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE opt_grp_cd='OPT_000080');
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000037', 'OPV_000487', 'OPT_000080', '일반박', 'Y', 1, 'Y', 'N',
       '금/은/먹유광·청박·적박·동박. STD body 매칭.', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000037' AND opt_cd='OPV_000487');
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000037', 'OPV_000488', 'OPT_000080', '홀로그램/트윙클', 'N', 2, 'Y', 'N',
       'HOLO body 매칭(+박종류 프리미엄).', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000037' AND opt_cd='OPV_000488');

-- A-3. 단가행 판별차원 충전 (UPDATE — 값 불변, print_opt_cd/opt_cd 만; IS NULL 가드 멱등)
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000001', opt_cd='OPV_000487', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_S1_STD'  AND print_opt_cd IS NULL;  -- 9행
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000001', opt_cd='OPV_000488', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_S1_HOLO' AND print_opt_cd IS NULL;  -- 9행
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000002', opt_cd='OPV_000487', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_S2_STD'  AND print_opt_cd IS NULL;  -- 9행
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000002', opt_cd='OPV_000488', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_S2_HOLO' AND print_opt_cd IS NULL;  -- 9행
-- setup: print_opt 만(박종류 무관·opt_cd NULL=와일드카드 유지)
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000001', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_SETUP_S1_STD' AND print_opt_cd IS NULL;  -- 1행(3351)
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000002', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_SETUP_S2_STD' AND print_opt_cd IS NULL;  -- 1행(3352)

-- A-4. use_dims 갱신 (판별차원 선언 — UI 그리드·opt_grp 스코프; 멱등 가드)
UPDATE t_prc_price_components SET use_dims='["print_opt_cd","opt_cd","min_qty","opt_grp:OPT_000080"]', upd_dt=now()
  WHERE comp_cd IN ('COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S1_HOLO',
                    'COMP_NAMECARD_FOIL_S2_STD','COMP_NAMECARD_FOIL_S2_HOLO')
    AND use_dims = '["min_qty"]';
UPDATE t_prc_price_components SET use_dims='["print_opt_cd","min_qty"]', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_SETUP_S1_STD' AND use_dims='["min_qty"]';
UPDATE t_prc_price_components SET use_dims='["print_opt_cd"]', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_SETUP_S2_STD' AND use_dims='[]';

-- A-5. 배선 (PRF_NAMECARD_FOIL 재사용 — S1_HOLO/S2_STD/S2_HOLO/SETUP_S2 추가; S1_STD/SETUP_S1 기존)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_NAMECARD_FOIL', v.comp_cd, v.seq, 'Y', now()
FROM (VALUES
  ('COMP_NAMECARD_FOIL_S1_HOLO', 3),
  ('COMP_NAMECARD_FOIL_S2_STD',  4),
  ('COMP_NAMECARD_FOIL_S2_HOLO', 5),
  ('COMP_NAMECARD_FOIL_SETUP_S2_STD', 6)
) AS v(comp_cd, seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
                  WHERE frm_cd='PRF_NAMECARD_FOIL' AND comp_cd=v.comp_cd);

COMMIT;
