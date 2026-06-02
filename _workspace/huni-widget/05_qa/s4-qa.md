# S4 QA Report — Huni-Widget 아크릴(ACNTHAP) 비교 QA (NC-2 판정 + hashRequest 캐시키 핫픽스)

- 검증 도구: `tsc --noEmit` EXIT 0 / `vitest run` 54 passed / `vite build` 성공 + `npx tsx` 어댑터·해시 런타임 프로브 + grep 정량 게이트 + `git diff` 정량 diff
- 대상(우리): ACNTHAP(아크릴 명찰, 카테고리 09) — `mapProduct(product_ACNTHAP.json)` 어댑터 출력 + `createWidgetStore` 라이브 store 경로
- 레퍼런스(Red): 본 패스는 **Red 라이브 위젯(:3001) 미접속** — 세션 종료로 서버 down, 비로그인 PRICE=0 한계상 fixture·단위·라이브 store 프로브 기반 검증(S3 패스와 동일 방식). 라이브 PRICE 대조는 미검증으로 정직 표기(S4-M1).
- 검증 대상 변경: **① S4 ACNTHAP 흡수**(src 운영코드 0줄, test/red-adapter-acryl.test.ts 신규만) **② hashRequest 캐시키 핫픽스**(price.ts working-tree diff)
- 대표 SKU: **ACNTHAP**(vTmpl_price, 3중 가격합성 SizeMatrix2D+옵션단가+TieredDiscount — 전부 BFF)
- 게이트 현황: **tsc EXIT 0 / vitest 54 passed(S3까지 39 → S4 6 + 핫픽스 9 = 15 신규, 기존 39 무회귀) / vite build 성공(dist/widget.js 707kB)** — 실측 재확인 완료.

---

## 종합 판정: **GO**

S4 검증 항목 5개 전부 PASS(미검증 1항목은 비차단 한계 — 결함 아님). **명세 §0 판정("ACNTHAP = 위젯/어댑터 0줄 변경 흡수, NC-2 신규 componentType 없음")이 EXISTING 어댑터·store 출력으로 실증됨.** `git status`상 src/ 운영코드 신규 0줄(S4는 `test/red-adapter-acryl.test.ts` 신규 검증뿐, price.ts 변경은 별건 핫픽스). **hashRequest 캐시키 핫픽스가 S4 가격 검증을 정상화함을 입증**: 버그 시절 옵션 변경(부자재·규격·수량·자재·색상)이 동일 캐시키로 막혔던 cache-miss 재요청이 working-tree diff 제거 후 정상 발동(ACNTHAP 라이브 store + 타 상품 BNBNFBL real_price 표본 모두). 불변식 INV-1~5 전부 유지. **Blocker/Major 결함 0건.** Minor/관찰 3건(검증 깊이 한계 + 명세-코드 서술 불일치 1건 — 전부 비차단). **S5 진입 무차단.**

> **핵심 입증:** ① NC-2 경계 — `mapProduct` 런타임이 ACNTHAP(vTmpl_price, 0×0 sentinel 부재)를 GRP_SIZE=**option-button**으로, BNBNFBL(real_price, sentinel 보유)을 **dimension-matrix-input**으로 정확히 분기(어댑터 조건 `real_price && sentinel` 데이터 구동). ② 핫픽스 — `JSON.stringify(req, Object.keys(req).sort())`(replacer가 중첩키 누락) → 재귀 `stableSerialize`로 교체. price.ts working-tree diff 외 운영코드 무변경.

---

## 검증 항목별 결과

### 1. ACNTHAP echo (명세 §5.1) — **PASS** (어댑터 단위 + 라이브 store)

어댑터→ `PCS_WRK_MTR`(finish-button, NBPIN/NBMGN, visible+required) / GRP_SIZE = `option-button`(소·중 프리셋) / BON_PAP·LAS_DFT visible=false 미렌더 / selectedFinishes echo 전부 실측 확인.

