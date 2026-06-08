-- =====================================================================
-- step 01 — t_prc_price_formulas
-- PRF_BANNER_NORMAL(FRM_TYPE.01 합산형) 1행 신설. PK=frm_cd → ON CONFLICT DO NOTHING
-- 멱등: 재실행 시 0행 변경. 손편집 금지(gen_load_sql.py 생성).
-- reg_dt 명시 생략→DEFAULT now() 발화(round-5 교훈: 명시 NULL 은 DEFAULT 미발화).
-- =====================================================================
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', '일반현수막 면적매트릭스+옵션 합산형', 'FRM_TYPE.01', '일반현수막(PRD_000138) 판매가=면적셀단가(siz)+선택가공추가가+선택추가추가가, ×제작수량은 공식외부(앱). off-grid=가로·세로 각각 한단계 큰 셀 ceiling(앱). 공유 PRF_POSTER_FIXED sparse 폐기(D-WIRE)', 'Y', now())
ON CONFLICT (frm_cd) DO NOTHING;
