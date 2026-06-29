# product-price-bridge-spec.md — 라이브DB → Shopby 카트 라인 필드 매핑 + 동적 가격 주입 경로

> 권위: Shopby 스펙 1차(`docs/shopby/shopby-api/*.yml`) / 후니 엔진 계약(`engine-contract.md`·`pricing.py`).
> 핵심 난제 = `evaluate_price.final_price`(런타임 동적가)를 카트 라인에 무손실로 싣기.
> 산출자: hsb-product-bridge-analyst. 작성: 2026-06-25. 추정 0 — 미상은 §4 / `open-questions.md`.

---

## 1. 양측 라인 계약 (대조)

### 1.1 후니 라이브 측 (출력)
`evaluate_price(target, selections, qty, grade_cd, ...)` 반환 (`pricing.py:468-488`):
```
{ ok, target{kind, code(prd_cd|tmpl_cd), name}, qty, as_of, mode,
  base{ source(FORMULA|PRODUCT_PRICE|TEMPLATE_PRICE|NONE), amount, components[], warnings },
  discounts[], final_price(int|None), warnings[], errors[] }
```
- 라인 1건 = (상품 `prd_cd`) + (CPQ 선택 `selections` = {siz_cd, mat_cd, print_opt_cd, proc_cd, opt_cd,
  coat_side_cnt, bdl_qty, siz_width, siz_height, ...} `engine-contract §3`) + 수량 `qty` → **`final_price` 단일 정수**.
- 원고: Edicus 편집결과 / PDF 업로드(위젯 측, `raw/widget_monitor`·`docs/reversing`). 가격 무관 첨부물.

### 1.2 Shopby 카트 라인 (입력) — `post-cart` requestBody (`order-shop-public.yml:32025-32070`)
```
[{ productNo(req), optionNo(req), orderCnt(req), groupId?, baseProductNo?,
   optionInputs:[{inputNo, inputLabel, inputValue}]? }]
```
**가격 필드 부재.** (동일 shape: `post-order-sheet` products[] `:21432-21526`, calculate payProductParams `:4143-4148`.)

> ★ R-9/X01 정정: 회원 `post-cart` **schema `cart-1115878954`에는 `channelType`이 없다**(게이트 직접 확인).
> `channelType?`은 **예제(:729)에만 있고 schema엔 없음 = I-CART-2** — 구현은 **schema 기준**(회원 라인에 channelType
> 미전송). `channelType`은 **게스트 `post-guest-cart` schema(`guest-cart337708942`)에만** 존재(`:32093-32096`).

---

## 2. 필드 대 필드 매핑 매트릭스

| # | 후니 라이브 요소 | 출처(후니) | → Shopby 카트/주문 라인 필드 | Shopby 근거 | 무손실? | 비고 |
|---|------------------|-----------|------------------------------|-------------|---------|------|
| F1 | 상품 `prd_cd` | `t_prd_products` / `24_master-extract-260610` | `productNo` (+매핑테이블 prd_cd↔productNo) | `cart-1115878954.productNo` `:32067` | ✅ (사전 매핑 시) | 후니 prd_cd → Shopby productNo 매핑 마스터 필요(신규 운영자산) |
| F2 | CPQ 옵션 선택 = `selections` 조합 | `10_configurator/cpq-design.md` (option_groups/items) | `optionNo` (사전 등록된 옵션행) | `cart-1115878954.optionNo` `:32064` | ⚠️ 조합 폭발 시 손실 | 옵션 1행=고정 addPrice → 가격분기마다 옵션행 필요(M-OPT-1) |
| F3 | **계산가 `final_price`** | `evaluate_price` 반환 `:485` | **(직접 대응 필드 없음)** | §3 참조 | ❌ **직접 무손실 경로 없음** | 핵심 난제. salePrice/addPrice 환원 또는 권위 분리만 가능 |
| F4 | 수량 `qty` | 위젯 입력 | `orderCnt` | `cart-1115878954.orderCnt` `:32043` | ✅ | — |
| F5 | 인쇄 사양 라벨(자재·사이즈·도수·후가공) | `selections` + `engine-contract §9` | `optionInputs[].inputValue` (텍스트) | `cart-1115878954.optionInputs` `:32046-32063` | ✅ (표시·전달) / ❌ (가격) | 텍스트 무손실 전달 가능, 가격 효과 0 (M-INPUT-1) |
| F6 | 후가공/추가옵션 가산분 | `evaluate_price` components(addtn) | `baseProductNo` 종속 추가상품(productNo) | `extra-products` `:3611-3633`, `baseProductNo` `:32035` | ⚠️ | 가산값마다 추가상품 사전 등록 필요(M-EXTRA-1) |
| F7 | 사양 메타(분류) | 상품마스터 | `customProperty`(상품 단위) / `extraInfo` | `get-custom-property-by-mallno` `:1136`, `get-product-extraInfos` `:1211` | ✅ (메타) | 라인 단위 customProperty 첨부는 미확인(OQ-2) |
| F8 | 등급할인 grade_cd | `evaluate_price grade_cd` | Shopby 회원등급(memberGrade) — 별도 도메인 | member API | ❌ 정합주의 | 후니 등급할인 라이브 0행(C9) — 현재 비발화 |
| F9 | 수량구간 할인 | `evaluate_price discounts[]` | Shopby 즉시/추가할인 또는 쿠폰 | `post-product-v2 immediateDiscountInfo` `:1357` | ❌ 모델 상이 | 후니=구간단가, Shopby=상품단위 할인율 — 직접 대응 불가 |

