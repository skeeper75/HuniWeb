-- =============================================================================
-- jibbitz156-fix.sql (실 COMMIT본 — 인간 승인 하 2026-07-01·use_yn=N 유지)
-- 아크릴지비츠 PRD_000156 신규출시 가격설계 — 가공(투명200/스핀600) opt_cd × 수량 × DSC_ACR_QTY
-- 설계=design-jibbitz-full-260701.md · 권위정정=jibbitz-authority-correction-260701.md
-- 독립검증: 골든8/8 PASS·dryrun 무결·동형선례(BADGE/KEYRING opt_cd)·DSC_ACR_QTY 권위B04 일치.
-- 채번 라이브 재확인(260701): MAX opt_grp=OPT_000082·opt_cd=OPV_000492·comp_price_id=79165 → 083/493/494/79166/79167 free.
-- undo=jibbitz156-undo.sql · backup=jibbitz156-backup-260701.tsv (incr/dflt_qty=NULL·binding=_TBD·use_yn=N)
-- ★활성화(use_yn N→Y)는 미포함 — 손님 미노출·§7 별도.
-- =============================================================================
BEGIN;

INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
VALUES ('PRF_ZIBITZ_ACRYL','아크릴지비츠 가공단가',
        '가공(투명/스핀) opt_cd 단가 × 수량. 사이즈 무관. 수량할인=DSC_ACR_QTY. §27 배선 260701','Y',now())
ON CONFLICT (frm_cd) DO NOTHING;

INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn, reg_dt)
VALUES ('COMP_ACRYL_ZIBITZ','아크릴지비츠 가공(투명/스핀) 완제품가',NULL,
        'PRICE_TYPE.01','["opt_cd", "min_qty", "opt_grp:OPT_000083"]'::jsonb,'Y','N',now())
ON CONFLICT (comp_cd) DO NOTHING;

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_ZIBITZ_ACRYL','COMP_ACRYL_ZIBITZ',1,'N',now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES ('PRD_000156','OPT_000083','가공','SEL_TYPE.01',1,1,'Y',1,'Y','N',now())
ON CONFLICT (prd_cd, opt_grp_cd) DO NOTHING;

INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES ('PRD_000156','OPV_000493','OPT_000083','투명','Y',1,'Y','N',now()),
       ('PRD_000156','OPV_000494','OPT_000083','스핀','N',2,'Y','N',now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;

INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, opt_cd, min_qty, unit_price, apply_ymd, note, reg_dt)
VALUES (79166,'COMP_ACRYL_ZIBITZ','OPV_000493',1,200,'2026-07-01','가격표 B04 아크릴지비츠 투명',now()),
       (79167,'COMP_ACRYL_ZIBITZ','OPV_000494',1,600,'2026-07-01','가격표 B04 아크릴지비츠 스핀',now())
ON CONFLICT (comp_price_id) DO NOTHING;

UPDATE t_prd_product_price_formulas
   SET frm_cd='PRF_ZIBITZ_ACRYL', upd_dt=now()
 WHERE prd_cd='PRD_000156' AND frm_cd='PRF_ACRYL_ZIBITZ_TBD';

INSERT INTO t_prd_product_discount_tables (prd_cd, dsc_tbl_cd, apply_bgn_ymd, note, reg_dt)
VALUES ('PRD_000156','DSC_ACR_QTY','2026-06-01','아크릴 카테고리 수량구간할인 재사용',now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

UPDATE t_prd_products
   SET nonspec_width_incr=1, nonspec_height_incr=1, dflt_qty=COALESCE(dflt_qty,100), upd_dt=now()
 WHERE prd_cd='PRD_000156';

-- 활성화 미포함(use_yn=N 유지). 런칭 시 §7: UPDATE t_prd_products SET use_yn='Y' WHERE prd_cd='PRD_000156';

COMMIT;
