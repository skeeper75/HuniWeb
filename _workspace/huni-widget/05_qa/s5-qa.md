# S5 QA Report — Huni-Widget 굿즈/파우치(GSPUFBC·GSTGMIC) 비교 QA (NC-3 판정 + printCount 계약 + echo 지점 이탈 판정)

- 검증 도구: `tsc --noEmit` EXIT 0 / `vitest run` 65 passed (10 files) / `vite build` 성공(dist/widget.js 715.32kB / gzip 131.85kB) + 정량 grep(INV-2) + `git diff --stat`(INV-3) + fixture↔캡처 shape diff
- 대상(우리): **GSPUFBC**(노트북-태블릿 파우치, tmpl_price 룩업 평탄단가) + **GSTGMIC**(마이크 네임택, tiered_price) — `mapProduct`/`serializeRedPriceRequest` 어댑터 출력 + `createWidgetStore` 라이브 store 경로
- 레퍼런스(Red): GSPUFBC는 **로그인 라이브 캡처 보유**(`s5_pouch_GSPUFBC.json`, customerCode 22025916, PRICE=2,850,000 실가). 비로그인 한계 없는 첫 S5 가격 fixture. GSTGMIC는 별도 price fixture 부재(후속, 비차단).
- 검증 대상 변경: **① S5 NC-3 흡수**(위젯 코어 0줄) **② printCount? optional 계약 1필드** **③ 어댑터 직렬화(ORD_CNT/PRN_CNT 분리) + quote 가드** **④ GSPUFBC fixture 2종 신규**
- 게이트 현황: **tsc EXIT 0 / vitest 65 passed(S4까지 54 → S5 신규 11 = 65, 기존 54 무회귀) / vite build 성공** — 실측 재확인 완료.

---

## 종합 판정: **GO**

S5 검증 항목 8개 전부 PASS(미검증 항목은 비차단 한계 — 결함 아님). **명세 §0 판정("NC-3 = 신규 componentType 없음, 위젯 코어·dispatcher·계약 0 변경으로 렌더")이 EXISTING 어댑터·store 출력으로 실증됨.** `git diff --stat -- src/widget/` = **0줄**(INV-3 정량 입증). 변경은 contract(printCount? 1필드)·adapters(red-types/red-adapter/fixture-source)·test·fixtures에만 국한. printCount는 중립 도메인명(Red PRN_CNT 아님)으로 위젯 코어 0건. tmpl/tiered_price 둘 다 위젯엔 불투명. **Blocker/Major 결함 0건.** 잔존은 전부 후속 라이브 보강(S5-M1~M6, 비차단).

### [핵심] echo 지점 이탈 판정 = **GO (의미·계약 동일, 회귀 위험 없음, 명세 의도에 더 부합)**

명세 §4.1 #2는 `buildPriceRequest`(=`src/widget/stores/price.ts`)에 `printCount: <selection>` **+1줄**을 계획했다. hw-builder는 이 1줄을 **buildPriceRequest에 넣지 않고**, 어댑터 직렬화(`serializeRedPriceRequest`)의 `PRN_CNT: req.printCount ?? 1`로 흡수했다(이유: buildPriceRequest가 `src/widget/stores/`에 위치 = 위젯 코어 → INV-3 0줄과 충돌). **이 이탈은 정당하다:**

| 검증축 | 명세 계획(buildPriceRequest +1줄) | hw-builder 구현(어댑터 흡수) | 판정 |
|--------|-----------------------------------|------------------------------|------|
| **의미 동일성** | 위젯이 printCount selection을 계약 필드에 echo | 현 stage UI에 printCount 컨트롤 미노출(캡처상 PRN_CNT는 select지만 위젯 옵션그룹 미매핑) → buildPriceRequest가 채울 selection 소스가 **아직 없음**. 어댑터가 `req.printCount ?? 1` 처리 | **명세 계획이 오히려 미성립** — 채울 selection이 없는데 1줄 추가는 죽은 코드. 어댑터 흡수가 정확 |
| **계약 동일성** | `printCount?: number` optional 계약 | 동일 계약(price.ts:29). buildPriceRequest는 미설정 → undefined, 어댑터가 ?? 1 | 계약 정의 100% 동일. 직렬화 분리 ORD_CNT(quantity)↔PRN_CNT(printCount ?? 1) 정확 |
| **회귀 위험** | store 분기 추가 = INV-3 위반(위젯 코어 +1줄) | store 0줄 → INV-3 완전 충족 | **어댑터 흡수가 회귀 위험 0** (NC-1의 store 분기보다도 약함, S4 완전 0과 동급) |
| **미래 확장성** | — | printCount selection 추가 시 buildPriceRequest에 `printCount: selectedId(...)` 1줄만 추가하면 자동 직렬화. 계약·어댑터 불변 | 후니 PRN_CNT 옵션 노출 시 위젯 코어 최소 변경 경로 보존 |

