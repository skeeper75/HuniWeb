-- =============================================================================
-- whitenamecard040-undo.sql  (역연산 · 단일 트랜잭션)
-- ★스코프: whitenamecard040-fix.sql 의 화이트인쇄명함 PRD_000040 별색 flat 교정만 역전.
-- 물리 백업(pre-state) = _backup/whitenamecard040-20260701-041452/
--   (product_price_formulas 1행=PRF_DGP_A 바인딩·component_prices 4·price_components 4·나머지 0행)
-- 역 FK 위상순: use_dims/단가행 → print_options → ★재바인딩 원복(WHITE 제거+PRF_DGP_A 재INSERT)
--               → options → opt_grp → formula_components → price_formulas.
-- 사용: 사후검증 골든 불일치/회귀 시 즉시 실행. 단가 unit_price 는 fix 가 변경 0이라 복원 불필요.
-- =============================================================================
BEGIN;

-- (7) 역전: use_dims 원복(구값) + mat_cd 복원(NULL→MAT_000137)
UPDATE t_prc_price_components SET use_dims='["mat_cd", "min_qty", "print_opt_cd"]', upd_dt=now()
WHERE comp_cd IN ('COMP_NAMECARD_WHITE_S1W_NOCL','COMP_NAMECARD_WHITE_S1W_CL',
                  'COMP_NAMECARD_WHITE_S2W_NOCL','COMP_NAMECARD_WHITE_S2W_CL')
  AND use_dims = '["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"]';

UPDATE t_prc_component_prices SET mat_cd='MAT_000137', upd_dt=now()
WHERE comp_price_id IN (3343, 3344, 3345, 3346) AND mat_cd IS NULL;

-- (6) 역전: 단가행 opt_cd NULL 환원(fix 가 충전한 값에 한정)
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now()
WHERE comp_price_id IN (3343, 3345) AND opt_cd='OPV_000489';
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now()
WHERE comp_price_id IN (3344, 3346) AND opt_cd='OPV_000490';

-- (5) 역전: print_options 삭제 (fix 신규 생성분)
DELETE FROM t_prd_product_print_options
WHERE prd_cd='PRD_000040' AND print_opt_cd IN ('POPT_000001','POPT_000002');

-- (4) ★재바인딩 원복 [HARD] — PRF_NAMECARD_WHITE 제거 + PRF_DGP_A 재INSERT(백업 verbatim)
DELETE FROM t_prd_product_price_formulas
WHERE prd_cd='PRD_000040' AND frm_cd='PRF_NAMECARD_WHITE';

INSERT INTO t_prd_product_price_formulas(prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000040', 'PRF_DGP_A', DATE '2026-06-01',
       '§29 040 빌드 260630 - 020 원자모델 복제(화이트인쇄)', TIMESTAMP '2026-06-30 11:59:59.022705'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas
  WHERE prd_cd='PRD_000040' AND frm_cd='PRF_DGP_A');

-- (3) 역전: mint 옵션/옵션그룹 삭제 (fix 신규 생성분)
DELETE FROM t_prd_product_options
WHERE prd_cd='PRD_000040' AND opt_cd IN ('OPV_000489','OPV_000490');
DELETE FROM t_prd_product_option_groups
WHERE prd_cd='PRD_000040' AND opt_grp_cd='OPT_000081';

-- (2) 역전: 배선 4건 삭제 (fix 신규 배선분)
DELETE FROM t_prc_formula_components
WHERE frm_cd='PRF_NAMECARD_WHITE'
  AND comp_cd IN ('COMP_NAMECARD_WHITE_S1W_NOCL','COMP_NAMECARD_WHITE_S1W_CL',
                  'COMP_NAMECARD_WHITE_S2W_NOCL','COMP_NAMECARD_WHITE_S2W_CL');

-- (1) 역전: flat 공식 삭제 (fix mint 분)
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_WHITE';

COMMIT;
