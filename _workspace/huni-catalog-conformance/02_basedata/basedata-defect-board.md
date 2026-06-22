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
---

# 배치1 — 포토북(PRD_000100~107)·캘린더(PRD_000108~112) 기초데이터 8축 결함 보드

> hcc-basedata-inspector · 2026-06-22 · §21 배치1 Phase 2 · 13상품(포토북 8세트멤버 + 캘린더 5)
> 3원 대조: ① 권위=상품마스터 260610(photobook-l1.csv·design-calendar-l1.csv) ② 라이브=읽기전용 psql
> ③ 도메인=domain-lens.md §B(포토북 세트·캘린더 가공/페이지). 생성측 — 판정은 게이트 재실측.

## 돈크리티컬/구조 결함 (우선)

### D-CAL-PLATE-112 · PRD_000112 와이드벽걸이캘린더 · 판형 · MISMATCH
- **증상:** 판형(plate_sizes)에 전지가 아닌 **작업판**이 적재됨.
- **권위 정답:** 출력용지규격(전지) = **330x660** (라이브 SIZ_000475로 실재).
- **라이브 실측:** plate_sizes.siz_cd = SIZ_000292(304x629) · output_paper_typ_cd=OUTPUT_PAPER_TYPE.03. 304x629 = 와이드벽걸이 작업사이즈와 동일치수.
- **도메인 근거:** domain-lens §4 [HARD] 판형=출력용지(전지). 작업판≠전지. 디지털 019 판형정정(SIZ_000522→SIZ_000499)과 동형.
- **재현 쿼리:** `SELECT pps.prd_cd, pps.siz_cd, s.work_width, s.work_height FROM t_prd_product_plate_sizes pps JOIN t_siz_sizes s ON pps.siz_cd=s.siz_cd WHERE pps.prd_cd='PRD_000112';`
- **라우팅:** dbm-load-builder(판형 siz_cd 정정 SIZ_000292→SIZ_000475). 가격엔진 인스펙터 교차(판형이 단가 차원).

### D-CAL-CRAFT-MATERIAL · PRD_000108/109/111/112 · 자재 · EXTRA (공정의 자재 오염, 4건)
- **증상:** 캘린더가공(삼각대/링)이 종이 자재(t_prd_product_materials)에 섞여 적재됨.
- **권위 정답:** materials = 종이사양(몽블랑190g 등)만. 삼각대·링칼라 = `캘린더사양_캘린더가공`/`링칼라` 컬럼 = **공정축**.
- **라이브 실측:** 108=삼각대(그레이)MAT_000252+링블랙MAT_000253 / 109=링블랙+삼각대(블랙)MAT_000254 / 111=링블랙 / 112=링블랙 — 전부 usage_cd=USAGE.07로 종이와 동일 슬롯에 혼입.
- **도메인 근거:** domain-lens §B.0 "캘린더가공=공정축(자재 아님)·자재로 보면 MISMATCH". [[dbmap-material-option-normalization]] 색/형상 오염 경계.
- **재현 쿼리:** `SELECT pm.prd_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd IN ('PRD_000108','PRD_000109','PRD_000111','PRD_000112') AND (m.mat_nm LIKE '삼각대%' OR m.mat_nm LIKE '링%');`
- **라우팅:** dbm-axis-staged-load(자재 오염 교정 — 삼각대/링 자재행 논리삭제 + 공정으로 재귀속).