**결론(GO):** echo 지점이 buildPriceRequest→serializeRedPriceRequest로 이동했으나 ① 계약 정의 동일 ② 직렬화 의미(quantity↔ORD_CNT / printCount↔PRN_CNT) 정확 ③ 현 stage에 printCount UI selection이 없으므로 명세의 buildPriceRequest +1줄은 채울 값이 없는 죽은 코드였을 것 ④ 어댑터 흡수로 INV-3(코어 0줄)을 명세 §0 의도("코어 0 실증")에 **더 강하게** 부합시킴. **의미 손실/회귀 위험 없음 → GO.** (명세 §4.1 #2 표는 차기 갱신 시 "buildPriceRequest +1줄(printCount selection 노출 시)" 조건부로 정정 권장 — 현 stage 미노출이라 0줄이 정답. S5-O1)

> test/red-adapter-goods-pouch.test.ts:104가 이 동작을 정직하게 단언: `expect(req.printCount).toBeUndefined()`(buildPriceRequest 미설정) + L108-109 `ORD_CNT=100 / PRN_CNT=1`(어댑터 ?? 1) + L114-116 `printCount:6 → PRN_CNT=6`(명시 전달 시 어댑터가 분리 직렬화).

---

## 검증 항목별 결과

### 1. echo 지점 이탈 GO/재작업 — **PASS (GO)** — 위 [핵심] 판정 참조

직렬화 정확성 런타임 입증(vitest):
- printCount 미전달: `serialize: ORD_CNT=100 PRN_CNT=1(미전달)` — quantity는 ORD_CNT, printCount 부재→PRN_CNT=1 하위호환.
- printCount=6 명시: `PRN_CNT=6`, ORD_CNT=100 불변 — 두 필드 독립 분리 직렬화 확인.
- 근거: `red-adapter.ts:358-359`(`ORD_CNT: req.quantity` / `PRN_CNT: req.printCount ?? 1`).

### 2. INV-3 코어 0줄 재현 — **PASS** (git diff --stat 정량)

```
git diff --stat -- src/widget/   →   (empty, 0 lines)
git status --short (src 한정)     →   M src/adapters/red/fixture-source.ts
                                       M src/adapters/red/red-adapter.ts
                                       M src/adapters/red/red-types.ts
                                       M src/contract/price.ts
                                      ?? test/red-adapter-goods-pouch.test.ts
                                      ?? fixtures/product_GSPUFBC.json
                                      ?? fixtures/price_GSPUFBC_sample.json
```
- **src/widget/ 변경 0줄** 확정. store/cascade/shadow/dispatcher/price-seam/editor-bridge 무변경. 변경이 **계약(optional 1필드)·어댑터·데이터·테스트에만** 국한됨 재확인. S4(완전 0)와 동급 — NC-1의 store 분기조차 불요.

### 3. INV-2 계약 중립 — **PASS** (정량 grep)

| 대상 | 결과 |
|------|------|
| `src/widget`+`src/contract`에서 PRN_CNT/ORD_CNT/price_gbn/ORD_INFO/PCS_COD/tmpl_price/tiered_price/PRN_CLR_CNT를 **코드 식별자/데이터 키**로 | **0건** |
| 매칭된 라인 전부 | **주석 언급만**(price.ts:25 `// ...ORD_CNT 로 직렬화`, 26-28 설명, constraints.ts:5/product.ts:43 `(Red MTRL_CD)`) — 과제 제약 "주석 언급 허용, 코드 종속만 위반"에 부합 |
| `printCount` 사용처 | contract/price.ts:29(계약 정의), red-types.ts:156(Red 매핑 주석), red-adapter.ts:359·378(어댑터 직렬화/가드) — **위젯 코어 0건** |
- Red 고유명(PRN_CNT/ORD_CNT/price_gbn/ORD_INFO/PCS_COD/tmpl_price/tiered_price)은 red-types.ts + red-adapter.ts 안에만 존재(설계 경계 유지). priceSchemeKey는 불투명 echo.

### 4. 회귀 0 — **PASS** (게이트 전체 재현)

| 게이트 | 결과 | 비고 |
|--------|------|------|
| `tsc --noEmit` | **EXIT 0** | 디스패처 exhaustive 포함, printCount? optional 타입 정합 |
| `vitest run` | **65 passed (10 files)** | 기존 54 무회귀(PRBKYPR S0·디지털 S1·스티커 S2·BNBNFBL/BNPTPET S3 NC-1·ACNTHAP S4) + S5 신규 11 green |
| `vite build` | **성공** | dist/widget.js 715.32kB(S4 707kB→715kB, +8kB = GSPUFBC fixture 2종 번들 포함) / gzip 131.85kB |
- S5 신규 11 테스트 분포: 파우치 흡수 3 + 어댑터 직렬화 2 + 가드 3 + 굿즈 흡수 1 + 라이브 런타임 1 + price fixture 평면화 1 = 11. printCount optional → 이전 stage fixture 동일 출력(회귀 0).

### 5. 가드 동작 — **PASS** (단위 + 라이브)

| 케이스 | 기대 | 실제 | 근거 |
|--------|------|------|------|
| quantity=0 → quote() | `{ok:false, finalPrice:0, lines:[]}` (침묵 0 아님) | `ok=false / finalPrice=0 / lines=[]` | test L141-150 PASS |
| printCount=0 명시 → quote() | `{ok:false, finalPrice:0}` (PRN_CNT 가드) | `ok=false / finalPrice=0` | test L152-160 PASS |
| quantity≥1(printCount 미전달=1) → 가드 통과 | PRICE>0 | `ok=true / finalPrice=2850000 / vat=285000` | test L162-171 PASS |
- 가드 구현: `isPriceRequestQuotable`(red-adapter.ts:377-379) = `(req.quantity ?? 0) >= 1 && (req.printCount ?? 1) >= 1` → `RedPriceAdapter.quote()`(L442-446)에서 위반 시 `UNQUOTABLE_BREAKDOWN`(L381-387) 명시 반환. **Red 침묵 PRICE=0 결함(캡처 incompleteReqBody) 재현 금지** 충족.

### 6. NC-1 미오염 — **PASS** (런타임 직접 대조)

| SKU | priceSchemeKey | NO_STD_ABL_YN | 0×0 sentinel | GRP_SIZE componentType | nonStandardAllowed | NC-1 |
|-----|----------------|---------------|--------------|------------------------|--------------------|------|
| **GSPUFBC** | tmpl_price | N | **false** | **option-button** | **false** | **미발동** |
| **GSTGMIC** | tiered_price | N | **false** | **option-button** | false | **미발동** |
| BNBNFBL(S3 대조) | real_price | — | true | dimension-matrix-input | — | 발동 |
- 어댑터 조건 `real_price && hasFreeInputSentinel`(red-adapter.ts:161-164)이 두 SKU 모두 정확 배제(둘 다 real_price 아님 + sentinel 부재). GSPUFBC `inputSpec=undefined`(자유입력 슬롯 미생성, test L68). 규격 5종/4종 전부 option-button. `nonStandardAllowed=false`(test L74) → "직접 입력하기" 비활성 정책 근거.
- 런타임 로그: `GSPUFBC GRP_SIZE: option-button values=5 ... nonStd=false`, `GSTGMIC GRP_SIZE option-button`.

### 7. fixture 근거성 — **PASS** (fixture↔캡처 shape diff)

| 항목 | fixture (product_GSPUFBC.json) | 캡처 (s5_pouch_GSPUFBC.json) | 판정 |
|------|-------------------------------|------------------------------|------|
| 규격 5종 재단치수 | 230×288 / 330×250 / 250×338 / 365×270 / 410×284 | sizePriceTable 동일 5종 | PASS |
| 작업사이즈 = 재단+20mm | CUT_MRG=20.00, 11in WRK 250×308(=230+20/288+20) | "작업=재단+각변 20mm" | PASS |
| 가격 평탄단가 | price fixture 2,850,000 | completeReqBody 11in세로 ORD_CNT=100 PRN_CNT=1 → 2,850,000 | PASS |
| VAT | 285,000 | PRICE_VAT 285,000 | PASS |
| 워터폴 | PRICE_MALL==PRICE==ORG_PRICE → finalPrice=ORG_PRICE | result_sum 3값 동일 2,850,000 | PASS |
| NO_STD_ABL_YN | N | 임의치수 PRICE=0(폐쇄 enum) | PASS |
- `mapPriceResponse(price_GSPUFBC_sample) → finalPrice=2,850,000 / vat=285,000`(test L213-218) 어댑터 평면화도 캡처 실가와 일치. **로그인 실가 기반 첫 S5 fixture로 PRICE>0 정합 확인됨**(S3/S4 비로그인 PRICE=0 한계 일부 극복).

### 8. GSTGMIC fallback 주의 — **PASS (비차단 확인)**

- GSTGMIC는 별도 price fixture 부재 → `fetchPrice`에서 `GSPU`/`ST`/`BN`/`DIGITAL_PRINT_PREFIX` 어디에도 미해당 → **책자 fixture fallback**(quantity<120 → priceQ30). 이는 **기존 동작**(S5 신규 회귀 아님).
- **검증 대상 = product 매핑(NC-3 판정)만**: GSTGMIC `mapProduct` 출력이 전 그룹 기존 15 componentType 안(option-button/select-box/finish-button/counter-input), tiered_price echo, **color/image-chip 그룹 0개**(chipGroups=0, test L181-182) — NC-3 신규 불요 실증. PCS 전부 VIEW_YN=N → finish-button hidden(미렌더).
- **가격 라이브 비교는 후속**(S5-M1 TieredDiscount 본진 미확인과 함께) — **차단 사유 아님 확인.** GSTGMIC 실측은 평탄 6,000원(tiered지만 캡처 SKU에선 곡선 0), TieredDiscount 곡선은 말랑/문구 SKU 후속 캡처 임계경로.

---

## 결함/관찰 목록 (심각도)

### S5-O1 [관찰] echo 지점 명세-구현 불일치 — *명세 §4.1 #2 서술 정정 권장 (구현이 더 정확)*
- 현황: 명세 §4.1 #2/§6는 "buildPriceRequest에 printCount echo 1줄 추가"로 서술. 구현은 그 1줄을 어댑터 `serializeRedPriceRequest`로 흡수(buildPriceRequest 0줄). 이유: buildPriceRequest는 위젯 코어(`src/widget/stores/`) → INV-3 0줄과 충돌 + 현 stage에 printCount UI selection 미노출(채울 값 없음).
- 영향: **결함 아님 — 구현이 명세 §0 의도(코어 0 실증)에 더 부합.** 계약 정의·직렬화 의미 동일, 회귀 위험 0(위 [핵심] 판정).
- 위치: `src/widget/stores/price.ts:75-88`(buildPriceRequest, printCount 미설정) / `src/adapters/red/red-adapter.ts:359`(어댑터 흡수) / 명세 §4.1 #2.
- 조치: 비차단. **명세 §4.1 #2 정정 권장**(hw-architect): "buildPriceRequest +1줄" → "printCount UI selection 노출 시에만 buildPriceRequest +1줄; 현 stage 미노출이라 0줄(어댑터가 `?? 1` 흡수). INV-3 코어 0 유지." 코드 수정 불요.

### S5-M1 [Minor] TieredDiscount 본진 미확인 — *검증 깊이 한계 (결함 아님 / 미검증)*
- 현황: 명세 §5 S5-M1과 동일. 실측 2 SKU(tmpl_price 파우치·tiered_price 굿즈) 모두 **평탄단가**(할인곡선 0). 구간 %할인(TieredDiscount) 본진은 말랑(2개부터 최대50%)·문구 SKU 미캡처로 미확인.
- 영향: 위젯 무관(INV-1 — 가격은 BFF 권위, 위젯은 quantity/printCount/dimensions echo만). NC-3 판정·echo·가드·직렬화는 본 패스 검증 대상이며 전부 PASS.
- 재현: 말랑/문구 SKU 로그인 라이브 캡처로 구간할인 곡선 확보 → 후니 TieredDiscount 모델 비교검증.
- 조치: 비차단. 후속 S5-M 임계경로.

### S5-M2 [Minor] GSTGMIC 가격 라이브 미비교 — *검증 깊이 한계 (결함 아님 / 미검증)*
- 현황: GSTGMIC 별도 price fixture 부재 → fetchPrice에서 책자 fixture fallback. 가격 라이브 대조 미수행(product 매핑만 검증).
- 영향: NC-3 판정 무관(product 구조가 판정 대상이며 PASS). 가격 정합은 GSTGMIC tiered_price 캡처 fixture 추가 필요.
- 재현: GSTGMIC 로그인 캡처 → `price_GSTGMIC_sample.json` 추가 + fetchPrice 분기.
- 조치: 비차단(S5-M1과 함께 후속).

### S5-M3 [Minor] 다색 굿즈 SKU 색상칩 렌더 미실증 — *검증 깊이 한계 (결함 아님 / 미검증)*
- 현황: 명세 §5 S5-M2/s5-nc3-decision §6. 캡처 2 SKU에 색상/이미지 셀렉터 부재 → large-color-chip/image-chip/mini-color-chip 실사용 미실증(머그/텀블러/에코백/말랑 색상 SKU 미캡처).
- 영향: NC-3 판정 불변(디자인 시스템 v5.0.0이 50×50을 정식 규정, 64×64 부재). 어댑터가 colorHex/imageUrl 슬롯 채워 기존 칩 렌더(설계상). 실증은 SKU 캡처 필요.
- 조치: 비차단. NC-3 신규 불요 판정은 미캡처 SKU에 의해 뒤집히지 않음.

### (참고) skinInfo view_yn / GSTGMIC hidden essential echo — **본 stage 스코프 밖** (S4-O1과 동일 패턴)
- GSTGMIC PCS 전부 VIEW_YN=N(코팅/모양커팅/부자재/조립/포장 = 필수 가공)이 finish-button visible=false로 그룹 생성(미렌더). S4-O1과 동일하게 defaultSelections가 visible 무관 기본 선택하여 selectedFinishes echo 가능 — INV 위반 아님(필수 가공 BFF 전달, 더 안전). 비차단.

---

## 라이브 vs 코드-온리 구분 (정직성)

| 검증 | 방식 |
|------|------|
| echo 지점 이탈(buildPriceRequest 0줄 / 어댑터 흡수) | **소스 직접 대조**(price.ts L75-88 vs red-adapter.ts L359) + **단위**(직렬화 2 tests) |
| NC-3 흡수(파우치 option-button·select-box·counter / 굿즈 chipGroups=0) | **어댑터 단위**(goods-pouch 4 tests) + **런타임 로그**(mapProduct) |
| 가드(quantity=0/printCount=0 → ok:false / 통과 시 PRICE>0) | **단위**(3 tests) + **라이브 store**(createWidgetStore PRICE=2,850,000) |
| INV-3 코어 0줄 | **git diff --stat -- src/widget/**(0줄) + git status |
| INV-2 중립성 | **정량 grep**(widget/contract 코드 식별자 0건, 주석만) |
| fixture 근거성(규격치수·작업+20mm·실가 2,850,000) | **fixture↔캡처 shape diff**(product/price ↔ s5_pouch_GSPUFBC) + **로그인 실가**(PRICE>0) |
| S0~S4 무회귀 | **게이트 재현**(tsc EXIT 0 / vitest 65 passed / vite build) |
| GSTGMIC 가격 실가 정합 | **미검증**(price fixture 부재, 책자 fallback — S5-M2) |
| TieredDiscount 구간할인 곡선 | **미검증**(실측 2 SKU 평탄 — S5-M1, 말랑/문구 후속) |
| 다색 굿즈 색상칩 렌더 | **미검증**(SKU 미캡처 — S5-M3) |

---

## 다음 stage 영향

- **S5 GO. 후속 stage 진입 무차단.** S5가 INV-1~5 전부 유지 + **위젯 코어 0줄 + 계약 optional 1필드 + 어댑터 직렬화/가드로 NC-3를 흡수**하여 "정규화 계약 의존 + 어댑터+데이터 흡수" 가설을 S4에 이어 재실증. NC-3 = 두 번째 "신규 불요" → 확정 신규 componentType = NC-1 단 1종 성립.
- **echo 지점 이탈은 INV-3을 강화하는 방향**(buildPriceRequest 1줄도 어댑터로 흡수)이며 의미 손실 없음 — 후니 PRN_CNT 옵션 노출 시 buildPriceRequest 1줄 추가 경로 보존.
- 잔존(전부 후속 독립, 병행 보강 가능): S5-M1(TieredDiscount 말랑/문구 캡처), S5-M2(GSTGMIC 실가 fixture), S5-M3(다색 굿즈 색상칩), S3/S4 잔존(real_price PRICE·타 아크릴 SKU).
- **명세 정정 1건(hw-architect 회신 권장)**: 명세 §4.1 #2 echo 지점 서술 ↔ 구현 불일치(S5-O1). 구현이 INV-3에 더 부합하므로 명세를 구현에 맞춰 조건부 정정. 코드 수정 불요.

---

## 환경 메모
- 검증 시점 게이트: tsc EXIT 0 / vitest 65 passed(10 files) / vite build 성공(dist/widget.js 715.32kB).
- GSPUFBC는 로그인 라이브 캡처(customerCode 22025916) 기반 — S3/S4 비로그인 PRICE=0 한계를 일부 극복한 첫 S5 실가 fixture(PRICE=2,850,000).
- 임시 프로브 미사용 — 본 패스는 vitest/grep/git diff/fixture diff로 검증(라이브 Red 재접속 불요). 재현은 본 보고서 명령 + `red-adapter-goods-pouch.test.ts` 11 케이스로 가능.
- 코드 수정·커밋 0건(read-only 검증 + 게이트 실행만). GO 후 오케스트레이터 커밋.
