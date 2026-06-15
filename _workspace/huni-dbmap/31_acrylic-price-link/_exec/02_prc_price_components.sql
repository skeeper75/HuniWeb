-- 신규 구성요소 (COROTTO .01/.01 · CARABINER .06/.01)
-- 생성: gen_load_sql.py (손편집 금지·재현성 R3). NEVER COMMIT.

-- src: data_components.csv comp_cd=COMP_ACRYL_COROTTO
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn) VALUES ('COMP_ACRYL_COROTTO', '아크릴코롯토 인쇄가공비', 'PRC_COMPONENT_TYPE.01', 'PRICE_TYPE.01', '["siz_cd"]'::jsonb, 'Y')
ON CONFLICT (comp_cd) DO NOTHING;

-- src: data_components.csv comp_cd=COMP_ACRYL_CARABINER
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn) VALUES ('COMP_ACRYL_CARABINER', '아크릴카라비너 완제품가', 'PRC_COMPONENT_TYPE.06', 'PRICE_TYPE.01', '["opt_cd"]'::jsonb, 'Y')
ON CONFLICT (comp_cd) DO NOTHING;

