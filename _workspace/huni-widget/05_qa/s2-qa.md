# S2 QA Report — Huni-Widget 스티커 비교 QA (원형·사각반칼·DTF 판)

- 검증 도구: Playwright + 설치된 Chrome 채널(headless, 실 브라우저 렌더 — 조작·날조 없음) + tsc/vitest/vite build + `npx tsx` 어댑터 런타임 실행 + grep 정량 게이트
- 대상(우리): `http://localhost:5173/` (vite dev) — `<huni-widget pdt="STTHCIC|STPADPN|...">` 커스텀 엘리먼트(상품별 신규 호스트 삽입으로 productCode 확정 오버라이드)
- 레퍼런스(Red): `http://localhost:3001/` (widget_monitor 라이브 테스트베드, HTTP 200) — 스티커 가격계약 동종성 대조. 1단계 라이브 캡처(s2_raw_captures)가 1차 근거원
- 비교 하네스: `http://localhost:4173/compare.html` (HTTP 200)
- 캡처: `05_qa/captures/s2_{STTHCIC,STCUXXX,STPADPN}.{json,png}` (1단계) + `05_qa/captures/s2_STTHCIC_widget.png` (本 QA 라이브 렌더)
- 대표 SKU: **STTHCIC**(원형, digital_price/PriceTable3D) · **STCUXXX**(사각반칼, digital_price) · **STPADPN**(DTF 판, **vTmpl_price/FixedUnit** 시트가)
- 분류: S2 스티커 비교 QA + 회귀(INV-3). 가격 *수치* 범위 — digital_price **검증 제외**(비로그인 PRICE=0), FixedUnit **shape-only + 위젯 가격계산 0**(서버권위 INV-1).
- 게이트 현황: **tsc EXIT 0 / vitest 29/29(red-adapter-sticker 5 + S1 무회귀 24) / vite build 성공**(loader 1.27kB + widget 675kB) — 실측 재확인 완료.

---

## 종합 판정: **GO**

S2 검증 항목 6개 전부 PASS. 회귀(INV-3) PASS — 스티커 확대가 S0 책자(PRBKYPR) + S1 디지털(BCSPDFT/PRPOXXX)을 깨지 않음을 **라이브 재마운트로 입증**. 불변식 INV-1~5 전부 유지. **Blocker/Major 결함 0건.** Minor 2건(둘 다 검증 깊이 한계 — 결함 아님). **F4 모양커팅 시각 판정: PASS(결함 없음)** — 현 fixtures 에선 THO_DFT 가 hidden-essential(auto-apply)이라 UI 미렌더. S3(포스터/실사) 진입 무차단.

> **핵심 입증:** 커밋 19e0331 diff 가 `src/widget/**`(store/cascade/shadow/dispatcher) **0줄 변경** — 변경은 `01_reverse/`·`fixtures/`·`adapters/red/fixture-source.ts`(라우팅)·`test/`·`captures/` 뿐. 두 가격모델(digital_price/vTmpl_price)·모양커팅·DTF 시트가가 **순수 어댑터+데이터**로 흡수되어 동일 코어가 책자·디지털·스티커를 모두 렌더.

---

## 검증 항목별 결과

### 1. 라이브 마운트 (STTHCIC·STPADPN, 단일면) — **PASS** (라이브)

두 스티커가 :5173 위젯에 정상 마운트·렌더. Shadow DOM 격리, 옵션그룹 수 일치.

