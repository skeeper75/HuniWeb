# vprice-board.md — V-PRICE 신규 14필드(6월 드리프트) 동등성 게이트 (Phase 3 · 생성측)

> 검사자: hrev-price-equivalence. 오라클 = 라이브 RedPrinting 신규필드 골든
>   (`02_golden/captures/new-fields-260623/NF-*.json`, 8 시나리오 · MR-1~MR-8).
> 검증 대상 = §6 재구성 가격 어댑터(`_workspace/huni-widget/04_build/src/adapters/red/red-adapter.ts`
>   + `red-types.ts` + 계약 `src/contract/price.ts`).
> 방법 = 차등(differential). 골든 reqBody(라이브 실측)로 NormalizedPriceRequest 역구성 →
>   `serializeRedPriceRequest` emit reqBody 를 골든 reqBody 와 **신규필드 field-for-field** 대조
>   (fixture 우회 금지). `mapPriceResponse` 출력을 골든 result_sum 과 대조.
> 하네스: `03_price/scripts/vprice-newfields.test.ts` (+ `vprice-newfields.config.mts`).
> 실행: `cd _workspace/huni-widget/04_build && ./node_modules/.bin/vitest run --config ../../huni-re-verify/03_price/scripts/vprice-newfields.config.mts`
> 결과: **70 PASS / 34 FAIL** (VP-1/VP-6 33 FAIL = 신규필드 미전송 + VP-5 1 FAIL = MR-5 정의부적절).
> 4월 베이스라인 보드는 `_prev/260623-april-baseline/03_price/`. R2 수치앵커 미채택(보강골든 단일권위).
> [HARD] 생성측 자가승인 금지 — verify-gate(Phase 5)·codex(Phase 4) 재판정.

---

## 0. 종합 판정 (★핵심 가설 확증: 재구성은 4월 기반이라 6월 신규필드를 못 본다)

| 게이트 | 판정 | 핵심 근거 |
|--------|------|-----------|
| **VP-1** 신규필드 골든 strict 재생 | **FAIL** | 신규필드 골든 33셀 전부 reqBody 발산. 6월 신규필드(ADD_CLR_YN/REAM_CNT) 28셀 + acceptance 전용(PACK/MAX/모델A) 일부 + DOSU_COD(4월기존) 5셀. 재구성이 신규 ORD_INFO 필드를 **단 하나도 emit 못 함**(계약/타입 슬롯 부재) |
| **VP-2** 라이브 차등(result_sum.PRICE/VAT) | **PASS(주의)** | `mapPriceResponse` 응답 평면화는 33셀 전부 finalPrice==golden.PRICE·vat==golden.PRICE_VAT 정합. ★단 이는 골든 응답을 fixture 주입한 **응답측** 차등 — 실 라이브에 신규필드 누락 요청을 POST 했을 때의 가격은 미검증(라이브 읽기전용·능동 변형금지). VP-1 발산이 라이브 가격에 영향 주는지는 codex deob 보강 권장 |
| **VP-3** PRICE≠0 sanity | **PASS** | 신규필드 정상경로 33셀 전부 라이브 result_sum.PRICE>0. 0 발생 0(MR globalSanity priceZeroCount=0 일치) |
| **VP-4** result_sum 권위 | **PASS** | `mapPriceResponse` 가 result_sum.PRICE 만 읽음(red-adapter.ts:650). per-line(예 NF-ORDCNT perLine[0].PRICE=0 번들) 무시. 워터폴 평면화 유지 |
| **VP-5** 메타모픽(수량↑⇒비감소·+후가공⇒증가) | **PASS(MR-5 제외)** | MR-1~4·6~8 라이브 시퀀스 단조 성립. ★MR-5(HOL/ROU/MIS/OSI) 1 FAIL = 16800→16200: 서로 **다른 후가공 종류** 나열이라 "단조" 부적용 — 메타모픽 **정의 오류**(각각 baseline 초과는 성립). 재구성 결함 아님(아래 §4) |
| **VP-6** 필드사전 정합(발명 0 + 미지원 명시) | **FAIL(미지원)** | 재구성 emit 필드는 전부 사전 ∈(발명 0). 그러나 사전·실캡처에 존재하는 신규필드를 재구성이 **모름** → VP-6 "역으로 미지원 명시" 조항 발동: ADD_CLR_YN/REAM_CNT/MAX_PRN_CNT/PACK_PRN_CNT/PDT_SIZE_INFO/PRINT_TYPE(가격경로)/TMPL_IDX/모델A래더 = **미지원** |

