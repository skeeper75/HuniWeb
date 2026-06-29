# Huni-Price-Engine-Design 하네스 — HANDOFF

> CLAUDE.md §18 · 갱신 2026-06-30 · **종단 GO 12건 — 11 상품군 시트 + 박류(foil) 후가공 면적 설계**(박류 데이터 설계 GO·codex가 동판비 silent 과금 돈크리티컬 적발→REV3 교정 후 GO)

## ★박류(foil) 면적 가격 설계 — 데이터 설계 GO (2026-06-30·12번째 종단·DB 미적재)

**박=동판비(setup·.03 1회성)+박가공비(면적→등급A~E→등급×수량구간·일반/특수박·.02)**. 신규 5 comp(동판비 SETUP_LARGE/SMALL+박가공비 PROC_LARGE/SMALL×STD/SPECIAL)·박색상축=proc_cd(박 자식공정 16종 재사용·mint 0)·**7상품(2단/3단접지카드·PUR/무선책자·펄명함·프리미엄쿠폰·프리미엄명함) 본체 공식 합산 바인딩**(addon 아님·명함박 PRF_NAMECARD_FOIL+접지카드 PRF_DGP_E 입증 패턴)·오리지널박명함은 기존 모델 보존(참조만). 골든 8/8 권위 verbatim(Claude+codex 독립 0오차).

**★폐루프 2회(생성≠검증 가치 입증)**: REV2=바인딩 addon 템플릿→본체 공식 합산 전환(addon은 단일단가만 담아 다차원 박가공비 ×qty 폭발). **REV3=codex가 돈크리티컬 적발**(designer·Claude validator E4 PASS 둘 다 놓침)=동판비 setup comp에 proc_cd 게이트 없으면 pricing.py:99-111 NULL 와일드카드로 박 미선택 주문에도 동판비(5,000~64,000) 상시 과금→동판비 use_dims에 proc_cd 추가로 해소(박가공비와 동형).

**돈크리티컬 3건 설계로 해소**: ①7상품 박 0원(comp 부재) ②박 미선택 동판비 상시과금(codex) ③.01이면 ×qty 폭발(.02+min_qty로 해소). **잔여 C트랙(개발팀)**: 면적→등급 환산 엔진 미지원(grade가 NON_QTY/TIER_DIMS 부재)→가변사이즈 상품(접지카드/책자)만 종속·고정사이즈(명함류)는 단일등급 collapse로 현 엔진 작동. **G6**: 명함박 1000구간 단가행 63,000 vs 권위 64,000 라이브 1셀 오적재(교정 후보). **실 적재 승인 대기(누적)**: 신규 5 comp + 동판비/박가공비 단가행(★proc_cd 충전 필수·박가공비 .02 NOT NULL) + 7상품 본체 공식 합산 배선·인간 승인 후 dbmap 위임·C트랙 선결(가변사이즈). 산출=`{01_formula,02_benchmark,03_design,04_validation,05_codex}/*-foil.md`.

## 다음 시작점

**★디자인캘린더 GO 완료**(2026-06-22·11번째·최종 종단·Phase4 1차 CONDITIONAL-GO(E2)→보정→codex Phase5.5 D1/D2 돈크리티컬 적발→designer 폐루프→validator 2차 재게이트 E1~E7 전건 PASS → 박제·이력·CHANGELOG·메모리 갱신 완료). **inline 정찰가 BLOCKED·고정가형 완제 SKU**(7 inline 비정수 역산→정찰가 스냅샷·추측 INSERT 금지). **★11시트 전수 종단 완주**(디지털/스티커/책자/포토북/캘린더/디자인캘린더/실사/아크릴/문구/굿즈파우치/상품악세사리).

**★이번 종단 특이점(생성≠검증 가치 입증)**: 앞 10종단(divergence 0)과 달리 codex가 **돈크리티컬 2건을 독립 적발**해 설계 강화 — D1(본체 정찰가 "qty 무관" 모델링이 엔진계약 `.01 단가형=unit×qty` 위반→저청구·GC-DCAL-9 44,000→80,000·신규 가드 G-DCAL-QTY)·D2(엽서 PRD_000110 editor_yn=N인데 라우팅키 editor_yn=Y→엽서 라우팅 누락). validator 1차가 설계 자체 골든 재유도만 하고 qty 의미 미도전한 간극을 codex가 메움→2차 재게이트 시정.

