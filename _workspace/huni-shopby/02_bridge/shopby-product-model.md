# shopby-product-model.md — Shopby 상품/옵션/가격/추가금액 모델 (스펙 근거)

> 권위 순서: Shopby OpenAPI 스펙(`docs/shopby/shopby-api/*.yml`) 1차 → enterprise 문서 → 라이브 갭필.
> 모든 주장에 `스펙: <파일>:<operationId>` 또는 `파일:라인` 근거. 추정 0.
> 산출자: hsb-product-bridge-analyst (기준점). 작성: 2026-06-25.

---

## 0. 결론 요약 (한 문단)

Shopby 카트/주문 라인은 **`productNo` + `optionNo` + `orderCnt`(+ 텍스트 `optionInputs`)** 만 입력받는다.
**라인에 가격을 직접 싣는 필드는 어디에도 없다.** 가격은 전적으로 서버가 `상품 판매가(salePrice) + 옵션 추가금(addPrice)`
공식으로 산출한다(즉시할인·추가할인은 서버가 다시 적용). 따라서 후니의 동적 계산가(`evaluate_price.final_price`)를
카트 라인에 "그 숫자 그대로" 넣는 경로는 **스펙에 존재하지 않는다**(상세 = `product-price-bridge-spec.md` §3).

---

## 1. 상품(Product) 모델

### 1.1 상품 조회 (storefront)
- `스펙: product-shop-public.yml:get-products-product` — 상품 단건 상세.
- `스펙: product-shop-public.yml:get-products-search-by-nos` — 번호 리스트 일괄.
- `스펙: product-shop-public.yml:get-product-extraInfos` — `{productNo, extraInfo:"추가정보1"}` (자유 텍스트 메타, 가격 무관).

### 1.2 상품 등록/수정 (admin·커스텀 개발 범위)
- `스펙: product-server-public.yml:post-product-v2` — 상품 신규 등록(주 등록 계약).
- `스펙: product-server-public.yml:put-product-v2` / `put-product` / `put-product-partial` — 수정.
- 등록 requestBody 핵심 가격 필드 (`product-server-public.yml:1348-1391`, post-product-v2 example):
  - `price.salePrice` — 기본 판매가 (예 10000).
  - `price.purchasePrice` — 매입가.
  - `price.immediateDiscountInfo{unitType: PERCENT|WON, amount, periodYn, startYmdt, endYmdt}` — 즉시할인.
  - `price.unitPriceInfo{unitName, unitNameType, unitPrice}` — 단위가격 **표시용**(가격 산정 아님).
  - `price.surtaxType: DUTY` — 과세 유형(정산/세금 정합 축).
  - `optionType: COMBINATION` + `option.options[]{optionNo, optionName, optionValue, addPrice, ...}`.

**핵심 명제 M-PROD-1:** 상품 가격 그릇 = `salePrice`(상품 1개) + 옵션별 `addPrice`(옵션 N개). 가격 변동은
**옵션 행을 늘리는 것**으로만 표현된다(임의 숫자 라인 입력 불가). → CPQ 조합 폭발의 근원.

---

## 2. 옵션(Option) 모델

### 2.1 옵션 조회 (storefront)
- `스펙: product-shop-public.yml:get-product-options` — 상품별 옵션. 응답 = `type(COMBINATION)`, `selectType(MULTI)`,
  `labels[]`, `multiLevelOptions[]`(계층), `flatOptions[]`(평면), `inputs[]`, `productSalePrice`, `immediateDiscountAmt`,
  `additionalProducts[]` (`product-shop-public.yml:3707-3729` example).
- `스펙: product-shop-public.yml:get-products-options` — 다상품 옵션 일괄.
- 각 옵션(`flatOptions[]`)의 가격 관련 필드 (`product-shop-public.yml:6460-6517`):
  - `optionNo` — 옵션 식별자(카트가 참조).
  - `addPrice` — **옵션 추가금액**(예 10000). 옵션 단위 가격 가산값. (`description: 추가금액`, `:6460-6463`)
  - `buyPrice` — `productSalePrice(즉시할인 적용) + addPrice`로 산출되는 구매가(서버 계산값, 표시).
  - `optionManagementCd` / `extraManagementCd` — 판매자 관리 코드(매핑 키 후보).
  - `stockCnt` / `saleType` / `forcedSoldOut` — 재고·판매상태.

### 2.2 옵션 등록/수정 (admin)
- `스펙: product-server-public.yml:put-product-options` — 옵션 일괄 등록/수정.
  requestBody (`product-server-public.yml:1802-1810` example):
  `{mallProductNo, options:[{item, optionType:COMBINATION, optionName:"색상|사이즈", optionValue:"빨강|XL",
  order, addPrice, useYn, optionManagementCd, extraManagementCd, stockCnt, optionImages[], mallOptionNo,
  forcedSoldOut, optionSelectType:MULTI}], inputs:[{mallProductInputNo, inputText, inputMatchingType:OPTION,
  useYn, required}]}`.