**게이트 규칙(단일 FAIL=NO-GO)** → **VP-PRICE(신규필드) = NO-GO** (VP-1·VP-6 FAIL).

---

## 1. 시나리오 × 게이트 매트릭스 (신규필드 골든 8)

| 시나리오 | productCode | price_gbn | VP-1 | VP-2 | VP-3 | VP-5(MR) |
|----------|-------------|-----------|:----:|:----:|:----:|:----:|
| NF-ORDCNT | NCCDDFT | offset2023_price | **FAIL**(DOSU/ADD_CLR/REAM ×3셀) | PASS | PASS | MR-1 PASS |
| NF-PRNCNT-modelB | NCCDDFT | offset2023_price | **FAIL**(×3셀) | PASS | PASS | MR-2 PASS |
| NF-REAMCNT | NCCDDFT | offset2023_price | **FAIL**(×3셀) | PASS | PASS | MR-7 N/A(acceptance) |
| NF-ADDCLR | NCCDDFT | offset2023_price | **FAIL**(×4셀) | PASS | PASS | MR-6 N/A(negative) |
| NF-FLD-DFT | NCCDDFT | offset2023_price | **FAIL**(×5셀) | PASS | PASS | MR-4 PASS |
| NF-POSTPCS | NCCDDFT | offset2023_price | **FAIL**(×5셀) | PASS | PASS | MR-5 **FAIL**(정의오류) |
| NF-ACCEPTANCE | NCCDDFT | offset2023_price | **FAIL**(×5셀·PACK/MAX/모델A 포함) | PASS | PASS | MR-8 N/A(acceptance) |
| NF-TIERED-modelB | GSTGMIC | tiered_price | **FAIL**(DOSU ×5셀) | PASS | PASS | MR-3 PASS |

VP-1 FAIL 셀 분해(테스트 실측): 6월 신규필드 누락 28셀 + DOSU_COD(4월기존)만 누락 5셀 = 33셀.
신규필드별 누락 셀 수: ADD_CLR_YN 28 · REAM_CNT 28 · PACK_PRN_CNT 2 · MAX_PRN_CNT 1 · MIN_ORD_PRN_CNT 1 · ADD_ORD_PRN_CNT 1.

---

## 2. 결함 보드 (신규필드 차원 — 심각도별)

> 모든 행: emit(재구성) vs live(골든). 오라클=라이브. 근거=라이브 골든 verbatim + 어댑터 파일:라인.

| ID | 심각도 | 발산 | emit(재구성) | live(골든) | 영향 셀 | §6 교정 위치 | 돈 영향 |
|----|--------|------|--------------|------------|---------|--------------|---------|
| **N1** | **HIGH** | `ADD_CLR_YN` 신규 ORD_INFO 필드 **미전송** | (부재·슬롯없음) | `"N"`/`"Y"` | 28 | 계약 `price.ts` NormalizedPriceRequest(슬롯부재) → `red-types.ts:166` RedPriceReqOrdInfo(슬롯부재) → `red-adapter.ts:580` serialize(set 없음) | 미확정(현 자재/도수선 라이브 inert=가격불변 — MR-6 negative. 단 ADD_CLR 가격발현 상품 노출 시 누락=오가격 잠복) |
| **N2** | **MED** | `REAM_CNT` 신규 ORD_INFO 필드 **미전송** | (부재·슬롯없음) | `0`/`1`/`2` | 28 | 동상(계약·types·serialize 3층 슬롯부재) | 미확정(현 PRN_CNT 가 수량권위라 REAM_CNT 단독 무영향 — MR-7 acceptance. 연단위 입력모드 상품 시 영향가능) |
| **N3** | **MED** | 수량모델 A(래더: `MIN_ORD_PRN_CNT`+`ADD_ORD_PRN_CNT`×h, `UNIT_PRN_CNT`) **미구현** | (전무) | 모델A 필드 | 1(NF-ACCEPTANCE 모델A 호출) | `red-adapter.ts:279-305`(buildQuantityRule/prnCntLadder 는 모델B만) — 모델A 산술계열 생성 코드 부재 | 미확정(PDT_VER_SIZE형 굿즈 노출상품 미가용 — golden 도 acceptance only) |
| **N4** | **LOW** | `PACK_PRN_CNT`(개별포장)·`MAX_PRN_CNT`(상한) **미전송** | (부재) | `100`/`10000` | 2/1 | 계약·types·serialize 슬롯부재 | 미확정(NCCDDFT 미바인딩·라이브 PRICE 보존. full sweep 미캡처) |
| **N5** | **LOW(잔존·4월기존)** | `DOSU_COD` **의도 omit** | (부재) | `"SID_S"` | 5(GSTGMIC 5셀, NCCDDFT 는 N1/N2 와 동반) | `red-adapter.ts:569`(OPEN-1 의도 omit) | **없음(가격동일)** — PRN_CLR_CNT 가 도수 가격의미 운반(4월 VP-2 입증). 신규필드 아님(4월 골든 전부 보유)·기존 판정 항목 |

