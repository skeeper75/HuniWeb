# claim-shop

**버전**: unspecified
**서버**: https://shop-api.e-ncp.com

클레임(claim) 관련 shop API입니다.

---

## Guest

### POST /guest/claims/cancel

**요약**: 옵션취소 신청하기(복수옵션)

**설명**:

## 부가설명 및 특이사항

다수의 선택옵션을 취소신청하는 비회원용 API입니다.

## API Version

### 1.0

기존 방식으로, API 요청에 성공 시 204 No Content를 응답합니다.

### 1.1 (개발중)

변경된 방식으로, API 요청에 성공 시 200 Ok 와 신청된 클레임과 옵션에 대한 정보를 응답합니다. (문서 참조)

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C.png)

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                         |
| ---------- | ------ | ------ | ---- | -------------------------------------------- | ---------------- |
| ClientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform   | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken | header | string | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version    | header | string | ✅   | API 버전^                                    | 1.0              |
| language   | header | string | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **200**: 200

---

### POST /guest/claims/estimate

**요약**: 클레임시 변경되는 주문 환불 예상금액 계산하기(복수옵션)

**설명**:

## 부가설명 및 특이사항

다수의 선택옵션을 취소할 경우 환불 예상금액을 미리 계산하는 비회원용 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-2.png)

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                         |
| ---------- | ------ | ------ | ---- | -------------------------------------------- | ---------------- |
| ClientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform   | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken | header | string | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version    | header | string | ✅   | API 버전^                                    | 1.0              |
| language   | header | string | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **200**: 200

---

### POST /guest/claims/return

**요약**: 반품 신청하기(복수옵션)

**설명**:

## 부가설명 및 특이사항

다수의 선택옵션을 반품하는 비회원용 API입니다.

## API Version

### 1.0

기존 방식으로, API 요청에 성공 시 204 No Content를 응답합니다.

### 1.1 (개발중)

변경된 방식으로, API 요청에 성공 시 200 Ok 와 신청된 클레임과 옵션에 대한 정보를 응답합니다. (문서 참조)

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claims_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claims_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claims_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claims_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-2.png)

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                         |
| ---------- | ------ | ------ | ---- | -------------------------------------------- | ---------------- |
| ClientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform   | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken | header | string | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version    | header | string | ✅   | API 버전^                                    | 1.0              |
| language   | header | string | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **200**: 200

---

### POST /guest/claims/free-gifts/satisfy

**요약**: 사은품 지급 조건 충족 여부 조회하기

**설명**:

## 부가설명 및 특이사항

클레임 이후에 사은품 지급 조건이 충족하는지 여부를 조회할 수 있는 API입니다.
정상상태의 옵션 금액의 합계로만 사은품 지급 여부를 판단합니다. (교환 출고 옵션도 계산에서 제외)

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                         |
| ---------- | ------ | ------ | ---- | -------------------------------------------- | ---------------- |
| ClientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform   | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken | header | string | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version    | header | string | ✅   | API 버전^                                    | 1.0              |
| language   | header | string | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **200**: 200

---

### PUT /guest/claims/{claimNo}/account

**요약**: 환불 계좌 정보 수정하기

**설명**:

## 부가설명 및 특이사항

환불 계좌 정보를 수정하는 비회원용 API입니다.

## API Version

### 1.0

기존 방식으로, API 요청에 성공 시 204 No Content를 응답합니다.

### 1.1 (개발중)

변경된 방식으로, API 요청에 성공 시 200 Ok 와 신청된 클레임과 옵션에 대한 정보를 응답합니다. (문서 참조)

## Request

### 참고사항

- responsibleObjectType이 null이면 클레임 사유에 해당되는 귀책이 들어갑니다.

**파라미터**:

| 이름       | 위치   | 타입    | 필수 | 설명                                         |
| ---------- | ------ | ------- | ---- | -------------------------------------------- | ---------------- |
| claimNo    | path   | integer | ✅   | 클레임 번호^                                 | 1                |
| ClientId   | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform   | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken | header | string  | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version    | header | string  | ✅   | API 버전^                                    | 1.0              |
| language   | header | string  | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **204**: 204

---

### GET /guest/claims/{claimNo}/check-withdraw

**요약**: 클레임 철회시 유효성 검증 타입 조회하기

**설명**:

## 부가설명 및 특이사항

