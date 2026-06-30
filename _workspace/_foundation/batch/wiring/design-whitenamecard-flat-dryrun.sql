-- ============================================================================
-- 화이트인쇄명함 PRD_000040 — 별색 flat 완제품가 모델 교정 (DRYRUN)
-- 생성 2026-07-01 · DB 미적재 · BEGIN…ROLLBACK · COMMIT 아님 · 실 적용은 인간 승인 후 §7 dbmap
-- 멱등: NOT EXISTS / IS NULL 가드. 채번 = 라이브 MAX+1 실측(opt_grp 080→081·opt 488→489/490).
-- 단가 verbatim(14,500~19,000 무변경) · 코팅 모델 부활 금지(클리어=별색).
-- 검증 SELECT는 ROLLBACK 직전 포함(적용 후 상태 확인용).
-- ============================================================================
BEGIN;

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
-- (3) ★재바인딩 [HARD] — PRF_DGP_A 제거 + PRF_NAMECARD_WHITE 추가 (이중합산 가드)
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
-- (4) ★근본 — print_opt 선택수단 (현 0건 = 견적0 지배원인)
--     colrcnt = 화면 표시 메타(화이트=1도 별색 best-fit·엔진은 print_opt_cd만 매칭)
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
-- (5) 클리어 별색 opt_grp/opt 신설 (코팅 아님·별색·채번 MAX+1: OPT_081·OPV_489/490)
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
-- (5b) 단가행 opt_cd 충전 (UPDATE·단가 불변) — NOCL=OPV_489·CL=OPV_490
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_prc_component_prices SET opt_cd='OPV_000489', upd_dt=now()
WHERE comp_price_id IN (3343, 3345) AND opt_cd IS NULL;          -- S1W_NOCL·S2W_NOCL

UPDATE t_prc_component_prices SET opt_cd='OPV_000490', upd_dt=now()
WHERE comp_price_id IN (3344, 3346) AND opt_cd IS NULL;          -- S1W_CL·S2W_CL

-- ─────────────────────────────────────────────────────────────────────────
-- (6) mat_cd 와일드카드 (MAT_000137→NULL·색 무관 매칭·단가 불변) + use_dims 갱신
--     037 FOIL 미러: mat_cd 드롭(와일드)·opt_cd 추가·opt_grp UI 스코핑.
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_prc_component_prices SET mat_cd=NULL, upd_dt=now()
WHERE comp_price_id IN (3343, 3344, 3345, 3346) AND mat_cd='MAT_000137';

UPDATE t_prc_price_components
SET use_dims='["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"]', upd_dt=now()
WHERE comp_cd IN ('COMP_NAMECARD_WHITE_S1W_NOCL','COMP_NAMECARD_WHITE_S1W_CL',
                  'COMP_NAMECARD_WHITE_S2W_NOCL','COMP_NAMECARD_WHITE_S2W_CL');

-- (7) §17 굿즈 자재 오염: MAT_000138~141 = 이미 del_yn=Y(소프트삭제 완료) → 조치 불요·플래그만.
--     PROC_000009 클리어 공정 잔존: flat 모델 가격무해(proc_cd 미매칭)·UX 정리 별 트랙. dryrun 미포함.

-- ═══════════════════════════════ 검증 SELECT (적용 후 상태) ═══════════════════════════════
-- V1. 040 바인딩 = PRF_NAMECARD_WHITE 단 1건(PRF_DGP_A 제거 확인·이중배선 0)
SELECT 'V1 binding' AS chk, prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000040';
-- V2. 배선 4건
SELECT 'V2 wiring' AS chk, count(*) AS n FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_WHITE';
-- V3. print_opt 2건
SELECT 'V3 print_opt' AS chk, count(*) AS n FROM t_prd_product_print_options WHERE prd_cd='PRD_000040' AND del_yn='N';
-- V4. 단가행 disjoint (print_opt × opt_cd × mat_cd NULL · 단가 verbatim)
SELECT 'V4 rows' AS chk, comp_price_id, print_opt_cd, opt_cd, mat_cd, min_qty, unit_price
FROM t_prc_component_prices WHERE comp_price_id IN (3343,3344,3345,3346) ORDER BY comp_price_id;
-- V5. 클리어 별색 opt (코팅 라벨 0)
SELECT 'V5 opt' AS chk, opt_cd, opt_nm, dflt_yn FROM t_prd_product_options
WHERE prd_cd='PRD_000040' AND opt_grp_cd='OPT_000081' ORDER BY disp_seq;
-- V6. use_dims 정합
SELECT 'V6 use_dims' AS chk, comp_cd, use_dims FROM t_prc_price_components
WHERE comp_cd LIKE 'COMP_NAMECARD_WHITE%' ORDER BY comp_cd;

-- 기대 골든(q100·합가형 tier÷min_qty×qty): 단면·없음 14,500 / 단면·있음 16,000 / 양면·없음 16,000 / 양면·있음 19,000.

ROLLBACK; -- DRYRUN — COMMIT 아님. 실 적용은 인간 승인 후 §7 dbmap.
</content>
