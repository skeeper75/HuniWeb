# parity-matrix-D1-price.md — 가격 도메인 정합 검증 (Red reqBody-build/price-flow ↔ 우리 구현)

> **STAGE S1 / D1 (price domain).** Red 의 가격요청 조립 + 가격흐름 로직(권위)을 우리 구현이 **책임/로직/분기 재현 동치**로 재현하는지 검증한다. line-copy 아님 — React vs Vue 차이 무관, **행위·분기 커버리지**만 본다.
> **검증 전용 — 코드 수정 없음.** 손실은 LOSS 레지스터에 severity + S3 재현 스펙(구현 없이)으로 기록.
> **권위**: `07_parity/red-code-map-05-api.md`(트랜스포트) + `red-code-map-06-widget-sdk.md`(reqBody 빌더 위치) + `mod_05_app_api.js`/`mod_06_app_widget_sdk.js`/`mod_07_app_components.js`(빌더 실코드).
> **우리 측**: `red-adapter.ts`(serializeRedPriceRequest+mapPriceResponse), `red-types.ts`(RedPriceReqBody), `widget/stores/price.ts`(buildPriceRequest), `contract/price.ts`(NormalizedPriceRequest/SelectedFinish).
> **선행**: P1 `parity-matrix-P1-normalization.md` (L-1 ATTB 컨텍스트).
> 근거표기: `RA:N`=red-adapter.ts, `PR:N`=price.ts, `CT:N`=contract/price.ts, `RT:N`=red-types.ts, `mod_05/06/07:N`=Red 소스.

---

## 0. 가격 도메인 판정 분포 (요약)

| 책임 축 | 판정 | 한 줄 |
|---------|------|-------|
| 1. dataJson 래퍼 | **완전재현** | `{dataJson:{...}}` 1중 래핑 + mb_cust_cod fallback `10000000` — 코드(mod_06:2522)와 정합 |
| 2. ORD_INFO 필드 | **부분재현** | 단일면 OK. 책자 CVR_/INN_/PAGE_CNT OK. **DOSU_COD 의도 omit**(OPEN-1), 의류 PRINT_TYPE 누락 |
| 3. PCS_INFO 조립 | **부분재현(BLOCKER 동반)** | PCS_COD/PCS_DTL_COD 복원 OK. **ATTB:'' 하드코딩(RA:427) = L-1 전손실** + ATTB_2/ATTB_3 필드 부재 |
| 4. price_gbn echo | **완전재현** | 불투명 echo, 클라 분기 0 — 코드(분기 0)와 정합 |
| 5. itemGroup 분기 | **상이(취약)** | Red 는 itemGroup(item_gbn)으로 스키마 분기. 우리는 **`materials.inner`/`pageCount` 존재여부 휴리스틱**(RA:397) — itemGroup 미참조. 제품코드/접두 아님이나 데이터-형상 추론 = 취약 |
| 6. 가격호출 가드(PRICE=0) | **완전재현+(상이 1)** | ORD_CNT/PRN_CNT≥1 가드(RA:438) = 침묵0 방지. 단 Red 의 **retCode!==200 \|\| !PRICE → 주문불가**(mod_06:1167)는 canOrder 도메인 — 본 어댑터엔 `ok:res.retCode===200`만(RA:474) |
| 7. 응답 워터폴 | **완전재현** | PRICE_MALL→PRICE→ORG_PRICE 3단(RA:456~465) = mod_06:1284 와 동일 순서/조건 |
| 8. debounce 트리거 | **(타이밍은 state 도메인)** | 본 도메인은 reqBody 형상만. 이중 debounce(150+200ms)는 state 도메인 소관 — 여기선 노트만 |

**가장 정확한 한 줄**: 우리 가격 직렬화는 **래퍼·필드·워터폴·price_gbn echo·침묵0 가드를 구조적으로 재현**하나, ① **ATTB 를 전부 버려(L-1, BLOCKER)** 속성 단가차 후가공을 오산하고, ② **itemGroup 분기를 데이터-형상 휴리스틱으로 대체**해 미래 상품에서 오분기 위험, ③ DOSU_COD/의류 PRINT_TYPE 등 Red ORD_INFO 의 일부 분기 필드를 운반하지 않는다.