| 경계면 | 기대 shape | 실제 shape (런타임) | 판정 |
|--------|-----------|--------------------|------|
| WRK_MTR → componentType | finish-button (colorHex 부재 RULE-2) | `finish-button` | PASS |
| WRK_MTR 값 id | [NBPIN, NBMGN] (불투명 PCS_DTL_CD) | `['NBPIN','NBMGN']` | PASS |
| WRK_MTR 라벨 | [옷핀 집게, 마그넷] | `['옷핀 집게','마그넷']`, `+`·`원` 미포함(델타 병기 없음 §1.3) | PASS |
| WRK_MTR visible/required/multiple | true/true/false | `true/true/false` | PASS |
| GRP_SIZE componentType | option-button (NC-1 아님) | `option-button`, `inputSpec=undefined` | PASS |
| GRP_SIZE 값 | [소 70X25(기본), 중 75X25] | `['소 70X25','중 75X25']`, sizeRules 70×25·75×25 | PASS |
| BON_PAP/LAS_DFT | 그룹 생성·visible=false·required=true·미렌더 | `visible=false`, 가시필터 `[GRP_SIZE,GRP_MTRL_COVER,GRP_DOSU_COVER,PCS_WRK_MTR,GRP_QUANTITY]`에서 제외 | PASS |
| buildPriceRequest.selectedFinishes echo | [{PCS_WRK_MTR, NBMGN}] | `[{groupId:'PCS_WRK_MTR',valueId:'NBMGN'}]` dims `{cutW:70,cutH:25,workW:72,workH:27}` | PASS |

- 근거: `red-adapter-acryl.test.ts` 6 tests passed + 어댑터 런타임 로그(`PCS_WRK_MTR: finish-button required=true visible=true values=옷핀 집게/마그넷`).
- **라이브 store echo**: `createWidgetStore({productCode:'ACNTHAP'})` 기본 진입 → `selectedFinishes`에 PCS_WRK_MTR=NBPIN echo, `selectOption('PCS_WRK_MTR','NBMGN')` → NBMGN echo (NC-1 라이브 프로브와 동일 방식, bff.price() 캡처).
- **CUT_MRG=2 정합**: ACNTHAP fixture `CUT_MRG=2.00` → workW=70+2=72, workH=25+2=27. NC-1(BNBNFBL=4mm)과 다르나 데이터 드리븐(어댑터 `base.cutMargin` 추출)으로 정상. 명세 §3 코드블록의 workW:72와 일치.

### 2. NC-1 미발동 경계 (명세 §5.2-6) — **PASS** (런타임 직접 대조)

ACNTHAP가 dimension-matrix-input을 생성하지 않고, S3(BNBNFBL)는 여전히 NC-1 발동 — 경계가 정확히 갈림을 한 런타임에서 직접 대조.

| SKU | priceSchemeKey | 0×0 sentinel | GRP_SIZE componentType | cutMargin | NC-1 |
|-----|----------------|--------------|------------------------|-----------|------|
| **ACNTHAP** | vTmpl_price | **false** | **option-button** | 2 | **미발동** |
| **BNBNFBL**(S3) | real_price | **true** | **dimension-matrix-input** | 4 | 발동 |

- 판정 로그: `경계 정확: true` (ACNTHAP=option-button && BNBNFBL=dimension-matrix-input).
- 어댑터 조건 `real_price && hasFreeInputSentinel`이 아크릴을 정확히 배제. ACNTHAP는 `inputSpec=undefined`(자유입력 슬롯/axis2 미생성) — 자유입력 칩 없음.
- `red-adapter-acryl.test.ts`의 사이즈 테스트가 `hasFreeInputSentinel===false`, `componentType !== 'dimension-matrix-input'` 단언으로 동일 확인.

### 3. 핫픽스 정상화 라이브 검증 (신규 중점) — **PASS** (라이브 store + 단위 + 타상품 표본)

캐시 ON 상태에서 옵션 변경이 cache miss(재요청)를 일으키고 동일 조합은 정당한 hit임을 라이브 store와 단위·타상품 표본으로 입증. **버그 시절 막혔던 동작이 정상화됨.**

| 케이스 | 기대 | 실제 | 근거 |
|--------|------|------|------|
| 캐시 ON(기본 30s TTL) + 부자재 NBPIN→NBMGN | price() 재호출(miss) | `captured.length > before` + 마지막 req에 NBMGN | `price-cache-key.test.ts` "캐시 ON…재호출(miss)" PASS |
| 동일 조합(GRP_SIZE 소 재선택) | 재호출 없음(hit) | `captured.length === afterSame` | 동 테스트 "동일 조합 재선택 → cache hit" PASS |
| 부자재 valueId만 다름(NBPIN vs NBMGN) | 다른 키 | not.toBe | 핫픽스 단위 PASS |
| dimensions cutW만 다름(70 vs 75) | 다른 키 | not.toBe | PASS |
| quantity만 다름(10 vs 20) | 다른 키 | not.toBe | PASS |
| materials만 다름 | 다른 키 | not.toBe | PASS |
| colorCounts만 다름(4 vs 8) | 다른 키 | not.toBe | PASS |
| 완전 동일 조합 | 동일 키 | toBe | PASS |
| 키 입력순서만 다르고 값 동일 | 동일 키(안정 직렬화) | toBe | PASS |

