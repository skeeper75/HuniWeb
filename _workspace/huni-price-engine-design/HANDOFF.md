# Huni-Price-Engine-Design 하네스 — HANDOFF

> CLAUDE.md §18 · 갱신 2026-06-22 · 종단 GO 8건(상품악세사리 첫 게이트 GO 완료)

## 다음 시작점

**★상품악세사리 GO 완료**(2026-06-22·첫 게이트 GO→codex high divergence 0→박제·이력·커밋). 굿즈 GP-1/GP-2 직계 동형(inline 고정가형)·신규 mint=공식3+comp3·OTC 이중등록 사실무근 정정. 8종단 완주 = 계산방식 전수 커버.

**다음 후보(동형 전파)**: 캘린더(공정택일그룹). Phase1(cartographer 지도)→benchmark→designer→validator E1~E7→codex Phase5.5 순.

**그 다음 남은 동형 전파 후보**: 캘린더(공정택일그룹) 외 미종단 상품군.
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

**디지털인쇄:** 박 동판 정액(차선A qty=1 격리 vs B 정액 prc_typ 신설)·인쇄면 통합 단가행 병합·G-7 옵션 자동주입.
**아크릴:** CA-1 미러 합류(mat_cd 판별차원 선결·돈크리티컬)·CA-4 후가공 개당/×수량·CA-3 카라비너 신설.
**공통:** webadmin pricing.py = read-only(엔진 코드 직접 수정 금지).

## 이번 세션 결정 (relitigate 금지)

- 실사·현수막 검증 재개 → Phase4(hpe-validator E1~E7 GO)·Phase5.5(codex high·divergence 0) 완료 → **GO 확정·메모리 박제**([[huni-price-engine-design-harness]]).
- codex 부가발견 DV-SB1(GC-S7 "280,000"/"350,000" 셀 표기 모순) → 350,000 통일 정정 완료(가격결론 무영향).
- CLAUDE.md §18 변경이력에 실사·현수막 GO 추가·"하네스 초기 구성" 행은 `CHANGELOG.md`로 이동(최근 3건 유지).
- effort high 유지(이전 세션 결정·effortLevel medium→high·codex-review.sh effort 인자).

## 건드리지 말 것 (confirmed-good)

- **단가행 값 전부 verbatim 보존**(전 상품군 공통·실 교정/배선은 인간 승인 후 dbmap 위임).
- 확정 GO 산출: 디지털 `04_validation/regate-verdict-digitalprint.md`·아크릴 `gate-verdict-acrylic.md`·실사 `gate-verdict-silsa-banner.md`·codex reconcile 3종.
- 실사·현수막 본체 라이브 상태(29 PRF·28상품 1:1 바인딩·동형결합 13→7 COMMIT 완료) — 이미 정합·건드리지 말 것.