---

## 1. 가격 도메인 대응 매트릭스

> verdict = 완전재현/부분재현/누락/상이. 증거는 양측 file:line.

| # | Red 책임 (file:line) | 우리 구현 위치 | 판정 | 증거 |
|---|----------------------|----------------|------|------|
| D1-1 | dataJson 1중 래핑 (mod_05:1138 `body:{dataJson: payload.body}`) | `serializeRedPriceRequest` `return {dataJson:{...}}` (RA:420~432) | **완전재현** | 양측 최상위 `{dataJson:{ORD_INFO,PCS_INFO,price_gbn,mb_cust_cod}}`. RT:185 RedPriceReqBody 타입도 정합 |
| D1-2 | mb_cust_cod (mod_06:2522 `i?.mb_cust_cod \|\| "10000000"`) | `req.customerTier ?? '10000000'` (RA:430) | **완전재현** | 게스트 fallback `10000000` 동일. 단 Red 출처는 provide("member"), 우리는 `s.member.tier`(PR:80) → 경로 정합 |
| D1-3 | ORD_INFO 단일원소 배열 (mod_06:1256 `[{...}]`) | `ORD_INFO:[ord]` (RA:422) | **완전재현** | 단일 원소 배열 구조 동일 |
| D1-4 | ORD_INFO 기본 필드 PDT_CD/CUT_/WRK_/PRN_CLR_CNT/MTRL_CD (red-code-map-06 §1 `m()`) | RA:401~411 | **완전재현** | PDT_CD/CUT_WDT/CUT_HGH/WRK_WDT/WRK_HGH/PRN_CLR_CNT/MTRL_CD 매핑 정합 |
| D1-5 | ORD_CNT(주문건수)+PRN_CNT(인쇄수량) 둘 다 (red-code-map-05 §3.5 ATTB=prnCnt; S5 실측 둘 다 필요) | `ORD_CNT:req.quantity`, `PRN_CNT:req.printCount??1` (RA:407~408) | **완전재현** | quantity↔ORD_CNT / printCount↔PRN_CNT 분리(CT:25~29). 미전달 시 PRN_CNT=1 하위호환 |
| D1-6 | 책자 ORD_INFO 스키마 분기 — CVR_/INN_ 분리 + PAGE_CNT (red-code-map-06 §6 `item_gbn==="book2025_item"`) | `if(isBook)` → PAGE_CNT/CVR_CLR_CNT/INN_CLR_CNT/CVR_MTRL_CD/INN_MTRL_CD (RA:412~419) | **부분재현(상이 소지)** | 필드 자체는 정합. 단 **분기 트리거가 다름** → D1-9 참조 |
| D1-7 | PCS_INFO `{PCS_COD,PCS_DTL_COD,ATTB[,ATTB_2,ATTB_3]}` (mod_06:1260; mod_07 각 finish emit) | `PCS_INFO:req.selectedFinishes.map(...)` (RA:423~428) | **부분재현 + BLOCKER** | PCS_COD(groupId slice 4)/PCS_DTL_COD(valueId) 복원 OK(RA:425~426). **ATTB:'' 하드코딩(RA:427)** + ATTB_2/ATTB_3 필드 없음(RT:178) → **L-1** |
| D1-8 | price_gbn 불투명 (mod_05 분기 0; option.price_gbn echo) | `price_gbn:req.priceSchemeKey` (RA:429), `priceSchemeKey:product.priceSchemeKey`(PR:79), `opt.price_gbn`(RA:74) | **완전재현** | 클라 분기 0개 = 코드와 정합. echo만 |
| D1-9 | itemGroup(item_gbn) 분기 (mod_05:1859~1885 book/clothes; red-code-map-06 §6) | `isBook = materials.inner\|\|colorCounts.inner\|\|pageCount 존재` (RA:397~400) | **상이(취약)** | Red 는 `item_gbn` **명시 분류값**으로 분기. 우리는 **inner 데이터 형상 추론** — itemGroup 미참조. 제품접두 기반 아님(P1 우려 해소)이나, inner 없는 책자/inner 있는 비책자에서 오분기 위험. **clothes2025(PRINT_TYPE) 분기 자체가 없음**(누락) |
| D1-10 | 가격호출 빈값 skip (mod_05:1937 `cn(O)` 빈 페이로드 skip) + 침묵 PRICE=0 (red-code-map-05 §5 G6) | `isPriceRequestQuotable`=ORD_CNT≥1&&PRN_CNT≥1 (RA:437~438), 위반 시 UNQUOTABLE(RA:504) | **완전재현(강화)** | Red 빈값 skip(조용)보다 **강화** — 명시적 `ok:false` 반환(침묵0 재현 금지, 의도된 개선). 회귀 가드 |
| D1-11 | 응답 3단 워터폴 (mod_06:1284) | `mapPriceResponse` PRICE_MALL≠PRICE→PRICE_MALL / ORG_PRICE≠PRICE→PRICE / else ORG_PRICE (RA:456~465) | **완전재현** | 순서·조건 동일. VAT 도 각 분기 짝 VAT 사용 |
| D1-12 | result_sum→finalPrice 평면화 + result[] 분해 (red-code-map-05 §3.3) | finalPrice/vat + `lines:res.result.map`(RA:467~471) | **완전재현(부분 label)** | finalPrice/vat/shipping 정합. lines label 은 PCS_CD 코드만(RA:469, result_log 한글 미추출) — 투명성 표시 손실(MINOR) |
| D1-13 | retCode 게이트 (mod_05:1141 retCode!==200 throw; mod_06:1167 !PRICE 주문불가) | `ok:res.retCode===200`(RA:474) | **부분재현** | retCode 200 게이트 OK. **`!result_sum.PRICE`(가격 0/누락) → ok:false 판정이 어댑터에 없음** — Red 는 PRICE 누락도 주문불가(G6). 우리 어댑터는 retCode만 보고 PRICE=0 이어도 `ok:true` 가능 → canOrder 도메인이 막아야(D1-15) |
| D1-14 | KOI 탭 실시간 재계산 (mod_06:1224 getKOIEditorTabData) | (없음) | **누락(의류/에디터)** | 에디터 내 자재변경 시 부분갱신 가격 재호출. 우리 가격 도메인엔 부분갱신 재계산 경로 없음. 의류·KOI 전용 → state/editor 도메인 핸드오프 |
| D1-15 | canOrder 가격검증 (mod_06:1167) | (price 도메인 밖 — state 소관) | **(핸드오프)** | 본 매트릭스 범위 밖이나 D1-13 누락(어댑터 PRICE=0 미차단)을 canOrder 가 보완하는지 state 도메인이 확인해야 함 |