**다음 후보**: **상품마스터 11 상품군 시트 전수 종단 완료** → 신규 동형 전파 대상 소진. 남은 작업 = ① **실 적재 승인 큐 소진**(아래 누적·인간 승인 후 dbmap 위임) ② 가격표(260527) 전용 시트 중 미커버 차원 점검(있으면) ③ 세트/반제품 완성가 미완분(책자 W3/W4 표지+내지 부품 합산) 닫기. 새 상품군 요청 시 Phase1(cartographer)→benchmark→designer→validator E1~E7→codex Phase5.5 순.

**디자인캘린더 실 적재 승인 대기(누적에 추가)**: 정찰가 채택 ① 경로(Q-DCAL-AUTHORITY 비준 후) PRF_DCAL_{DESK/DESKMINI/POSTCARD/WALL/WALLWIDE} 5공식 신설·COMP_DCAL_FIXED 1 comp 신설(.01 단가형·use_dims=[siz_cd])·7 inline 정찰가 단가행 verbatim 충전·부모 PRD_000108~112 바인딩(product_prices INSERT 금지=G-PRODPRICE). 우드거치대 comp는 캘린더 종단 mint 선행 의존(현 라이브 0행). **컨펌 선결**: Q-DCAL-AUTHORITY(정찰가 채택 vs BLOCKED 유지)·Q-DCAL-ROUTE(주문방법 라우팅·엽서 editor_yn=N 포함)·Q-DCAL-FIN(우드거치대 개당/주문당)·Q-DCAL-ENVELOPE(봉투 귀속)·Q-DCAL-DSC(정찰가×qty base 위 수량구간할인 여부). 돈크리티컬 가드: G-DCAL-QTY(본체 ×qty·qty-불변 금지)·G-PRODPRICE(product_prices INSERT 금지)·G-DCAL-SIZE-PRICE(siz_cd 정찰가 분기).

**포토북 실 적재 승인 대기(누적)**: PRF_PHOTOBOOK_SUM 공식 신설·comp2(BASE/PAGE) 신설·base24 12행(1 BLOCKED)/per2p 4행 단가행 verbatim 충전·부모 PRD_000100 바인딩(product_prices INSERT 금지). **컨펌 선결**: Q-PB-PAGEBASE(돈크리티컬·소프트 base_min=4 vs 하드24)·Q-PB-MAT(표지자재 MAT_005/006/007 del_yn=Y 활성화/재매핑)·Q-PB-SOFT8(10x10 소프트 공란 BLOCKED)·Q-PB-COAT/FACE·Q-PB-DSC. 돈크리티컬 가드 6종(G-PB-PAGE/PRODPRICE/FLAT/SET/BIND01/PAGEBASE) 준수.
- **실 적재 승인 대기(누적)**: 디지털 prc_typ 교정(.01→.02)·아크릴 G-A1 바인딩·실사 후가공 배선·문구(본체 product_prices·떡메모 바인딩·DSC 링크 4건)·책자(W1 제본비 재배선·W2 중철 단가행 교정=과청구 50%)·굿즈/파우치(GP-1 product_prices·GP-2 formula+variant 단가·★GP-2 product_prices INSERT 금지 가드·구간할인 base) — 전부 인간 승인 후 dbm-axis-staged-load/dbm-load-execution/dbm-price-arbiter 위임.

## 진행 현황

