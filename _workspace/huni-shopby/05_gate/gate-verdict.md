# gate-verdict.md — SB1~SB7 독립 검증 게이트 판정 (생성≠검증) · 재게이트 R2

> 산출자: hsb-integration-gate (검증). 작성: 2026-06-25 (재게이트 2회차, 보정 루프 후).
> 방법[HARD]: architect 설계(`03_design/`)·codex reconcile(`04_codex/`)의 모든 계약 주장을 **그대로 믿지 않고**
> 실제 Shopby OpenAPI 스펙(`docs/shopby/shopby-api/*.yml`) operationId·필드 단위로 직접 재대조 + 라이브 DB
> 읽기전용 SELECT + `pricing.py` 계약 재확인 + 위젯 정규화 계약 대조. 모든 "verified"는 게이트가 스펙 라인을
> 직접 연 결과(생성자/codex 인용 전재 0).
> 권위 순서: Shopby OpenAPI 스펙 1차 → enterprise/Aurora → 라이브 갭필. 추정 0·미상 "모름".
> 비밀값(.env.local 값·clientId·토큰·systemKey 값)은 키 이름만, 값 비노출.

---

## 0. 최종 판정 — **GO (CONDITIONAL)**

> **직전 NO-GO(R1)의 8개 FAIL 드라이버(X03·X04·X05·X07·X08·X09·X10·X11)가 설계 본문에 전부 보정 반영됐고,
> 게이트가 그 보정을 그대로 믿지 않고 실제 스펙 라인으로 직접 재대조한 결과 전부 verified(반증 0)다.** SB1~SB7
> 단일 FAIL 없음 → **GO**. 단 **CONDITIONAL** — 가격 메커니즘(전략 D/P-B)의 결정적 운영 관문 3개(I-PRICE-1
> 상품심사·I-PRICE-2 정산 권위·I-PRICE-3 동시성/잔존청소/클레임 추적/server API 격리)가 **여전히 BLOCKED**다.
> 이 BLOCKED는 설계가 **추정으로 메우지 않고 정직하게 분리**했으므로 게이트 결함이 아니라 **인간 승인·갭필 선결**
> 사항이다. 즉 **설계는 검증 통과(GO)이나, 실 구현 착수 전 BLOCKED 관문이 닫혀야** 한다(전건 GO 아닌 CONDITIONAL).
>
> ★ 재게이트 핵심 — 직전 NO-GO 항목 해소 여부 우선 확인 결과: **8건 전부 해소**(스펙 라인 직접 재확인). 신규
> FAIL 적발 0. 게이트가 독립 재실측 중 토대 행수 104(공식78∪직접단가26)·골든 PRD_000016(공식 PRF_DGP_A·
> 옵션그룹8)·라인 가격필드 0건을 라이브/스펙으로 직접 확인 — 설계 정량 주장 드리프트 0.

| 게이트 | 판정 | 한 줄 |
|--------|:----:|------|
| **SB1** 커머스 흐름 충실성 | **PASS** | operationId 8개 실재 + 직전 FAIL 드라이버(X07/X08/X09/X10) 필수 필드가 설계 본문에 반영됨을 스펙 라인으로 직접 재확인 |
| **SB2** 브리지 무손실 | **PASS** | 라인 가격필드 0건(등록가 동기화 유일경로) 재확인 + X03 불변식(salePrice=0·첫옵션0·별행)·X05 인증분리 설계 반영 확인. 토대 104 라이브 일치 |
| **SB3** 종단 e2e 추적 | **PASS** | 골든 PRD_000016 라이브 실재(공식·옵션그룹8) + 종단 operationId 골격 끊김 0 + 필수 필드 갭이 e2e §0 표에 반영됨(필드 단위 실현가능 확인) |
| **SB4** 인증/세션 정합 | **PASS** | Shop API(Shop-By-Authorization·게스트 무토큰) + X05 server API(systemKey) 분리가 설계 §1.1에 반영. oauth2 raw shape 부재(I-AUTH-2)는 정직 갭(스펙 직접 grep 0건) |
| **SB5** 전략 권고 건전성 | **PASS** | 전략 D/P-B 트레이드오프 스펙 근거 인용·BLOCKED 관문(I-PRICE-1/2/3) 정직 표기·하이브리드 마이그레이션(A→D) 대안 명시. 은폐 0 |
| **SB6** codex reconcile 수렴 | **PASS** | codex 11건(X01~X11) 게이트 직접 재판정 — 8 결함 verified·false-positive 2(설계 옳음)·BLOCKED 1. 보정 반영분 재확인. 미해결 명시·pending 위장 0 |
| **SB7** 생성≠검증 독립성 + 무날조 | **PASS** | 게이트가 모든 핵심 claim을 스펙 라인·라이브 SELECT로 직접 재실측(§8 증거표). 미상은 "모름". 생성자 인용 전재 0 |

