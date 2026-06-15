-- 공식↔구성요소 배선 (신규 3 INSERT · CLR 메타보정 BLOCKED 주석)
-- 생성: gen_load_sql.py (손편집 금지·재현성 R3). NEVER COMMIT.

-- [BLOCKED Q-ACR-7] src: data_wiring.csv PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T 메타 보정(disp_seq=1·addtn_yn=N) — 엔진 prc_typ .02 계약 미확정으로 보류.
-- INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) VALUES ('PRF_CLR_ACRYL', 'COMP_ACRYL_CLEAR3T', 1, 'N')
-- ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now()
--   WHERE t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq OR t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn;

-- src: data_wiring.csv PRF_MIRROR_ACRYL→COMP_ACRYL_MIRROR3T
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) VALUES ('PRF_MIRROR_ACRYL', 'COMP_ACRYL_MIRROR3T', 1, 'N')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- src: data_wiring.csv PRF_COROTTO_ACRYL→COMP_ACRYL_COROTTO
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) VALUES ('PRF_COROTTO_ACRYL', 'COMP_ACRYL_COROTTO', 1, 'N')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- src: data_wiring.csv PRF_CARABINER_ACRYL→COMP_ACRYL_CARABINER
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) VALUES ('PRF_CARABINER_ACRYL', 'COMP_ACRYL_CARABINER', 1, 'N')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

