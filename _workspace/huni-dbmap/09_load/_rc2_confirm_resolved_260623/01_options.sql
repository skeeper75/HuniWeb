-- 01_options.sql — CONFIRM-C 족자 천정고리 신규 옵션 (멱등 INSERT·NOT EXISTS 가드)
-- 대상: t_prd_product_options  PK=(prd_cd, opt_cd)
-- 신규 opt_cd=OPV_000431 (라이브 MAX=OPV_000430·충돌 0 실측). 기존 그룹 OPT_000016(추가·SEL_TYPE.01) 재사용.
-- search-before-mint: 신규 그룹 0건(기존 추가그룹 재사용). reg_dt=DEFAULT now().
-- src: rc2-confirm-resolved-load-spec §3.2 (권위 엑셀 "천정형고리 포함" verbatim)

INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000135', 'OPV_000431', 'OPT_000016', '천정형고리 포함', 'N', 2, 'Y', 'N'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options
   WHERE prd_cd = 'PRD_000135' AND opt_cd = 'OPV_000431'
);

-- [린넨·타공은 옵션 이미 완비·신규 0건]
-- [option_item 환원행 = 본 3건 전부 HOLD (린넨 환원 불요·타공 환원 이미 존재·족자 HOLD-C-ITEM 자재 미등록). 신규 환원행 0]