클레임 철회시 유효성 검증 타입 조회하는 비회원용 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C.png)

**파라미터**:

| 이름       | 위치   | 타입    | 필수 | 설명                                         |
| ---------- | ------ | ------- | ---- | -------------------------------------------- | ---------------- |
| claimNo    | path   | integer | ✅   | 클레임 번호^                                 | 1                |
| ClientId   | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform   | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken | header | string  | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version    | header | string  | ✅   | API 버전^                                    | 1.0              |
| language   | header | string  | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **200**: 200

---

### GET /guest/claims/{claimNo}/result

**요약**: 클레임 상세보기(클레임 번호)

**설명**:

## 부가설명 및 특이사항

비회원을 위한 클레임 번호로 클레임 세부 내역을 조회하는 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_claim_result%20클레임%20상세보기.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_claim_result%20클레임%20상세보기.png)

**파라미터**:

| 이름       | 위치   | 타입    | 필수 | 설명                                         |
| ---------- | ------ | ------- | ---- | -------------------------------------------- | ---------------- |
| claimNo    | path   | integer | ✅   | 클레임 번호^                                 | 1                |
| ClientId   | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform   | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken | header | string  | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version    | header | string  | ✅   | API 버전^                                    | 1.0              |
| language   | header | string  | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **200**: 200

---

### PUT /guest/claims/{claimNo}/withdraw

**요약**: 클레임 철회하기(클레임번호)

**설명**:

## 부가설명 및 특이사항

클레임 번호로 신청된 클레임을 철회하는 비회원용 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C.png)

**파라미터**:

| 이름       | 위치   | 타입    | 필수 | 설명                                         |
| ---------- | ------ | ------- | ---- | -------------------------------------------- | ---------------- |
| claimNo    | path   | integer | ✅   | 클레임 번호^                                 | 1                |
| ClientId   | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform   | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken | header | string  | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version    | header | string  | ✅   | API 버전^                                    | 1.0              |
| language   | header | string  | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **204**: 204

---

### GET /guest/order-options/{orderOptionNo}/claims

**요약**: 클레임 신청을 위한 정보 조회하기

**설명**:

## 부가설명 및 특이사항

클레임 목록을 조회하는 비회원용 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_order-options_claim%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%8B%A0%EC%B2%AD%EA%B0%80%EB%8A%A5%20%EC%A0%95%EB%B3%B4%EC%A1%B0%ED%9A%8C%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_order-options_claim%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%8B%A0%EC%B2%AD%EA%B0%80%EB%8A%A5%20%EC%A0%95%EB%B3%B4%EC%A1%B0%ED%9A%8C%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_order-options_claim%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%8B%A0%EC%B2%AD%EA%B0%80%EB%8A%A5%20%EC%A0%95%EB%B3%B4%EC%A1%B0%ED%9A%8C%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_order-options_claim%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%8B%A0%EC%B2%AD%EA%B0%80%EB%8A%A5%20%EC%A0%95%EB%B3%B4%EC%A1%B0%ED%9A%8C%201-2.png)

**파라미터**:

| 이름          | 위치   | 타입    | 필수 | 설명                                                     |
| ------------- | ------ | ------- | ---- | -------------------------------------------------------- | ---------------- |
| orderOptionNo | path   | integer | ✅   | 주문 상품 옵션 번호^                                     | 1                |
| claimType     | query  | string  | ✅   | 클레임 타입(CANCEL: 취소, RETURN: 반품, EXCHANGE: 교환)^ | CANCEL           |
| ClientId      | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                                | test-client-id   |
| platform      | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^             | PC               |
| guestToken    | header | string  | ✅   | 비회원 토큰^                                             | test-guest-token |
| Version       | header | string  | ✅   | API 버전^                                                | 1.0              |
| language      | header | string  | ❌   | 언어 (기본값: ko)^                                       | ko               |

**응답**:

- **200**: 200

---

### POST /guest/later-input/shippings/claims/cancel

**요약**: [샵바이 엔터프라이즈 전용] 나중 배송 입력 주문 취소하기

**설명**:

## 부가설명 및 특이사항

나중 배송 입력 주문을 취소하는 API입니다.

**파라미터**:

| 이름                | 위치   | 타입   | 필수 | 설명                                         |
| ------------------- | ------ | ------ | ---- | -------------------------------------------- | -------------------------------- |
| ClientId            | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id                   |
| platform            | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                               |
| Version             | header | string | ✅   | API 버전^                                    | 1.0                              |
| encryptedShippingNo | header | string | ✅   | 암호화된 배송 번호^                          | UFE3Ylo2aUlkSWVuZHVGQjYyS2pZZz09 |
| language            | header | string | ❌   | 언어 (기본값: ko)^                           | ko                               |

**응답**:

- **204**: 204

---

### POST /guest/order-options/{orderOptionNo}/claims/cancel

**요약**: 옵션취소 신청하기

**설명**:

## 부가설명 및 특이사항

단일옵션을 취소신청하는 비회원용 API입니다.

## API Version

### 1.0

기존 방식으로, API 요청에 성공 시 204 No Content를 응답합니다.

### 1.1 (개발중)

변경된 방식으로, API 요청에 성공 시 200 Ok 와 신청된 클레임과 옵션에 대한 정보를 응답합니다. (문서 참조)

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_order-options_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_order-options_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_order-options_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_order-options_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-2.png)

**파라미터**:

| 이름          | 위치   | 타입    | 필수 | 설명                                         |
| ------------- | ------ | ------- | ---- | -------------------------------------------- | ---------------- |
| orderOptionNo | path   | integer | ✅   | 주문 상품 옵션 번호^                         | 1                |
| ClientId      | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform      | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken    | header | string  | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version       | header | string  | ✅   | API 버전^                                    | 1.0              |
| language      | header | string  | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **200**: 200

---

### GET /guest/order-options/{orderOptionNo}/claims/estimate

**요약**: 클레임시 변경되는 주문 환불금액 계산하기(단일옵션)

**설명**:

## 부가설명 및 특이사항

선택옵션을 취소할 경우 환불 예상금액을 미리 계산하는 비회원용 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_order-options_claim_estimate%20클레임%20시%20변경되는%20주문%20환불%20계산%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_order-options_claim_estimate%20클레임%20시%20변경되는%20주문%20환불%20계산%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_order-options_claim_estimate%20클레임%20시%20변경되는%20주문%20환불%20계산%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_order-options_claim_estimate%20클레임%20시%20변경되는%20주문%20환불%20계산%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| --------------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| orderOptionNo         | path   | integer | ✅   | 주문 상품 옵션 번호^                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 1                |
| claimReasonType       | query  | string  | ✅   | 클레임사유(CHANGE_MIND: 단순변심(색상,사이즈 등), DEFECTIVE_PRODUCT: 상품불량/파손, WRONG_DELIVERY: 배송누락/오배송, OUT_OF_STOCK_SYSTEM: 재고부족(품절취소), CANCEL_BEFORE_PAY: 입금전취소, WRONG_PRODUCT_DETAIL: 상품상세 정보와 다름, DELAY_DELIVERY: 판매자 배송 지연, OTHERS_SELLER: 기타(판매자 귀책), OTHERS_BUYER: 기타(구매자 귀책), OUT_OF_STOCK: 상품 품절/재고 없음, LATER_INPUT_ORDER: 배송지 미입력 취소, LATER_INPUT_ORDER_RECEIVER_CANCEL: 선물거절취소)^ | CHANGE_MIND      |
| claimType             | query  | string  | ✅   | 클레임타입(CANCEL: 취소, RETURN: 반품, EXCHANGE: 교환)^                                                                                                                                                                                                                                                                                                                                                                                                                   | CANCEL           |
| exchangeCnt           | query  | string  | ❌   | 교환할수량(claimType이 EXCHANGE인 경우)^                                                                                                                                                                                                                                                                                                                                                                                                                                  | 1                |
| exchangeOptionNo      | query  | string  | ❌   | 교환할옵션번호(claimType이 EXCHANGE인 경우)^                                                                                                                                                                                                                                                                                                                                                                                                                              | 1                |
| exchangeProductNo     | query  | string  | ❌   | 교환할상품번호(claimType이 EXCHANGE인 경우)^                                                                                                                                                                                                                                                                                                                                                                                                                              | 1                |
| productCnt            | query  | string  | ✅   | 취소/반품할 제품수량^                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 1                |
| responsibleObjectType | query  | string  | ❌   | 귀책 - responsibleObjectType이 null이면 ClaimReasonType에 매핑되는 귀책 적용(CHANGE_MIND, CANCEL_BEFORE_PAY, OTHERS_BUYER -> BUYER / DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER -> SELLER)(BUYER: 구매자귀책, SELLER: 판매자귀책)^                                                                                                                                                         | BUYER            |
| returnWayType         | query  | string  | ❌   | 반품상품 수거방법(SELLER_COLLECT: 판매자수거요청, BUYER_DIRECT_RETURN: 구매자직접반품)^                                                                                                                                                                                                                                                                                                                                                                                   | SELLER_COLLECT   |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                                                                                                                                                                                                                                                                                                                                                                                                                                                 | test-client-id   |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^                                                                                                                                                                                                                                                                                                                                                                                                                              | PC               |
| guestToken            | header | string  | ✅   | 비회원 토큰^                                                                                                                                                                                                                                                                                                                                                                                                                                                              | test-guest-token |
| Version               | header | string  | ✅   | API 버전^                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 1.0              |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                                                                                                                                                                                                                                                                                                                                                                                                                                                        | ko               |

