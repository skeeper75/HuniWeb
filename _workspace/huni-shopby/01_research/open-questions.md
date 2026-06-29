# Shopby 커머스 흐름 — 미해결 질문·라이브 갭필 후보

> 원칙: 추정 0. 스펙(`order-shop-public.yml`/`member-shop-public.yml`)으로 닫지 못한 흐름·필드만 여기 분리.
> 갭필 순서: enterprise/docs-complete 문서 → 라이브(docs.shopby.co.kr / server-docs.shopby.co.kr, WebFetch 읽기전용·부족분만).

---

## 0. 검증 노트 (재대조 라운드)

- **2026-06-25 재대조**: `commerce-flow-contract.md`/`auth-session-model.md`의 핵심 shape 주장을 실제 yml과 필드 단위 재검증.
  - operationId 라인: post-cart(679)·put-cart(615)·get-cart(443)·delete-cart(752)·get-cart-calculate(820)·get-cart-validate(1138)·post-guest-cart(1272)·post-order-sheet(3789)·order-sheet calculate(4063)·post-payments-reserve(4703)·naver-ordersheet(4815) — **전부 일치**.
  - 스키마 정의 라인: cart-1115878954(32025)·order-sheets-427257668(21397)·payments-reserve-2101669004(33000)·order-sheet calc resp(18912)·cart-calculate resp(25490)·reserve resp(14893) — **전부 일치**.
  - 돈 검증: payments-reserve `required`=[clientReturnUrl,member,orderSheetNo,orderer,payType,pgType,saveAddressBook,subPayAmt,updateMember] (33001-33010 verbatim), `paymentAmtForVerification`="검증을위한 결제예정금액(적립금사용후)" nullable (33398-33401), order-sheet calc resp `required`=[appliedCoupons,availablePayTypes,deliveryGroups,paymentInfo] (18912-18918), `paymentAmt` 스키마 프로퍼티 존재(19702 외) — **전부 확인**.
  - **Q-PAY-1 재확증**: order-shop 전체에서 `*-confirm` op는 `put-guest-order-options-order-option-no-confirm`(1962)·`put-profile-order-options-order-option-no-confirm`(6624) 둘뿐이고 **둘 다 구매확정(배송후 PUT)**. cart→ordersheet→reserve 경로에 "주문 생성/결제 확정" POST는 **실제로 부재**(추출 누락 아님). reserve 이후 후속 주문생성 POST 없음.
  - **post-cart `channelType` 주의**: post-cart 예시 문자열(729행)에 `channelType:null`이 들어 있으나 `cart-1115878954` 스키마 properties(32035-32069)에는 `channelType`가 **정의되지 않음**(스키마 필드=baseProductNo,groupId,orderCnt,optionInputs,optionNo,productNo). `channelType`는 guest-cart 스키마(32093-32096)에만 존재. → 후니 브리지가 post-cart에 channelType을 보낼지 여부는 라이브 동작 확인 필요(예시 vs 스키마 불일치는 Shopby 스펙 자체 inconsistency).
  - **결론**: 기존 3개 산출물은 정확. 스펙 버전 미변경 → 계약 정정 불요. 미상은 아래 그대로 유효.

---

## A. 돈·브리지 (최우선 — architect 종속)

### Q-PRICE-1 [HIGH] 후니 인쇄 견적가를 Shopby 가격에 싣는 경로
- 미상: post-cart / post-order-sheet / reserve requestBody 전수 확인 결과 **임의 단가 주입 필드가 없다**(라인은 productNo+optionNo+orderCnt로만 식별, 가격은 Shopby 서버 권위 재계산). 후니 위젯이 산출한 인쇄 견적가(사이즈/도수/수량 조합)를 Shopby 주문 금액에 반영할 표준 경로가 스펙에 직접 노출되지 않음.
- 후보 경로(검증 필요, 추정 아님 — 가능성 나열):
  - (a) Shopby 옵션 마스터에 조합별 옵션을 만들고 `addPrice`(옵션추가금액)로 차등 — get-cart 응답 `price.addPrice` 존재 확인(order-shop-public.yml:514). 조합 폭발 문제.
  - (b) 단일 옵션 + 구매자입력(`optionInputs`)로 사양 전달하되 금액은 별도 — 단 optionInputs는 가격 인자 아님(텍스트).
  - (c) Shopby 외부 가격 연동/커스텀 가격 API 존재 여부.
- 갭필: display/product-shop-public.yml의 옵션·추가금액 모델 + docs.shopby.co.kr "옵션/추가상품/가격" 가이드. hsb-product-bridge와 합동.

