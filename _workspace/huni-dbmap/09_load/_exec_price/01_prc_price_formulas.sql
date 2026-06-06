-- 01_prc_price_formulas.sql
-- 단계01 공식 헤더 — PK pk_t_prc_price_formulas(frm_cd).
-- 생성: gen_load_sql.py (손편집 금지). 멱등: ON CONFLICT 가드.
-- BEGIN/COMMIT 미포함 — apply.sql 가 트랜잭션 래핑.

-- src: 01_prc_price_formulas.csv:row2 frm_cd=PRF_ENV_MAKING
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_ENV_MAKING', '봉투제작 소재/수량별 단가', 'FRM_TYPE.02', '단순형: 판매가=[수량행][소재열] (계산공식집초안 행46). 완제품가 1 component. 봉투종류·소재는 component_prices 차원', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;
-- src: 01_prc_price_formulas.csv:row3 frm_cd=PRF_STK_FIXED
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_STK_FIXED', '스티커 규격/소재/수량별 단가', 'FRM_TYPE.02', '단순형: [수량행][출력매수×소재열] (계산공식집초안 행52). 규격(판수)·소재는 component_prices 차원', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;
-- src: 01_prc_price_formulas.csv:row4 frm_cd=PRF_GANGPAN_FIXED
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_GANGPAN_FIXED', '합판도무송 사이즈/소재/수량별 단가', 'FRM_TYPE.02', '단순형: [수량행][사이즈×소재열] (행61). 사이즈mm·소재는 component_prices 차원', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;
-- src: 01_prc_price_formulas.csv:row5 frm_cd=PRF_NAMECARD_FIXED
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_NAMECARD_FIXED', '명함 면/소재/수량별 단가(용지포함)', 'FRM_TYPE.02', '단순형: [수량행][소재×면열] (행33). 용지포함 단품가. 면=comp흡수, 소재=mat 차원', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;
-- src: 01_prc_price_formulas.csv:row6 frm_cd=PRF_PCB_FIXED
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_PCB_FIXED', '엽서북 사이즈/면/페이지/수량별 단가', 'FRM_TYPE.02', '단순형: [수량행][옵션열] (행92). 사이즈=siz, 면·페이지=comp흡수 차원', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;
-- src: 01_prc_price_formulas.csv:row7 frm_cd=PRF_FOLD_SUM
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_FOLD_SUM', '접지 합산형(오시+접지 후가공 구성요소)', 'FRM_TYPE.01', '합산형: 접지비=[제작수량행] 구성요소 (행30). 카드/리플렛 상위 원자합산형 공식의 후가공 구성요소', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;
-- src: 01_prc_price_formulas.csv:row8 frm_cd=PRF_BIND_SUM
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_BIND_SUM', '제본 합산형(제본비 구성요소)', 'FRM_TYPE.01', '합산형: 제본비=[수량행][제본종류열] 구성요소 (행69). 책자 원자합산형 공식의 제본 구성요소', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;
-- src: 01_prc_price_formulas.csv:row9 frm_cd=PRF_TTEOKME_FIXED
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_TTEOKME_FIXED', '떡메모지 사이즈/권당장수/장수별 단가', 'FRM_TYPE.02', '단순형: [수량행][옵션열] (행92, 엽서북/떡메). 사이즈=siz, 권당장수=bdl_qty, 장수=min_qty', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;
-- src: 01_prc_price_formulas.csv:row10 frm_cd=PRF_PHOTOCARD_FIXED
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_PHOTOCARD_FIXED', '포토카드 세트 고정가', 'FRM_TYPE.02', '단순형: [세트당 고정단가] (행43). 20장1세트=bdl_qty 차원. 일반/투명 분리', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;
-- src: 01_prc_price_formulas.csv:row11 frm_cd=PRF_POSTER_FIXED
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_POSTER_FIXED', '포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)', 'FRM_TYPE.02', '단순형: [면적/사이즈×수량][소재별] 완제품가(출력+코팅+가공 포함). 메인=완제품비.06 통가격 + 추가옵션 별도 add-on. 면적시트 31블록', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;
