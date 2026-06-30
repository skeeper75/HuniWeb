-- =============================================================================
-- whitenamecard040-fix.sql  (COMMIT · 멱등 · 단일 트랜잭션 · 사전상태 abort assert)
-- ★스코프[HARD]: 화이트인쇄명함 PRD_000040 별색 flat 교정만. 박명함 037·기타 절대 제외.
-- 출처: design-whitenamecard-flat-dryrun.sql 본문 verbatim(ROLLBACK→COMMIT) + codex R4 preflight assert.
-- 게이트 GO: gate-whitenamecard-flat-260701.md(E1~E7 PASS·골든 q100 허용오차0)·codex Phase5.5 합의(divergence0).
-- 인간 승인: 사용자 2026-07-01 (화이트인쇄명함 040 별색 flat 교정만 COMMIT·재바인딩 포함).
-- 단가 verbatim(unit_price 변경 0건; mat_cd→NULL·opt_cd 충전·use_dims만).
-- 코팅 라벨 부활 금지(클리어=별색). comp_nm "코팅" 잔존=cosmetic·미수정(C6·가격무영향).
-- FK 위상순: price_formula → formula_components → opt_grp → options → 재바인딩(DELETE+INSERT)
--            → print_options → 단가행 opt_cd/mat_cd UPDATE → use_dims UPDATE.
-- =============================================================================
BEGIN;

-- ─────────────────────────────────────────────────────────────────────────
-- (0) 사전상태 abort assert [codex R4·live drift 차단] — 어긋나면 트랜잭션 abort
-- ─────────────────────────────────────────────────────────────────────────
DO $$
DECLARE
  v_bind_cnt   int;
  v_dgp_cnt    int;
  v_white_bind int;
  v_wired      int;
  v_white_frm  int;
  v_prices     text;
BEGIN
  -- 040 바인딩 = PRF_DGP_A 단 1건
  SELECT count(*) INTO v_bind_cnt FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000040';
  SELECT count(*) INTO v_dgp_cnt  FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000040' AND frm_cd='PRF_DGP_A';
  SELECT count(*) INTO v_white_bind FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000040' AND frm_cd='PRF_NAMECARD_WHITE';
  IF v_bind_cnt <> 1 OR v_dgp_cnt <> 1 OR v_white_bind <> 0 THEN
    RAISE EXCEPTION 'ABORT: 040 바인딩 사전상태 불일치 (전체=% · PRF_DGP_A=% · WHITE=%) — 기대 1/1/0', v_bind_cnt, v_dgp_cnt, v_white_bind;
  END IF;
  -- flat comp 3343~3346 미배선
  SELECT count(*) INTO v_wired FROM t_prc_formula_components
   WHERE comp_cd IN ('COMP_NAMECARD_WHITE_S1W_NOCL','COMP_NAMECARD_WHITE_S1W_CL',
                     'COMP_NAMECARD_WHITE_S2W_NOCL','COMP_NAMECARD_WHITE_S2W_CL');
  IF v_wired <> 0 THEN
    RAISE EXCEPTION 'ABORT: flat comp 사전 배선됨 (count=%) — 기대 0', v_wired;
  END IF;
  -- PRF_NAMECARD_WHITE 공식 미존재
  SELECT count(*) INTO v_white_frm FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_WHITE';
  IF v_white_frm <> 0 THEN
    RAISE EXCEPTION 'ABORT: PRF_NAMECARD_WHITE 사전 존재 (count=%) — 기대 0', v_white_frm;
  END IF;
  -- 단가행 3343~3346 현재값 verbatim assert (codex N3/N4)
  SELECT string_agg(comp_price_id || '=' || unit_price::numeric(12,2), ',' ORDER BY comp_price_id)
    INTO v_prices FROM t_prc_component_prices WHERE comp_price_id IN (3343,3344,3345,3346);
  IF v_prices <> '3343=14500.00,3344=16000.00,3345=16000.00,3346=19000.00' THEN
    RAISE EXCEPTION 'ABORT: 단가행 현재값 불일치 (%) — 기대 3343=14500/3344=16000/3345=16000/3346=19000', v_prices;
  END IF;
  RAISE NOTICE 'PREFLIGHT PASS — 040 바인딩 PRF_DGP_A 단독·flat comp 미배선·공식 미존재·단가 verbatim 확인.';
END $$;

-- ─────────────────────────────────────────────────────────────────────────
-- (1) flat 공식 신설 — PRF_NAMECARD_WHITE (원자합산 아님·flat 1행 매칭형)
-- ─────────────────────────────────────────────────────────────────────────
INSERT INTO t_prc_price_formulas(frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_NAMECARD_WHITE',
       '화이트인쇄명함 면·클리어별색·수량별 단가(용지포함)',
       'flat 완제품가 1행 매칭형. 단/양면×클리어별색(코팅 아님)×수량 단가표. PRF_DGP_A 원자합산 대체. search-before-mint(무손실 불가 입증).',
       'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_WHITE');

