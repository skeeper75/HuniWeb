-- acryl-146-step2-dryrun.sql — 146 키링 Step2 적재 DRY-RUN (ROLLBACK 전용·골든)
-- fix 본문 그대로 + 어서션 + ROLLBACK. 라이브 미변경. 종결자=ROLLBACK 확인.
\set ON_ERROR_STOP on
BEGIN;

INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, del_yn)
SELECT 'PRD_000146', v.mat_cd, 'USAGE.07', 'N', v.disp_seq, 'N'
FROM (VALUES ('MAT_000202',10),('MAT_000203',11),('MAT_000204',12),('MAT_000205',13),
             ('MAT_000206',14),('MAT_000207',15),('MAT_000208',16),('MAT_000209',17)) AS v(mat_cd, disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials WHERE prd_cd='PRD_000146' AND mat_cd=v.mat_cd AND usage_cd='USAGE.07');

INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000146','OPT_000079','볼체인','SEL_TYPE.01',0,1,'N',2,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000146' AND opt_grp_cd='OPT_000079');

INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000146', v.opt_cd, v.opt_grp_cd, v.opt_nm, 'N', v.disp_seq, 'Y', 'N'
FROM (VALUES
  ('OPV_000473','OPT-000012','고리없음',3),('OPV_000474','OPT-000012','은색구슬줄',4),
  ('OPV_000475','OPT_000079','선택안함',1),('OPV_000476','OPT_000079','오렌지',2),
  ('OPV_000477','OPT_000079','핑크',3),('OPV_000478','OPT_000079','핫핑크',4),
  ('OPV_000479','OPT_000079','민트그린',5),('OPV_000480','OPT_000079','블루',6),
  ('OPV_000481','OPT_000079','바이올렛',7),('OPV_000482','OPT_000079','블랙',8),
  ('OPV_000483','OPT_000079','화이트',9)
) AS v(opt_cd, opt_grp_cd, opt_nm, disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options o WHERE o.prd_cd='PRD_000146' AND o.opt_cd=v.opt_cd);

INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn)
SELECT 'PRD_000146', v.opt_cd, 1, 'OPT_REF_DIM.03', v.mat_cd, 'USAGE.07', NULL, 'Y', 'N'
FROM (VALUES ('OPV_000476','MAT_000202'),('OPV_000477','MAT_000203'),('OPV_000478','MAT_000204'),
             ('OPV_000479','MAT_000205'),('OPV_000480','MAT_000206'),('OPV_000481','MAT_000207'),
             ('OPV_000482','MAT_000208'),('OPV_000483','MAT_000209')) AS v(opt_cd, mat_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items i WHERE i.prd_cd='PRD_000146' AND i.opt_cd=v.opt_cd AND i.item_seq=1);

INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT 'COMP_ACRYL_KEYRING_BALLCHAIN','키링 볼체인','PRC_COMPONENT_TYPE.04','PRICE_TYPE.01',
       jsonb_build_array('opt_cd','min_qty','opt_grp:OPT_000079'),'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_KEYRING_BALLCHAIN');

INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, opt_cd, min_qty, unit_price)
SELECT v.comp_price_id, v.comp_cd, '2026-06-28', v.opt_cd, 1, v.unit_price
FROM (VALUES
  (39087::bigint,'COMP_ACRYL_KEYRING','OPV_000473',0::numeric),
  (39088,'COMP_ACRYL_KEYRING','OPV_000474',300),
  (39089,'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000475',0),
  (39090,'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000476',1000),(39091,'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000477',1000),
  (39092,'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000478',1000),(39093,'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000479',1000),
  (39094,'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000480',1000),(39095,'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000481',1000),
  (39096,'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000482',1000),(39097,'COMP_ACRYL_KEYRING_BALLCHAIN','OPV_000483',1000)
) AS v(comp_price_id, comp_cd, opt_cd, unit_price)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices p WHERE p.comp_cd=v.comp_cd AND p.opt_cd=v.opt_cd AND p.apply_ymd='2026-06-28');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_ACRYL_KEYRING','COMP_ACRYL_KEYRING_BALLCHAIN',3,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_KEYRING' AND comp_cd='COMP_ACRYL_KEYRING_BALLCHAIN');

-- ============================================================
-- 어서션 (골든 · 본체 CLEAR3T mat_043 + 고리 KEYRING + 볼체인 BALLCHAIN)
-- ============================================================
\echo '== 골든: 146 키링 본체+고리+볼체인 합산 =='
WITH body(sw,sh,p) AS (
  SELECT siz_width, siz_height, unit_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043' AND min_qty=1
), g(label, sw, sh, gori_opt, ball_opt, expect) AS (VALUES
  ('G1  30x30 은색고리+볼체인블랙', 30::numeric,30::numeric,'OPV-000026','OPV_000482',5200::numeric),
  ('G2  30x30 금색고리+선택안함',   30,30,'OPV-000027','OPV_000475',4300),
  ('G3  20x30 고리없음+선택안함',   20,30,'OPV_000473','OPV_000475',2700)
)
SELECT g.label, b.p AS body, k.unit_price AS gori, bc.unit_price AS ball,
       (b.p + k.unit_price + bc.unit_price) AS calc, g.expect,
       CASE WHEN (b.p+k.unit_price+bc.unit_price)=g.expect THEN 'PASS' ELSE 'FAIL' END AS verdict
FROM g
JOIN body b ON b.sw=g.sw AND b.sh=g.sh
JOIN t_prc_component_prices k  ON k.opt_cd=g.gori_opt AND k.comp_cd='COMP_ACRYL_KEYRING'
JOIN t_prc_component_prices bc ON bc.opt_cd=g.ball_opt AND bc.comp_cd='COMP_ACRYL_KEYRING_BALLCHAIN'
ORDER BY g.label;

\echo '== G13 always-add 가드: 미선택 시 본체만(BALLCHAIN/KEYRING use_dims opt_cd 보유) =='
SELECT comp_cd, (use_dims @> '["opt_cd"]'::jsonb) AS has_opt_cd FROM t_prc_price_components
WHERE comp_cd IN ('COMP_ACRYL_KEYRING','COMP_ACRYL_KEYRING_BALLCHAIN') ORDER BY comp_cd;

\echo '== 채번 카운트(자재8·그룹1·옵션11·단가행11·comp1·배선1) =='
SELECT
 (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000146' AND mat_cd BETWEEN 'MAT_000202' AND 'MAT_000209') AS mat,
 (SELECT count(*) FROM t_prd_product_options WHERE prd_cd='PRD_000146' AND opt_cd BETWEEN 'OPV_000473' AND 'OPV_000483') AS opt,
 (SELECT count(*) FROM t_prc_component_prices WHERE comp_price_id BETWEEN 39087 AND 39097) AS price_rows,
 (SELECT count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_KEYRING') AS keyring_fc;

ROLLBACK;
\echo '== ROLLBACK 완료 — 라이브 미변경 =='