### D-CAL-CRAFT-PROCESS · PRD_000108/109 · 공정 · MISMATCH/MISSING (2건, D-CAL-CRAFT-MATERIAL의 짝)
- **증상:** 캘린더가공(삼각대+링)이 공정(t_prd_product_processes)에 미등록.
- **권위 정답:** 108=삼각대(그레이)+링블랙 · 109=삼각대(블랙)+링블랙.
- **라이브 실측:** 108 processes=수축포장(PROC_000076)만 / 109 processes=0행. 가공이 공정으로 없음(자재로만 잘못 들어감).
- **도메인 근거:** domain-lens §B.0 캘린더가공=필수 공정축. 자재 EXTRA와 1:1 짝 결함(같은 데이터가 잘못된 축에 적재).
- **재현 쿼리:** `SELECT prd_cd, proc_cd, mand_proc_yn FROM t_prd_product_processes WHERE prd_cd IN ('PRD_000108','PRD_000109');`
- **라우팅:** dbm-axis-staged-load(자재→공정 축 이동, 위 자재 오염건과 한 트랜잭션).

## 페이지룰 누락 (MISSING, 7건)

### D-CAL-PAGE · PRD_000108~112 · 페이지룰 · MISSING (5건)
- **증상:** 캘린더 고정 페이지사양이 page_rules에 미등록(전 캘린더 0행).
- **권위 정답:** 108=30P · 109=26P · 110=12P · 111=13P · 112=13P (design-calendar 페이지사양 컬럼).
- **라이브 실측:** t_prd_product_page_rules에 108~112 행 0(본체 PRD_000100만 24~150 incr2 존재).
- **도메인 근거:** domain-lens §B.0 "캘린더는 페이지사양이 본질=needed=Y(낱장 디지털과 반대)". 고정페이지=min=max로 등록 가능.
- **재현 쿼리:** `SELECT prd_cd, page_min, page_max FROM t_prd_product_page_rules WHERE prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112');`
- **라우팅:** dbm-load-builder(page_rule 코드행 적재). 단, 캘린더 page_rule의 min/max/incr 해석=고정페이지 vs 가변편집은 CONFIRM 큐.

### D-PB-SEMI-PAGE · PRD_000101 내지 · 페이지룰 · MISSING (1건)
- **증상:** 내지 반제품의 편집기 페이지룰이 반제품 prd에 미환원(본체에만 적재).
- **권위 정답:** 내지페이지 24~150 incr2(편집기).
- **라이브 실측:** 101 page_rules 0행. 본체 PRD_000100에만 24/150/2 적재.
- **도메인 근거:** domain-lens §B.1 세트 superset 모델(반제품 역할축은 본체에 집약). 환원 여부=구조 의도 CONFIRM.
- **재현 쿼리:** `SELECT prd_cd, page_min, page_max FROM t_prd_product_page_rules WHERE prd_cd='PRD_000101';`
- **라우팅:** dbm-correctness-audit(세트 구조 의도 확인 후 — 본체 귀속이 정상이면 MISSING 해제).

## 포토북 반제품 역할축 미환원 (MISSING, 도수/판형/공정 — 세트 superset 모델)

### D-PB-SEMI-ROLE · PRD_000101~107 · 도수·판형·공정 · MISSING (12셀)
- **증상:** 반제품(내지/표지/면지)의 역할축 자식행이 반제품 prd에 0 — 전부 본체 PRD_000100에 집약 적재.
- **권위 정답(역할축):** 내지(101)=도수 양면·판형 작업203x203 · 표지(102/103/105/106/107)=도수 단면·공정 무광코팅 · 면지(104)=공정 PUR제본.
- **라이브 실측:** 101~107 print_options·plate_sizes·processes 자식행 모두 0. 본체 100이 도수2행·판형11행·공정2행(무광·PUR) 보유.
- **도메인 근거:** domain-lens §B.1 [HARD] 라이브=세트 본체 superset 모델(라이브 구조를 사실로 받되 권위 의도와 대조). **자재축은 본체 USAGE 슬롯으로 환원되어 MATCH**지만, 도수/판형/공정은 슬롯 구분 없이 본체에 합쳐져 반제품 단위로는 미환원.
- **판정 주의:** 라이브 적재가 "세트 본체 집약"이 의도된 설계라면 이 12셀은 MISSING이 아니라 구조상 정상(N/A 재판정 대상). **세트 멤버에 역할축을 환원할지 = 구조 의도 CONFIRM**(아래 큐). 게이트·codex 2차 판정 필수.
- **재현 쿼리:** `SELECT 'po' t, prd_cd FROM t_prd_product_print_options WHERE prd_cd BETWEEN 'PRD_000101' AND 'PRD_000107' UNION ALL SELECT 'proc', prd_cd FROM t_prd_product_processes WHERE prd_cd BETWEEN 'PRD_000101' AND 'PRD_000107';` (0행 확인)
- **라우팅:** dbm-correctness-audit(세트 superset vs 멤버 환원 구조 판정 — 교정 아닌 의도 확정 선행).