---

## 1. SB1 — 커머스 흐름 충실성 : **PASS**

### 1.1 operationId·엔드포인트 존재 (게이트 직접 grep)
**존재하지 않는 엔드포인트 0**:

| operationId | 스펙 라인(직접 확인) | 판정 |
|-------------|------|:---:|
| `post-cart` | `order-shop-public.yml:679` | ✅ 실재 |
| `post-guest-cart` | `:1272` | ✅ 실재 |
| `get-cart-calculate` | `:820` | ✅ 실재 |
| `get-cart-validate` | `:1138` | ✅ 실재 |
| `post-order-sheet` | `:3789` | ✅ 실재 |
| `post-order-sheets-order-sheet-no-calculate` | `:4063` | ✅ 실재 |
| `post-payments-reserve` | `:4703` | ✅ 실재 |
| `get-previous-order-guest-token` | `:5309`(operationId)·**method=POST `:5304`** | ✅ 실재(이름만 get-, 실제 POST) |
| `put-product-options` | `product-server-public.yml:1756` | ✅ 실재(server API) |

### 1.2 직전 FAIL 드라이버(필수 필드) 보정 반영 — 스펙 라인 직접 재확인

| ID(직전 NO-GO) | 직전 결함 | 설계 보정 위치 | 게이트 스펙 직접 재확인 | 해소 |
|----|------|---------|---------|:---:|
| **X07** | products[] 필수 `recurringPaymentDelivery` 누락 | e2e §0 #5 입력에 명시 + I-OS-1 갭필 분리 | `order-shop-public.yml:21436` products[] required=`[optionNo, orderCnt, productNo, recurringPaymentDelivery]` 직접 확인. order-sheet 라인 schema `order-sheets-427257668:21397`도 동형 | ✅ |
| **X08** | calculate 필수 `addressRequest` 누락 | e2e §0 #7 입력에 `addressRequest{4필수}`+payProductParams 명시 | `:28580` `order-sheets-orderSheetNo-calculate177283610` required=`[accumulationUseAmt, addressRequest, couponRequest, shippingAddresses]`·addressRequest 하위 required=`[receiverAddress, receiverContact1, receiverDetailAddress, receiverZipCd]`(`:28588`) 직접 확인 | ✅ |
| **X09** | reserve 필수 9중 4 누락·검증액 과인식 | e2e §0 #8 + widget-cart-contract §6.1에 필수9 전체 + paymentAmtForVerification "스펙 nullable·운영필수" 구분 | `:33000` `payments-reserve-2101669004` required 9=`[clientReturnUrl, member, orderSheetNo, orderer, payType, pgType, saveAddressBook, subPayAmt, updateMember]`·`paymentAmtForVerification:nullable:true`(`:33398`·required 아님) 직접 확인 | ✅ |
| **X10** | guest-token method/body 오기 | e2e §0 #10g·§2를 `POST /previous-orders/guest/{orderNo}`+{password}로 정정 | `:5304 post:`·requestBody example `{"password":""}`(`:5352`) 직접 확인 | ✅ |

