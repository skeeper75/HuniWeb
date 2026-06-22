# re-contract-price.md — 가격계산 API 역공학 계약 (검증의 자)

> `get_ajax_price_vTmpl` 요청/응답 계약을 verbatim 추출. **검증 동등성의 기준**.
> 권위순서: 디옵 코드(`docs/reversing/red_reverse_engineer/03_deobfuscated`)/라이브 캡처 > 리포트 서술 > 추론.
> 각 필드에 출처(리포트 섹션 / 캡처 파일:키 / deob mod:line)를 단다. 못 다는 건 "미확인".

---

## 0. 엔드포인트 / 트랜스포트

| 항목 | 값 | 출처 |
|------|-----|------|
| 메서드·경로 | `POST /ko/product_price/get_ajax_price_vTmpl` | SDK Report §6.1 / api-log.json:14 / b1_AIPPCUT.json:172 (`/rp-api/...`) |
| Content-Type | application/json (Authorization·CSRF 없음, 세션쿠키 인증) | SDK Report §6 "모든 API 통신은 평문 JSON·인증헤더 없음" |
| 최상위 래퍼 | `{ "dataJson": { ... } }` 1중 래핑 | SDK Report §6.1 / deob mod_05:1138 `body:{dataJson: payload.body}` (D1-price D1-1) / 전 캡처 reqBody |
| 선행 호출 | `GET /ko/product/get_digital_product_info?pdt_cod=<CODE>` (제품 옵션 로드) | api-log.json:3-9 / SDK Report §7.2 (응답→product.baseInfo 스토어) |
| 네트워크 시퀀스 | info(GET) → price(POST). 옵션 변경마다 price 재호출(sdkOptionChange) | api-log.json(GET→POST 반복) / SDK Report §10.3 sdkOptionChange="가격 재계산 트리거" |

---

## 1. 요청 필드 사전 — `dataJson.ORD_INFO[0]`

> ORD_INFO = 단일원소 배열 `[{...}]` (deob mod_06:1256 / red-types.ts:189 / 전 캡처).

| 필드 | 의미 | 예시 | 출처 |
|------|------|------|------|
| `PDT_CD` | 제품코드 | `"PRBKYPR"`, `"AIPPCUT"` | SDK Report §6.2 / b1_AIPPCUT.json:174 / red-types.ts:167 |
| `CUT_WDT` / `CUT_HGH` | 재단 가로/세로(mm) | 182/257(B5), 300/340 | SDK Report §6.1-6.2 / b1_AIPPCUT.json:174 / red-types.ts:168-169 |
| `WRK_WDT` / `WRK_HGH` | 작업 가로/세로(mm, 도련포함) | 192/267, 300/340(도련0) | SDK Report §6.1-6.2 / b1_AIPPCUT.json:174 / red-types.ts:170-171 |
| `ORD_CNT` | 주문건수(정규화 quantity) | 1 | b1_AIPPCUT.json:189(rel 2893) / s5_pouch completeReqBody / red-types.ts:172 |
| `PRN_CNT` | 인쇄수량(정규화 printCount) | 1, 2, 50 | SDK Report §6.1-6.2 / b1_AIPPCUT.json:189 / red-types.ts:173 |
| `PRN_CLR_CNT` | 인쇄 도수(색수) | 0(SID_X 인쇄없음), 4, 8 | b1_AIPPCUT.json:174 / s5_pouch / red-types.ts:174. ★도수 가격의미 운반(DOSU_COD 대신, OPEN-1) |
| `MTRL_CD` | (표지/단일면) 자재코드 | `"PXPLP001"`, `"RXART300"`(아트지300g) | SDK Report §6.2 / b1_AIPPCUT.json:174 / red-types.ts:175 |
| `DOSU_COD` | 도수코드 | `"SID_X"`(인쇄없음), `"SID_S"` | b1_AIPPCUT.json:189 / s5_pouch / red-types.ts:176. ★우리 어댑터는 **의도 omit**(PRN_CLR_CNT가 가격의미 운반, D-L4 MINOR) |
| **책자(book2025) 분리필드** | ↓ item_gbn=book2025_item 일 때만 | | deob mod_05:1859 / red-types.ts:177-183 |
| `PAGE_CNT` | 페이지 수 | 10, 24 | SDK Report §6.1 / red-adapter.ts:593 |
| `CVR_CLR_CNT` / `INN_CLR_CNT` | 표지/내지 컬러 수 | 4 / 8 | SDK Report §6.1 / red-adapter.ts:594-595 |
| `CVR_MTRL_CD` / `INN_MTRL_CD` | 표지/내지 자재코드 | RXART300 / RXYWM080(윤전백색모조80g) | SDK Report §6.1-6.2 / red-adapter.ts:596-597 |

**의류(clothes2025) 분기** — `PRINT_TYPE`/`DIR_MTR` 등: **미확인**(deob 언급·D-L2에 누락으로 분류, 캡처 부재). 파일럿 외.

## 1b. 요청 — `dataJson.PCS_INFO[]` (후가공/공정 배열)