**응답**:

- **200**: 200

---

### POST /guest/order-options/{orderOptionNo}/claims/exchange

**요약**: 교환 신청하기

**설명**:

## 부가설명 및 특이사항

비회원을 위한 선택옵션을 교환하는 API입니다.

## API Version

### 1.0

기존 방식으로, API 요청에 성공 시 204 No Content를 응답합니다.

### 1.1 (개발중)

변경된 방식으로, API 요청에 성공 시 200 Ok 와 신청된 클레임과 옵션에 대한 정보를 응답합니다. (문서 참조)

## Request

### 참고사항

- responsibleObjectType이 null이면 클레임 사유에 해당되는 귀책이 들어갑니다.

**파라미터**:

| 이름          | 위치   | 타입    | 필수 | 설명                                         |
| ------------- | ------ | ------- | ---- | -------------------------------------------- | ---------------- |
| orderOptionNo | path   | integer | ✅   | 주문 상품 옵션 번호^                         | 1                |
| ClientId      | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform      | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken    | header | string  | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version       | header | string  | ✅   | API 버전^                                    | 1.0              |
| language      | header | string  | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **200**: 200

---

### GET /guest/order-options/{orderOptionNo}/claims/result

**요약**: 클레임 상세보기(주문상품 옵션번호)

**설명**:

## 부가설명 및 특이사항

주문상품 옵션번호로 클레임 세부 내역을 조회하는 비회원용 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_order-options_claim_result%20클레임%20상세보기.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_order-options_claim_result%20클레임%20상세보기.png)

**파라미터**:

| 이름          | 위치   | 타입    | 필수 | 설명                                         |
| ------------- | ------ | ------- | ---- | -------------------------------------------- | ---------------- |
| orderOptionNo | path   | integer | ✅   | 주문 상품 옵션 번호^                         | 1                |
| ClientId      | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform      | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken    | header | string  | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version       | header | string  | ✅   | API 버전^                                    | 1.0              |
| language      | header | string  | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **200**: 200

---

### POST /guest/order-options/{orderOptionNo}/claims/return

**요약**: 반품 신청하기(단일옵션)

**설명**:

## 부가설명 및 특이사항

단일옵션을 반품하는 비회원용 API입니다.

## API Version

### 1.0

기존 방식으로, API 요청에 성공 시 204 No Content를 응답합니다.

### 1.1 (개발중)

변경된 방식으로, API 요청에 성공 시 200 Ok 와 신청된 클레임과 옵션에 대한 정보를 응답합니다. (문서 참조)

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_order-options_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_order-options_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_order-options_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_order-options_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-2.png)

**파라미터**:

| 이름          | 위치   | 타입    | 필수 | 설명                                         |
| ------------- | ------ | ------- | ---- | -------------------------------------------- | ---------------- |
| orderOptionNo | path   | integer | ✅   | 주문 상품 옵션 번호^                         | 1                |
| ClientId      | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform      | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken    | header | string  | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version       | header | string  | ✅   | API 버전^                                    | 1.0              |
| language      | header | string  | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **200**: 200

---

### PUT /guest/order-options/{orderOptionNo}/claims/withdraw

**요약**: 클레임 철회하기(주문상품 옵션번호)

**설명**:

## 부가설명 및 특이사항

주문상품 옵션번호로 신청된 클레임을 철회하는 비회원용 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_order-options_claim_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_order-options_claim_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C.png)

