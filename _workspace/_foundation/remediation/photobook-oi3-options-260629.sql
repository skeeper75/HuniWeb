-- =====================================================================
-- 포토북(PRD_000100) OI-3 — 표지타입 옵션그룹 등록 (시뮬레이터/위젯 표지타입 선택)
-- 가격 데이터(COMP_PHOTOBOOK_BASE opt_cd 단가행)는 COMMIT 완료. 이 SQL은 손님이
-- 표지타입(opt_cd)을 고를 수 있게 옵션그룹+옵션 3개를 등록 → set_selections.opt_cd 전달.
-- opt_cd = 라이브 컨벤션 OPV_000484(하드)/485(레더하드)/486(소프트). 그룹=OPT_000079(신규·MAX+1).
-- 택1 필수(SEL_TYPE.01·min1·max1·mand Y). ★10x10 소프트=권위 빈칸(가격 없음·CPQ 제약 별도).
-- 멱등(NOT EXISTS). 기본=ROLLBACK(검증). COMMIT은 헤더 주석 해제.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;

-- 1. 옵션그룹 "표지타입"
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, reg_dt)
SELECT 'PRD_000100', 'OPT_000079', '표지타입', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000100' AND opt_grp_cd='OPT_000079');

-- 2. 옵션 3개 (opt_cd = 가격 단가행 opt_cd 와 동일)
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
SELECT v.prd_cd, v.opt_cd, v.opt_grp_cd, v.opt_nm, v.dflt_yn, v.disp_seq, 'Y', 'N', now()
FROM (VALUES
  ('PRD_000100','OPV_000484','OPT_000079','하드커버',     'Y', 1),
  ('PRD_000100','OPV_000485','OPT_000079','레더하드커버', 'N', 2),
  ('PRD_000100','OPV_000486','OPT_000079','소프트커버',   'N', 3)
) AS v(prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options o
  WHERE o.prd_cd=v.prd_cd AND o.opt_cd=v.opt_cd);

-- 검증
SELECT 'group' t, count(*) n FROM t_prd_product_option_groups WHERE prd_cd='PRD_000100' AND opt_grp_cd='OPT_000079'
UNION ALL SELECT 'options', count(*) FROM t_prd_product_options WHERE prd_cd='PRD_000100' AND opt_grp_cd='OPT_000079';
-- 기대: group 1 / options 3

-- COMMIT;
ROLLBACK;
-- UNDO: DELETE FROM t_prd_product_options WHERE prd_cd='PRD_000100' AND opt_grp_cd='OPT_000079';
--       DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000100' AND opt_grp_cd='OPT_000079';
