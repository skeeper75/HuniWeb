-- 굿즈파우치 GB-2 파일럿 — 캔버스 삼각 파우치(PRD_000240) variant 고정가 공식식 종단
-- 방향2(현수막식): base 구성요소 grid(use_dims=[siz_cd]·PRICE_TYPE.01·verbatim) + CPQ 옵션(사이즈 M/L) + 오적재 자재 정리.
-- 권위 = 상품마스터 260702 엑셀 verbatim(M 9,800 / L 11,500). 값=스크립트 도출. 멱등.
-- 공유 자산(전 33 variant 전파용): PRF_GOODS_FIXED_SIZ · COMP_GOODS_FIXED_SIZ.
\set ON_ERROR_STOP on
BEGIN;

\echo '=== PRE: 240 현황(formula/sizes/optgrp/active_mat) ==='
SELECT
 (SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000240') formula,
 (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000240' AND del_yn='N') sizes,
 (SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000240' AND del_yn='N') optgrp,
 (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000240' AND del_yn='N') active_mat;

-- 1) siz mint 2 (등급·치수 없음)
INSERT INTO t_siz_sizes (siz_cd, siz_nm, impos_yn, use_yn, del_yn, reg_dt) VALUES
 ('SIZ_000562','캔버스 삼각 파우치 M','N','Y','N',now()),
 ('SIZ_000563','캔버스 삼각 파우치 L','N','Y','N',now())
ON CONFLICT (siz_cd) DO UPDATE SET siz_nm=EXCLUDED.siz_nm, use_yn='Y', del_yn='N';

-- 2) product_sizes (트리거 OPT_REF_DIM.01 선행 요건)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, del_yn, reg_dt) VALUES
 ('PRD_000240','SIZ_000562','Y','N',now()),
 ('PRD_000240','SIZ_000563','N','N',now())
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET dflt_yn=EXCLUDED.dflt_yn, del_yn='N';

-- 3) 공식(공유)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, reg_dt) VALUES
 ('PRF_GOODS_FIXED_SIZ','굿즈 사이즈등급 고정가','Y',now())
ON CONFLICT (frm_cd) DO UPDATE SET frm_nm=EXCLUDED.frm_nm, use_yn='Y';

-- 4) 구성요소(공유·사이즈별 완제품가·단가형)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, prc_typ_cd, use_dims, use_yn, del_yn, reg_dt) VALUES
 ('COMP_GOODS_FIXED_SIZ','굿즈 사이즈별 완제품가','PRICE_TYPE.01','["siz_cd"]','Y','N',now())
ON CONFLICT (comp_cd) DO UPDATE SET comp_nm=EXCLUDED.comp_nm, prc_typ_cd=EXCLUDED.prc_typ_cd, use_dims=EXCLUDED.use_dims, use_yn='Y', del_yn='N';

-- 5) 배선
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES
 ('PRF_GOODS_FIXED_SIZ','COMP_GOODS_FIXED_SIZ',1,'N',now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- 6) 단가행 2 (verbatim·comp_price_id IDENTITY 자동·멱등 위해 DELETE 후 INSERT)
DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_GOODS_FIXED_SIZ' AND siz_cd IN('SIZ_000562','SIZ_000563') AND apply_ymd='2026-07-03';
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, unit_price, note, reg_dt) VALUES
 ('COMP_GOODS_FIXED_SIZ','2026-07-03','SIZ_000562', 9800,'굿즈 variant 고정가 260704(엑셀 verbatim)',now()),
 ('COMP_GOODS_FIXED_SIZ','2026-07-03','SIZ_000563',11500,'굿즈 variant 고정가 260704(엑셀 verbatim)',now());

-- 7) 상품-공식 바인딩
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, reg_dt) VALUES
 ('PRD_000240','PRF_GOODS_FIXED_SIZ','2026-07-03',now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET frm_cd=EXCLUDED.frm_cd;

-- 8) CPQ 옵션그룹(사이즈·택1·필수)
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, mand_yn, disp_seq, use_yn, del_yn, reg_dt) VALUES
 ('PRD_000240','OPT_000172','사이즈','SEL_TYPE.01','Y',1,'Y','N',now())
ON CONFLICT (prd_cd, opt_grp_cd) DO UPDATE SET opt_grp_nm=EXCLUDED.opt_grp_nm, sel_typ_cd=EXCLUDED.sel_typ_cd, mand_yn='Y', use_yn='Y', del_yn='N';

-- 9) 옵션 2(M 기본·L)
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt) VALUES
 ('PRD_000240','OPV_000667','OPT_000172','M','Y',1,'Y','N',now()),
 ('PRD_000240','OPV_000668','OPT_000172','L','N',2,'Y','N',now())
ON CONFLICT (prd_cd, opt_cd) DO UPDATE SET opt_grp_cd=EXCLUDED.opt_grp_cd, opt_nm=EXCLUDED.opt_nm, dflt_yn=EXCLUDED.dflt_yn, use_yn='Y', del_yn='N';

-- 10) 옵션아이템(ref_dim=사이즈→siz_cd·트리거 검사)
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, use_yn, del_yn, reg_dt) VALUES
 ('PRD_000240','OPV_000667',1,'OPT_REF_DIM.01','SIZ_000562','Y','N',now()),
 ('PRD_000240','OPV_000668',1,'OPT_REF_DIM.01','SIZ_000563','Y','N',now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO UPDATE SET ref_dim_cd=EXCLUDED.ref_dim_cd, ref_key1=EXCLUDED.ref_key1, use_yn='Y', del_yn='N';

-- 11) 오적재 자재 정리(240 링크만 논리삭제·자재 마스터 무접촉·공유 14/13상품 무영향)
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now()
 WHERE prd_cd='PRD_000240' AND mat_cd IN('MAT_000319','MAT_000320') AND usage_cd='USAGE.07';

\echo '=== POST: 240 종단 상태 ==='
SELECT
 (SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000240') formula,
 (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000240' AND del_yn='N') sizes,
 (SELECT count(*) FROM t_prd_product_option_items WHERE prd_cd='PRD_000240' AND del_yn='N') opt_items,
 (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_GOODS_FIXED_SIZ') cp_rows,
 (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000240' AND del_yn='N') active_mat;
\echo '=== POST: 단가행 verbatim(M 9800 / L 11500) ==='
SELECT siz_cd, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_GOODS_FIXED_SIZ' ORDER BY siz_cd;

ROLLBACK;