**핵심 명제 M-OPT-1:** 옵션 1행 = 1개의 고정 `addPrice`. 후니처럼 (사이즈×수량×자재×후가공)으로 가격이 연속/조합
변동하면, **각 가격 분기마다 별도 옵션행**이 필요하다. `optionValue`는 "빨강|XL" 같은 라벨 조합이며 가격은 그 행의
`addPrice` 1개로 고정. (= 전략 A 동기화의 무손실성 제약 — `bridge-strategy-options.md` 전략 A 참조.)

---

## 3. 구매자 작성형 옵션(inputs / optionInputs) — 텍스트 전용

- `스펙: product-shop-public.yml:get-product-options` → 응답 `inputs:[{inputNo, inputLabel, inputMatchingType, required}]`
  (`:3725-3727`). 등록측 `inputs[].inputMatchingType` enum (`product-shop-public.yml:6524-6531`):
  - `OPTION: 옵션별` / `PRODUCT: 상품별` / `AMOUNT: 수량별` — **매칭 스코프**일 뿐 가격 효과 없음.
- 카트/주문에 실리는 형태: `optionInputs:[{inputNo, inputLabel, inputValue}]` (`order-shop-public.yml:32046-32063`, cart req schema).

**핵심 명제 M-INPUT-1:** `optionInputs[].inputValue`는 **자유 텍스트**(예 "14호", "최대한 늦게 생산된걸로")이며
**가격에 영향을 주지 않는다.** inputMatchingType(OPTION/PRODUCT/AMOUNT)은 표시·매칭 범위 지정이지 가격 가산이 아니다.
→ 후니 사양(자재/사이즈/도수/후가공)을 **표시·전달**하는 무손실 채널로는 적합하나, **가격 주입 채널로는 부적합**.

---

## 4. 추가상품(Extra Product) 모델

- `스펙: product-shop-public.yml:get-extra-products` — 상품별 추가상품 목록.
  응답 = `{extraProductTitle, extraProducts:[{productNo, productName, price{salePrice, immediateDiscountInfo,
  additionalDiscountInfo, couponDiscountInfo}, limitations{...,canAddToCart}, optionInfo{flatOptions[]{optionNo,
  addPrice, buyPrice,...}}, inputs[]}]}` (`product-shop-public.yml:3611-3633`).

**핵심 명제 M-EXTRA-1:** 추가상품은 **그 자체가 별도 `productNo`를 가진 정식 상품**이다(자기 salePrice·옵션·addPrice 보유).
카트에 실릴 때 `baseProductNo`로 본상품에 종속된다(`order-shop-public.yml:32035-32037`, `baseProductNo: 본상품번호(추가상품이라면 필수 입력)`).
→ "임의 추가 금액을 한 줄 더 얹는" 자유 금액 라인이 아니라, **사전 등록된 가격을 가진 상품 1개를 더 붙이는 것**.
후니의 후가공/옵션가산을 "추가상품"으로 표현하려면 그 가산값마다 추가상품(+옵션)을 미리 등록해야 한다.

---

## 5. 상품항목추가 / 커스텀 속성(Custom Property)

- `스펙: product-shop-public.yml:get-custom-property-by-mallno` — 몰 전체 상품 항목 정의.
  응답 = `{customProperties:[{no, name:"시즌", values:[{no, value:"S/S"}]}]}` (`product-shop-public.yml:1136-1138`).
- enterprise 문서: `상품항목추가 관리`(`shopby_enterprise_docs/product.mdx:32`, `/product/customproperty.md`).

**핵심 명제 M-CUSTOM-1:** 커스텀 속성 = **상품 분류·필터링용 라벨 마스터**(이름 + 허용값 enum). 가격 필드 없음.
주문 라인에 임의 금액을 싣는 용도가 아니다. 후니 사양 메타데이터(예 "지종=아트지")를 **분류·표시**하는 데는 쓸 수 있으나,
**계산가 주입 경로 아님**. (상세 = open-questions.md OQ-2: 카트 라인별 customProperty 첨부 가능 여부는 스펙 미확인.)

---

## 6. 서버측 가격 산정 공식 (스펙 명문)

`스펙: product-shop-public.yml:get-products-related-products` description (`:3816-3833`)에 가격 적용 규칙이 **명문화**:

1. **기본 판매가**: 옵션 없는 상품 = `salePrice` 그대로. 옵션 있는 상품 = `salePrice + addPrice`.
   세트 상품 = 구성 옵션들의 구매가 합.