> ★ 판정: 엔드포인트 존재 0결손 + 직전 FAIL의 4개 필수 필드 갭이 설계 본문에 정확히 반영됨(게이트가 스펙 라인
> 직접 재확인). "모든 단계가 req shape과 필드 단위 일치"라는 SB1 정의 충족 → **PASS**. 잔여 갭(I-OS-1 일반주문
> recurringPaymentDelivery 빈값 shape·I-PAY-2 subPayAmt 산식)은 설계가 갭필로 정직 분리(추정 0).

---

## 2. SB2 — 브리지 무손실 (PRICE≠0·이중계산 0) : **PASS**

### 2.1 큰 전제 독립 재확인 (= 옳음)
- **라인 임의 단가 필드 부재 (X02)** — 게이트 직접 grep: 6개 yml 전체 `customPrice`/`priceOverride`/`orderPrice`
  **0건**. post-cart 스키마 `cart-1115878954`(`order-shop-public.yml:32025-32070`) required=`[optionNo, orderCnt,
  productNo]`·properties는 baseProductNo/groupId/orderCnt/optionInputs/optionNo/productNo만(가격필드 0) 직접 확인.
  → "계산가 생존 유일경로=등록가(addPrice) 동기화" 전제 verified.
- **라이브 토대 무손실 입력측 실재 (드리프트 0)** — 게이트 읽기전용 SELECT(2026-06-25):

  | 항목 | 게이트 SELECT 값 | 설계 §7 주장 | 판정 |
  |------|:---:|:---:|:---:|
  | `t_prd_products` (del_yn='N') | **275** | 275 | ✅ |
  | 가격소스 보유 prd (공식78 ∪ 직접단가26) | **104** | 104 | ✅ (둘 다 직접 union으로 재확인) |
  | └ 공식 바인딩 `t_prd_product_price_formulas` | **78 prd**(orphan 0·deleted 0) | — | ✅ |
  | └ 직접단가 `t_prd_product_prices` | **26행/26 prd** | — | ✅ |
  | CPQ 옵션그룹 prd | **51**(148행) | 51 | ✅ |
  | CPQ 제약 prd | **8**(10행) | 8 | ✅ |
  | 등급할인율 행 `t_dsc_grade_discount_rates` | **0** | 0 | ✅ (Shopby 할인=0 권장 정합·이중할인 위험 0) |
  | 셋트 행 / 부모 | **28 / 7** | 28 / 7 | ✅ |

  → evaluate_price 출력 shape `pricing.py:462`(`final_price=round_won(running) if ok else None`)·`:485` return
  직접 확인. evaluate_set_price `:718`·`:816`·`:825` 실재. PRICE≠0/None 계약 실재.

### 2.2 직전 FAIL(X03·X05) 보정 반영 — 스펙 라인 직접 재확인

- **[X03] 가격 불변식 명문화** — 직전 FAIL "salePrice=0 불변식 미명문(돈크리)". 보정: `integration-architecture
  §4.2.1`·`widget-cart-contract §4.0`에 불변식 표 명문화(salePrice=0·즉시/추가/수량할인=0·addPrice=final_price·
  **첫(대표) 옵션 addPrice=0 → 가격은 별 옵션행 order≥2**). 게이트 스펙 직접 재확인:
  - product-shop-public.yml 금액모델(`:791-804`): "옵션 있는 상품 = 판매가 + 옵션가", "판매가에 즉시할인 적용된
    가격 + 옵션가", **"옵션가격에서 즉시 할인이 적용되는 것이 아님"**(`:799-800`) — salePrice≠0이면 즉시할인이
    salePrice에만 적용되는 비대칭 → `salePrice+addPrice ≠ final_price` 과금오류. 불변식 salePrice=0이 정확히 이를 제거.
  - **첫 옵션 addPrice=0 제약은 스펙에 8곳**(`product-server-public.yml:9504,11646,13273,14567,16495,16846,17536,19438`).
    설계는 5곳 인용(과소 인용이나 결론 동일). 설계의 "가격=별 옵션행(order≥2)" 구조가 이 제약과 충돌 회피 — 정당.
  → X03 보정 verified(돈크리 해소). **단 잔여 검증 포인트(VP-X03)**: put-product-options example은 단일 옵션
    addPrice=0만 보임 — "별행(order≥2)에 addPrice>0 등록이 실제 허용·심사 통과"는 라이브 미검증(I-PRICE-1로 흡수).