| 상품군 | 계산방식 | 게이트 | codex |
|--------|----------|--------|-------|
| 디지털인쇄 | 원자합산형+고정가형 | NO-GO→보정→**재게이트 GO** | NO-GO 지지(medium) |
| 아크릴 | 면적매트릭스형 | **첫 게이트 GO**(보정 0) | GO 지지(**high**) |
| 실사·현수막 | 면적+고정가+수량구간(3방식) | **E1~E7 전건 PASS·GO**(차단0·LOW2) | GO 지지(**high**·divergence 0) |
| 문구 | 고정가+수량구간할인+매트릭스 | **E1~E7 전건 PASS·GO**(차단0·보정0·mint0) | GO 지지(**high**·divergence 0) |
| 책자 | 반제품 세트 부품 합산(두 갈래) | **E1~E7 전건 PASS·GO**(첫 게이트·차단0·보정0) | GO 지지(**high**·divergence 0) |
| 굿즈/파우치 | 고정가형 2서브유형(GP-1 단일/GP-2 변형) | **E1~E7 전건 PASS·GO**(첫 게이트·차단0·LOW1) | GO 지지(**high**·divergence 0) |
| 스티커 | 이산 siz_cd 단가형+세트 합가형(면적 직교) | **재게이트 GO**(E1 CONDITIONAL→PASS·보정-1 RESOLVED·차단0) | GO 지지(**high**·divergence 0) |
| 상품악세사리 | inline 고정가형(굿즈 GP-1/GP-2 동형) | **첫 게이트 GO**(E1~E7 전건·차단0·보정0·LOW1) | GO 지지(**high**·divergence 0) |
| 캘린더 | 원자합산형(디지털인쇄 직계 동형·페이지수 곱·제본비 .01 부당가) | **첫 게이트 GO**(E1~E7 전건·차단0·보정0·LOW1) | GO 지지(**high**·divergence 0) |
| 포토북 | 부품합산 세트형+페이지 선형(★inline 공식화 가능=캘린더 정반대) | **첫 게이트 GO**(E1~E7 전건·차단0·보정0·LOW2) | GO 지지(**high**·divergence 0) |
| 디자인캘린더 | inline 정찰가 BLOCKED·고정가형 완제 SKU(★캘린더 Q-CAL-GOLDEN 결판·11시트 완주) | **2차 재게이트 GO**(E2 CONDITIONAL→PASS·D1/D2 보정·차단0) | **D1/D2 돈크리티컬 적발→교정 후 합의**(divergence 0 아님) |

## 미해결 / 블로커 (전부 DB 미적재·인간 승인 후 dbmap 위임)

**실사·현수막(GO·차단 아님):**
- Q-SB-PUNCH-DIM: 배너 후가공(PUNCH_4/6/8 등 use_dims=[]·NULL) 판별차원 충전+opt_cd 채번. **미충전 배선 절대 금지**(타공 4+6+8 silent 합산 20,000 과청구 실증). 라이브 부분 백필 3건(MESH_PUNCH_6·NORMAL_QBANG_4·MESH_PROC_OPT) 포함.
- Q-SB-PROC-QTY(돈크리티컬): 후가공/거치 1건당 vs ×수량 prc_typ 확정(거치대 ×qty=250,000 과청구 가능).
- Q-SB-CH1: CANVAS_HANGING 차원 정합(validator 라이브 900×900=8,000 확정·셀 표기 분리).
- G-S1: 후가공 배선 0건(PRF_POSTER disp_seq 2~) → 위 컨펌큐 해소 후 배선.

**문구(GO·차단 아님):**
- Q-ST-DSC-LINK(돈크리티컬): DSC_STAT_QTY 링크 누락 4건(PRD_000173/174/175 만년다이어리 하드/레더+097 떡메모) INSERT → 누락 시 +150,000 과청구 실증.
- Q-ST-MEMO1: 메모패드 2사이즈 2가격 = 사이즈 차원 공식 vs 별 prd_cd.
- Q-ST-DSC-DOUBLE: 떡메모 unit 내장 볼륨할인 위 DSC_STAT_QTY 추가 = 의도된 추가할인 vs 이중할인(dbm-price-arbiter 심의).
- 본체 9 product_prices INSERT·떡메모 PRD_000097 바인딩.

