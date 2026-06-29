# reconcile.md — Claude 설계 vs Codex 독립 발견 대조 (합의·불일치·false-positive + 라우팅)

> 산출자: hsb-codex-verifier. 작성: 2026-06-25.
> 방법: codex 발견(가설)을 Claude 설계 산출(`03_design/`·`02_bridge/`)과 대조하고, **각 항목을 Claude가 Shopby
> 스펙으로 직접 재확인(verified)** 했다. ★codex 주장=가설 — "스펙으로 확인 가능?" 열에 verified/반증/모름을 명시.
> 권위 순서: Shopby OpenAPI 스펙 1차 → enterprise 문서 → 라이브 갭필. 추정 0·날조 0.
> ★ 총평: codex 11개 발견 전부 스펙 라인으로 verified(반증 0). 돈크리티컬 결함 2건(X03·X05)이 핵심 — 설계가
> 큰 그림(라인 가격 필드 부재·등록가 재산출)은 옳으나 **adapter 구현 계약 수준에서 채워지지 않은 결함**이 다수.

---

## 0. 한눈에 — 판정 분포

| 판정 | 건수 | ID |
|------|:---:|----|
| **합의(고신뢰·verified)** — 결함/누락이 실재 | 8 | X03·X04·X05·X07·X08·X09·X10·X11 |
| **합의 — false-positive(설계가 옳음을 codex도 확인)** | 2 | X01·X02 |
| **합의 — 이미 설계가 BLOCKED로 분리(중복 확인)** | 1 | X06 |
| **불일치(조사 필요)** | 0 | — |
| **codex false-positive(정당 설계 오판)** | 0 | — |

> ★ codex가 정당한 설계를 결함으로 오판한 사례 0. 대신 codex 스스로 X01·X02를 "false-positive 후보"로 표기해
> 설계 전제가 옳음을 독립 확인 — 이는 설계의 큰 전제(라인 가격 필드 부재)에 대한 **2nd opinion 고신뢰 합의**.

---

## A. 합의 — 결함/누락 실재 (verified, 교정 필요)

### A-1. **[X03] `addPrice=final_price`는 `salePrice=0` 전제·첫 옵션 addPrice=0 강제 없으면 과금 오류 — 돈크리티컬 HIGH**
- **codex 주장**: salePrice≠0이면 `salePrice+addPrice ≠ final_price`로 과금 오류. 게다가 첫 옵션가는 addPrice=0 강제.
- **Claude 스펙 재확인 = verified(돈크리티컬)**:
  - `product-shop-public.yml:3816` — 옵션 있는 상품가 = `salePrice + addPrice`(M-PRICE-1, 설계도 인용).
  - `product-server-public.yml:16844` — **"옵션 추가 가격(첫 옵션가는 반드시 추가금이 0이여야 합니다)"** (직접 재확인).
  - 설계 `integration-architecture.md:226·230` — 다이어그램 노트 "salePrice + addPrice = final_price"는 **salePrice=0일 때만 성립**.
    설계 본문 §4.2는 `addPrice=final_price', salePrice=0 또는 기준`으로 표기 — "또는 기준"이 모호(salePrice≠0 허용 여지).
- **판정**: **합의·실재 결함**. 설계가 의도는 맞으나(등록가=후니가) **수식 불변식이 명문화 안 됨**. P-B 동적 옵션을
  "신규 옵션(첫 옵션)"으로 만들면 첫 옵션 addPrice=0 강제와 충돌 → 별도 옵션행 구조 필요.
- **라우팅 → architect**: §4.2를 **불변식으로 확정** — ① 컨테이너/대표상품 `salePrice=0` 고정 + addPrice=final_price,
  또는 ② `addPrice = final_price − effectiveSalePrice`(salePrice 보존 시). 첫 옵션 addPrice=0 제약을 P-B 옵션행
  생성 규칙에 반영(대표 옵션은 0, 가격 옵션은 별행). gate(SB2)가 골든 e2e 재계산으로 `최종 청구액 = final_price` 검증.