| 필드 | 의미 | 출처 |
|------|------|------|
| `PCS_COD` | 공정코드 | CUT_DFT(재단)·PER_DFT(제본)·COT_DFT(코팅)·SUB_MTR/WRK_MTR(자재)·RIN_DFT(링)·ROU_DFT(라운드) — SDK Report §6.2 / qtysweep_GSTGMIC(allPcsCods) / red-types.ts:191 |
| `PCS_DTL_COD` | 공정 상세코드 | BPLFT(좌철)·TCMAS(코팅)·DFXXX(기본)·TG003 — SDK Report §6.2 / qtysweep_GSNTSPR / red-types.ts:191 |
| `ATTB` (+`ATTB_2`/`ATTB_3`) | **다형 불투명** 속성 echo | red-types.ts:190-191 / D1-price §2. ★의미: (a)속성칩값(BID_SIL/RIN_DFT) (b)사이즈연동반경(ROU_DFT) (c)수량(SUB_MTR/INN_DFT). **ORD_CNT 추종 증거=0**(crossverify-round2 §2 삼중확정). 라이브 실측: qtysweep_GSTGMIC WRK_MTR ATTB=PRN_CNT(2,10), AIPPCUT SUB_MTR ATTB=1(고정), ACPDSTD SUB_MTR ATTB="" → **엔트리별 다형, 단일 규칙 없음** |

## 1c. 요청 — `dataJson` 최상위 (ORD_INFO/PCS_INFO 외)

| 필드 | 의미 | 출처 |
|------|------|------|
| `price_gbn` | 가격체계 구분(불투명 echo, 클라 분기 0) | SDK Report §6.2 / red-adapter.ts:624 / red-types.ts:192. 값: `book2025_price`(책자)·`real_price`(SizeMatrix)·`vTmpl_price`(FixedUnit)·`tmpl_price`(파우치)·`tiered_price`(수량할인) |
| `mb_cust_cod` | 고객등급(가격 등급) | SDK Report §6.2 / deob mod_06:2522 `i?.mb_cust_cod \|\| "10000000"` / red-types.ts:193. **비회원 기본 `"10000000"`. 빈값('')→Red 침묵 PRICE=0**(W1-a, red-adapter.ts:628 `\|\|` 처리) |

---

## 2. 응답 구조

```
{ "retCode": 200,
  "result": [ {PCS_CD, PCS_DTL_CD, PRICE, PRICE_VAT, PRICE_MALL, PRICE_MALL_VAT, ORG_PRICE, ORG_PRICE_VAT}, ... ],
  "result_sum": { PRICE, PRICE_VAT, PRICE_MALL, PRICE_MALL_VAT, ORG_PRICE, ORG_PRICE_VAT },
  "result_log"?: {list:[]}, "book_info"?: {DLVR_AMT} }
```

| 필드 | 의미 | 출처 |
|------|------|------|
| `retCode` | 200=정상(mod_05:1141 !==200 throw) | red-types.ts:141 / D1-price D1-13 |
| `result[].PCS_CD` / `PRICE` / `PRICE_VAT` / `PRICE_MALL` | 공정별 단가 분해 | SDK Report §6.1 / qtysweep_GSTGMIC.pcsPrices / red-types.ts:130-137 |
| **`result_sum.PRICE`** | ★**단일 가격 권위**(합계 공급가) | b1_AIPPCUT.json:175 / s5_pouch / red-types.ts:144. **per-line `result[].PRICE`는 0일 수 있음**(GSTGMIC: PRT_DFT 외 전 line 0, sum=13600) — VP-4 |
| `result_sum.PRICE_VAT` | 합계 부가세 | b1_AIPPCUT.json:177 / red-types.ts:145 |
| `result_sum.PRICE_MALL`/`_VAT`, `ORG_PRICE`/`_VAT` | 워터폴용(PRICE_MALL≠PRICE→ORG_PRICE≠PRICE→ORG_PRICE) | red-adapter.ts:649-663 / deob mod_06:1284 |
| `result_log` | 책자 응답에만(디지털 부재) | red-types.ts:151-152 |
| `book_info.DLVR_AMT` | 배송비(책자) | red-types.ts:153 |
| priceLog (서버 디버그문자열) | "개당단가 : N원, 인쇄수량 : N, 주문건수 : N" | b1_AIPPCUT.json:183 / s5_pouch (PRICE=0 진단 단서) |

---

## 3. 불변식 (오라클 sanity — 매니페스트에 강제)

1. **PRICE=0 = 결함신호** (HARD): RedPrinting은 정상적으로 PRICE=0을 반환하지 않는다 — 0은 항상 우리측 결함(세션만료/필수필드누락/스펙선택). 출처: red-adapter.ts:676-680 / s5-pouch-live-note / auto-memory `huni-widget-red-price-never-zero`.
2. **`result_sum.PRICE`가 단일 권위** — per-line `result[].PRICE` 읽기 금지(번들 컴포넌트는 합법적 0). 출처: red-types.ts:144 / qtysweep_GSTGMIC(PRT_DFT 외 line=0).
3. **ORD_CNT≥1 && PRN_CNT≥1 필수** — 둘 중 하나 부재/0이면 침묵 PRICE=0. 출처: s5_pouch incompleteReqBody(부재→0) vs completeReqBody(추가→2,850,000) / red-adapter.ts:635-637.
4. **mb_cust_cod 빈값('') 금지** — '' → Red 침묵 PRICE=0. 출처: b1_AIPPCUT.json:234(custCode:''→PRICE=0) / red-adapter.ts:628.
5. **dataJson 래퍼 필수** — bare `{ORD_INFO,...}`는 거부/침묵0 위험. 출처: deob mod_05:1138 / red-types.ts:196-197.

---

## 4. 미확인
- 의류(clothes2025) PRINT_TYPE/DIR_MTR reqBody shape — 캡처 부재(파일럿 외, D-L2 누락).
- ATTB가 단가에 실제 영향 주는 후가공(링색·반경)에서의 가격 차 — 라이브 차등 미입증(D-L1, qty=1 캡처가 ORD_CNT/상수/material-qty 구분 불가, D-1 재캡처 선행).
- deob 03_deobfuscated 모듈 라인수(crossverify가 2607/1392로 기록·미직접확인) — VM-3에서 재검증.
