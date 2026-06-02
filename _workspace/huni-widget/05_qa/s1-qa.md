# S1 QA Report — Huni-Widget 디지털인쇄 비교 QA (명함·포스터/엽서)

- 검증 도구: Playwright + 설치된 Chrome 채널 (headless, 실 브라우저 렌더 — 조작·날조 없음) + tsc/vitest + grep 정량 게이트
- 대상(우리): `http://localhost:5173/` (vite dev) — `<huni-widget pdt="BCSPDFT|PRPOXXX|PRBKYPR">` 커스텀 엘리먼트 마운트 (productCode 오버라이드)
- 레퍼런스(Red): `http://localhost:3001/` (widget_monitor 라이브 테스트베드) — 디지털인쇄 계약 동종성 대조
- 비교 하네스: `http://localhost:4173/compare.html`
- 캡처: `05_qa/captures/{s1_namecard, s1_singleside, s1_whiteprint, s1_poster, s1_poster_papers}.png`
- 대표 SKU: **BCSPDFT**(일반 명함, 단/양면) · **BCSPWHT**(화이트인쇄=별색 명함) · **PRPOXXX**(종이 포스터/엽서/접지)
- 분류: S1 디지털인쇄 비교 QA + 회귀(INV-3). **가격 *수치* 비교는 범위 외**(비로그인 캡처 PRICE=0, 서버권위 INV-1).
- 게이트 현황: **tsc 0 / vitest 24/24(디지털 7 포함) / build 성공**(통지) — 실측 재확인 완료.

---

## 종합 판정: **GO**

S1 디지털인쇄 5개 검증 항목 전부 PASS. 회귀(INV-3) PASS — 디지털 확대가 S0 책자(PRBKYPR)를 깨지 않음을 **라이브로 입증**. 불변식 INV-1~5 전부 유지. **Blocker/Major 결함 0건.** Minor 1건(별색 렌더 *의미* 명확화 — 결함 아님, 명세-동작 정합 확인). 다음 stage(S2 스티커) 진입 무차단.

> **핵심 입증:** "위젯 코어 0변경(어댑터+데이터만)으로 디지털인쇄 상품군 확대" 가설이 실데이터+라이브 렌더로 성립. BCSPDFT/PRPOXXX 단일면이 기존 5 componentType + finish로 100% 커버되며, 동일 코어가 PRBKYPR 책자(표지/내지 분리)도 그대로 렌더.

---

## 검증 항목별 결과

### 1. 단일면 UI (ProductSide=[default]) — **PASS** (라이브)

책자 표지/내지 분리 없이 단일면 경로로 정확히 렌더됨.

| 관찰 | BCSPDFT(명함) | PRPOXXX(포스터/엽서) | 근거 |
|------|---------------|----------------------|------|
| `hasInnerLabel`(내지 텍스트) | **false** | **false** | 라이브 DOM 프로브 |
| 카운터 입력 수 | 1 (수량만) | 1 (수량만) | `input[inputmode=numeric]`=1 (책자는 2) |
| 파일 입력 수 | 1 (단일 PDF) | 1 (단일 PDF) | `input[type=file]`=1 |
| 업로드 영역 | "기본 작업 / 기본 PDF 파일 업로드" 1개 | 동일 | innerText |
| 내지 그룹(GRP_INNER_*) | 0건 | 0건 | renderedGroups 에 '내지*' 부재 |

