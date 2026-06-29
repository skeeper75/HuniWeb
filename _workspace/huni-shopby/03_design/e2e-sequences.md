# e2e-sequences.md — 회원/게스트 종단 시퀀스 (operationId 바인딩, dead link 0)

> 산출자: hsb-integration-architect. 작성: 2026-06-25.
> 모든 단계는 `01_research/commerce-flow-contract.md`의 실제 operationId에 바인딩한다(스펙 외 흐름은 명시 표기).
> 권위: Shopby OpenAPI 스펙(`order-shop-public.yml`·auth.mdx) 1차. 입력 팩 밖 엔드포인트 창작 0.
> 가격 권위 정합(addPrice 동기화)은 `integration-architecture.md §4` 참조.

---

## 0. 단계별 operationId 바인딩 표 (dead link 검증)

| # | 단계 | operationId | Method · Path | 입력(이전 출력과 연결) | 출력(다음 입력) | 근거 |
|---|------|-------------|---------------|------------------------|-----------------|------|
| 0 | 위젯 구성·견적 | (BFF) `POST /price` | 후니 BFF | NormalizedPriceRequest | finalPrice | api-contract §2 |
| B | 가격 동기화(D/P-B) | `put-product-options` | `PUT /options`(product-server) | addPrice=final_price | optionNo | product-server:1804, bridge §3.2 P-B |
| 1 | 장바구니 등록(회원) | `post-cart` | `POST /cart` | {productNo, optionNo, orderCnt, optionInputs[]} | {count} | order-shop:679 |
| 1g | 장바구니 계산(게스트) | `post-guest-cart` | `POST /guest/cart` | [{cartNo, productNo, optionNo, orderCnt, optionInputs[]}] | deliveryGroups[]+price | order-shop:1272 |
| 2 | 장바구니 조회(회원) | `get-cart` | `GET /cart` | — | deliveryGroups[]+price | order-shop:443 |
| 3 | 금액 계산 ★돈확정1(회원) | `get-cart-calculate` | `GET /cart/calculate` | cartNo | {buyAmt, totalAmt, ...} | order-shop:820 |
| 4 | 구매가능 검증 | `get-cart-validate` | `GET /cart/validate` | — | {result:bool} | order-shop:1138 |
| 5 | 주문서 작성 | `post-order-sheet` | `POST /order-sheets` | {products[]={optionNo, orderCnt, productNo, **recurringPaymentDelivery**}, cartNos[], productCoupons[], trackingKey?} | {orderSheetNo} | order-shop:3789·products[] required :21436 |
| 6 | 주문서 조회 | `get-order-sheet` | `GET /order-sheets/{orderSheetNo}` | orderSheetNo | availablePayTypes, 주소, 금액 | order-shop:3870 |
| 7 | 금액 계산 ★돈확정2(최종) | `post-order-sheets-order-sheet-no-calculate` | `POST /order-sheets/{orderSheetNo}/calculate` | {accumulationUseAmt, **addressRequest**{receiverAddress, receiverContact1, receiverDetailAddress, receiverZipCd}, couponRequest, shippingAddresses[]={..., payProductParams[]}} | paymentInfo.paymentAmt | order-shop:4063·required :28580·addressRequest :28588 |
| 8 | 주문 예약 ★검증 | `post-payments-reserve` | `POST /payments/reserve` | {**clientReturnUrl, member, orderSheetNo, orderer, payType, pgType, saveAddressBook, subPayAmt, updateMember**}(필수9) + paymentAmtForVerification=paymentAmt(nullable·운영필수) + tempPassword?(게스트) | {returnUrl, confirmUrl, key} | order-shop:4703·required :33000 |
| 9 | PG 결제(스펙 외) | — (NCPPay 결제편의모듈) | returnUrl → PG | reserve 출력 | clientReturnUrl?result=SUCCESS&orderNo | order-shop:33179-33184 (I-PAY-1) |
| 10g | 게스트 주문 토큰 | `get-previous-order-guest-token` | **`POST /previous-orders/guest/{orderNo}`** | path orderNo + body {password}(주문 비밀번호) | guestToken | order-shop:5214 path·5304 post:·5352 {password} |
| 11g | 게스트 주문 조회 | `get-guest-orders-order-no` | `GET /guest/orders/{orderNo}` | guestToken(헤더) | 주문상세 | order-shop:1421 |