---

## 2. ATTB 심층 (L-1 BLOCKER 확정·심화)

P1 이 "ATTB 전손실 BLOCKER" 라고 했고, D1 에서 **Red 의 ATTB 조립 규칙을 컴포넌트별로 정밀 추출**해 확정한다. ATTB 는 후가공별로 **의미·출처가 다른 다형 필드**다.

### 2.1 Red 의 ATTB 조립 규칙 (컴포넌트별, mod_07 실코드)

| 후가공 (mod_07:line) | ATTB 출처 | emit 형태 | 비고 |
|----------------------|-----------|-----------|------|
| **BID_SIL** (mod_07:1910~1921) | `attbOptions[].value` (사용자 선택 속성칩) | `{PCS_CD, PCS_DTL_CD:options[0].value, PCS_DTL_NM:"${name}(${attbName})", ATTB: 선택값}` | PCS_DTL_CD 는 **고정**(options[0]), 변동축은 **ATTB 에만** 실림. ATTB 손실 = 속성 선택 전손실 |
| **RIN_DFT** (mod_07 동형, attbOptions 패턴) | attbOptions(링 색상) 선택 | `{..., ATTB: 링색값}` (P1 mod_07:3240) | 링 색상이 ATTB. 단가차 有 |
| **ROU_DFT** (mod_07:3331~3344) | 사이즈연동 반경 `roundingConfigMap[pdtCode].value[DIV_SEQ]` | `{PCS_DTL_CD, ATTB: 반경}` (멀티) | 반경이 ATTB, 사이즈→반경 캐스케이드 |
| **SUB_MTR/INN_DFT 류** (mod_07:2586~2600) | 수량입력 `u`(기본 1, <1 보정) 또는 `relatedData.orderQty` | `{PCS_DTL_CD, PCS_DTL_NM, ATTB: r ? u : orderQty, ATTB_2:"", ATTB_3:""}` | **ATTB_2/ATTB_3 슬롯 존재**(빈값이라도). 수량형 후가공 |
| **PDT_WRK(의류 인쇄영역)** (mod_07:2467~2470) | `relatedData.orderQty` | `{PCS_DTL_CD:r.value.value, ATTB: orderQty}` | 인쇄영역×수량 |
| **COT_DFT/SCO_DFT** (mod_07:2247~2263) | **ATTB 안 씀** — 대신 `PCS_DTL_CD = coating(slice0,4) + side(slice-1)` 합성 | `{PCS_DTL_CD: u+c}` (ATTB 없음) | ⚠ COT_DFT 는 ATTB 가 아니라 **PCS_DTL_CD 합성**으로 양면축 운반. P1 L-2 의 진실 확인 |