**합계(6월 신규필드 차원): HIGH 1(N1) / MED 2(N2·N3) / LOW 2(N4·N5)**.
**전부 reqBody 직렬화 누락(미전송/미구현)** — 응답 평면화(mapPriceResponse) 결함은 0(VP-2 응답측 PASS).

### 2.1 N1/N2 근거 (무날조 — 3층 슬롯 부재 실증)
- 라이브 신규 골든 NCCDDFT offset2023 전 호출 ORD_INFO[0] = `{PDT_CD,MTRL_CD,CUT_*,WRK_*,PRN_CNT,ORD_CNT,DOSU_COD,PRN_CLR_CNT,ADD_CLR_YN,REAM_CNT}` (예: `NF-ORDCNT_NCCDDFT.json:41-42` `"ADD_CLR_YN":"N","REAM_CNT":0`).
- 계약 `04_build/src/contract/price.ts:24-41` NormalizedPriceRequest: ADD_CLR_YN/REAM_CNT 운반 슬롯 **0**(quantity/printCount/colorCounts/materials/selectedFinishes 만).
- `red-types.ts:166-184` RedPriceReqOrdInfo: ADD_CLR_YN/REAM_CNT 필드 정의 **0**(DOSU_COD?·책자분리필드만).
- `red-adapter.ts:580-590` serialize ORD_INFO 조립: ADD_CLR_YN/REAM_CNT set 코드 **0**.
- ⇒ 재구성은 계약 진입점부터 신규필드를 받을 수 없음 = "4월 기반이라 6월 신규필드 미인지" 가설 **확증**.

### 2.2 N3 근거 (수량모델 A 미구현)
- price-engine-additions.md §2: 모델 A(래더) = `PRN_CNT = MIN_ORD_PRN_CNT + ADD_ORD_PRN_CNT × h` (h=0..9), deob L15432-15445. PDT_VER_SIZE형 굿즈.
- 재구성 `buildQuantityRule`(red-adapter.ts:279)·`prnCntLadder`(:299) = 모델 B(행기반 FIR/INC/STEP + 폐쇄 enum 래더)만 구현. 모델 A 산술계열 생성 = grep 흔적 0(`MIN_ORD_PRN_CNT`/`ADD_ORD_PRN_CNT`/`UNIT_PRN_CNT` 전무).
- 단 모델 A 가격함수는 라이브 골든도 acceptance only(NF-ACCEPTANCE — 노출상품 미가용). 미검증 셀(§4).

---

## 3. 수량모델 A/B 재구성 구현 여부

| 모델 | 정의(price-engine-additions §2) | 재구성 구현 | 근거 |
|------|--------------------------------|-------------|------|
| **모델 B (행기반)** | pdt_prn_cnt_info 행 + base FIR_CNT/INC_CNT/INC_STEP/REAM_YN. offset2023 명함/카드/책자 | **부분 구현** | `buildQuantityRule`(FIR/INC/STEP→QuantityRule)·`prnCntLadder`(폐쇄 래더→select enum, red-adapter.ts:299-305·451-468) = **UI 옵션그룹 생성** 구현. ★단 `REAM_YN` 미사용·`REAM_CNT` serialize 미전송(N2). 가격요청 차원 불완전 |
| **모델 A (래더/산술)** | MIN_ORD_PRN_CNT + ADD_ORD_PRN_CNT × h, UNIT_PRN_CNT, DFT_YN 첫행. PDT_VER_SIZE형 굿즈 | **미구현** | 산술계열 생성 코드·필드 슬롯 전무(N3) |

---

## 4. 미검증 셀 (무날조 — 사유 명시)

