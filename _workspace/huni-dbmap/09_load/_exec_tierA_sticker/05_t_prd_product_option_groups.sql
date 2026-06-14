-- =====================================================================
-- step 05 — t_prd_product_option_groups (스티커 4상품 · 12행)
-- 멱등 가드 = (prd_cd, opt_grp_nm, del_yn='N') NOT EXISTS. 코드=라이브 MAX(OPT-000005)+1 → OPT_000006~ (`_` 통일·D3).
--   066 죽은 stub OPT-000004 원형(del_yn=Y)·고아 OPV-000006 과 무관(이름검사 가드, 충돌 0).
-- 트리거 없음. reg_dt 생략→DEFAULT now(). use_yn/del_yn NOT NULL. 손편집 금지.
-- disp_seq = L1 옵션성 컬럼순서(종이1·인쇄2·화이트별색3·커팅4).
-- =====================================================================

-- ===== PRD_000052 반칼 자유형 스티커 (종이5·인쇄·커팅) =====
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000052','OPT_000006','종이','SEL_TYPE.01',1,1,'Y',1,'Y','N','종이(자재) 택1 필수. 코팅=자재 흡수(무광/유광코팅스티커=mat 행·스티커 예외 S1).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='종이' AND del_yn='N');
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000052','OPT_000007','인쇄','SEL_TYPE.01',1,1,'Y',2,'Y','N','인쇄(도수) 택1 필수. 단면 단일(opt_id=1). GAP-HIDDEN 후보(C-S1).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='인쇄' AND del_yn='N');
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000052','OPT_000008','커팅','SEL_TYPE.01',1,1,'Y',4,'Y','N','커팅(공정) 택1 필수. 반칼 PROC_000054.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000052' AND opt_grp_nm='커팅' AND del_yn='N');

-- ===== PRD_000053 반칼 자유형 투명스티커 (종이·인쇄·화이트별색·커팅) =====
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000053','OPT_000009','종이','SEL_TYPE.01',1,1,'Y',1,'Y','N','종이(자재) 택1 필수. 투명스티커 1종.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='종이' AND del_yn='N');
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000053','OPT_000010','인쇄','SEL_TYPE.01',1,1,'Y',2,'Y','N','인쇄(도수) 택1 필수. 단면 단일(opt_id=1).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='인쇄' AND del_yn='N');
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000053','OPT_000011','화이트별색','SEL_TYPE.01',0,1,'N',3,'Y','N','화이트별색(공정) 택1 선택. 화이트 PROC_000008(L1 화이트인쇄(단면))·화이트없음 센티넬. 별색=공정 정합(C-S5).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='화이트별색' AND del_yn='N');
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000053','OPT_000012','커팅','SEL_TYPE.01',1,1,'Y',4,'Y','N','커팅(공정) 택1 필수. 반칼 PROC_000054.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000053' AND opt_grp_nm='커팅' AND del_yn='N');

-- ===== PRD_000055 낱장 자유형 스티커 (종이·인쇄·커팅) =====
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000055','OPT_000013','종이','SEL_TYPE.01',1,1,'Y',1,'Y','N','종이(자재) 택1 필수. 유포지 1종.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000055' AND opt_grp_nm='종이' AND del_yn='N');
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000055','OPT_000014','인쇄','SEL_TYPE.01',1,1,'Y',2,'Y','N','인쇄(도수) 택1 필수. 단면 단일(opt_id=1).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000055' AND opt_grp_nm='인쇄' AND del_yn='N');
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000055','OPT_000015','커팅','SEL_TYPE.01',1,1,'Y',4,'Y','N','커팅(공정) 택1 필수. 완칼 PROC_000053.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000055' AND opt_grp_nm='커팅' AND del_yn='N');

-- ===== PRD_000066 합판도무송스티커 (종이6·인쇄) — 커팅 OG 미생성(형상=siz 융합 S3) =====
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000066','OPT_000016','종이','SEL_TYPE.01',1,1,'Y',1,'Y','N','종이(자재) 택1 필수. 6종. 죽은 stub OPT-000004(del Y) 무관 신규.'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='종이' AND del_yn='N');
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note)
SELECT 'PRD_000066','OPT_000017','인쇄','SEL_TYPE.01',1,1,'Y',2,'Y','N','인쇄(도수) 택1 필수. 단면 단일(opt_id=1). 커팅=형상별 도무송=사이즈선택(OG 미생성 S3).'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000066' AND opt_grp_nm='인쇄' AND del_yn='N');
