# 와우프레스 가격 메커니즘 — templated vs quoted·가격조회 API 계약 (§35 Phase 1)

> 원천: `wowpress-api:6.4-제품가격조회`·`wowpress-api:9.1-status`·`wowpress-pdf:price_order_spec_v1.01.pdf#p5`·
> `catalog:products/*.json#pricing`. **[HARD] 가격 값 권위 = 와우 제품가격조회 API**(후니 evaluate_price 경계 동형·§33 D-18).
> 온톨로지는 가격 **축·구성요소 연결까지만** — 값 계산 안 함.

## 1. 결정적 발견 — catalog에 실 가격값 0

스크립트 전수 판정 (`_cache/wow_products.csv#pricing_status`):

| 지표 | 값 | 앵커 |
|---|---|---|
| `pricing.status = requires-configuration` | **326 / 326 (전량)** | `catalog:products/*.json#pricing.status` |
| `pricing.source` | `/std/prod/jobcost` (전량 동일) | `#pricing.source` |
| `pricing.template != null` (index의 "templated") | 6 | `#pricing.template` |
| `pricing.quotes` 비어있지 않음 | 0 | `#pricing.quotes` |
| index.json pricingStats | templatedProducts=6·quotedProducts=0 | `catalog:index.json#pricingStats` |

**결론**: catalog는 **가격 스냅샷을 담지 않는다.** 전 상품 가격은 런타임에 `/std/prod/jobcost` 호출로만 확정.
→ 와우 = **사실상 전량 quoted(API 조회형)**. index의 "templated 6"은 정적 가격표가 아니라 **jobcost 호출용 payload 템플릿이 만들어진 6상품**일 뿐(아래 §2).

## 2. "templated 6"의 실체 = payload 템플릿 (정적 가격표 아님)

6 templated 상품: 특가책자(무선)(40200)·윤전책자(40201)·무선책자(40196)·PVC커버노트(40525)·중철책자(40198)·특가책자(스프링)(40433) — **전부 책자류** (`_cache/wow_products.csv` has_template=True).

`catalog:products/40200.json#pricing.template` 실체:
```
{ endpoint:"/std/prod/jobcost",
  payload:{ prodno:40200, ordqty:1, ordcnt:1, ordtitle:"AI Auto Estimate",
            ordbody:"자동 견적 요청", jobpresetno:14, awkjob:[] },
  notes:"jobpresetno 및 후가공 옵션을 채운 뒤 /std/prod/jobcost 호출 필요" }
```
- 이 6상품은 catalog 수집기가 payload를 조립했으나 **실 호출은 에러**:
  `pricing.error = "상품단가 확인요청 JSON Format...Column '[target_bound]' cannot be null"`,
  `pricing.diagnostics.statusCode = 1048`, `step = "PJOIN 1 SET JOBNO"` (`catalog:products/40200.json#pricing.diagnostics`).
- **판정: templated ≠ 정적 가격표.** 와우에는 catalog 계층의 정적 가격표가 존재하지 않음. templated/quoted 이분은 catalog 수집기 산물이며 **실질은 단일 메커니즘(jobcost API)**.

## 3. 가격조회 API 계약 (`POST /api/v1/ord/cjson_jobcost`)

앵커: `wowpress-api:6.4-제품가격조회` · `wowpress-pdf:price_order_spec_v1.01.pdf#p5`.

### 3.1 요청 파라미터 (Table 7)

| key | type | 의미 | 앵커 |
|---|---|---|---|
| `prodno` | int | 제품번호 | `wowpress-api:6.4#prodno` |
| `ordqty` | string | 인쇄 수량/매수 | `#ordqty` |
| `ordcnt` | string | 인쇄 건수 | `#ordcnt` |
| `ordtitle` | string | C/S 참고 주문제목 | `#ordtitle` |
| `prsjob` | array(map) | **인쇄기·인쇄옵션 정보** (규격/재질/도수/인쇄방식 선택값을 이 안에 실음) | `#prsjob` |
| `awkjob` | array(map) | 후가공·후가공옵션 정보 | `#awkjob` |

- 선택값 전달 구조: catalog 템플릿 payload는 `jobpresetno`+`awkjob`을 최상위에 두지만, SPEC Table 7 정본은 **`prsjob` array**에 인쇄 구성(규격 sizeno·재질 paperno·도수 colorno 포함)을 실어 보냄. → 규격/재질/도수는 별도 top-level 파라미터가 아니라 **prsjob 맵 내부 필드**.
- 상세 payload JSON 샘플은 문서에서 "제품가격확인 파라미터 샘플 보기"(접힘) — catalog에 전개본 없음 → **GAP-PRICE-1**.

### 3.2 응답 데이터 (Table 8, `resultMap.cjson_jobcost`)

가격 출력 필드 (`wowpress-api:6.4#ordcost_*`):

| 필드 | type | 의미 |
|---|---|---|
| `status` | string | 요청상태값(→ §4 코드표) |
| `ordqty` / `ordcnt` | int | 주문수량 / 주문건수 |
| `ordcost_price` | double | 주문금액 |
| `ordcost_dc` | double | 할인금액 |
| `ordcost_sup` | double | 공급가 |
| `ordcost_tax` | double | 부가세 |
| `ordcost_bill` | double | **청구가(최종)** |
| `ordcost_base` | map | 제품가격정보 상세(내역) |
| `prsjob` / `awkjob` | array | 인쇄/후가공 주문옵션(반영본) |
| `boxcnt`·`weight_ord`·`weight_box` | int/float | 배송 박스수·무게 |
| `exitday`·`exitdate` | int | 출고 소요일·출고예정일 |