| 관찰 | STTHCIC(원형) | STPADPN(DTF 판) | PRBKYPR(회귀) | 근거 |
|------|---------------|------------------|---------------|------|
| mounted | **true** | **true** | true | 라이브 `shadowRoot #huni-widget-root.children>0` |
| `hasInnerLabel`(내지) | **false** | **false** | **true** | 단일면 vs 책자 분기 정확 |
| native `<select>` | **0** | **0** | 0 | RULE-1 준수 |
| listbox 트리거 | 1(용지) | 1(용지) | 2(표지+내지) | 라이브 |
| 카운터 입력 | 1(수량) | 1(수량) | 2(수량+내지장수) | `input[inputmode=numeric]` |
| 파일 입력 | 1(PDF) | 0(에디터: "기본 편집하기") | 1 | 라이브 |
| 렌더 그룹 | 9(규격/용지/도수/재단/코팅/넘버링/부분UV/수량/기본작업) | 6(규격/용지/도수/폴리백/수량/기본작업) | 14+ | 라이브 groupLabels |
| 격리(공격 CSS) | bg 흰색·radius 0px·Noto Sans | 동일 | 동일 | 호스트 `button{bg:red;radius:9999px;font:Times}` 누수 0 |

- 옵션그룹 수: 1단계 캡처는 STTHCIC "옵션그룹 9", STPADPN "옵션그룹 7"로 기록. 라이브 렌더 가시 그룹은 STTHCIC **9**(THO_DFT 1개가 vis=false 미렌더 → 매핑 9 중 8 가시 + 기본작업 패널), STPADPN **6**(매핑 7 중 가시 6 + 기본작업) — 매핑 그룹 수(9/7)와 가시 렌더 수의 차이는 **hidden-essential(auto-apply) 그룹** 때문이며 의도된 동작(아래 §2).
- 코드 경로: 단일면 분기 `red-adapter.ts:62` `sides=[{key:'default'}]`. 스티커 fixture 는 `inner_pdt_mtrl_info` 부재 → 책자 표지/내지 분리 없음.
- STPADPN uploadType=editor("기본 편집하기" 버튼, files=0) — 에디터 진입 경로. STTHCIC uploadType=pdf("기본 PDF 파일 업로드", files=1).
- 캡처 증거: `s2_STTHCIC_widget.png` — 규격 option-button 그리드(사이즈직접입력 선택 보라테두리 + 10X10~100X100), 용지 select-box, 재단/코팅/넘버링/부분UV finish-button(선택 보라), 수량 −/100/+, 하단 합계 0원.

### 2. 모양커팅 finish-button (F4 — 시각 검수) — **PASS (결함 없음)** [별도 명기]

**THO_DFT(모양커팅) 매핑은 정확하나, 현 fixtures 에선 hidden-essential(auto-apply)이라 UI 에 selectable 그룹으로 렌더되지 않음** → "모양 선택이 후가공처럼 보임" 리스크가 **현 패스에선 발현되지 않음.**

| 관찰 | STTHCIC | STCUXXX | 근거 |
|------|---------|---------|------|
| THO_DFT 매핑 | `PCS_THO_DFT` → **finish-button** (값 11/1) | 동일 (값 1) | vitest console + `mapProduct` 런타임 |
| THO_DFT `VIEW_YN/ESN_YN` | **N / Y** (hidden-essential) | N / Y | fixture `pdt_pcs_info` 실측 |
| 어댑터 visible | **false** | false | `mapProduct` 런타임 `g.visible=false` |
| 라이브 UI 렌더 | **미렌더**(OptionPanel `filter(visible)`) | 미렌더 | 라이브 groupLabels 에 "모양커팅" 부재 |
| 가격 summary 노출 | **THO_DFT 라인**(0원, 투명성 행) | — | `s2_STTHCIC_widget.png` 합계부 |

- **시각 판정**: STTHCIC 라이브 캡처(`s2_STTHCIC_widget.png`)에 가시 finish-button 은 재단/코팅/넘버링/부분UV 4종으로 전부 **진짜 후가공**이며 의미 혼동 없음. 모양커팅은 가시 그룹이 아니라 가격 breakdown 의 투명성 라인(THO_DFT 0원)으로만 등장 → 적용된 후가공의 정직한 표기. **DESIGN.md 14종 규칙 위반 없음, finish-button 배치 합리적.**
- **권고 노트(비차단)**: SCO_DFT 라벨이 실데이터에서 "**부분UV**"(스코어링 아님) — 1단계 캡처 §2.1 "SCO_*" 표기와 라벨 차이 있음(데이터 라벨이 정답, 위젯은 echo). 또한 THO_DFT 가 **visible=true 로 렌더되는 SKU**(예: STTHELP 타원형/STTHSQU 사각라운드 등 모양선택형)는 현 fixtures 미보유 → "가시 모양선택 finish-button" 의 시각검수는 본 패스 미수행(아래 S2-M1). 위젯 무관(finish-button 동일).

