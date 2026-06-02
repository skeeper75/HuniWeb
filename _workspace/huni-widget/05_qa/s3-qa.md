# S3 QA Report — Huni-Widget 포스터/실사/배너 비교 QA (NC-1 `dimension-matrix-input`)

- 검증 도구: Playwright + 설치된 Chrome 채널(headless, 실 브라우저 렌더 — 조작·날조 없음) + tsc/vitest/vite build + `npx tsx` 어댑터 런타임 실행 + grep 정량 게이트 + `git show 7968401` 정량 diff
- 대상(우리): `http://localhost:5173/` (vite dev, HMR) — `<huni-widget pdt="BNBNFBL|BNPTPET|...">` 커스텀 엘리먼트(상품별 신규 호스트 삽입으로 productCode 확정 오버라이드)
- 레퍼런스(Red): `http://localhost:3001/` (widget_monitor 라이브 테스트베드, HTTP 200) — 토큰 만료 가능성으로 **fixture 기반 검증 위주**(s3-poster-capture.md 캡처가 어댑터 입력원)
- 비교 하네스: `http://localhost:4173/compare.html` (HTTP 200)
- 검증 대상 커밋: **7968401** (NC-1 dimension-matrix-input + 자유입력 cutW/cutH 결함 해소)
- 대표 SKU: **BNBNFBL**(현수막, real_price/SizeMatrix2D) · **BNPTPET**(배너, real_price) — 둘 다 GRP_SIZE → dimension-matrix-input
- 캡처: `05_qa/captures/s3_nc1_BNBNFBL.png` (라이브 렌더)
- 게이트 현황: **tsc EXIT 0 / vitest 39 passed(기존 33 무회귀 + NC-1 6: 단위 3 + 라이브 런타임 3) / vite build 성공** — 실측 재확인 완료.

---

## 종합 판정: **GO**

S3/NC-1 검증 항목 8개 전부 PASS. **첫 코어(store) 터치임에도 INV-3 경계가 git diff 로 정량 입증됨** — store 변경은 `dimsFromSelection` if-분기 1개 + widget-store numeric slot(필드1+액션1+초기화+defaultSelections 보정) 뿐이고, cascade/shadow/editor-bridge/`buildPriceRequest` 본체는 **0줄 변경**(재작성 아님). **결함 해소 입증**: 자유입력 5000×900 → store 요청 `{cutW:5000,cutH:900,workW:5004,workH:904}` (이전 `{cutW:0,cutH:0}` 폴백 + retCode 999 원인 제거). **회귀 입증(最重)**: adapter 라우팅이 `real_price` 한정이라 S0 책자·S1 디지털·S2 스티커의 GRP_SIZE 가 option-button 유지됨을 **라이브 강검증**(S1/S2 의 "사이즈직접입력" 칩 클릭 → 가로/세로 input **미출현**, S3 만 출현). 불변식 INV-1~5 전부 유지. **Blocker/Major 결함 0건.** Minor 2건(검증 깊이 한계 — 결함 아님). **S4(아크릴, NC-2) 진입 무차단.**

> **핵심 입증:** 커밋 7968401 의 `src/widget/**` 변경 4파일 중 leaf(DimensionMatrixInput.tsx 신규)·dispatcher(OptionControl.tsx case+1)는 가시 컴포넌트 확장이고, **코어는 price.ts(+10) + widget-store.ts(+22/−1)** 뿐. `cascade|editor-bridge|price-seam|shadow|buildPriceRequest` grep = **NONE**. 하나의 store 가 데이터(priceScheme=real_price + 0×0 sentinel)에 따라 자유입력 분기를 소비하고, 그 외엔 기존 sizeRule 룩업 경로 그대로 도달.

---

## 검증 항목별 결과

### 1. NC-1 라이브 마운트 (BNBNFBL/BNPTPET) — **PASS** (라이브)

현수막·배너가 :5173 에 마운트 시 GRP_SIZE 가 dimension-matrix 칩으로 렌더, "사이즈직접입력" 선택 시 가로/세로 number input 2개 출현. Shadow DOM 격리.