- **가격 = 축 조합 → API → ordcost_bill**. 구성요소 내역은 `ordcost_base`(map)에 은닉 → 온톨로지는 이 map을 재현하지 않음(§33 D-18 경계).

## 4. 가격 = 제약 검증자 (핵심 메커니즘)

`wowpress-api:6.4` 본문 명시:
- **"제품의 가격이 수량에 정확히 비례하지 않습니다"** (`wowpress-api:6.4#note`) → 수량 비선형(구간할인/판걸이형). 온톨로지 가격축에 "수량 비선형" 사실 기록.
- **"제품의 가격이 조회되지 않으면 주문이 불가능한 옵션"** (`wowpress-api:6.4#note`) → **가격조회 API가 곧 옵션조합 유효성 검증자.** 유효하면 200+가격, 무효면 에러코드.

### status 코드표 (`wowpress-api:9.1`, Table 57) — 축별 검증 매핑

| code | 의미 | 검증 축 |
|---|---|---|
| 200 | 정상 처리(가격 반환) | — |
| 401 | 필수 파라미터 누락 [action, prodno, ordcnt, ordqty] | 공통 |
| 402 | 제품 필수 후가공 체크 에러 | 후가공(필수) |
| 403 | 인쇄작업 선택 오류 | 인쇄방식 prsjob |
| 404 | 규격 선택 오류 | 규격 sizeno |
| 405 | 지질 선택 오류 | 재질 paperno |
| 406 | 도수 선택 오류 | 도수 colorno |
| 407 | 추가 도수 선택 오류 | 도수 colornoadd |
| 408 | 옵션조합 불가 (sizeno·paperno·optno·colorno·colornoadd 확인) | **교차축 조합** |
| 409 | 작업수량 불가 (ordqty) | 수량 |
| 410 | 규격 필수후가공 체크 에러 | 규격↔후가공 필수조건 |
| 411 | 비규격 입력 에러 (Width/Height 필요) | 비규격 규격 |

- 이 코드표 = §structure §5의 인라인 `req_*`/`rst_*` 제약이 **런타임에 강제되는 지점**. 정적 제약(catalog raw)과 동적 검증(jobcost status)이 짝.

## 5. 가격 결정 축 (온톨로지가 담을 연결)

가격은 다음 축의 조합으로 결정 (값은 API 권위, 축·연결만 KB):
1. **제품(prodno)** — 기준.
2. **수량/건수(ordqty·ordcnt)** — 비선형(구간). ordqty_type select(317)/input(6).
3. **인쇄방식(prsjob: jobpresetno·jobno)** — 합판/독판/UV/INDIGO 등 16종.
4. **규격(sizeno)** — 규격/비규격(width×height).
5. **재질(paperno)** — papergroup·pgram.
6. **도수(colorno·colornoadd)** — 단·양면 도수, 별색.
7. **후가공(awkjob: jobno)** — 43그룹·471작업, 각 unit(부/매/개)별 가산.
8. **부자재/옵션(optno·prodadd)** — 별도 가산 상품.

→ **가격 모델 = 축 조합 입력 → jobcost → ordcost_bill (구성내역 ordcost_base map)**. 후니 대비: 후니 evaluate_price(불투명 서버 계산)와 **경계 동형** — mapper가 `price_model_differs` 관계로 대조.

## 6. 가격 권위 경계 명세 (§33 D-18 동형)

| 계층 | 와우 | 후니(§33) |
|---|---|---|
| 가격 축·구성요소 연결 | 온톨로지(KB)가 담음 | 온톨로지가 담음 |
| 가격 **값** 계산 권위 | `POST /std/prod/jobcost` → `ordcost_bill` | `evaluate_price()` (Railway 서버) |
| 옵션조합 유효성 | jobcost status 200 vs 402~411 | webadmin constraint + 위젯 validate |
| KB 책임 한계 | **축·연결까지. 값 재현·저장 안 함** | 동일 |

## GAP (정직 기록)

- **GAP-PRICE-1**: jobcost 요청 payload 전개 JSON 샘플 부재 — API 문서의 "샘플 보기"가 접힘, catalog에도 성공 응답 없음. prsjob 맵 내부 정확한 필드 배치(sizeno/paperno/colorno 위치)는 라이브 호출 or PDF 상세 필요. anchor=`wowpress-pdf:price_order_spec_v1.01.pdf`(p5~ 미정독).
- **GAP-PRICE-2**: catalog 6 templated 상품 전부 **에러 상태**(target_bound null, statusCode 1048) — 성공 가격 샘플 0. 실 가격 형태는 라이브(devshop, gstack 읽기전용) 재확인 필요분. `captured_at` 미수집.
- **GAP-PRICE-3**: `ordcost_base`(가격 구성내역 map) 스키마 미공개 — 후니 formula_components 대비 불가. §33 D-18 경계상 KB 대상 아님(값 계산 권위 밖). 정보로만 기록.
- **GAP-PRICE-4**: catalog 노후(2025-10-14) — 가격/할인 정책 갱신분 미반영. 가격 값은 항상 런타임 API가 권위(스냅샷 신뢰 금지).