### 3. FixedUnit 실가 shape (STPADPN) — **PASS** (라이브 캡처 + 런타임)

비로그인에도 실 시트가 반환되며, 정규화 `NormalizedPriceBreakdown` 으로 일관 흡수. 위젯은 echo 만 — **가격계산 0**.

| 케이스 | result_sum.PRICE / PRICE_VAT | 정규화 finalPrice/vat/lines | 근거 |
|--------|------------------------------|------------------------------|------|
| STPADPN 140×200 | **4000 / 400** | finalPrice=4000, vat=400, lines=3 | `mapPriceResponse` 런타임 |
| STPADPN A4(210×297) | **8000 / 800** | (raw 캡처 datapoint) | `s2_raw_captures/s2_STPADPN.json` call2 |
| 규격 비례 | 140×200(4000) < A4(8000) ✅ | 동일 envelope `vTmpl_price` | raw priceCalls call1/call2 |
| STTHCIC digital(비교) | 0 / 0 | finalPrice=0, lines=2 | shape-only |

- **shape 일관성**: 두 가격모델 모두 `result_sum.{PRICE,PRICE_VAT,PRICE_MALL,ORG_PRICE...}` 동일 키 → `mapPriceResponse` 가 동일 `{ok, finalPrice:number, vat:number, lines[]}` 로 흡수(vitest "동일 정규화 shape" pass). digital=0, FixedUnit=4000 둘 다 정상 처리.
- **위젯 가격계산 0 (INV-1)**: widget-store.ts:308 `finalPrice: s.price?.finalPrice ?? 0` — 응답 echo. price.ts:69 `priceSchemeKey: product.priceSchemeKey`(불투명 echo). 위젯 코어에 산술 가격계산(`*unit`/`*quantity`/reduce 합산) **0건**(grep). 4000/8000 은 BFF 가 산출, 위젯은 그대로 표시.
- 비례 datapoint(8000)는 **fixture 미적재**(loaded fixture 는 140×200=4000 1건) — A4=8000 은 raw 캡처에만 존재(아래 S2-M2 shape-only 한계). 단 비례·shape 동일성은 raw 캡처로 입증.

### 4. digital_price 가격값 제외 — **준수 확인** (명시)

STTHCIC/STCUXXX 는 비로그인 PRICE=0(`price_STTHCIC_sample.json result_sum.PRICE=0`). **가격 수치 비교 대상 아님** — 옵션트리(§1)·캐스케이드(§5)·요청 페이로드 shape 만 검증. 응답 라인 shape(`result[].PCS_CD`=THO_DFT/CUT_DFT round-trip)은 정확.

### 5. disable 캐스케이드 (STTHCIC 151행) — **PASS** (런타임)

소재→PCS disable 평면화가 Red 동등 의미로 동작. **위젯 코어(cascade.ts) 불변 엔진**이 그대로 흡수.

| 관찰 | 실측 | 근거 |
|------|------|------|
| `result.product_data.pdt_disable_pcs_info` 행 | **151** | fixture 실측(1단계 캡처 일치) |
| `mapProduct` disableRules 평면화 | **151** (group-level 64 + value-level 87) | `mapProduct` 런타임 |
| 평면화 규칙 | `triggerValueId`(소재) → `disablesGroupId`/`disablesValueId` | red-adapter.ts:281-285 |
| 런타임 캐스케이드 | 소재 `RGEGP050` 선택 → `PCS_SCO_DFT`(부분UV) 그룹 전 값 `disabled:true` | `applyCascade(p, {GRP_MTRL_COVER:RGEGP050}, 'GRP_MTRL_COVER')` 런타임 |
| 엔진 코드 | S0/S1 와 동일 `cascade.ts`(material→pcs disable, 선택해제 연쇄) | 커밋 diff: cascade.ts 변경 0 |

