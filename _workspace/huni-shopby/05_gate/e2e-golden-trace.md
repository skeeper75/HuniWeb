# e2e-golden-trace.md — 대표 구성 1건 종단 라운드트립 추적 (위젯→완료) · 재게이트 R2

> 산출자: hsb-integration-gate. 작성: 2026-06-25 (재게이트 2회차).
> 방법[HARD]: 대표 골든 1건을 위젯 핸드오프부터 결제까지 **각 단계의 실제 operationId·필수 필드를 스펙 라인으로
> 직접 확인**하며 라운드트립 실현가능성을 추적한다(문서 권위+라이브 갭필 수준 — 실호출 아닌 스펙 기반 추적·
> 라이브는 입력측 shape/행수만 읽기전용 SELECT 확인·주문/결제 submit 0). 생성자 인용 전재 0·미상 "모름".
> 비밀값 비노출. operationId 골격 끊김 / 필드 단위 실현가능성을 구분한다.

---

## 0. 골든 선정 (라이브 실재 — 게이트 직접 SELECT)

| 항목 | 값 (RAILWAY_DB read-only SELECT 2026-06-25) |
|------|------|
| prd_cd | **PRD_000016** |
| prd_nm | **프리미엄엽서** |
| del_yn | N (활성) |
| 가격공식 바인딩 | `t_prd_product_price_formulas` → **PRF_DGP_A** (디지털인쇄 원자합산형, 1건) |
| CPQ 옵션그룹 | `t_prd_product_option_groups` → **8개** (옵션선택 UI 가능) |
| 가격 산출 경로 | `evaluate_price(PRD_000016, selections, qty)` → final_price (`pricing.py:340·462·485`) |

> 선정 사유: 가격사슬 완전(공식 바인딩) + CPQ 옵션 적재(8그룹) = foundation §2 "✅ 가능" 카테고리(엽서). 위젯 자유
> 선택→원자합산 가격→카트 종단을 대표하기 적합(GREEN). 대표 구성(예시): 사이즈+도수+자재+후가공+수량 선택.

---

## 1. 종단 라운드트립 (단계별 operationId·필수 필드 — 스펙 직접 확인)

| # | 단계 | operationId·method | 입력(이전 출력 연결) | 필수 필드 (스펙 라인 직접 확인) | 출력→다음 |
|---|------|---------------------|----------------------|--------------------------------|-----------|
| 0 | 위젯 견적 | (BFF) `POST /price` | NormalizedPriceRequest | — | finalPrice |
| H | 핸드오프 | 위젯 `onCartHandoff` → BFF `POST /cart-handoff` | NormalizedCartHandoff{productCode=PRD_000016, selectedOptions, quantity, priceSnapshot.finalPrice, artifacts} | data-contract.md:230·api-contract.md:55 직접 확인 | BFF 어댑터 진입 |
| B | 가격 동기화 (P-B) | `put-product-options` **PUT**(server API) | mallProductNo + options[](대표 addPrice=0, 가격행 order≥2 addPrice=final_price) + inputs[] | systemKey·version **required:true**(`product-server-public.yml:1758·1789`)·base=server-api.e-ncp.com(`:7`)·schema products-options-915318368 | optionNo(가격행) |
| 1 | 장바구니 등록 | `post-cart` **POST** | [{productNo, optionNo(B), orderCnt, optionInputs[]=사양·원고}] | `cart-1115878954` required=`[optionNo, orderCnt, productNo]`(`order-shop-public.yml:32029-32033`)·**가격필드 0** | {count} |
| 3 | 금액 계산1 | `get-cart-calculate` **GET** | cartNo | (회원) — | {buyAmt, totalAmt} = salePrice(0)+addPrice(final_price)=동일값 |
| 4 | 구매가능 검증 | `get-cart-validate` **GET** | — | resp {result:bool}(`:1138`) | result=true → 진입 |
| 5 | 주문서 작성 | `post-order-sheet` **POST** | {products[]={optionNo, orderCnt, productNo, **recurringPaymentDelivery**}, cartNos[], trackingKey?} | `order-sheets-427257668` products[] required=`[optionNo, orderCnt, productNo, recurringPaymentDelivery]`(`:21436`) | {orderSheetNo} |
| 6 | 주문서 조회 | `get-order-sheet` **GET** | orderSheetNo | — | availablePayTypes, 주소, 금액 |
| 7 | 금액 계산2 (최종) | `post-order-sheets-order-sheet-no-calculate` **POST** | {accumulationUseAmt, **addressRequest**{receiverAddress, receiverContact1, receiverDetailAddress, receiverZipCd}, couponRequest, shippingAddresses[]} | `order-sheets-orderSheetNo-calculate177283610` required=`[accumulationUseAmt, addressRequest, couponRequest, shippingAddresses]`(`:28580`)·addressRequest 하위 4필수(`:28588`) | paymentInfo.paymentAmt |
| 8 | 주문 예약 | `post-payments-reserve` **POST** | 필수9{clientReturnUrl, member, orderSheetNo, orderer, payType, pgType, saveAddressBook, subPayAmt, updateMember} + paymentAmtForVerification=paymentAmt(nullable·운영필수) + tempPassword?(게스트) | `payments-reserve-2101669004` required 9(`:33000`)·paymentAmtForVerification nullable(`:33398`) | {returnUrl, confirmUrl, key} |
| 9 | PG 결제 | — (NCPPay 결제편의모듈) | returnUrl → PG | **스펙 외 — I-PAY-1 "모름"**(order-shop 별도 결제확정 POST 0·confirmUrl은 reserve 응답:4804에만) | clientReturnUrl?result=SUCCESS&orderNo |
| 10g | 게스트 주문 토큰 | `get-previous-order-guest-token` **POST**(이름만 get-) | path orderNo + body {password} | `:5304 post:`·example {"password":""}(`:5352`) | guestToken |

