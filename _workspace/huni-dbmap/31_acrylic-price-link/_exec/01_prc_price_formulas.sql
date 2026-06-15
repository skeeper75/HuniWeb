-- 신규 가격공식 (PRF_MIRROR/COROTTO/CARABINER·PRF_CLR 재현)
-- 생성: gen_load_sql.py (손편집 금지·재현성 R3). NEVER COMMIT.

-- src: data_formulas.csv frm_cd=PRF_CLR_ACRYL (라이브 실재 — ON CONFLICT 스킵)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn) VALUES ('PRF_CLR_ACRYL', '투명 아크릴 공식', '투명 아크릴 인쇄가공비', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- src: data_formulas.csv frm_cd=PRF_MIRROR_ACRYL
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn) VALUES ('PRF_MIRROR_ACRYL', '미러 아크릴 공식', '미러아크릴3T 인쇄가공비', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- src: data_formulas.csv frm_cd=PRF_COROTTO_ACRYL
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn) VALUES ('PRF_COROTTO_ACRYL', '아크릴코롯토 공식', '아크릴코롯토 인쇄가공비', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- src: data_formulas.csv frm_cd=PRF_CARABINER_ACRYL
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn) VALUES ('PRF_CARABINER_ACRYL', '아크릴카라비너 공식', '아크릴카라비너 완제품가(형상별 고정가)', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