> **연결(operationId) 검증**: 각 단계 출력이 다음 입력으로 연결됨(B.optionNo→1.optionNo, 5.orderSheetNo→6/7/8,
> 7.paymentAmt→8.paymentAmtForVerification, 8.returnUrl→9, 9.orderNo→10g, 10g.guestToken→11g). **operationId 연결 0 끊김.**
> **단 필수 필드 갭은 별도 분리**(R-8 정직성): #5 `recurringPaymentDelivery` 일반주문 빈/null shape=**I-OS-1**(갭필),
> #7 `addressRequest`/payProductParams·#8 reserve 필수세트는 본 표에 반영(상기). #9(결제 확정)는 스펙 외 콜백=**I-PAY-1**(모름).
> 즉 "operationId 골격 정합"과 "필드 단위 실현가능성"은 다른 차원 — 골격 끊김 0, 필드 갭은 X07·X08·X09·I-OS-1로 추적.

---

## 1. 회원 종단 시퀀스 (장바구니 경유, 전략 D/P-B 가격 동기화 포함)

```mermaid
sequenceDiagram
    autonumber
    actor U as 회원(브라우저)
    participant W as 위젯 (Shadow DOM)
    participant BFF as 후니 BFF (브리지)
    participant EP as evaluate_price
    participant S3 as S3
    participant SB as Shopby Shop API
    participant PG as PG (NCPPay)

    Note over BFF,SB: 공통 헤더 Version/clientId/platform + Shop-By-Authorization: Bearer <token>

    rect rgb(245,245,255)
    Note over U,EP: ① 위젯 구성 → 견적
    U->>W: componentType 옵션 선택 (size/dosu/material/finish/qty)
    W->>BFF: POST /price  NormalizedPriceRequest
    BFF->>EP: evaluate_price(target, selections, qty)
    EP-->>BFF: final_price (후니 권위가, >0)
    BFF-->>W: NormalizedPriceBreakdown {finalPrice}
    end

    rect rgb(245,255,245)
    Note over U,S3: ② 원고 (Edicus 또는 PDF)
    alt PDF 업로드
        W->>BFF: POST /presigned {fileName, productCode, side}
        BFF-->>W: {uploadUrl(60분), storedFileName}
        W->>S3: PUT uploadUrl (application/pdf 직접)
        W->>BFF: POST /file-meta {storedFileName}
        BFF-->>W: {pageCount, sizeBytes}
    else Edicus 편집
        W->>BFF: POST /editor-config {productCode, side}
        BFF-->>W: NormalizedEditorConfig {psCode, templateUrl, token}
        Note over W: Edicus iframe 편집 → projectId, thumbnailUrls
    end
    end

    rect rgb(235,245,255)
    Note over W,SB: ③ 핸드오프 + 가격 동기화 (★권위 주입)
    U->>W: "장바구니 담기"
    W->>BFF: POST /cart-handoff  NormalizedCartHandoff<br/>{priceSnapshot.finalPrice, selectedOptions, artifacts}
    BFF->>EP: re-evaluate (만료 가드)
    EP-->>BFF: final_price' (검증)
    BFF->>SB: PUT /options [put-product-options]<br/>addPrice=final_price', Shopby 할인=0
    SB-->>BFF: optionNo
    BFF->>SB: POST /cart [post-cart]<br/>[{productNo, optionNo, orderCnt, optionInputs[]=사양·원고식별자}]
    SB-->>BFF: {count}
    BFF-->>W: {ok, redirectUrl?}
    end

    rect rgb(255,250,235)
    Note over U,SB: ④ 장바구니 → 돈확정1
    U->>SB: 장바구니 진입 (스킨/프론트)
    SB->>SB: GET /cart [get-cart]
    SB->>SB: GET /cart/calculate?cartNo=.. [get-cart-calculate]
    Note over SB: ★돈확정1 {buyAmt, totalAmt}<br/>= salePrice+addPrice(=final_price') → 동일값(이중계산 0)
    end

    rect rgb(255,245,245)
    Note over U,PG: ⑤ 주문서 → 돈확정2(최종) → 결제
    U->>SB: "주문하기"
    SB->>SB: GET /cart/validate [get-cart-validate] → {result:true}
    SB->>SB: POST /order-sheets [post-order-sheet]<br/>{products[]={optionNo,orderCnt,productNo,recurringPaymentDelivery},<br/>cartNos[], productCoupons[], trackingKey?}
    SB-->>U: {orderSheetNo}
    SB->>SB: GET /order-sheets/{no} [get-order-sheet] → availablePayTypes
    U->>SB: 쿠폰/적립금/배송지 선택
    SB->>SB: POST /order-sheets/{no}/calculate [..calculate]<br/>{accumulationUseAmt,<br/>addressRequest{receiverAddress,receiverContact1,<br/>receiverDetailAddress,receiverZipCd},<br/>couponRequest, shippingAddresses[]={..,payProductParams[]}}
    Note over SB: ★돈확정2 paymentInfo.paymentAmt<br/>(배송지·배송비 반영 후 — 가격 정합 검증 이 단계까지)
    U->>SB: 결제수단 선택 → "결제"
    SB->>SB: POST /payments/reserve [post-payments-reserve]<br/>필수9{clientReturnUrl,member:true,orderSheetNo,orderer,<br/>payType,pgType,saveAddressBook,subPayAmt,updateMember}<br/>+paymentAmtForVerification=paymentAmt(nullable·운영필수)
    Note over SB: ★검증 paymentAmtForVerification vs 서버 재계산
    SB-->>U: {orderSheetNo, returnUrl, confirmUrl, key}
    U->>PG: returnUrl 결제창 (NCPPay 모듈)
    PG-->>SB: 결제 콜백 (confirmUrl) [스펙 외 — I-PAY-1]
    PG-->>U: clientReturnUrl?result=SUCCESS&orderNo
    end
```

