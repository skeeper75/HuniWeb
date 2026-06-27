-- acryl-addon-147-152-dryrun.sql — 아크릴 addon 5상품 적재 DRY-RUN (ROLLBACK 전용·골든/어서션)
-- fix.sql 본문을 그대로 BEGIN…(검증 SELECT)…ROLLBACK 으로 감쌈. 라이브 미변경.
-- 검증: A1 채번충돌0 · A2 옵션아이템 ref 무결성(트리거 통과) · A3 5바인딩 · A4 가산작동 골든 · A5 always-add 가드 · A6 멱등.
-- 실행: psql -f acryl-addon-147-152-dryrun.sql  (종결자 = ROLLBACK 확인)
\set ON_ERROR_STOP on
BEGIN;

-- ---- [0] product_material 보강 (147) ----
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, del_yn)
SELECT 'PRD_000147','MAT_000050','USAGE.07','N',2,'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials
  WHERE prd_cd='PRD_000147' AND mat_cd='MAT_000050' AND usage_cd='USAGE.07');

-- ---- [1] 옵션그룹 ----
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn)
SELECT v.prd_cd, v.opt_grp_cd, v.opt_grp_nm, 'SEL_TYPE.01', 0, 1, 'N', 1, 'Y', 'N'
FROM (VALUES
  ('PRD_000147','OPT_000074','자석부착'),('PRD_000148','OPT_000075','부속'),
  ('PRD_000149','OPT_000076','집게'),('PRD_000150','OPT_000077','바디'),
  ('PRD_000152','OPT_000078','부속')
) AS v(prd_cd, opt_grp_cd, opt_grp_nm)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups g WHERE g.prd_cd=v.prd_cd AND g.opt_grp_cd=v.opt_grp_cd);

-- ---- [2] 옵션 ----
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT v.prd_cd, v.opt_cd, v.opt_grp_cd, v.opt_nm, 'N', v.disp_seq, 'Y', 'N'
FROM (VALUES
  ('PRD_000147','OPV_000465','OPT_000074','자석부착',1),
  ('PRD_000148','OPV_000466','OPT_000075','원형핀',1),('PRD_000148','OPV_000467','OPT_000075','1구자석',2),
  ('PRD_000149','OPV_000468','OPT_000076','투명집게',1),
  ('PRD_000150','OPV_000469','OPT_000077','화이트바디',1),('PRD_000150','OPV_000470','OPT_000077','투명바디',2),
  ('PRD_000152','OPV_000471','OPT_000078','일자핀',1),('PRD_000152','OPV_000472','OPT_000078','2구자석',2)
) AS v(prd_cd, opt_cd, opt_grp_cd, opt_nm, disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options o WHERE o.prd_cd=v.prd_cd AND o.opt_cd=v.opt_cd);

-- ---- [3] 옵션아이템 (트리거 fn_chk_opt_item_ref 검증 = A2) ----
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn)
SELECT v.prd_cd, v.opt_cd, 1, 'OPT_REF_DIM.03', v.mat_cd, 'USAGE.07', NULL, 'Y', 'N'
FROM (VALUES
  ('PRD_000147','OPV_000465','MAT_000050'),
  ('PRD_000148','OPV_000466','MAT_000047'),('PRD_000148','OPV_000467','MAT_000048'),
  ('PRD_000149','OPV_000468','MAT_000056'),
  ('PRD_000150','OPV_000469','MAT_000054'),('PRD_000150','OPV_000470','MAT_000053'),
  ('PRD_000152','OPV_000471','MAT_000046'),('PRD_000152','OPV_000472','MAT_000049')
) AS v(prd_cd, opt_cd, mat_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items i WHERE i.prd_cd=v.prd_cd AND i.opt_cd=v.opt_cd AND i.item_seq=1);

-- ---- [4] 가산 comp ----
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT v.comp_cd, v.comp_nm, 'PRC_COMPONENT_TYPE.04', 'PRICE_TYPE.01',
       jsonb_build_array('opt_cd','min_qty','opt_grp:'||v.opt_grp_cd), 'Y', 'N'
