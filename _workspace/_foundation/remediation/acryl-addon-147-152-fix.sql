-- acryl-addon-147-152-fix.sql — 아크릴 addon 5상품 CPQ 옵션층 + 가산공식 멱등 적재본 (라이브 COMMIT 후보)
-- 대상: 147 마그넷 · 148 뱃지 · 149 집게 · 150 스마트톡 · 152 명찰.
-- 설계 권위: huni-price-engine-design/03_design/acrylic-addon-design.md + validator GO(조건부).
-- 단가 verbatim(가격표 B04b)·본체 COMP_ACRYL_CLEAR3T(MAT_043 면적) 재사용·공유 comp/공식 미터치([[base-master-code-no-delete]]).
-- 채번(라이브 2026-06-28 실측 MAX+1·언더스코어): opt_grp OPT_000074~78 · opt OPV_000465~72 · comp_price_id 39078~85.
-- 멱등: 전부 NOT EXISTS / ON CONFLICT 가드. 단일 트랜잭션. FK 위상순.
-- ★실 COMMIT은 인간 승인 후. dryrun(acryl-addon-147-152-dryrun.sql)은 ROLLBACK+골든 어서션.
BEGIN;

-- ============================================================
-- [0] product_material 보강 (트리거 fn_chk_opt_item_ref 무결성 선결)
--     147 마그넷 MAT_000050(네오디움자석) 미등록 → 옵션아이템 ref 전 선등록. (148~152는 등록 완료.)
-- ============================================================
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, del_yn)
SELECT 'PRD_000147','MAT_000050','USAGE.07','N',2,'N'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_materials
  WHERE prd_cd='PRD_000147' AND mat_cd='MAT_000050' AND usage_cd='USAGE.07'
);

-- ============================================================
-- [1] 가공 옵션그룹 (택1·비필수 = SEL_TYPE.01 min0 max1 mand_yn N)
-- ============================================================
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn)
SELECT v.prd_cd, v.opt_grp_cd, v.opt_grp_nm, 'SEL_TYPE.01', 0, 1, 'N', 1, 'Y', 'N'
FROM (VALUES
  ('PRD_000147','OPT_000074','자석부착'),
  ('PRD_000148','OPT_000075','부속'),
  ('PRD_000149','OPT_000076','집게'),
  ('PRD_000150','OPT_000077','바디'),
  ('PRD_000152','OPT_000078','부속')
) AS v(prd_cd, opt_grp_cd, opt_grp_nm)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups g
  WHERE g.prd_cd=v.prd_cd AND g.opt_grp_cd=v.opt_grp_cd
);

-- ============================================================
-- [2] 옵션 (dflt_yn N·disp_seq 순차)
-- ============================================================
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT v.prd_cd, v.opt_cd, v.opt_grp_cd, v.opt_nm, 'N', v.disp_seq, 'Y', 'N'
FROM (VALUES
  ('PRD_000147','OPV_000465','OPT_000074','자석부착',1),
  ('PRD_000148','OPV_000466','OPT_000075','원형핀',1),
  ('PRD_000148','OPV_000467','OPT_000075','1구자석',2),
  ('PRD_000149','OPV_000468','OPT_000076','투명집게',1),
  ('PRD_000150','OPV_000469','OPT_000077','화이트바디',1),
  ('PRD_000150','OPV_000470','OPT_000077','투명바디',2),
  ('PRD_000152','OPV_000471','OPT_000078','일자핀',1),
  ('PRD_000152','OPV_000472','OPT_000078','2구자석',2)
) AS v(prd_cd, opt_cd, opt_grp_cd, opt_nm, disp_seq)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options o
  WHERE o.prd_cd=v.prd_cd AND o.opt_cd=v.opt_cd
);

-- ============================================================
-- [3] 옵션아이템 (ref_dim_cd=OPT_REF_DIM.03 자재·ref_key1=부속mat·ref_key2=USAGE.07·item_seq=1)
--     트리거 fn_chk_opt_item_ref가 t_prd_product_materials(prd_cd,mat_cd,usage_cd) EXISTS 검사.
-- ============================================================
INSERT INTO t_prd_product_option_items
  (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn)
SELECT v.prd_cd, v.opt_cd, 1, 'OPT_REF_DIM.03', v.mat_cd, 'USAGE.07', NULL, 'Y', 'N'
FROM (VALUES
  ('PRD_000147','OPV_000465','MAT_000050'),
  ('PRD_000148','OPV_000466','MAT_000047'),
  ('PRD_000148','OPV_000467','MAT_000048'),
  ('PRD_000149','OPV_000468','MAT_000056'),
  ('PRD_000150','OPV_000469','MAT_000054'),
  ('PRD_000150','OPV_000470','MAT_000053'),
  ('PRD_000152','OPV_000471','MAT_000046'),
  ('PRD_000152','OPV_000472','MAT_000049')
) AS v(prd_cd, opt_cd, mat_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items i
  WHERE i.prd_cd=v.prd_cd AND i.opt_cd=v.opt_cd AND i.item_seq=1
);

