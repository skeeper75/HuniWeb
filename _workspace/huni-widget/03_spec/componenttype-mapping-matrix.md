# componenttype-mapping-matrix.md — 14종 전수 매핑 매트릭스 + 구조결함 감사

> 파이프라인 ③ 선행 분석. 시각재현(Phase 6)을 안전하게 잇기 위해 4단 체인의 정합성을 전수 확정한다.
> **코드 수정 0** — 결함은 발견·권고만. 추측 금지(불명/후니데이터 필요로 표기).
> 근거: red-adapter.ts / component-type-map.ts / OptionControl.tsx / contract/product.ts / fixtures/product_*.json(16종) 전수 대조.

---

## 0. 4단 체인 정의

```
Red 위젯 실측 → red-adapter 산출 → dispatcher 렌더 → 후니 DESIGN 14종
 (역공학 근거)   (코드 현실)        (OptionControl)   (스펙 목표)
```

판정 기준:
- **어댑터 산출**: red-adapter.ts에서 해당 componentType 문자열을 OptionGroup에 실제로 넣는 코드가 있는가 (파일:라인).
- **dispatcher 렌더**: OptionControl.tsx switch에 case가 있는가 (Y/N).
- **실렌더(fixture)**: 16개 product fixture 중 어댑터 로직을 통과해 해당 componentType을 실제로 만들어내는 상품이 있는가.

---

## 1. 전수 매트릭스 (14 contract componentType + 변형, 빠짐없이)