2. **즉시할인**: `(salePrice − 즉시할인) + addPrice`. ★옵션가(addPrice)에는 즉시할인이 **적용되지 않음**.
3. **추가할인**: `((salePrice − 즉시할인) + addPrice) × (1 − 추가할인율)` — 실제 구매가에 적용.

**핵심 명제 M-PRICE-1:** Shopby 라인 최종가는 **항상 서버가 (등록된 salePrice·addPrice·할인) 으로 재산출**한다.
클라이언트가 보낸 어떤 값도 가격으로 채택되지 않는다. → 동적 계산가 생존의 유일한 길 = **그 계산가가 곧
등록된 salePrice/addPrice 이게 만드는 것**(전략 A/C 동기화), 또는 **별도 권위 가격을 후니 백엔드가 보유하고
Shopby 가격을 신뢰하지 않는 것**(전략 B/D + 정산 재정의 — open).

---

## 7. 가격이 서버에서 재계산되는 지점 (recompute 충돌 지점)

| 지점 | operationId | 가격 입력 필드? | 서버 재산출? | 근거 |
|------|-------------|----------------|--------------|------|
| 장바구니 등록 | `post-cart` | **없음** (productNo·optionNo·orderCnt·optionInputs·baseProductNo·groupId만) | 가격 미수신, 조회 시 산출 | `order-shop-public.yml:722-731`, 스키마 `cart-1115878954` `:32025-32070` |
| 장바구니 금액조회 | `get-cart-calculate` | (조회) | salePrice+addPrice+할인 재산출 | `order-shop-public.yml:get-cart-calculate :811` |
| 주문서 작성 | `post-order-sheet` | **없음** (products[]=productNo·optionNo·orderCnt·optionInputs·baseProductNo·rentalInfos·recurringPaymentDelivery) | 재산출 | `order-shop-public.yml:3839-3844`, 스키마 `order-sheets-427257668` `:21432-21526` |
| 주문서 금액조회 | `post-order-sheets-order-sheet-no-calculate` | **없음** (payProductParams=동일 라인 shape, 가격 없음) | 쿠폰·배송 포함 재산출 | `order-shop-public.yml:4143-4148` |
| 주문서 GET | `get-order-sheet` | (조회) | `price{salePrice,addPrice,immediateDiscountAmt,additionalDiscountAmt,standardAmt,buyAmt}` + `paymentInfo.paymentAmt` | `order-shop-public.yml:3957-3958`, `:4012-4020` |

**핵심 명제 M-RECOMPUTE-1:** post-cart·post-order-sheet·calculate **3개 쓰기/계산 엔드포인트 모두 가격 입력 필드가 없다.**
스펙 전수 검색 결과 `customPrice`·`orderPrice`·`priceOverride`·"주문 시 가격 결정" 류 키 **0건**(검색: 6개 *.yml).
유일하게 클라이언트가 보내는 금액류 = `rentalInfos.monthlyRentalAmount`(렌탈 전용)·`externalPayTotalAmt`(외부결제)이며
일반 상품가 라인에는 무관. → **카트/주문서/계산 어디서도 후니 계산가를 라인 값으로 받지 않는다(스펙 사실).**

---

## 8. 정산·세금·클레임 관련 (전략 평가용 메모)

- 과세 유형: `price.surtaxType`(post-product-v2, `:1362`).
- 수수료/매입: `price.purchasePrice`·`partnerChargeAmt`·`commissionInfo{type:PARTNER, rate}`(`:1355-1356`).
- 정산은 admin "정산" 기능이 NATIVE로 처리(`admin-analysis/feature-matrix.md:79-85`) — 정산은 **Shopby가 보유한 라인 가격**
  기준으로 산출됨이 합리적 추론이나, **정산 산출이 라인 salePrice/addPrice를 권위로 쓰는지 vs 다른 소스를 쓰는지는
  스펙 미확인** (→ open-questions OQ-4). 전략 B/C(가격 주입 불가)에서 정산 정합이 핵심 리스크.

---

## 9. `/products/{productNo}/purchasable` — 우선구매권한(구매가능 여부 아님) [정정]

- `스펙: product-shop-public.yml:get-product-purchase-permission` (`/products/{productNo}/purchasable`, `:3730-3805`).
- ★ **이름이 "purchasable"이나 일반 "구매 가능 여부" 게이트가 아니다.** summary="상품번호로 **상품우선구매권한** 조회".
  응답 `products-productNo-purchasable-1211254388`(`:7923`) = `[{permissionNo, optionNo, purchaseStartAt,
  purchaseEndAt, purchaseCnt, purchasedCnt}]` (예시 `:3801-3805`) — **한정/우선 구매권(기간·수량 제한)** 정보.