- **[X05] server API 인증 분리** — 직전 FAIL "put-product-options 인증 미분리(고객 critical path 인라인)". 보정:
  `integration-architecture §1.1`(경계도+두 클라이언트)·`widget-cart-contract §4.1`. 게이트 스펙 직접 재확인:
  - `put-product-options`(`product-server-public.yml:1756`) base=`server-api.e-ncp.com`(`:7`) — 고객 Shop API
    `shop-api.e-ncp.com`와 별개. `systemKey`(header, **required:true**)·`version`(required:true)·Authorization
    required:false 직접 확인. 설계가 Shop API 클라이언트(고객 토큰)와 server API 클라이언트(systemKey)를 명시 분리·
    실패 격리/레이트/동시성 가드를 §4.4/I-PRICE-3에 추가. → X05 보정 verified(인증 모델 결함 해소).

> ★ 판정: 무손실 경로 스펙상 성립(전제 옳음) + 직전 FAIL의 불변식(X03)·인증분리(X05)가 설계 본문에 반영됨
> (게이트 스펙 직접 재확인) → SB2 PASS. 단 **불변식의 실 통과(별행 addPrice>0 심사·노출)는 I-PRICE-1 BLOCKED**
> (라이브 미검증)이므로 실 구현 전 닫혀야 함(CONDITIONAL 사유).

---

## 3. SB3 — 종단 e2e 추적 : **PASS**

대표 골든 1건 = **PRD_000016 프리미엄엽서**. 게이트 라이브 재실측: 공식 바인딩 **PRF_DGP_A**(디지털인쇄 원자합산형)
1건 + CPQ 옵션그룹 **8**개. 상세 라운드트립은 `e2e-golden-trace.md` 참조.

- **operationId 골격 끊김 0** — 위젯 `onCartHandoff`(data-contract.md:230 NormalizedCartHandoff 직접 확인) → BFF
  `/cart-handoff`(api-contract.md:27·55-57 `{ok, redirectUrl?}`·UNDECIDED 직접 확인) → put-product-options(B) →
  post-cart(1) → cart/calculate(3) → cart/validate(4) → post-order-sheet(5) → get-order-sheet(6) → calculate(7) →
  reserve(8) → PG(9). 각 출력→다음 입력 연결(B.optionNo→1.optionNo, 5.orderSheetNo→6/7/8, 7.paymentAmt→
  8.paymentAmtForVerification).
- **필드 단위 실현가능성 — 직전 CONDITIONAL 해소** — 직전 R1에서 #5/#7/#8 필수 필드 결손으로 CONDITIONAL이었으나,
  보정으로 e2e §0 표에 recurringPaymentDelivery(#5)·addressRequest(#7)·reserve 필수9(#8)가 반영됨(게이트가 §1.2/§2.2
  에서 스펙 라인 직접 재확인). #9(결제 확정 콜백)는 스펙 외(I-PAY-1) 정직 분리(order-shop에 결제확정 POST 부재 직접
  재확인 — confirmUrl은 reserve 응답에만, `:4804`).

> ★ operationId 골격 끊김 0 + 필수 필드 갭 보정 반영 + 골든 라이브 실재 → SB3 PASS. 상품별 실견적 0원 여부
> (I-VERIFY-1)는 위젯 strict 실호출 영역(§6 위임)으로 정직 분리.

---

## 4. SB4 — 인증/세션 정합 : **PASS**