## 공정 EXTRA — 권위 미근거 (1건, 의심)

### D-CAL-PROC-EXTRA-110 · PRD_000110 엽서캘린더 · 공정 · EXTRA
- **증상:** 권위 캘린더가공 빈칸인데 라이브 공정=타공(PROC_000079) 존재.
- **권위 정답:** 엽서캘린더 캘린더가공 컬럼 빈값(가공 없음·거치대는 추가상품 우드거치대).
- **라이브 실측:** processes=타공(PROC_000079, upr_proc_cd NULL) 1행.
- **도메인 근거:** 엽서캘=벽걸이형 타공(고리 구멍)일 가능성 — 권위 미표기지만 도메인상 정당할 수 있음. 111(벽걸이)도 타공 보유.
- **재현 쿼리:** `SELECT prd_cd, proc_cd FROM t_prd_product_processes WHERE prd_cd='PRD_000110';`
- **라우팅:** codex/게이트 2차(타공이 권위 누락인지 정당 공정인지) — 111 타공도 동일 검토.

## CONFIRM 큐 (배치1)
- **Q-PB-SUPERSET:** 포토북 세트가 본체 superset 적재(101~107 역할축 미환원)가 의도인가, 멤버 환원이 정합인가. → 12 MISSING셀의 verdict 분기.
- **Q-CAL-PAGE-SHAPE:** 캘린더 page_rule을 고정페이지(min=max=30 등)로 적재할지, 편집기 가변(min/max)로 적재할지. design-calendar는 단일 페이지수 표기.
- **Q-CAL-PLATE-112:** 112 판형 304x629(작업판)→330x660(전지) 정정이 맞는지(D-CAL-PLATE-112). 가격엔진 단가 차원 영향.


---

# 배치2 — 책자·문구·상품악세사리 (34상품 × 8축, 272셀)

검사 셀: 272 (needed=Y 129·needed=N 143=N/A). 권위=상품마스터 260610(booklet/stationery/product-accessory-l1).
라이브 실측=읽기전용 psql(2026-06-22). 3원 대조(권위 엑셀↔라이브 t_prd_product_*↔도메인 렌즈).

## 결함 보드 (12건: MISSING 1·CONFIRM 11)

