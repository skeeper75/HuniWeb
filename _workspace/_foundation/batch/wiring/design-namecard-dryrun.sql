-- =============================================================================
-- design-namecard-dryrun.sql  (DRY-RUN · 멱등 · COMMIT 아님)
-- 명함류 고아 8건 §18 설계 적재 — 박명함 PRD_000037 / 화이트명함 PRD_000040
-- 생성: 2026-07-01 (hpe-engine-designer)  |  실행: BEGIN ... ROLLBACK (검증 전용)
-- 단가 verbatim(값 0건 변경, 판별차원 컬럼만 충전) · NOT EXISTS/IS NULL 가드
-- 실 COMMIT 은 인간 승인 후 §7 dbmap. 선행 의존: §26(화이트 tier) · §17(자재 오염).
-- =============================================================================
BEGIN;

-- ─────────────────────────────────────────────────────────────────────────
-- A. 오리지널박명함 PRD_000037 — PRF_NAMECARD_FOIL 재사용
-- ─────────────────────────────────────────────────────────────────────────

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

-- A-4. use_dims 갱신 (판별차원 선언 — 엔진이 매칭에 사용)
UPDATE t_prc_price_components SET use_dims='["print_opt_cd","opt_cd","min_qty","opt_grp:OPT_000080"]', upd_dt=now()
  WHERE comp_cd IN ('COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S1_HOLO',
                    'COMP_NAMECARD_FOIL_S2_STD','COMP_NAMECARD_FOIL_S2_HOLO')
    AND use_dims = '["min_qty"]';
UPDATE t_prc_price_components SET use_dims='["print_opt_cd","min_qty"]', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_SETUP_S1_STD' AND use_dims='["min_qty"]';
UPDATE t_prc_price_components SET use_dims='["print_opt_cd"]', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_FOIL_SETUP_S2_STD' AND use_dims='[]';

-- A-5. 배선 (PRF_NAMECARD_FOIL 재사용 — S1_HOLO/S2_STD/S2_HOLO/SETUP_S2 추가)
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

-- ─────────────────────────────────────────────────────────────────────────
-- B. 화이트인쇄명함 PRD_000040 — PRF_NAMECARD_WHITE 신설 (견적0 해소)
-- ─────────────────────────────────────────────────────────────────────────

-- B-1. 공식 신설 + 바인딩
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_NAMECARD_WHITE', '화이트인쇄명함 면/코팅/수량별 단가(용지포함)',
       '가격표260527. 화이트(큐리어스스킨) 단/양면 × 코팅(CL/NOCL) 4 body. print_opt_cd×opt_cd disjoint. §18 명함 고아배선 260701.', 'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_WHITE');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000040', 'PRF_NAMECARD_WHITE', '2026-06-01',
       '화이트인쇄명함 공식 신설 바인딩(이전 미바인딩→견적0 해소).', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas
                  WHERE prd_cd='PRD_000040' AND frm_cd='PRF_NAMECARD_WHITE');

-- B-2. 선택수단: print_options (단/양면)
INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, del_yn, reg_dt)
SELECT 'PRD_000040', 1, '단면', 'CLR_000005', 'CLR_000001', 'Y', 1, 'POPT_000001', 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options
                  WHERE prd_cd='PRD_000040' AND print_opt_cd='POPT_000001');
INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, del_yn, reg_dt)
SELECT 'PRD_000040', 2, '양면', 'CLR_000005', 'CLR_000005', 'N', 2, 'POPT_000002', 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options
                  WHERE prd_cd='PRD_000040' AND print_opt_cd='POPT_000002');

-- B-3. 선택수단: 코팅 옵션그룹 + 옵션 (mint: OPT_000081 / OPV_000489·490)
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000040', 'OPT_000081', '코팅', 'SEL_TYPE.01', 1, 1, 'Y', 2, 'Y', 'N',
       '화이트명함 코팅 택1(코팅/무코팅). opt_cd 판별차원. 기본=무코팅[CONFIRM]. mint MAX+1.', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE opt_grp_cd='OPT_000081');
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000040', 'OPV_000490', 'OPT_000081', '무코팅', 'Y', 1, 'Y', 'N', '클리어 없음. NOCL body 매칭.', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000040' AND opt_cd='OPV_000490');
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000040', 'OPV_000489', 'OPT_000081', '코팅', 'N', 2, 'Y', 'N', '클리어 코팅. CL body 매칭.', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000040' AND opt_cd='OPV_000489');

-- B-4. 선택수단: 자재 (큐리어스스킨 MAT_000137 — mat_cd no_match 견적0 방지)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, del_yn, reg_dt)
SELECT 'PRD_000040', 'MAT_000137', 'USAGE.07', 'Y', 1, 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials
                  WHERE prd_cd='PRD_000040' AND mat_cd='MAT_000137');
-- NOTE[§17]: PRD_000040 의 MAT_000138~141(굿즈 오염)은 본 dryrun 미포함 — 자재 정리 트랙 위임.

-- B-5. 단가행 코팅 판별차원 충전 (UPDATE — print_opt/mat 기보유, opt_cd 추가)
UPDATE t_prc_component_prices SET opt_cd='OPV_000490', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_WHITE_S1W_NOCL' AND opt_cd IS NULL;  -- 3343
UPDATE t_prc_component_prices SET opt_cd='OPV_000489', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_WHITE_S1W_CL'   AND opt_cd IS NULL;  -- 3344
UPDATE t_prc_component_prices SET opt_cd='OPV_000490', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_WHITE_S2W_NOCL' AND opt_cd IS NULL;  -- 3345
UPDATE t_prc_component_prices SET opt_cd='OPV_000489', upd_dt=now()
  WHERE comp_cd='COMP_NAMECARD_WHITE_S2W_CL'   AND opt_cd IS NULL;  -- 3346

-- B-6. use_dims 갱신 (opt_cd 코팅 판별 추가)
UPDATE t_prc_price_components
  SET use_dims='["mat_cd","print_opt_cd","opt_cd","min_qty","opt_grp:OPT_000081"]', upd_dt=now()
  WHERE comp_cd IN ('COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL',
                    'COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL')
    AND use_dims = '["mat_cd", "min_qty", "print_opt_cd"]';

-- B-7. 배선 (신설 공식에 4 body)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_NAMECARD_WHITE', v.comp_cd, v.seq, 'Y', now()
FROM (VALUES
  ('COMP_NAMECARD_WHITE_S1W_NOCL', 1),
  ('COMP_NAMECARD_WHITE_S1W_CL',   2),
  ('COMP_NAMECARD_WHITE_S2W_NOCL', 3),
  ('COMP_NAMECARD_WHITE_S2W_CL',   4)
) AS v(comp_cd, seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
                  WHERE frm_cd='PRF_NAMECARD_WHITE' AND comp_cd=v.comp_cd);

-- =============================================================================
-- 검증 SELECT (실행 후 확인 — disjoint·배선·골든 사전점검)
-- =============================================================================
-- 박명함 배선(기대 6행): SELECT comp_cd,disp_seq FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_FOIL' ORDER BY disp_seq;
-- 박명함 단가행 판별(기대 NULL 0): SELECT comp_cd,count(*) FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_NAMECARD_FOIL%' AND print_opt_cd IS NULL GROUP BY comp_cd;
-- 화이트 배선(기대 4행): SELECT comp_cd FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_WHITE' ORDER BY disp_seq;
-- 화이트 바인딩(기대 1): SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000040';

ROLLBACK;   -- DRY-RUN. 실 적용 = 인간 승인 후 COMMIT 으로 교체 (§7 dbmap).
