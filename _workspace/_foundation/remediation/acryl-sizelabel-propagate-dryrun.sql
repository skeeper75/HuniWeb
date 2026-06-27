-- acryl-sizelabel-propagate-fix.sql — 사이즈 라벨 옵션 4종 전파 (159 동형·저청구 교정·라이브 COMMIT 후보)
-- 159 코스터 파일럿 라이브 GO(2500→12700). 동형 전파: 157 네임택·158 포카키링·161 판아크릴·162 포카스탠드.
-- 각 등록사이즈를 라벨 옵션(OPT_REF_DIM.01 siz_cd)으로 → 손님 택1 → 면적격자(CLEAR3T) 환원 계산. 격자 20~200 전부 커버.
-- 채번 OPT_000075~078·OPV_000467~472(언더스코어·159가 OPT_000074/OPV_465~466). 본체 바인딩(PRF_CLR_ACRYL)·격자 미터치.
-- ★실 COMMIT은 인간 승인 후·라이브 시뮬레이터 실증.
\set ON_ERROR_STOP on
BEGIN;

-- [1] 사이즈 옵션그룹 (필수 택1)
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn)
SELECT v.prd_cd, v.opt_grp_cd, '사이즈', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', 'N'
FROM (VALUES
  ('PRD_000157','OPT_000075'),('PRD_000158','OPT_000076'),
  ('PRD_000161','OPT_000077'),('PRD_000162','OPT_000078')
) AS v(prd_cd, opt_grp_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups g WHERE g.prd_cd=v.prd_cd AND g.opt_grp_cd=v.opt_grp_cd);

-- [2] 옵션 (등록사이즈 라벨·첫번째 dflt)
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT v.prd_cd, v.opt_cd, v.opt_grp_cd, v.opt_nm, v.dflt, v.disp_seq, 'Y', 'N'
FROM (VALUES
  ('PRD_000157','OPV_000467','OPT_000075','55x86','Y',1),
  ('PRD_000157','OPV_000468','OPT_000075','60x60','N',2),
  ('PRD_000158','OPV_000469','OPT_000076','55x86','Y',1),
  ('PRD_000161','OPV_000470','OPT_000077','120x120','Y',1),
  ('PRD_000161','OPV_000471','OPT_000077','120x180','N',2),
  ('PRD_000162','OPV_000472','OPT_000078','68x103','Y',1)
) AS v(prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt, disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options o WHERE o.prd_cd=v.prd_cd AND o.opt_cd=v.opt_cd);

-- [3] 옵션아이템 (OPT_REF_DIM.01 siz_cd → 면적격자 환원)
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, qty, use_yn, del_yn)
SELECT v.prd_cd, v.opt_cd, 1, 'OPT_REF_DIM.01', v.siz_cd, NULL, 'Y', 'N'
FROM (VALUES
  ('PRD_000157','OPV_000467','SIZ_000012'),('PRD_000157','OPV_000468','SIZ_000148'),
  ('PRD_000158','OPV_000469','SIZ_000012'),
  ('PRD_000161','OPV_000470','SIZ_000359'),('PRD_000161','OPV_000471','SIZ_000361'),
  ('PRD_000162','OPV_000472','SIZ_000364')
) AS v(prd_cd, opt_cd, siz_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items i WHERE i.prd_cd=v.prd_cd AND i.opt_cd=v.opt_cd AND i.item_seq=1);

\echo '== 구조: 4종 옵션그룹/옵션/siz_cd ref =='
SELECT o.prd_cd, o.opt_cd, o.opt_nm, i.ref_key1 FROM t_prd_product_options o JOIN t_prd_product_option_items i USING(prd_cd,opt_cd) WHERE o.prd_cd IN('PRD_000157','PRD_000158','PRD_000161','PRD_000162') AND o.opt_cd BETWEEN 'OPV_000467' AND 'OPV_000472' ORDER BY o.prd_cd, o.disp_seq;
ROLLBACK;
