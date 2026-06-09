-- =====================================================================
-- step 05 — t_prd_product_option_groups (OPT_000003 가공 · OPT_000004 추가)
-- 멱등 가드 = (prd_cd, opt_grp_nm) NOT EXISTS. 코드=라이브 MAX(OPT-000002)+1 → OPT_000003+(`_` 통일·D3).
--   기존 OPT-000002 각목추가=del_yn='Y' 소프트삭제 → 이름 가공/추가와 무관(충돌 0).
-- 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPT_000003', '가공', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '가공 택1 필수 (열재단 기본). sel_typ=SEL_TYPE.01 단일 (가격표 B26 J/K 단일컬럼 캐스케이드). v2 BUNDLE.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000138' AND opt_grp_nm = '가공' AND del_yn = 'N');
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)
SELECT 'PRD_000138', 'OPT_000004', '추가', 'SEL_TYPE.01', 0, 1, 'N', 2, 'Y', '추가 택1 선택 (추가없음 센티넬 기본 min0). sel_typ=SEL_TYPE.01 (가격표 B26 M/N 단일컬럼). v2 BUNDLE.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd = 'PRD_000138' AND opt_grp_nm = '추가' AND del_yn = 'N');