### A-2. **[X04] `put-product-options` 의사코드가 실제 request shape 아님 — HIGH(구현 계약)**
- **codex 주장**: 설계 `putProductOptions({mallProductNo, addPrice})`는 틀림. 실제는 `{mallProductNo, options:[{...,addPrice}], inputs:[...]}`.
- **Claude 스펙 재확인 = verified**:
  - `product-server-public.yml:1795·16796` — body = `{mallProductNo, options:[{item, optionType, optionName, optionValue,
    order, addPrice, useYn, optionSelectType, optionManagementCd, ...}], inputs:[{mallProductInputNo, inputText,
    inputMatchingType, useYn, required}]}`. 응답 = `{mallProductNo, mallProductOptionNos:[...]}` (`:1817`).
- **판정**: **합의·실재**(단 설계 §4 의사코드는 "BFF 내부 의사코드"로 명시 — 완전 계약 아님). codex 지적은 정당:
  P-B를 구현 계약으로 격상하려면 option row 전체 필드를 채워야 함(addPrice만으론 옵션 생성 불가).
- **라우팅 → architect**: P-B 계약(`product-price-bridge-spec` 또는 widget-cart-contract §4)에 `put-product-options`
  **완전 payload shape**(optionName/optionValue/optionType/order/stockCnt/useYn/optionManagementCd/mallOptionNo)를
  명시. mallOptionNo=0(신규) vs 기존값(수정) 분기 규칙도. **단 이는 설계→구현 상세화이지 큰 전제 오류 아님**.

### A-3. **[X05] put-product-options 인증이 Shop API 흐름과 다름(server API systemKey) — HIGH(아키텍처)**
- **codex 주장**: e2e 공통 헤더는 `Shop-By-Authorization`인데 put-product-options는 server API라 `systemKey`+`version` required.
- **Claude 스펙 재확인 = verified(아키텍처 결함)**:
  - `product-server-public.yml:1758` — `systemKey`(header, **required:true**, 앱 기준 발급), `version`(required:true),
    `Authorization`/`mallKey`(required:false 대안). base url=`server-api.e-ncp.com`(:7) — **고객 Shop API(`shop-api`)와 별개**.
  - e2e `e2e-sequences.md:48` 공통 헤더는 `Version/clientId/platform + Shop-By-Authorization: Bearer <token>`(고객 토큰).
- **판정**: **합의·실재 결함**. 설계가 put-product-options를 **고객 주문 critical path에 인라인**(§4.2·시퀀스 ③)하면서
  인증 모델 차이를 누락. BFF는 **server API 시스템 자격(systemKey, 관리자급)** 으로 별도 호출해야 함 — 이는 고객
  요청마다 관리자 권한 server 호출이 끼는 구조라 보안·레이트·실패격리 설계가 필요(설계 미반영).
- **라우팅 → architect**: §1 경계도/§4에 **server API 클라이언트(systemKey)** 를 Shop API 클라이언트와 분리 명시.
  systemKey 보관(.env.local·BFF만)·실패 격리·동시성을 §4.4/open-issues에 추가. 비밀값=키 이름만(노출 금지).

### A-4. **[X07] `post-order-sheet.products[]` 필수 `recurringPaymentDelivery` 누락 — MEDIUM**
- **codex 주장**: products[] required에 recurringPaymentDelivery 포함인데 e2e §0 입력에서 빠짐. "dead link 0" 주장 과함.
- **Claude 스펙 재확인 = verified**: `order-shop-public.yml:21436` — products[] `required: [optionNo, orderCnt, productNo, recurringPaymentDelivery]`(직접 재확인).
- **판정**: **합의·부분**. 설계는 **이미 I-OS-1로 분리**(open-issues.md:39 — "일반주문 빈/null 키 채움법 미상"). 단
  e2e §0 표의 "dead link 0" 자기점검 주장은 필수 필드 누락을 가린 면이 있어 **과장**. codex 지적 정당.
- **라우팅 → architect/gate**: e2e §0 "dead link 0"을 "operationId 연결 0 끊김 / 단 필수 필드 갭은 I-OS-1·X08·X09로
  분리"로 정정. I-OS-1 갭필(일반주문 recurringPaymentDelivery null/빈 shape) 우선순위 상향.