- **핵심 명제 M-PURCH-1:** 후니가 찾는 "이 상품/옵션을 실제로 주문 라인에 담을 수 있는가"(가격사슬 완전·재고·판매상태)
  의 sanity 게이트는 이 엔드포인트가 **아니다**. 그 역할은 `get-cart-validate`(`order-shop-public.yml:1138`,
  `{result:bool}`)다(commerce-flow-contract §1.6). → 브리지 SB2 "카트 전달 가능" 판정에 purchasable을 쓰면 안 됨.

---

## 10. enterprise 옵션 모델 (M-OPT-1 권위 보강 — `add-list/add/sale-info/option.mdx`)

스펙(`product-server-public.yml`)의 옵션 shape를 enterprise 운영 매뉴얼이 의미적으로 확증한다(`option.mdx`).

| enterprise 사실 | 근거(option.mdx) | 브리지 함의 |
|----------------|-----------------|------------|
| 옵션가(addPrice)=상품 판매가에 **추가/차감되는 고정값**(차감은 음수) | `:60-62, 103-105` | 라인 가격 분기마다 옵션행 1개·고정가. 연속 계산가 불가(M-OPT-1 확증) |
| 선택형 옵션 **최대 5개** + 텍스트 옵션 **최대 5개** | `:44-45` | CPQ 축(자재·사이즈·도수·후가공·수량…)이 5축 초과면 일체형 조합으로 못 담음 |
| 일체형=모든 옵션 조합 1박스 / 분리형=축별 개별박스 | `:49-50` | 후니 CPQ 캐스케이드를 일체형으로 펼치면 조합 폭발(전략 A 제약) |
| **선택옵션 = "추가상품 판매 등으로 활용"** | `:88` | 후가공 가산을 native 선택옵션(addPrice)으로 표현하는 1차 경로(추가상품 API 대안) |
| 텍스트 옵션 = 주문자 자유입력·**가격 효과 없음**·상품별/옵션별 매칭 | `:166-186` | 후니 사양(지종 등) 무손실 표시 채널(M-INPUT-1 확증)·가격 채널 아님 |
| **구매수량별 추가할인 = 필수옵션 구매수량·금액 기준** | `:162` | Shopby native 수량할인은 "필수옵션 수량 구간"에 정률/정액 — 후니 구간단가와 모델 상이(OQ-5) |
| 옵션 일괄수정/사후 수정 지원([옵션 정보 적용]) | `:124, 219-228` | 옵션 addPrice를 사후 변경 가능(P-B 동적 등록 메커니즘 존재) — 단 §11 심사 종속 |
| **세트 상품의 세트 옵션은 분리형(필수/선택) 설정 불가** | `:157` | 후니 셋트상품(`evaluate_set_price`)을 Shopby 세트로 매핑 시 옵션 구성 제약 |

---

## 11. 상품심사(judgement) — P-B(동적 옵션) 운영 관문 [OQ-3 보강]

- `스펙: product-server-public.yml:put-inspection-confirm`(심사 확정) / enterprise `judgement.mdx`.
- ★ enterprise 명문: "신규로 등록한 상품 또는 **상품의 일부 정보를 수정한 경우** 상품판매를 위한 상품 심사가
  필요"(`judgement.mdx:9`). 수정 시 승인상태 = **"수정 후 승인대기"**(`:35`)로 전이.
- **핵심 명제 M-JUDGE-1:** 옵션 addPrice를 주문 직전 동적 변경/등록(P-B)하면 상품이 "수정 후 승인대기"로
  떨어질 수 있고, 그 사이 판매 차단 위험. **"일부 정보 수정"에 addPrice/옵션 변경이 포함되는지(자동승인 예외
  여부)는 매뉴얼 문구로 단정 불가** → 여전히 OQ-3(라이브/세부 정책 확인 필요)이나, **자동심사가 없다면 P-B는 사실상 불가**.

---

## 12. 미확인 (open으로 분리)

- 카트 라인 단위로 임의 `customProperty` 값을 첨부하는 경로 — 스펙 미확인 (OQ-2).
- 가격을 "주문 시 결정"하게 만드는 상품 유형/설정 — 스펙·enterprise option.mdx 정독 결과 **미발견**(옵션가=고정값
  모델만 존재). OQ-1 잠정 결론 **"불가"** 강화(enterprise 권위). 라이브 비공개 설정 가능성만 잔존.
- P-B(주문 직전 옵션 동적 생성)가 상품심사 "수정 후 승인대기"를 유발하는지(M-JUDGE-1) — addPrice 변경의
  자동승인 예외 여부 미확인 (OQ-3).
