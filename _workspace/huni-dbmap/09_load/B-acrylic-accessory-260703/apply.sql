-- B그룹 아크릴 부속 단일옵션 3상품 COMMIT (2026-07-03) — 항상 포함(사용자 확정)
--  마그넷(147)·집게(149)·머리끈(154). 라벨 명확분만. 다중옵션(148뱃지·150스마트톡·152명찰)=보류.
-- 전용공식(본체 CLEAR3T + 부속comp) 실재·배선완료 → 옵션그룹+옵션 재생성 + 공식 재바인딩.
-- 부속 단가행: 자석 OPV_000465=800·집게 OPV_000468=700·머리끈 OPV-000028=500 (opt_cd 매칭).
BEGIN;

-- 옵션그룹 (mand=Y·SEL_TYPE.01·단일 → 항상 포함)
INSERT INTO t_prd_product_option_groups
 (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES
 ('PRD_000147','OPT_000074','자석',  'SEL_TYPE.01',1,1,'Y',1,'Y','N',now()),
 ('PRD_000149','OPT_000076','집게',  'SEL_TYPE.01',1,1,'Y',1,'Y','N',now()),
 ('PRD_000154','OPT-000014','헤어끈','SEL_TYPE.01',1,1,'Y',1,'Y','N',now())
ON CONFLICT (prd_cd, opt_grp_cd) DO NOTHING;

-- 옵션 (opt_cd = 부속 단가행 OPV 정확일치)
INSERT INTO t_prd_product_options
 (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES
 ('PRD_000147','OPV_000465','OPT_000074','자석부착',  'Y',1,'Y','N',now()),
 ('PRD_000149','OPV_000468','OPT_000076','투명집게',  'Y',1,'Y','N',now()),
 ('PRD_000154','OPV-000028','OPT-000014','블랙헤어끈','Y',1,'Y','N',now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;

-- 공식 재바인딩 (본체전용 → 부속 전용공식)
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_MAGNET',   upd_dt=now() WHERE prd_cd='PRD_000147' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_CLIP',     upd_dt=now() WHERE prd_cd='PRD_000149' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_HAIRBAND', upd_dt=now() WHERE prd_cd='PRD_000154' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_CLR_ACRYL';

COMMIT;