- Red 동등 의미: Red 는 자재 변경 시 `pdt_disable_pcs_info` 로 후가공 가용성을 잠금 → 위젯은 동일 룰을 group/value disable 로 평면화. 24개 룰이 STTHCIC 실그룹(CUT/THO/COT/NUM/SCO)을 타깃, 나머지는 미렌더 그룹(MIS 등) 타깃(안전 무시). 평면화·적용 의미 Red 동등.

### 6. 회귀 (INV-3 — 위젯 코어 불변, 最重) — **PASS** (라이브) — [별도 섹션 아래]

상세 §회귀 검사.

---

## 회귀 검사 (INV-3 위젯 코어 불변) — **PASS**

스티커 확대 후에도 S0 책자 + S1 디지털 fixture 가 **동일 코어로 그대로 렌더**됨을 라이브 재마운트로 입증. 어댑터+데이터만 늘었고 store/cascade/shadow/dispatcher 불변.

### 동일 컨텍스트 5상품 순차 라이브 재마운트 결과 (`<huni-widget pdt>` 삽입)

| 항목 | STTHCIC | STPADPN | **PRBKYPR(S0)** | **BCSPDFT(S1)** | **PRPOXXX(S1)** |
|------|---------|---------|------------------|------------------|------------------|
| mounted | true | true | **true** | **true** | **true** |
| hasInnerLabel | false | false | **true** | false | false |
| 카운터 | 1 | 1 | **2** | 1 | 1 |
| listbox | 1 | 1 | **2** | 1 | 1 |
| native select | 0 | 0 | 0 | 0 | 0 |
| 내지 그룹 | 부재 | 부재 | **표지/내지 분리 전부** | 부재 | 부재 |
| 특징 그룹 | 모양커팅(hidden) | 폴리백포장 | 면지·제본방향·내지장수 | 모양(타공/플라워) | 접지·모양커팅·미싱·오시 |
| console errors | — | — | — | — | — |

- **단일 코어 분기 정합**: 동일 probe 가 스티커·디지털은 `hasInnerLabel:false`·카운터1·listbox1 로, 책자(PRBKYPR)는 `hasInnerLabel:true`·카운터2·listbox2 로 렌더 — **하나의 코어가 데이터(hasInner)에 따라 단일면/책자를 모두 정확히 분기.** INV-3 핵심 증명.
- **console/page errors = 0** (5 마운트 전체). "Invalid hook call" 0건. `_consoleErrors:[]`, `_pageErrors:[]`.

### 격리·Portal (INV-4) — 회귀 PASS

- 공격 CSS(`button{background:red;border-radius:9999px;font:Times}`) 주입에도 5상품 전부 button bg=흰색·radius=0px·Noto Sans 누수 0.
- body-escape popper(`document.body [role=listbox]`) = **0** (Portal-in-shadow) — 5상품.

### 빌드/타입/테스트 (공통 게이트) — PASS

- `npx tsc --noEmit` → **EXIT 0** (디스패처 exhaustive 포함).
- `npx vitest run` → **29/29 pass** (editor-bridge 8 / red-adapter 6 / red-adapter-digital 7 / **red-adapter-sticker 5** / upload-flow 3).
- `npx vite build` → **성공** (153 modules, loader.js 1.27kB + widget.js 675.52kB).

---

## 불변식 검증 (INV-1~5)