→ **구조 결론**: ATTB 는 (a) 속성칩 선택값(BID/RIN), (b) 사이즈연동 반경(ROU), (c) 수량(SUB_MTR/PDT_WRK) 의 **3가지 의미**로 쓰인다. ATTB_2/ATTB_3 슬롯도 일부 컴포넌트가 채운다(현재 빈값이나 후니가 채울 수 있음). COT_DFT 의 양면축은 **ATTB 가 아니라 PCS_DTL_CD 합성**(L-2 별건).

### 2.2 우리 구현의 ATTB 처리 (전손실 경로)

```
contract/price.ts:13   SelectedFinish = { groupId, valueId }          ← ATTB 필드 자체가 없음
price.ts:63~72         finishesFromSelections → { groupId, valueId } 만 ← 선택 컨트롤이 ATTB 미수집
red-adapter.ts:423~428 PCS_INFO.map → { PCS_COD, PCS_DTL_COD, ATTB:'' } ← 직렬화 시 빈문자 하드코딩
red-types.ts:178       PCS_INFO 타입 ATTB?:string (ATTB_2/ATTB_3 슬롯 없음)
```

3중 손실: ① 계약 타입에 슬롯 없음 → ② store 가 수집 안 함 → ③ 직렬화가 `''` 강제. **데이터가 흐를 통로 자체가 없다.**

### 2.3 L-1 재현 스펙 (S3 — 구현 금지, 명세만)