### Q-PAY-1 [HIGH] 결제 확정(주문 생성) 엔드포인트의 부재
- 미상: order-shop 스펙에 "결제 완료 후 주문 생성/확정" 전용 POST가 없음(grep confirm/complete → 모두 구매확정=배송완료 후 단계 put-*-confirm). reserve가 PG `returnUrl`/`confirmUrl`(order-shop-public.yml:14920-14927)을 반환하고, 완료 시 `clientReturnUrl?result=SUCCESS&orderNo`로 리다이렉트(order-shop-public.yml:33179-33184).
- 질문: 결제 확정은 PG→Shopby 서버 콜백(confirmUrl)으로만 처리되는가? 클라이언트가 호출할 "주문 확정/조회" 후속 API는? reserve 설명이 가리키는 'NCPPay 결제편의모듈'(order-shop-public.yml:4698-4702)의 클라이언트 SDK 흐름.
- 갭필: docs.shopby.co.kr 결제편의모듈 가이드(workspace.nhn-commerce.com/guide/skin/dev-cover/order#pay-button), app-payment-module 가이드.

### Q-PRICE-2 [MED] subPayAmt / externalPayInfos 정확 의미
- 미상: reserve `subPayAmt`(required, order-shop-public.yml:33009)와 `externalPayInfos[]`(외부결제 LPOINT 등) 조합 시 `paymentAmtForVerification`과의 산식 관계.
- 갭필: docs.shopby.co.kr 외부결제/복합결제 가이드.

---

## B. 인증 (auth 서비스 raw shape)

### Q-AUTH-1 [HIGH] post-oauth2-token / post-oauth-token-dormant requestBody
- 미상: 로그인 토큰 발급 API의 **requestBody schema(아이디/비밀번호/keepLogin 필드)**. 본 레포 `*.yml`에 auth 서비스 스펙 파일이 없고, docs-complete auth.mdx는 헤더만 표기(body 표 미기재). 근거: shopby-api-docs-complete/01_shop-api/auth.mdx:629-643 (post-oauth2-token에 Parameters 헤더만).
- 갭필: docs.shopby.co.kr `auth` 서비스 OpenAPI (`?url.primaryName=auth/#/OAUTH2/post-oauth2-token`).

### Q-AUTH-2 [MED] 토큰 응답 shape(accessToken/refreshToken/expireIn)
- 미상: post-oauth2-token 200 응답 본문 필드 정확명. /oauth/callback 예시로 `accessToken`,`expireIn`,`daysFromLastPasswordChange`는 확인(auth.mdx:592) — OAuth2 응답의 refreshToken 필드명·만료 구조 미확정.
- 갭필: 동일 auth OpenAPI.

### Q-ENV-1 [LOW] 서비스별 base URL 차이
- 확인: order 서비스 = `https://shop-api.e-ncp.com`(order-shop-public.yml:7), auth/member docs-complete 표기 = `https://shop-api.shopby.co.kr`(auth.mdx:18). 동일 게이트웨이의 별칭인지, 환경(alpha/real)별 분리인지 미상. reserve 예시에 `alpha-service.e-ncp.com`(order-shop-public.yml:4779), `api.e-ncp.com`(14922)도 등장.
- 갭필: docs.shopby.co.kr 서버정보/환경 가이드.

---

## C. 카트/주문서 세부

### Q-CART-1 [MED] 게스트 cartNo의 출처
- 미상: post-guest-cart requestBody가 `cartNo`(required, order-shop-public.yml:32082-32086)를 요구. 게스트는 서버 영속 카트가 없는데 cartNo를 어떻게 채번/관리하나(클라이언트 임시값 추정되나 스펙 미명시).
- 갭필: docs.shopby.co.kr 비회원 장바구니 가이드.

### Q-OS-1 [MED] recurringPaymentDelivery 일반주문 필수 처리
- 미상: post-order-sheet `products[].recurringPaymentDelivery`가 required로 표기(order-shop-public.yml:21440). 일반(비정기) 주문에서 이 객체를 어떻게 채우나(빈/null 키 허용? 예시는 cycleType="MONTH" 채움 order-shop-public.yml:3840-3842).
- 갭필: 일반 주문 예시(docs.shopby.co.kr 주문서 가이드).

### Q-OS-2 [LOW] cartNos 경유 vs products 직접 — 금액 일치 보장
- 미상: 장바구니 경유(cartNos)와 바로구매(products)에서 order-sheet/calculate가 동일 산식인지, cartNos가 products와 중복 제공될 때 우선순위.
- 갭필: 주문서 가이드.

### Q-CART-2 [LOW] post-cart channelType — 예시 vs 스키마 불일치
- 미상: post-cart 예시(order-shop-public.yml:729)에 `channelType:null`이 있으나 `cart-1115878954` 스키마 properties(32035-32069)에는 channelType 미정의. guest-cart 스키마(32093-32096)에만 존재. 후니 브리지가 회원 post-cart에 channelType(쇼핑채널링)을 보낼 수 있는지/무시되는지 라이브 확인 필요.
- 갭필: docs.shopby.co.kr 쇼핑채널링/장바구니 가이드 + 라이브 응답 동작.

---

## D. 채널/약관

### Q-MISC-1 [LOW] agreementTermsAgrees 필수 termsType 세트
- 미상: reserve에서 어떤 `termsType`(PI_SELLER_PROVISION 등 enum order-shop-public.yml:33048-33059)이 결제 성공에 필수인지(몰 설정 종속 추정).
- 갭필: docs.shopby.co.kr 약관 동의 가이드.

### Q-MISC-2 [LOW] NaverPay 경로의 후니 적용 여부
- 결정대기: post-payments-naver-ordersheet(order-shop-public.yml:4815)는 표준 cart→ordersheet→reserve와 분기(items 직전달, 응답=네이버 구매 URL). 1차 통합 범위 포함 여부는 architect/PM 결정.