**책자(GO·차단 아님):**
- W1 제본비 재배선(PRF_BIND_SUM→활성 COMP_BIND_TWINRING)·W2 중철 단가행 교정(트윈링값 오염→정답 중철값·삭제 JUNGCHEOL 보유) = **돈크리티컬 과청구 50%** → dbm-price-arbiter+인간 승인.
- ★del_yn 필터 부재 확정(삭제 comp도 가격 평가에 포함) — 교훈: 삭제 데이터가 가격에 새는지 코드 확인 필수.
- 완성가(W3/W4 표지+내지 부품 합산)는 codex DV-BK2(component별 effective quantity 엔진 계약)·DV-BK3(역할별 selection 차원)·DV-BK4(저청구 위험)+Q-BK-COVER(표지/내지 단가 소스) 닫은 후. 제본비 .01 정당(교정 불요·디지털 무비판 전이 금지).

**스티커(재게이트 GO·보정-1 RESOLVED·차단0·전건 컨펌큐):**
- ★보정-1 RESOLVED: 052/053/054 일괄 SIZ_172→SIZ_520 교정은 053(mat162)/054(mat163)에 무효(SIZ_520에 mat162/163 단가행 0행). 진원=권위 단가행의 라이브 적재 누락(B01 명시규격 124x186/90x190/100x148/90x110엔 전7소재 완전·바인딩 ISO A는 부분/0). 교정=사이즈축별 분리(A5=059 추가바인딩·A4=SIZ_520+mat162/163 단가행 적재 import xlsx verbatim·A6=바인딩 제거). designer+validator+codex 3원 합의·052도 동일 결함(validator 자기오류 정정).
- 컨펌큐(dbm-price-arbiter 라이브 재실측 선행·추측 INSERT 금지): CV-STK-053/054(경로 택1·🔴 054 active)·CV-STK-A4-MAP(SIZ_520 재사용 vs 신규 채번)·G-STK-1(154→153·243→162 재바인딩)·G-STK-3(SIZ_196/058 단가행 0행·제거vs출처)·G-STK-4(064 잠정·use_yn=N).
- 확정(라이브 결판): B06 팩/타투 prc_typ=.02·이산 siz_cd 단가형(면적 직교·siz_width 0행)·형상=가격축 아님·신규 mint 0(전부 재바인딩). 실 교정 인간 승인 후 dbmap 위임.

**굿즈/파우치(GO·차단 아님):**
- ★GP-2 PRODUCT_PRICE 선점 가드(돈크리티컬·codex 독립 발견): GP-2 상품에 product_prices 1건이라도 있으면 FORMULA 우회→variant 단가 영영 안 먹힘. **적재 가드: GP-2 product_prices INSERT 금지·formula 바인딩만**.
- G-GP-3 평탄화 함정: GP-2 variant축 use_dims 판별차원 충전(평탄화 시 M주문 S가격 오청구).
- Q-GP-FIN1(가공 가산 개당/×수량·돈크리티컬)·Q-GP-OPT1(GP-2 option_items 적재 선결)·Q-GP-CFLAT(C열 단가 추출)·Q-GP-7(폰케이스 등록).
- 자재 오염(.09 74행)·3GAP(SHAPE/COUNT/OPT)은 가격엔진 스코프 밖 → dbmap 자재축 트랙 위임.

**캘린더(GO·차단 아님):**
- ★Q-CAL-GOLDEN(BLOCKED): 디자인캘린더 inline 가격(탁상10400 등)이 단가행 합산과 정수해로 안 맞음(정찰가 스냅샷 추정) → inline vs 산식 어느 게 권위인지 상품마스터↔가격표 교차대조+인간 결판. 추측 단가 INSERT 금지.
- ★G-CAL-PAGE 양방향(codex CX-CAL-A): 페이지수(4~16) 곱을 전역 qty로 넣으면 제본비/가공비도 ×페이지수 과대청구 → 인쇄/용지에만 적용되는 컴포넌트별 수량 산식 필요(양방향 명문화).
- ★Q-CAL-TWINRING-DOUBLE(codex CX-CAL-B): 트윈링제본 가공칸(2000) vs WALL 제본비(5000) 이중계상 경계 → COMP_CALOPT opt_cd에 트윈링 넣지 말 것 박제.
- Q-CAL-BIND-DELYN(WALL 통합 사용 vs DESK130/220/MINI del_yn=Y 부활)·Q-CAL-FIN(가공 add-on 개당 ×수량 vs 정액)·Q-CAL-PROC-INJECT·Q-CAL-DESK130·Q-CAL-PLATE(와이드 SIZ_292↔인쇄비 SIZ_077)·Q-CAL-PKG·Q-CAL-ENVELOPE(캘린더봉투 PRD_000005 addon vs 독립).
- 실 적용=PRF_CAL_* 5공식 신설·formula_components 배선·product_price_formulas 바인딩·COMP_CALOPT_STAND 단가행·OPV 채번. 제본비 단가행 무변경(이미 .01 verbatim). 전부 인간 승인 후 dbm-load-execution/dbm-price-arbiter 위임.