- **Shop API 세션 모델(직접 확인)** — `Shop-By-Authorization` 헤더 광범위 실재(order-shop 다수 grep). post-cart
  헤더에 Shop-By-Authorization/accessToken 둘 다 required:false(게스트는 무토큰 `post-guest-cart`·`member:false`+
  tempPassword reserve). 회원/게스트 분기 스펙 정합.
- **X05 server API 인증 분리 반영** — 직전 CONDITIONAL의 인증 결함이 §1.1 두 클라이언트 분리로 해소(§2.2 X05 참조).
  BFF는 Shop API 클라이언트(고객 토큰)와 server API 클라이언트(systemKey)를 분리. → 인증 모델 결함 해소.
- **[I-AUTH-2] oauth2 raw shape 부재 (정직 갭, 게이트 직접 grep)** — `oauth2` operationId/path **0건**(단어로는
  display/member/product-shop에 등장하나 path/operationId 없음). 설계의 "post-oauth2-token requestBody shape 모름"은
  날조 아닌 정직 갭. **보강 관찰**: 외부회원 연동 raw shape 일부는 `member-shop-public.yml:2409·2447`(openAccessToken
  활용 회원확인)에 실재 — 설계 I-AUTH-2가 약간 보수적이나(과소 표기) 추정/날조 0 원칙 위배 없음(안전 방향).

> ★ Shop API 세션 모델 정합 + X05 분리 반영 + 갭(oauth2 raw)은 정직 분리 → SB4 PASS. 운영방식(I-AUTH-1 headless)·
> 외부회원(I-AUTH-3)은 인간 승인 선결.

---

## 5. SB5 — 전략 권고 건전성 : **PASS**

- 전략 D(혼합: 노출=A 동기화 + 가격=P-B 직전 동적생성) 권고가 `bridge-strategy-options §2` 5축 표 인용 근거 기반.
  순수 직접주입(C)·컨테이너(B) 단독 탈락(라인 가격 필드 0건)이 게이트 SB2 재확인과 일치(스펙 근거 견고).
- **BLOCKED 관문 정직 표기(은폐 0)** — I-PRICE-1(상품심사 재심사)·I-PRICE-2(정산 권위)·I-PRICE-3(동시성/잔존청소/
  클레임 추적 X11/server API 격리)을 인간 승인·갭필 전 **진행 불가 BLOCKED**로 명시(open-issues §A). "채택 완료" 위장 0.
- 마이그레이션 대안 명시 — I-PRICE-1 NO 시 전략 A(고정가·소조합 사전 동기화 P-A)로 회귀, 위젯·BFF 정규화 계약
  무변경(어댑터 내부 선택). 상품군별 하이브리드(고정가=A·연속/매트릭스=D)(§2.3·§2.4). 등급할인 0행(게이트 라이브
  확인)으로 Shopby 할인=0 권장이 이중할인 위험 0 정합.
- **정량 주장 검증(SB5/SB7 교차)** — 게이트가 토대 104(78+26)·골든 옵션그룹8을 라이브로 직접 union 재확인 →
  설계 정량 권고(GREEN 우선 104상품·CPQ 51상품)가 라이브 근거 기반(드리프트 0).

> ★ 트레이드오프 스펙 근거·미해결 정직 표기·대안·정량 근거 모두 충족 → SB5 PASS.

---

## 6. SB6 — codex reconcile 수렴 : **PASS**

게이트가 codex 11건(X01~X11, `04_codex/codex-findings.md`·`reconcile.md`)을 **직접 재판정**(reconcile 인용 전재 아님):