- **버그 원인 정확 제거(working-tree diff)**: `const stable = JSON.stringify(req, Object.keys(req).sort())` 삭제 → 재귀 `stableSerialize(req)`. 옛 방식은 replacer 배열이 **모든 중첩 레벨**에 적용돼 `dimensions/selectedFinishes/colorCounts/materials` 내부 키를 누락 → 옵션만 다른 두 요청이 동일 키 → cache hit으로 재요청 차단(전 상품 영향).
- **타 상품 보존 표본**(BNBNFBL real_price, 다축 dimensions 런타임 프로브): 동일조합 동일키(hit보존)=true, cutW/finish/material/colorCount 변경 모두 다른키(miss)=true. 샘플키가 `{"colorCounts":{"default":4},...,"dimensions":[{"cutH":900,"cutW...}` — 중첩 객체 내부 키까지 직렬화 육안 확인. 핫픽스가 ACNTHAP뿐 아니라 기존 가격 캐싱 동작을 의도대로 보존.

### 4. S0~S3 무회귀 (명세 §5.2-5) — **PASS** (게이트 전체 재현)

S4는 src 운영코드 0변경 + 핫픽스는 캐시키만 수정 → 전체 green 재현.

| 게이트 | 결과 | 비고 |
|--------|------|------|
| `tsc --noEmit` | **EXIT 0** | 디스패처 exhaustive 포함 |
| `vitest run` | **54 passed (9 files)** | S3까지 39 무회귀 + S4 acryl 6 + 핫픽스 cache-key 9 |
| `vite build` | **성공** | dist/widget.js 707.71kB / gzip 130.56kB |

- `git status --short`: src/ 운영코드 변경 = **price.ts(M, 핫픽스만)** 1개. S4 ACNTHAP 흡수는 `test/red-adapter-acryl.test.ts`(??, 신규 검증)뿐 — **위젯/어댑터 운영코드 0줄 추가**가 정량 입증(명세 §4 표 전 행 0/0 부합).
- 핫픽스 기존 가격 캐싱 동작 보존: 항목 3의 타상품(BNBNFBL) 표본 + 핫픽스 단위 9 tests 전부 green.

### 5. INV-1~5 불변식 — **PASS** (정량 grep + git diff)

| INV | 판정 | 근거 |
|-----|------|------|
| **INV-1 서버권위 가격** | **PASS** | grep: `src/widget/stores`+`components`에 가격 산술(`*unit`/`*quantity`/`.reduce(`/`finalPrice=`/`sum+=`) **0건**. ACNTHAP 3중 합성(SizeMatrix2D+옵션단가+TieredDiscount)은 전부 BFF. 위젯은 dimensions/selectedFinishes/quantity 수치 echo만. 비로그인 PRICE=0(실가 미확보 = 항목 한계). |
| **INV-2 계약 중립** | **PASS** | grep: `src/contract`+`src/widget`에 Red 고유명(vTmpl_price/real_price/PCS_CD/MTRL_CD/VIEW_YN/ESN_YN/ACNTHAP/NBPIN/NBMGN) **0건**(GRP_/PCS_ prefix 구조 비교 제외). priceSchemeKey는 불투명 echo. |
| **INV-3 코어 불변** | **PASS** | src 운영코드 신규 0줄(git status). S4는 store 분기조차 불요 — NC-1과 달리 dimsFromSelection/widget-store 무변경. ACNTHAP는 기존 컴포넌트로 렌더되는 또 하나의 상품. |
| **INV-4 Shadow 격리** | **PASS** | 변경 없음 — 영향 없음. |
| **INV-5 dispatcher 고정** | **PASS** | `ComponentType` union 15멤버 불변, dispatcher case 추가 0(NC-2 신규 case 없음). tsc EXIT 0 exhaustive. |

---

## 결함/관찰 목록 (심각도)

