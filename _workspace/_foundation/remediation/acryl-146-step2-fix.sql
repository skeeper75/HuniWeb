-- acryl-146-step2-fix.sql — 146 아크릴키링 옵션 완전성 (고리없음·은색구슬줄 + 볼체인) (라이브 COMMIT 후보)
-- Step1(acryl-146-keyring): 본체+고리(은색1100·금색1200) 재바인딩 PRF_ACRYL_KEYRING 완료.
-- Step2(본 파일): ① 고리 그룹(OPT-000012)에 고리없음(0)·은색구슬줄(300) 옵션+단가행 보강
--                 ② 볼체인 추가상품(신규 comp+그룹·선택안함0·색8종 각1000) → PRF_ACRYL_KEYRING disp3 배선.
-- 권위: 상품마스터 아크릴 시트 146(고리없음·은색구슬줄·은색고리·금색고리 / 볼체인 선택안함+8색) + 가격표 B04b. 단가 verbatim.
-- 채번(언더스코어 표준·C트랙 정합): opt_grp OPT_000079 · opt OPV_000473~483 · comp_price_id 39087~39097.
-- search-before-mint: 볼체인 자재 MAT_000202~209(오렌지/핑크/핫핑크/민트그린/블루/바이올렛/블랙/화이트) 재사용. KEYRING comp 재사용(단가행만 보강).
-- 동시선택: 고리 ∥ 볼체인 = 별 그룹·별 comp 합산(상품마스터 별 컬럼·골든 G1 5200 정합). [[base-master-code-no-delete]].
-- 멱등: NOT EXISTS 가드. 단일 트랜잭션. FK 위상순. ★실 COMMIT은 인간 승인 후. dryrun=ROLLBACK+골든.
\set ON_ERROR_STOP on
BEGIN;

-- ============================================================
-- [0] 볼체인 자재 8색을 146에 등록 (트리거 fn_chk_opt_item_ref 선결 · 마스터 코드 재사용)
-- ============================================================
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, del_yn)
SELECT 'PRD_000146', v.mat_cd, 'USAGE.07', 'N', v.disp_seq, 'N'
FROM (VALUES
  ('MAT_000202',10),('MAT_000203',11),('MAT_000204',12),('MAT_000205',13),
  ('MAT_000206',14),('MAT_000207',15),('MAT_000208',16),('MAT_000209',17)
) AS v(mat_cd, disp_seq)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_materials
  WHERE prd_cd='PRD_000146' AND mat_cd=v.mat_cd AND usage_cd='USAGE.07'
);

-- ============================================================
-- [1] 볼체인 옵션그룹 (택1·비필수 · 고리 그룹과 별축=동시선택)
-- ============================================================
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000146','OPT_000079','볼체인','SEL_TYPE.01',0,1,'N',2,'Y','N'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000146' AND opt_grp_cd='OPT_000079'
);

-- ============================================================
-- [2] 옵션 — 고리 그룹 보강(고리없음·은색구슬줄) + 볼체인 그룹(선택안함+8색)
-- ============================================================
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000146', v.opt_cd, v.opt_grp_cd, v.opt_nm, 'N', v.disp_seq, 'Y', 'N'
FROM (VALUES
  -- 고리 그룹(OPT-000012) 보강: 은색고리(disp1)·금색고리(disp2) 기존
  ('OPV_000473','OPT-000012','고리없음',3),
  ('OPV_000474','OPT-000012','은색구슬줄',4),
  -- 볼체인 그룹(OPT_000079)
  ('OPV_000475','OPT_000079','선택안함',1),
  ('OPV_000476','OPT_000079','오렌지',2),
  ('OPV_000477','OPT_000079','핑크',3),
  ('OPV_000478','OPT_000079','핫핑크',4),
  ('OPV_000479','OPT_000079','민트그린',5),
  ('OPV_000480','OPT_000079','블루',6),
  ('OPV_000481','OPT_000079','바이올렛',7),
  ('OPV_000482','OPT_000079','블랙',8),
  ('OPV_000483','OPT_000079','화이트',9)
) AS v(opt_cd, opt_grp_cd, opt_nm, disp_seq)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options o WHERE o.prd_cd='PRD_000146' AND o.opt_cd=v.opt_cd
);

-- ============================================================
-- [3] 옵션아이템 — 볼체인 8색만 자재 ref(고리없음·은색구슬줄·선택안함=무자재 가산=item 없음)
--     트리거 fn_chk_opt_item_ref: (prd_cd,mat_cd,usage_cd) EXISTS([0]에서 선등록).
-- ============================================================
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn)
SELECT 'PRD_000146', v.opt_cd, 1, 'OPT_REF_DIM.03', v.mat_cd, 'USAGE.07', NULL, 'Y', 'N'
FROM (VALUES
  ('OPV_000476','MAT_000202'),('OPV_000477','MAT_000203'),('OPV_000478','MAT_000204'),
  ('OPV_000479','MAT_000205'),('OPV_000480','MAT_000206'),('OPV_000481','MAT_000207'),
  ('OPV_000482','MAT_000208'),('OPV_000483','MAT_000209')
) AS v(opt_cd, mat_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items i
  WHERE i.prd_cd='PRD_000146' AND i.opt_cd=v.opt_cd AND i.item_seq=1
);

-- ============================================================
-- [4] 볼체인 가산 comp (단가형 · use_dims opt_cd 보유=always-add 가드)
-- ============================================================
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT 'COMP_ACRYL_KEYRING_BALLCHAIN','키링 볼체인','PRC_COMPONENT_TYPE.04','PRICE_TYPE.01',
       jsonb_build_array('opt_cd','min_qty','opt_grp:OPT_000079'),'Y','N'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_KEYRING_BALLCHAIN'
);

-- ============================================================
-- [5] 단가행 — KEYRING 보강 2(고리없음0·은색구슬줄300) + BALLCHAIN 9(선택안함0·8색 각1000)
-- ============================================================
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, opt_cd, min_qty, unit_price)
SELECT v.comp_price_id, v.comp_cd, '2026-06-28', v.opt_cd, 1, v.unit_price
FROM (VALUES
  (39087::bigint,'COMP_ACRYL_KEYRING',          'OPV_000473',   0::numeric),
  (39088,        'COMP_ACRYL_KEYRING',          'OPV_000474', 300),
  (39089,        'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000475',   0),
  (39090,        'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000476',1000),
  (39091,        'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000477',1000),
  (39092,        'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000478',1000),
  (39093,        'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000479',1000),
  (39094,        'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000480',1000),
  (39095,        'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000481',1000),
  (39096,        'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000482',1000),
  (39097,        'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000483',1000)
) AS v(comp_price_id, comp_cd, opt_cd, unit_price)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices p
  WHERE p.comp_cd=v.comp_cd AND p.opt_cd=v.opt_cd AND p.apply_ymd='2026-06-28'
);

-- ============================================================
-- [6] PRF_ACRYL_KEYRING 에 볼체인 comp 배선 (disp3 addtn Y · 본체1/고리2 기존)
-- ============================================================
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_ACRYL_KEYRING','COMP_ACRYL_KEYRING_BALLCHAIN',3,'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_ACRYL_KEYRING' AND comp_cd='COMP_ACRYL_KEYRING_BALLCHAIN'
);

COMMIT;