- 코드 경로: `red-adapter.ts:53` `hasInner = inner_pdt_mtrl_info.length>0` → 디지털 fixture 는 `inner_pdt_mtrl_info` 부재 → `sides=[{key:'default', uploadType: usePDF==='Y'?'pdf':'editor'}]` (red-adapter.ts:62). BCSPDFT/PRPOXXX 모두 `usePDF=Y, useKoi=N, useRP=N` → uploadType=pdf 단일면.
- 계약 테스트 교차: `red-adapter-digital.test.ts:38-47` — `sides=['default']`, `optionGroups.some(side==='inner')===false`, GRP_INNER_PAGE/MTRL_INNER/DOSU_INNER 모두 false. **7/7 pass.**
- 캡처 증거: `s1_namecard.png`·`s1_singleside.png` — 규격 바로 아래 단일 옵션 스택, 하단 "기본 작업" 단일 PDF 업로드. 표지/내지 헤더 없음.
- 라벨 정직성: 단일면이라 용지 라벨이 "표지 용지"가 아니라 **"용지"** (red-adapter.ts:174 `hasInner?'표지 용지':'용지'`). 캡처·라이브 둘 다 "용지" 확인.

### 2. 별색 자동적용 (BCSPWHT 화이트인쇄) — **PASS** (캡처+fixture+코드)

별색은 **사용자 선택 그룹이 아니라 hidden-essential 자동적용**임이 명세·데이터·렌더 3중 정합.

- fixture 실측(`product_BCSPWHT.json`): `PRT_WHT`(화이트인쇄) 그룹 = `VIEW_YN=N, ESN_YN=Y` (PCS_DTL_CD=DFXXX, "화이트인쇄"). 즉 **숨김 필수(자동적용)**. (CUT_DFT 재단도 동일 VIEW_N/ESN_Y.)
- 어댑터: `mapPcsGroups` (red-adapter.ts:126) `visible: VIEW_YN==='Y'` → PRT_WHT.visible=**false**. 그룹은 optionGroups 에 **방출됨**(round-trip 보존) 단 visible=false.
- 렌더: `OptionPanel.tsx:44` `filter(g=>g.side===side && g.visible)` → PRT_WHT **미렌더**(정상). 주석 `OptionPanel.tsx:43` "visible=false 는 hidden essential(자동적용) → UI 미렌더"와 일치.
- 캡처 증거: `s1_whiteprint.png` — 용지 "인바이런먼트 크라프트 216g"(6종 자재셋), 화이트인쇄 선택 그룹 **없음**(자동적용이므로 정상). 코팅 그룹도 별색 자재 캐스케이드로 비노출.
- 계약 테스트 교차: `red-adapter-digital.test.ts:72-86` — `PCS_PRT_WHT` 그룹 존재(어댑터 방출), componentType=finish-button(colorHex 부재 → RULE-2), 단일면 유지, 신규 componentType 0. **pass.**
- **별색 5종 노트:** 본 fixture(BCSPWHT)의 별색은 화이트인쇄 1종이며 자동적용 형태. 명세상 별색 5종(화이트/클리어/핑크/금/은)은 dosu/inkType OptionValue 또는 PCS 그룹으로 흡수되며 전부 **데이터(값) 추가**이지 코드 변경 0 — 어느 형태든 위젯은 불투명 id echo. 5종 전수 별색 fixture 는 본 패스 미보유(아래 Minor S1-M1).

### 3. 단/양면 colorCount (4↔8) — **PASS** (fixture+라이브)

단면/양면 dosu 가 priceColorCount 4↔8 로 평면화되어 캐스케이드(가격요청 차원)로 흐름.

- fixture 실측: BCSPDFT dosu = `[(SID_S 단면 PRN_CLR_CNT=4), (SID_D 양면 PRN_CLR_CNT=8)]`. BCSPWHT/PRPOXXX 동일 4/8.
- 어댑터: red-adapter.ts:191-197 `priceColorCount: d.PRN_CLR_CNT` 평면화 — dosu↔bnc(별색수) 평면화. OptionValue 에 수치 슬롯으로 echo.
- 계약 테스트 교차: `red-adapter-digital.test.ts:65-70` — `SID_S.priceColorCount===4`, `SID_D.priceColorCount===8`. **pass.**
- 라이브: 단면/단면→양면 클릭 발화 성공(`bcspdft_click_danmyeon:true`, `bcspdft_click_yangmyeon:true`), JS 에러 0. 양면/단면 option-button 2개 렌더(`s1_namecard`=양면 선택, `s1_singleside`=단면 선택 — 선택상태가 보라테두리로 토글).
- **Red 동등 의미:** dosu→colorCount 평면화는 Red 가격요청에 `priceColorCount`(=PRN_CLR_CNT)를 보내는 것과 동일 차원. 위젯은 4/8 수치를 echo 만 하고 가격 영향은 BFF(INV-1). 단/양면 전환이 **색상수 차원을 바꾸는 페이로드 형태**가 Red 와 동일.
- 범위 노트: 가격 *수치* 변화는 비로그인 PRICE=0 이라 미검증(범위 외). **페이로드 차원(4↔8) 형태**만 검증 — 통과.