---

## 2. 가격 생존 추적 (PRICE≠0·이중계산 0 — 불변식 검증)

```
위젯 evaluate_price(PRD_000016, sel, qty) = final_price (>0, pricing.py:462 final_price=round_won(running) if ok)
        │  (라인 가격 입력 필드 부재 X02 — 6 yml grep 0건 직접 확인)
        ▼  유일 생존경로 = 등록가 동기화
[B] put-product-options: 대표옵션 addPrice=0 (첫 옵션 0 강제·product-server 8곳) / 가격옵션행(order≥2) addPrice=final_price
        │  불변식(§4.2.1): salePrice=0·즉시할인=0·추가할인=0·수량할인=0
        ▼
[1] post-cart {productNo, optionNo=가격옵션행, orderCnt}
        ▼
[3] cart/calculate = salePrice(0) + addPrice(final_price) = final_price        ← 이중계산 0 (재산출 동일값)
        ▼
[7] order-sheet/calculate (+addressRequest·배송비) → paymentInfo.paymentAmt     ← 배송지 반영 후 최종 금액
        ▼
[8] reserve paymentAmtForVerification = paymentAmt (anti-tamper)               ← 서버 재계산 불일치 시 거절
```

- **PRICE≠0 보존**: BFF가 `evaluate_price.ok=true && final_price>0`일 때만 동기화·진행. 0/None이면 차단
  (`pricing.py:462` None-on-fail + 메모리 huni-widget-red-price-never-zero). → 가격 0 라인이 카트로 안 감.
- **이중계산 0**: 가격이 addPrice 한 곳에만 살아있고 final_price는 이미 수량구간·할인 최종 반영. Shopby 즉시/추가/
  수량할인을 그 라인에 0으로 두면 재산출해도 동일값. 등급할인율 0행(게이트 라이브 SELECT 확인)으로 이중할인 위험 0.

---

## 3. dead link / 필드 갭 추적

- **operationId 연결 끊김 0** — B.optionNo→1.optionNo, 5.orderSheetNo→6/7/8, 7.paymentAmt→8.paymentAmtForVerification,
  8.returnUrl→9, 9.orderNo→(게스트)10g. 각 출력이 다음 입력으로 연결됨(게이트 §1 표 스펙 라인 확인).
- **필드 단위 실현가능성 — 직전 R1 CONDITIONAL 해소** — #5(recurringPaymentDelivery)·#7(addressRequest)·#8(reserve
  필수9)이 e2e §0 표에 반영됨(게이트가 스펙 라인 직접 재확인 — gate-verdict §1.2). 즉 "골든을 그대로 실행해도 필수
  필드 결손으로 깨지던" 직전 문제 해소.
- **스펙 외 정직 분리(날조 0)**: #9 결제 확정 콜백(I-PAY-1)·일반주문 recurringPaymentDelivery 빈값 shape(I-OS-1)·
  게스트 cartNo(I-CART-1)는 "모름". 라인 구조화 파일 메타(thumbnail/pageCount 객체)는 I-FILE-1 — 현재는 식별자
  텍스트(optionInputs)로만 무손실 전달.

---

## 4. 게이트가 직접 확인 못한 것 (라이브/위젯 실호출 — §6 위임·인간 승인 후)

| ID | 미검증 | 사유 | 검증 주체 |
|----|--------|------|----------|
| **VP-X03** | 별행(order≥2) addPrice>0 옵션이 put-product-options로 실제 등록·심사 통과·즉시 노출되는가 | example은 단일 옵션 addPrice=0만 보임. 라이브 server API 쓰기 = 파괴적(게이트 금지) + 상품심사(I-PRICE-1 BLOCKED) | §6 / 인간 승인 후 라이브 |
| **I-VERIFY-1** | PRD_000016 strict 실호출 final_price>0 실제 산출 | 게이트는 공식 바인딩·옵션그룹 존재만 라이브 확인. evaluate_price 실호출은 위젯 어댑터 영역 | §6 huni-widget |
| **I-PRICE-1/2/3** | P-B 심사 재승인·정산 권위·동시성/청소/추적성 | 라이브 admin 쓰기/심사 흐름·정산 문서 미확보(BLOCKED 관문) | 갭필 + 인간 승인 |

> ★ 골든 1건 종단 추적 결론: **operationId 골격 끊김 0 + 필수 필드 갭 보정 반영 + 가격 생존 경로(불변식) 스펙상
> 실현가능 + 골든 라이브 실재** → SB3 PASS. 단 실 구현 전 VP-X03·I-PRICE-1/2/3이 닫혀야 함(CONDITIONAL).