-- ============================================================
-- [4] 가산 comp (단가형 PRICE_TYPE.01 · comp_typ PRC_COMPONENT_TYPE.04 · use_dims에 opt_cd 보유=always-add 가드)
-- ============================================================
INSERT INTO t_prc_price_components
  (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT v.comp_cd, v.comp_nm, 'PRC_COMPONENT_TYPE.04', 'PRICE_TYPE.01',
       jsonb_build_array('opt_cd','min_qty','opt_grp:'||v.opt_grp_cd), 'Y', 'N'
FROM (VALUES
  ('COMP_ACRYL_MAGNET','마그넷 자석부착','OPT_000074'),
  ('COMP_ACRYL_BADGE','뱃지 부속','OPT_000075'),
  ('COMP_ACRYL_CLIP','집게 부속','OPT_000076'),
  ('COMP_ACRYL_SMARTTOK','스마트톡 바디','OPT_000077'),
  ('COMP_ACRYL_NAMETAG_PIN','명찰 부속','OPT_000078')
) AS v(comp_cd, comp_nm, opt_grp_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_price_components c WHERE c.comp_cd=v.comp_cd
);

-- ============================================================
-- [5] 단가행 (comp_price_id 명시 채번·apply_ymd=2026-06-28·opt_cd→unit_price verbatim·min_qty=1)
-- ============================================================
INSERT INTO t_prc_component_prices
  (comp_price_id, comp_cd, apply_ymd, opt_cd, min_qty, unit_price)
SELECT v.comp_price_id, v.comp_cd, '2026-06-28', v.opt_cd, 1, v.unit_price
FROM (VALUES
  (39078::bigint,'COMP_ACRYL_MAGNET',   'OPV_000465', 800::numeric),
  (39079,        'COMP_ACRYL_BADGE',    'OPV_000466', 600),
  (39080,        'COMP_ACRYL_BADGE',    'OPV_000467', 1000),
  (39081,        'COMP_ACRYL_CLIP',     'OPV_000468', 700),
  (39082,        'COMP_ACRYL_SMARTTOK', 'OPV_000469', 2600),
  (39083,        'COMP_ACRYL_SMARTTOK', 'OPV_000470', 3000),
  (39084,        'COMP_ACRYL_NAMETAG_PIN','OPV_000471', 700),
  (39085,        'COMP_ACRYL_NAMETAG_PIN','OPV_000472', 1700)
) AS v(comp_price_id, comp_cd, opt_cd, unit_price)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices p
  WHERE p.comp_cd=v.comp_cd AND p.opt_cd=v.opt_cd AND p.apply_ymd='2026-06-28'
);

-- ============================================================
-- [6] 전용공식 (PRF_ACRYL_* · 본체 comp 재사용 disp1 addtn N + 가산 comp disp2 addtn Y)
-- ============================================================
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT v.frm_cd, v.frm_nm, '본체 면적 + 가공 가산(addon)', 'Y'
FROM (VALUES
  ('PRF_ACRYL_MAGNET','아크릴마그넷 공식'),
  ('PRF_ACRYL_BADGE','아크릴뱃지 공식'),
  ('PRF_ACRYL_CLIP','아크릴집게 공식'),
  ('PRF_ACRYL_SMARTTOK','아크릴스마트톡 공식'),
  ('PRF_ACRYL_NAMETAG','아크릴명찰 공식')
) AS v(frm_cd, frm_nm)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd=v.frm_cd
);

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT v.frm_cd, v.comp_cd, v.disp_seq, v.addtn_yn
FROM (VALUES
  ('PRF_ACRYL_MAGNET','COMP_ACRYL_CLEAR3T',1,'N'),
  ('PRF_ACRYL_MAGNET','COMP_ACRYL_MAGNET',2,'Y'),
  ('PRF_ACRYL_BADGE','COMP_ACRYL_CLEAR3T',1,'N'),
  ('PRF_ACRYL_BADGE','COMP_ACRYL_BADGE',2,'Y'),
  ('PRF_ACRYL_CLIP','COMP_ACRYL_CLEAR3T',1,'N'),
  ('PRF_ACRYL_CLIP','COMP_ACRYL_CLIP',2,'Y'),
  ('PRF_ACRYL_SMARTTOK','COMP_ACRYL_CLEAR3T',1,'N'),
  ('PRF_ACRYL_SMARTTOK','COMP_ACRYL_SMARTTOK',2,'Y'),
  ('PRF_ACRYL_NAMETAG','COMP_ACRYL_CLEAR3T',1,'N'),
  ('PRF_ACRYL_NAMETAG','COMP_ACRYL_NAMETAG_PIN',2,'Y')
) AS v(frm_cd, comp_cd, disp_seq, addtn_yn)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components fc
  WHERE fc.frm_cd=v.frm_cd AND fc.comp_cd=v.comp_cd
);

-- ============================================================
-- [7] 상품-공식 바인딩 (apply_bgn_ymd=2026-06-28)
-- ============================================================
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT v.prd_cd, v.frm_cd, '2026-06-28', 'addon — 본체+가공 가산'
FROM (VALUES
  ('PRD_000147','PRF_ACRYL_MAGNET'),
  ('PRD_000148','PRF_ACRYL_BADGE'),
  ('PRD_000149','PRF_ACRYL_CLIP'),
  ('PRD_000150','PRF_ACRYL_SMARTTOK'),
  ('PRD_000152','PRF_ACRYL_NAMETAG')
) AS v(prd_cd, frm_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas pf
  WHERE pf.prd_cd=v.prd_cd AND pf.apply_bgn_ymd='2026-06-28'
);

COMMIT;