### 4. select-box custom dropdown (native select 금지) — **PASS** (라이브)

material(용지) select-box 가 native `<select>` 없이 custom dropdown(Radix Popover, Portal-in-shadow)으로 렌더.

| 관찰 | 실측 | 근거 |
|------|------|------|
| native `<select>` (위젯 전체) | **0** | grep `<select>`=0 (HuniSelect.tsx 주석 1건뿐) + 라이브 `sr.querySelectorAll('select')`=0 (BCSPDFT/PRPOXXX/PRBKYPR 전부) |
| `aria-haspopup="listbox"` 트리거 | 1(디지털)/2(책자) | 라이브 |
| 열림 시 `[role="listbox"]` in shadow | **1** | 라이브 BCSPDFT 용지 열기 |
| body-escape (popper in body) | **0** | `document.body` 직속 popper=0 → Portal-in-shadow |
| 옵션 렌더 | 5종 (아트지250g/300g/스노우지250g/300g/얼스팩226g) | 라이브 `[role=option]` |
| 스타일 적용 | bg 흰색, Noto Sans, 그림자+테두리 | 라이브 computed + `s1_poster_papers.png` |

- 코드: `HuniSelect.tsx:1` "native `<select>` 금지, Popover+커스텀 목록", `Popover.Portal container={container}`(43행)로 shadow mountPoint 주입, `role="listbox"`(47)/`role="option"`(57).
- 캡처 증거: `s1_poster_papers.png` — PRPOXXX 용지 드롭다운 **열린 상태**(아트지100g 선택 보라 + 120g/150g/180g/200g/250g 목록), 보라 테두리 박스+그림자, 하단 접지 그룹 위로 오버레이. native OS select 아님.
- DESIGN Critical Rule(RULE-1 native select 금지) 준수 — **라이브 definitive PASS.**

### 5. 회귀 (INV-3 — 위젯 코어 불변) — **PASS** (라이브) — [별도 섹션 아래]

상세는 §회귀 검사.

---

## 회귀 검사 (INV-3 위젯 코어 불변) — **PASS**

디지털인쇄 확대 후에도 S0 책자(PRBKYPR) fixture 가 **동일 코어로 그대로 렌더**됨을 라이브로 입증. 어댑터+데이터만 늘었고 store/cascade/shadow/dispatcher 불변.

### S0 PRBKYPR 라이브 재마운트 결과 (디지털 마운트 직후 동일 페이지)

| 항목 | 실측 | 책자 기대 |
|------|------|----------|
| `hasInnerLabel` | **true** | true (표지/내지 분리) |
| 카운터 입력 | **2** (수량 + 내지 장수) | 2 |
| listbox 트리거 | **2** (표지 용지 + 내지 용지) | 2 |
| 내지 그룹 렌더 | 내지 용지·내지 인쇄 도수·내지 장수 전부 | 전부 |
| 에디터 진입 | "표지 편집하기" 버튼(editor uploadType) | editor |
| 내지 업로드 | "내지 PDF 파일 업로드" | pdf |
| dosu 버튼 | 단면/양면(표지) + 양면(내지) | distinct |