**파라미터**:

| 이름          | 위치   | 타입    | 필수 | 설명                                         |
| ------------- | ------ | ------- | ---- | -------------------------------------------- | ---------------- |
| orderOptionNo | path   | integer | ✅   | 주문 상품 옵션 번호^                         | 1                |
| ClientId      | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform      | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken    | header | string  | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version       | header | string  | ✅   | API 버전^                                    | 1.0              |
| language      | header | string  | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **204**: 204

---

### POST /guest/orders/{orderNo}/claims/cancel

**요약**: 주문취소 신청하기

**설명**:

## 부가설명 및 특이사항

주문을 취소신청하는 비회원용 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C.png)

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                         |
| ---------- | ------ | ------ | ---- | -------------------------------------------- | ---------------- |
| orderNo    | path   | string | ✅   | 주문 번호^                                   | 1                |
| ClientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id   |
| platform   | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| guestToken | header | string | ✅   | 비회원 토큰^                                 | test-guest-token |
| Version    | header | string | ✅   | API 버전^                                    | 1.0              |
| language   | header | string | ❌   | 언어 (기본값: ko)^                           | ko               |

**응답**:

- **204**: 204

---

## Member

### GET /profile/claims

**요약**: 회원 클레임 목록 조회하기

**설명**:

## 부가설명 및 특이사항

클레임 목록을 조회하는 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_claims%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EB%AA%A9%EB%A1%9D%20%EC%A1%B0%ED%9A%8C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_claims%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EB%AA%A9%EB%A1%9D%20%EC%A1%B0%ED%9A%8C.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                         |
| --------------------- | ------ | ------ | ---- | -------------------------------------------- | ------------------------ |
| claimTypes            | query  | string | ❌   | 클레임 구분(null인 경우 전체)^               | CANCEL                   |
| endYmd                | query  | string | ❌   | 조회 종료일(null인 경우 오늘)^               | yyyy-mm-dd               |
| hasTotalCount         | query  | string | ❌   | 목록 카운트 포함 여부(default: false)^       | false                    |
| pageNumber            | query  | string | ❌   | 페이지 번호 (1 이상)^                        | 1                        |
| pageSize              | query  | string | ❌   | 한 페이지당 노출 수^                         | 10                       |
| startYmd              | query  | string | ❌   | 조회 시작일(null인 경우 3개월 전)^           | yyyy-mm-dd               |
| ClientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **200**: 200

---

### POST /profile/claims/cancel

**요약**: 회원 옵션취소 신청하기(복수옵션)

**설명**:

## 부가설명 및 특이사항

다수의 선택옵션을 취소신청하는 API입니다.

## API Version

### 1.0

기존 방식으로, API 요청에 성공 시 204 No Content를 응답합니다.

### 1.1 (개발중)

변경된 방식으로, API 요청에 성공 시 200 Ok 와 신청된 클레임과 옵션에 대한 정보를 응답합니다. (문서 참조)

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                         |
| --------------------- | ------ | ------ | ---- | -------------------------------------------- | ------------------------ |
| ClientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **200**: 200

---

### POST /profile/claims/estimate

**요약**: 회원 클레임시 변경되는 주문의 환불 예상금액 계산하기(복수옵션)

**설명**:

## 부가설명 및 특이사항

다수의 선택옵션을 취소할 경우 환불 예상금액을 미리 계산하는 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                         |
| --------------------- | ------ | ------ | ---- | -------------------------------------------- | ------------------------ |
| ClientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **200**: 200

---

### POST /profile/claims/return

**요약**: 회원 반품 신청하기(복수옵션)

**설명**:

## 부가설명 및 특이사항

다수의 선택옵션을 반품하는 API입니다.

## API Version

### 1.0

기존 방식으로, API 요청에 성공 시 204 No Content를 응답합니다.

### 1.1 (개발중)

변경된 방식으로, API 요청에 성공 시 200 Ok 와 신청된 클레임과 옵션에 대한 정보를 응답합니다. (문서 참조)

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                         |
| --------------------- | ------ | ------ | ---- | -------------------------------------------- | ------------------------ |
| ClientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **200**: 200

---

### POST /profile/claims/free-gifts/satisfy

**요약**: 사은품 지급 조건 충족 여부 조회하기

**설명**:

## 부가설명 및 특이사항