---

## 2. 게스트(비회원) 종단 시퀀스 (stateless 카트)

```mermaid
sequenceDiagram
    autonumber
    actor G as 비회원
    participant W as 위젯
    participant BFF as 후니 BFF (브리지)
    participant EP as evaluate_price
    participant SB as Shopby Shop API
    participant PG as PG

    Note over BFF,SB: accessToken/Shop-By-Authorization 없음 (게스트)

    rect rgb(245,245,255)
    G->>W: componentType 선택
    W->>BFF: POST /price → evaluate_price → finalPrice (>0)
    EP-->>BFF: final_price
    end

    rect rgb(235,245,255)
    Note over W,SB: 핸드오프 + 가격 동기화 (회원과 동일 P-B)
    G->>W: "장바구니 담기"
    W->>BFF: POST /cart-handoff  NormalizedCartHandoff
    BFF->>EP: re-evaluate
    BFF->>SB: PUT /options [put-product-options] addPrice=final_price'
    SB-->>BFF: optionNo
    BFF-->>W: {ok}
    end

    rect rgb(255,250,235)
    Note over G,SB: 게스트 카트 = stateless 계산 (영속 아님) ★돈확정1
    G->>SB: POST /guest/cart [post-guest-cart]<br/>[{cartNo(클라 임시·I-CART-1), productNo, optionNo, orderCnt, optionInputs[]}]
    SB-->>G: deliveryGroups[]+price{buyAmt..totalAmt}
    end

    rect rgb(255,245,245)
    Note over G,PG: 주문서 → 돈확정2 → 결제 (tempPassword)
    G->>SB: POST /order-sheets [post-order-sheet] (accessToken=null)<br/>{products[]={optionNo,orderCnt,productNo,recurringPaymentDelivery}, trackingKey?}
    SB-->>G: {orderSheetNo}
    G->>SB: POST /order-sheets/{no}/calculate [..calculate]<br/>{accumulationUseAmt, addressRequest{4필수}, couponRequest,<br/>shippingAddresses[]={..,payProductParams[]}}
    Note over SB: ★돈확정2 paymentInfo.paymentAmt (배송지·배송비 반영)
    G->>SB: POST /payments/reserve [post-payments-reserve]<br/>필수9{clientReturnUrl,member:false,orderSheetNo,orderer,<br/>payType,pgType,saveAddressBook,subPayAmt,updateMember}<br/>+tempPassword:'****'+paymentAmtForVerification(운영필수)
    Note over SB: ★검증 paymentAmtForVerification
    SB-->>G: {returnUrl, confirmUrl, key}
    G->>PG: 결제창
    PG-->>G: clientReturnUrl?result=SUCCESS&orderNo
    end

    rect rgb(245,255,245)
    Note over G,SB: 비회원 주문 조회 (tempPassword와 동일 자격)
    G->>SB: POST /previous-orders/guest/{orderNo} [get-previous-order-guest-token]<br/>body {password}(주문 비밀번호)
    SB-->>G: guestToken
    G->>SB: GET /guest/orders/{orderNo} [get-guest-orders-order-no] (guestToken 헤더)
    SB-->>G: 주문상세
    end
```