FROM (VALUES
  ('COMP_ACRYL_MAGNET','마그넷 자석부착','OPT_000074'),('COMP_ACRYL_BADGE','뱃지 부속','OPT_000075'),
  ('COMP_ACRYL_CLIP','집게 부속','OPT_000076'),('COMP_ACRYL_SMARTTOK','스마트톡 바디','OPT_000077'),
  ('COMP_ACRYL_NAMETAG_PIN','명찰 부속','OPT_000078')
) AS v(comp_cd, comp_nm, opt_grp_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components c WHERE c.comp_cd=v.comp_cd);

-- ---- [5] 단가행 (verbatim) ----
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, opt_cd, min_qty, unit_price)
SELECT v.comp_price_id, v.comp_cd, '2026-06-28', v.opt_cd, 1, v.unit_price
FROM (VALUES
  (39078::bigint,'COMP_ACRYL_MAGNET','OPV_000465',800::numeric),
  (39079,'COMP_ACRYL_BADGE','OPV_000466',600),(39080,'COMP_ACRYL_BADGE','OPV_000467',1000),
  (39081,'COMP_ACRYL_CLIP','OPV_000468',700),
  (39082,'COMP_ACRYL_SMARTTOK','OPV_000469',2600),(39083,'COMP_ACRYL_SMARTTOK','OPV_000470',3000),
  (39084,'COMP_ACRYL_NAMETAG_PIN','OPV_000471',700),(39085,'COMP_ACRYL_NAMETAG_PIN','OPV_000472',1700)
) AS v(comp_price_id, comp_cd, opt_cd, unit_price)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices p WHERE p.comp_cd=v.comp_cd AND p.opt_cd=v.opt_cd AND p.apply_ymd='2026-06-28');

-- ---- [6] 공식 + formula_components ----
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT v.frm_cd, v.frm_nm, '본체 면적 + 가공 가산(addon)', 'Y'
FROM (VALUES
  ('PRF_ACRYL_MAGNET','아크릴마그넷 공식'),('PRF_ACRYL_BADGE','아크릴뱃지 공식'),
  ('PRF_ACRYL_CLIP','아크릴집게 공식'),('PRF_ACRYL_SMARTTOK','아크릴스마트톡 공식'),
  ('PRF_ACRYL_NAMETAG','아크릴명찰 공식')
) AS v(frm_cd, frm_nm)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd=v.frm_cd);

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT v.frm_cd, v.comp_cd, v.disp_seq, v.addtn_yn
FROM (VALUES
  ('PRF_ACRYL_MAGNET','COMP_ACRYL_CLEAR3T',1,'N'),('PRF_ACRYL_MAGNET','COMP_ACRYL_MAGNET',2,'Y'),
  ('PRF_ACRYL_BADGE','COMP_ACRYL_CLEAR3T',1,'N'),('PRF_ACRYL_BADGE','COMP_ACRYL_BADGE',2,'Y'),
  ('PRF_ACRYL_CLIP','COMP_ACRYL_CLEAR3T',1,'N'),('PRF_ACRYL_CLIP','COMP_ACRYL_CLIP',2,'Y'),
  ('PRF_ACRYL_SMARTTOK','COMP_ACRYL_CLEAR3T',1,'N'),('PRF_ACRYL_SMARTTOK','COMP_ACRYL_SMARTTOK',2,'Y'),
  ('PRF_ACRYL_NAMETAG','COMP_ACRYL_CLEAR3T',1,'N'),('PRF_ACRYL_NAMETAG','COMP_ACRYL_NAMETAG_PIN',2,'Y')
) AS v(frm_cd, comp_cd, disp_seq, addtn_yn)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd=v.frm_cd AND fc.comp_cd=v.comp_cd);

-- ---- [7] 바인딩 ----
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT v.prd_cd, v.frm_cd, '2026-06-28', 'addon — 본체+가공 가산'
FROM (VALUES
  ('PRD_000147','PRF_ACRYL_MAGNET'),('PRD_000148','PRF_ACRYL_BADGE'),('PRD_000149','PRF_ACRYL_CLIP'),
  ('PRD_000150','PRF_ACRYL_SMARTTOK'),('PRD_000152','PRF_ACRYL_NAMETAG')
) AS v(prd_cd, frm_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas pf WHERE pf.prd_cd=v.prd_cd AND pf.apply_bgn_ymd='2026-06-28');