### A-5. **[X08] `order-sheet calculate` 필수 `addressRequest` 누락 — HIGH(돈확정 단계)**
- **codex 주장**: calculate required=`accumulationUseAmt, addressRequest, couponRequest, shippingAddresses`인데 e2e에 addressRequest 없음.
- **Claude 스펙 재확인 = verified**: `order-shop-public.yml:28580` — calculate request `required: [accumulationUseAmt, addressRequest, couponRequest, shippingAddresses]`(직접 재확인).
- **판정**: **합의·실재 결함**. e2e §0 #7 입력에 `{accumulationUseAmt, couponRequest, shippingAddresses[]}`만 — **addressRequest 누락**.
  ★돈확정2(최종 결제금액 확정) 단계라 누락 시 400/흐름 깨짐. 설계가 open-issues에도 분리 안 함(진성 누락).
- **라우팅 → architect**: e2e §1·§2 calculate 단계에 `addressRequest` + `shippingAddresses[].payProductParams[]` shape 추가.
  배송지·배송비가 최종 금액에 영향 → 가격 정합(이중계산 0) 검증을 이 단계까지 확장. gate(SB2) 골든에 포함.

### A-6. **[X09] `payments/reserve` 필수 필드 축약 — HIGH**
- **codex 주장**: reserve required=`clientReturnUrl, member, orderSheetNo, orderer, payType, pgType, saveAddressBook,
  subPayAmt, updateMember`인데 e2e가 clientReturnUrl·saveAddressBook·subPayAmt·updateMember 생략.
  `paymentAmtForVerification`은 nullable·required 아님. `agreementTermsAgrees`도 required 아님.
- **Claude 스펙 재확인 = verified(미묘 포함)**:
  - `order-shop-public.yml:33000` — required = 위 9개(직접 재확인). e2e §0 #8은 일부만 표기.
  - `order-shop-public.yml:33398` — `paymentAmtForVerification: nullable:true` — **required 아님**(codex 정확). 설계는
    이를 검증 핵심 필수처럼 다룸(arch §4.2 anti-tamper). → **스펙상 선택**이나 **운영 규칙으로 항상 전송**이 맞음(codex 권고 타당).
  - `agreementTermsAgrees`(:33347) 존재하나 required 목록엔 없음 — 설계 I-MISC-1과 정합.
- **판정**: **합의·실재 결함**. reserve 최소 필수 세트가 e2e에 불완전. paymentAmtForVerification의 "필수 vs 운영규칙"
  구분은 codex가 더 정확(설계가 required로 오인 가능). subPayAmt/updateMember/saveAddressBook/clientReturnUrl 누락.
- **라우팅 → architect**: e2e §1·§2 reserve 단계 + widget-cart-contract §6에 **reserve 필수 9필드 전체** 명시.
  paymentAmtForVerification은 "스펙상 nullable이나 anti-tamper 운영규칙상 항상 전송"으로 주석. I-PAY-2(subPayAmt 산식)과 연결.

### A-7. **[X10] 게스트 previous-order token 단계 method/body 틀림 — MEDIUM**
- **codex 주장**: `get-previous-order-guest-token`은 실제 `POST /previous-orders/guest/{orderNo}` + `{password}` body. e2e는 GET·orderNo만.
- **Claude 스펙 재확인 = verified**: `order-shop-public.yml:5304` — 해당 path 아래 메서드는 **`post:`** (operationId 이름만 "get-").
  requestBody 예시 `{"password":""}`(:5345). e2e §0 #10g는 `GET .../guest-token` 입력 `orderNo`로 표기 — **method·body 오류**.
- **판정**: **합의·실재 결함**. operationId 명칭(get-*)에 속아 GET으로 표기. 실제는 POST + 비회원 주문 비밀번호.
- **라우팅 → architect**: e2e §0 #10g·§2 게스트 시퀀스를 `POST /previous-orders/guest/{orderNo}` + tempPassword(주문 비밀번호) →
  guestToken 헤더 조회로 정정. (게스트 reserve의 tempPassword와 동일 자격 — 연결 명시.)

