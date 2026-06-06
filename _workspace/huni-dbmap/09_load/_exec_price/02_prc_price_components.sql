-- 02_prc_price_components.sql
-- 단계02 구성요소 카탈로그 — PK pk_t_prc_price_components(comp_cd). comp_cd<=50자 점검.
-- 생성: gen_load_sql.py (손편집 금지). 멱등: ON CONFLICT 가드.
-- BEGIN/COMMIT 미포함 — apply.sql 가 트랜잭션 래핑.

-- src: 02_prc_price_components.csv:row2 comp_cd=COMP_ACRYL_CLEAR15T
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_ACRYL_CLEAR15T', '투명아크릴1.5T 인쇄가공비', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row3 comp_cd=COMP_ACRYL_CLEAR3T
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_ACRYL_CLEAR3T', '투명아크릴3T 인쇄가공비', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row4 comp_cd=COMP_ACRYL_MIRROR3T
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_ACRYL_MIRROR3T', '미러아크릴3T 인쇄가공비', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row5 comp_cd=COMP_COAT_GLOSSY
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_COAT_GLOSSY', '유광코팅비', 'PRC_COMPONENT_TYPE.02', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.02', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row6 comp_cd=COMP_COAT_MATTE
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_COAT_MATTE', '무광코팅비', 'PRC_COMPONENT_TYPE.02', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.02', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row7 comp_cd=COMP_ENV_MAKING
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_ENV_MAKING', '봉투제작 완제품가', 'PRC_COMPONENT_TYPE.06', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.06', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row8 comp_cd=COMP_PP_CORNER_RIGHT
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_CORNER_RIGHT', '모서리 직각', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row9 comp_cd=COMP_PP_CORNER_ROUND
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_CORNER_ROUND', '모서리 둥근', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row10 comp_cd=COMP_PP_CREASE_1L
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_CREASE_1L', '오시 1줄', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row11 comp_cd=COMP_PP_CREASE_2L
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_CREASE_2L', '오시 2줄', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row12 comp_cd=COMP_PP_CREASE_3L
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_CREASE_3L', '오시 3줄', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row13 comp_cd=COMP_PP_PERF_1L
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_PERF_1L', '미싱 1줄', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row14 comp_cd=COMP_PP_PERF_2L
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_PERF_2L', '미싱 2줄', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row15 comp_cd=COMP_PP_PERF_3L
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_PERF_3L', '미싱 3줄', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row16 comp_cd=COMP_PP_VARIMG_1EA
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_VARIMG_1EA', '가변이미지 1개', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row17 comp_cd=COMP_PP_VARIMG_2EA
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_VARIMG_2EA', '가변이미지 2개', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row18 comp_cd=COMP_PP_VARIMG_3EA
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_VARIMG_3EA', '가변이미지 3개', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row19 comp_cd=COMP_PP_VARTEXT_1EA
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_VARTEXT_1EA', '가변텍스트 1개', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row20 comp_cd=COMP_PP_VARTEXT_2EA
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_VARTEXT_2EA', '가변텍스트 2개', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row21 comp_cd=COMP_PP_VARTEXT_3EA
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PP_VARTEXT_3EA', '가변텍스트 3개', 'PRC_COMPONENT_TYPE.04', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row22 comp_cd=COMP_PRINT_DIGITAL_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_DIGITAL_S1', '디지털인쇄비(단면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row23 comp_cd=COMP_PRINT_DIGITAL_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_DIGITAL_S2', '디지털인쇄비(양면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row24 comp_cd=COMP_PRINT_SPOT_CLEAR_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_SPOT_CLEAR_S1', '별색인쇄비 클리어(단면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row25 comp_cd=COMP_PRINT_SPOT_CLEAR_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_SPOT_CLEAR_S2', '별색인쇄비 클리어(양면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row26 comp_cd=COMP_PRINT_SPOT_GOLD_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_SPOT_GOLD_S1', '별색인쇄비 금색(단면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row27 comp_cd=COMP_PRINT_SPOT_GOLD_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_SPOT_GOLD_S2', '별색인쇄비 금색(양면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row28 comp_cd=COMP_PRINT_SPOT_PINK_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_SPOT_PINK_S1', '별색인쇄비 핑크(단면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row29 comp_cd=COMP_PRINT_SPOT_PINK_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_SPOT_PINK_S2', '별색인쇄비 핑크(양면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row30 comp_cd=COMP_PRINT_SPOT_SILVER_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_SPOT_SILVER_S1', '별색인쇄비 은색(단면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row31 comp_cd=COMP_PRINT_SPOT_SILVER_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_SPOT_SILVER_S2', '별색인쇄비 은색(양면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row32 comp_cd=COMP_PRINT_SPOT_WHITE_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_SPOT_WHITE_S1', '별색인쇄비 화이트(단면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row33 comp_cd=COMP_PRINT_SPOT_WHITE_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PRINT_SPOT_WHITE_S2', '별색인쇄비 화이트(양면)', 'PRC_COMPONENT_TYPE.01', 'round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row34 comp_cd=COMP_FOLD_CARD_2H
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_FOLD_CARD_2H', '접지비(후가공) [COMP_FOLD_CARD_2H]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row35 comp_cd=COMP_FOLD_CARD_3H
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_FOLD_CARD_3H', '접지비(후가공) [COMP_FOLD_CARD_3H]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row36 comp_cd=COMP_FOLD_CARD_6CR
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_FOLD_CARD_6CR', '접지비(후가공) [COMP_FOLD_CARD_6CR]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row37 comp_cd=COMP_FOLD_LEAF_HALF
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_FOLD_LEAF_HALF', '접지비(후가공) [COMP_FOLD_LEAF_HALF]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row38 comp_cd=COMP_FOLD_LEAF_3FOLD
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_FOLD_LEAF_3FOLD', '접지비(후가공) [COMP_FOLD_LEAF_3FOLD]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row39 comp_cd=COMP_FOLD_LEAF_4ACC
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_FOLD_LEAF_4ACC', '접지비(후가공) [COMP_FOLD_LEAF_4ACC]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row40 comp_cd=COMP_FOLD_LEAF_4GATE
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_FOLD_LEAF_4GATE', '접지비(후가공) [COMP_FOLD_LEAF_4GATE]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row41 comp_cd=COMP_BIND_JUNGCHEOL
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_BIND_JUNGCHEOL', '제본비(후가공) [COMP_BIND_JUNGCHEOL]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row42 comp_cd=COMP_BIND_MUSEON
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_BIND_MUSEON', '제본비(후가공) [COMP_BIND_MUSEON]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row43 comp_cd=COMP_BIND_TWINRING
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_BIND_TWINRING', '제본비(후가공) [COMP_BIND_TWINRING]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row44 comp_cd=COMP_BIND_PUR
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_BIND_PUR', '제본비(후가공) [COMP_BIND_PUR]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row45 comp_cd=COMP_BIND_HC_MUSEON
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_BIND_HC_MUSEON', '제본비(후가공) [COMP_BIND_HC_MUSEON]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row46 comp_cd=COMP_BIND_HC_TWINRING
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_BIND_HC_TWINRING', '제본비(후가공) [COMP_BIND_HC_TWINRING]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row47 comp_cd=COMP_BIND_SSABARI
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_BIND_SSABARI', '제본비(후가공) [COMP_BIND_SSABARI]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row48 comp_cd=COMP_BIND_CAL_WALL
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_BIND_CAL_WALL', '제본비(후가공) [COMP_BIND_CAL_WALL]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row49 comp_cd=COMP_BIND_CAL_DESK220
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_BIND_CAL_DESK220', '제본비(후가공) [COMP_BIND_CAL_DESK220]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row50 comp_cd=COMP_BIND_CAL_DESK130
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_BIND_CAL_DESK130', '제본비(후가공) [COMP_BIND_CAL_DESK130]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row51 comp_cd=COMP_BIND_CAL_DESKMINI
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_BIND_CAL_DESKMINI', '제본비(후가공) [COMP_BIND_CAL_DESKMINI]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row52 comp_cd=COMP_CUT_PERF_1H6
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_CUT_PERF_1H6', '타공비(후가공) [COMP_CUT_PERF_1H6]', 'PRC_COMPONENT_TYPE.04', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row53 comp_cd=COMP_CUT_FULL_DIECUT
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_CUT_FULL_DIECUT', '커팅 합가(완제품가) [COMP_CUT_FULL_DIECUT]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row54 comp_cd=COMP_CUT_FULL_PERF_1H6
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_CUT_FULL_PERF_1H6', '커팅 합가(완제품가) [COMP_CUT_FULL_PERF_1H6]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row55 comp_cd=COMP_CUT_FULL_PERF_2H6
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_CUT_FULL_PERF_2H6', '커팅 합가(완제품가) [COMP_CUT_FULL_PERF_2H6]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row56 comp_cd=COMP_STK_PRINT
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_STK_PRINT', '스티커 단가(완제품가) [COMP_STK_PRINT]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row57 comp_cd=COMP_STK_PACK
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_STK_PACK', '스티커 단가(완제품가) [COMP_STK_PACK]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row58 comp_cd=COMP_GANGPAN_PRINT
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_GANGPAN_PRINT', '합판도무송 단가(완제품가) [COMP_GANGPAN_PRINT]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row59 comp_cd=COMP_NAMECARD_STD_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_STD_S1', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_STD_S1]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row60 comp_cd=COMP_NAMECARD_STD_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_STD_S2', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_STD_S2]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row61 comp_cd=COMP_NAMECARD_PREMIUM_S1_MGA
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_PREMIUM_S1_MGA', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_PREMIUM_S1_MGA]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row62 comp_cd=COMP_NAMECARD_PREMIUM_S1_MGB
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_PREMIUM_S1_MGB', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_PREMIUM_S1_MGB]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row63 comp_cd=COMP_NAMECARD_PREMIUM_S2_MGA
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_PREMIUM_S2_MGA', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_PREMIUM_S2_MGA]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row64 comp_cd=COMP_NAMECARD_PREMIUM_S2_MGB
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_PREMIUM_S2_MGB', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_PREMIUM_S2_MGB]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row65 comp_cd=COMP_NAMECARD_COAT_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_COAT_S1', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_COAT_S1]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row66 comp_cd=COMP_NAMECARD_COAT_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_COAT_S2', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_COAT_S2]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row67 comp_cd=COMP_NAMECARD_PEARL_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_PEARL_S1', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_PEARL_S1]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row68 comp_cd=COMP_NAMECARD_PEARL_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_PEARL_S2', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_PEARL_S2]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row69 comp_cd=COMP_NAMECARD_CLEAR_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_CLEAR_S1', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_CLEAR_S1]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row70 comp_cd=COMP_NAMECARD_WHITE_S1W_NOCL
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_WHITE_S1W_NOCL', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_WHITE_S1W_NOCL]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row71 comp_cd=COMP_NAMECARD_WHITE_S1W_CL
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_WHITE_S1W_CL', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_WHITE_S1W_CL]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row72 comp_cd=COMP_NAMECARD_WHITE_S2W_NOCL
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_WHITE_S2W_NOCL', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_WHITE_S2W_NOCL]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row73 comp_cd=COMP_NAMECARD_WHITE_S2W_CL
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_WHITE_S2W_CL', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_WHITE_S2W_CL]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row74 comp_cd=COMP_NAMECARD_SHAPE_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_SHAPE_S1', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_SHAPE_S1]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row75 comp_cd=COMP_NAMECARD_SHAPE_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_SHAPE_S2', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_SHAPE_S2]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row76 comp_cd=COMP_NAMECARD_MINISHAPE_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_MINISHAPE_S1', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_MINISHAPE_S1]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row77 comp_cd=COMP_NAMECARD_MINISHAPE_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_MINISHAPE_S2', '명함 단가(용지포함 완제품가) [COMP_NAMECARD_MINISHAPE_S2]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row78 comp_cd=COMP_NAMECARD_FOIL_SETUP_S1_STD
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_FOIL_SETUP_S1_STD', '박형압 동판셋업비 [COMP_NAMECARD_FOIL_SETUP_S1_STD]', 'PRC_COMPONENT_TYPE.05', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row79 comp_cd=COMP_NAMECARD_FOIL_SETUP_S2_STD
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_FOIL_SETUP_S2_STD', '박형압 동판셋업비 [COMP_NAMECARD_FOIL_SETUP_S2_STD]', 'PRC_COMPONENT_TYPE.05', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row80 comp_cd=COMP_NAMECARD_FOIL_S1_STD
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_FOIL_S1_STD', '오리지널박 합가(완제품가) [COMP_NAMECARD_FOIL_S1_STD]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row81 comp_cd=COMP_NAMECARD_FOIL_S1_HOLO
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_FOIL_S1_HOLO', '오리지널박 합가(완제품가) [COMP_NAMECARD_FOIL_S1_HOLO]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row82 comp_cd=COMP_NAMECARD_FOIL_S2_STD
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_FOIL_S2_STD', '오리지널박 합가(완제품가) [COMP_NAMECARD_FOIL_S2_STD]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row83 comp_cd=COMP_NAMECARD_FOIL_S2_HOLO
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_NAMECARD_FOIL_S2_HOLO', '오리지널박 합가(완제품가) [COMP_NAMECARD_FOIL_S2_HOLO]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row84 comp_cd=COMP_PHOTOCARD_BULK
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PHOTOCARD_BULK', '포토카드 단가(완제품가) [COMP_PHOTOCARD_BULK]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row85 comp_cd=COMP_PCB_S1_20P
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PCB_S1_20P', '엽서북 단가(완제품가) [COMP_PCB_S1_20P]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row86 comp_cd=COMP_PCB_S1_30P
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PCB_S1_30P', '엽서북 단가(완제품가) [COMP_PCB_S1_30P]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row87 comp_cd=COMP_PCB_S2_20P
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PCB_S2_20P', '엽서북 단가(완제품가) [COMP_PCB_S2_20P]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row88 comp_cd=COMP_PCB_S2_30P
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PCB_S2_30P', '엽서북 단가(완제품가) [COMP_PCB_S2_30P]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row89 comp_cd=COMP_PHOTOCARD_SET
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PHOTOCARD_SET', '포토카드 단가(완제품가) [COMP_PHOTOCARD_SET]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row90 comp_cd=COMP_PHOTOCARD_CLEAR_SET
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PHOTOCARD_CLEAR_SET', '포토카드 단가(완제품가) [COMP_PHOTOCARD_CLEAR_SET]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row91 comp_cd=COMP_TTEOKME
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_TTEOKME', '떡메모지 단가(완제품가) [COMP_TTEOKME]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row92 comp_cd=COMP_POSTER_ARTPRINT_PHOTO
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_ARTPRINT_PHOTO', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_ARTPRINT_PHOTO]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row93 comp_cd=COMP_POSTER_ARTPAPER_MATTE
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_ARTPAPER_MATTE', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_ARTPAPER_MATTE]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row94 comp_cd=COMP_POSTER_WATERPROOF_PET
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_WATERPROOF_PET', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_WATERPROOF_PET]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row95 comp_cd=COMP_POSTER_ADH_WATERPROOF_PVC
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_ADH_WATERPROOF_PVC', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_ADH_WATERPROOF_PVC]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row96 comp_cd=COMP_POSTER_ADH_CLEAR_PVC
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_ADH_CLEAR_PVC', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_ADH_CLEAR_PVC]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row97 comp_cd=COMP_POSTER_ARTFABRIC_GRAPHIC
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_ARTFABRIC_GRAPHIC', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_ARTFABRIC_GRAPHIC]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row98 comp_cd=COMP_POSTER_LINEN_FABRIC
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_LINEN_FABRIC', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_LINEN_FABRIC]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row99 comp_cd=COMP_POSTER_CANVAS_FABRIC
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_CANVAS_FABRIC', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_CANVAS_FABRIC]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row100 comp_cd=COMP_POSTER_LEATHER_ARTPRINT
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_LEATHER_ARTPRINT', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_LEATHER_ARTPRINT]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row101 comp_cd=COMP_POSTER_TYVEK_PRINT
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_TYVEK_PRINT', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_TYVEK_PRINT]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row102 comp_cd=COMP_POSTER_MESH_PRINT
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_MESH_PRINT', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_MESH_PRINT]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row103 comp_cd=COMP_POSTER_FRAMELESS_WOOD
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_FRAMELESS_WOOD', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_FRAMELESS_WOOD]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row104 comp_cd=COMP_POSTER_LEATHER_FRAME
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_LEATHER_FRAME', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_LEATHER_FRAME]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row105 comp_cd=COMP_POSTER_JOKJA
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_JOKJA', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_JOKJA]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row106 comp_cd=COMP_POSTEROPT_JOKJA_CEILHOOK
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_JOKJA_CEILHOOK', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_JOKJA_CEILHOOK]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row107 comp_cd=COMP_POSTER_CANVAS_HANGING
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_CANVAS_HANGING', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_CANVAS_HANGING]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row108 comp_cd=COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row109 comp_cd=COMP_POSTER_LINEN_WOODBONG
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_LINEN_WOODBONG', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_LINEN_WOODBONG]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row110 comp_cd=COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row111 comp_cd=COMP_POSTER_PET_BANNER
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_PET_BANNER', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_PET_BANNER]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row112 comp_cd=COMP_POSTEROPT_PET_BANNER_STAND_IN
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_PET_BANNER_STAND_IN', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_PET_BANNER_STAND_IN]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row113 comp_cd=COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row114 comp_cd=COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row115 comp_cd=COMP_POSTER_MESH_BANNER
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_MESH_BANNER', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_MESH_BANNER]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row116 comp_cd=COMP_POSTER_BANNER_NORMAL
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_BANNER_NORMAL', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_BANNER_NORMAL]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row117 comp_cd=COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row118 comp_cd=COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row119 comp_cd=COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row120 comp_cd=COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_6
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_6', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_6]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row121 comp_cd=COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row122 comp_cd=COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_8
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_8', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_8]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row123 comp_cd=COMP_POPT_BNR_GAKMOK_STR_900_4
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POPT_BNR_GAKMOK_STR_900_4', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POPT_BNR_GAKMOK_STR_900_4]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row124 comp_cd=COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row125 comp_cd=COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row126 comp_cd=COMP_POSTER_BANNER_MESH
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_BANNER_MESH', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_BANNER_MESH]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row127 comp_cd=COMP_POSTEROPT_BANNER_MESH_PROC_OPT
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_MESH_PROC_OPT', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_MESH_PROC_OPT]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row128 comp_cd=COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row129 comp_cd=COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row130 comp_cd=COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row131 comp_cd=COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row132 comp_cd=COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row133 comp_cd=COMP_POSTER_MINI_STANDBOARD
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_MINI_STANDBOARD', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_MINI_STANDBOARD]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row134 comp_cd=COMP_POSTER_MINI_BANNER
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_MINI_BANNER', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_MINI_BANNER]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row135 comp_cd=COMP_POPT_BNR_GAKMOK_STR_900_4_LE
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POPT_BNR_GAKMOK_STR_900_4_LE', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POPT_BNR_GAKMOK_STR_900_4_LE]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row136 comp_cd=COMP_POPT_BNR_GAKMOK_STR_900_4_GT
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POPT_BNR_GAKMOK_STR_900_4_GT', '포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POPT_BNR_GAKMOK_STR_900_4_GT]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row137 comp_cd=COMP_POSTER_FOAMBOARD_WHITE
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_FOAMBOARD_WHITE', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_FOAMBOARD_WHITE]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row138 comp_cd=COMP_POSTER_FOAMBOARD_BLACK
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_FOAMBOARD_BLACK', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_FOAMBOARD_BLACK]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row139 comp_cd=COMP_POSTER_FOMEXBOARD_WHITE3MM
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_FOMEXBOARD_WHITE3MM', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_FOMEXBOARD_WHITE3MM]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row140 comp_cd=COMP_POSTER_FOMEXBOARD_WHITE5MM
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_FOMEXBOARD_WHITE5MM', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_FOMEXBOARD_WHITE5MM]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row141 comp_cd=COMP_POSTER_ACRYLSTK_GLOSS
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_ACRYLSTK_GLOSS', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_ACRYLSTK_GLOSS]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row142 comp_cd=COMP_POSTER_ACRYLSTK_MIRROR
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_ACRYLSTK_MIRROR', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_ACRYLSTK_MIRROR]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row143 comp_cd=COMP_POSTER_SHEETCUT_MATTE
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_SHEETCUT_MATTE', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_SHEETCUT_MATTE]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
-- src: 02_prc_price_components.csv:row144 comp_cd=COMP_POSTER_SHEETCUT_HOLO
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_POSTER_SHEETCUT_HOLO', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_SHEETCUT_HOLO]', 'PRC_COMPONENT_TYPE.06', 'round-2 7시트 확대 자동생성', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
