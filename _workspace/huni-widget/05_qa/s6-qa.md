# S6 QA Report — Huni-Widget 옵셋 캘린더(HLCLSTD·HLCLWAL) 비교 QA (PriceTable3D 변형 판정 + 가격 round-trip + INV-3 코어 0줄)

- 검증 도구: `tsc --noEmit` EXIT 0 / `vitest run` **76 passed (11 files, 65→76)** / `vite build` 성공(dist/widget.js 746.72kB / gzip 134.74kB) + 정량 grep(INV-2) + `git diff`·`git show 8863cbd`(INV-3) + 캡처(ground truth)↔fixture↔직렬화 shape diff
- 대상(우리): **HLCLSTD**(탁상 캘린더, offset2023_price) + **HLCLWAL**(벽걸이 캘린더, offset2023_price) — `mapProduct`/`serializeRedPriceRequest`/`mapPriceResponse` 어댑터 출력 + `createRedAdapter` quote 경로
- 레퍼런스(Red, ground truth): `05_qa/captures/s6_cal_{HLCLSTD,HLCLWAL}.json` — **로그인 라이브 캡처**(mb_cust_cod 10000000), 각 SKU 3 priceCall(침묵 0 + PRICE>0 2종)
- 검증 대상 변경: **① 어댑터 PRN_CNT 폐쇄 래더 enum 분기(red-adapter.ts +62)** **② red-types RedPrnCntInfo 래더 필드 + disable null 평탄화(+21)** **③ fixture-source HLCL 라우팅(+14)** **④ fixture 4종 신규(product/price ×2)** **⑤ test 신규(+228)**
- 게이트 현황: **tsc EXIT 0 / vitest 76 passed(S5까지 65 → S6 신규 11 = 76, 기존 65 무회귀) / vite build 성공** — 실측 재확인 완료. 코드·fixture 수정 0건(read-only 검증 + QA 노트만 작성).

---

## 종합 판정: **GO**

S6 must-pass 6개 전부 PASS. **명세 §0 판정("옵셋 캘린더 = 책자 PriceTable3D 변형, 신규 componentType 0, 위젯 코어 0변경")이 캡처 ground truth ↔ 어댑터 출력 교차비교로 실증됨.** 커밋 8863cbd가 `src/widget/`·`src/contract/`를 **단 한 파일도 건드리지 않음**(전 변경이 `src/adapters/red/` 3종 + fixtures 4종 + test 1종에 격리) → INV-3 코어 0줄을 커밋 레벨에서 입증. NC 패턴(신규 componentType 불요)이 S4·S5에 이어 **세 번째 실증**. Blocker/Major 결함 0건. OPEN 항목(PRN_CNT store 배선·DOSU_COD)은 비차단 — 사유는 아래 [정직성] 절에서 GO 판정과 함께 명시.

### [핵심 정직성 판정 1] PRN_CNT enum→printCount store 배선 미완 = **GO (현 stage에서 정당, S5 echo 전례와 동형)**

빌더가 OPEN으로 남긴 항목: PRN_CNT 폐쇄 래더는 `GRP_PRN_CNT` select-box enum으로 **어댑터 출력엔 존재**하나(test L92-105 PASS), 사용자가 이 select에서 고른 값이 `printCount`로 흘러 `buildPriceRequest`에 echo되는 **store 배선은 미구현**이다. round-trip 테스트(L140, L168)는 `{ ...buildPriceRequest(state), printCount: 500 }`로 **명시 구성**해 어댑터 직렬화 정합만 증명한다(UI selection flow 아님).

**이것이 S6 GO를 막지 않는 이유:**