### S4-M1 [Minor] Red 라이브 위젯 직접 비교 미수행 — *검증 깊이 한계 (결함 아님 / 미검증)*
- 현황: 세션 종료로 Red(:3001) down + 비로그인 PRICE=0 → 본 패스는 fixture·단위·라이브 store 프로브 기반. ACNTHAP 3중 가격합성(SizeMatrix2D 매트릭스 + 부자재단가 + TieredDiscount 50%) 실가 변동은 **미확보**.
- 영향: 위젯 무관(INV-1 — 위젯은 cutW/cutH·selectedFinishes·quantity 수치 echo만, 합성은 BFF 권위). echo·구조·캐시 동작이 본 패스 검증 대상이며 전부 PASS. **실가 정합은 로그인 캡처 필요**(명세 §5.1-4·§5.3-9와 동일 한계).
- 재현: Red 토큰 갱신(`node extract-cookies.cjs`) + 로그인 상태 가격 캡처 → 규격 소→중 / 옷핀→마그넷 / 수량 tier 경계 변경 시 finalPrice 변동을 우리 echo와 대조.
- 조치: S5 진입과 무관(비차단).

### S4-O1 [관찰] hidden essential(BON_PAP/LAS_DFT)이 selectedFinishes에 echo — *명세 §2.3 서술과 코드 실동작 불일치 (INV 위반 아님)*
- 현황: 명세 §2.3은 "hidden 그룹은 사용자 선택 없으므로 selections 미포함 → finishesFromSelections에 안 들어감"으로 서술. 그러나 `defaultSelections`(widget-store.ts L109-118)는 **visible 필터 없이** 모든 values 보유 그룹의 첫 값을 선택하므로 PCS_BON_PAP=ACXXS, PCS_LAS_DFT=DFXXX도 기본 선택됨. 라이브 store 로그가 확인: `selectedFinishes=[{PCS_BON_PAP},{PCS_LAS_DFT},{PCS_WRK_MTR}]`.
- 영향: **INV 위반 아님 — 오히려 정합 안전.** 필수 가공(ESN_YN=Y)이 가격요청에 포함되어 BFF가 ESN_YN=Y를 서버측 자동 포함하지 않아도 단가 정합 보장. 위젯 산술 0(INV-1 유지). 명세 §2.3의 "BFF가 productCode만으로 필수 가공 적용" 가정이 불필요해지는 방향(더 안전).
- 위치: `src/widget/stores/widget-store.ts:109-118` defaultSelections / 명세 §2.3 L107-109.
- 조치: 비차단. **명세 §2.3 서술 정정 권장**(hw-architect): "hidden essential은 selections 미포함" → "defaultSelections가 visible 무관 기본 선택하여 selectedFinishes에 echo됨(필수 가공 BFF 전달, INV-1 안전)". test/red-adapter-acryl.test.ts L164-175가 이 실동작을 정직하게 단언·기록 중. 코드 수정 불요(현 동작이 더 안전).

### S4-M2 [Minor] 타 아크릴 SKU 자유입력 라우팅 미검증 — *검증 깊이 한계 (결함 아님 / 미검증)*
- 현황: 명세 §5.3-7 — 아크릴 스탠드/코롯토/키링 등이 가로×세로 자유입력을 가지면 NC-1 자동 발동해야 하나, ACNTHAP(명찰=프리셋만) 외 아크릴 SKU fixture 미보유로 미검증.
- 영향: ACNTHAP 판정 무관(명찰은 프리셋). 어댑터 조건이 데이터 구동이므로 자유입력 SKU는 자동으로 NC-1 라우팅(설계상). 실증은 SKU fixture 필요.
- 재현: 해당 SKU live-capture로 `price_gbn`·자유입력 sentinel 존재 확인 후 fixture 추가.
- 조치: 비차단. 후속 아크릴 확대 시 SKU 추가하며 자연 보강.

### (참고) skinInfo view_yn=N 시각 정합 — **본 stage 스코프 밖** (명세 §2.5/§7 OPEN)
- ACNTHAP는 도수/용지 섹션 숨김(skinInfo `dosuSelect.view_yn=N`/`paperSelect.view_yn=N`)이나 현 어댑터는 GRP_DOSU_COVER/GRP_MTRL_COVER를 visible로 노출(값 1개라 가격 무해). 위젯 코어 불변 원칙상 본 stage 미수정 — 후니 단계 보정. 비차단.

---