클레임 이후에 사은품 지급 조건이 충족하는지 여부를 조회할 수 있는 API입니다.
정상상태의 옵션 금액의 합계로만 사은품 지급 여부를 판단합니다. (교환 출고 옵션도 계산에서 제외)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                         |
| --------------------- | ------ | ------ | ---- | -------------------------------------------- | ------------------------ |
| ClientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **200**: 200

---

### PUT /profile/claims/{claimNo}/account

**요약**: 회원 환불 계좌 정보 수정하기

**설명**:

## 부가설명 및 특이사항

환불 계좌 정보를 수정하는 API입니다.

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                         |
| --------------------- | ------ | ------- | ---- | -------------------------------------------- | ------------------------ |
| claimNo               | path   | integer | ✅   | 클레임 번호^                                 | 1                        |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string  | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string  | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **204**: 204

---

### GET /profile/claims/{claimNo}/check-withdraw

**요약**: 회원 클레임 철회시 유효성 검증 타입 조회하기

**설명**:

## 부가설명 및 특이사항

클레임 철회시 유효성 검증 타입 조회하는 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                         |
| --------------------- | ------ | ------- | ---- | -------------------------------------------- | ------------------------ |
| claimNo               | path   | integer | ✅   | 클레임 번호^                                 | 1                        |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string  | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string  | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **200**: 200

---

### GET /profile/claims/{claimNo}/result

**요약**: 회원 클레임 상세보기(클레임 번호)

**설명**:

## 부가설명 및 특이사항

클레임 번호로 클레임 세부 내역을 조회합니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_claims_result%20클레임%20상세보기%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_claims_result%20클레임%20상세보기%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_claims_result%20클레임%20상세보기%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_claims_result%20클레임%20상세보기%201-2.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_claims_result%20클레임%20상세보기%201-3.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_claims_result%20클레임%20상세보기%201-3.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_claims_result%20클레임%20상세보기%201-4.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_claims_result%20클레임%20상세보기%201-4.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                         |
| --------------------- | ------ | ------- | ---- | -------------------------------------------- | ------------------------ |
| claimNo               | path   | integer | ✅   | 클레임 번호^                                 | 1                        |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string  | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string  | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **200**: 200

---

### PUT /profile/claims/{claimNo}/withdraw

**요약**: 회원 클레임 철회하기(클레임번호)

**설명**:

## 부가설명 및 특이사항

클레임 번호로 신청된 클레임을 철회하는 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_claims_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                         |
| --------------------- | ------ | ------- | ---- | -------------------------------------------- | ------------------------ |
| claimNo               | path   | integer | ✅   | 클레임 번호^                                 | 1                        |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string  | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string  | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **204**: 204

---

### GET /profile/order-options/{orderOptionNo}/claims

**요약**: 회원 클레임 신청을 위한 정보 조회하기

**설명**:

## 부가설명 및 특이사항

선택옵션에 대한 클레임을 신청할 때 필요한 정보를 조회합니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_claim%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%8B%A0%EC%B2%AD%EA%B0%80%EB%8A%A5%20%EC%A0%95%EB%B3%B4%20%EC%A1%B0%ED%9A%8C%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_claim%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%8B%A0%EC%B2%AD%EA%B0%80%EB%8A%A5%20%EC%A0%95%EB%B3%B4%20%EC%A1%B0%ED%9A%8C%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_claim%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%8B%A0%EC%B2%AD%EA%B0%80%EB%8A%A5%20%EC%A0%95%EB%B3%B4%20%EC%A1%B0%ED%9A%8C%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_claim%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%8B%A0%EC%B2%AD%EA%B0%80%EB%8A%A5%20%EC%A0%95%EB%B3%B4%20%EC%A1%B0%ED%9A%8C%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                                     |
| --------------------- | ------ | ------- | ---- | -------------------------------------------------------- | ------------------------ |
| orderOptionNo         | path   | integer | ✅   | 주문 상품 옵션 번호^                                     | 1                        |
| claimType             | query  | string  | ✅   | 클레임 타입(CANCEL: 취소, RETURN: 반품, EXCHANGE: 교환)^ | CANCEL                   |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                                | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^             | PC                       |
| accessToken           | header | string  | ❌   | 로그인 인증키^                                           | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                                | Bearer test-access-token |
| Version               | header | string  | ✅   | API 버전^                                                | 1.0                      |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                                       | ko                       |

