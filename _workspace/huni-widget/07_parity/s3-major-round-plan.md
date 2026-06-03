# S3 MAJOR 라운드 — 의사결정용 상세 계획

> **작성:** hw-architect · 2026-06-03 (BLOCKER 라운드 GO 직후)
> **기준(불변):** 책임/로직/분기 재현 동등 (라인 답습 아님, React/Zustand 구현차 허용).
> **상태:** PLANNING ONLY — 코드 변경 없음. 본 문서는 사용자가 "어느 웨이브를 언제, 어떤 캡처 비용으로 진행할지" 결정하기 위한 근거.
> **입력:** parity-gap-map.md, parity-matrix-S2-product-coverage.md, blocker-fix-verification.md, D1~D4 매트릭스, 04_build/src 실측(red-adapter.ts 623L, cascade.ts 80L, price.ts 139L, widget-store.ts 365L, editor-bridge.ts 160L, contract/*).
> **fixture 실측 교차검증 완료** — 어느 MAJOR가 현 fixture로 검증 가능하고 어느 것이 신규 캡처를 강제하는지 데이터 shape까지 확인.

---

## 0. 한 줄 결론 (먼저)

MAJOR 11항목 중 **현 fixture로 즉시 구현·검증 가능한 것이 5건**(L-4 END_PAP color-chip, L-3의 멀티/4귀토글 부분, P4 VIEW_YN 동적토글+hidden-essential 자동선택, 에디터 3액션, L-D3-1 isReadyToOrder, L-D3-5 buildIframeSrc 분기). **신규 캡처를 강제하는 것은 4건**(L-3의 size→반경 ATTB, L-1 속성칩 attb 마감(BLOCKER 잔여), D-L2 의류 분기, L-12 ACC). **컨버전으로 미뤄야 안전한 것이 2그룹**(의류 30상품 C-3~C-6, ACC 부자재 — day-1 무증상이고 후니 판매 여부 미정).

→ **추천: Wave A(어댑터+기존fixture, day-1 발현 6항목)부터 캡처 0회로 착수.** 신규 캡처는 Wave A 종료 후 단 1회 배치(귀처리+면지 책자 1상품 = `PRBKYPR` 재캡처로 대부분 흡수 가능, 추가 1~2상품)로 묶어 트래픽가드 준수.

---

## 1. fixture 교차검증 결과 (캡처 의존성의 근거 — 핵심)

> S2가 "정확 상품수 산출 불가"로 남긴 빈칸을, 보유 fixture 15종의 **실제 데이터 shape**를 떠서 메웠다. 이게 캡처 비용 판단의 기반.

| MAJOR 관련 코드 | 보유 fixture | 데이터 실측 결과 | 현 fixture로 검증 가능? |
|----------------|--------------|-----------------|------------------------|
| **END_PAP** (L-4) | `product_PRBKYPR.json` | END_PAP 옵션 10색(CLYEL/CLMIN/CLWHT…) **존재**, 단 **hex 필드 없음**(`PCS_DTL_COD`만). hex는 Red 컴포넌트 상수맵(mod_07:2511)에 있음 → 어댑터 상수맵으로 주입 | **예** — 옵션 데이터 경로 실재, 어댑터가 hex만 채우면 됨. 캡처 불요 |
| **ROU_DFT 4귀** (L-3 멀티) | `product_BCSPDFT.json` | ROU_DFT 4엔트리(DFXLT/DFXRT/DFXLB/DFXRB = 좌상/우상/좌하/우하) **존재**. `WEB_PCS_DTL_GRP=ROU_DFT_DF` | **예** — 멀티선택+4귀 전체토글은 현 fixture로 검증 가능 |
| **ROU_DFT 반경 ATTB** (L-3 size연동) | (동일) | 4귀 엔트리에 **ATTB 없음, DIV_SEQ=0** — 즉 BCSPDFT는 반경 비연동(귀돌이만). `factor==='size'` 반경맵 상품은 **fixture에 없음** | **아니오** — size→반경 cascade는 반경연동 책자 신규 캡처 필요 |
| **VIEW_YN** (P4) | `product_PRBKYPR.json` | VIEW_YN:N 3건 + VIEW_YN:Y 17건 **공존** → hidden essential(VIEW_YN=N) 자동선택·동적 add/remove 경로 실재 | **예** — PRBKYPR로 P4 + L-D2-2 둘 다 검증 가능 |
| **RIN_DFT 링색 attb** (L-1 속성칩) | `product_HLCLWAL.json` | RIN_DFT가 **가격측 shape**(ATTB_CD/ATTB_NM만, 옵션 색칩 아님). 선택 가능한 링색 옵션 리스트 **부재** | **아니오** — BID_SIL/RIN_DFT 속성칩 attb는 해당 후가공 보유 상품 신규 캡처 필요(BLOCKER 잔여로 추적됨) |
| **COT_DFT/SCO_DFT** (BLOCKER, 완료) | 9/7 fixture 보유 | (BLOCKER 라운드 RESOLVED — 재합성 검증 완료) | (해당없음) |
| **clothes2025/apparel_info** (D-L2, C-3~6) | **0건** | 의류 fixture 전무. red-adapter에 apparel 경로 0 | **아니오** — 의류 1상품(CL*) 신규 캡처 필수 |
| **DIR_MTR / ACC** (L-12) | **0건** | 부자재 fixture 전무. ACC는 옵션레벨이라 어느 상품에 붙는지도 미상 | **아니오** — ACC 보유 상품 식별+캡처 필요 |

**해석:** MAJOR 중 가격·시각 발현이 가장 가까운 L-4·L-3(멀티)·P4는 **캡처 0회로 진행 가능**(가장 큰 발견). 캡처를 강제하는 건 (a) L-3 반경연동, (b) L-1 속성칩 마감, (c) 의류, (d) ACC 4건뿐.

---

## 2. MAJOR 항목별 의사결정 테이블

> 각 항목: 수정 복잡도(어댑터only/+store/+cascade/+신규leaf) · 정확 파일 · core 터치 여부 · 캡처 의존 · 상품도달(S2) · day-1 발현 여부 · 리스크.

### 2-A. 수정 복잡도 · 파일 · core 터치

| ID | 갭 | 복잡도 | 정확 파일 | core/contract 터치? | BLOCKER처럼 최소·정당? |
|----|----|--------|-----------|---------------------|----------------------|
| **L-4** | END_PAP color-chip hex | **어댑터only** | `red-adapter.ts`(hex 상수맵 + color-chip 라우팅) | **무** (ColorChip.colorHex 이미 존재) | 어댑터 데이터 주입만 — 가장 깨끗 |
| **L-3a** | ROU_DFT 멀티+4귀토글 | **+신규leaf** | `red-adapter.ts`(multiple:true) + 신규 `MultiCheckGroup.tsx`(체크박스+전체토글) + `widget-store`(배열선택 기존지원 WS:27) | contract **무**(multiple prod:59 기존, SelectionValue[] 기존) | 신규 leaf 1개 — D4가 정당화한 2개 중 하나 |
| **L-3b** | ROU_DFT size→반경 ATTB | **+cascade +캡처** | `red-adapter.ts`(roundingConfigMap 이식) + `cascade.ts`(size watch→ATTB 재계산) + L-1 attb 직렬화 | contract **무**(attb 슬롯 BLOCKER서 추가됨) | cascade 룰 1종 추가, 단 캡처 선행 필수 |
| **P4** | VIEW_YN 동적 add/remove + hidden-essential 자동선택 + 연동가격 | **+cascade** | `cascade.ts`(disable전용→add/remove 확장) + `widget-store.ts`(defaultSelections hidden essential, WS:109) + `contract/constraints.ts`(addRules 슬롯) | contract **소**(addRules 1슬롯 additive) | cascade 핵심 확장 — 회귀면 가장 넓음(주의) |
| **L-1 속성칩** | BID_SIL/RIN_DFT attb runtime population | **어댑터 +캡처** | `red-adapter.ts`(attbOptions 추출) — slot은 BLOCKER서 준비됨 | **무**(슬롯 기존) | BLOCKER 잔여 마감. 캡처 선행 필수 |
| **D-L2** | itemGroup echo (clothes 분기) | **어댑터only**(echo) / **+의류분기**(C-3~6) | `red-adapter.ts`(itemGroup 불투명 echo) + (의류는 별 분기) + `contract/product.ts`(itemGroup? 슬롯) | contract **소**(itemGroup? optional echo) | echo 자체는 최소. 의류 실분기는 큰 단위(Wave C) |
| **L-12** | ACC 부자재 인스턴스+캐스케이드 | **+신규leaf +store +캡처** | `red-adapter.ts`(accFilterConfigMap) + 신규 `AccPanel.tsx` + `widget-store`(acc-order 슬라이스) + `cascade.ts`(다단 종속) | contract **중**(부자재 모델 신규) | D4 정당화 2 신규leaf 중 둘째. 가장 큼 — 컨버전 |
| **C-1~C-6** | 컴포넌트 내부 캐스케이드 | **혼합** | C-1(=L-3b), C-2(cascade 폴백), C-3~C-6(의류 어댑터분기) | C-2 **무** / C-3~6 **소** | C-2만 day-1, 나머지 의류(Wave C) |
| **에디터 3액션** | page-count-changed / request-user-token / prod-var-changed | **핸들러 추가** | `editor-bridge.ts`(switch case 3 + 콜백) + `contract/editor.ts`(콜백 타입) | contract **소**(콜백 3 additive) | switch case 추가 — 격리됨, 리스크 낮음 |
| **onOptionChange** | 호스트 통지(COMMON/ACC, summary) | **+store** | `widget-store.ts`(selectOption시 onOptionChange 발화) + `contract`(콜백) | contract **소**(콜백 additive) | 발화 지점만 추가. 낮음 |
| **L-D3-1** | isReadyToOrder(서버 주문가능) | **어댑터 +store** | `editor-bridge.ts`(goto-cart서 호출) + `red-adapter.ts`(isReadyToOrder 매퍼) + `widget-store`(canOrder 합성) | **무** | BFF 엔드포인트 의존 — Red fixture로는 stub. 후니 배선시 실연결 |
| **L-D3-5** | buildIframeSrc EDIT/reform 분기 | **어댑터only** | `editor-bridge.ts`(buildIframeSrc cmd 분기) | **무** | URL 조립 분기만. 낮음 |

**core 터치 총평:** MAJOR 전체에서 contract 변경은 전부 **additive optional 슬롯**(itemGroup?/addRules/콜백 3종)으로, BLOCKER 라운드와 동일한 최소·additive 패턴 유지 가능. 신규 leaf 컨트롤은 D4가 사전 정당화한 **정확히 2개**(MultiCheckGroup, AccPanel)로 한정 — 그 외 신규 컨트롤 0.

### 2-B. 캡처 의존 · 상품도달 · 발현 · 리스크

| ID | 캡처 의존 | 필요 캡처 (productCode + 옵션스윕) | 상품도달(S2) | day-1 발현? | 리스크 |
|----|-----------|-----------------------------------|--------------|-------------|--------|
| **L-4** | **기존 fixture** | — (PRBKYPR 보유, hex는 어댑터상수) | 면지색칩 책자 ~수십(book2025 부분) | **발현**(PRBKYPR) | 낮음. ColorChip 렌더 검증된 컴포넌트 |
| **L-3a** | **기존 fixture** | — (BCSPDFT 4귀 보유) | 귀처리 상품(책자+일부굿즈) | **발현**(BCSPDFT) | 중. 신규 leaf → 시각재현(06) 재대조 필요 |
| **L-3b** | **신규 캡처** | 반경연동 책자 1종(`factor==='size'` 보유 — 후보: PR 책자 중 사이즈가변 라운딩, get_digital_product_info로 DIV_SEQ≠0 확인) | 반경연동 상품 소수 | 무증상(반경연동 fixture 없음) | 중. cascade+캡처. 미확보 시 slot-only 유지 가능 |
| **P4** | **기존 fixture** | — (PRBKYPR VIEW_YN:N 3건 보유) | 동적옵션 상품 광역(미상, 잠재 전반) | **부분발현**(PRBKYPR hidden essential) | **높음** — cascade 핵심 로직 변경, 전 상품 회귀면 |
| **L-1 속성칩** | **신규 캡처** | BID_SIL/RIN_DFT 속성칩 보유 상품(후보: 링제본 HL*·실링 후가공 명함) | 속성칩 후가공 보유분 | 무증상(fixture 부재) | 낮음(슬롯 준비됨, 데이터만 채움) |
| **D-L2 echo** | **기존 fixture** | — (모든 fixture에 itemGroup 메타 echo 가능) | 전 상품 분기정확성 | 잠재(isBook 휴리스틱 대체중) | 낮음(불투명 echo) |
| **D-L2 의류분기** | **신규 캡처** | 의류 1종(`clothes2025` — CL 카테고리, 예 티셔츠/앞치마) | **의류 30 전체** | **무증상(전 미지원)** | 높음(신규 어댑터 경로) — Wave C |
| **L-12 ACC** | **신규 캡처** | ACC 부자재 보유 상품(식별 선행 — 어느 상품이 부자재 옵션 쓰는지 미상) | 미상(옵션레벨) | 무증상 | 높음 — Wave C/컨버전 |
| **C-2 폴백** | 기존 fixture | — (disable 보유 fixture 다수) | disable 보유 상품 | 잠재(현 빈선택) | 중(required PCS면 가격함의) |
| **에디터 3액션** | 기존(라이브) | — (live-capture로 에디터 액션 관찰, 신규 product 캡처 불요) | 에디터 보유 상품(책자+편집) | 부분(에디터 가격연동) | 낮음(격리) |
| **onOptionChange** | 불요 | — | 전 상품(호스트 통지) | 발현(호스트 통합시) | 낮음 |
| **L-D3-1** | BFF 의존 | — (Red는 stub, 후니 배선시 실연결) | 에디터 주문 상품 | 부분 | 중(서버계약 미정) |
| **L-D3-5** | 불요 | — (URL 조립) | 재편집 상품 | 무증상(재편집 미사용) | 낮음 |

---

## 3. 스테이지 웨이브 계획

> 그룹핑 원칙: ① **캡처 0회 + day-1 발현 + core 무/소터치**를 Wave A로 묶어 즉시 가치·낮은 리스크 선확보. ② **신규 캡처 강제** 항목을 Wave B로 묶어 캡처 1배치로 트래픽가드 내 처리. ③ **컨버전-only(의류/ACC, day-1 무증상, 후니 판매 미정)**를 Wave C로 분리해 지금 안 함.

### Wave A — 어댑터/cascade + 기존 fixture + day-1 발현 (캡처 0회)

**포함:** L-4(END_PAP hex), L-3a(ROU 멀티+4귀토글), P4(VIEW_YN 동적+hidden-essential), D-L2 echo(itemGroup 불투명), 에디터 3액션, L-D3-1(isReadyToOrder, BFF stub), L-D3-5(buildIframeSrc 분기), onOptionChange 통지, C-2(disable 폴백).

**왜 묶나:** 전부 보유 fixture(PRBKYPR/BCSPDFT 등)로 검증 가능하고, contract 변경이 additive 슬롯에 그치며, day-1 또는 호스트통합 시 즉시 발현. 신규 leaf는 L-3a의 MultiCheckGroup 1개뿐(D4 사전정당).

**고치는 것:** 색칩 면지 정상 렌더·선택의미 운반, 귀처리 멀티선택, 동적 옵션 토글+필수후가공 자동적재, itemGroup 분기근거 확보, 에디터 가격연동 3경로, 서버 주문가능 게이트 골격, 재편집 진입, 호스트 옵션변경 통지.

**필요 캡처:** **없음.** (단, 에디터 3액션은 live-capture로 에디터 런타임 액션 관찰 1회 권장 — 신규 product 캡처 아님, 기존 widget_monitor 세션으로 page-count-changed/request-user-token/prod-var-changed 메시지 shape 확인.)

**검증:** tsc 0 / vitest(현 94 → +회귀가드) / build OK + 시각재현(06) 재대조(L-3a 신규 leaf, L-4 color-chip). 구조 무변경 git 증명은 신규 leaf 추가분 제외하고 유지.

**권장 순서(근거):**
1. **L-4 (어댑터only, 최저리스크)** — 데이터 주입만, 컴포넌트 무변경. 빠른 GREEN으로 베이스 다짐.
2. **D-L2 echo + onOptionChange + 에디터 3액션 + L-D3-5** (격리된 additive) — 서로 독립, 병렬 가능. cascade 안 건드림.
3. **C-2 disable 폴백** (cascade 소변경) — P4 전에 폴백부터(작은 cascade 변경으로 워밍업).
4. **L-3a (신규 leaf)** — MultiCheckGroup 도입 + 시각재현 재대조.
5. **P4 (cascade 핵심확장, 최고리스크) 맨 마지막** — 동적 add/remove는 회귀면이 가장 넓으니 다른 항목 안정화 후 착수. hidden-essential 자동선택(L-D2-2) 동반.

→ **리스크 오름차순 = 신뢰 누적 순서.** BLOCKER 라운드와 동일 철학(작은 additive 먼저, 핵심 cascade 마지막).

### Wave B — 신규 캡처 강제 (캡처 1배치)

**포함:** L-3b(size→반경 ATTB, =C-1), L-1 속성칩 마감(BID_SIL/RIN_DFT attb runtime).

**왜 묶나:** 둘 다 "해당 후가공 보유 상품 데이터 부재"가 공통 차단 — 캡처로만 해소. 묶어서 1배치 캡처.

**필요 캡처(통합 리스트):**
- **C-cap-1:** 반경연동 책자 1종 — `get_digital_product_info`로 `roundingConfigMap factor==='size'`(ROU_DFT DIV_SEQ≠0) 확인되는 PR 책자. PRBKYPR가 해당하면 **재캡처만으로 흡수**(추가 0). 아니면 PR 책자 1종 추가.
- **C-cap-2:** 속성칩 후가공(BID_SIL 또는 링색 RIN_DFT 옵션리스트) 보유 상품 1종 — 링제본/실링 후가공 명함 후보. attb 옵션 스윕 1회.

**옵션 스윕:** 반경상품=사이즈 2~3종 변경하며 반경 ATTB 변화 캡처 / 속성칩=속성 전값 1회씩.

**검증:** 캡처 fixture로 L-3b round-trip(size 변경→반경 ATTB 자동전환→PCS_INFO attb 일치), L-1 속성칩 attb echo가 캡처값과 일치(타우톨로지 아님).

**권장 순서:** Wave A 완료·GO 후. **트래픽가드: 총 1~2 상품 × get_digital_product_info(저비용 GET), 200req/20MB 한참 이내.** server.js 토큰/쿠키 fresh 재기동(F6 정합) 후 가격 캡처.

### Wave C — 컨버전-only (의류 30 + ACC, 지금 보류 권장)

**포함:** D-L2 의류분기, C-3/C-4/C-5/C-6, L-11(멀티사이즈수량), 팬톤 color-chip, L-12 ACC 부자재.

**왜 보류:** ① day-1 **무증상**(어댑터 경로 0, fixture 0 — 현 위젯이 의류/ACC를 아예 렌더 안 함). ② **후니가 의류/부자재를 day-1 판매하는지 미정** — 안 팔면 신규 어댑터 분기+의류 컴포넌트 다수가 사장. ③ S2가 "의류 30이 단일 최대 사각이나 day-1 비차단" 명시. ④ 게이트가 D-L2 echo(Wave A에서 선행) — itemGroup 분기 토대가 먼저 있어야 의류 실분기가 의미.

**선행 조건(컨버전 단계서):** 후니 옵션마스터 수령 → 의류/부자재 판매 확정 → 의류 1종+ACC보유 1종 캡처 → 어댑터 의류분기+AccPanel(D4 정당 신규leaf 2번째) 구현.

→ **지금 하지 않는다.** 단 Wave A의 itemGroup echo로 "의류가 들어오면 분기할 자리"는 마련.

---

## 4. 통합 캡처 비용 (사용자 요구 — 선제 명시)

| 웨이브 | 신규 캡처 횟수 | 대상 productCode | 비용 |
|--------|---------------|------------------|------|
| **Wave A** | **0** (product 캡처) + 에디터 액션 관찰 1회(기존 세션) | — | 트래픽 0 |
| **Wave B** | **1~2 상품** | 반경연동 책자(PRBKYPR 재캡처 시 0추가) + 속성칩 후가공 1종 | get_digital_product_info ×1~2, 가격스윕 소량 — 200req/20MB 한참 이내 |
| **Wave C** | (보류) | 의류 1 + ACC 1 (컨버전 단계) | 컨버전 시 ×2 |

**총 신규 캡처(지금 진행분 A+B): 최소 0, 최대 2 상품.** Wave A는 캡처 0으로 MAJOR 6항목 처리 가능이 핵심.

---

## 5. 추천 (단일 최선 경로) + 대안

### ★ 추천: Wave A 먼저 (캡처 0회 착수)

**근거:**
- **캡처 0으로 MAJOR 다수 해소** — L-4/L-3a/P4/에디터/echo가 보유 fixture로 검증된다는 게 본 분석의 최대 발견. 라이브 캡처 비용·세션리스크(토큰/쿠키 fresh 재기동 등) 없이 즉시 가치.
- **BLOCKER 라운드 검증 철학 그대로 이식** — additive 슬롯·신규leaf 최소(1개)·리스크 오름차순. blocker-fix-verification이 입증한 "core 최소터치" 패턴 연속.
- **day-1 발현 우선** — 현 fixture가 실제로 타는 경로(면지색칩/귀처리/VIEW_YN)부터 닫아 실 BFF 배선 시 정확성 확보.
- **Wave B를 1배치로 미뤄 캡처 효율** — 반경+속성칩을 묶어 캡처 왕복 1회. Wave A 안정화 후라 캡처 결과를 안정된 토대에 얹음.

**다음 단계(구체):** hw-builder에게 Wave A 착수 지시 — **순서 L-4 → (echo/onOptionChange/에디터3/L-D3-5 병렬) → C-2 → L-3a → P4**. 신규 leaf는 MultiCheckGroup 1개만. 완료 후 hw-qa BLOCKER-스타일 독립 재검증 → GO 시 Wave B 캡처.

### 대안: P4(동적 cascade) 선분리 — "캡처 0 중에서도 가장 무거운 것 먼저"

P4는 cascade 핵심이라 후속 모든 항목과 상호작용. 이를 **먼저** 처리하면 이후 L-3a/L-4가 안정된 cascade 위에 얹힌다는 논리. **단 비추천** — P4 회귀면이 가장 넓어, 실패 시 라운드 전체 지연. BLOCKER 철학(작은 것 먼저 신뢰 누적)에 반함. 사용자가 "동적옵션이 가장 시급"하다고 판단하면만 채택.

---

## 6. 사용자가 저울질할 가장 큰 결정점 (단 하나)

**"Wave C(의류 30 + ACC)를 지금 할 것인가, 후니 컨버전까지 미룰 것인가."**

- **미루면(추천):** day-1 무증상이라 비차단. 하지만 의류 30은 **단일 최대 사각(universe 6.3%)** — 후니가 의류를 판다면 컨버전 때 신규 어댑터분기+의류컴포넌트 다수가 한꺼번에 발생(부채 이연).
- **지금 하면:** 의류 1종 캡처+어댑터 의류분기를 미리 구축 → 컨버전 리스크 선제 제거. 하지만 후니가 의류 미판매면 **전부 사장**(과투자).

→ **결정에 필요한 단 하나의 정보: "후니가 day-1에 의류/부자재를 파는가."** 이 답에 따라 Wave C가 now/defer로 갈림. 다른 모든 MAJOR(Wave A/B)는 이 답과 무관하게 진행 가능.

**부차 결정점:** P4 동적 cascade의 회귀 리스크 수용 범위 — Wave A 맨 끝(추천) vs 선분리(대안). cascade.ts(80L)가 현재 disable전용 단일책임이라, add/remove 확장은 가장 큰 단일 구조변경.