## 라이브 vs 코드-온리 구분 (정직성)

| 검증 | 방식 |
|------|------|
| ACNTHAP echo(부자재 finish-button·사이즈 option-button·숨김필수 visible=false·selectedFinishes) | **어댑터 단위**(red-adapter-acryl 6 tests) + **라이브 store**(createWidgetStore bff.price() 캡처) |
| NC-1 미발동 경계(ACNTHAP option-button vs BNBNFBL dimension-matrix) | **런타임 직접 대조**(mapProduct 양 SKU 1패스) + 단위 단언 |
| 핫픽스 정상화(옵션변경 miss / 동일조합 hit) | **라이브 store**(캐시 ON, selectOption→price() 재호출) + **단위**(hashRequest 9) + **타상품 표본**(BNBNFBL 런타임 프로브) |
| 핫픽스 버그원인 제거 | **git working-tree diff**(JSON.stringify replacer → stableSerialize 재귀) |
| S0~S3 무회귀 | **게이트 재현**(tsc EXIT 0 / vitest 54 passed / vite build) |
| INV-1 가격산술 0 · INV-2 중립성 | **정량 grep**(stores/components/contract 0건) |
| INV-3 코어 0변경 | **git status**(src 운영코드 신규 0줄, S4=테스트만) |
| 실가(SizeMatrix2D/TieredDiscount/부자재단가 합성 결과) 정합 | **미검증**(PRICE=0, Red 미접속 — S4-M1) |
| 타 아크릴 SKU 자유입력 라우팅 | **미검증**(SKU fixture 미보유 — S4-M2) |

---

## 핫픽스가 S4 가격 검증을 정상화함 (명시)

S4 가격 검증의 핵심(항목 3)은 "옵션 변경이 가격 재요청을 일으키는가"다. **hashRequest 캐시키 버그가 존재했다면 이 검증 자체가 불가능**했다 — 부자재 옷핀→마그넷, 규격 소→중, 수량 변경이 모두 동일 캐시키로 cache hit되어 store가 BFF에 재요청을 보내지 않았을 것이고, ACNTHAP echo가 첫 요청 이후 갱신되지 않아 항목 1·3의 라이브 store 검증이 위양성(false hit)으로 오염됐을 것이다. 핫픽스(replacer 배열 → 재귀 stableSerialize)가 중첩 키를 모두 직렬화하도록 정상화함으로써, S4의 옵션-변경→재요청 경로가 정당하게 동작하고 동일 조합만 hit하는 캐시 시맨틱이 회복됐다. 이는 ACNTHAP 단일 상품이 아니라 전 상품(BNBNFBL real_price 표본 포함)에 적용되는 정상화다.

---

## 다음 stage(S5) 영향

- **S5 진입 무차단.** S4가 INV-1~5 전부 유지 + **위젯/어댑터 0줄 변경으로 NC-2를 흡수**(NC-1의 store 분기조차 불요)하여 "정규화 계약 의존 + 어댑터+데이터 흡수" 가설을 가장 강하게 실증. 핫픽스로 캐시 시맨틱 정상화 완료.
- 잔존(전부 S5 독립, 병행 보강 가능): S4-M1(로그인 라이브 PRICE 실가 대조 — 3중 합성), S4-M2(타 아크릴 SKU 자유입력 라우팅 fixture), skinInfo view_yn 시각 정합(후니 단계), S3-M1/M2(real_price PRICE·cutMargin SKU 확대).
- **명세 정정 1건(hw-architect 회신 권장)**: 명세 §2.3 hidden essential echo 서술 ↔ 코드 실동작 불일치(S4-O1). 코드가 더 안전한 방향이므로 명세를 코드에 맞춰 정정. 코드 수정 불요.

---

## 환경 메모
- Red(:3001) 세션 종료로 down — 본 패스는 fixture(product_ACNTHAP.json)·단위 테스트·라이브 store 프로브(createWidgetStore + StubBffClient)로 검증. 라이브 PRICE 직접 대조는 S4-M1(비차단, 로그인 필요).
- 임시 프로브(`_s4probe.mts`, `_s4bound.mts`)는 실행 후 삭제 완료. 재현은 본 보고서의 프로브 스니펫 + `red-adapter-acryl.test.ts`/`price-cache-key.test.ts`로 가능.
- 검증 시점 게이트: tsc EXIT 0 / vitest 54 passed(9 files) / vite build 성공.