**응답**:

- **200**: 200

---

### POST /profile/order-options/{orderOptionNo}/claims/cancel

**요약**: 회원 옵션취소 신청하기(단일옵션)

**설명**:

## 부가설명 및 특이사항

단일옵션을 취소신청하는 API입니다.

## API Version

### 1.0

기존 방식으로, API 요청에 성공 시 204 No Content를 응답합니다.

### 1.1 (개발중)

변경된 방식으로, API 요청에 성공 시 200 Ok 와 신청된 클레임과 옵션에 대한 정보를 응답합니다. (문서 참조)

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_order-options_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_order-options_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_order-options_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_order-options_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                         |
| --------------------- | ------ | ------- | ---- | -------------------------------------------- | ------------------------ |
| orderOptionNo         | path   | integer | ✅   | 주문 상품 옵션 번호^                         | 1                        |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string  | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string  | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **200**: 200

---

### GET /profile/order-options/{orderOptionNo}/claims/estimate

**요약**: 회원 클레임시 변경되는 주문의 환불 예상금액 계산하기(단일옵션)

**설명**:

## 부가설명 및 특이사항

선택옵션을 취소할 경우 환불 예상금액을 미리 계산하는 API입니다.

## 참고

ClaimType을 EXCHANGE로 요청 시 exchangeProductNo, exchangeOptionNo, exchangeCnt가 null일 경우
동일상품, 동일옵션, 교환수량으로 환불예상금액을 조회합니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_claim_estimate%20클레임%20시%20변경되는%20주문%20환불계산%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| --------------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| orderOptionNo         | path   | integer | ✅   | 주문 상품 옵션 번호^                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 1                        |
| claimReasonType       | query  | string  | ✅   | 클레임사유(CHANGE_MIND: 단순변심(색상,사이즈 등), DEFECTIVE_PRODUCT: 상품불량/파손, WRONG_DELIVERY: 배송누락/오배송, OUT_OF_STOCK_SYSTEM: 재고부족(품절취소), CANCEL_BEFORE_PAY: 입금전취소, WRONG_PRODUCT_DETAIL: 상품상세 정보와 다름, DELAY_DELIVERY: 판매자 배송 지연, OTHERS_SELLER: 기타(판매자 귀책), OTHERS_BUYER: 기타(구매자 귀책), OUT_OF_STOCK: 상품 품절/재고 없음, LATER_INPUT_ORDER: 배송지 미입력 취소, LATER_INPUT_ORDER_RECEIVER_CANCEL: 선물거절취소)^ | CHANGE_MIND              |
| claimType             | query  | string  | ✅   | 클레임타입(CANCEL: 취소, RETURN: 반품, EXCHANGE: 교환)^                                                                                                                                                                                                                                                                                                                                                                                                                   | CANCEL                   |
| exchangeCnt           | query  | string  | ❌   | 교환할수량(claimType이 EXCHANGE인 경우)^                                                                                                                                                                                                                                                                                                                                                                                                                                  | 1                        |
| exchangeOptionNo      | query  | string  | ❌   | 교환할옵션번호(claimType이 EXCHANGE인 경우)^                                                                                                                                                                                                                                                                                                                                                                                                                              | 1                        |
| exchangeProductNo     | query  | string  | ❌   | 교환할상품번호(claimType이 EXCHANGE인 경우)^                                                                                                                                                                                                                                                                                                                                                                                                                              | 1                        |
| productCnt            | query  | string  | ✅   | 취소/반품할 제품수량^                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 1                        |
| responsibleObjectType | query  | string  | ❌   | 귀책 - responsibleObjectType이 null이면 ClaimReasonType에 매핑되는 귀책 적용(CHANGE_MIND, CANCEL_BEFORE_PAY, OTHERS_BUYER -> BUYER / DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER -> SELLER)(BUYER: 구매자귀책, SELLER: 판매자귀책)^                                                                                                                                                         | BUYER                    |
| returnWayType         | query  | string  | ❌   | 반품상품 수거방법(SELLER_COLLECT: 판매자수거요청, BUYER_DIRECT_RETURN: 구매자직접반품)^                                                                                                                                                                                                                                                                                                                                                                                   | SELLER_COLLECT           |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                                                                                                                                                                                                                                                                                                                                                                                                                                                 | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^                                                                                                                                                                                                                                                                                                                                                                                                                              | PC                       |
| accessToken           | header | string  | ❌   | 로그인 인증키^                                                                                                                                                                                                                                                                                                                                                                                                                                                            | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Bearer test-access-token |
| Version               | header | string  | ✅   | API 버전^                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 1.0                      |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                                                                                                                                                                                                                                                                                                                                                                                                                                                        | ko                       |