| 관찰 | BNBNFBL(현수막) | BNPTPET(배너) | 근거 |
|------|------------------|----------------|------|
| mounted | **true** | **true** | 라이브 `#huni-widget-root.children>0` |
| GRP_SIZE componentType | **dimension-matrix-input** | dimension-matrix-input | `mapProduct` 런타임 + nc1-live-proof |
| "사이즈직접입력" 칩(hasFreeChip) | **true** | true | 라이브 버튼 텍스트 스캔 |
| 자유입력 선택 전 numeric input | 1(수량) | — | 라이브 |
| 자유입력 선택 **후** numeric input | **3(가로/세로/수량)** | — | 라이브 (aria-label `가로`/`세로`) |
| native `<select>` | **0** | 0 | RULE-1 준수 |
| 렌더 그룹 | 규격/용지/도수/재단/아일렛/각목/큐방/로프/봉제/고리/추가부자재/수량 | 규격/용지/도수/코팅/재단/아일렛/큐방/추가부자재/수량/기본작업 | 라이브 groupLabels |
| 격리(공격 CSS) | bg 흰색·radius 0px·Noto Sans KR | 동일 | 호스트 `button{bg:red!important;radius:9999px;font:Times}` 누수 0 |

- 자유입력 선택 시 number input 정확히 +2(가로/세로)만 출현 → `isFree` 분기 정확.
- 캡처 증거: `s3_nc1_BNBNFBL.png` — 가로/세로 `5000 X 900 mm` + helpText "가로 0~5000mm · 세로 0~5000mm" + 재단(정사이즈재단/방풍커팅/모양재단)·각목·봉제(접어꿰매기/줄미싱/봉미싱) finish-button + 하단 CUT_ZUN 0원/합계 0원.
- `console errors=0, page errors=0` (7상품 마운트 전체). "Invalid hook call" 0건.

### 2. 결함 해소 (핵심) — **PASS** (라이브 런타임 + 단위)

"사이즈직접입력" + 가로/세로(5000/900) 입력 → store `dimsFromSelection` 출력이 입력수치로 채워짐. 이전 `{cutW:0,cutH:0}` 폴백 + retCode 999 해소. 작업사이즈=재단+4mm 자동.

| 케이스 | dimsFromSelection 출력 | 근거 |
|--------|------------------------|------|
| 자유입력 5000×900 (dev 동일 store 경로) | **`{cutW:5000,cutH:900,workW:5004,workH:904}`** | `nc1-live-proof.test.ts` (createWidgetStore + StubBffClient, bff.price() 캡처) |
| 자유입력 5000×900 (buildPriceRequest 단위) | `{cutW:5000,cutH:900,workW:5004,workH:904}` | `red-adapter-poster.test.ts` |
| 자유입력 미입력(W/H=0) | `cutW:0` 유지(검증/canOrder 가 차단) | poster.test.ts — 빈값 방어 |
| 작업=재단+CUT_MRG | mrg=4 (base.cutMargin 런타임 확인) | tsx 런타임 |

- 결함 원인 정확히 제거: 정적 sizeRule 룩업이 SIZE_0(`{cutW:0,cutH:0,workW:4,workH:4}` sentinel)에서 0 폴백 → numeric slot 우선 소비로 입력수치 직접 전달.
- **INV-1 준수**: 위젯은 `cutW/cutH/workW/workH` 수치 전달만. workW/H = cut+mrg 는 **치수 산술**(가격 산술 아님). 보간·단가·최종가는 BFF(비로그인 PRICE=0).

### 3. 규격프리셋 회귀 — **PASS** (라이브 런타임 + 단위)

규격(5000X900 등) 선택 시 기존 sizeRule 경로 정상 유지. 자유입력 분기가 프리셋을 안 깸.

| 케이스 | 출력 | 근거 |
|--------|------|------|
| 프리셋 5000X900 선택 | `{cutW:5000,cutH:900,workW:preset.workW(5004)}` (sizeRule 권위) | nc1-live-proof + poster.test |
| 프리셋 선택 + 자유입력 수치(111×222) 동시 보유 | **프리셋 우선** → cutW:5000(sizeRule), 자유입력 무시 | poster.test "규격프리셋 선택" |