| 검증축 | 판정 |
|--------|------|
| **계약·직렬화 정확성** | `serializeRedPriceRequest`가 printCount→PRN_CNT, quantity→ORD_CNT 분리 직렬화하는 부분은 S5에서 확립·검증 완료. printCount=500 명시 시 ORD_INFO.PRN_CNT=500 정확(test L149 PASS). **배선만 남고 직렬화는 완전.** |
| **S5 echo 전례 동형** | S5 QA가 이미 판정: "현 stage UI에 printCount selection 미노출 → buildPriceRequest +1줄은 채울 값 없는 죽은 코드 → 어댑터 `?? 1` 흡수가 정확." S6은 한 발 더 나아가 **enum 그룹을 어댑터에 노출**(GRP_PRN_CNT select-box)했으나 store→buildPriceRequest 배선이 아직 없다. 즉 S6은 selection 소스(enum 그룹)는 생겼으나 그것을 store가 읽어 printCount로 매핑하는 1줄이 미배선. |
| **INV-3 우선** | 그 배선 1줄은 `src/widget/stores/`(위젯 코어)에 들어가므로 지금 추가하면 INV-3 코어 0줄과 충돌. 빌더가 "코어 0 우선" 원칙(명세 §4.1 #3)대로 보류한 것은 명세 의도에 부합. |
| **현 검증 충분성** | S6의 must-pass는 "PriceTable3D 변형 판정 + 가격 round-trip + 코어 0줄"이며, 이는 어댑터 직렬화 정합으로 전부 입증됨. printCount UI flow는 **다음 stage(또는 후니 옵션 노출 시)** 임계경로. |

**결론(GO):** 배선 미완은 **검증 깊이의 한계이지 결함이 아니다.** 단, 잔존 리스크 1건 — 실제 위젯 UI에서 사용자가 PRN_CNT를 안 고르면 `printCount=undefined → 어댑터 ?? 1 → PRN_CNT=1`로 직렬화되어 **단가가 PRN_CNT=1 기준**이 된다(가드는 통과, 침묵 0 아님). 이는 후니/실가 단계에서 PRN_CNT UI 노출 + buildPriceRequest 1줄 배선으로 해소. **S6-O1로 후속 명시.**

### [핵심 정직성 판정 2] DOSU_COD 직렬화 생략 = **GO이나, round-trip이 이를 "검증하지 못함"을 명시 (NO-GO 아님)**

빌더 주장: "DOSU_COD는 비차단 — PRN_CLR_CNT가 도수 가격의미를 운반하므로 round-trip이 DOSU_COD 없이 성립." **독립 검증 결과: 주장의 결론(생략 가능)은 현 근거로 반증되지 않으나, fixture round-trip은 DOSU_COD를 실제로 검증하지 못한다.**

- **사실 1:** 캡처 ground truth ORD_INFO에는 `DOSU_COD:"SID_D"`(STD)/`"SID_S"`(WAL)가 **존재**하고, 그 호출이 PRICE 778,500/2,368,500을 냈다. 즉 실가는 **DOSU_COD가 있는 상태**에서 산출됨.
- **사실 2:** `serializeRedPriceRequest`는 DOSU_COD를 **출력하지 않는다**(grep 확인: red-adapter.ts에 DOSU_COD 키 없음).
- **사실 3(핵심):** `FixtureRedDataSource.fetchPrice`는 **productCode(`startsWith('HLCL')`)로 fixture를 라우팅**할 뿐 ORD_INFO 필드를 보지 않는다. 따라서 778,500/2,368,500은 **DOSU_COD 유무와 무관하게 반환**된다 → **fixture round-trip은 "DOSU_COD 생략해도 같은 가격"을 증명하지 않는다.** 그것은 직렬화 shape 정합 + 응답 평탄화만 증명한다.
- **divergence 판정:** 그렇다면 NO-GO인가? **아니다.** 보강 근거: PRN_CLR_CNT(STD=8/WAL=4 양면/단면)가 `colorCounts.default`로 직렬화되어 도수의 **가격 차원**을 운반하고(test L151 PASS), DOSU_COD(SID_D/SID_S)는 그 PRN_CLR_CNT와 1:1 종속(양면=8/단면=4)이다. 즉 **DOSU_COD는 PRN_CLR_CNT의 라벨**이지 독립 가격 입력이 아닐 개연성이 높다. 기존 책자/포스터/파우치 fixture가 DOSU_COD 없이 PRICE>0 재현하는 것도 방증. 따라서 **현 근거로 NO-GO를 발동할 divergence는 없다** — 다만 "생략 가능"은 **fixture가 아닌 실 BFF/후니 라이브 round-trip으로만 확정**된다.
- **조치:** 비차단. **S6-M1(DOSU_COD 실서버 검증)** 후속. 명세 §6-OPEN-1의 안전판("실가 단가 차이 시 어댑터 `DOSU_COD: req.dosuCode` 1줄, 위젯 무관")이 정확한 대응이며, 그 1줄도 어댑터 한정이므로 INV-3 불변. 현 S6 GO에는 영향 없음.

---

## 검증 항목별 결과 (must-pass 6 + 보조)

| # | 항목 | 기대 | 결과 | 판정 |
|---|------|------|------|------|
| **1** | 캡처 ↔ 구현 가격 round-trip | 직렬화 ORD_INFO[0] = 캡처 reqBody(rel 7440) 필드 1:1 + PRICE 778,500/2,368,500 평탄화 | 직렬화 `CUT=90x180 WRK=94x184 PRN_CNT=500 ORD_CNT=1 CLR=8 MTRL=RXRAU240 gbn=offset2023_price` = 캡처 dataJson.ORD_INFO[0] 정확 일치(test L144-153). `mapPriceResponse`→`finalPrice=778500 vat=77850`(L112-113), WAL `finalPrice=2368500`(L215) | **PASS** |
| **2** | 어댑터 ↔ 계약(신규 0) | offset 캘린더가 기존 PriceTable3D 계약에 계약 필드 **0 추가**로 매핑. CLD_STD/CUT_DFT/RIN_DFT = 기존 select(finish-button), dispatcher case 0 | 캘린더 전용 옵션 전부 `PCS_*` finish-button(test L75-89: CLD_STD 12종 visible, CUT_DFT hidden VIEW_YN=N, RIN_DFT visible). `git show 8863cbd`에 `component-type-map.ts`·dispatcher 미포함. 계약 변경 0 | **PASS** |
| **3** | INV-3 코어 불변 | `git diff src/widget/ src/contract/` = 0줄 | 워킹트리 diff **0 lines**(0줄). **커밋 8863cbd 전체 파일 8종 중 `src/widget/`·`src/contract/` = 0건**(전부 adapters/red 3 + fixtures 4 + test 1). 커밋 레벨 입증 | **PASS** |
| **4** | 가드(침묵 PRICE=0 차단) | ORD_CNT 또는 PRN_CNT 누락 → 명시 `{ok:false}`(침묵 0 재현 금지). 캡처 결함 재현 | 캡처 rel 2027(STD)·rel 1891(WAL): PRN_CNT+ORD_CNT 누락 → **PRICE=0(침묵)** ground truth 확인. `isPriceRequestQuotable`(red-adapter.ts:415-417)가 quantity=0 또는 printCount=0 → `UNQUOTABLE_BREAKDOWN{ok:false,finalPrice:0}`(test L176-186 PASS) | **PASS** |
| **5** | PRN_CNT 폐쇄 래더 enum | STD 다행 래더(100~1000) → select-box 10종, DFT_YN=Y(500) 선두 / WAL 단일행(500) → degenerate select-box 1종. counter-input 아님 | STD `GRP_PRN_CNT select-box values=500,100,200,300,400,600,700,800,900,1000`(test L99, 첫=500), `inputSpec=undefined`(L98), `GRP_QUANTITY` 미생성(L103). WAL `values=['500']`(L198). 어댑터 `prnCntLadder`(FIR/INC null 필터, red-adapter.ts:158-164) | **PASS** |
| **6** | 회귀(S1~S5 무회귀) | 기존 65 green 유지 + 신규 11, 총 76, 회귀 0 | `vitest run` **76 passed (11 files)**. S0~S5 fixture(PRBKYPR/디지털/스티커/BNBNFBL·BNPTPET/ACNTHAP/GSPUFBC·GSTGMIC) 동일 출력. tsc EXIT 0, vite build 성공 | **PASS** |
| 보조 A | INV-2 계약 중립 | offset2023_price/CLD_STD/HLCL/PRN_CNT 등 Red 고유명이 widget·contract에 **코드 식별자로 0건** | grep: offset2023_price 0건, CLD_STD/STA_CLD/PAK_POL 0건, HLCL 0건. PRN_CNT/ORD_CNT는 `contract/price.ts:25,27,28` **주석만**(코드 식별자 아님, S5와 동일 — printCount는 중립 도메인명) | **PASS** |
| 보조 B | NC-1 미오염 | offset2023_price가 dimension-matrix-input 미생성(real_price+0×0 sentinel 아님) | STD `GRP_SIZE option-button`, `inputSpec=undefined`, dimension-matrix 아님(test L62-64). real_price 아님 → 어댑터 NC-1 조건(red-adapter.ts:179) 미발동 | **PASS** |
| 보조 C | 시크릿 스캔(신규 fixture) | 라이브 토큰/시크릿 0건 | `koiAccessToken:"[JWT]"`(redacted 플레이스홀더)/`rpAccessToken:null`/`mb_cust_cod:"REDACTED"`. 실 JWT(`eyJ...`) 패턴 0건. price fixture에 mb_cust 부재 | **PASS (CLEAN)** |

---

## 캡처(ground truth) ↔ fixture ↔ 직렬화 교차 매트릭스 (핵심 증거)

| 필드 | 캡처 ORD_INFO (rel 7440 STD / rel 7395 WAL) | product fixture | 직렬화 출력 | 일치 |
|------|----------------------------------------------|------------------|--------------|------|
| PDT_CD | HLCLSTD / HLCLWAL | pdt_cod 동일 | `req.productCode` echo | ✔ |
| CUT_WDT×HGH (STD) | 90×180 | size 세로형 90×180 | 90×180(SizeRule 자동주입) | ✔ |
| WRK_WDT×HGH (STD) | 94×184 | size 세로형 WRK 94×184 | 94×184 | ✔ |
| PRN_CNT | 500 | 래더 DFT_YN=Y=500 | printCount=500 → PRN_CNT=500 | ✔ |
| ORD_CNT | 1 | — | quantity=1 → ORD_CNT=1 | ✔ |
| PRN_CLR_CNT | 8(STD,양면) / 4(WAL,단면) | dosu SID_D=8 / SID_S=4 | colorCounts.default echo | ✔ |
| MTRL_CD | RXRAU240 / RXSNO150 | mtrl[0] 동일 | materials.default echo | ✔ |
| **DOSU_COD** | **SID_D / SID_S (존재)** | dosu COD 존재 | **미출력(생략)** | **⚠ 직렬화 생략 — 판정 2 참조** |
| price_gbn | offset2023_price | option.price_gbn 동일 | 불투명 echo | ✔ |
| PCS_INFO | CUT_DFT/RIN_DFT/CLD_STD (STD) | PCS 동일 | PCS_ prefix 역매핑 정확(test L154-158) | ✔ |
| result_sum.PRICE | 778500 / 2368500 | price fixture 동일 | mapPriceResponse finalPrice 동일 | ✔ |

> **주의(증거 한계):** HLCLWAL round-trip 테스트(test L208)는 `sizeRules[0]`(=A3 297×420, DFT_YN=Y)를 선택하나, 2,368,500 캡처(rel 7395)는 **A2 420×594**다. `quote()`가 `startsWith('HLCL')`로 fixture를 **productCode 라우팅**하므로 dimension 무관하게 2,368,500을 반환 → **가격은 fixture-routed이지 dimension-matched가 아니다.** STD도 동일(productCode 라우팅). 이는 S3/S5와 동일한 fixture 검증 패턴(BFF가 가격 권위, INV-1)이며 결함 아님 — 단 "직렬화 shape 정합 + 응답 평탄화"를 증명하지 **dimension별 단가 정합은 실 BFF/후니 라이브로만 검증** 가능. S6-M1과 함께 후속.

---

## 결함/관찰 목록 (심각도)

### S6-O1 [관찰] PRN_CNT enum→printCount store 배선 미완 — *비차단, 현 stage 정당 (S5 echo 전례 동형)*
- 현황: `GRP_PRN_CNT` select-box는 어댑터 출력에 존재하나, 사용자 선택값이 `buildPriceRequest`로 흘러 printCount echo되는 store 배선 미구현. round-trip은 printCount 명시 구성으로 직렬화만 증명.
- 영향: 실 UI에서 PRN_CNT 미선택 시 `printCount=undefined → 어댑터 ?? 1 → PRN_CNT=1` 단가(가드는 통과, 침묵 0 아님). **결함 아님** — 배선 1줄은 위젯 코어라 INV-3 코어 0줄 우선으로 보류(명세 §4.1 #3 부합).
- 위치: `src/widget/stores/price.ts`(buildPriceRequest, printCount 미설정) / `src/adapters/red/red-adapter.ts:304-321`(GRP_PRN_CNT enum 생성) / test/s6-calendar.test.ts:138-140(명시 구성 주석).
- 조치: 비차단. 후니 PRN_CNT UI 노출 시 buildPriceRequest +1줄(quantity echo와 동형) 배선 → 자동 직렬화. 계약·어댑터 불변.

### S6-M1 [Minor] DOSU_COD 생략의 실가 정합 미검증 — *검증 깊이 한계 (결함 아님 / 미검증)*
- 현황: 직렬화가 DOSU_COD 생략. fixture round-trip은 productCode 라우팅이라 DOSU_COD 유무를 **실제로 검증하지 못함**(같은 가격이 무조건 반환). 캡처 실가는 DOSU_COD 존재 상태에서 산출됨.
- 영향: 위젯 무관(INV-1 — 가격은 BFF 권위). PRN_CLR_CNT(8/4)가 도수 가격의미 운반 + DOSU_COD↔PRN_CLR_CNT 1:1 종속(양면=8/단면=4)으로 "생략 가능" 개연성 높음. 현 근거로 NO-GO divergence 없음.
- 재현/확정: 실 BFF 또는 후니 라이브에서 DOSU_COD 유/무 동일 ORD_INFO 가격 대조. 차이 시 어댑터 `DOSU_COD: req.dosuCode` 1줄(명세 §6-OPEN-1 안전판, 위젯 무관).
- 조치: 비차단. 후속 S6-M 임계경로.

### S6-M2 [Minor] WAL/STD round-trip = fixture-routed (dimension별 단가 미검증) — *검증 깊이 한계*
- 현황: `quote()`가 productCode로 fixture 선택 → dimension/래더값 무관하게 캡처 PRICE 반환. WAL 테스트는 A3 선택이나 캡처는 A2.
- 영향: shape 정합·응답 평탄화는 증명, **규격×PRN_CNT별 단가 정합은 미검증**(S3/S5 동일 패턴, INV-1 BFF 권위라 위젯 무관).
- 조치: 비차단. 실 BFF/후니 라이브 단가 대조(S6-M1과 함께).

### (참고) 캘린더 전용 STA_CLD/PAK_POL 주문메타 연월 노출 — **본 stage 스코프 밖** (명세 §6-OPEN-2)
- 효도달력 시작연월(STA_CLD) select는 가격 무관(주문메타). 본 S6는 offset PriceTable3D 가격검증이 임계경로 → 비스코프. 향후 어댑터가 메타 그룹 생성 시 기존 select-box 재사용(신규 타입 0). 비차단.

### (참고) GSCLMGN(자석=goods tiered)·TPCLECO(Red 미설정) — **S6 무관** (명세 §6-OPEN-5/6)
- GSCLMGN은 굿즈 tiered(S5 계열), TPCLECO는 Red 상품 마스터 공백(우리 결함 아님). 둘 다 offset PriceTable3D 임계경로 아님. 명세대로 미검증 명시.

---

## 라이브 vs 코드-온리 구분 (정직성)

| 검증 | 방식 |
|------|------|
| 가격 round-trip(778,500/2,368,500 직렬화·평탄화) | **캡처 ground truth ↔ fixture ↔ 직렬화 shape diff** + **단위**(s6-calendar.test.ts 11 케이스) |
| ORD_INFO 필드 정합(CUT/WRK/PRN_CNT/ORD_CNT/CLR/MTRL) | **캡처 dataJson.ORD_INFO[0] 직접 추출** ↔ serialize 출력 1:1 대조 |
| 침묵 PRICE=0 결함 재현 | **캡처 rel 2027(STD)·rel 1891(WAL) ground truth**(PRN_CNT 누락→PRICE=0) ↔ 가드 단위(2 케이스) |
| PRN_CNT 폐쇄 래더 enum | **어댑터 단위**(STD 10종/WAL 1종 select-box) + 어댑터 소스(prnCntLadder FIR/INC null 필터) |
| 신규 componentType 0(PCS finish-button 흡수) | **어댑터 단위**(CLD_STD/CUT_DFT/RIN_DFT/HOL_DFT/RIN_CUT finish-button) + **git show**(dispatcher/component-type-map 미변경) |
| INV-3 코어 0줄 | **git diff -- src/widget src/contract**(0줄) + **git show 8863cbd**(커밋 8파일 중 widget/contract 0건) |
| INV-2 중립성 | **정량 grep**(widget/contract 코드 식별자 0건, 주석만) |
| 시크릿 스캔 | **grep**(실 JWT 0건, 플레이스홀더만) |
| S1~S5 무회귀 | **게이트 재현**(tsc EXIT 0 / vitest 76 passed / vite build 성공) |
| **DOSU_COD 생략 시 실가 동일성** | **미검증**(fixture productCode 라우팅이라 검증 불가 — S6-M1, 실 BFF 필요) |
| **dimension/PRN_CNT별 단가 정합** | **미검증**(fixture-routed — S6-M2, 실 BFF 필요) |

---

## 다음 stage 영향

- **S6 GO. 후속 stage 진입 무차단.** offset 캘린더(HLCLSTD·HLCLWAL)가 **책자 PriceTable3D 변형**임을 캡처 ground truth ↔ 어댑터 교차비교로 실증. 위젯 코어 0줄(커밋 레벨 입증) + 계약 0변경 + 신규 componentType 0으로 "정규화 계약 의존 + 어댑터+fixture 흡수" 가설을 S4(NC-2)·S5(NC-3)에 이어 **세 번째 재실증**. 확정 신규 componentType = NC-1(dimension-matrix-input) 단 1종 유지.
- **S6 신규 인프라:** PRN_CNT 폐쇄 래더→select-box enum 분기(어댑터 한정, red-adapter.ts:304-321) — 후니/타 SKU의 폐쇄 수량 래더에 재사용 가능. pdt_disable_pcs_info null 평탄화도 어댑터 견고성 보강.
- 잔존(전부 후속 독립, 병행 보강 가능): S6-O1(PRN_CNT store 배선, 후니 UI 노출 시), S6-M1(DOSU_COD 실서버 검증), S6-M2(dimension/래더별 단가 실 BFF 대조), S5 잔존(TieredDiscount 말랑/문구), S3 잔존(real_price 실가).
- **명세 정정 불요:** 명세 §4.1 #3가 이미 "printCount echo 1줄은 코어 0 우선 시도 후 필요 시에만"으로 조건부 서술 → 구현(배선 보류)과 정합. DOSU_COD도 §6-OPEN-1에 안전판 명시됨.

---

## 환경 메모
- 검증 시점 게이트: tsc EXIT 0 / vitest 76 passed(11 files) / vite build 성공(dist/widget.js 746.72kB, S5 715kB→746kB +31kB = HLCLSTD/WAL fixture 번들 포함 / gzip 134.74kB).
- 캡처는 로그인 라이브(mb_cust_cod 10000000) ground truth — STD/WAL 각 3 priceCall(침묵 0 + PRICE>0 ×2)로 침묵결함·실가 동시 확보. S5 GSPUFBC에 이은 두 번째 로그인 실가 stage.
- 검증은 vitest/grep/git diff·git show/캡처-fixture shape diff로 수행(라이브 Red 재접속 불요, 테스트베드 localhost:3001 read-only 미사용). 재현은 본 보고서 명령 + `s6-calendar.test.ts` 11 케이스로 가능.
- 코드 수정·커밋 0건(read-only 검증 + 본 QA 노트만 작성). GO 후 오케스트레이터 커밋.
</content>
</invoke>