**응답**:

- **200**: 200

---

### POST /profile/order-options/{orderOptionNo}/claims/exchange

**요약**: 회원 클레임 교환 신청하기

**설명**:

## 부가설명 및 특이사항

선택옵션을 교환하는 API입니다.

## API Version

### 1.0

기존 방식으로, API 요청에 성공 시 204 No Content를 응답합니다.

### 1.1 (개발중)

변경된 방식으로, API 요청에 성공 시 200 Ok 와 신청된 클레임과 옵션에 대한 정보를 응답합니다. (문서 참조)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                         |
| --------------------- | ------ | ------- | ---- | -------------------------------------------- | ------------------------ |
| orderOptionNo         | path   | integer | ✅   | 주문 상품 옵션 번호^                         | 1                        |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string  | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string  | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **200**: 200

---

### GET /profile/order-options/{orderOptionNo}/claims/result

**요약**: 회원 클레임 상세보기(주문상품 옵션번호)

**설명**:

## 부가설명 및 특이사항

주문상품 옵션번호로 클레임 세부 내역을 조회하는 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_claim_result%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EB%B3%B4%EA%B8%B0%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_claim_result%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EB%B3%B4%EA%B8%B0%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_claim_result%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EB%B3%B4%EA%B8%B0%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_claim_result%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EB%B3%B4%EA%B8%B0%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                         |
| --------------------- | ------ | ------- | ---- | -------------------------------------------- | ------------------------ |
| orderOptionNo         | path   | integer | ✅   | 주문 상품 옵션 번호^                         | 1                        |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string  | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string  | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **200**: 200

---

### POST /profile/order-options/{orderOptionNo}/claims/return

**요약**: 회원 반품 신청하기(단일옵션)

**설명**:

## 부가설명 및 특이사항

단일옵션을 반품하는 API입니다.

## API Version

### 1.0

기존 방식으로, API 요청에 성공 시 204 No Content를 응답합니다.

### 1.1 (개발중)

변경된 방식으로, API 요청에 성공 시 200 Ok 와 신청된 클레임과 옵션에 대한 정보를 응답합니다. (문서 참조)

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_order-options_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_order-options_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_order-options_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_order-options_claim_return%20%EB%B0%98%ED%92%88%EC%8B%A0%EC%B2%AD%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                         |
| --------------------- | ------ | ------- | ---- | -------------------------------------------- | ------------------------ |
| orderOptionNo         | path   | integer | ✅   | 주문 상품 옵션 번호^                         | 1                        |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string  | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string  | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **200**: 200

---

### PUT /profile/order-options/{orderOptionNo}/claims/withdraw

**요약**: 회원 클레임 철회하기(주문상품 옵션번호)

**설명**:

## 부가설명 및 특이사항

주문상품 옵션번호로 신청된 클레임을 철회하는 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_claim_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_claim_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_claim_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_claim_withdraw%20%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%B2%A0%ED%9A%8C%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                         |
| --------------------- | ------ | ------- | ---- | -------------------------------------------- | ------------------------ |
| orderOptionNo         | path   | integer | ✅   | 주문 상품 옵션 번호^                         | 1                        |
| ClientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string  | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string  | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **204**: 204

---

### POST /profile/orders/{orderNo}/claims/cancel

**요약**: 회원 주문취소 신청하기

**설명**:

## 부가설명 및 특이사항

주문을 취소신청하는 API입니다.

## 화면 예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_orders_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_orders_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_orders_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_orders_claim_cancle%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                         |
| --------------------- | ------ | ------ | ---- | -------------------------------------------- | ------------------------ |
| orderNo               | path   | string | ✅   | 주문 번호^                                   | 1                        |
| ClientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                    | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| accessToken           | header | string | ❌   | 로그인 인증키^                               | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                    | Bearer test-access-token |
| Version               | header | string | ✅   | API 버전^                                    | 1.0                      |
| language              | header | string | ❌   | 언어 (기본값: ko)^                           | ko                       |

**응답**:

- **204**: 204

---