- 우선순위 정확: 선택 rule 이 0×0 sentinel 일 때만 numeric slot 소비, 그 외엔 sizeRule 룩업 권위. `if (rule.cutW===0 && rule.cutH===0 && dim)` 가드가 이를 강제.

### 4. 자유입력 범위 검증 — **PASS** (라이브 + 단위)

MAX_CUT_WDT=5000 상한이 leaf `clampAxis` 입력단에서 적용.

| 관찰 | 실측 | 근거 |
|------|------|------|
| InputSpec.max (MAX_CUT_WDT) | **5000** | tsx 런타임 `inputSpec.max=5000` |
| axis2.max (MAX_CUT_HGH) | 5000 | inputSpec.axis2 |
| leaf clampAxis 상한 | `n > max → return max` | DimensionMatrixInput.tsx:24 |
| 입력 5000 정상 표시 | value="5000" | 라이브 axisVals |

- clamp 위치: **입력단**(leaf clampAxis) — 사용자가 5000 초과 타이핑해도 즉시 상한. canOrder(주문단)는 하한/빈값 차단. UX 정합: 입력단 상한 + 주문단 빈값방어 2단.

### 5. 배너 가공옵션 (F5) — **PASS** (런타임 + 라이브)

CUT_ZUN(열재단)/봉제/봉미싱 등 배너 가공이 **finish-button 으로 흡수** — 신규 컴포넌트 0.

| 그룹 | componentType | 근거 |
|------|---------------|------|
| PCS_CUT_ZUN(재단/열재단) | finish-button | tsx 런타임 + 라이브("정사이즈재단/방풍커팅/모양재단") |
| PCS_SEW_DFT / PCS_SEW_RIN(봉제/봉미싱) | finish-button | tsx 런타임 + 라이브("접어꿰매기/줄미싱/봉미싱") |
| PCS_ILT/LUM/QBG/ROP/SUB | finish-button | tsx 런타임 |
| BNBNFBL 전 componentType 집합 | **dimension-matrix-input, select-box, option-button, finish-button, counter-input** (5종) | tsx 런타임 |

- 신규 컴포넌트는 dimension-matrix-input 1개뿐. 나머지 배너 가공은 전부 기존 finish-button. (명세상 COT_DFT 명칭은 본 fixture 에 ILT/LUM/QBG 등으로 표기 — 라벨은 데이터 echo, 컴포넌트는 finish-button 동일.)

### 6. DESIGN 규칙 (8 Critical Rules) — **PASS** (라이브)