> **데이터 모델 변경**: `SelectedFinish`(contract/price.ts:13)에 `attb?: string; attb2?: string; attb3?: string` 추가. ATTB 는 후가공별로 (a)속성칩값 (b)사이즈연동반경 (c)수량 3의미를 갖는 다형 불투명 문자열이므로 **계약은 의미를 모르고 문자열만 운반**(위젯 무계산 원칙 유지). 정규화 OptionValue 에는 ATTB 후보를 담을 `attbOptions?: {id,label}[]`(BID/RIN 속성칩) 또는 사이즈연동/수량형은 cascade 룰로 산출.
> **수집(store)**: ATTB 보유 후가공(BID_SIL/RIN_DFT=속성칩, ROU_DFT=사이즈연동반경, SUB_MTR/PDT_WRK=수량) 선택 시 `finishesFromSelections`(price.ts:63)가 해당 그룹의 선택 ATTB 를 `SelectedFinish.attb`에 실어야 함. 속성칩형은 사용자 선택값, 사이즈연동형은 cascade 가 현재 DIV_SEQ→반경 룩업해 주입, 수량형은 수량 상태 echo.
> **직렬화(adapter)**: `serializeRedPriceRequest`(RA:423~428)가 `ATTB: f.attb ?? ''`, `ATTB_2: f.attb2 ?? ''`, `ATTB_3: f.attb3 ?? ''` 로 echo. red-types PCS_INFO 타입에 ATTB_2/ATTB_3 추가.
> **검증**: ATTB 가 단가에 영향 주는 후가공(링색·반경)에서 ATTB 변경 시 PRICE 가 달라지는지 라이브 BFF(또는 캡처)로 대조. 현재 `ATTB:''` 는 "속성 없음" 단가를 받음 → 속성 선택해도 같은 가격 = 오산.
> **비-목표**: COT_DFT 양면축은 ATTB 아님 — L-2(PCS_DTL_CD 합성)로 별도 처리. ATTB 스펙은 BID/RIN/ROU/SUB_MTR/PDT_WRK 에 한정.

---

## 3. LOSS 레지스터 (가격 도메인)

| ID | 항목 | severity | 무엇을 잃나 | S3 재현 스펙 (구현 금지) |
|----|------|----------|-------------|--------------------------|
| **D-L1** | ATTB 전손실 (BID_SIL/RIN_DFT/ROU_DFT/SUB_MTR/PDT_WRK) | **BLOCKER** | 속성칩값·사이즈연동반경·수량형 ATTB → 가격·주문 PCS_INFO 왜곡 | §2.3: SelectedFinish.attb/attb2/attb3 추가 + store 수집(3유형별) + 직렬화 echo + red-types ATTB_2/3. P1 L-1 과 동일 — D1 이 컴포넌트별 출처 확정 |
| **D-L2** | itemGroup 분기를 데이터-형상 휴리스틱으로 대체 | **MAJOR** | item_gbn 명시분류 대신 `inner 존재` 추론 → inner 없는 책자/inner 있는 비책자 오분기, **clothes2025 PRINT_TYPE 분기 부재** | NormalizedProduct 에 `itemGroup`(불투명 분류 echo, opt.item_gbn) 추가 → 어댑터가 itemGroup 으로 ORD_INFO 스키마 분기(book2025/clothes2025/vDigital). 휴리스틱(RA:397) 제거 |
| **D-L3** | PRICE=0/누락 시 ok:true 가능 (어댑터 retCode만 검사) | **MAJOR** | Red 는 `!result_sum.PRICE → 주문불가`(mod_06:1167). 어댑터는 retCode===200 만 → PRICE 0 이어도 ok:true 빠져나감 | `mapPriceResponse`(RA:451)에 `ok: res.retCode===200 && (sum.PRICE>0 \|\| sum.ORG_PRICE>0)` 가드 추가. 또는 canOrder 도메인이 보완(D1-15 — state 핸드오프 확인 필요) |
| **D-L4** | DOSU_COD 의도 omit (OPEN-1) | **MINOR(미확정)** | Red ORD_INFO 에 DOSU_COD 존재. 우리는 PRN_CLR_CNT 로 도수 가격의미 운반(테스트 입증). 회귀 가드 유지 중 | 라이브 BFF 가 DOSU_COD 를 PRN_CLR_CNT 외 추가로 요구하는지 검증. 현재는 PRN_CLR_CNT echo 로 충분(가드된 의도 omit) — 위험 낮음 |
| **D-L5** | ATTB_2/ATTB_3 슬롯 부재 | **MINOR→MAJOR(후니)** | SUB_MTR 류가 ATTB_2/3 빈값 슬롯 운용(mod_07:2598). 현재 Red 는 빈값이나 후니가 채우면 손실 | red-types PCS_INFO + SelectedFinish 에 슬롯 추가(D-L1 과 동반 처리) |
| **D-L6** | result lines 한글 label 미추출 | **MINOR** | 가격 분해행 라벨이 PCS_CD 코드(RA:469) — Summary 투명성 표시 저하 | result_log/result_sum 에서 한글 label 매핑 또는 어댑터가 PCS_GRP_NM 룩업 |
| **D-L7** | KOI 탭 실시간 부분갱신 재계산 없음 (mod_06:1224) | **MAJOR(의류 컨버전)** | 에디터 내 자재변경 시 부분갱신 가격호출 | state/editor 도메인 핸드오프 — 가격 직렬화는 재사용 가능(부분갱신 params spread) |
| **D-L8** | 이중 debounce 타이밍 (150+200ms, mod_06:2742/mod_05:1937) | **(state 도메인)** | 본 가격 도메인은 reqBody 형상만 — 타이밍은 state 소관 | 노트만. state 매트릭스가 단일 debounce 합치기 회귀 점검 |

