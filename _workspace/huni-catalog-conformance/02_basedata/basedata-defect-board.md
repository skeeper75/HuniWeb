# basedata-defect-board.md — 디지털인쇄 8축 기초데이터 정합 결함 보드

> **Phase 2 — hcc-basedata-inspector(생성측)** · 2026-06-22 · `huni-catalog-conformance` §21
> 스코프: 디지털인쇄 36상품(PRD_000016~PRD_000051) × 8축 = 288셀. 권위[HARD]=상품마스터 260610.
> 3원 대조: ① 권위 엑셀(authority-spec) ② 라이브 실측(읽기전용 psql) ③ 인쇄 도메인(domain-lens).
> **판정은 게이트가 독립 재실측**(자기 셀 자기 승인 금지). 직접 교정 금지=라우팅만.

## 요약
- 셀: 288 (MATCH 158 · N/A 85 · MISSING 31 · MISMATCH 9 · EXTRA 2 · CONFIRM 3)
- 결함 행: 45 (HIGH 24 · MED 5 · LOW 16)

### 돈/견적 영향 Top (HIGH)
1. **인쇄옵션 미적재(11 MISSING·6 MISMATCH)** — 별색인쇄(화이트/클리어/핑크/금/은)가 라이브 processes·print_options·option_items 어디에도 미연결(별색 family PROC_000007~012 마스터는 존재·product_processes 링크 0). 커팅(모양엽서/명함/라벨)·일부 접지도 미적재. 별색·커팅=가격 가산 옵션 → **견적 누락(돈크리티컬)**.
2. **판형 오적재/혼입(EXTRA 1·MISMATCH 2·CONFIRM 3)** — component_prices.siz_cd=판형이 가격 단가행 기준. 지그재그엽서(030) 권위 330x660 vs 라이브 154x604(.03), 와이드리플렛(049) 330x660 vs 635x303 → **단가행 오매칭 위험**. 투명엽서(019) 완성품 사이즈(102x152 등)가 plate_sizes에 혼입(output_paper_typ NULL).
3. **자재 별도설정 미적재(형압명함 038, 1 MISSING)** — 종이 슬롯 0행 → 용지비(COMP_PAPER) 산출 불가.

## 결함 행 (축 → 영향순)