---

## 3. 동적 가격 주입 경로 후보 — 스펙 정밀 탐색 결과

### 3.1 [확정·부정] 라인에 가격을 직접 싣는 경로 = **없음**
- post-cart / post-order-sheet / order-sheet calculate **3개 모두 라인에 가격 입력 필드 없음**
  (`order-shop-public.yml:32025-32070`, `:21432-21526`, `:4143-4148`).
- 6개 *.yml 전수 검색: `customPrice`·`orderPrice`·`priceOverride`·"주문 시 가격"·"가격 결정" 류 키 **0건**.
- 클라이언트가 보내는 유일 금액류: `rentalInfos.monthlyRentalAmount`(렌탈), `externalPayTotalAmt`(외부결제) —
  일반 상품 라인가와 무관.
- **결론: "후니 계산가 정수를 카트 라인에 그대로 주입" 은 스펙상 불가능(open 아님, 부정 확정).**

### 3.2 [확정] 가격이 라인까지 살아남는 **유일한 조건**
Shopby 라인가 = 서버가 `salePrice + addPrice (− 즉시/추가할인)` 으로 재산출(M-PRICE-1, `:3816-3833`).
→ **후니 계산가가 살아남으려면, 그 계산가가 곧 Shopby에 등록된 salePrice/addPrice 값이어야 한다.**

| 경로 | 메커니즘 | 스펙 가능성 | 무손실 조건 | 한계 |
|------|----------|-------------|-------------|------|
| **P-A 사전 옵션 동기화** | 가격분기 조합마다 옵션행 등록(addPrice=후니 가산), salePrice=기준 | ✅ `put-product-options addPrice` `:1804` | 조합 수가 유한·열거 가능할 때만 무손실 | CPQ 연속/대규모 조합 시 옵션 폭발(수천~수만 행) |
| **P-B 주문 직전 옵션 동적 생성** | 1주문 직전 후니가 addPrice=계산가인 옵션을 즉석 등록 → 그 optionNo로 카트 | ⚠️ 등록 API는 존재(`post-product-v2`/`put-product-options`) | 라인=정확히 그 옵션가 | 실시간 등록 정합·잔존 옵션 청소·동시성·심사(judgement) 미검증(OQ-3) |
| **P-C 컨테이너 1상품 + salePrice=계산가** | 대표상품 1개, 주문건마다 salePrice를 후니 계산가로 세팅 | ⚠️ salePrice는 상품속성(주문 단위 변경=상품 수정) | 1상품=1가격 동시성 충돌 | 동시 주문이 같은 상품 공유 시 가격 덮어쓰기 충돌 — 부적합 |
| **P-D 추가상품으로 가산 표현** | 본상품 기준가 + 후가공별 추가상품(addon)으로 차액 | ⚠️ `extra-products` + `baseProductNo` | 가산 단위가 추가상품으로 열거될 때 | 연속 금액 표현 불가(추가상품도 사전 등록가) |

**핵심: 모든 경로가 "후니 계산가 = Shopby 등록 가격"으로 만드는 사전/직전 동기화에 의존.**
임의 숫자를 런타임에 라인으로 흘리는 길은 스펙에 없다.

### 3.3 [재계산 충돌] cart/calculate·order-sheet/calculate 통과 조건
- calculate는 라인 가격을 **무조건 재산출**(쿠폰·배송 포함, `:4047-4156`).
- 후니 계산가가 calculate를 통과(= 동일 값 유지)하려면: 그 라인의 optionNo가 가진 addPrice + 상품 salePrice의
  서버 산출값이 후니 final_price와 **일치**해야 함. → P-A/P-B만 이 일치를 보장 가능.