**포토북(GO·차단 아님·10번째 종단):**
- ★Q-PB-PAGEBASE(돈크리티컬): 소프트커버 base_min=4 vs 하드 24(라이브 page_rule 부모만 24/150/2 저장)·per2p 증분 시작점 가름(잘못하면 소프트 페이지 과소/과대청구) → 인간 컨펌.
- ★G-PB-PAGE(돈크리티컬·캘린더 G-CAL-PAGE 동형): 페이지 곱은 per2p(내지비)에만·base24 금지·부수는 둘 다 곱. 누락 시 150P를 15,000에 과소(정답 46,500=3.1배).
- ★G-PB-PRODPRICE(돈크리티컬): base24를 product_prices INSERT 금지(FORMULA 우회 silent·라이브 0행 자동충족)·GP-2/캘린더/악세사리 동형.
- Q-PB-MAT(표지자재 MAT_005/006/007 전건 del_yn=Y·BIND_PUR도 del_yn=Y·가격 무관이나 적재 전 활성화/재매핑)·Q-PB-SOFT8(10x10 소프트 row8 공란=GC-PB-11 BLOCKED·추측 금지)·Q-PB-COAT/FACE(표지 무광코팅 단가행·면지 가격기여)·Q-PB-DSC(수량구간할인 0행 확인).
- 실 적용=PRF_PHOTOBOOK_SUM 공식 1 신설·comp2(BASE[siz,mat]/PAGE[siz]) 신설·base24 12행(1 BLOCKED)/per2p 4행 단가행 verbatim·부모 PRD_000100 바인딩(product_prices 금지). 인쇄/용지/제본/코팅 재사용(mint0). 인간 승인 후 dbm-load-execution/dbm-price-arbiter 위임.

**디자인캘린더(GO·차단 아님·11번째 최종 종단):**
- ★D1 G-DCAL-QTY(돈크리티컬·codex 적발·저청구): 본체 정찰가를 qty-불변으로 모델링 금지. `.01 단가형`은 항상 unit_price×qty(`pricing.py:180-192`·`price-flow-map.md:106`). 본체=1부 정찰가×qty·GC-DCAL-9=80,000(44,000은 저청구 오답·탁상 10부 10,400 고정=104,000 대비 93,600 누락).
- ★D2 엽서 라우팅(codex 적발): 엽서 PRD_000110 editor_yn=N → 라우팅키를 editor_yn 단독에 의존 금지. 신호=가격포함 시트 등재+상품별 PRF_DCAL_* 바인딩(엽서 포함 5상품).
- ★inline 정찰가 BLOCKED 확정[HARD]: 7 inline(10400/9700/6500/6500/4000/9900/24000) 비정수 역산(유효판수 1.313/0.486/...)→정찰가 스냅샷·산식 재현 불가→추측 단가 INSERT 금지. 캘린더 Q-CAL-GOLDEN의 inline 권위 분기 기준 최종 결판처(정수재현→FORMULA·아니면 BLOCKED).
- ★G-DCAL-DUAL: 동일 prd_cd(108~112) 일반캘린더 공식 vs 디자인캘린더 정찰가 이중정의 가능성 → 라이브 product_prices/바인딩/PRF 전부 0행=충돌 미존재(잠재)·결판=정찰가 채택+주문방법 차원 분기.
- 실 적용=PRF_DCAL_* 5공식+COMP_DCAL_FIXED 1 신설·정찰가 단가행 verbatim·부모 108~112 바인딩(product_prices INSERT 금지). 우드거치대 comp=캘린더 종단 mint 선행 의존. 컨펌큐 Q-DCAL-AUTHORITY/ROUTE/FIN/ENVELOPE/DSC. 전부 인간 승인 후 dbm-load-execution/dbm-price-arbiter 위임.