### A-8. **[X11] 동적 옵션 청소 후 과거 주문/클레임 추적성 스펙만으로 단정 불가 — HIGH(리스크)**
- **codex 주장**: claim 응답 `claimedOptions[]`에 orderOptionNo·optionNo·price.{buyAmt,addPrice,salePrice}·refund* 보유.
  스펙만으로 "현재 option master 재조회 여부" 확인 불가 → 동적 옵션 immutable 보존 권고.
- **Claude 스펙 재확인 = verified(가설 부분 포함)**:
  - `claim-shop-public.yml`(독립 grep) — claims는 `orderProductOptionNo`/`orderOptionNo`(주문시점 옵션 스냅샷)를 참조.
    환불 산식 `refundPayAmt/refundMainPayAmt/refundSubPayAmt` 별도 존재(claim-server 8063 류).
  - "환불·정산이 과거 주문 snapshot만 쓰는지 vs 현재 option master 참조인지"는 **스펙만으로 미확정** — codex도 "모름" 명시(정직).
- **판정**: **합의·리스크 실재**. 설계 §4.4·open-issues I-PRICE-3은 "주문건별 고유 optionNo"는 언급하나 **주문 후 그 옵션의
  immutable 보존(삭제/변경 금지)** 정책은 미명문. P-B 잔존 청소(I-PRICE-3)와 충돌 — 청소하면 클레임/정산 추적성 위험 가능.
- **라우팅 → architect + open-issues 격상**: §4.4·I-PRICE-3에 **"주문 성립 후 그 optionNo는 immutable(useYn=N만, 삭제·addPrice
  변경 금지)·후니 quote snapshot 별도 영속화"** 정책 추가. 정산/클레임 가격 권위(snapshot vs master)는 **I-PRICE-2(OQ-4)에
  병합·갭필 후보**(settlement/claim 문서). 이는 codex가 추가한 **새 결합 리스크**(P-B 청소 ↔ 클레임 추적) — 설계 보강 가치 높음.

---

## B. 합의 — false-positive(설계가 옳음을 codex도 독립 확인)

### B-1. **[X02] 라인 임의 단가 입력 필드 없음 — 설계 전제 옳음(고신뢰 합의)**
- **codex**: post-cart/post-order-sheet 가격 필드 0·등록가 재산출 = 설계 전제 정합("폐기 유지").
- **Claude 재확인 = verified**: 6개 yml `customPrice/priceOverride/orderPrice` 0건(독립 grep 재확인). post-cart schema
  필수=productNo/optionNo/orderCnt만. → **설계의 핵심 전제(P-B/등록가 동기화 외 길 없음)에 대한 독립 2nd opinion 합의 = 고신뢰.**
- **라우팅**: 없음(설계 유지·신뢰 강화).

### B-2. **[X01] `post-cart.channelType` member schema엔 없음 — widget-cart-contract 옳음, bridge-spec만 정정**
- **codex**: member post-cart 예제엔 channelType 있으나 schema엔 없음(guest schema에만). widget-cart-contract "회원엔 없음"은 정당.
- **Claude 재확인 = verified**: member 예제(:729) channelType 有 / schema `cart-1115878954` channelType 無(독립 재확인) /
  guest schema(:32093) 有. → widget-cart-contract §2.2(회원 post-cart에 channelType 없음·I-CART-2로 분리)는 **정확**.
  단 `product-price-bridge-spec §1.2`가 member post-cart shape에 `channelType?`을 적은 것은 **예제 기준 표기 → 정정 권장**.
- **판정**: codex의 widget-cart-contract 부분은 false-positive(설계 옳음), bridge-spec 부분은 minor 정정.
- **라우팅 → product-bridge-analyst(LOW)**: `product-price-bridge-spec §1.2`에서 member post-cart `channelType?` 제거 또는
  "예제에만 있고 schema엔 없음(I-CART-2)" 주석. 구현은 schema 기준(member에 channelType 미전송).

---

## C. 합의 — 이미 설계가 BLOCKED로 분리(중복 확인 = 검증 신뢰)