- **단일면 vs 책자 분기 정합:** 동일 probe 가 BCSPDFT/PRPOXXX 는 `hasInnerLabel:false`·카운터1·listbox1 로, PRBKYPR 은 `hasInnerLabel:true`·카운터2·listbox2 로 렌더 — **하나의 코어가 데이터(hasInner)에 따라 단일면/책자를 모두 정확히 분기.** INV-3 핵심 증명.

### 격리·Portal·hook (INV-4) — 회귀 PASS

| 항목 | BCSPDFT | PRPOXXX | PRBKYPR | 근거 |
|------|---------|---------|---------|------|
| Shadow 격리(공격 CSS) | button bg=흰색, radius=0px, Noto Sans | 동일 | 동일 | 호스트 `button{background:red!important;border-radius:9999px;font:Times}` 주입에도 누수 0 |
| Portal-in-shadow | listbox shadow 내부, body-escape 0 | 동일 | 동일(2 select) | 라이브 |
| **"Invalid hook call" 등** | **0건** | **0건** | **0건** | console 필터 `hookCallErrors:[]` (3 마운트 전체) |
| page errors | **0건** | **0건** | **0건** | `pageErrors:[]` |

### 빌드/타입/테스트 (공통 게이트 §5.1) — PASS

- `npx tsc --noEmit` → **EXIT 0** (디스패처 exhaustive 포함).
- `npx vitest run` → **24/24 pass** (editor-bridge 8 / red-adapter 6 / **red-adapter-digital 7** / upload-flow 3).
- build 성공(오케스트레이터 통지).

---

## 불변식 검증 (INV-1~5)

| INV | 판정 | 근거 |
|-----|------|------|
| **INV-1 서버권위 가격** | **PASS** | 위젯 가격계산 0. dosu priceColorCount/sizeRule cutW/cutH 는 echo 슬롯, finalPrice/lines 는 어댑터 평면화(`mapPriceResponse`). 비로그인 PRICE=0 도 위젯 무영향(합계 0원 그대로 렌더). 가격모델(PriceTable3D) 위젯 부재. |
| **INV-2 계약 중립** | **PASS** (정량) | grep `price_gbn\|ORD_INFO\|[Ss]hopby` 위젯 src(adapters/red 제외) = **0건**. `PCS_CD\|MTRL_CD` 매치 2건은 전부 **계약 주석**(product.ts:42, constraints.ts:5-6 — "Red MTRL_CD" 설명 코멘트)이며 타입 구조·런타임 코드엔 Red 고유명 0. Red 필드명은 red-adapter.ts/red-types.ts 안에만. |
| **INV-3 위젯 코어 불변** | **PASS** (라이브) | S0 PRBKYPR 재마운트 전부 통과(위 회귀). 디지털 확대 = fixture 3종 + DATASET_COMPONENT_TYPE 변경 0(component-type-map.ts 그대로). store/cascade/shadow/dispatcher diff 0. |
| **INV-4 Shadow 격리+Portal** | **PASS** (라이브) | 공격 CSS 누수 0 (3 상품), listbox Portal shadow 내부·body-escape 0. |
| **INV-5 14 dispatcher 고정** | **PASS** (정량) | `ComponentType` union = 14 멤버(product.ts:8-22). `OptionControl.tsx:19` 단일 switch 가 14 case 전부(12 렌더 + summary/upload-cta=null), default 없음 → tsc exhaustive(EXIT 0)가 누락 강제. 팩토리/레지스트리 추상화 0(주석 명시·구조 확인). S1 신규 componentType 0. |

---

## 결함 목록 (심각도)