| prd_cd | 상품 | 축 | 판정 | 영향 | 증상 | 권위 정답 | 라이브 실측 | 도메인 근거 | 라우팅 |
|--------|------|----|------|------|------|-----------|-------------|-------------|--------|
| PRD_000019 | 투명엽서 | 인쇄옵션 | MISMATCH | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['별색인쇄'] | 화이트인쇄(없음), 화이트인쇄(단면), 화이트인쇄(양면) | procs=['직각', '둥근'] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000020 | 화이트인쇄엽서 | 인쇄옵션 | MISSING | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['별색인쇄'] | 화이트인쇄(없음), 화이트인쇄(단면), 화이트인쇄(양면), 클리어인쇄(없음), 클리어인쇄(단면),  | procs=[] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000021 | 핑크별색엽서 | 인쇄옵션 | MISSING | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['별색인쇄'] | 핑크인쇄(없음), 핑크인쇄(단면), 핑크인쇄(양면) | procs=[] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000022 | 금은별색엽서 | 인쇄옵션 | MISSING | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['별색인쇄'] | 금색인쇄(없음), 금색인쇄(단면), 금색인쇄(양면), 은색인쇄(없음), 은색인쇄(단면), 은색인쇄( | procs=[] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000023 | 모양엽서 | 인쇄옵션 | MISSING | HIGH(가격/견적) | 인쇄옵션 라이브 0행 | 자유형 | 0 | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000024 | 포토카드 | 인쇄옵션 | MISMATCH | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['별색인쇄'] | 화이트인쇄(단면), 무광코팅(양면), 유광코팅(양면) | procs=['무광', '직각', '유광', '둥근'] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000025 | 투명포토카드 | 인쇄옵션 | MISMATCH | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['별색인쇄'] | 화이트인쇄(단면) | procs=['직각', '둥근'] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000028 | 미니접지카드 | 인쇄옵션 | MISSING | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['접지'] | 2단 가로접지 / ★사이즈선택 : 90x50 / 86x52, 2단 세로접지 / ★사이즈선택 : 50 | procs=[] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000035 | 모양명함 | 인쇄옵션 | MISSING | HIGH(가격/견적) | 인쇄옵션 라이브 0행 | 한쪽라운딩, 나뭇잎, 큰라운딩, 클래식, 자유형 | 0 | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000036 | 미니모양명함 | 인쇄옵션 | MISSING | HIGH(가격/견적) | 인쇄옵션 라이브 0행 | 사각라운딩, 물방울, 원형, 자유형 | 0 | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000039 | 투명명함 | 인쇄옵션 | MISMATCH | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['별색인쇄'] | 화이트인쇄(단면) | procs=['직각', '둥근'] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000040 | 화이트인쇄명함 | 인쇄옵션 | MISMATCH | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['별색인쇄'] | 화이트인쇄(단면), 화이트인쇄(양면), 클리어인쇄(없음), 클리어인쇄(단면), 클리어인쇄(양면) | procs=['둥근', '직각'] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000043 | 인쇄배경지(OPP봉투타입) | 인쇄옵션 | MISSING | HIGH(가격/견적) | 인쇄옵션 라이브 0행 | 기본형(커팅없음), 타공형, 핀고정형, 북마크1개입, 스마트톡형, 북마크2개입, 카드고정형, 키링형 | 0 | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000044 | 인쇄배경지(투명케이스타입) | 인쇄옵션 | MISSING | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['접지'] | 기본형, 상하접지형 | procs=[] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000045 | 인쇄헤더택 | 인쇄옵션 | MISSING | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['접지'] | 기본형(접지만), 타공형 | procs=[] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000046 | 라벨/택 | 인쇄옵션 | MISSING | HIGH(가격/견적) | 인쇄옵션 라이브 0행 | 사각, 라운딩, 삼각, 팔각, 원형, 사각리본, 삼각리본, 리본, ★사이즈선택 : 커팅모양다름 | 0 | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000048 | 접지리플렛 | 인쇄옵션 | MISMATCH | HIGH(가격/견적) | 인쇄옵션 라이브 미적재: ['접지'] | 코팅없음, 무광코팅(단면), 무광코팅(양면), 유광코팅(단면), 유광코팅(양면), ★종이두께선택시  | procs=['무광', '유광', '가변텍스트', '가변이미지'] | 별색=PROC_000007 family(clr_cd=NULL)·코팅=유광/무광공정·접지=*접지공정·커팅=모양공정(domain- | dbm-correctness-audit |
| PRD_000019 | 투명엽서 | 판형 | EXTRA | HIGH(가격/견적) | 완성품 사이즈가 plate_sizes에 혼입(output_paper_typ NULL) | 315x467 | 102x152, 137x137, 150x212 | 판형=출력판형 전용([[dbmap-platesize-is-output-paper]]) | 변경→dbm-correctness-audit |
| PRD_000030 | 지그재그엽서 | 판형 | MISMATCH | HIGH(가격/견적) | 판형 불일치 | 330x660 | 154x604, 604x154 | 출력판형 미스매치 | dbm-correctness-audit |
| PRD_000037 | 오리지널박명함 | 판형 | CONFIRM | HIGH(가격/견적) | 권위 판형 빈값 vs 라이브 plate(비판형 상품) | (빈값) | 90x50 | 봉투/썬캡=비판형(authority-spec §4 needed=N) | CONFIRM 인간확인·needed 재판정 |
| PRD_000049 | 와이드 접지리플렛 | 판형 | MISMATCH | HIGH(가격/견적) | 판형 불일치 | 330x660 | 635x303, 644x303, 646x303 | 출력판형 미스매치 | dbm-correctness-audit |
| PRD_000050 | 봉투제작 | 판형 | CONFIRM | HIGH(가격/견적) | 권위 판형 빈값 vs 라이브 plate(비판형 상품) | (빈값) | 238x262, 225x193, 510x387, 262x238 | 봉투/썬캡=비판형(authority-spec §4 needed=N) | CONFIRM 인간확인·needed 재판정 |
| PRD_000051 | 썬캡 | 판형 | CONFIRM | HIGH(가격/견적) | 권위 판형 빈값 vs 라이브 plate(비판형 상품) | (빈값) | 313x400 | 봉투/썬캡=비판형(authority-spec §4 needed=N) | CONFIRM 인간확인·needed 재판정 |
| PRD_000038 | 형압명함 | 자재 | MISSING | HIGH(가격/견적) | 별도설정 자재 라이브 0 | *별도설정 | 0 | 종이 슬롯 미적재 | dbm-axis-staged-load |
| PRD_000048 | 접지리플렛 | 사이즈코드 | MISSING | MED(견적옵션) | 사이즈 라이브 미적재 | A5 (반접지), A4 (반접지), A4 (3단접지), A4 (4단병풍접지), A3 (반접지), A | 0 | 접지리플렛=접지형태 사이즈(A4반접지 등)·라이브 product_sizes 0행(plate만 적재) | siz/코드행→dbm-load-builder |
| PRD_000049 | 와이드 접지리플렛 | 사이즈코드 | MISSING | MED(견적옵션) | 사이즈 라이브 미적재 | 3절 (3단접지), 3절 (4단대문접지), 3절 (4단병풍접지) | 0 | 접지리플렛=접지형태 사이즈(A4반접지 등)·라이브 product_sizes 0행(plate만 적재) | siz/코드행→dbm-load-builder |
| PRD_000050 | 봉투제작 | 사이즈코드 | MISSING | MED(견적옵션) | 사이즈 라이브 미적재 | 대봉투, 소봉투, 자켓봉투, 티켓봉투 | 0 | 완성품 재단치수 필수 | siz/코드행→dbm-load-builder |
| PRD_000028 | 미니접지카드 | 공정 | MISSING | MED(견적옵션) | 후가공/박 ['1개', '2개', '3개', '박(없음)', '박(있음)'] 라이브 미적재 | 1개, 2개, 3개, 박(없음), 박(있음) | 0 | 후가공/박/형압 공정행 필요 | dbm-correctness-audit |
| PRD_000038 | 형압명함 | 공정 | MISMATCH | MED(견적옵션) | 공정 ['형압'] 라이브 미적재 | 직각, 둥근, 형압(없음), 형압(음각), 형압(양각) | 둥근, 직각 | 후가공/박/형압 일부 누락 | dbm-correctness-audit |
| PRD_000024 | 포토카드 | 묶음수 | EXTRA | LOW(옵션표시) | 묶음수 needed=N인데 라이브 적재 | (없음) | ['20', 'QTY_UNIT.06'] | 건수표기 없는 상품(domain-lens §7) | 변경→dbm-correctness-audit |
| PRD_000031 | 프리미엄명함 | 묶음수 | MISSING | LOW(옵션표시) | 명함 건수(박스단위) 라이브 미적재 | 건수(옵션)=Y | 0 | 명함류 박스단위 묶음(domain-lens §7) | dbm-load-builder |
| PRD_000032 | 코팅명함 | 묶음수 | MISSING | LOW(옵션표시) | 명함 건수(박스단위) 라이브 미적재 | 건수(옵션)=Y | 0 | 명함류 박스단위 묶음(domain-lens §7) | dbm-load-builder |
| PRD_000033 | 스탠다드명함 | 묶음수 | MISSING | LOW(옵션표시) | 명함 건수(박스단위) 라이브 미적재 | 건수(옵션)=Y | 0 | 명함류 박스단위 묶음(domain-lens §7) | dbm-load-builder |
| PRD_000034 | 펄명함 | 묶음수 | MISSING | LOW(옵션표시) | 명함 건수(박스단위) 라이브 미적재 | 건수(옵션)=Y | 0 | 명함류 박스단위 묶음(domain-lens §7) | dbm-load-builder |
| PRD_000035 | 모양명함 | 묶음수 | MISSING | LOW(옵션표시) | 명함 건수(박스단위) 라이브 미적재 | 건수(옵션)=Y | 0 | 명함류 박스단위 묶음(domain-lens §7) | dbm-load-builder |
| PRD_000036 | 미니모양명함 | 묶음수 | MISSING | LOW(옵션표시) | 명함 건수(박스단위) 라이브 미적재 | 건수(옵션)=Y | 0 | 명함류 박스단위 묶음(domain-lens §7) | dbm-load-builder |
| PRD_000037 | 오리지널박명함 | 묶음수 | MISSING | LOW(옵션표시) | 명함 건수(박스단위) 라이브 미적재 | 건수(옵션)=Y | 0 | 명함류 박스단위 묶음(domain-lens §7) | dbm-load-builder |
| PRD_000038 | 형압명함 | 묶음수 | MISSING | LOW(옵션표시) | 명함 건수(박스단위) 라이브 미적재 | 건수(옵션)=Y | 0 | 명함류 박스단위 묶음(domain-lens §7) | dbm-load-builder |
| PRD_000039 | 투명명함 | 묶음수 | MISSING | LOW(옵션표시) | 명함 건수(박스단위) 라이브 미적재 | 건수(옵션)=Y | 0 | 명함류 박스단위 묶음(domain-lens §7) | dbm-load-builder |
| PRD_000040 | 화이트인쇄명함 | 묶음수 | MISSING | LOW(옵션표시) | 명함 건수(박스단위) 라이브 미적재 | 건수(옵션)=Y | 0 | 명함류 박스단위 묶음(domain-lens §7) | dbm-load-builder |
| PRD_000016 | 프리미엄엽서 | 페이지룰 | MISSING | LOW(옵션표시) | 페이지룰 라이브 미적재 | 판수 표기 | 0 | 접지/책자 페이지 제약(domain-lens §9) | dbm-load-builder |
| PRD_000017 | 코팅엽서 | 페이지룰 | MISSING | LOW(옵션표시) | 페이지룰 라이브 미적재 | 판수 표기 | 0 | 접지/책자 페이지 제약(domain-lens §9) | dbm-load-builder |
| PRD_000018 | 스탠다드엽서 | 페이지룰 | MISSING | LOW(옵션표시) | 페이지룰 라이브 미적재 | 판수 표기 | 0 | 접지/책자 페이지 제약(domain-lens §9) | dbm-load-builder |
| PRD_000019 | 투명엽서 | 페이지룰 | MISSING | LOW(옵션표시) | 페이지룰 라이브 미적재 | 판수 표기 | 0 | 접지/책자 페이지 제약(domain-lens §9) | dbm-load-builder |
| PRD_000027 | 2단접지카드 | 페이지룰 | MISSING | LOW(옵션표시) | 페이지룰 라이브 미적재 | 판수 표기 | 0 | 접지/책자 페이지 제약(domain-lens §9) | dbm-load-builder |

## 재현 쿼리 (psql 읽기전용·한 줄)

- **PRD_000019 인쇄옵션** (MISMATCH): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000019' AND pp.del_yn='N';`
- **PRD_000020 인쇄옵션** (MISSING): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000020' AND pp.del_yn='N';`
- **PRD_000021 인쇄옵션** (MISSING): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000021' AND pp.del_yn='N';`
- **PRD_000022 인쇄옵션** (MISSING): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000022' AND pp.del_yn='N';`
- **PRD_000023 인쇄옵션** (MISSING): `SELECT * FROM t_prd_product_processes WHERE prd_cd='PRD_000023' AND del_yn='N';`
- **PRD_000024 인쇄옵션** (MISMATCH): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000024' AND pp.del_yn='N';`
- **PRD_000025 인쇄옵션** (MISMATCH): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000025' AND pp.del_yn='N';`
- **PRD_000028 인쇄옵션** (MISSING): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000028' AND pp.del_yn='N';`
- **PRD_000035 인쇄옵션** (MISSING): `SELECT * FROM t_prd_product_processes WHERE prd_cd='PRD_000035' AND del_yn='N';`
- **PRD_000036 인쇄옵션** (MISSING): `SELECT * FROM t_prd_product_processes WHERE prd_cd='PRD_000036' AND del_yn='N';`
- **PRD_000039 인쇄옵션** (MISMATCH): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000039' AND pp.del_yn='N';`
- **PRD_000040 인쇄옵션** (MISMATCH): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000040' AND pp.del_yn='N';`
- **PRD_000043 인쇄옵션** (MISSING): `SELECT * FROM t_prd_product_processes WHERE prd_cd='PRD_000043' AND del_yn='N';`
- **PRD_000044 인쇄옵션** (MISSING): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000044' AND pp.del_yn='N';`
- **PRD_000045 인쇄옵션** (MISSING): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000045' AND pp.del_yn='N';`
- **PRD_000046 인쇄옵션** (MISSING): `SELECT * FROM t_prd_product_processes WHERE prd_cd='PRD_000046' AND del_yn='N';`
- **PRD_000048 인쇄옵션** (MISMATCH): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000048' AND pp.del_yn='N';`
- **PRD_000019 판형** (EXTRA): `SELECT siz_cd,output_paper_typ_cd,note FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000019' AND del_yn='N' AND (output_paper_typ_cd IS NULL OR output_paper_typ_cd='');`
- **PRD_000030 판형** (MISMATCH): `SELECT siz_cd,output_paper_typ_cd FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000030' AND del_yn='N';`
- **PRD_000037 판형** (CONFIRM): `SELECT siz_cd,output_paper_typ_cd FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000037' AND del_yn='N';`
- **PRD_000049 판형** (MISMATCH): `SELECT siz_cd,output_paper_typ_cd FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000049' AND del_yn='N';`
- **PRD_000050 판형** (CONFIRM): `SELECT siz_cd,output_paper_typ_cd FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000050' AND del_yn='N';`
- **PRD_000051 판형** (CONFIRM): `SELECT siz_cd,output_paper_typ_cd FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000051' AND del_yn='N';`
- **PRD_000038 자재** (MISSING): `SELECT mat_cd FROM t_prd_product_materials WHERE prd_cd='PRD_000038' AND del_yn='N';`
- **PRD_000048 사이즈코드** (MISSING): `SELECT siz_cd FROM t_prd_product_sizes WHERE prd_cd='PRD_000048' AND del_yn='N';`
- **PRD_000049 사이즈코드** (MISSING): `SELECT siz_cd FROM t_prd_product_sizes WHERE prd_cd='PRD_000049' AND del_yn='N';`
- **PRD_000050 사이즈코드** (MISSING): `SELECT siz_cd FROM t_prd_product_sizes WHERE prd_cd='PRD_000050' AND del_yn='N';`
- **PRD_000028 공정** (MISSING): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000028' AND pp.del_yn='N';`
- **PRD_000038 공정** (MISMATCH): `SELECT pm.proc_nm FROM t_prd_product_processes pp JOIN t_proc_processes pm ON pm.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000038' AND pp.del_yn='N';`
- **PRD_000024 묶음수** (EXTRA): `SELECT bdl_qty,bdl_unit_typ_cd FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000024' AND del_yn='N';`
- **PRD_000031 묶음수** (MISSING): `SELECT * FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000031' AND del_yn='N';`
- **PRD_000032 묶음수** (MISSING): `SELECT * FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000032' AND del_yn='N';`
- **PRD_000033 묶음수** (MISSING): `SELECT * FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000033' AND del_yn='N';`
- **PRD_000034 묶음수** (MISSING): `SELECT * FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000034' AND del_yn='N';`
- **PRD_000035 묶음수** (MISSING): `SELECT * FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000035' AND del_yn='N';`
- **PRD_000036 묶음수** (MISSING): `SELECT * FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000036' AND del_yn='N';`
- **PRD_000037 묶음수** (MISSING): `SELECT * FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000037' AND del_yn='N';`
- **PRD_000038 묶음수** (MISSING): `SELECT * FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000038' AND del_yn='N';`
- **PRD_000039 묶음수** (MISSING): `SELECT * FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000039' AND del_yn='N';`
- **PRD_000040 묶음수** (MISSING): `SELECT * FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000040' AND del_yn='N';`
- **PRD_000016 페이지룰** (MISSING): `SELECT * FROM t_prd_product_page_rules WHERE prd_cd='PRD_000016';`
- **PRD_000017 페이지룰** (MISSING): `SELECT * FROM t_prd_product_page_rules WHERE prd_cd='PRD_000017';`
- **PRD_000018 페이지룰** (MISSING): `SELECT * FROM t_prd_product_page_rules WHERE prd_cd='PRD_000018';`
- **PRD_000019 페이지룰** (MISSING): `SELECT * FROM t_prd_product_page_rules WHERE prd_cd='PRD_000019';`
- **PRD_000027 페이지룰** (MISSING): `SELECT * FROM t_prd_product_page_rules WHERE prd_cd='PRD_000027';`

## CONFIRM (권위 vs 도메인 충돌 — 인간 확인, 결함 아님)

- **판형 needed 충돌(037 오리지널박명함·050 봉투제작·051 썬캡)**: 권위 엑셀 출력용지규격 빈값(비판형) + authority-spec §4는 needed=N 규정, 그러나 체크리스트는 판형 36상품 전부 needed=Y. 라이브엔 비판형 plate(90x50·봉투형·313x400) 존재. → **needed 재판정** 필요(authority-spec §5 Q-DGP-PLATE 연관).
- (참고) 030/049 판형 MISMATCH는 §5 Q-DGP-PLATE(3절 vs 국4절 판형 분기) 도메인 모호와 연관 — price-engine 인스펙터·게이트 교차 확인 권장.