-- =====================================================================
-- step 06 — t_prd_product_option_groups
-- OG-GAGONG·OG-CHUGA 2행. sel_typ=SEL_TYPE.01 단일. PK=(prd_cd,opt_grp_cd) → ON CONFLICT DO NOTHING
-- 멱등: 재실행 시 0행 변경. 손편집 금지(gen_load_sql.py 생성).
-- reg_dt 명시 생략→DEFAULT now() 발화(round-5 교훈: 명시 NULL 은 DEFAULT 미발화).
-- =====================================================================
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OG-GAGONG', '가공', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', '가공 택1 필수 (열재단 기본). sel_typ 근거=가격표 B26 J/K 단일컬럼 캐스케이드 한셀=한값 (CONFIRM-MULTI: 타공+봉미싱 등 복수가공 가능시 SEL_TYPE.02 정정, Red pcs type checkbox 존재). v2 동일', now())
ON CONFLICT (prd_cd, opt_grp_cd) DO NOTHING;
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OG-CHUGA', '추가', 'SEL_TYPE.01', 0, 1, 'N', 2, 'Y', '추가 택1 선택 (추가없음 센티넬 기본 min0). sel_typ 근거=가격표 B26 M/N 단일컬럼 (CONFIRM-MULTI: 큐방+각목 등 복수거치 가능시 SEL_TYPE.02). v2 동일', now())
ON CONFLICT (prd_cd, opt_grp_cd) DO NOTHING;