- 일치하지 않으면(예: 후니가 별도 권위가 보유, Shopby엔 placeholder 가격) → **calculate가 Shopby 가격으로 덮어써
  후니 계산가 소실** → 정산/결제 금액이 후니 견적과 어긋남(전략 B/D의 핵심 리스크, `open-questions OQ-4`).

---

## 4. 무손실성 손익 요약 (매핑 관점)

- **무손실 가능 (사양·식별·수량·텍스트)**: F1, F4, F5(표시), F7(메타). → 카트 라인에 상품/옵션/수량/사양텍스트는 충실 전달.
- **조건부 무손실 (가격)**: F3 = 옵션/상품 가격을 후니 계산가와 동기화했을 때만(P-A/P-B). 동기화 안 하면 손실.
- **모델 불일치 (할인)**: F8·F9 = 후니 구간단가/등급할인 ↔ Shopby 상품단위 할인율/쿠폰 → 직접 매핑 불가, 재설계 영역.

## 5. 토대 연결 — "카트 전달 가능 상태" 상품군 → 브리지 착수 우선순위

> 토대 `live-db-loaded-state.md` §2·§4의 GREEN/YELLOW/RED 분류를 브리지 매핑 적용 순서로 환원.

| 상태 | 상품군(토대 §2 재실측 2026-06-25) | 가격사슬 | 브리지 적용 |
|------|----------------------------------|---------|------------|
| **GREEN** | 스티커16·포스터9·엽서/카드9·엽서7·책자4·접지카드2·포토카드2·패브릭포스터2·쿠폰/상품권2·사인3·전단1 (≈60상품) | ①②③ 충족·final_price>0 | **1순위** — 이 중 고정가형/축≤5 소조합부터 전략 A 파일럿 |
| YELLOW | 인쇄홍보물·라이프·에코백 (상품단위 선별) | 일부 상품만 가격소스 | 2순위 — 상품 단위 GREEN 재확인 후 |
| RED | 하드커버책자0/19·포토북0/8·아크릴0/2·캘린더류·조합형 | 가격소스 0(§21 NO-GO) | **제외** — dbmap 적재 트랙 선행(인간 승인) |

- ★ **런타임 sanity 게이트 배선:** 라인 담기 전 "구매 가능 여부"는 `get-cart-validate`(`order-shop-public.yml:1138`,
  `{result:bool}`)로 확인. `/products/{productNo}/purchasable`은 **우선구매권한**(한정구매)이지 일반 구매가능 게이트가
  아니므로 SB2 판정에 오용 금지(shopby-product-model §9, OQ-7).
- ★ **CPQ 적재 51상품**(토대 §6)이 옵션 매핑(F2) 무손실 SB2 1순위 후보. 옵션그룹/아이템→`ref_dim` 풀이→selections.

## 6. 후가공/추가옵션 가산(F6) — native 선택옵션 경로 [enterprise 보강]
- enterprise `option.mdx:88`: **선택옵션 = "추가상품 판매 등으로 활용"**(native). → 후가공 가산을 추가상품 API
  (`extra-products`·`baseProductNo`)로만 표현할 필요 없이, **본상품의 native 선택옵션(addPrice)** 으로도 표현 가능.
- 함의: F6 경로가 둘(추가상품 vs 선택옵션). 선택옵션이 운영 단순(상품 1개 내 옵션행)·추가상품은 별 productNo 종속.
  단 둘 다 가산값이 **사전 등록 고정가**여야 함은 동일(연속 가산 불가).

## 7. 미확인 (open-questions.md로)
- OQ-1 가격 "주문 시 결정" 상품 유형 존재 여부 — 스펙+enterprise option.mdx 이중 미발견(불가 강화).
- OQ-2 카트 라인 단위 customProperty/추가정보 첨부 가능 여부.
- OQ-3 주문 직전 옵션 동적 생성(P-B)이 상품심사(judgement) "수정 후 승인대기"를 유발하는지(M-JUDGE-1·위험 격상).
- OQ-4 Shopby 정산이 라인 salePrice/addPrice를 권위로 쓰는지(정산 NATIVE·전략 B/D 가격 분리 시 정합).
- OQ-5 후니 구간단가 ↔ Shopby 수량할인(필수옵션 수량 기준) 모델 상이 — Shopby 할인=0 권장(잠정 닫힘).
- OQ-7 `/products/{productNo}/purchasable` = 우선구매권한(정정·구매가능 게이트 아님).
