-- 01_t_prc_price_formulas.sql  — DGP 공식 헤더 6행 (신규 mint frm_cd)
-- 멱등: PK frm_cd → ON CONFLICT (frm_cd) DO NOTHING
-- reg_dt/upd_dt omit → reg_dt DEFAULT now() 발화. 트랜잭션은 apply.sql 이 감쌈.

-- src: t_prc_price_formulas_DGP.csv:2  key=PRF_DGP_A
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_DGP_A', '디지털인쇄 원자합산형A 엽서·상품권·슬로건', 'FRM_TYPE.01', '합산형: 판매가=인쇄비+코팅비+용지비+후가공비+추가상품 (계산공식집초안 행4). 별색인쇄비 행7 별도. 박(대형) 슬롯 행11. 엽서·상품권·종이슬로건', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- src: t_prc_price_formulas_DGP.csv:3  key=PRF_DGP_B
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_DGP_B', '디지털인쇄 원자합산형B 모양엽서·라벨택', 'FRM_TYPE.01', '합산형: 판매가=인쇄비+용지비+커팅비 (계산공식집초안 행15). 커팅=완칼(die-cut)', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- src: t_prc_price_formulas_DGP.csv:4  key=PRF_DGP_C
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_DGP_C', '디지털인쇄 원자합산형C 인쇄배경지·헤더택', 'FRM_TYPE.01', '합산형: 판매가=인쇄비+용지비+접지비+타공비+추가상품 (계산공식집초안 행19)', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- src: t_prc_price_formulas_DGP.csv:5  key=PRF_DGP_D
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_DGP_D', '디지털인쇄 원자합산형D 소량전단지', 'FRM_TYPE.01', '합산형: 판매가=인쇄비+코팅비+용지비+후가공비 (계산공식집초안 행25)', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- src: t_prc_price_formulas_DGP.csv:6  key=PRF_DGP_E
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_DGP_E', '디지털인쇄 원자합산형E 접지카드·접지리플렛', 'FRM_TYPE.01', '합산형: 판매가=인쇄비+코팅비+용지비+접지비+후가공비+박(대형)+추가상품 (계산공식집초안 행29). 국4절/3절 기준', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- src: t_prc_price_formulas_DGP.csv:7  key=PRF_DGP_F
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_DGP_F', '디지털인쇄 원자합산형F 썬캡(미출시)', 'FRM_TYPE.01', '합산형: 판매가=용지비+인쇄비+커팅비 (계산공식집초안 행49). use_yn=N 미출시', 'N')
ON CONFLICT (frm_cd) DO NOTHING;