| # | 후니 componentType | ② Red 어댑터 산출 (파일:라인) | ③ dispatcher case | ④ 트리거 fixture (실렌더?) | ⑤ 후니 컨버전 예상 | ⑥ 구조결함·공백 |
|---|--------------------|------------------------------|-------------------|---------------------------|--------------------|------------------|
| 1 | `option-button` | **산출됨**. `DATASET_COMPONENT_TYPE.size`(map:8) → `red-adapter:190`(비-matrix size), `DATASET_COMPONENT_TYPE.dosu`(map:10) → `red-adapter:234`(도수), `:266`(내지도수) | Y (L21) | **전 fixture**. size: 16/16, dosu: 16/16. (예: BCSPDFT 도수 2값, BNBNFBL size 5값) | 후니 size/dosu 옵션 → option-button. **필요필드**: 옵션값 ≤6개 텍스트. 후니가 size를 다르게 줄 가능성 있음 | 없음 (체인 완전) |
| 2 | `select-box` | **산출됨**. `DATASET_COMPONENT_TYPE.material`(map:9) → `red-adapter:221`(표지용지), `:256`(내지용지), `:313`(**PRN 폐쇄래더 enum 재사용**) | Y (L25) | **다수**. mtrl 16/16(PRPOXXX 45값·STCUXXX 19값·STTHCIC 19값), PRN래더: HLCLSTD(10행)·HLCLWAL(1행) | 후니 용지 옵션(값 多) → select-box. **필요필드**: 옵션 라벨 리스트 | 없음. (참고: `:313`은 select-box를 인쇄수량 enum으로 **의미 전용** — 기능상 정상, 단 가독성 주의) |
| 3 | `counter-input` | **산출됨**. `DATASET_COMPONENT_TYPE.quantity`(map:11) → `red-adapter:329` (`prnLadder.length===0 && q` 일 때) | Y (L37, CounterInputBridge) | **다수**. PRN래더 없는 상품 전부(ACNTHAP·BCSPDFT·STCUXXX 등 14/16). HLCLSTD·HLCLWAL은 래더라 select로 대체 | 후니 수량(FIR/INC/STEP 자유입력) → counter-input. **필요필드**: min/first/step. 후니가 폐쇄래더면 select로 갈 수도 | 없음 |
| 4 | `color-chip` | **경로 존재·산출 0**. `pcsComponentType(false)` 하드코딩(`red-adapter:126`) → 인자가 상수 `false` → `'color-chip'` 분기 영구 도달 불가 | Y (L29) | **실렌더 불가**. 전 16 fixture의 pcs·mtrl에서 `CLR_HEX_CD` 100% 빈 값(검증 완료) → `false`는 데이터의 정확한 반영 | 후니가 박/포일 후가공에 색상 hex 제공 시 살아남. **필요필드**: PCS값에 colorHex(또는 mtrl 색상) | **②Red 경로부재**. `false` 하드코딩은 *버그 아님*(Red에 색 데이터 0). 후니 어댑터가 `hasColor` 동적판정 필요 |
| 5 | `price-slider` | **산출 0**. 어댑터 전체에서 `'price-slider'` 리터럴 0건 | Y (L45, PriceSliderBridge) | **실렌더 불가**. 어떤 fixture도 트리거 안 함 | 후니가 수량 구간을 슬라이더로 표현하기로 결정 시. **DB+UX 결정 필요** | **②Red 경로부재**. 컴포넌트·브리지·case 모두 있으나 산출 경로 0. Red엔 슬라이더 의미 데이터 없음(미사용 컴포넌트) |
| 6 | `image-chip` | **산출 0**. 어댑터 전체에서 `'image-chip'` 리터럴 0건. ImageChip.tsx는 `v.imageUrl`(OptionValue.imageUrl) 의존하나 어댑터가 `imageUrl`을 채우는 곳도 0 | Y (L35) | **실렌더 불가**. 어떤 fixture도 트리거 안 함 | 후니가 재질/디자인을 이미지 썸네일로 제공 시. **필요필드**: OptionValue.imageUrl(이미지 URL) | **②Red 경로부재**. 2차 발견 정확. contract.imageUrl·dispatcher·컴포넌트 OK, **어댑터 산출 + imageUrl 소스 둘 다 없음** |
| 7 | `mini-color-chip` | **산출 0**. 리터럴 0건 | Y (L31) | **실렌더 불가** | 후니 부자재 소형 색상칩(링컬러 등) 제공 시. **필요필드**: colorHex + 소형 표시 의도 | **②Red 경로부재**. color-chip과 동일 — 색 데이터 0 + 어댑터 분기 0 |
| 8 | `large-color-chip` | **산출 0**. 리터럴 0건 | Y (L33) | **실렌더 불가** | 후니 다색 그리드(별색인쇄 팔레트 등) 제공 시. **필요필드**: colorHex 다수 | **②Red 경로부재**. 동일 |
| 9 | `area-input` | **산출 0**. 리터럴 0건. (브리지는 일반 selection 슬롯으로 처리하도록 OptionControl:70에 존재) | Y (L41, AreaInputBridge) | **실렌더 불가**. 어떤 fixture도 트리거 안 함 | 후니 박크기/맞춤크기 가로×세로 mm 단일 입력 옵션 제공 시. **주의**: dimension-matrix-input(#10)과 의미 중복 — 후니 컨버전 시 어느 쪽 쓸지 결정 필요 | **②Red 경로부재**. Red는 자유크기를 dimension-matrix(프리셋+자유입력)로 표현 → 순수 area-input 산출 경로 없음 |
| 10 | `dimension-matrix-input` | **산출됨**. `red-adapter:190` (`priceScheme==='real_price' && hasFreeInput`) | Y (L43, DimensionMatrixBridge) | **실렌더 가능**. BNBNFBL·BNPTPET (둘 다 `real_price` + `사이즈직접입력` sentinel `CUT_WDT='0.00'`). 검증: `num('0.00')===0` → hasFreeInput=true | 후니 실사/배너류 맞춤크기 → dimension-matrix. **필요필드**: real_price 상응 가격체계 + 0×0 sentinel 사이즈행 | 없음 (NC-1 경로 작동 확인) |
| 11 | `page-counter-input` | **산출됨**. `DATASET_COMPONENT_TYPE.innerPage`(map:12) → `red-adapter:285` (`hasInner && q.pageMin/Max != null`) | Y (L39, PageCounterBridge) | **실렌더 가능**. PRBKYPR (유일 inner 보유 상품, inner_pdt_mtrl 4·inner_dosu 1) | 후니 책자 내지장수 옵션 → page-counter. **필요필드**: inner 면 + MIN/MAX/STEP_INN_PAGE | 없음 |
| 12 | `finish-button` | **산출됨**. `pcsComponentType(false)`(`red-adapter:126`) 의 false 분기 → 항상 finish-button | Y (L23) | **실렌더 가능**. pcs 보유 전 상품(16/16, 예: BCSPDFT 19값·STTHCIC 17값). 후가공 그룹 전부 finish-button | 후니 후가공(코팅/귀돌이/타공 등) → finish-button. **필요필드**: PCS 그룹·값 | 없음. (단 #4와 동일 분기점 — 후니 색상후가공이 오면 finish/color 분기 로직 필요) |
| 13 | `finish-select-box` | **산출 0**. 리터럴 0건. 어댑터는 후가공을 항상 finish-button(`pcsComponentType`)으로만 산출 | Y (L27) | **실렌더 불가**. 어떤 fixture도 트리거 안 함 | 후가공 값이 많을 때(긴 리스트) select형으로. **현재 어댑터에 "PCS 값 多 → select" 분기 없음** | **③구조결함 후보**. DESIGN 7.12는 값 多 후가공을 finish-select-box로 규정하나, 어댑터는 PCS값 개수와 무관하게 항상 finish-button. 값이 많은 PCS그룹(예: 19값)도 버튼으로 깔림 → DESIGN 의도와 불일치 가능 |
| 14 | `summary` | **해당없음(어댑터 비대상)**. OptionGroup이 아닌 패널 고정 컴포넌트 | N (디스패처 제외, OptionControl:48 `return null`) | N/A. PriceSummary가 NormalizedPriceBreakdown 직접 소비 | 후니 가격 분해 → PriceSummary (componentType 무관) | 없음 (설계상 디스패처 제외가 정상) |
| 15 | `upload-cta` | **해당없음(어댑터 비대상)**. 패널 고정(OrderCTA), CtaCapability 기반 | N (디스패처 제외, OptionControl:49 `return null`) | N/A. OrderCTA가 product.cta 소비 | 후니 CTA 정책 → CtaCapability | 없음 (설계상 정상) |

> 표기: `map:N`=component-type-map.ts 라인, `red-adapter:N`=red-adapter.ts 라인, `L N`=OptionControl.tsx 라인.

---

## 2. 분류 요약 (①②③)

### ① Red-실렌더 가능 (현재 fixture로 렌더됨 → 시각재현 즉시 가능) — 7종

| componentType | 트리거 fixture(대표) | 비고 |
|---------------|---------------------|------|
| `option-button` | 전 16/16 (size·dosu) | 가장 흔함 |
| `select-box` | 16/16 (mtrl 多), HLCLSTD/HLCLWAL (PRN enum) | 인쇄수량 enum 재사용 포함 |
| `counter-input` | 14/16 (PRN래더 없는 상품) | 수량 자유입력 |
| `finish-button` | 16/16 (pcs 후가공) | 후가공 |
| `page-counter-input` | PRBKYPR (유일 inner) | 책자 전용 |
| `dimension-matrix-input` | BNBNFBL·BNPTPET (real_price+자유입력) | NC-1 |
| `summary`/`upload-cta` | (디스패처 외 패널 고정) | componentType 무관하게 항상 표시 |

→ **시각재현 즉시 가능 컴포넌트**: option-button, select-box, counter-input, finish-button, page-counter-input, dimension-matrix-input (+ summary/upload-cta 패널). 14종 중 핵심 6종 + 패널 2종.

### ② Red 경로부재 (후니 컨버전 전까지 시각재현 불가) — 5종

| componentType | 끊김 유형 | 후니 살아날 조건 |
|---------------|----------|------------------|
| `color-chip` | 하드코딩 `false` + Red 색 데이터 0 | 후가공/mtrl에 colorHex 제공 |
| `mini-color-chip` | 어댑터 분기 0 + 색 데이터 0 | 소형 색상칩 옵션(링컬러 등) |
| `large-color-chip` | 어댑터 분기 0 + 색 데이터 0 | 다색 그리드(별색 팔레트) |
| `image-chip` | 어댑터 산출 0 + imageUrl 소스 0 | OptionValue.imageUrl 이미지 옵션 |
| `price-slider` | 어댑터 산출 0 (Red에 슬라이더 의미 없음) | 수량 구간 슬라이더 UX 채택 |

→ **후니 이연 목록**: color-chip / mini-color-chip / large-color-chip / image-chip / price-slider. 이 5종은 fixture를 아무리 바꿔도 현재 Red 데이터로 렌더 불가 (baseline 없음 = 시각재현 대상 아님).

### ③ 구조결함 (코드 결정 필요) — 1종 (+area-input 경계)

| componentType | 결함 | 권고 |
|---------------|------|------|
| `finish-select-box` | 어댑터가 PCS 값 개수와 무관하게 항상 finish-button. DESIGN 7.12(값 多→select)와 잠재 불일치 | 후니 후가공 데이터 확정 후 "PCS 값 임계치→finish-select-box" 분기 추가 여부 결정. **현 시점 코드수정 보류** (Red 기준으론 finish-button이 동작) |
| `area-input` (경계) | dimension-matrix-input과 기능 중복. 순수 area-input 산출 경로 없음 | 후니 컨버전 시 area vs dimension-matrix 택1 결정. 둘 다 유지할 근거 없으면 area-input은 미사용 |

---

## 3. 구조결함 상세 (유형·증거·권고 — 코드 수정 안 함)

### D-1. image-chip 산출 경로 0 (2차 발견 재확인) — ②
- **유형**: 산출경로 부재 + 데이터 소스 부재(이중).
- **증거**: `grep "'image-chip'" src/adapters/` → 0건. ImageChip.tsx:64는 `v.imageUrl` 의존하나 red-adapter 전체에서 `imageUrl:` 할당 0건. OptionValue.imageUrl(contract:46)은 정의만 있고 채워지지 않음.
- **권고**: 후니가 이미지 옵션을 줄 때 (a)mtrl/option에 이미지 URL 필드 식별 → (b)어댑터에 image-chip 분기 + imageUrl 매핑 추가. **Red 단계에선 수정 불필요**(렌더할 데이터 없음).

### D-2. color-chip `false` 하드코딩 — ② (버그 아님)
- **유형**: 데이터 부재의 정확한 반영(하드코딩처럼 보이나 의미상 정상).
- **증거**: `red-adapter:126` `pcsComponentType(false)`. 전 16 fixture pcs·mtrl의 `CLR_HEX_CD` 100% 빈 값(스캔 완료). STCUXXX mtrl 19행도 `CLR_NM='기본'`·hex 빈값 = 용지지 색상 아님.
- **권고**: `false`를 동적(`hasColor`)으로 바꾸려면 후니에 색 데이터가 있어야 의미. 후니 어댑터에서 `pcsComponentType(pcs값에 colorHex 존재 여부)` 로 활성화. **Red 어댑터는 `false` 유지가 정확**.

### D-3. mini/large-color-chip 분기 부재 — ②
- **유형**: 어댑터 분기 자체가 없음(color-chip은 함수라도 있으나 mini/large는 결정 로직 0).
- **증거**: component-type-map.ts에 size/material/dosu/quantity/innerPage 5키만. 색상 크기 변형(mini 32×32 / large grid) 결정 규칙 없음.
- **권고**: 후니 부자재/별색 데이터 확정 시 "색상 옵션 + 표시크기 의도" → mini/large 분기 규칙 작성. DESIGN 7.7/7.8 참조. **현 보류**.

### D-4. price-slider 미사용 컴포넌트 — ②
- **유형**: 산출경로 0 (Red 도메인에 슬라이더 의미 데이터 없음).
- **증거**: 어댑터 `'price-slider'` 0건. PriceSliderBridge(OptionControl:85)는 존재하나 호출 도달 불가.
- **권고**: 후니 UX에서 수량 구간 슬라이더를 채택할지가 **제품 결정**. 채택 안 하면 컴포넌트·case 정리 후보(단순성). **현 보류**.

### D-5. finish-select-box 임계치 분기 부재 — ③ (유일한 코드결정 결함)
- **유형**: dispatcher-contract 정합은 OK(case 존재)이나 **어댑터 결정 로직 누락**.
- **증거**: 어댑터는 `mapPcsGroups`에서 PCS값 개수와 무관하게 `pcsComponentType(false)`=finish-button 고정(`red-adapter:126`). 값이 19개인 PCS그룹(BCSPDFT)도 버튼으로 펼침. DESIGN 7.12는 값 多 후가공을 select형으로 규정.
- **권고**: 후니 후가공 데이터 확정 후 "PCS 그룹 값 ≥ 임계치 → finish-select-box" 분기를 어댑터에 추가할지 결정. **Red 기준에선 finish-button이 동작하므로 현 시점 수정 보류** — 단 시각재현 시 값 많은 후가공 그룹이 DESIGN과 다르게 보일 수 있음을 인지.

### D-6. area-input vs dimension-matrix-input 중복 — ③ 경계
- **유형**: 산출 로직 의미 중복(같은 "자유 크기 입력"을 두 컴포넌트가 표현 가능).
- **증거**: Red는 자유크기를 dimension-matrix(`real_price`+sentinel)로만 산출. area-input(단축 mm 입력) 산출 경로 0.
- **권고**: 후니 컨버전 시 둘 중 하나로 통일 결정. **현 보류**.

---

## 4. 후니 컨버전 체크리스트 (componentType ↔ 후니 필드 의존)

> [HARD] DB 미정 — 아래는 **가능성·필요조건**이지 확정 매핑 아님. 후니 데이터 확정 시 각 항목 검증 후 어댑터에 반영.

| componentType | 후니에서 필요한 것 (불확실 — 확인 대상) |
|---------------|----------------------------------------|
| option-button | size/dosu류 옵션값 텍스트 리스트 (값 ≤ ~6) |
| select-box | 용지/옵션 값 多 리스트. 폐쇄 수량래더면 enum 재사용 |
| counter-input | 수량 자유입력 min/first/step (없으면 select로) |
| finish-button | 후가공 그룹·값. **색상 후가공이면 color-chip 분기 갈림** |
| page-counter-input | 책자 inner 면 + 내지장수 MIN/MAX/STEP |
| dimension-matrix-input | 맞춤크기 가격체계(real_price 상응) + 0×0 sentinel 사이즈행 |
| **color-chip** | 후가공/mtrl에 **colorHex 필드** (Red엔 0 — 후니 데이터 필요) |
| **mini-color-chip** | 소형 색상칩(링컬러 등) + colorHex + 표시크기 의도 |
| **large-color-chip** | 다색 그리드(별색 팔레트) + colorHex 다수 |
| **image-chip** | 재질/디자인 **이미지 URL** (OptionValue.imageUrl 소스) |
| **price-slider** | 수량 구간 슬라이더 UX 채택 여부 (제품 결정) |
| **finish-select-box** | 값 多 후가공 → select 전환 임계치 정책 |
| summary/upload-cta | NormalizedPriceBreakdown / CtaCapability (componentType 무관) |

**컨버전 핵심 주의**: 후니 데이터가 ②/③의 5+1종을 트리거하면 *그때 처음* 어댑터 분기·시각재현이 필요해진다. 따라서 후니 옵션 마스터 수령 시 **가장 먼저 "어떤 옵션이 색상(hex)/이미지(url)를 갖는가"**를 확인해야 color-chip·image-chip 계열의 부활 여부가 결정된다.

---

## 5. 권고 처리순서

1. **시각재현 계속 진행 (①7종)** — option-button·select-box·counter-input·finish-button·page-counter-input·dimension-matrix-input + summary/upload-cta는 baseline이 실재하므로 Phase 6 즉시 진행 가능.
2. **②5종은 시각재현 대상에서 제외** — color/mini/large-color-chip·image-chip·price-slider는 렌더할 fixture가 없으므로 "GAP"이 아니라 "데이터 부재". 시각재현 백로그에서 빼고 후니 컨버전 항목으로 이관.
3. **③finish-select-box(D-5)만 코드결정 후보로 별도 트래킹** — 단 Red 기준 동작하므로 후니 후가공 데이터 확정 시 처리. 지금 수정 안 함.
4. **후니 옵션 마스터 수령 시 색상/이미지 필드 우선 확인** — ②부활 여부 판정 게이트.

---

## 6. OPEN (미해결 — build-plan 이관 후보)

- O-1: DESIGN 7.6 `ImageOptionSelector` 64×64는 현 image-chip(50×50)과 별 규격 — 후니 이미지 옵션이 어느 규격인지 미확정.
- O-2: finish-select-box 임계치(값 몇 개부터 select)가 DESIGN에 수치 미명시.
- O-3: area-input과 dimension-matrix-input의 후니 단일화 기준 미정.