| INV | 판정 | 근거 |
|-----|------|------|
| **INV-1 서버권위 가격** | **PASS** | 위젯 가격계산 0. grep: src/widget 에 산술 가격계산(`*unit`/`*quantity`/reduce 합산) 0건. FixedUnit(4000/8000)·digital(0) 모두 `finalPrice` echo(widget-store.ts:308). priceSchemeKey 불투명 echo(price.ts:69) — vTmpl_price 분기 0. |
| **INV-2 계약 중립** | **PASS** (정량) | grep `vTmpl_price\|FixedUnit\|price_gbn\|ORD_INFO\|PCS_CD\|MTRL_CD\|[Ss]hopby` 위젯 src(adapters/red 제외) = **2건뿐, 전부 주석**(constraints.ts:5 "Red MTRL_CD", product.ts:42 "Red MTRL_CD/PCS_DTL_COD 등"). 타입·런타임에 Red 고유명·`vTmpl_price`·`FixedUnit` 문자열 0. price_gbn/vTmpl_price 는 adapters/red 안에만. |
| **INV-3 위젯 코어 불변** | **PASS** (라이브+diff) | 커밋 19e0331 변경 27파일 전부 01_reverse/fixtures/adapters(red/fixture-source.ts)/test/captures — **src/widget/** 0줄. S0·S1 라이브 재마운트 전부 통과. cascade/store/shadow/dispatcher diff 0. |
| **INV-4 Shadow 격리+Portal** | **PASS** (라이브) | 공격 CSS 누수 0(5상품), listbox Portal shadow 내부·body-escape 0. |
| **INV-5 14 dispatcher 고정** | **PASS** (정량) | `ComponentType` union = 14 멤버(product.ts:8-21). `OptionControl.tsx:19` 단일 switch 가 14 case(12 렌더 + summary/upload-cta=null), default 없음 → tsc exhaustive(EXIT 0) 강제. 팩토리/레지스트리 0(주석 명시). 스티커 신규 case 0. 스티커 3종 전부 기존 4종(option-button/select-box/finish-button/counter-input)만 사용(vitest console). |

---

## 결함 목록 (심각도)

### S2-M1 [Minor] 가시 모양선택형(THO_DFT visible=true) SKU fixture 미보유 — *검증 깊이 한계 (결함 아님)*
- 현황: 캡처 2종(STTHCIC/STCUXXX) 모두 THO_DFT 가 `VIEW_YN=N`(hidden-essential, auto-apply)이라 모양커팅이 UI 에 selectable 그룹으로 **렌더되지 않음**. 따라서 F4 의 "가시 모양 finish-button 시각검수"는 본 패스에서 실제 렌더로 미수행.
- 영향: 위젯 무영향 추정(finish-button 동일 경로, 신규 componentType 0). 단 모양선택형 SKU(예 STTHELP/STTHSQU)에서 visible=true 시 finish-button 배치가 "후가공처럼" 보일 시각 리스크(F4)는 그 fixture 로 1회 시각검수 권장.
- 위치: `04_build/fixtures/` (가시 THO_DFT SKU 부재). 재현: VIEW_YN=Y 인 모양선택 ST SKU 캡처 후 라이브 마운트, finish-button 배치 시각검수.
- 조치: S3 진입과 무관(비차단). live-capture 로 모양선택형 1건 보강 시 F4 완결.

### S2-M2 [Minor] FixedUnit A4(8000) datapoint fixture 미적재 — *shape-only 한계 (결함 아님)*
- 현황: loaded fixture `price_STPADPN_sample.json` 은 140×200=4000 1건만 보유. A4=8000 비례 datapoint 는 raw 캡처(`s2_raw_captures/s2_STPADPN.json` call2)에만 존재.
- 영향: 위젯 무영향(INV-1 — 위젯은 서버 응답 echo, 비례는 BFF 책임). shape 동일성·비례는 raw 캡처로 입증됨. 다만 fixture-드리븐 테스트는 1 datapoint 만 커버.
- 위치: `04_build/fixtures/price_STPADPN_sample.json`. 재현: A4 케이스 fixture 추가 후 `mapPriceResponse` finalPrice=8000 검증.
- 조치: 비차단. 후니 BFF 연동 시 실가는 서버에서. fixture 보강은 선택.

### (참고) 가격값 일치 — **검증 범위 외 / shape-only** (명시)
- digital_price 스티커(STTHCIC/STCUXXX): 비로그인 **PRICE=0** → 가격 *수치* 검증 제외. 옵션트리·캐스케이드·페이로드/응답 shape 만 판정.
- FixedUnit(STPADPN): 실가(4000/8000) 반환되나 **위젯은 echo만**. *수치 일치*가 아니라 **shape 일관성(NormalizedPriceBreakdown) + 위젯 가격계산 0(INV-1)** 을 검증 — 통과. 위젯 코드가 4000/8000 을 산출/가공하지 않음 확인(grep 0건).

---

## 라이브 vs 코드-온리 구분 (정직성)

| 검증 | 방식 |
|------|------|
| 스티커 라이브 마운트(STTHCIC/STPADPN, 단일면·격리·옵션그룹) | **라이브** (커스텀 엘리먼트 삽입, DOM 프로브) |
| F4 모양커팅 시각(렌더 그룹·summary 라인) | **라이브** (`s2_STTHCIC_widget.png` 스크린샷 + groupLabels) |
| THO_DFT hidden-essential(VIEW_N→미렌더) | fixture 실측 + `mapProduct` 런타임 + 라이브 미렌더 |
| FixedUnit shape(4000/vat400/lines3) + digital(0) | **런타임** `mapPriceResponse` + fixture |
| FixedUnit 비례(140×200<A4) | raw 캡처 datapoint (4000/8000) |
| disable 캐스케이드 151행 평면화 + 런타임 disable | **런타임** `mapProduct`(151) + `applyCascade`(SCO_DFT disable) |
| S0 책자 + S1 디지털 회귀 | **라이브** (5상품 동일 컨텍스트 재마운트, console 0) |
| INV-2 중립성·INV-5 exhaustive·INV-1 가격계산 0 | **정량 grep + tsc EXIT 0** |
| 위젯 코어 0변경(INV-3) | **git diff** 커밋 19e0331 (src/widget 0줄) + 라이브 |
| 가격 *수치* 일치(digital) | **검증 범위 외** (PRICE=0, INV-1) |
| Red 위젯 스티커 직접 조작 비교 | 부분 — Red 1단계 라이브 캡처(동일 envelope/캐스케이드)가 우리 어댑터 입력원. 위젯 내부 깊이 조작 미수행 |

---

## 다음 stage(S3) 영향

- **S3(포스터/실사) 진입 무차단.** S2 가 INV-1~5 전부 유지·코어 0변경으로 통과 → S3 도 "어댑터+데이터만" 가설 적용 가능.
- S3 신규성 **NC-1**(실사/대형 — area-input·평방미터 가격 등): 본 패스에서 area-input 디스패처 case 는 이미 존재(OptionControl.tsx:40, AreaInputBridge)하나 **스티커 패스에선 미사용** → S3 에서 처음 가시 렌더될 전망. area-input/price-slider InputSpec 직렬화 경로가 실데이터로 첫 검증 대상이 됨(현재 코드는 준비됨, 미실증).
- 선결: S3 진입 전 포스터/실사 Red fixture 캡처(area-input 평방·대형 규격·실사 가격모델) 필요.
- 잔존: S2-M1(가시 모양선택 SKU), S2-M2(FixedUnit A4 fixture), S1-M1(별색 5종 fixture) — 전부 S3 와 독립, 병행 보강 가능.

---

## 환경 메모
- 라이브 probe 는 `<huni-widget pdt="...">` 커스텀 엘리먼트를 상품별 신규 호스트 div 에 삽입(connectedCallback 가 해당 productCode 로 마운트) — S1 init-override 대비 productCode 확정 격리. 동일 페이지 순차 삽입으로 S2→S0→S1 회귀를 한 컨텍스트에서 대조.
- 임시 probe 스크립트(`_s2probe.mjs`, `_s2f4.mjs`)는 실행 후 삭제 완료. F4 스크린샷 `captures/s2_STTHCIC_widget.png` 보존. 재현은 `interact.mjs` 패턴 + 본 보고서 절차로 가능.
- Red(3001) HTTP 200 — 본 패스는 스티커 가격계약 동종성(1단계 라이브 캡처 = 어댑터 입력원)으로 검증. 가격 *수치* 범위 외라 Red 위젯 가격 라이브 직접 호출은 미수행.
