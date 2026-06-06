-- 05_prd_product_price_formulas.sql
-- 단계05 상품-공식 바인딩 — PK t_prd_product_price_formulas_pkey(prd_cd, frm_cd).
-- 생성: gen_load_sql.py (손편집 금지). 멱등: ON CONFLICT 가드.
-- BEGIN/COMMIT 미포함 — apply.sql 가 트랜잭션 래핑.

-- src: 05_prd_product_price_formulas.csv:row2 PRD_000050/PRF_ENV_MAKING
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000050', 'PRF_ENV_MAKING', '2026-06-01', '봉투제작→소재/수량별 단가 공식. 봉투종류(티켓/소/자켓/대) siz_cd 후니 등록 후 component_prices siz 채움')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row3 PRD_000052/PRF_STK_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000052', 'PRF_STK_FIXED', '2026-06-01', '반칼 자유형 스티커→규격/소재/수량 단가')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row4 PRD_000053/PRF_STK_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000053', 'PRF_STK_FIXED', '2026-06-01', '반칼 자유형 투명스티커→규격/소재/수량 단가')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row5 PRD_000055/PRF_STK_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000055', 'PRF_STK_FIXED', '2026-06-01', '낱장 자유형 스티커(완칼)→규격/수량 단가')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row6 PRD_000066/PRF_GANGPAN_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000066', 'PRF_GANGPAN_FIXED', '2026-06-01', '합판도무송스티커→사이즈/소재/수량 단가')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row7 PRD_000033/PRF_NAMECARD_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000033', 'PRF_NAMECARD_FIXED', '2026-06-01', '스탠다드명함→면/소재/수량(용지포함)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row8 PRD_000031/PRF_NAMECARD_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000031', 'PRF_NAMECARD_FIXED', '2026-06-01', '프리미엄명함→면/소재/수량')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row9 PRD_000032/PRF_NAMECARD_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000032', 'PRF_NAMECARD_FIXED', '2026-06-01', '코팅명함→면/소재/수량')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row10 PRD_000094/PRF_PCB_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000094', 'PRF_PCB_FIXED', '2026-06-01', '엽서북→사이즈/면/페이지/수량')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row11 PRD_000048/PRF_FOLD_SUM
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000048', 'PRF_FOLD_SUM', '2026-06-01', '접지리플렛→접지(오시+접지) 후가공 구성요소')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row12 PRD_000068/PRF_BIND_SUM
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000068', 'PRF_BIND_SUM', '2026-06-01', '중철책자→제본 구성요소')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row13 PRD_000069/PRF_BIND_SUM
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000069', 'PRF_BIND_SUM', '2026-06-01', '무선책자→제본 구성요소')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row14 PRD_000071/PRF_BIND_SUM
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000071', 'PRF_BIND_SUM', '2026-06-01', '트윈링책자→제본 구성요소')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row15 PRD_000070/PRF_BIND_SUM
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000070', 'PRF_BIND_SUM', '2026-06-01', 'PUR책자→제본 구성요소')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row16 PRD_000097/PRF_TTEOKME_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000097', 'PRF_TTEOKME_FIXED', '2026-06-01', '떡메모지→사이즈/권당장수/장수 (wave-2 B-1)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row17 PRD_000024/PRF_PHOTOCARD_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000024', 'PRF_PHOTOCARD_FIXED', '2026-06-01', '포토카드(20장1세트)→세트고정가 (wave-2 B-2)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row18 PRD_000025/PRF_PHOTOCARD_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000025', 'PRF_PHOTOCARD_FIXED', '2026-06-01', '투명포토카드(20장1세트)→세트고정가 (wave-2 B-2)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row19 PRD_000118/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000118', 'PRF_POSTER_FIXED', '2026-06-01', '아트프린트포스터(인화지)→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row20 PRD_000119/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000119', 'PRF_POSTER_FIXED', '2026-06-01', '아트페이퍼포스터(매트지)→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row21 PRD_000120/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000120', 'PRF_POSTER_FIXED', '2026-06-01', '방수포스터(PET)→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row22 PRD_000121/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000121', 'PRF_POSTER_FIXED', '2026-06-01', '접착방수포스터(PVC)→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row23 PRD_000122/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000122', 'PRF_POSTER_FIXED', '2026-06-01', '접착투명포스터(투명PVC)→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row24 PRD_000123/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000123', 'PRF_POSTER_FIXED', '2026-06-01', '아트패브릭포스터(그래픽천)→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row25 PRD_000124/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000124', 'PRF_POSTER_FIXED', '2026-06-01', '린넨패브릭포스터→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row26 PRD_000125/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000125', 'PRF_POSTER_FIXED', '2026-06-01', '캔버스패브릭포스터→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row27 PRD_000126/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000126', 'PRF_POSTER_FIXED', '2026-06-01', '레더아트프린트→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row28 PRD_000127/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000127', 'PRF_POSTER_FIXED', '2026-06-01', '타이벡프린트(하드/소프트)→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row29 PRD_000128/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000128', 'PRF_POSTER_FIXED', '2026-06-01', '메쉬프린트→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row30 PRD_000131/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000131', 'PRF_POSTER_FIXED', '2026-06-01', '프레임리스우드액자→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row31 PRD_000132/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000132', 'PRF_POSTER_FIXED', '2026-06-01', '레더아트액자→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row32 PRD_000135/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000135', 'PRF_POSTER_FIXED', '2026-06-01', '족자포스터→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row33 PRD_000133/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000133', 'PRF_POSTER_FIXED', '2026-06-01', '캔버스행잉포스터→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row34 PRD_000134/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000134', 'PRF_POSTER_FIXED', '2026-06-01', '린넨우드봉족자→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row35 PRD_000136/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000136', 'PRF_POSTER_FIXED', '2026-06-01', 'PET배너→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row36 PRD_000137/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000137', 'PRF_POSTER_FIXED', '2026-06-01', '메쉬배너→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row37 PRD_000138/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000138', 'PRF_POSTER_FIXED', '2026-06-01', '일반현수막→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row38 PRD_000139/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000139', 'PRF_POSTER_FIXED', '2026-06-01', '메쉬현수막→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row39 PRD_000144/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000144', 'PRF_POSTER_FIXED', '2026-06-01', '미니스탠딩보드→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row40 PRD_000145/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000145', 'PRF_POSTER_FIXED', '2026-06-01', '미니배너→소재/사이즈/수량 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row41 PRD_000129/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000129', 'PRF_POSTER_FIXED', '2026-06-01', '폼보드(B11 중첩)→사이즈/소재 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row42 PRD_000130/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000130', 'PRF_POSTER_FIXED', '2026-06-01', '포맥스보드(B11 중첩)→사이즈/소재 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row43 PRD_000142/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000142', 'PRF_POSTER_FIXED', '2026-06-01', '유광아크릴스티커(B27 중첩)→사이즈/소재 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row44 PRD_000143/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000143', 'PRF_POSTER_FIXED', '2026-06-01', '미러아크릴스티커(B27 중첩)→사이즈/소재 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row45 PRD_000140/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000140', 'PRF_POSTER_FIXED', '2026-06-01', '무광시트커팅(B27 중첩)→사이즈/소재 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
-- src: 05_prd_product_price_formulas.csv:row46 PRD_000141/PRF_POSTER_FIXED
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000141', 'PRF_POSTER_FIXED', '2026-06-01', '홀로그램시트커팅(B27 중첩)→사이즈/소재 완제품가(포함항목 통가격)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