**디지털인쇄:** 박 동판 정액(차선A qty=1 격리 vs B 정액 prc_typ 신설)·인쇄면 통합 단가행 병합·G-7 옵션 자동주입.
**아크릴:** CA-1 미러 합류(mat_cd 판별차원 선결·돈크리티컬)·CA-4 후가공 개당/×수량·CA-3 카라비너 신설.
**공통:** webadmin pricing.py = read-only(엔진 코드 직접 수정 금지).

## 이번 세션 결정 (relitigate 금지)

- 디자인캘린더(11번째·최종 종단)를 Phase1(cartographer∥benchmark)→designer→validator E1~E7→codex Phase5.5 전 파이프라인 종단 → 1차 CONDITIONAL-GO(E2 .03 부재)→보정→codex D1/D2 돈크리티컬 적발→designer 폐루프→**validator 2차 재게이트 E1~E7 전건 PASS=GO** 확정. **★상품마스터 11시트 전수 종단 완주.**
- **★inline 권위 분기 기준 최종 적용[HARD]**: "inline이 단가행 산식으로 정수·일관 재현되면 FORMULA(포토북)·안 되면 정찰가 BLOCKED(캘린더·디자인캘린더)" — 캘린더 Q-CAL-GOLDEN을 디자인캘린더에서 결판(7 inline 비정수 역산→BLOCKED).
- **★codex가 돈크리티컬 2건 독립 적발(divergence 0 깨짐·생성≠검증 가치 입증)**: D1(본체 "qty 무관" → 엔진계약 위반 저청구·GC-DCAL-9 80,000·G-DCAL-QTY 신설)·D2(엽서 editor_yn=N 라우팅). validator 1차가 설계 자체 골든 재유도만 하고 qty 의미 미도전한 간극을 codex가 메움. 엔진계약(`price-flow-map.md:106`·`pricing.py:180-192`)·designer 자체 데이터로 둘 다 codex 정당 확정 → 자동 채택 아닌 라이브/계약 재실측으로 채택.
- **★prc_typ .03 라이브 부존재[HARD]**: PRICE_TYPE enum=.01/.02만. "고정가형 정찰가"=`.01 단가형 + min_qty=1`로 표현(가격 결과 불변·악세사리/캘린더 동형).
- effort high 유지(effortLevel·codex-review.sh effort 인자).

## 건드리지 말 것 (confirmed-good)

- **단가행 값 전부 verbatim 보존**(전 상품군 공통·실 교정/배선은 인간 승인 후 dbmap 위임).
- 확정 GO 산출(**11종단·전 시트 완주**): 디지털 `04_validation/regate-verdict-digitalprint.md`·아크릴/실사/문구/책자/굿즈/스티커/악세사리/캘린더/포토북/**디자인캘린더** `gate-verdict-*.md`·codex reconcile 11종.
- 실사·현수막 본체 라이브 상태(29 PRF·28상품 1:1 바인딩·동형결합 13→7 COMMIT 완료) — 이미 정합·건드리지 말 것.
- 포토북 골든 GC-PB-1~10(허용오차 0·권위 CSV verbatim)·신규 mint 결판(공식1+comp2·search-before-mint 10연속)·base24 internalize(책자 full분해와 정반대) — 검증·codex 합의 완료·재논의 금지.
- 디자인캘린더 inline BLOCKED 결판(7 inline 비정수 역산·정찰가 스냅샷)·G-DCAL-DUAL(라이브 0행 실측)·D1 ×qty 교정(GC-DCAL-9=80,000·G-DCAL-QTY)·D2 엽서 라우팅·prc_typ .03 부존재(=.01+min_qty=1) — validator 2차 재게이트+codex reconcile 완료·재논의 금지.
