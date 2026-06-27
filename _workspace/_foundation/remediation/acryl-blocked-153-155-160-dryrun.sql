-- acryl-blocked-153-155-160-dryrun.sql — DRY-RUN (ROLLBACK 전용·골든). 종결자=ROLLBACK.
\set ON_ERROR_STOP on
BEGIN;

INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT v.comp_cd, v.comp_nm, 'PRC_COMPONENT_TYPE.01', 'PRICE_TYPE.02', jsonb_build_array('siz_cd','min_qty'),'Y','N'
FROM (VALUES ('COMP_ACRYL_NAMETAG_GS','아크릴명찰(골드실버) 본체'),
             ('COMP_ACRYL_BALLPEN','아크릴볼펜 본체'),
             ('COMP_ACRYL_FREESTAND','아크릴자유형스탠드 본체')) AS v(comp_cd, comp_nm)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components c WHERE c.comp_cd=v.comp_cd);

INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, min_qty, unit_price)
SELECT v.comp_price_id, v.comp_cd, '2026-06-28', v.siz_cd, 1, v.unit_price
FROM (VALUES
  (39102::bigint,'COMP_ACRYL_NAMETAG_GS','SIZ_000346',3400::numeric),
  (39103,'COMP_ACRYL_NAMETAG_GS','SIZ_000348',4000),(39104,'COMP_ACRYL_NAMETAG_GS','SIZ_000350',4700),
  (39105,'COMP_ACRYL_BALLPEN','SIZ_000336',1800),(39106,'COMP_ACRYL_BALLPEN','SIZ_000330',2200),
  (39107,'COMP_ACRYL_BALLPEN','SIZ_000333',2700),
  (39108,'COMP_ACRYL_FREESTAND','SIZ_000357',8800),(39109,'COMP_ACRYL_FREESTAND','SIZ_000358',12200),
  (39110,'COMP_ACRYL_FREESTAND','SIZ_000359',15700),(39111,'COMP_ACRYL_FREESTAND','SIZ_000360',19100),
  (39112,'COMP_ACRYL_FREESTAND','SIZ_000361',22600)
) AS v(comp_price_id, comp_cd, siz_cd, unit_price)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices p WHERE p.comp_cd=v.comp_cd AND p.siz_cd=v.siz_cd AND p.apply_ymd='2026-06-28');

INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT v.frm_cd, v.frm_nm, '고정가형 by-siz_cd(상품 정찰가)', 'Y'
FROM (VALUES ('PRF_ACRYL_NAMETAG_GS','아크릴명찰(골드실버) 공식'),
             ('PRF_ACRYL_BALLPEN','아크릴볼펜 공식'),('PRF_ACRYL_FREESTAND','아크릴자유형스탠드 공식')) AS v(frm_cd, frm_nm)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd=v.frm_cd);

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT v.frm_cd, v.comp_cd, 1, 'N'
FROM (VALUES ('PRF_ACRYL_NAMETAG_GS','COMP_ACRYL_NAMETAG_GS'),
             ('PRF_ACRYL_BALLPEN','COMP_ACRYL_BALLPEN'),('PRF_ACRYL_FREESTAND','COMP_ACRYL_FREESTAND')) AS v(frm_cd, comp_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd=v.frm_cd AND fc.comp_cd=v.comp_cd);

INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT v.prd_cd, v.frm_cd, '2026-06-28', '고정가형 by-siz_cd(견적불가 해소)'
FROM (VALUES ('PRD_000153','PRF_ACRYL_NAMETAG_GS'),('PRD_000155','PRF_ACRYL_BALLPEN'),
             ('PRD_000160','PRF_ACRYL_FREESTAND')) AS v(prd_cd, frm_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas pf WHERE pf.prd_cd=v.prd_cd AND pf.frm_cd=v.frm_cd);

\echo '== 골든: 153/155/160 형상·사이즈별 고정가(siz_cd 정확매칭·권위 verbatim) =='
WITH g(label, comp_cd, siz_cd, expect) AS (VALUES
  ('153 명찰GS 60x20','COMP_ACRYL_NAMETAG_GS','SIZ_000346',3400::numeric),
  ('153 명찰GS 70x25','COMP_ACRYL_NAMETAG_GS','SIZ_000348',4000),
  ('153 명찰GS 80x30','COMP_ACRYL_NAMETAG_GS','SIZ_000350',4700),
  ('155 볼펜 20x20','COMP_ACRYL_BALLPEN','SIZ_000336',1800),
  ('155 볼펜 30x30','COMP_ACRYL_BALLPEN','SIZ_000330',2200),
  ('155 볼펜 40x40','COMP_ACRYL_BALLPEN','SIZ_000333',2700),
  ('160 자유형 120x60','COMP_ACRYL_FREESTAND','SIZ_000357',8800),
  ('160 자유형 120x180','COMP_ACRYL_FREESTAND','SIZ_000361',22600)
)
SELECT g.label, p.unit_price AS loaded, g.expect,
       CASE WHEN p.unit_price=g.expect THEN 'PASS' ELSE 'FAIL' END AS verdict
FROM g JOIN t_prc_component_prices p ON p.comp_cd=g.comp_cd AND p.siz_cd=g.siz_cd AND p.apply_ymd='2026-06-28'
ORDER BY g.label;

\echo '== 바인딩 3 + siz_cd 등록사이즈 정합 (단가행 siz_cd가 상품 등록사이즈에 존재) =='
SELECT v.prd_cd, v.frm_cd,
  (SELECT count(*) FROM t_prc_component_prices p
     JOIN t_prc_formula_components fc ON fc.comp_cd=p.comp_cd
    WHERE fc.frm_cd=v.frm_cd AND p.apply_ymd='2026-06-28'
      AND EXISTS (SELECT 1 FROM t_prd_product_sizes s WHERE s.prd_cd=v.prd_cd AND s.siz_cd=p.siz_cd)) AS siz_match
FROM (VALUES ('PRD_000153','PRF_ACRYL_NAMETAG_GS'),('PRD_000155','PRF_ACRYL_BALLPEN'),
             ('PRD_000160','PRF_ACRYL_FREESTAND')) AS v(prd_cd, frm_cd);

ROLLBACK;
\echo '== ROLLBACK 완료 — 라이브 미변경 =='