| 규칙 | 실측 | 근거 |
|------|------|------|
| RULE-1 native select 금지 | `<select>` = **0** | 라이브 7상품 |
| RULE-2 선택 칩 = 흰배경 + 보라 2px 테두리 | selBg=`rgb(255,255,255)`, selBorderColor=`rgb(85,56,134)`(#553886), selBorderWidth=`2px` | 라이브 자유입력 sentinel 선택칩 |
| 비선택 칩 토큰 | border #CACACA, text #979797 | leaf:74 + 라이브 |
| native input 금지(자유입력) | `type="text" inputMode="numeric"`(스피너 없음) + 토큰(#CACACA border, #553886 focus) | DimensionMatrixInput.tsx:87-105 + 캡처 |
| 폰트 | Noto Sans KR | 라이브 computed font |
| 격리(Shadow DOM) | 공격 CSS 누수 0 | 라이브 |

- 칩 스타일은 OptionButton RULE-2 동일 토큰. 자유입력 input 은 AreaInput 토큰 동일(높이 50px, #CACACA border, #553886 focus).

### 7. INV-3 경계 (最重) — **PASS** (git diff 정량)

store 는 `dimsFromSelection` 분기 1개 + widget-store numeric slot 만, cascade/shadow/editor-bridge/buildPriceRequest 본체 **무변경**. "재작성 아님" 판정. → 아래 §INV-3 경계 상세.

### 8. 전 stage 회귀 (最重) — **PASS** (라이브 강검증)

S0 PRBKYPR + S1 BCSPDFT/PRPOXXX + S2 STTHCIC/STPADPN 여전히 통과. **adapter 라우팅 real_price 한정 → S1/S2 GRP_SIZE(option-button) 무변경** 라이브 입증. → 아래 §회귀 상세.

---

## 결함 해소 섹션 (cutW/cutH 채워짐 증명)

**§2.1 결함:** "사이즈직접입력"(SIZE_0) 자유입력 → 정적 sizeRule 룩업이 sentinel(`cutW:0,cutH:0`)에서 0 폴백 → 가격요청 dimensions 빈값 → BFF retCode 999.

**해소 메커니즘 (price.ts diff):**
```
if (sizeGroup && rule && rule.cutW === 0 && rule.cutH === 0) {   // sentinel 식별
  const dim = s.dimensionInputs[sizeGroup.id];                    // numeric slot
  if (dim && (dim.w > 0 || dim.h > 0)) {
    const mrg = product.constraints.base.cutMargin;               // 4mm
    return { side, cutW: dim.w, cutH: dim.h, workW: dim.w+mrg, workH: dim.h+mrg };
  }
}
// ↓ 기존 sizeRule 룩업 경로 그대로 도달(early-return 후 불변)
```

**증명 (3중):**
1. **라이브 런타임** (`nc1-live-proof.test.ts`): dev 하네스 동일 경로(createWidgetStore + StubBffClient[FixtureRedDataSource])로 `bff.price()` 에 실리는 요청 캡처 → `req.dimensions[default]={cutW:5000,cutH:900,workW:5004,workH:904}`. 콘솔 로그 `[LIVE] 이전 폴백 {cutW:0,cutH:0} 해소 확인`.
2. **단위** (`red-adapter-poster.test.ts`): buildPriceRequest(state) → `dim.cutW=5000, cutH=900, workW=5004, workH=904`.
3. **라이브 DOM** (`s3_nc1_BNBNFBL.png`): 가로 5000 / 세로 900 입력 → `5000 X 900 mm` 표시, console error 0.

**미입력 방어:** W/H=0 이면 `cutW:0` 유지(가드 `dim.w>0||dim.h>0` 미충족) → canOrder/검증이 주문 차단. 빈 가격요청은 여전히 방어됨(정상).

---

## INV-3 경계 섹션 (git diff — store 분기만 · 재작성 0)

`git show 7968401 --stat` 의 `src/widget/**` 변경 = 4파일:

| 파일 | 줄수(+/−) | 분류 | 재작성 여부 |
|------|-----------|------|-------------|
| `controls/DimensionMatrixInput.tsx` | 신규(+115) | **leaf**(가시 컴포넌트 확장) | 신규 파일 |
| `controls/OptionControl.tsx` | +25 | dispatcher case+1 + Bridge | 기존 case 불변 |
| `stores/price.ts` | **+10/−0** | dimsFromSelection if-분기 1개 | **재작성 아님** |
| `stores/widget-store.ts` | **+22/−1** | numeric slot(필드1+액션1+init+defaultSelections 보정) | **재작성 아님** |

**무변경 정량 증명** (`git show 7968401 --stat | grep -iE 'cascade|editor-bridge|price-seam|shadow|buildPriceRequest'`) = **NONE**:
- `cascade.ts` — 0줄 (캐스케이드 엔진 불변)
- editor-bridge(postMessage 핸들러) — 0줄
- shadow(Portal/adoptedStyleSheets) — 0줄
- `buildPriceRequest` 본체 — 0줄 (`dimensions: sides.map(dimsFromSelection)` 호출부 불변, 분기는 dimsFromSelection **내부** 1개)

**price.ts 재작성 아님 입증:** diff 가 기존 `dimsFromSelection` 함수 시작부에 `if (sentinel && slot) return {...}` 분기 **삽입**만. early-return 후 `if (rule) { return {...rule}; }` 기존 코드 **그대로 도달**(unchanged context line). 기존 sizeRule 룩업 경로는 한 글자도 안 바뀜.

**widget-store.ts 재작성 아님 입증:** `selectOption`/`schedulePriceQuote`/`setQuantity`/`uploadPdf`/`openEditor` 등 **기존 액션 본문 무변경**. 추가는 ① `DimensionInput` 타입 ② `dimensionInputs` 상태 필드 ③ `setDimensionInput` 액션 ④ loadProduct 초기화 1줄 ⑤ defaultSelections 가드(`g.inputSpec` → `g.inputSpec && g.values.length === 0`, dimension-matrix 가 values 보유하므로 기본 프리셋 선택 위함). `−1` 은 ⑤의 조건 1줄 교체.

**계약 신규 필드 0:** product.ts diff = union 멤버 1줄(`'dimension-matrix-input'`)만. `InputSpec.axis2` 는 **부모 커밋(7968401^)에 이미 존재**(grep count=1, area-input 용 2축 슬롯 재사용). `PriceDimension.cutW/cutH`·`BaseRule.cutMargin/maxCutW` 도 기존 슬롯.

---

## 회귀 섹션 (S0+S1+S2 라이브 통과 — real_price 한정 라우팅 증명)

### 동일 컨텍스트 7상품 순차 라이브 재마운트

| 항목 | BNBNFBL(S3) | BNPTPET(S3) | **PRBKYPR(S0)** | **BCSPDFT(S1)** | **PRPOXXX(S1)** | **STTHCIC(S2)** | **STPADPN(S2)** |
|------|-------------|-------------|------------------|------------------|------------------|------------------|------------------|
| mounted | true | true | **true** | **true** | **true** | **true** | **true** |
| native select | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| console errors | — | — | — | — | — | — | — |
| 특징 | 규격=dimension-matrix + 배너가공 | 규격=dimension-matrix | 책자(표지/내지 분리) | 디지털명함 | 포스터(접지/모양커팅) | 원형스티커 | DTF판 |

### S1/S2 GRP_SIZE option-button 유지 — **강검증** (最重)

S1/S2 의 size 그룹에도 "사이즈직접입력" 칩이 존재(`hasFreeChip:true`)하나, **클릭해도 가로/세로 input 이 출현하지 않음**(=option-button 의 일반 선택지일 뿐, dimension-matrix 아님). dimension-matrix 라면 칩 클릭 후 numeric input +2 여야 함.

| 상품 | "사이즈직접입력" 칩 클릭 전→후 numeric input | spawnedWH | 판정 |
|------|----------------------------------------------|-----------|------|
| **BCSPDFT(S1)** | [수량] → [수량] | **false** | option-button 유지 ✅ |
| **STTHCIC(S2)** | [수량] → [수량] | **false** | option-button 유지 ✅ |
| **BNBNFBL(S3, 대조)** | [수량] → [**가로,세로,**수량] | **true** | dimension-matrix ✅ |

→ **스티커/명함 사이즈가 dimension-matrix 로 잘못 바뀌지 않음** 라이브 입증. adapter 라우팅 `priceScheme === 'real_price' && hasFreeInput` 조건이 S1(digital_price)·S2(digital_price/vTmpl_price)를 정확히 배제.

### 격리·Portal (INV-4) — 회귀 PASS

- 공격 CSS(`button{background:red!important;border-radius:9999px;font:Times}`) 주입에도 7상품 전부 button bg=흰색·radius=0px·Noto Sans KR 누수 0.
- body-escape popper(`body > [role=listbox]`) = **0** (Portal-in-shadow).

### 빌드/타입/테스트 (공통 게이트) — PASS

- `npx tsc --noEmit` → **EXIT 0** (디스패처 exhaustive 포함).
- `npx vitest run` → **39 passed** (7 파일: editor-bridge 8 / red-adapter 6 / red-adapter-digital 7 / red-adapter-sticker 5 / upload-flow 3 / **red-adapter-poster 3 단위 + nc1-live-proof 3 = NC-1 6**, 기존 33 무회귀).
- `npx vite build` → **성공**.

---

## 불변식 검증 (INV-1~5)

| INV | 판정 | 근거 |
|-----|------|------|
| **INV-1 서버권위 가격** | **PASS** | grep: src/widget/stores·components 에 가격 산술(`*unit`/`*quantity`/`reduce(`) **0건**. 위젯은 cutW/cutH/workW/workH **치수 전달만**(workW/H=cut+mrg 는 치수 산술, 가격 아님). 보간·단가·최종가는 BFF(비로그인 PRICE=0, 합계 0원 라이브 확인). |
| **INV-2 계약 중립** | **PASS** (정량) | grep `real_price\|digital_price\|vTmpl_price\|CUT_WDT\|CUT_HGH\|MAX_CUT\|DFT_YN\|PCS_CD\|MTRL_CD\|BNBNFBL` in `src/widget/`+`src/contract/` = **3건, 전부 주석**(DimensionMatrixInput.tsx:24 "MAX_CUT 초과 거부" 주석, constraints.ts:5·product.ts:43 "Red MTRL_CD" 주석). 런타임/타입에 Red 고유명·priceScheme 문자열 0. union 멤버명 `dimension-matrix-input` 중립. sentinel 식별은 `cutW===0&&cutH===0` **값 비교**(Red 필드명 직접참조 아님). priceScheme 문자열은 `adapters/red` 안에서만 소비. |
| **INV-3 store 분기만·재작성 0** | **PASS** (git diff) | 위 §INV-3 경계. price.ts +10(if 분기 1개, early-return 후 기존 경로 불변), widget-store.ts +22/−1(필드+액션+init+가드). cascade/editor-bridge/price-seam/buildPriceRequest 본체 0줄(grep NONE). |
| **INV-4 Shadow 격리+Portal** | **PASS** (라이브) | 공격 CSS 누수 0(7상품), listbox Portal shadow 내부·body-escape 0. shadow 파일 diff 0. |
| **INV-5 15 union ↔ dispatcher exhaustive** | **PASS** (정량) | `ComponentType` union = **15 멤버**(product.ts, dimension-matrix-input 포함). `OptionControl.tsx` 단일 switch = **15 case**, **default 없음**(grep 'default:' = 0) → tsc exhaustive(EXIT 0) 강제. 신규 case 1개(dimension-matrix-input)만 추가, 기존 case 불변. 팩토리/레지스트리 0. |

---

## 결함 목록 (심각도)

### S3-M1 [Minor] Red 라이브 위젯 직접 비교 미수행(토큰 만료) — *검증 깊이 한계 (결함 아님)*
- 현황: Red 테스트베드(:3001) 토큰 만료 가능성으로 본 패스는 **fixture 기반 검증 위주**. Red 위젯의 실 SizeMatrix2D 보간 PRICE 와 우리 cutW/cutH→PRICE 직접 대조는 미수행.
- 영향: 위젯 무관(INV-1 — 위젯은 cutW/cutH 전달만, PRICE 는 BFF 권위). 결함 해소 증명 대상은 "cutW/cutH 가 요청에 실리는지"이며 이는 fixture 라이브 런타임으로 충족.
- 위치: `01_reverse/s3-poster-capture.md` §1.5(실측 계약). 재현: Red 토큰 갱신 후 라이브 가격 캡처 → cutW/cutH 변동→PRICE 변동 대조.
- 조치: S4 진입과 무관(비차단). 로그인 캡처로 보강 가능(NC1-impl-note §6.3).

### S3-M2 [Minor] real_price 작업사이즈 공식(cut+4mm) 2 SKU 만 검증 — *검증 깊이 한계 (결함 아님)*
- 현황: `work = cut + cutMargin(4)` 가 BNBNFBL/BNPTPET 2 SKU 에서만 캡처. 타 배너/실사 SKU 의 cutMargin 이 동일 4mm 인지 미검증.
- 영향: cutMargin 은 base.cutMargin(어댑터가 데이터에서 추출) — SKU 별 다르면 어댑터가 자동 흡수(위젯 코어 무관). 공식 자체(cut+mrg)는 데이터 드리븐.
- 위치: `04_build/fixtures/`(real_price SKU 2종). 재현: 추가 real_price SKU fixture 캡처 후 cutMargin 확인.
- 조치: 비차단. S4(아크릴)·후속 real_price 확대 시 SKU 추가하며 자연 보강.

### (참고) 가격값 일치 — **검증 범위 외 / shape-only** (명시)
- BNBNFBL/BNPTPET real_price: 비로그인 **PRICE=0**(합계 0원 라이브). **가격 수치 비교 대상 아님** — cutW/cutH 가 요청에 실리는지(결함 해소)·옵션트리·페이로드 shape 만 판정. SizeMatrix2D 보간·PRICE 산출은 BFF 권위(INV-1). 위젯이 cutW/cutH 로 가격 산술 시 INV-1 위반이나 grep 0건으로 미발생.

---

## 라이브 vs 코드-온리 구분 (정직성)

| 검증 | 방식 |
|------|------|
| NC-1 라이브 마운트(BNBNFBL/BNPTPET, 칩 렌더·자유입력 input 출현·격리) | **라이브** (커스텀 엘리먼트 삽입, DOM 프로브 + 클릭) |
| 결함 해소(cutW/cutH 채워짐, 5000×900→workW/H 5004/904) | **라이브 런타임**(nc1-live-proof, dev 동일 store) + **단위**(poster.test) + **라이브 DOM**(스크린샷) |
| 규격프리셋 회귀(sizeRule 권위, 자유입력 무시) | **라이브 런타임** + 단위 |
| 자유입력 범위(MAX_CUT=5000 clamp) | **라이브**(value 확인) + 단위(inputSpec.max) + 코드(clampAxis) |
| F5 배너가공 finish-button 흡수 | **런타임**(mapProduct componentType) + **라이브**(groupLabels/스크린샷) |
| DESIGN RULE-2 칩 스타일(흰배경+보라2px) | **라이브** computed style |
| S1/S2 option-button 유지(칩 클릭→W/H 미출현) | **라이브 강검증**(클릭 전후 numeric input diff) |
| S0+S1+S2 회귀(7상품 마운트, console 0) | **라이브** (동일 컨텍스트 순차 재마운트) |
| INV-2 중립성·INV-5 exhaustive·INV-1 가격산술 0 | **정량 grep + tsc EXIT 0** |
| INV-3 store 분기만·재작성 0 | **git diff** 커밋 7968401 (src/widget 4파일, cascade/bridge/seam 0줄) |
| 가격 *수치* 일치(real_price PRICE) | **검증 범위 외** (PRICE=0, INV-1) — Red 토큰 만료로 라이브 PRICE 대조 미수행(S3-M1) |

---

## 다음 stage(S4, NC-2) 영향

- **S4(아크릴, NC-2) 진입 무차단.** S3 가 INV-1~5 전부 유지 + **첫 코어 터치를 INV-3 경계 내(store 분기 1개)로 입증**하며 통과 → "코어 최소 침습 + 어댑터+데이터" 가설이 store 터치에도 성립.
- NC-1 패턴(numeric slot + dimsFromSelection 분기 + dimension-matrix leaf)이 **재사용 가능한 선례**: NC-2 가 또 다른 numeric 입력차원(예: 두께/면수)을 요구하면 동일 numeric slot 패턴(groupId 키)으로 슬롯 충돌 없이 확장 가능. dimensionInputs 가 이미 `Record<string, DimensionInput>` 다규격 대비.
- 잔존(전부 S4 독립, 병행 보강 가능): S3-M1(Red 라이브 PRICE 대조), S3-M2(real_price SKU 추가 cutMargin), S2-M1(가시 모양선택 SKU), S2-M2(FixedUnit A4 fixture), S1-M1(별색 5종 fixture).
- S4 선결: 아크릴 Red fixture 캡처(NC-2 신규성 — 두께/면수/형압 등 어떤 입력차원이 필요한지). NC-2 가 또 코어를 터치하면 본 패스와 동일하게 INV-3 git diff 정량 검증 필수.

---

## 환경 메모
- 라이브 probe 는 `<huni-widget pdt="...">` 커스텀 엘리먼트를 상품별 신규 호스트 div 에 삽입(connectedCallback 가 해당 productCode 로 마운트) — dev 기본 PRBKYPR(`init(#host)`)과 격리. 동일 페이지 7상품 순차 삽입으로 S3↔S0/S1/S2 회귀를 한 컨텍스트에서 대조.
- 임시 probe 스크립트(`_s3nc1.mjs`, `_s3reg.mjs`)는 실행 후 삭제 완료. 라이브 스크린샷 `captures/s3_nc1_BNBNFBL.png` 보존. 재현은 `interact.mjs` 패턴 + 본 보고서 절차로 가능.
- Red(3001) HTTP 200 이나 토큰 만료 가능성으로 본 패스는 fixture(s3-poster-capture.md 캡처 = 어댑터 입력원)로 검증. real_price PRICE 라이브 직접 대조는 S3-M1(비차단).