-- ─────────────────────────────────────────────────────────────────────────
-- (2) 배선 — 4 flat comp → PRF_NAMECARD_WHITE (addtn_yn=Y, seq 1..4)
-- ─────────────────────────────────────────────────────────────────────────
INSERT INTO t_prc_formula_components(frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_NAMECARD_WHITE', v.comp_cd, v.seq, 'Y', now()
FROM (VALUES
  ('COMP_NAMECARD_WHITE_S1W_NOCL', 1),
  ('COMP_NAMECARD_WHITE_S1W_CL',   2),
  ('COMP_NAMECARD_WHITE_S2W_NOCL', 3),
  ('COMP_NAMECARD_WHITE_S2W_CL',   4)
) AS v(comp_cd, seq)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components fc
  WHERE fc.frm_cd='PRF_NAMECARD_WHITE' AND fc.comp_cd=v.comp_cd);

-- ─────────────────────────────────────────────────────────────────────────
-- (3) 클리어 별색 opt_grp/opt 신설 (코팅 아님·별색·채번 MAX+1: OPT_081·OPV_489/490)
-- ─────────────────────────────────────────────────────────────────────────
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000040', 'OPT_000081', '클리어(별색)', 'SEL_TYPE.01', 1, 1, 'Y', 3, 'Y', 'N',
       '화이트인쇄명함 클리어 별색 택1(없음/있음). 코팅 아님. opt_cd 판별차원 선택수단. mint MAX+1.', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000040' AND opt_grp_cd='OPT_000081');

INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000040', v.opt_cd, 'OPT_000081', v.opt_nm, v.dflt, v.seq, 'Y', 'N', v.note, now()
FROM (VALUES
  ('OPV_000489', '클리어 없음', 'Y', 1, '기본(저가). NOCL body 매칭. [CONFIRM 클리어 기본값].'),
  ('OPV_000490', '클리어 있음', 'N', 2, 'CL body 매칭(+클리어 별색).')
) AS v(opt_cd, opt_nm, dflt, seq, note)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options o
  WHERE o.prd_cd='PRD_000040' AND o.opt_cd=v.opt_cd);

-- ─────────────────────────────────────────────────────────────────────────
-- (4) ★재바인딩 [HARD] — PRF_DGP_A 제거 + PRF_NAMECARD_WHITE 추가 (이중합산 가드)
-- ─────────────────────────────────────────────────────────────────────────
DELETE FROM t_prd_product_price_formulas
WHERE prd_cd='PRD_000040' AND frm_cd='PRF_DGP_A';

INSERT INTO t_prd_product_price_formulas(prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000040', 'PRF_NAMECARD_WHITE', DATE '2026-06-01',
       '040 화이트인쇄명함 flat 재바인딩(PRF_DGP_A 원자→flat). 견적0 교정.', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas
  WHERE prd_cd='PRD_000040' AND frm_cd='PRF_NAMECARD_WHITE');

-- ─────────────────────────────────────────────────────────────────────────
-- (5) ★근본 — print_opt 선택수단 (현 0건 = 견적0 지배원인)
-- ─────────────────────────────────────────────────────────────────────────
INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, reg_dt, del_yn, print_opt_cd)
SELECT 'PRD_000040', 1, '단면', 'CLR_000002', 'CLR_000001', 'Y', 1, now(), 'N', 'POPT_000001'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options
  WHERE prd_cd='PRD_000040' AND print_opt_cd='POPT_000001' AND del_yn='N');

INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, reg_dt, del_yn, print_opt_cd)
SELECT 'PRD_000040', 2, '양면', 'CLR_000002', 'CLR_000002', 'N', 2, now(), 'N', 'POPT_000002'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options
  WHERE prd_cd='PRD_000040' AND print_opt_cd='POPT_000002' AND del_yn='N');

-- ─────────────────────────────────────────────────────────────────────────
-- (6) 단가행 opt_cd 충전 (UPDATE·단가 불변) — NOCL=OPV_489·CL=OPV_490 (IS NULL 가드 멱등)
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_prc_component_prices SET opt_cd='OPV_000489', upd_dt=now()
WHERE comp_price_id IN (3343, 3345) AND opt_cd IS NULL;          -- S1W_NOCL·S2W_NOCL

UPDATE t_prc_component_prices SET opt_cd='OPV_000490', upd_dt=now()
WHERE comp_price_id IN (3344, 3346) AND opt_cd IS NULL;          -- S1W_CL·S2W_CL

-- ─────────────────────────────────────────────────────────────────────────
-- (7) mat_cd 와일드카드 (MAT_000137→NULL·색 무관 매칭·단가 불변) + use_dims 갱신
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_prc_component_prices SET mat_cd=NULL, upd_dt=now()
WHERE comp_price_id IN (3343, 3344, 3345, 3346) AND mat_cd='MAT_000137';

UPDATE t_prc_price_components
SET use_dims='["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"]', upd_dt=now()
WHERE comp_cd IN ('COMP_NAMECARD_WHITE_S1W_NOCL','COMP_NAMECARD_WHITE_S1W_CL',
                  'COMP_NAMECARD_WHITE_S2W_NOCL','COMP_NAMECARD_WHITE_S2W_CL')
  AND use_dims = '["mat_cd", "min_qty", "print_opt_cd"]';   -- 멱등 가드(구값에 한정)

COMMIT;