---

## 4. F-2 수정 재확인 (캡처가 아닌 코드 권위로)

P1/이전에 F-2(bare `{ORD_INFO,...}` → `{dataJson:{...}}` 래핑 + mb_cust_cod) 수정이 랜딩됨. **코드 권위로 재확인**:

- ✅ **dataJson 래퍼**: mod_05:1138 `body:JSON.stringify({dataJson: priceRequestPayload.body})` — 우리 RA:420~432 정합. **캡처가 아니라 코드가 직접 증명**.
- ✅ **mb_cust_cod fallback**: mod_06:2522 `i?.mb_cust_cod || "10000000"` — 우리 RA:430 `?? '10000000'` 정합.
- ✅ **ORD_INFO 배열 + ORD_CNT/PRN_CNT 둘 다**: red-code-map-05 §3.5(ATTB=prnCnt) + S5 실측 — 우리 RA:407~408 정합.
- ⚠ **단 price_gbn 위치**: 코드는 reqBody 안에 price_gbn 을 넣는다(red-code-map-05 §3.1 dataJson 내부). 우리도 dataJson 내부(RA:429) — 정합. (이전 우려였던 "price_gbn 이 분기키" 는 코드상 분기 0 으로 무효, echo 위치만 맞으면 됨 — 맞음.)

**F-2 는 코드 권위에서도 hold.** 단 dataJson 내부 필드 중 **ATTB(D-L1)·itemGroup 분기(D-L2)** 는 F-2 가 다루지 않은 잔존 결함.

---

## 5. 검증 메타 (회의적 점검)

- **과대보고 경계**: D1-1/D1-4/D1-5/D1-8/D1-10/D1-11 "완전재현" 은 *현 fixture(디지털/책자/굿즈/파우치) reqBody 형상* 기준 사실. 의류(clothes2025 PRINT_TYPE)·부자재(ACC)·KOI탭 재계산은 fixture 부재로 **미검증** — 컨버전 시 D-L2/D-L7 로 재분류.
- **PCS_INFO 보존의 진실 경계**: 단순 후가공(ATTB 없는 ADC_PVC/BON_PAP 등)은 PCS_COD/PCS_DTL_COD 복원으로 **진짜 무손실**(RA:425~426). 손실은 오직 ATTB 보유 후가공(BID/RIN/ROU/SUB_MTR/PDT_WRK 5종) — 과대보고 아님.
- **휴리스틱 isBook 의 현 위험도**: 현 fixture 에서 책자만 inner 데이터를 가지므로 RA:397 휴리스틱이 우연히 정확. 그러나 **명시 itemGroup 부재**는 후니 데이터에서 깨질 수 있는 구조적 취약(D-L2 MAJOR 유지).
- **L-1 은 P1 과 D1 양쪽에서 BLOCKER 확정** — D1 이 추가로 ATTB 의 3가지 의미·출처·ATTB_2/3 슬롯·COT_DFT 비-ATTB 경계를 정밀화함. S3 가 SelectedFinish 확장 시 이 3유형을 모두 다뤄야 함.