---

## 3. 외부회원 연동(ncpstore) 로그인 시퀀스 (후니 자체 회원 권위 시 — Aurora 근거)

```mermaid
sequenceDiagram
    autonumber
    actor U as 사용자
    participant FE as 후니 프론트
    participant HUNI as 후니 회원 시스템
    participant SB as Shopby auth

    U->>FE: 로그인 (후니 계정)
    FE->>HUNI: 인증 → 고객사 accessToken
    HUNI-->>FE: 고객사 accessToken
    FE->>SB: POST /oauth2/openid [post-oauth2-openid-token]<br/>{provider:ncpstore, openAccessToken:<고객사 token>}
    Note over SB: Shopby가 openAccessToken으로<br/>고객사 회원정보 조회 API 호출 → 회원 갱신
    SB-->>FE: Shopby accessToken (Shop-By-Authorization)
    Note over FE,SB: 이후 모든 Cart/Order/Pay 호출에 Bearer 사용
```

> 근거: `aurora 외부회원_연동 §2`. 고객사 회원정보 조회 API는 1:1 문의로 사전 등록(운영 선결).
> 채택 여부 = 인간 승인(I-AUTH-3). `post-oauth2-openid-token` raw body shape는 갭필 필요(I-AUTH-2).

---

## 4. trackingKey 흐름 (Aurora 추적 가이드 정합)

- 진입 URL에 trackingKey 포함 → **로그인 API query-string** + **주문서 작성 API body**에 추가
  (`aurora 추적_TrackingKey_가이드`).
- 주문서 바인딩: `post-order-sheet.trackingKey`(order-shop:21416-21419, string nullable) — commerce-flow §3.1 정합.
- 캠페인 통계까지 추적(카카오 친구톡·마이앱). 1차 통합에서 선택적.

---

## 5. 자기 점검

- [x] 회원/게스트 양 경로 종단 시퀀스 — 모든 단계 operationId 바인딩(§0 표).
- [x] **operationId 연결 검증(§0 하단)** — 출력→입력 연결 확인, **연결 0 끊김**. 단 "dead link 0"≠"필드 단위
  실현가능"임을 명시(R-8 정직성): 필수 필드 갭은 X07(recurringPaymentDelivery·I-OS-1)·X08(addressRequest)·
  X09(reserve 필수세트)로 분리 추적.
- [x] 가격 동기화(P-B) 단계를 시퀀스에 명시 — addPrice=final_price·salePrice=0(§4.2.1 불변식) → 이중계산 0.
- [x] #7 addressRequest(4필수)+payProductParams·#8 reserve 필수9 + paymentAmtForVerification(nullable·운영필수) 반영.
- [x] #10g guest-token = **POST /previous-orders/guest/{orderNo} + {password}**(method/body 정정, R-7).
- [x] 스펙 외 흐름(#9 결제확정·게스트 cartNo·일반주문 recurringPaymentDelivery shape)은 "모름"
  (I-PAY-1·I-CART-1·I-OS-1)으로 분리, 날조 0.
