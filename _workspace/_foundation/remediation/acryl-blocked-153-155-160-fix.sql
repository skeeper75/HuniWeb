-- acryl-blocked-153-155-160-fix.sql — BLOCKED 큐 3상품 견적불가 해소 (고정가형 by-siz_cd · 라이브 COMMIT 후보)
-- 권위[HARD]=상품마스터 아크릴 시트 inline 정찰가(가격표 면적격자와 불일치=상품 자체 정찰가). 단가 verbatim.
--   153 아크릴명찰(골드실버): 60x20=3400·70x25=4000·80x30=4700  [자재=골드/실버(MAT_195/196)·투명3T격자 무관]
--       ★최초 'MIRROR3T 격자' 가정은 main 오판(고아 comp 오인). 권위 확인=일반 명찰 정찰가(미러격자 6800/7200/7600 아님). 권위 절대.
--   155 아크릴볼펜:        20x20=1800·30x30=2200·40x40=2700      [본체만·바디칼라 가공은 별 추가상품 트랙·보류]
--   160 아크릴자유형스탠드: 120x60=8800·120x90=12200·120x120=15700·120x150=19100·120x180=22600
-- 모델: 본체 단일 comp(고정가 by-siz_cd·PRICE_TYPE.02 합가형 min_qty=1·comp_typ.01·자재무관 카라비너 동형).
-- ★163 미니파츠(120x50)=권위 가격 빈칸 → 적재 제외(BLOCKED·실 단가 확보 후).
-- 채번: comp_price_id 39102~39112(라이브 MAX 39101+1). 멱등 NOT EXISTS. ★실 COMMIT은 인간 승인 후.
\set ON_ERROR_STOP on
BEGIN;

-- [1] 본체 comp 3종 (고정가 by-siz_cd)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT v.comp_cd, v.comp_nm, 'PRC_COMPONENT_TYPE.01', 'PRICE_TYPE.02', jsonb_build_array('siz_cd','min_qty'),'Y','N'
FROM (VALUES
  ('COMP_ACRYL_NAMETAG_GS','아크릴명찰(골드실버) 본체'),
  ('COMP_ACRYL_BALLPEN','아크릴볼펜 본체'),
  ('COMP_ACRYL_FREESTAND','아크릴자유형스탠드 본체')
) AS v(comp_cd, comp_nm)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components c WHERE c.comp_cd=v.comp_cd);

-- [2] 단가행 (siz_cd 정확매칭 · 권위 verbatim · min_qty=1)
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, min_qty, unit_price)
SELECT v.comp_price_id, v.comp_cd, '2026-06-28', v.siz_cd, 1, v.unit_price
FROM (VALUES
  (39102::bigint,'COMP_ACRYL_NAMETAG_GS','SIZ_000346',3400::numeric),  -- 60x20
  (39103,        'COMP_ACRYL_NAMETAG_GS','SIZ_000348',4000),           -- 70x25
  (39104,        'COMP_ACRYL_NAMETAG_GS','SIZ_000350',4700),           -- 80x30
  (39105,        'COMP_ACRYL_BALLPEN',   'SIZ_000336',1800),           -- 20x20
  (39106,        'COMP_ACRYL_BALLPEN',   'SIZ_000330',2200),           -- 30x30
  (39107,        'COMP_ACRYL_BALLPEN',   'SIZ_000333',2700),           -- 40x40
  (39108,        'COMP_ACRYL_FREESTAND', 'SIZ_000357',8800),           -- 120x60
  (39109,        'COMP_ACRYL_FREESTAND', 'SIZ_000358',12200),          -- 120x90
  (39110,        'COMP_ACRYL_FREESTAND', 'SIZ_000359',15700),          -- 120x120
  (39111,        'COMP_ACRYL_FREESTAND', 'SIZ_000360',19100),          -- 120x150
  (39112,        'COMP_ACRYL_FREESTAND', 'SIZ_000361',22600)           -- 120x180
) AS v(comp_price_id, comp_cd, siz_cd, unit_price)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices p
  WHERE p.comp_cd=v.comp_cd AND p.siz_cd=v.siz_cd AND p.apply_ymd='2026-06-28'
);

-- [3] 전용공식 3종 (본체 단일 comp)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT v.frm_cd, v.frm_nm, '고정가형 by-siz_cd(상품 정찰가)', 'Y'
FROM (VALUES
  ('PRF_ACRYL_NAMETAG_GS','아크릴명찰(골드실버) 공식'),
  ('PRF_ACRYL_BALLPEN','아크릴볼펜 공식'),
  ('PRF_ACRYL_FREESTAND','아크릴자유형스탠드 공식')
) AS v(frm_cd, frm_nm)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd=v.frm_cd);

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT v.frm_cd, v.comp_cd, 1, 'N'
FROM (VALUES
  ('PRF_ACRYL_NAMETAG_GS','COMP_ACRYL_NAMETAG_GS'),
  ('PRF_ACRYL_BALLPEN','COMP_ACRYL_BALLPEN'),
  ('PRF_ACRYL_FREESTAND','COMP_ACRYL_FREESTAND')
) AS v(frm_cd, comp_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd=v.frm_cd AND fc.comp_cd=v.comp_cd);

-- [4] 상품-공식 바인딩
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT v.prd_cd, v.frm_cd, '2026-06-28', '고정가형 by-siz_cd(견적불가 해소)'
FROM (VALUES
  ('PRD_000153','PRF_ACRYL_NAMETAG_GS'),
  ('PRD_000155','PRF_ACRYL_BALLPEN'),
  ('PRD_000160','PRF_ACRYL_FREESTAND')
) AS v(prd_cd, frm_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas pf WHERE pf.prd_cd=v.prd_cd AND pf.frm_cd=v.frm_cd
);

COMMIT;