| prd_cd | 상품 | 축 | 판정 | 증상 | 권위 정답 | 라이브 실측 | 도메인 근거 | 재현 쿼리 | 라우팅 |
|---|---|---|---|---|---|---|---|---|---|
| PRD_000070 | PUR책자 | 자재 | MISSING | 자재 전무 | ['*별도설정', '*별도설정'] | 0 | 동형 책자/문구는 자재 다수·본 prd만 0 | `SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000070' AND COALESCE(del_yn,'N')='N';` | dbm-axis-staged-load |
| PRD_000071 | 트윈링책자 | 자재 | CONFIRM | 링/투명커버를 materials에 귀속 | 종이만 권위 | materials에 링/커버 포함 | 5행 USAGE.05/07 | `SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000071' AND COALESCE(del_yn,'N')='N';` | codex/gate(자재경계) |
| PRD_000082 | 하드커버 링책자 | 자재 | CONFIRM | 링/투명커버를 materials에 귀속 | 종이만 권위 | materials에 링/커버 포함 | 3행 USAGE.05/07 | `SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000082' AND COALESCE(del_yn,'N')='N';` | codex/gate(자재경계) |
| PRD_000088 | 레더 링바인더 | 자재 | CONFIRM | 링/투명커버를 materials에 귀속 | 종이만 권위 | materials에 링/커버 포함 | 3행 USAGE.05/07 | `SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000088' AND COALESCE(del_yn,'N')='N';` | codex/gate(자재경계) |
| PRD_000006 | 볼체인 | 사이즈코드 | CONFIRM | 부속물 변형을 sizes 아닌 materials에 등록 | 8변형 sizes | sizes 0·materials 8 | 권위 사이즈(필수)=8변형(색/길이) → 라이브 sizes 0·materials 8행[USAGE.07] 귀속(부속물 변형 축귀속 모호) | `SELECT (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000006' AND COALESCE(del_yn,'N')='N') siz, (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000006' AND COALESCE(del_yn,'N')='N') mat;` | codex/gate(Q-PA-SIZEAXIS) |
| PRD_000007 | 와이어링 | 사이즈코드 | CONFIRM | 부속물 변형을 sizes 아닌 materials에 등록 | 3변형 sizes | sizes 0·materials 3 | 권위 사이즈(필수)=3변형(색/길이) → 라이브 sizes 0·materials 3행[USAGE.07] 귀속(부속물 변형 축귀속 모호) | `SELECT (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000007' AND COALESCE(del_yn,'N')='N') siz, (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000007' AND COALESCE(del_yn,'N')='N') mat;` | codex/gate(Q-PA-SIZEAXIS) |
| PRD_000008 | 천정고리 | 사이즈코드 | CONFIRM | 부속물 변형을 sizes 아닌 materials에 등록 | 1변형 sizes | sizes 0·materials 1 | 권위 사이즈(필수)=1변형(색/길이) → 라이브 sizes 0·materials 1행[USAGE.07] 귀속(부속물 변형 축귀속 모호) | `SELECT (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000008' AND COALESCE(del_yn,'N')='N') siz, (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000008' AND COALESCE(del_yn,'N')='N') mat;` | codex/gate(Q-PA-SIZEAXIS) |
| PRD_000010 | 행택끈 | 사이즈코드 | CONFIRM | 부속물 변형을 sizes 아닌 materials에 등록 | 3변형 sizes | sizes 0·materials 3 | 권위 사이즈(필수)=3변형(색/길이) → 라이브 sizes 0·materials 3행[USAGE.07] 귀속(부속물 변형 축귀속 모호) | `SELECT (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000010' AND COALESCE(del_yn,'N')='N') siz, (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000010' AND COALESCE(del_yn,'N')='N') mat;` | codex/gate(Q-PA-SIZEAXIS) |
| PRD_000012 | 우드거치대 | 사이즈코드 | CONFIRM | 부속물 변형을 sizes 아닌 materials에 등록 | 1변형 sizes | sizes 0·materials 1 | 권위 사이즈(필수)=1변형(색/길이) → 라이브 sizes 0·materials 1행[USAGE.07] 귀속(부속물 변형 축귀속 모호) | `SELECT (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000012' AND COALESCE(del_yn,'N')='N') siz, (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000012' AND COALESCE(del_yn,'N')='N') mat;` | codex/gate(Q-PA-SIZEAXIS) |
| PRD_000013 | 우드봉 | 사이즈코드 | CONFIRM | 부속물 변형을 sizes 아닌 materials에 등록 | 3변형 sizes | sizes 0·materials 3 | 권위 사이즈(필수)=3변형(색/길이) → 라이브 sizes 0·materials 3행[USAGE.07] 귀속(부속물 변형 축귀속 모호) | `SELECT (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000013' AND COALESCE(del_yn,'N')='N') siz, (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000013' AND COALESCE(del_yn,'N')='N') mat;` | codex/gate(Q-PA-SIZEAXIS) |
| PRD_000014 | 우드행거 | 사이즈코드 | CONFIRM | 부속물 변형을 sizes 아닌 materials에 등록 | 3변형 sizes | sizes 0·materials 3 | 권위 사이즈(필수)=3변형(색/길이) → 라이브 sizes 0·materials 3행[USAGE.07] 귀속(부속물 변형 축귀속 모호) | `SELECT (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000014' AND COALESCE(del_yn,'N')='N') siz, (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000014' AND COALESCE(del_yn,'N')='N') mat;` | codex/gate(Q-PA-SIZEAXIS) |
| PRD_000015 | 만년스탬프 리필잉크 | 사이즈코드 | CONFIRM | 부속물 변형을 sizes 아닌 materials에 등록 | 7변형 sizes | sizes 0·materials 7 | 권위 사이즈(필수)=7변형(색/길이) → 라이브 sizes 0·materials 7행[USAGE.07] 귀속(부속물 변형 축귀속 모호) | `SELECT (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000015' AND COALESCE(del_yn,'N')='N') siz, (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000015' AND COALESCE(del_yn,'N')='N') mat;` | codex/gate(Q-PA-SIZEAXIS) |