| codex ID | 게이트 직접 재확인 | 판정 |
|----------|------|:---:|
| X02·X01 (라인 가격 필드 부재·channelType member schema 부재) | grep 0건·`cart-1115878954` channelType 부재 직접 확인 | ✅ 합의(설계 옳음·보정 R-9 반영) |
| X03 (salePrice=0 불변식·첫 옵션 0) | product-shop 금액모델 `:799-800` + product-server 8곳 "첫 옵션 0" 직접 확인 | ✅ 합의·보정 §4.2.1 반영 |
| X04 (put-product-options full shape) | `products-options-915318368` example options[]/inputs[] 직접 확인 | ✅ 합의·보정 widget-cart §4.2 반영 |
| X05 (server API systemKey) | `:1756-1815` systemKey required·server-api base 직접 확인 | ✅ 합의·보정 §1.1 반영 |
| X07 (recurringPaymentDelivery) | `:21436` required 직접 확인 | ✅ 합의·보정 e2e #5 반영 |
| X08 (addressRequest) | `:28580` required 직접 확인 | ✅ 합의·보정 e2e #7 반영 |
| X09 (reserve 9필수·paymentAmtForVerification nullable) | `:33000`·`:33398` 직접 확인 | ✅ 합의·보정 e2e #8 반영 |
| X10 (guest-token POST+password) | `:5304 post:`·`:5352 {password}` 직접 확인 | ✅ 합의·보정 e2e #10g 반영 |
| X06·X11 (P-B 심사 BLOCKED·청소↔클레임 추적 충돌) | judgement BLOCKED + claim 스냅샷(orderOptionNo·claimedOptions) 직접 확인 | ✅ 합의(X11 I-PRICE-3 격상 반영) |

- **불일치 0·codex false-positive(정당설계 오판) 0** — codex 신뢰도 높음. codex "모름" 5건 중 4건 설계 분리 일치,
  1건(클레임 추적성 X11)은 신규 격상돼 I-PRICE-3에 병합(reconcile 라우팅 정확).
- 보정 반영분(X03~X10 8건)이 설계 본문에 들어갔음을 게이트가 스펙 라인으로 재확인 → 수렴 입증. pending 위장 0 → PASS.

---

## 7. SB7 — 생성≠검증 독립성 + 무날조 : **PASS**

- 게이트는 모든 핵심 claim을 **생성자/codex 인용 없이 스펙 라인·라이브 SELECT·pricing.py로 직접 재실측**(§8 증거표).
- **독립 재실측이 잡은 것** — 게이트가 초기에 가격소스를 78(공식만)로 보고 104 드리프트를 의심했으나, 직접단가
  테이블 `t_prd_product_prices`(26 prd)를 추가 union해 **104를 라이브로 직접 재확인**(게이트 자체 누락 정정). 이는
  생성자 주장을 의심하고 끝까지 라이브로 판정하는 SB7 독립성의 실증(설계 104는 정확).
- 미상은 "모름" 유지 — I-AUTH-2(oauth2 부재)·I-PAY-1(결제 확정 콜백)·I-CART-1(게스트 cartNo)·I-FILE-1(라인
  구조화 첨부)·I-OS-1(일반주문 recurringPaymentDelivery 빈값)을 게이트가 추정으로 메우지 않음(스펙 grep로 부재 확인).
- 날조 0 → PASS.

---

## 8. 게이트 직접 재실측 증거표 (생성자 인용 전재 0)