-- ============================================================
-- 어서션 SELECT (ROLLBACK 전 검증 출력)
-- ============================================================
\echo '== A3 5바인딩(147~152 PRF_ACRYL_*) =='
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas
WHERE prd_cd IN ('PRD_000147','PRD_000148','PRD_000149','PRD_000150','PRD_000152')
  AND frm_cd LIKE 'PRF_ACRYL\_%' ORDER BY prd_cd;

\echo '== A2 옵션아이템 ref 무결성: 8건 INSERT 성공(트리거 통과) =='
SELECT prd_cd, opt_cd, ref_dim_cd, ref_key1, ref_key2 FROM t_prd_product_option_items
WHERE prd_cd IN ('PRD_000147','PRD_000148','PRD_000149','PRD_000150','PRD_000152')
  AND opt_cd LIKE 'OPV_00046%' OR opt_cd LIKE 'OPV_00047%' ORDER BY prd_cd, opt_cd;

\echo '== A4 골든: 본체(라이브 CLEAR3T) + 가산(신규 단가행) 합산 vs 기대값 =='
WITH body AS (
  SELECT siz_width, siz_height, unit_price AS body_price
  FROM t_prc_component_prices
  WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043' AND min_qty=1
), golden(label, sw, sh, opt_cd, expect) AS (VALUES
  ('G4  147마그넷 30x30 자석부착',  '30','30','OPV_000465', 3900::numeric),
  ('G5  148뱃지 40x40 1구자석',     '40','40','OPV_000467', 4800),
  ('G6  148뱃지 30x30 원형핀',      '30','30','OPV_000466', 3700),
  ('G7  149집게 50x50 투명집게',    '50','50','OPV_000468', 5500),
  ('G8  150스마트톡 50x50 투명바디','50','50','OPV_000470', 7800),
  ('G9  150스마트톡 60x60 화이트바디','60','60','OPV_000469', 8500),
  ('G10 152명찰 60x20 2구자석',     '60','20','OPV_000472', 5100),
  ('G11 152명찰 80x30 일자핀',      '80','30','OPV_000471', 5400)
)
SELECT g.label,
       b.body_price, a.unit_price AS add_price,
       (b.body_price + a.unit_price) AS calc, g.expect,
       CASE WHEN (b.body_price + a.unit_price) = g.expect THEN 'PASS' ELSE 'FAIL' END AS verdict
FROM golden g
JOIN body b ON b.siz_width::numeric=g.sw::numeric AND b.siz_height::numeric=g.sh::numeric
JOIN t_prc_component_prices a ON a.opt_cd=g.opt_cd AND a.apply_ymd='2026-06-28'
ORDER BY g.label;

\echo '== A5 always-add 가드: 전 신규 가산 comp use_dims에 opt_cd 보유 =='
SELECT comp_cd, use_dims, (use_dims @> '["opt_cd"]'::jsonb) AS has_opt_cd
FROM t_prc_price_components
WHERE comp_cd IN ('COMP_ACRYL_MAGNET','COMP_ACRYL_BADGE','COMP_ACRYL_CLIP','COMP_ACRYL_SMARTTOK','COMP_ACRYL_NAMETAG_PIN')
ORDER BY comp_cd;

\echo '== A1 채번 카운트(신규 그룹5/옵션8/comp5/단가행8/공식5/바인딩5) =='
SELECT
 (SELECT count(*) FROM t_prd_product_option_groups WHERE opt_grp_cd BETWEEN 'OPT_000074' AND 'OPT_000078') AS grp,
 (SELECT count(*) FROM t_prd_product_options WHERE opt_cd BETWEEN 'OPV_000465' AND 'OPV_000472') AS opt,
 (SELECT count(*) FROM t_prc_component_prices WHERE comp_price_id BETWEEN 39078 AND 39085) AS price_rows,
 (SELECT count(*) FROM t_prc_price_formulas WHERE frm_cd LIKE 'PRF_ACRYL\_%' AND frm_cd IN
   ('PRF_ACRYL_MAGNET','PRF_ACRYL_BADGE','PRF_ACRYL_CLIP','PRF_ACRYL_SMARTTOK','PRF_ACRYL_NAMETAG')) AS frm;

ROLLBACK;
\echo '== ROLLBACK 완료 — 라이브 미변경 =='