## 중대 결함 (돈크리/단정)

- **[돈크리] PRD_000070 PUR책자 자재 MISSING**: 권위 내지/표지종이=*별도설정(=종이 옵션 다수 필요). 라이브 t_prd_product_materials 0행. 동형 책자(068·069·071·072…)는 자재 13~49행 등록됐는데 070만 전무 → 종이 선택 불가·용지비 가격구성요소 누락 → 견적 0/오류. 라우팅 dbm-axis-staged-load(자재 재적재).

## CONFIRM 큐 (배치2) — 게이트/codex 독립 재판정 대상

- **Q-PA-SIZEAXIS (악세 8건):** 부속물 변형(볼체인 8색·와이어링 3색·우드봉/행거 길이·리필잉크 7색·천정고리·행택끈·우드거치대)을 권위 `사이즈(필수)` 컬럼이 담는데 라이브는 sizes 0·materials[USAGE.07]에 등록. 사이즈축으로 봐야 하나 materials 귀속이 정합인가? domain-lens C.2(악세=완제 부속물·사이즈+수량+가격만)와 충돌 — sizes vs materials 축귀속 확정 필요. (봉투류 001~005·009·011은 치수형이라 sizes 정상 등록=MATCH).
- **Q-BK-RINGMAT (책자 3건·071·082·088):** 바인더링(화이트/블랙/메탈링)·투명커버(유광/무광)를 materials[USAGE.07/05]에 등록. 권위는 종이만 자재이고 링/투명커버는 제본옵션/표지옵션 컬럼 → 자재 오염인지, usage 슬롯 분리가 정당한지 검토([[dbmap-material-option-normalization]]).
- **Q-ST-PRINTAXIS (문구 3건·173·174·175 도수):** 만년다이어리 하드/레더하드/레더소프트는 권위 인쇄사양 자체가 부재(표지만 명시). 라이브 print_options 0. 권위 부재로 단정 불가 → 도수 needed=Y이나 권위에 도수 데이터 없음(완제 다이어리=내지 인쇄 미적용 가능).
- **Q-097-PAGE (떡메모지 페이지룰):** 권위 페이지사양 부재인데 라이브 page_rules 3~3/3 존재. 떡메모지=낱장 떡제본 메모지 → page_rule EXTRA 의심.
- **레더 커버류 판형/공정/페이지 CONFIRM (088·174·175·172·173·177~181):** 권위 작업/재단/페이지 부재 ↔ 라이브 plate/page 0. 레더·완제 커버 다이어리/노트는 출력판형·페이지룰 미적용이 정합일 수 있음(권위 부재로 MATCH/N-A 경계 — 게이트가 product-viewer 3원 확인).