### S1-M1 [Minor] 별색 5종 전수 fixture 미보유 — *검증 깊이 한계 (결함 아님, 데이터 보강 권장)*
- 현황: BCSPWHT 별색은 **화이트인쇄 1종**(VIEW_N/ESN_Y 자동적용)만 fixture 보유. 명세 별색 5종(화이트/클리어/핑크/금/은)의 dosu OptionValue 또는 PCS 그룹 전수 렌더는 미검증.
- 영향: 위젯 무영향 추정(불투명 id echo, 신규 componentType 0). 단 5종 selectable/auto-apply 혼합 시 visible 분기·라벨 정합은 5종 fixture 로 1회 확인 권장.
- 위치: `04_build/fixtures/` (별색 5종 fixture 부재). 재현: 5종 별색 상품(예: SCO_GLD 금/SCO_SLV 은 그룹 포함 SKU) Red 캡처 후 BCSPWHT 와 동일 probe.
- 조치: S2 진입과 무관(비차단). live-capture 로 5종 별색 SKU 1건 보강 시 완결.

### (참고) 가격값 일치 — **검증 범위 외** (명시)
- S1 fixture 는 비로그인 캡처라 **PRICE=0**. 응답 *shape* 는 정확(`mapPriceResponse` → `{ok, finalPrice:number, vat:number, lines[], shipping}`; 디지털 lines[0].code='CUT_DFT' round-trip — digital test:112-120 pass). **가격 *수치* 일치는 INV-1(서버권위)상 위젯 무영향이므로 검증하지 않음.** shape/동작/렌더/캐스케이드/페이로드 형태만 판정.

---

## 라이브 vs 코드-온리 구분 (정직성)

| 검증 | 방식 |
|------|------|
| 단일면 render(내지 부재·카운터1·파일1) | **라이브** (3 상품 DOM 프로브) |
| select-box custom dropdown(listbox in shadow, body-escape 0, 5옵션) | **라이브** (BCSPDFT 용지 열기) |
| 격리(공격 CSS 누수 0)·hook 경고 0 | **라이브** (3 마운트) |
| S0 책자 회귀(내지 그룹·2 카운터·2 select·에디터) | **라이브** (PRBKYPR 재마운트) |
| 단/양면 클릭 발화 | **라이브** (JS 에러 0) |
| 별색 자동적용(VIEW_N/ESN_Y → 미렌더) | fixture + 코드 + 캡처 (s1_whiteprint) |
| dosu 4↔8 평면화 | fixture + digital test + 라이브 dosu 버튼 |
| INV-2 중립성·INV-5 exhaustive | **정량 grep + tsc EXIT 0** |
| 가격 *수치* 일치 | **검증 범위 외** (PRICE=0, INV-1) |
| Red 위젯 디지털 직접 조작 비교 | 부분 — Red 는 동일 digital_price 계약·동일 캐스케이드 패턴(우리 어댑터 입력원). 위젯 내부 깊이 조작 미수행 |

---

## 다음 stage(S2) 영향

- **S2 스티커 진입 무차단.** S1 이 INV-1~5 전부 유지·코어 0변경으로 통과 → S2(PriceTable3D 반칼 + FixedUnit 타투/스티커팩)도 "어댑터+데이터만" 가설 적용 가능. FixedUnit 은 BFF 계산만, 위젯 입력은 기존 counter(step).
- 선결: S2 진입 전 스티커 Red fixture 캡처(판수=size류 option-button, 소재 select-box) 필요(expansion-strategy §5.2 S2).
- 잔존: S1-M1(별색 5종 fixture) — S2 와 독립, 병행 보강 가능.

---

## 환경 메모
- 라이브 probe 는 `<huni-widget pdt="...">` 커스텀 엘리먼트로 productCode 오버라이드(index.html 기본은 PRBKYPR). 동일 페이지 순차 재마운트로 S1→S0 회귀를 한 컨텍스트에서 대조.
- 임시 probe 스크립트(`_s1probe.mjs`, `_s1select.mjs`)는 실행 후 삭제 완료. 재현은 `interact.mjs` 패턴 + 본 보고서 절차로 가능.
- Red(3001) 에디터 토큰 만료 23:21경 — 본 패스는 디지털 계약 동종성(어댑터 입력원)으로 검증, Red 위젯 가격 라이브 호출은 가격값 범위 외라 미수행.