| 항목 | 사유 |
|------|------|
| **N1~N4 의 라이브 가격 영향(실 POST)** | 신규필드 누락/오타입 reqBody 를 라이브에 POST 하면 Red 거부/오가격/silent무시 중 무엇인지 알 수 있으나 = 능동 변형 = 읽기전용 불변식 위반 → 미수행. byte 누락은 확정. 현 골든은 정상 shape 만 캡처(완전 reqBody) → 누락 reqBody 의 라이브 반응 미관측. codex deob(빌더 L13955-13999·L19733·L22611) 파서 동작으로 보강 권장 |
| **VP-2 신규필드 가격 동일성(실 라이브 차등)** | mapPriceResponse 응답측 차등은 골든 result_sum fixture 주입(PASS). 실 라이브에 재구성 reqBody(신규필드 누락)를 넣어 동일 PRICE 나오는지는 라이브 read-only·능동변형 금지로 미수행. ADD_CLR_YN/REAM_CNT 는 현 자재/도수선 inert(MR-6/7) 라 누락이 현 가격엔 무영향 추정이나 단정 불가 |
| **모델 A 가격함수·PACK_PRN_CNT/MAX_PRN_CNT 가격함수** | NCCDDFT 미바인딩·PDT_VER_SIZE 노출상품 미가용(NF-ACCEPTANCE PARTIAL — acceptance only). price-engine-additions §5 미확정과 일치. 재구성 미구현(N3/N4) 자체는 확정, 가격영향은 미캡처 |
| **PDT_SIZE_INFO/PRINT_TYPE(가격경로)/TMPL_IDX** | 신규필드 골든 8 시나리오에 미포함(BT*/GSSTPRT 사이즈정보·의류·트래블택 전용). 재구성: PRINT_TYPE 은 의류 OptionGroup 평면화는 있으나(apparel.ts) 가격 ORD_INFO 전송은 미구현. PDT_SIZE_INFO 는 red-types.ts:59 슬롯만. 본 파일럿 골든 외 — 미검증 |
| **MR-5 메타모픽 정의** | MR-5 sequence(HOL16800/ROU16200/MIS18200/OSI18200)는 서로 **다른 후가공 종류** — "단조 비감소" 부적용(16800→16200 역전 정상). 올바른 관계 = "각 후가공 > baseline 12700"(전부 성립). metamorphic-relations.json MR-5 holds:true 의 shape 기술은 맞으나 단조검사 대상 아님 → Phase 5 게이트가 메타모픽 검사식 정정 권장(재구성 결함 아님) |

---

## 5. Phase 4 codex(high) 독립검증 핵심 쟁점

1. **N1 ADD_CLR_YN 누락이 돈크리티컬로 잠복하는가** — Red offset2023_price 핸들러가 ADD_CLR_YN 부재 시 default "N" 으로 처리(현 가격불변)하는가, 아니면 다른 자재/도수선에서 +가격을 누락시키는가? deob 빌더 L13982(dosuInfo.ADD_CLR_YN) 소비 코드 확인. 발현 상품선이 있으면 N1=HIGH 확정.
2. **N2 REAM_CNT 연단위 입력모드** — REAM_CNT 가 PRN_CNT 대체모드(연→매수)로 작동하는 상품이 있는가? 있으면 재구성 누락 = 그 상품군 가격 전체 누락(MED→HIGH 승격 여지). deob L22611(pdt_prn_cnt_info REAM_CNT/PRN_CNT) 확인.
3. **N3 모델 A 가격함수** — codex 가 PDT_VER_SIZE형 노출상품을 라이브 server.js 로 독립 탐색(읽기전용)해 모델 A 래더가 실제 가격 차등을 내는지. 그렇다면 재구성 미구현 = 그 상품군 견적 불가.
4. **VP-2 실 라이브 차등** — codex 가 동일 옵션(신규필드 포함/제외)을 라이브 server.js 로 독립 POST(읽기전용 범위 내)해 PRICE 동일성 재실측. Claude 골든과 무관하게.
5. **VM-3 인용 실재성** — price-engine-additions.md 의 deob 라인(L13955-13999·L19733·L22611·L15432-15445)이 실재하는가(crossverify-round2 G-1 선례: deob 부존재 라인 날조 적발). R2 수치 6,350,000 vs 라이브 12,700 스케일 아티팩트도 codex 가 deob 으로 진위 판정.
