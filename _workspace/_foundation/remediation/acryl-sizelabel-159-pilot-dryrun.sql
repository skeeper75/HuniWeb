-- acryl-sizelabel-159-pilot-fix.sql — 159 코스터 사이즈 라벨 옵션 파일럿 (저청구 교정·라이브 COMMIT 후보)
-- 결함: 159 면적격자 본체(CLEAR3T·siz_width/height)인데 nonspec_yn=N·siz_cd 차원 부재 → 시뮬레이터 사이즈 입력 없음 → 최소셀(2500) 저청구.
--   실제 등록사이즈=100x100(원형/사각)·정답가=12,700. (코스터 2500 = ~5배 저청구.)
-- 교정(굿즈230 동형·OPT_REF_DIM.01): 사이즈 라벨 옵션그룹 추가 → 손님 택1 → _opt_maps dims[siz_cd] → _reduce_siz_dims cut→면적격자 매칭.
-- 본체 바인딩(PRF_CLR_ACRYL)·자재(MAT_043)·격자 미터치. 채번 OPT_000074·OPV_000465~466(언더스코어).
-- 트리거 fn_chk_opt_item_ref: OPT_REF_DIM.01은 siz_cd 참조 → t_prd_product_sizes EXISTS 검사(이미 등록).
-- ★실 COMMIT은 인간 승인 후·라이브 시뮬레이터 실증.
\set ON_ERROR_STOP on
BEGIN;

-- [1] 사이즈 옵션그룹 (필수 택1)
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000159','OPT_000074','사이즈','SEL_TYPE.01',1,1,'Y',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000159' AND opt_grp_cd='OPT_000074');

-- [2] 옵션 (등록사이즈 = 손님 라벨·첫번째 dflt)
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT v.prd_cd, v.opt_cd, 'OPT_000074', v.opt_nm, v.dflt, v.disp_seq, 'Y', 'N'
FROM (VALUES
  ('PRD_000159','OPV_000465','100x100 원형','Y',1),
  ('PRD_000159','OPV_000466','100x100 사각','N',2)
) AS v(prd_cd, opt_cd, opt_nm, dflt, disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options o WHERE o.prd_cd=v.prd_cd AND o.opt_cd=v.opt_cd);

-- [3] 옵션아이템 (ref_dim_cd=OPT_REF_DIM.01 siz_cd → 면적격자 환원)
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, qty, use_yn, del_yn)
SELECT 'PRD_000159', v.opt_cd, 1, 'OPT_REF_DIM.01', v.siz_cd, NULL, 'Y', 'N'
FROM (VALUES ('OPV_000465','SIZ_000355'),('OPV_000466','SIZ_000356')) AS v(opt_cd, siz_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items i WHERE i.prd_cd='PRD_000159' AND i.opt_cd=v.opt_cd AND i.item_seq=1);

\echo '== 구조: 옵션그룹/옵션/아이템(siz_cd ref) =='
SELECT g.opt_grp_cd, g.mand_yn, o.opt_cd, o.opt_nm, i.ref_dim_cd, i.ref_key1
FROM t_prd_product_option_groups g
JOIN t_prd_product_options o ON o.prd_cd=g.prd_cd AND o.opt_grp_cd=g.opt_grp_cd
JOIN t_prd_product_option_items i ON i.prd_cd=o.prd_cd AND i.opt_cd=o.opt_cd
WHERE g.prd_cd='PRD_000159' AND g.opt_grp_cd='OPT_000074' ORDER BY o.disp_seq;
ROLLBACK;
\echo '== ROLLBACK =='