| 검증 항목 | 게이트가 직접 연 근거 | 결과 |
|-----------|---------------------|------|
| operationId 8개 존재·라인 | order-shop grep(post-cart:679/guest-cart:1272/calc:820/validate:1138/order-sheet:3789/oscalc:4063/reserve:4703/guest-token:5309) | 전부 실재 |
| post-cart 스키마 required·가격필드 | `order-shop-public.yml:32025-32070` (cart-1115878954) | required=optionNo/orderCnt/productNo·가격필드 0 |
| 라인 가격 필드 전수 | 6개 yml grep customPrice/priceOverride/orderPrice | 0건 |
| X03 금액모델·즉시할인 비대칭 | `product-shop-public.yml:791-804` | "옵션가격에서 즉시 할인이 적용되는 것이 아님"(799-800) |
| X03 첫 옵션 0 | `product-server-public.yml:9504,11646,13273,14567,16495,16846,17536,19438` | "첫 옵션가 추가금 0" 8곳(설계 5곳 인용·과소) |
| X04/X05 put-product-options | `product-server-public.yml:1756-1815` + schema products-options-915318368 | systemKey/version required·server-api base·options[]/inputs[] full |
| X07 recurringPaymentDelivery | `order-shop-public.yml:21436`·order-sheets-427257668:21397 | products[] required(cart 동형) |
| X08 addressRequest | `:28580-28598` | calculate required·addressRequest 하위 4필수 |
| X09 reserve 필수·검증액 nullable | `:33000-33010`·`:33398` | 9 required·paymentAmtForVerification nullable |
| X10 guest-token | `:5304 post:`·`:5352 {password}` | POST+password body |
| X11 claim 스냅샷 | `claim-shop-public.yml:86-87,147` | claimedOptions[].orderOptionNo·orderProductOptionNo 실재 |
| oauth2 부재 (I-AUTH-2) | 6개 yml grep oauth2 operationId/path | 0건(정직 갭) |
| 결제 확정 POST 부재 (I-PAY-1) | order-shop grep confirmUrl/결제확정 | reserve 응답 confirmUrl(:4804)만·별도 확정 POST 0 |
| evaluate_price 출력 | `pricing.py:340,462,485` | shape 일치·final_price None-on-fail |
| evaluate_set_price | `pricing.py:718,816,825` | 실재·final_price None-on-fail |
| 라이브 토대 행수 | RAILWAY_DB read-only SELECT (2026-06-25) | 275/104(78공식∪26직접단가)/51/8/0/28·7 — 드리프트 0 |
| 골든 PRD_000016 | RAILWAY_DB SELECT | 공식 PRF_DGP_A·옵션그룹 8·del_yn=N — 실재 |
| 위젯 핸드오프 계약 | `huni-widget/03_spec/data-contract.md:230`·`api-contract.md:27,55-57` | NormalizedCartHandoff·{ok,redirectUrl?}·UNDECIDED 실재 |

---

## 9. 결론·다음

- **GO (CONDITIONAL)** — 직전 NO-GO의 8 FAIL 드라이버(X03~X11) 전부 보정 반영·게이트 스펙 직접 재확인 verified.
  SB1~SB7 단일 FAIL 0. 신규 결함 적발 0. 토대·골든·스펙 드리프트 0.
- **CONDITIONAL 사유 (실 구현 착수 전 닫혀야 할 BLOCKED 관문 — 설계가 정직 분리, 게이트 동의)**:
  - **I-PRICE-1**(P-B 동적 옵션 상품심사 재승인 여부) — NO면 전략 A(P-A 사전 동기화)로 마이그레이션(설계 §2.3).
  - **I-PRICE-2**(정산이 라인 salePrice/addPrice 권위로 쓰는지) — 정산/클레임 가격 권위 미확정.
  - **I-PRICE-3**(동시성·잔존 청소·**클레임 추적 X11**·server API 격리·노출 지연) — immutable 옵션 정책(주문 후
    삭제 금지·useYn=N만) 인간 승인 필요.
- **갭필 큐**(docs.shopby.co.kr, WebFetch 읽기전용·부족분만): I-AUTH-2(auth OpenAPI)·I-PAY-1(결제편의모듈)·
  I-PAY-2(subPayAmt 산식)·I-OS-1(일반주문 recurringPaymentDelivery 빈값)·I-CART-1(게스트 cartNo).
- **잔여 검증 포인트(라이브/위젯 실호출 — §6 위임·인간 승인 후)**: VP-X03(별행 addPrice>0 심사·노출 통과)·
  I-VERIFY-1(상품별 strict final_price>0 실비율)·I-VERIFY-3(셋트 7부모 evaluate_set_price PRICE≠0).
- **실 구현/연동은 인간 승인 후 §6 huni-widget 트랙 위임**(게이트는 검증·교정명세까지·DB 미적재·라이브 읽기전용).
  자세한 교정/라우팅/승인 큐는 `remediation-spec.md`.