### C-1. **[X06] P-B 동적 옵션 상품심사/노출/동시성 미검증 — 설계 BLOCKED와 일치**
- **codex**: put-product-options 존재하나 심사상태(APPROVAL_READY·AFTER_APPROVAL_READY) 전이·노출·동시성 미검증 → "채택 완료"로 쓰면 안 됨.
- **Claude 재확인 = verified·합의**: `product-server-public.yml:3287`(inspections approval-waiting) + judgement.mdx:9·31(수정 후
  승인대기) 독립 확인. 설계는 **이미 I-PRICE-1(BLOCKED 관문)·OQ-3·M-JUDGE-1으로 정확히 분리**(open-issues.md:15).
- **판정**: **합의·중복 확인**. codex가 독립적으로 같은 BLOCKED를 도출 = 설계의 정직성(미검증을 추정으로 안 메움)에 대한 2nd opinion 검증.
  단 codex 종합판정의 "P-B는 운영 가능 확정 설계 아니다"는 **설계 결론(전략 D는 BLOCKED 관문 전 채택 불가)과 동일** — 불일치 아님.
- **라우팅**: 없음(설계 BLOCKED 유지). I-PRICE-1/2/3 갭필 우선순위는 gate가 SB6로 수렴.

---

## D. codex가 "모름"으로 정직 분리한 것 (설계 open-issues와 대조)

| codex "모름" | 설계 분리 여부 | 라우팅 |
|-------------|--------------|--------|
| addPrice 변경이 상품심사 AFTER_APPROVAL_READY 유발하는지 | ✅ I-PRICE-1/OQ-3 | 갭필(docs.shopby.co.kr 심사정책) |
| 동적 옵션 생성 직후 즉시 구매 가능한지(노출 지연) | ✅ I-PRICE-3 | 라이브 admin 읽기 탐색 |
| 정산/클레임 환불이 snapshot vs 현재 master 참조 | ⚠️ I-PRICE-2(OQ-4)에 부분 — **claim 추적성은 미분리** | **신규: X11로 I-PRICE-3에 병합·갭필** |
| recurringPaymentDelivery 일반주문 빈값 shape | ✅ I-OS-1 | 갭필(주문서 가이드) |
| PG reserve 후 결제 확정 콜백 전체 흐름 | ✅ I-PAY-1 | 갭필(NCPPay 결제편의모듈) |

> ★ codex "모름" 5건 중 4건은 설계가 이미 open-issues로 분리(추정 0 일치 = 양측 정직). 1건(클레임 추적성)만
> X11로 신규 보강 필요 → I-PRICE-3 격상.

---

## E. 종합 reconcile 결론

1. **큰 전제 = 고신뢰 합의**: "라인 임의 가격 필드 부재·등록가 재산출·계산가 생존=등록가 동기화"는 codex 독립 2nd opinion으로
   재확인(X02). 전략 D/P-B 외 무손실 길 없음·D의 핵심 관문 BLOCKED(X06)도 합의.
2. **adapter 구현 계약 결함 다수(verified)**: X03(돈크리티컬 salePrice=0 불변식)·X05(server API 인증 분리)·X04(put-product-options
   full shape)·X08(addressRequest)·X09(reserve 필수세트)·X07(recurringPaymentDelivery)·X10(guest token POST) — **설계가
   큰 그림은 맞으나 종단 계약을 구현 가능 수준으로 못 채움**. 특히 X03·X05·X08·X09는 그대로 구현하면 **돈 틀림/주문 실패**.
3. **신규 결합 리스크(X11)**: P-B 잔존 청소 ↔ 클레임/정산 추적성 충돌 — 설계 미명문. immutable 옵션 정책 보강 필요.
4. **불일치·false-positive(정당설계 오판) 0**: codex가 정당 설계를 결함으로 오판한 사례 없음. codex 신뢰도 높음(단 가설→verified 거침).
5. **다음**: gate(SB6)가 본 reconcile를 수렴. A-군(8 결함) → architect 보정 루프(X03·X05 최우선=돈크리티컬). B/C군은
   설계 유지(LOW 정정만). 갭필 후보(D 표)는 docs.shopby.co.kr WebFetch 읽기전용·부족분만.

> ★ codex 출력 raw=`04_codex/_tmp/codex-out.txt`. 본 reconcile의 모든 "verified"는 Claude가 스펙 라인을 직접 재확인한 것.
