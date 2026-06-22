# order-shop

**버전**: 0.1.0-SNAPSHOT
**서버**: https://shop-api.e-ncp.com

주문(order) 관련 shop API입니다.

---

## AppCard

### GET /app-card/cards

**요약**: [개발중] 앱카드 간편결제 카드사 목록 조회

**설명**:

## 부가설명 및 특이사항

쇼핑몰에서 사용할 수 있는 앱카드 카드사 목록을 조회한다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| cardCode | query  | string | ❌   | 특정 카드사^                                  | 2088           |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| language | header | string | ❌   | 언어 (기본 값: ko)^                           | ko             |

**응답**:

- **200**: 200

---

### GET /app-card/inst-plan

**요약**: [개발중] 앱카드 할부정보 조회

**설명**:

## 부가설명 및 특이사항

쇼핑몰의 앱카드 할부정보를 조회한다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| amount   | query  | number | ❌   | 상품금액^                                     | 50000          |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| language | header | string | ❌   | 언어 (기본 값: ko)^                           | ko             |

**응답**:

- **200**: 200

---

### GET /app-card/pay-cards

**요약**: [개발중] 앱카드 간편결제카드 목록 조회

**설명**:

## 부가설명 및 특이사항

앱카드 회원의 간편결제카드 목록을 조회한다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| cardCode              | query  | string | ❌   | 특정 카드사^                                  | 2088                     |
| amount                | query  | number | ❌   | 상품금액^                                     | 50000                    |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /app-card/auth/{orderNo}

**요약**: [개발중] 앱카드 인증결과 조회

**설명**:

## 부가설명 및 특이사항

해당 주문번호의 앱카드 인증 여부를 조회한다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderNo               | path   | string | ✅   | 주문번호^                                     | test-order-no            |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### DELETE /app-card/pay-cards/{acntId}

**요약**: [개발중] 앱카드 간편결제 카드 삭제

**설명**:

## 부가설명 및 특이사항

해당 카드 아이디와 일치하는 간편결제 카드를 삭제한다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| acntId                | path   | string | ✅   | 간편결제 계정 아이디^                         | test-acnt-id             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### GET /app-card/qr/{orderNo}

**요약**: [개발중] 앱카드 결제 QR 생성

**설명**:

## 부가설명 및 특이사항

해당 주문번호의 앱카드 결제 QR을 생성한다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderNo               | path   | string | ✅   | 주문번호^                                     | test-order-no            |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

## Cart

### GET /cart

**요약**: 장바구니 가져오기

**설명**:

## 부가설명 및 특이사항

로그인된 유저의 장바구니 목록을 조회하기 위한 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EB%AA%A9%EB%A1%9D%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EB%AA%A9%EB%A1%9D%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | ------------------------ |
| divideInvalidProducts | query  | boolean | ❌   | 구매하지 못하는 상품 분할여부^                | true                     |
| groupId               | query  | string  | ❌   | 장바구니 그룹 아이디^                         | cartGroupId              |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /cart

**요약**: 장바구니 등록하기

**설명**:

## 부가설명 및 특이사항

로그인된 유저의 장바구니에 상품(옵션)을 추가하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /cart

**요약**: 장바구니 수정하기

**설명**:

## 부가설명 및 특이사항

로그인된 유저의 장바구니의 상품 중 구매 수량과 사용자 입력형 옵션을 수정하는 API 입니다.

옵션 종류는 변경할 수 없습니다.

옵션변경은 변경할 옵션을 삭제한 후 신규등록하는 방법으로 수정합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### DELETE /cart

**요약**: 장바구니 삭제하기

**설명**:

## 부가설명 및 특이사항

장바구니 목록에서 장바구니를 삭제하는 API 입니다.

cartNo를 List형으로 전달해야 합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| cartNo                | query  | string | ✅   | 장바구니 번호^                                | 1,2,3                    |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /cart/calculate

**요약**: 장바구니에서 선택된 상품금액 계산하기

**설명**:

## 부가설명 및 특이사항

장바구니에서 선택된 상품만 계산하여 금액만 리턴하는 API 입니다.

아래 화면예시에서 상품/옵션별 배송비는 업데이트(재계산)하지 못합니다.

cartNo 파라미터 자체를 넘기지 않는 경우 : 장바구니 전체

cartNo 에 빈 값을 넘기는 경우 : 0원

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart_calculate%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EC%84%A0%ED%83%9D%20%EA%B3%84%EC%82%B0.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart_calculate%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EC%84%A0%ED%83%9D%20%EA%B3%84%EC%82%B0.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | ------------------------ |
| cartNo                | query  | string  | ❌   | 선택된 장바구니 번호^                         | 1,2,3                    |
| divideInvalidProducts | query  | boolean | ❌   | 구매하지 못하는 상품 분할여부^                | true                     |
| groupId               | query  | string  | ❌   | 장바구니 그룹 아이디^                         | cartGroupId              |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /cart/count

**요약**: 장바구니에 담긴 상품 개수 가져오기

**설명**:

## 부가설명 및 특이사항

로그인된 유저의 장바구니에 담긴 상품 개수를 조회하기 위한 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /cart/subset

**요약**: 장바구니에서 선택된 항목만 장바구니 그룹별로 재계산하기

**설명**:

## 부가설명 및 특이사항

장바구니에서 선택된 상품만 계산하여 장바구니 상품들과 금액까지 포함해서 리턴하는 API 입니다.

아래 화면예시에서 상품/옵션별 배송비를 함께 업데이트(재계산)할 수 있습니다.

cartNo 파라미터 자체를 넘기지 않는 경우 : 장바구니 전체

cartNo 에 빈 값을 넘기는 경우 : 0원

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart_subset%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%EC%97%90%EC%84%9C%20%EC%84%A0%ED%83%9D%EB%90%9C%20%ED%95%AD%EB%AA%A9%EB%A7%8C%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B7%B8%EB%A3%B9%EB%B3%84%EB%A1%9C%20%EC%9E%AC%20%EA%B3%84%EC%82%B0.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart_subset%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%EC%97%90%EC%84%9C%20%EC%84%A0%ED%83%9D%EB%90%9C%20%ED%95%AD%EB%AA%A9%EB%A7%8C%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B7%B8%EB%A3%B9%EB%B3%84%EB%A1%9C%20%EC%9E%AC%20%EA%B3%84%EC%82%B0.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | ------------------------ |
| cartNo                | query  | string  | ❌   | 선택된 장바구니 번호^                         | 1,2,3                    |
| divideInvalidProducts | query  | boolean | ❌   | 구매하지 못하는 상품 분할여부^                | true                     |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /cart/validate

**요약**: 장바구니에 저장된 모든 상품 구매 가능 여부 확인하기

**설명**:

## 부가설명 및 특이사항

장바구니에 저장된 모든 상품의 구매 가능 여부를 확인하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /cart/coupons/maximum

**요약**: 장바구니 기준 최대 쿠폰 할인 금액 가져오기

**설명**:

## 부가설명 및 특이사항

장바구니 기준으로 최대 할인이 가능한 쿠폰 정보를 조회합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| cartNo                | query  | number | ✅   | 장바구니 번호^                                | 1                        |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

## GuestOrder

### POST /guest/cart

**요약**: 비회원 장바구니 계산하기

**설명**:

## 부가설명 및 특이사항

비회원의 장바구니금액 및 합배송 상품을 계산하여 목록을 가져오는 API 입니다.

쇼핑몰배송의 경우, 파트너명을 '쇼핑몰배송'으로 내려줍니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_cart%20%EA%B2%8C%EC%8A%A4%ED%8A%B8%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B3%84%EC%82%B0%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_cart%20%EA%B2%8C%EC%8A%A4%ED%8A%B8%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B3%84%EC%82%B0%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_cart%20%EA%B2%8C%EC%8A%A4%ED%8A%B8%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B3%84%EC%82%B0%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_cart%20%EA%B2%8C%EC%8A%A4%ED%8A%B8%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B3%84%EC%82%B0%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | -------------- |
| divideInvalidProducts | query  | boolean | ❌   | 구매하지 못하는 상품 분할여부^                | true           |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0            |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko             |

**응답**:

- **200**: 200

---

### GET /guest/orders/{orderNo}

**요약**: 비회원 주문 상세 조회하기

**설명**:

## 부가설명 및 특이사항

비회원 주문의 상세정보를 조회하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_orders%20%EB%B9%84%ED%9A%8C%EC%9B%90%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_orders%20%EB%B9%84%ED%9A%8C%EC%9B%90%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_orders%20%EB%B9%84%ED%9A%8C%EC%9B%90%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_orders%20%EB%B9%84%ED%9A%8C%EC%9B%90%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C%201-2.png)

**파라미터**:

| 이름             | 위치   | 타입   | 필수 | 설명                                                               |
| ---------------- | ------ | ------ | ---- | ------------------------------------------------------------------ | ------------------- |
| orderNo          | path   | string | ✅   | -                                                                  |
| orderRequestType | query  | string | ❌   | 주문옵션타입 (ALL: 전체, CLAIM: 클레임진행, NORMAL: 클레임미진행)^ | CLAIM               |
| Version          | header | string | ✅   | API 버전^                                                          | 1.0                 |
| clientId         | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                          | test-client-id      |
| platform         | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                      | PC                  |
| language         | header | string | ❌   | 언어 (기본 값: ko)^                                                | ko                  |
| guestToken       | header | string | ✅   | guestToken^                                                        | 12121a3-123123-1213 |

**응답**:

- **200**: 200

---

### POST /guest/orders/{orderNo}

**요약**: 비회원 주문 토큰 발급하기

**설명**:

## 부가설명 및 특이사항

주문번호, 패스워드, 이름, 핸드폰번호, 이메일로 주문 상세를 조회하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_orders%20%EB%B9%84%ED%9A%8C%EC%9B%90%20%EC%A3%BC%EB%AC%B8%20%ED%86%A0%ED%81%B0%20%EB%B0%9C%EA%B8%89.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_orders%20%EB%B9%84%ED%9A%8C%EC%9B%90%20%EC%A3%BC%EB%AC%B8%20%ED%86%A0%ED%81%B0%20%EB%B0%9C%EA%B8%89.png)

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| orderNo  | path   | string | ✅   | 주문번호^                                     | 2020010101012  |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| language | header | string | ❌   | 언어 (기본 값: ko)^                           | ko             |

**응답**:

- **200**: 200

---

### PUT /guest/order-options/{orderOptionNo}/confirm

**요약**: 비회원 상품 주문 구매확정 처리하기

**설명**:

## 부가설명 및 특이사항

배송중, 배송완료 상태의 상품주문을 구매확정 처리하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_order-options_confirm%20%EC%83%81%ED%92%88%20%EC%A3%BC%EB%AC%B8%20%EA%B5%AC%EB%A7%A4%ED%99%95%EC%A0%95.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_order-options_confirm%20%EC%83%81%ED%92%88%20%EC%A3%BC%EB%AC%B8%20%EA%B5%AC%EB%A7%A4%ED%99%95%EC%A0%95.png)

**파라미터**:

| 이름          | 위치   | 타입   | 필수 | 설명                                          |
| ------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------- |
| orderOptionNo | path   | number | ✅   | 주문번호^                                     | 121212              |
| Version       | header | string | ✅   | API 버전^                                     | 1.0                 |
| clientId      | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id      |
| platform      | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                  |
| language      | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                  |
| guestToken    | header | string | ✅   | guestToken^                                   | 12121a3-123123-1213 |

**응답**:

- **204**: 204

---

### PUT /guest/order-options/{orderOptionNo}/delivery-done

**요약**: 비회원 상품 주문 배송완료 처리하기

**설명**:

## 부가설명 및 특이사항

배송중 상태의 상품주문을 배송완료 처리하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_order-options_delivery-done%20%EC%83%81%ED%92%88%20%EC%A3%BC%EB%AC%B8%20%EB%B0%B0%EC%86%A1%EC%99%84%EB%A3%8C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_order-options_delivery-done%20%EC%83%81%ED%92%88%20%EC%A3%BC%EB%AC%B8%20%EB%B0%B0%EC%86%A1%EC%99%84%EB%A3%8C.png)

**파라미터**:

| 이름          | 위치   | 타입   | 필수 | 설명                                          |
| ------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------- |
| orderOptionNo | path   | number | ✅   | 주문번호^                                     | 121212              |
| Version       | header | string | ✅   | API 버전^                                     | 1.0                 |
| clientId      | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id      |
| platform      | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                  |
| language      | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                  |
| guestToken    | header | string | ✅   | guestToken^                                   | 12121a3-123123-1213 |

**응답**:

- **204**: 204

---

### POST /guest/orders/{orderNo}/cashReceipt

**요약**: 비회원 현금영수증 신청하기

**설명**:

## 부가설명 및 특이사항

구매자가 무통장입금 주문에 대하여 현금영수증을 발급하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_orders_cashReceipt%20%EB%B9%84%ED%9A%8C%EC%9B%90%20%ED%98%84%EA%B8%88%EC%98%81%EC%88%98%EC%A6%9D%20%EC%8B%A0%EC%B2%AD.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_orders_cashReceipt%20%EB%B9%84%ED%9A%8C%EC%9B%90%20%ED%98%84%EA%B8%88%EC%98%81%EC%88%98%EC%A6%9D%20%EC%8B%A0%EC%B2%AD.png)

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                          |
| ---------- | ------ | ------ | ---- | --------------------------------------------- | ------------------- |
| orderNo    | path   | string | ✅   | 주문번호^                                     | 2020042100000001    |
| Version    | header | string | ✅   | API 버전^                                     | 1.0                 |
| clientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id      |
| platform   | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                  |
| language   | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                  |
| guestToken | header | string | ✅   | guestToken^                                   | 12121a3-123123-1213 |

**응답**:

- **200**: 200

---

### PUT /guest/orders/{orderNo}/cashReceipt

**요약**: 현금영수증 신청정보 수정 (무통장 입금 주문)

**설명**:

## 부가설명 및 특이사항

현금영수증 발급을 신청한 무통장입금 주문의 현금영수증 신청 정보를 수정하는 API입니다.<br />
주문이 입금 대기상태인 경우에만 수정 가능합니다.<br />

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                          |
| ---------- | ------ | ------ | ---- | --------------------------------------------- | ------------------- |
| orderNo    | path   | string | ✅   | 주문번호^                                     | 2020042100000001    |
| Version    | header | string | ✅   | API 버전^                                     | 1.0                 |
| clientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id      |
| platform   | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                  |
| language   | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                  |
| guestToken | header | string | ✅   | guestToken^                                   | 12121a3-123123-1213 |

**응답**:

- **200**: 200

---

### GET /guest/orders/{orderNo}/claim

**요약**: 비회원 주문 상세 조회하기 (클레임 상세사유 포함)

**설명**:

## 부가설명 및 특이사항

주문번호, 토큰으로 상세 데이터를 조회하는 API 입니다.

클레임 상세사유를 포함합니다.

## 화면예시

[![](<http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_orders_claim%20%EC%A0%84%EC%B2%B4%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%EB%A5%BC%20%EC%9C%84%ED%95%9C%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C(%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EC%82%AC%EC%9C%A0%20%ED%8F%AC%ED%95%A8)%201-1.png?autox150>)](<http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_orders_claim%20%EC%A0%84%EC%B2%B4%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%EB%A5%BC%20%EC%9C%84%ED%95%9C%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C(%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EC%82%AC%EC%9C%A0%20%ED%8F%AC%ED%95%A8)%201-1.png>)
[![](<http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_orders_claim%20%EC%A0%84%EC%B2%B4%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%EB%A5%BC%20%EC%9C%84%ED%95%9C%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C(%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EC%82%AC%EC%9C%A0%20%ED%8F%AC%ED%95%A8)%201-2.png?autox150>)](<http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_orders_claim%20%EC%A0%84%EC%B2%B4%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%EB%A5%BC%20%EC%9C%84%ED%95%9C%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C(%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EC%82%AC%EC%9C%A0%20%ED%8F%AC%ED%95%A8)%201-2.png>)

**파라미터**:

| 이름             | 위치   | 타입   | 필수 | 설명                                                               |
| ---------------- | ------ | ------ | ---- | ------------------------------------------------------------------ | -------------- |
| orderNo          | path   | string | ✅   | -                                                                  |
| orderRequestType | query  | string | ❌   | 주문옵션타입 (ALL: 전체, CLAIM: 클레임진행, NORMAL: 클레임미진행)^ | CLAIM          |
| claimType        | query  | string | ❌   | 클레임타입 (CANCEL, RETURN, EXCHANGE, NONE)^                       | CANCEL         |
| Version          | header | string | ✅   | API 버전^                                                          | 1.0            |
| clientId         | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                          | test-client-id |
| platform         | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                      | PC             |
| language         | header | string | ❌   | 언어 (기본 값: ko)^                                                | ko             |

**응답**:

- **200**: 200

---

### PUT /guest/orders/{orderNo}/deliveries

**요약**: 비회원 주문단위 배송정보 수정하기

**설명**:

## 부가설명 및 특이사항

주문번호에 속한 배송정보를 일괄 수정하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_orders_deliveries%20%EC%A3%BC%EB%AC%B8%EB%8B%A8%EC%9C%84%20%EB%B0%B0%EC%86%A1%EC%A0%95%EB%B3%B4%20%EC%88%98%EC%A0%95%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_orders_deliveries%20%EC%A3%BC%EB%AC%B8%EB%8B%A8%EC%9C%84%20%EB%B0%B0%EC%86%A1%EC%A0%95%EB%B3%B4%20%EC%88%98%EC%A0%95%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_orders_deliveries%20%EC%A3%BC%EB%AC%B8%EB%8B%A8%EC%9C%84%20%EB%B0%B0%EC%86%A1%EC%A0%95%EB%B3%B4%20%EC%88%98%EC%A0%95%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[PUT]%20guest_orders_deliveries%20%EC%A3%BC%EB%AC%B8%EB%8B%A8%EC%9C%84%20%EB%B0%B0%EC%86%A1%EC%A0%95%EB%B3%B4%20%EC%88%98%EC%A0%95%201-2.png)

**파라미터**:

| 이름       | 위치   | 타입    | 필수 | 설명                                          |
| ---------- | ------ | ------- | ---- | --------------------------------------------- | ------------------- |
| orderNo    | path   | string  | ✅   | 주문옵션번호^                                 | 2010121010          |
| add        | query  | boolean | ❌   | 주소지 추가 여부^                             | true                |
| Version    | header | string  | ✅   | API 버전^                                     | 1.0                 |
| clientId   | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id      |
| platform   | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                  |
| language   | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                  |
| guestToken | header | string  | ✅   | guestToken^                                   | 12121a3-123123-1213 |

**응답**:

- **204**: 204

---

### GET /guest/orders/{orderNo}/forgot-password

**요약**: 비회원 초기화된 주문 패스워드 전송하기

**설명**:

## 부가설명 및 특이사항

비밀번호를 분실한 사용자를 위해서 주문번호를 이용해 패스워드를 초기화 시키고, 입력한 e-mail 또는 sms로 초기화된 비밀번호를 전달하는 API 입니다.
주문번호 외의 주문자명, 핸드폰번호, 이메일 등으로 추가 인증 처리를 하기 위해서는 설정 정보를 변경해야 하며, 해당 설정 정보는 샵바이 관리자에게 문의하여 수정 가능합니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_orders_forgot-password%20%EB%B9%84%ED%9A%8C%EC%9B%90%20%EC%A3%BC%EB%AC%B8%20%ED%8C%A8%EC%8A%A4%EC%9B%8C%EB%93%9C%20%EC%9E%AC%EC%A0%84%EC%86%A1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[GET]%20guest_orders_forgot-password%20%EB%B9%84%ED%9A%8C%EC%9B%90%20%EC%A3%BC%EB%AC%B8%20%ED%8C%A8%EC%8A%A4%EC%9B%8C%EB%93%9C%20%EC%9E%AC%EC%A0%84%EC%86%A1.png)

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                          |
| --------- | ------ | ------ | ---- | --------------------------------------------- | ------------------ |
| orderNo   | path   | string | ✅   | 주문번호^                                     | 202110081443456213 |
| replyType | query  | string | ✅   | 비밀번호 받을 방식 (EMAIL: 이메일, SMS: sms)^ | EMAIL              |
| mobileNo  | query  | string | ❌   | 주문자 핸드폰 번호^                           | 01012345678        |
| email     | query  | string | ❌   | 주문자 이메일^                                | test@nhn.com       |
| name      | query  | string | ❌   | 주문자명^                                     | 홍길동             |
| Version   | header | string | ✅   | API 버전^                                     | 1.0                |
| clientId  | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id     |
| platform  | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                 |
| language  | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                 |

**응답**:

- **204**: 204

---

## LaterShippingInput

### GET /later-input/areafees

**요약**: [샵바이 엔터프라이즈 전용] 지역별 추가 배송비 목록 조회하기 (배송비템플릿 번호 또는 암호화된 배송 번호 리스트 사용)

**설명**:

## 부가설명 및 특이사항

배송비템플릿 번호 또는 암호화된 배송번호 리스트로 지역별 추가 배송비 목록을 조회하는 API 입니다.
(두 필드 중 하나만 입력해야 합니다.)

암호화 된 배송 번호 리스트(encryptedShippingNo): 선물하는 시점에 동일한 수령자 연락처를 입력한 배송번호 목록

배송번호 리스트 중 1개 이상의 배송에 추가 배송비를 부과하는 주소가 응답됩니다.

**파라미터**:

| 이름                | 위치   | 타입   | 필수 | 설명                                          |
| ------------------- | ------ | ------ | ---- | --------------------------------------------- | -------------------------------- |
| templateNo          | query  | string | ❌   | 배송비 템플릿 번호^                           | 12345                            |
| encryptedShippingNo | query  | string | ❌   | 암호화된 배송 번호 리스트^                    | UFE3Ylo2aUlkSWVuZHVGQjYyS2pZZz09 |
| Version             | header | string | ✅   | API 버전^                                     | 1.0                              |
| clientId            | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id                   |
| platform            | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                               |
| language            | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                               |

**응답**:

- **200**: 200

---

### GET /later-input/order

**요약**: [샵바이 엔터프라이즈 전용] 나중배송입력 주문 상세 조회하기

**설명**:

## 부가명 및 특이사항

암호화된 배송 번호 리스트로 주문 상세정보를 조회하는 API 입니다.

암호화 된 배송 번호 리스트(encryptedShippingNo): 선물하는 시점에 동일한 수령자 연락처를 입력한 배송번호 목록

**파라미터**:

| 이름                | 위치   | 타입   | 필수 | 설명                                                               |
| ------------------- | ------ | ------ | ---- | ------------------------------------------------------------------ | -------------------------------- |
| orderRequestType    | query  | string | ❌   | 주문옵션타입 (ALL: 전체, CLAIM: 클레임진행, NORMAL: 클레임미진행)^ | ALL                              |
| Version             | header | string | ✅   | API 버전^                                                          | 1.0                              |
| clientId            | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                          | test-client-id                   |
| platform            | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                      | PC                               |
| language            | header | string | ❌   | 언어 (기본 값: ko)^                                                | ko                               |
| encryptedShippingNo | header | string | ✅   | 암호화된 배송 번호 리스트^                                         | RDFlU2czQ3dZeGM1YXlMYm9XSklidz09 |

**응답**:

- **200**: 200

---

### GET /later-input/shippings

**요약**: [샵바이 엔터프라이즈 전용] 나중 입력 배송지 조회하기

**설명**:

## 부가설명 및 특이사항

나중에 입력된 배송지를 조회하는 API 입니다.

암호화 된 배송 번호 리스트(encryptedShippingNo): 선물하는 시점에 동일한 수령자 연락처를 입력한 배송번호 목록

**파라미터**:

| 이름                | 위치   | 타입   | 필수 | 설명                                          |
| ------------------- | ------ | ------ | ---- | --------------------------------------------- | -------------------------------- |
| Version             | header | string | ✅   | API 버전^                                     | 1.0                              |
| clientId            | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id                   |
| platform            | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                               |
| language            | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                               |
| encryptedShippingNo | header | string | ✅   | 암호화된 배송 번호 리스트^                    | UFE3Ylo2aUlkSWVuZHVGQjYyS2pZZz09 |

**응답**:

- **200**: 200

---

### PUT /later-input/shippings

**요약**: [샵바이 엔터프라이즈 전용] 나중 입력 배송지 정보 수정하기

**설명**:

## 부가설명 및 특이사항

나중에 입력된 배송지 정보를 수정하는 API 입니다.

암호화 된 배송 번호 리스트(encryptedShippingNo): 선물하는 시점에 동일한 수령자 연락처를 입력한 배송번호

암호화된 배송 번호 리스트(encryptedShippingNo)에 해당하는 모든 배송지를 수정합니다.

**파라미터**:

| 이름                | 위치   | 타입   | 필수 | 설명                                          |
| ------------------- | ------ | ------ | ---- | --------------------------------------------- | -------------------------------- |
| Version             | header | string | ✅   | API 버전^                                     | 1.0                              |
| clientId            | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id                   |
| platform            | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                               |
| language            | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                               |
| encryptedShippingNo | header | string | ✅   | 암호화된 배송 번호 리스트^                    | UFE3Ylo2aUlkSWVuZHVGQjYyS2pZZz09 |

**응답**:

- **204**: 204

---

### GET /shippings/{encryptedShippingNo}/later-input

**요약**: [샵바이 엔터프라이즈 전용] 나중 입력 배송지 조회하기

**설명**:

## 부가설명 및 특이사항

나중에 입력된 배송지를 조회하는 API 입니다.

암호화 된 배송 번호 리스트(encryptedShippingNo): 선물하는 시점에 동일한 수령자 연락처를 입력한 배송번호 목록

**파라미터**:

| 이름                | 위치   | 타입   | 필수 | 설명                                          |
| ------------------- | ------ | ------ | ---- | --------------------------------------------- | -------------------------------- |
| encryptedShippingNo | path   | string | ✅   | 암호화된 배송 번호 리스트^                    | UFE3Ylo2aUlkSWVuZHVGQjYyS2pZZz09 |
| Version             | header | string | ✅   | API 버전^                                     | 1.0                              |
| clientId            | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id                   |
| platform            | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                               |
| language            | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                               |

**응답**:

- **200**: 200

---

### PUT /shippings/{encryptedShippingNo}/later-input

**요약**: [샵바이 엔터프라이즈 전용] 나중 입력 배송지 정보 수정하기

**설명**:

## 부가설명 및 특이사항

나중에 입력된 배송지 정보를 수정하는 API 입니다.

암호화 된 배송 번호 리스트(encryptedShippingNo): 선물하는 시점에 동일한 수령자 연락처를 입력한 배송번호

암호화된 배송 번호 리스트(encryptedShippingNo)에 해당하는 모든 배송지를 수정합니다.

**파라미터**:

| 이름                | 위치   | 타입   | 필수 | 설명                                          |
| ------------------- | ------ | ------ | ---- | --------------------------------------------- | -------------------------------- |
| encryptedShippingNo | path   | string | ✅   | 암호화된 배송 번호 리스트^                    | UFE3Ylo2aUlkSWVuZHVGQjYyS2pZZz09 |
| Version             | header | string | ✅   | API 버전^                                     | 1.0                              |
| clientId            | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id                   |
| platform            | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                               |
| language            | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                               |

**응답**:

- **204**: 204

---

## MyPay

### POST /my-pay/modify-main-payment

**요약**: (마이페이 PG용)주 결제수단 설정하기

**설명**:

## 부가설명 및 특이사항

'마이페이' PG 사용 시 주 결제수단을 설정합니다.
신용카드와 계좌는 주 결제수단을 각각 관리합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### GET /my-pay/modify-password

**요약**: (마이페이 PG용)비밀번호 변경 파라미터 조회하기

**설명**:

## 부가설명 및 특이사항

비밀번호 변경 webUI를 띄우기 위한 파라미터를 조회합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ---------------------------- |
| clientReturnUrl       | query  | string | ✅   | 결제수단 등록 완료 후 client 이동 url^        | https://www.nhn-commerce.com |
| ci                    | query  | string | ❌   | 고객의 CI                                     |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                          |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id               |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                           |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                           |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token            |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token     |

**응답**:

- **200**: 200

---

### GET /my-pay/payment-infos

**요약**: (마이페이 PG용)등록된 결제수단 조회하기

**설명**:

## 부가설명 및 특이사항

등록된 결제수단 리스트를 조회합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| payMethod             | query  | string | ❌   | 결제수단 코드 (신용카드: 01, 계좌: 16)^       | 01                       |
| bankCardCode          | query  | string | ❌   | 신용카드 : 카드사 코드, 계좌 : 은행 코드^     | 16                       |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### DELETE /my-pay/payment-infos

**요약**: (마이페이 PG용)록된 결제수단 삭제하기

**설명**:

## 부가설명 및 특이사항

등록된 결제수단을 삭제합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| payToken              | query  | string | ✅   | 이니시스에서 발행한 SEED wpaytoken^           | LL3E994QcmzSFH0JCiZOFw== |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### GET /my-pay/register-payment

**요약**: (마이페이 PG용)결제수단 등록 webUrl를 위한 정보 조회하기

**설명**:

## 부가설명 및 특이사항

결제수단 webUI를 띄우기 위한 파라미터를 조회합니다.

payMethod에 입력한 값에 따라 다른 webUI를 응답합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ---------------------------- |
| clientReturnUrl       | query  | string | ✅   | 결제수단 등록 완료 후 client 이동 url^        | https://www.nhn-commerce.com |
| payMethod             | query  | string | ✅   | 결제수단 코드 (신용카드: 01, 계좌: 16)^       | 01                           |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                          |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id               |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                           |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                           |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token            |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token     |

**응답**:

- **200**: 200

---

### GET /my-pay/register-user

**요약**: (마이페이 PG용)회원등록 webUrl를 위한 정보 조회하기

**설명**:

## 부가설명 및 특이사항

회원등록 webUI를 띄우기 위한 파라미터를 조회합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ---------------------------- |
| clientReturnUrl       | query  | string | ✅   | 회원등록 완료 후 client 이동 url^             | https://www.nhn-commerce.com |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                          |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id               |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                           |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                           |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token            |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token     |

**응답**:

- **200**: 200

---

### GET /my-pay/register-user-with-payment

**요약**: (마이페이 PG용)회원등록후 결제수단 등록으로 바로 넘어갈 수 있도록 필요한 값 조회하기

**설명**:

## 부가설명 및 특이사항

회원등록 및 결제수단 등록을 함께 진행할때, 회원등록 webUI를 띄우기 위한 파라미터를 조회합니다.

회원등록이 성공적으로 끝나면 clientBridgeUrl 로 결제수단등록에 필요한 파라미터들이 urlEncoding이 된 상태로 함께 redirect 됩니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                               |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------ | --------------------------------------- |
| clientReturnUrl       | query  | string | ✅   | 회원등록, 결제수단 등록 완료 후 client 이동 url^                   | https://www.nhn-commerce.com            |
| clientBridgeUrl       | query  | string | ✅   | 회원등록 후 결제수단 등록에 필요한 파라미터와 함께 redirect될 url^ | https://www.register-payment-bridge.com |
| Version               | header | string | ✅   | API 버전^                                                          | 1.0                                     |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                          | test-client-id                          |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                      | PC                                      |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                                                | ko                                      |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                                                  | test-access-token                       |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                                          | Bearer test-access-token                |

**응답**:

- **200**: 200

---

### DELETE /my-pay/user

**요약**: (마이페이 PG용)회원서비스 해제하기

**설명**:

## 부가설명 및 특이사항

회원서비스를 해제합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### DELETE /my-pay/user/by-key

**요약**: (마이페이 PG용)마이페이 회원 서비스 해지하기

**설명**:

## 부가설명 및 특이사항

회원서비스를 해지합니다.

마이페이 회원 등록 중 '이미 등록된 회원입니다.'라는 메시지가 나오는 경우에만, 해당 API를 통해 회원서비스를 해지할 수 있습니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                 |
| --------- | ------ | ------ | ---- | ------------------------------------ | ---------- |
| deleteKey | query  | string | ✅   | 회원 서비스 해지할 유저의 deleteKey^ | delete-key |
| Version   | header | string | ✅   | API 버전^                            | 1.0        |
| language  | header | string | ❌   | 언어 (기본 값: ko)^                  | ko         |

**응답**:

- **204**: 204

---

## OrderConfiguration

### GET /order-configs

**요약**: 주문 설정 값 가져오기

**설명**:

## 부가설명 및 특이사항

주문 설정값을 조회하는 API 입니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| language | header | string | ❌   | 언어 (기본 값: ko)^                           | ko             |

**응답**:

- **200**: 200

---

## OrderSheet

### POST /order-sheets

**요약**: 주문서 작성하기

**설명**:

## 부가설명 및 특이사항

주문을 진행 할 상품정보를 전달하는 API 입니다.

주문서 페이지 진입전에 실행합니다.

비회원 주문인 경우 accessToken을 null로 보냅니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[POST]%20order-sheets%20%EC%A3%BC%EB%AC%B8%EC%84%9C%20%EC%83%9D%EC%84%B1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[POST]%20order-sheets%20%EC%A3%BC%EB%AC%B8%EC%84%9C%20%EC%83%9D%EC%84%B1.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /order-sheets/{orderSheetNo}

**요약**: 주문서 조회하기

**설명**:

## 부가설명 및 특이사항

주문서 번호를 이용하여 주문상품정보를 조회하는 API 입니다.

비회원 주문인 경우, accessToken을 null로 보냅니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[GET]%20order-sheets%20%EC%A3%BC%EB%AC%B8%EC%84%9C%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[GET]%20order-sheets%20%EC%A3%BC%EB%AC%B8%EC%84%9C%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[GET]%20order-sheets%20%EC%A3%BC%EB%AC%B8%EC%84%9C%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[GET]%20order-sheets%20%EC%A3%BC%EB%AC%B8%EC%84%9C%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | ------------------------ |
| orderSheetNo          | path   | string  | ✅   | -                                             |
| includeMemberAddress  | query  | boolean | ❌   | 회원주소포함여부^                             | false                    |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| currency              | header | string  | ❌   | 통화 코드^                                    | KRW                      |

**응답**:

- **200**: 200

---

### POST /order-sheets/{orderSheetNo}/calculate

**요약**: 쿠폰 및 배송지 정보가 적용된 금액 조회하기

**설명**:

## 부가설명 및 특이사항

쿠폰 및 배송비 계산이 적용된 주문서 금액을 조회하는 API 입니다.

비회원 주문인 경우 accessToken을 null로 보냅니다.

jibunAddress를 입력해줘야 지역별 추가배송비 계산이 가능합니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[POST]%20order-sheets_calculate%20%EC%BF%A0%ED%8F%B0%20%EB%B0%8F%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EC%A0%95%EB%B3%B4%EA%B0%80%20%EC%A0%81%EC%9A%A9%EB%90%9C%20%EA%B8%88%EC%95%A1%EC%9D%84%20%EB%85%B8%EC%B6%9C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[POST]%20order-sheets_calculate%20%EC%BF%A0%ED%8F%B0%20%EB%B0%8F%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EC%A0%95%EB%B3%B4%EA%B0%80%20%EC%A0%81%EC%9A%A9%EB%90%9C%20%EA%B8%88%EC%95%A1%EC%9D%84%20%EB%85%B8%EC%B6%9C.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderSheetNo          | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| currency              | header | string | ❌   | 통화 코드^                                    | KRW                      |

**응답**:

- **200**: 200

---

### GET /order-sheets/{orderSheetNo}/coupons

**요약**: 적용할 수 있는 쿠폰 정보 조회하기

**설명**:

## 부가설명 및 특이사항

해당 주문에 적용할 수 있는 쿠폰을 조회하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[GET]%20order-sheets_coupons%20%EC%A0%81%EC%9A%A9%ED%95%A0%20%EC%88%98%20%EC%9E%88%EB%8A%94%20%EC%BF%A0%ED%8F%B0%20%EC%A0%95%EB%B3%B4%20%EC%A1%B0%ED%9A%8C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[GET]%20order-sheets_coupons%20%EC%A0%81%EC%9A%A9%ED%95%A0%20%EC%88%98%20%EC%9E%88%EB%8A%94%20%EC%BF%A0%ED%8F%B0%20%EC%A0%95%EB%B3%B4%20%EC%A1%B0%ED%9A%8C.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderSheetNo          | path   | string | ✅   | -                                             |
| channelType           | query  | string | ❌   | 채널타입^                                     | NAVER_EP                 |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /order-sheets/{orderSheetNo}/coupons/apply

**요약**: 쿠폰 적용하기

**설명**:

## 부가설명 및 특이사항

해당 주문서에 선택된 쿠폰을 적용하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[POST]%20order-sheets_coupons_apply%20%EC%BF%A0%ED%8F%B0%EC%A0%81%EC%9A%A9.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[POST]%20order-sheets_coupons_apply%20%EC%BF%A0%ED%8F%B0%EC%A0%81%EC%9A%A9.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderSheetNo          | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| currency              | header | string | ❌   | 통화 코드^                                    | KRW                      |

**응답**:

- **200**: 200

---

### POST /order-sheets/{orderSheetNo}/coupons/calculate

**요약**: 쿠폰적용금액 계산하기

**설명**:

## 부가설명 및 특이사항

쿠폰을 적용한 금액을 미리 조회하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[POST]%20order-sheets_coupons_calculate%20%EC%BF%A0%ED%8F%B0%EC%A0%81%EC%9A%A9%20%EA%B8%88%EC%95%A1%20%EA%B3%84%EC%82%B0.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[POST]%20order-sheets_coupons_calculate%20%EC%BF%A0%ED%8F%B0%EC%A0%81%EC%9A%A9%20%EA%B8%88%EC%95%A1%20%EA%B3%84%EC%82%B0.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderSheetNo          | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /order-sheets/{orderSheetNo}/coupons/maximum

**요약**: 최대쿠폰적용금액 계산하기

**설명**:

## 부가설명 및 특이사항

해당 주문서에서 최대로 할인 받을 수 있는 상품쿠폰을 계산하는 API 입니다.

장바구니 쿠폰은 계산에서 제외됩니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[POST]%20order-sheets_coupons_maximum%20%EC%B5%9C%EB%8C%80%EC%BF%A0%ED%8F%B0%EC%A0%81%EC%9A%A9%EA%B8%88%EC%95%A1%20%EA%B3%84%EC%82%B0.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/ordersheet/[POST]%20order-sheets_coupons_maximum%20%EC%B5%9C%EB%8C%80%EC%BF%A0%ED%8F%B0%EC%A0%81%EC%9A%A9%EA%B8%88%EC%95%A1%20%EA%B3%84%EC%82%B0.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderSheetNo          | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

## Purchase

### POST /payments/reserve

**요약**: 주문 예약하기

**설명**:

## 부가설명 및 특이사항

주문을 예약하는 API 입니다.

[주문서화면](https://workspace.nhn-commerce.com/guide/skin/dev-cover/order#pay-button) 가이드의'결제편의모듈'항목 참고바랍니다.

payType과 PgType 값은 [https://docs.shopby.co.kr/?url.primaryName=order/#/OrderSheet/get-order-sheet](https://docs.shopby.co.kr/?url.primaryName=order/#/OrderSheet/get-order-sheet) 응답값 내 availablePayTypes 참고부탁드립니다

앱(iOS/AOS) 결제 개발 가이드: [https://workspace.shopby.co.kr/guide/skin/dev-cover/app-payment-module?lv=11](https://workspace.shopby.co.kr/guide/skin/dev-cover/app-payment-module?lv=11)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| currency              | header | string | ❌   | 통화 코드(해외 결제 시 필수)^                 | KRW                      |

**응답**:

- **200**: 200

---

## NaverPay

### POST /payments/naver/ordersheet

**요약**: 네이버페이 주문서 생성하기

**설명**:

## 부가설명 및 특이사항

네이버페이 주문서를 생성하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /payments/naver/validate

**요약**: 네이버페이 상품구매 검증하기

**설명**:

## 부가설명 및 특이사항

네이버페이 상품구매 가능 여부를 검증하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /payments/naver/wish-list

**요약**: 네이버페이 찜 등록하기

**설명**:

## 부가설명 및 특이사항

네이버페이 찜을 등록하는 API 입니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| language | header | string | ❌   | 언어 (기본 값: ko)^                           | ko             |

**응답**:

- **200**: 200

---

## PreviousOrder

### GET /previous-orders

**요약**: 이전주문 검색

**설명**:
이전주문 검색

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | ------------------------------------ |
| searchType            | query  | string  | ❌   | 검색 타입^                                    | ORDER_NO, ORDERER_NAME, PRODUCT_NAME |
| keyword               | query  | string  | ❌   | 검색어^                                       | 홍길동                               |
| startYmd              | query  | string  | ❌   | 조회시작일^                                   | 2025-07-24                           |
| endYmd                | query  | string  | ❌   | 조회종료일^                                   | 2025-10-24                           |
| page                  | query  | integer | ✅   | 페이지 번호^                                  | 1                                    |
| size                  | query  | integer | ✅   | 페이지당 노출 개수(최대 200)^                 | 30                                   |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0                                  |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id                       |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                                   |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                                   |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                             | test-access-token                    |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token             |

**응답**:

- **200**: 200

---

### GET /previous-orders/{orderNo}

**요약**: 이전주문 상세조회

**설명**:
이전주문 상세조회

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderNo               | path   | string | ✅   | 주문 번호^                                    | 202206151234567890       |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /previous-orders/guest/{orderNo}

**요약**: 비회원 이전주문 상세조회

**설명**:
비회원 이전주문 상세조회

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                          |
| ---------- | ------ | ------ | ---- | --------------------------------------------- | ------------------ |
| orderNo    | path   | string | ✅   | 주문 번호^                                    | 202206151234567890 |
| Version    | header | string | ✅   | API 버전^                                     | 1.0                |
| clientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id     |
| platform   | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                 |
| language   | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                 |
| guestToken | header | string | ✅   | guestToken^                                   | test-guest-token   |

**응답**:

- **200**: 200

---

### POST /previous-orders/guest/{orderNo}

**요약**: 이전주문 비회원 토큰 발급

**설명**:
이전주문 비회원 토큰 발급

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | ------------------ |
| orderNo  | path   | string | ✅   | 주문 번호^                                    | 202206151234567890 |
| Version  | header | string | ✅   | API 버전^                                     | 1.0                |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id     |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                 |
| language | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                 |

**응답**:

- **200**: 200

---

## MyOrder

### GET /profile/orders

**요약**: 주문 리스트 조회하기

**설명**:

## 부가설명 및 특이사항

시작일 종료일 사이의 주문리스트를 조회하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders%20%EC%A3%BC%EB%AC%B8%20%EB%A6%AC%EC%8A%A4%ED%8A%B8%20%EC%A1%B0%ED%9A%8C%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders%20%EC%A3%BC%EB%AC%B8%20%EB%A6%AC%EC%8A%A4%ED%8A%B8%20%EC%A1%B0%ED%9A%8C%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders%20%EC%A3%BC%EB%AC%B8%20%EB%A6%AC%EC%8A%A4%ED%8A%B8%20%EC%A1%B0%ED%9A%8C%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders%20%EC%A3%BC%EB%AC%B8%20%EB%A6%AC%EC%8A%A4%ED%8A%B8%20%EC%A1%B0%ED%9A%8C%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| --------------------- | ------ | ------- | ---- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| orderRequestTypes     | query  | string  | ❌   | 주문상태 (DEPOSIT_WAIT: Deposit Wait, PAY_DONE: Pay Done, PRODUCT_PREPARE: Product Prepare, DELIVERY_PREPARE: Delivery Prepare, DELIVERY_ING: Delivering, DELIVERY_DONE: Delivery Done, BUY_CONFIRM: Buy Confirm, CANCEL_DONE: Cancel Done, RETURN_DONE: Return Done, EXCHANGE_DONE: Exchange Done, CANCEL_PROCESSING: 취소처리중, RETURN_PROCESSING: 반품처리중, EXCHANGE_WAITING: 교환대기중, EXCHANGE_PROCESSING: 교환처리중) \* (null인 경우 전체) ^ | DEPOSIT_WAIT,PAY_DONE                           |
| pageNumber            | query  | number  | ❌   | 페이지 번호 (1 이상)^                                                                                                                                                                                                                                                                                                                                                                                                                                    | 1                                               |
| pageSize              | query  | number  | ❌   | 한 페이지당 노출 수(최대 200)^                                                                                                                                                                                                                                                                                                                                                                                                                           | 10                                              |
| hasTotalCount         | query  | boolean | ❌   | 목록 카운트 포함 여부(default: false)^                                                                                                                                                                                                                                                                                                                                                                                                                   | false                                           |
| startYmd              | query  | string  | ❌   | 조회 시작일(yyyy-MM-dd), null인 경우 3개월 전 날짜로 조회^                                                                                                                                                                                                                                                                                                                                                                                               | YYYY-MM-DD                                      |
| endYmd                | query  | string  | ❌   | 조회 종료일(yyyy-MM-dd), null인 경우 오늘 날짜로 조회^                                                                                                                                                                                                                                                                                                                                                                                                   | YYYY-MM-DD                                      |
| searchType            | query  | string  | ❌   | 검색 타입^                                                                                                                                                                                                                                                                                                                                                                                                                                               | PRODUCT_NAME                                    |
| keyword               | query  | string  | ❌   | 검색어                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| requiresShipping      | query  | string  | ❌   | 배송여부^                                                                                                                                                                                                                                                                                                                                                                                                                                                | true                                            |
| orderType             | query  | string  | ❌   | 주문유형^                                                                                                                                                                                                                                                                                                                                                                                                                                                | NORMAL(일반주문),LATER_SHIPPING_INPUT(선물주문) |
| Version               | header | string  | ✅   | API 버전^                                                                                                                                                                                                                                                                                                                                                                                                                                                | 1.0                                             |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                                                                                                                                                                                                                                                                                                                                                                                                                                | test-client-id                                  |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                                                                                                                                                                                                                                                                                                                                                                                                            | PC                                              |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                                                                                                                                                                                                                                                                                                                                                                                                                                      | ko                                              |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                                                                                                                                                                                                                                                                                                                                                                                                                                        | test-access-token                               |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                                                                                                                                                                                                                                                                                                                                                                                                                                | Bearer test-access-token                        |

**응답**:

- **200**: 200

---

### GET /profile/orders/{orderNo}

**요약**: 주문 상세 조회하기

**설명**:

## 부가설명 및 특이사항

주문번호로 상세 데이터를 조회하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C%201-2.png)
[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C%201-3.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C%201-3.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                               |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------ | ------------------------ |
| orderNo               | path   | string | ✅   | -                                                                  |
| orderRequestType      | query  | string | ❌   | 주문옵션타입 (ALL: 전체, CLAIM: 클레임진행, NORMAL: 클레임미진행)^ | CLAIM                    |
| Version               | header | string | ✅   | API 버전^                                                          | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                          | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                      | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                                                | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                                                  | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                                          | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/previous-orders/summary

**요약**: 마이페이지용 이전주문 수량 조회하기

**설명**:

## 부가설명 및 특이사항

시작일 종료일 사이의 이전주문 수량을 조회하는 API 입니다.

시작일과 종료일을 입력하지 않으면 최근 3개월의 이전주문 수량이 조회됩니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                       |
| --------------------- | ------ | ------ | ---- | ---------------------------------------------------------- | ------------------------ |
| startYmd              | query  | string | ❌   | 조회 시작일(yyyy-MM-dd), null인 경우 3개월 전 날짜로 조회^ | YYYY-MM-DD               |
| endYmd                | query  | string | ❌   | 조회 종료일(yyyy-MM-dd), null인 경우 오늘 날짜로 조회^     | YYYY-MM-DD               |
| Version               | header | string | ✅   | API 버전^                                                  | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                  | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^              | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                                        | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                                          | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                                  | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/order-options/summary/status

**요약**: 주문 상태별 주문 옵션별 수량 조회하기

**설명**:

## 부가설명 및 특이사항

시작일 종료일 사이의 주문 상태별 주문 옵션별 수량을 조회하는 API 입니다.

옵션별로 카운트 합니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_summary_status%20%EC%83%81%ED%83%9C%EB%B3%84%20%EC%A3%BC%EB%AC%B8%20%EC%98%B5%EC%85%98%EB%B3%84%20%EC%88%98%EB%9F%89.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_summary_status%20%EC%83%81%ED%83%9C%EB%B3%84%20%EC%A3%BC%EB%AC%B8%20%EC%98%B5%EC%85%98%EB%B3%84%20%EC%88%98%EB%9F%89.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                       |
| --------------------- | ------ | ------ | ---- | ---------------------------------------------------------- | ------------------------ |
| startYmd              | query  | string | ❌   | 조회 시작일(yyyy-MM-dd), null인 경우 3개월 전 날짜로 조회^ | YYYY-MM-DD               |
| endYmd                | query  | string | ❌   | 조회 종료일(yyyy-MM-dd), null인 경우 오늘 날짜로 조회^     | YYYY-MM-DD               |
| Version               | header | string | ✅   | API 버전^                                                  | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                  | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^              | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                                        | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                                          | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                                  | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /profile/order-options/{orderOptionNo}/confirm

**요약**: 상품 주문 구매 확정하기

**설명**:

## 부가설명 및 특이사항

배송중, 배송완료 상태의 상태주문을 구매확정 처리하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_confirm%20%EC%83%81%ED%92%88%20%EC%A3%BC%EB%AC%B8%20%EA%B5%AC%EB%A7%A4%ED%99%95%EC%A0%95.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_confirm%20%EC%83%81%ED%92%88%20%EC%A3%BC%EB%AC%B8%20%EA%B5%AC%EB%A7%A4%ED%99%95%EC%A0%95.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderOptionNo         | path   | string | ✅   | 주문옵션번호^                                 | 123                      |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### PUT /profile/order-options/{orderOptionNo}/delivery-done

**요약**: 상품 주문 배송완료 처리하기

**설명**:

## 부가설명 및 특이사항

배송중 상태의 상품주문을 배송완료 처리하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_delivery-done%20%EC%83%81%ED%92%88%20%EC%A3%BC%EB%AC%B8%20%EB%B0%B0%EC%86%A1%EC%99%84%EB%A3%8C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_order-options_delivery-done%20%EC%83%81%ED%92%88%20%EC%A3%BC%EB%AC%B8%20%EB%B0%B0%EC%86%A1%EC%99%84%EB%A3%8C.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderOptionNo         | path   | string | ✅   | 주문옵션번호^                                 | 123                      |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### GET /profile/orders/summary/amount

**요약**: 주문 상태별 주문 수량 및 금액 조회하기

**설명**:

## 부가설명 및 특이사항

시작일과 종료일 사이의 주문 상태별 주문 수량과 결제 금액 조회하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| orderStatusType       | query  | string | ❌   | 주문 상태 (DEPOSIT_WAIT: Deposit Wait, PAY_DONE: Pay Done, PRODUCT_PREPARE: Product Prepare, DELIVERY_PREPARE: Delivery Prepare, DELIVERY_ING: Delivering, DELIVERY_DONE: Delivery Done, BUY_CONFIRM: Buy Confirm, CANCEL_DONE: Cancel Done, RETURN_DONE: Return Done, EXCHANGE_DONE: Exchange Done, PAY_WAIT: Pay Wait, PAY_CANCEL: Pay Cancel, PAY_FAIL: Pay Fail, DELETE: Delete, EXCHANGE_WAIT: Exchange Wait, REFUND_DONE: Refund Done)^ | DEPOSIT_WAIT             |
| startYmd              | query  | string | ❌   | 조회 시작일(yyyy-MM-dd), null인 경우 3개월 전 날짜로 조회^                                                                                                                                                                                                                                                                                                                                                                                    | YYYY-MM-DD               |
| endYmd                | query  | string | ❌   | 조회 종료일(yyyy-MM-dd), null인 경우 오늘 날짜로 조회^                                                                                                                                                                                                                                                                                                                                                                                        | YYYY-MM-DD               |
| Version               | header | string | ✅   | API 버전^                                                                                                                                                                                                                                                                                                                                                                                                                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                                                                                                                                                                                                                                                                                                                                                                                                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                                                                                                                                                                                                                                                                                                                                                                                                 | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                                                                                                                                                                                                                                                                                                                                                                                                                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                                                                                                                                                                                                                                                                                                                                                                                                                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                                                                                                                                                                                                                                                                                                                                                                                                                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/orders/summary/status

**요약**: 주문 상태별 주문 수량 조회하기

**설명**:

## 부가설명 및 특이사항

시작일 종료일 사이의 주문 상태별 주문 옵션별 수량을 조회하는 API 입니다.

옵션별로 카운트 합니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_summary_status%20%EC%83%81%ED%83%9C%EB%B3%84%20%EC%A3%BC%EB%AC%B8%20%EC%98%B5%EC%85%98%EB%B3%84%20%EC%88%98%EB%9F%89.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_order-options_summary_status%20%EC%83%81%ED%83%9C%EB%B3%84%20%EC%A3%BC%EB%AC%B8%20%EC%98%B5%EC%85%98%EB%B3%84%20%EC%88%98%EB%9F%89.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                       |
| --------------------- | ------ | ------ | ---- | ---------------------------------------------------------- | ------------------------ |
| startYmd              | query  | string | ❌   | 조회 시작일(yyyy-MM-dd), null인 경우 3개월 전 날짜로 조회^ | YYYY-MM-DD               |
| endYmd                | query  | string | ❌   | 조회 종료일(yyyy-MM-dd), null인 경우 오늘 날짜로 조회^     | YYYY-MM-DD               |
| Version               | header | string | ✅   | API 버전^                                                  | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                  | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^              | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                                        | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                                          | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                                  | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /profile/orders/{orderNo}/cashReceipt

**요약**: 현금영수증 신청하기

**설명**:

## 부가설명 및 특이사항

구매자가 결제완료된 주문의 현금영수증을 발급하는 API입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_orders_cashReceipt%20%ED%98%84%EA%B8%88%EC%98%81%EC%88%98%EC%A6%9D%20%EC%8B%A0%EC%B2%AD.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[POST]%20profile_orders_cashReceipt%20%ED%98%84%EA%B8%88%EC%98%81%EC%88%98%EC%A6%9D%20%EC%8B%A0%EC%B2%AD.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderNo               | path   | string | ✅   | 주문번호^                                     | 2020042100000001         |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /profile/orders/{orderNo}/cashReceipt

**요약**: 현금영수증 신청정보 수정 (무통장 입금 주문)

**설명**:

## 부가설명 및 특이사항

현금영수증 발급을 신청한 무통장입금 주문의 현금영수증 신청 정보를 수정하는 API입니다.<br />
주문이 입금 대기상태인 경우에만 수정 가능합니다.<br />

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderNo               | path   | string | ✅   | 주문번호^                                     | 2020042100000001         |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/orders/{orderNo}/claim

**요약**: 전체 주문취소를 위한 주문 상세 조회하기 (클레임 상세사유 포함)

**설명**:

## 부가설명 및 특이사항

주문번호로 상세 데이터를 조회하는 API 입니다.

클레임 상세사유를 포합합니다.

## 화면예시

[![](<http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders_claim%20%EC%A0%84%EC%B2%B4%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%EB%A5%BC%20%EC%9C%84%ED%95%9C%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C(%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EC%82%AC%EC%9C%A0%20%ED%8F%AC%ED%95%A8)%201-1.png?autox150>)](<http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders_claim%20%EC%A0%84%EC%B2%B4%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%EB%A5%BC%20%EC%9C%84%ED%95%9C%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C(%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EC%82%AC%EC%9C%A0%20%ED%8F%AC%ED%95%A8)%201-1.png>)
[![](<http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders_claim%20%EC%A0%84%EC%B2%B4%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%EB%A5%BC%20%EC%9C%84%ED%95%9C%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C(%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EC%82%AC%EC%9C%A0%20%ED%8F%AC%ED%95%A8)%201-2.png?autox150>)](<http://image.toast.com/aaaaahb/api-description/order/myorder/[GET]%20profile_orders_claim%20%EC%A0%84%EC%B2%B4%20%EC%A3%BC%EB%AC%B8%EC%B7%A8%EC%86%8C%EB%A5%BC%20%EC%9C%84%ED%95%9C%20%EC%A3%BC%EB%AC%B8%20%EC%83%81%EC%84%B8%EC%A1%B0%ED%9A%8C(%ED%81%B4%EB%A0%88%EC%9E%84%20%EC%83%81%EC%84%B8%EC%82%AC%EC%9C%A0%20%ED%8F%AC%ED%95%A8)%201-2.png>)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------ |
| orderNo               | path   | string | ✅   | -                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| orderRequestType      | query  | string | ❌   | 주문옵션타입 (DEPOSIT_WAIT: Deposit Wait, PAY_DONE: Pay Done, PRODUCT_PREPARE: Product Prepare, DELIVERY_PREPARE: Delivery Prepare, DELIVERY_ING: Delivering, DELIVERY_DONE: Delivery Done, BUY_CONFIRM: Buy Confirm, CANCEL_DONE: Cancel Done, RETURN_DONE: Return Done, EXCHANGE_DONE: Exchange Done, PAY_WAIT: Pay Wait, PAY_CANCEL: Pay Cancel, PAY_FAIL: Pay Fail, DELETE: Delete, EXCHANGE_WAIT: Exchange Wait, REFUND_DONE: Refund Done)^ | CLAIM                    |
| claimType             | query  | string | ✅   | 클레임타입 (CANCEL, RETURN, EXCHANGE, NONE)^                                                                                                                                                                                                                                                                                                                                                                                                     | CANCEL,RETURN,EXCHANGE   |
| Version               | header | string | ✅   | API 버전^                                                                                                                                                                                                                                                                                                                                                                                                                                        | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                                                                                                                                                                                                                                                                                                                                                                                                        | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                                                                                                                                                                                                                                                                                                                                                                                                    | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                                                                                                                                                                                                                                                                                                                                                                                                                              | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                                                                                                                                                                                                                                                                                                                                                                                                                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                                                                                                                                                                                                                                                                                                                                                                                                                        | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /profile/orders/{orderNo}/deliveries

**요약**: 주문단위 배송정보 수정하기

**설명**:

## 부가설명 및 특이사항

주문번호에 속한 배송정보를 일괄 수정하는 API 입니다.

지역별 배송비가 변경되는 주소로는 배송정보를 변경할 수 없습니다.
지역별 배송비는 receiverJibunAddress로 입력되는 지번주소를 기준으로 판단합니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_orders_deliveries%20%EC%A3%BC%EB%AC%B8%EB%8B%A8%EC%9C%84%20%EB%B0%B0%EC%86%A1%EC%A0%95%EB%B3%B4%20%EC%88%98%EC%A0%95.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/myorder/[PUT]%20profile_orders_deliveries%20%EC%A3%BC%EB%AC%B8%EB%8B%A8%EC%9C%84%20%EB%B0%B0%EC%86%A1%EC%A0%95%EB%B3%B4%20%EC%88%98%EC%A0%95.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | ------------------------ |
| orderNo               | path   | string  | ✅   | 주문옵션번호^                                 | 2010121010               |
| add                   | query  | boolean | ❌   | 주소지 추가 여부^                             | true                     |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### GET /profile/orders/{orderNo}/payment-receipt-url

**요약**: 결제 영수증 조회

**설명**:
결제 영수증 조회

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderNo               | path   | string | ✅   | 주문번호^                                     | 1234567890               |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/orders/{orderNo}/simple-receipt

**요약**: 간이 영수증 조회

**설명**:
간이 영수증 조회

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderNo               | path   | string | ✅   | 주문번호^                                     | 1234567890               |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/orders/{orderNo}/specifications

**요약**: 거래 명세서 조회 (주문 기준)

**설명**:
거래 명세서 조회 (주문 기준)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderNo               | path   | string | ✅   | 주문번호^                                     | 1234567890               |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /profile/orders/{orderNo}/cashReceipt/cancel

**요약**: [샵바이 스탠다드 전용] 현금영수증 취소하기

**설명**:
|
|## 부가설명 및 특이사항
|구매자가 현금영수증 발행된 주문의 현금영수증 발행 취소하는 API입니다.
|

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| orderNo               | path   | string | ✅   | 주문번호^                                     | 2020042100000001         |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

## ShippingAddress

### GET /profile/shipping-addresses

**요약**: 배송지 목록 가져오기

**설명**:

## 부가설명 및 특이사항

주소지정보를 조회하는 API 입니다.

기본 배송지(defaultAddress)가 가장 상단에 노출되며, 이후 최근 사용된 주소 순서로 나열됩니다 (최근 사용시간의 역순로 정렬)

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[GET]%20profile_shipping-addresses%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EB%AA%A9%EB%A1%9D%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[GET]%20profile_shipping-addresses%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EB%AA%A9%EB%A1%9D%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /profile/shipping-addresses

**요약**: 배송지 등록하기

**설명**:

## 부가설명 및 특이사항

주소지정보를 추가하는 API 입니다.

주소록 배송지(AddressType.BOOK)는 제한없이 등록이 가능하고 최근 배송지(AddressType.RECENT)는 최대 10개 까지 등록이 됩니다.

최근 배송지가 10개가 등록된 상태에서 추가로 최근 배송지를 등록하면 기본 배송지가 아닌 최근 배송지중에 사용한지 가장 오래된 최근 배송지가 삭제 됩니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[GET]%20profile_shipping-addresses%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EB%AA%A9%EB%A1%9D%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[GET]%20profile_shipping-addresses%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EB%AA%A9%EB%A1%9D%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/shipping-addresses/booked

**요약**: 저장 된 배송지 목록 가져오기

**설명**:

## 부가설명 및 특이사항

저장 된 주소지정보를 조회하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | ------------------------ |
| page                  | query  | integer | ✅   | 페이지 번호 (1 이상)^                         | 1                        |
| size                  | query  | integer | ✅   | 페이지당 노출 개수^                           | 30                       |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/shipping-addresses/recent

**요약**: 최근 배송지 가져오기

**설명**:

## 부가설명 및 특이사항

로그인한 사용자의 최근배송지 목록을 조회하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[GET]%20profile_shipping-addresses_recent%20%EC%B5%9C%EA%B7%BC%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[GET]%20profile_shipping-addresses_recent%20%EC%B5%9C%EA%B7%BC%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/shipping-addresses/{addressNo}

**요약**: 배송지 가져오기

**설명**:

## 부가설명 및 특이사항

선택한 배송지의 세부 정보를 조회하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[GET]%20profile_shipping-addresses%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[GET]%20profile_shipping-addresses%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| addressNo             | path   | number | ✅   | 배송지 번호^                                  | 1                        |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /profile/shipping-addresses/{addressNo}

**요약**: 배송지 수정하기

**설명**:

## 부가설명 및 특이사항

선택한 배송지 주소를 수정하는 API 입니다.

[참고사항]
주소지 정보 중 'nullable'한 값은 해당 값을 입력하지 않은 경우에 기존 값이 유지되고, 공백을 넣어 요청할 경우 공백으로 수정됩니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[PUT]%20profile_shipping-addresses%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EC%88%98%EC%A0%95.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[PUT]%20profile_shipping-addresses%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EC%88%98%EC%A0%95.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| addressNo             | path   | number | ✅   | 배송지 번호^                                  | 1                        |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### DELETE /profile/shipping-addresses/{addressNo}

**요약**: 배송지 삭제하기

**설명**:

## 부가설명 및 특이사항

등록된 배송지를 삭제하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[DELETE]%20profile_shipping-addresses%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EC%82%AD%EC%A0%9C.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[DELETE]%20profile_shipping-addresses%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EC%82%AD%EC%A0%9C.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| addressNo             | path   | number | ✅   | 배송지 번호^                                  | 1                        |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### PUT /profile/shipping-addresses/{addressNo}/default

**요약**: 기본 배송지 수정하기

**설명**:

## 부가설명 및 특이사항

선택한 배송지를 기본배송지로 지정하는 API 입니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[PUT]%20profile_shipping-addresses_default%20%EA%B8%B0%EB%B3%B8%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EC%88%98%EC%A0%95.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/shipping-address/[PUT]%20profile_shipping-addresses_default%20%EA%B8%B0%EB%B3%B8%20%EB%B0%B0%EC%86%A1%EC%A7%80%20%EC%88%98%EC%A0%95.png)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| addressNo             | path   | number | ✅   | 배송지 번호^                                  | 1                        |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /shippings/enums

**요약**: 배송 enum 정보 조회

**설명**:
배송 enum 정보 조회

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                |
| -------- | ------ | ------ | ---- | ------------------- | --- |
| Version  | header | string | ✅   | API 버전^           | 1.0 |
| language | header | string | ❌   | 언어 (기본 값: ko)^ | ko  |

**응답**:

- **200**: 200

---

## RecurringPayment

### GET /recurring-payments

**요약**: 정기결제 조회하기

**설명**:

## 부가설명 및 특이사항

정기결제를 조회하는 API 입니다.

### v1.0

페이징 처리를 위한 totalCount를 제공하지 않습니다.

```
[
 {
  "recurringPaymentId": "",
  ...
 },
 ...
]
```

### v1.1

페이징 처리를 위한 totalCount를 제공합니다.
자세한 정보는 Responses 항목 참고 바랍니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| startYmd              | query  | string | ❌   | 시작일^                                       | YYYY-MM-DD               |
| endYmd                | query  | string | ❌   | 종료일^                                       | YYYY-MM-DD               |
| statusTypes           | query  | string | ❌   | 정기결제 상태 리스트^                         | ACTIVE,SYSTEM_PAUSED     |
| page                  | query  | number | ❌   | 페이지 번호 (1 이상)^                         | 1                        |
| size                  | query  | number | ❌   | 페이지당 노출 개수^                           | 30                       |
| Version               | header | string | ✅   | API 버전^                                     | 1.1                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /recurring-payments

**요약**: 정기결제 신청하기

**설명**:

## 부가설명 및 특이사항

정기결제를 신청하는 API 입니다.

참고 : 정기결제 신청 시점에 가격이 500원 미만인 상품이 존재하면 400 에러를 응답합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /recurring-payments/card

**요약**: 가장 최근에 등록된 정기결제 카드 조회하기

**설명**:

## 부가설명 및 특이사항

가장 최근에 등록된 정기결제 카드를 조회하는 API 입니다.

회원에게 등록된 정기결제 카드가 없을 시 400 에러로 응답합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /recurring-payments/card

**요약**: 정기결제 카드 등록하기

**설명**:

## 부가설명 및 특이사항

정기결제 카드를 등록하는 API 입니다.

사용중인 PG가 비 인증 방식으로 정기결제 카드를 등록하는 경우 사용 가능합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### DELETE /recurring-payments/card

**요약**: 회원의 모든 정기결제 카드 삭제하기

**설명**:

## 부가설명 및 특이사항

회원의 모든 정기결제 카드를 삭제하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### GET /recurring-payments/cards

**요약**: 정기결제 카드 조회하기

**설명**:

## 부가설명 및 특이사항

모든 정기결제 카드를 조회하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /recurring-payments/cart

**요약**: 정기결제 장바구니 조회하기

**설명**:

## 부가설명 및 특이사항

로그인된 유저의 장바구니 목록을 조회하기 위한 API 입니다.

참고: 500원 미만의 상품은 invalidProducts에 포함하여 응답합니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EB%AA%A9%EB%A1%9D%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EB%AA%A9%EB%A1%9D%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | ------------------------ |
| divideInvalidProducts | query  | boolean | ❌   | 구매하지 못하는 상품 분할여부^                | true                     |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /recurring-payments/cart

**요약**: 정기결제 장바구니에 추가하기

**설명**:

## 부가설명 및 특이사항

로그인된 유저의 장바구니에 상품(옵션)을 추가하는 API 입니다.

상품금액이 500원 미만일 경우 장바구니 담기가 불가능합니다.

참고:정기결제(배송) API화면가이드 https://workspace.nhn-commerce.com/support/recommendedContents/30659

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /recurring-payments/cart

**요약**: 정기결제 장바구니 수정하기

**설명**:

## 부가설명 및 특이사항

로그인된 유저의 장바구니의 상품 중 구매 수량과 사용자 입력형 옵션을 수정하는 API 입니다.

옵션 종류는 변경할 수 없습니다.

옵션변경은 변경할 옵션을 삭제한 후 신규등록하는 방법으로 수정합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### DELETE /recurring-payments/cart

**요약**: 정기결제 장바구니 삭제하기

**설명**:

## 부가설명 및 특이사항

장바구니 목록에서 장바구니를 삭제하는 API 입니다.

cartNo를 List형으로 전달해야 합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| cartNo                | query  | string | ✅   | 장바구니 번호^                                | 1,2,3                    |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /recurring-payments/close

**요약**: 정기결제 해지하기 (bulk)

**설명**:

## 부가설명 및 특이사항

정기결제를 해지 처리하는 API 입니다.

성공적으로 해지 완료 시 204(noContent) 응답을 반환합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### PUT /recurring-payments/gifts

**요약**: 정기 결제 사은품 변경

**설명**:

## 부가설명 및 특이사항

정기 결제 사은품을 수정하는 API 입니다.

최초 정기 결제 신청 시 선택할 수 있었던 사은품 중에서 선택할 수 있습니다.

모든 정기결제의 사은품을 성공적으로 변경 시 204(noContent) 응답을 반환합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### GET /recurring-payments/next-recurring-date

**요약**: 정기결제 다음배송일자 조회하기

**설명**:

## 부가설명 및 특이사항

정기결제 다음 배송일자를 조회하는 API 입니다.

정기결제 신청번호가 없으면 현재 날짜 기준으로 조회합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| recurringPaymentId    | query  | string | ❌   | 정기결제 신청번호^                            | 202108251705594          |
| cycle                 | query  | number | ✅   | 정기결제 주기^                                | 1                        |
| cycleDate             | query  | number | ❌   | 정기결제 일시^                                | 1                        |
| cycleDayOfWeek        | query  | string | ❌   | 정기결제 요일^                                | MONDAY                   |
| cycleType             | query  | string | ❌   | 정기결제 배송주기 타입^                       | (MONTH: 월, WEEK: 주)    |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /recurring-payments/order-sheets

**요약**: 정기결제 주문서 작성하기

**설명**:

## 부가설명 및 특이사항

정기결제 주문을 진행할 상품정보를 전달하는 API 입니다.

주문서 페이지 진입전에 실행합니다.

참고 : 주문서 생성시점에 가격이 500원 미만인 상품이 존재하면 400 에러를 응답합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /recurring-payments/status

**요약**: 정기결제 상태 변경 (bulk)

**설명**:

## 부가설명 및 특이사항

정기결제 신청건의 상태를 변경하는 API 입니다.

모든 신청건의 상태를 성공적으로 변경 시 204(noContent) 응답을 반환합니다.

참고: 아래와 같은 상태변경만 가능합니다.

### 이용중 (ACTIVE) -> 일시중지 (USER_PAUSED)

### 일시중지 (USER_PAUSED) -> 이용중 (ACTIVE)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### GET /recurring-payments/{recurringPaymentId}

**요약**: 정기 결제 상세 조회

**설명**:

## 부가설명 및 특이사항

정기 결제 상세 조회 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| recurringPaymentId    | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /recurring-payments/card/priority

**요약**: 정기결제 카드 우선순위 변경

**설명**:

## 부가설명 및 특이사항

정기결제 카드의 우선순위를 변경하는 API 입니다.

모든 카드의 우선순위를 입력해야 합니다.

정기 결제에 실패하는 경우, 카드의 우선순위에 따라 다음으로 결제를 시도할 카드가 결정됩니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### DELETE /recurring-payments/card/{cardNo}

**요약**: 정기결제 카드 삭제하기

**설명**:

## 부가설명 및 특이사항

정기결제 카드를 삭제하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| cardNo                | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### GET /recurring-payments/cart/calculate

**요약**: 정기결제 장바구니에서 선택된 상품금액 계산하기

**설명**:

## 부가설명 및 특이사항

장바구니에서 선택된 상품만 계산하여 금액만 리턴하는 API 입니다.

아래 화면예시에서 상품/옵션별 배송비는 업데이트(재계산)하지 못합니다.

cartNo 파라미터 자체를 넘기지 않는 경우 : 장바구니 전체

cartNo 에 빈 값을 넘기는 경우 : 0원

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart_calculate%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EC%84%A0%ED%83%9D%20%EA%B3%84%EC%82%B0.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart_calculate%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EC%84%A0%ED%83%9D%20%EA%B3%84%EC%82%B0.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | ------------------------ |
| cartNo                | query  | string  | ✅   | 선택된 장바구니 번호^                         | 1,2,3                    |
| divideInvalidProducts | query  | boolean | ❌   | 구매하지 못하는 상품 분할여부^                | true                     |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /recurring-payments/cart/subset

**요약**: 정기결제 장바구니에서 선택된 항목만 장바구니 그룹별로 재계산하기

**설명**:

## 부가설명 및 특이사항

장바구니에서 선택된 상품만 계산하여 장바구니 상품들과 금액까지 포함해서 리턴하는 API 입니다.

아래 화면예시에서 상품/옵션별 배송비를 함께 업데이트(재계산)할 수 있습니다.

cartNo 파라미터 자체를 넘기지 않는 경우 : 장바구니 전체

cartNo 에 빈 값을 넘기는 경우 : 0원

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart_subset%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%EC%97%90%EC%84%9C%20%EC%84%A0%ED%83%9D%EB%90%9C%20%ED%95%AD%EB%AA%A9%EB%A7%8C%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B7%B8%EB%A3%B9%EB%B3%84%EB%A1%9C%20%EC%9E%AC%20%EA%B3%84%EC%82%B0.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/cart/[GET]%20cart_subset%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%EC%97%90%EC%84%9C%20%EC%84%A0%ED%83%9D%EB%90%9C%20%ED%95%AD%EB%AA%A9%EB%A7%8C%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B7%B8%EB%A3%B9%EB%B3%84%EB%A1%9C%20%EC%9E%AC%20%EA%B3%84%EC%82%B0.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | ------------------------ |
| cartNo                | query  | string  | ✅   | 선택된 장바구니 번호^                         | 1,2,3                    |
| divideInvalidProducts | query  | boolean | ❌   | 구매하지 못하는 상품 분할여부^                | true                     |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /recurring-payments/close/{recurring-payment-id}

**요약**: 정기결제 해지하기

**설명**:

## 부가설명 및 특이사항

정기결제를 해지 처리하는 API 입니다.

성공적으로 해지 완료 시 204(noContent) 응답을 반환합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| recurring-payment-id  | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### POST /recurring-payments/guest/cart

**요약**: 정기결제 비회원 장바구니 계산하기

**설명**:

## 부가설명 및 특이사항

비회원의 장바구니금액 및 합배송 상품을 계산하여 목록을 가져오는 API 입니다.

쇼핑몰배송의 경우, 파트너명을 '쇼핑몰배송'으로 내려줍니다.

## 화면예시

[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_cart%20%EA%B2%8C%EC%8A%A4%ED%8A%B8%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B3%84%EC%82%B0%201-1.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_cart%20%EA%B2%8C%EC%8A%A4%ED%8A%B8%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B3%84%EC%82%B0%201-1.png)
[![](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_cart%20%EA%B2%8C%EC%8A%A4%ED%8A%B8%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B3%84%EC%82%B0%201-2.png?autox150)](http://image.toast.com/aaaaahb/api-description/order/guest/[POST]%20guest_cart%20%EA%B2%8C%EC%8A%A4%ED%8A%B8%20%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88%20%EA%B3%84%EC%82%B0%201-2.png)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | -------------- |
| divideInvalidProducts | query  | boolean | ❌   | 구매하지 못하는 상품 분할여부^                | true           |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0            |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko             |

**응답**:

- **200**: 200

---

### GET /recurring-payments/later-input/shippings

**요약**: 정기결제 선물하기 나중 입력 배송지 정보 조회하기

**설명**:

## 부가설명 및 특이사항

정기 결제 선물하기에서 나중 입력 배송지 정보를 조회하는 API 입니다.

정기 결제 그룹번호(recurringPaymentGroupNo)는 암호화된 값이어야 합니다.

**파라미터**:

| 이름                    | 위치   | 타입   | 필수 | 설명                                          |
| ----------------------- | ------ | ------ | ---- | --------------------------------------------- | -------------------------------- |
| Version                 | header | string | ✅   | API 버전^                                     | 1.0                              |
| clientId                | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id                   |
| platform                | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                               |
| language                | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                               |
| accessToken             | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token                |
| Shop-By-Authorization   | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token         |
| recurringPaymentGroupNo | header | string | ✅   | 암호화된 정기결제 그룹 번호^                  | RDFlU2czQ3dZeGM1YXlMYm9XSklidz09 |

**응답**:

- **200**: 200

---

### PUT /recurring-payments/later-input/shippings

**요약**: 정기결제 선물하기 나중 입력 배송지 정보 수정하기

**설명**:

## 부가설명 및 특이사항

정기 결제 선물하기에서 나중 입력 배송지 정보를 수정하는 API 입니다.

정기 결제 그룹번호(recurringPaymentGroupNo)는 암호화된 값이어야 합니다.

**파라미터**:

| 이름                    | 위치   | 타입   | 필수 | 설명                                          |
| ----------------------- | ------ | ------ | ---- | --------------------------------------------- | -------------------------------- |
| Version                 | header | string | ✅   | API 버전^                                     | 1.0                              |
| clientId                | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id                   |
| platform                | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                               |
| language                | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                               |
| accessToken             | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token                |
| Shop-By-Authorization   | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token         |
| recurringPaymentGroupNo | header | string | ✅   | 암호화된 정기결제 그룹 번호^                  | RDFlU2czQ3dZeGM1YXlMYm9XSklidz09 |

**응답**:

- **204**: 204

---

### GET /recurring-payments/order-sheets/{orderSheetNo}

**요약**: 정기결제 주문서 가져오기

**설명**:

## 부가설명 및 특이사항

정기결제 주문서를 조회하는 API 입니다.

참고 : 주문서 내에 가격이 500원 미만인 상품이 존재하면 400 에러를 응답합니다.

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                          |
| --------------------- | ------ | ------- | ---- | --------------------------------------------- | ------------------------ |
| orderSheetNo          | path   | string  | ✅   | -                                             |
| includeMemberAddress  | query  | boolean | ❌   | 회원주소포함여부^                             | false                    |
| isPresent             | query  | boolean | ❌   | 정기결제 선물하기 여부^                       | false                    |
| Version               | header | string  | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string  | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /recurring-payments/skip/next

**요약**: 정기결제 회차 건너뛰기 (bulk)

**설명**:

## 부가설명 및 특이사항

정기결제의 다음 회차를 건너뛰도록 설정합니다.

모든 정기결제의 회차 건너뛰가 성공적으로 설정 시 204(noContent) 응답을 반환합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### GET /recurring-payments/{recurringPaymentGroupNo}/guest

**요약**: 정기결제 선물하기 수령자 주문 상세 조회하기

**설명**:

## 부가설명 및 특이사항

정기 결제 선물하기 주문 상세 조회 API 입니다.

**파라미터**:

| 이름                    | 위치   | 타입   | 필수 | 설명                                          |
| ----------------------- | ------ | ------ | ---- | --------------------------------------------- | ---------------- |
| recurringPaymentGroupNo | path   | string | ✅   | -                                             |
| Version                 | header | string | ✅   | API 버전^                                     | 1.0              |
| clientId                | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id   |
| platform                | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC               |
| language                | header | string | ❌   | 언어 (기본 값: ko)^                           | ko               |
| guestToken              | header | string | ✅   | guestToken^                                   | test-guest-token |

**응답**:

- **200**: 200

---

### POST /recurring-payments/{recurringPaymentGroupNo}/guest

**요약**: 정기결제 선물하기 수령자 주문 토큰 발급하기

**설명**:

## 부가설명 및 특이사항

정기 결제 선물하기 주문 조회용 토큰을 발급하는 API 입니다.

신청그룹번호, 이름, 비밀번호를 입력해야 합니다.

**파라미터**:

| 이름                    | 위치   | 타입   | 필수 | 설명                                          |
| ----------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| recurringPaymentGroupNo | path   | string | ✅   | -                                             |
| Version                 | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId                | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform                | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language                | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken             | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization   | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /recurring-payments/{recurringPaymentId}/gifts

**요약**: 정기 결제 사은품 조회

**설명**:

## 부가설명 및 특이사항

정기 결제 사은품을 조회하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| recurringPaymentId    | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /recurring-payments/{recurringPaymentId}/info

**요약**: 정기 결제 배송 정보 변경

**설명**:

## 부가설명 및 특이사항

정기 결제 정보를 수정하는 API 입니다.

변경을 원치 않는 정보는 null 로 요청해 주세요.

정기 결제의 정보를 성공적으로 변경 시 204(noContent) 응답을 반환합니다.

### 1. 상품 변경

상품 변경 시 새로운 배송 주기 정보도 같이 입력해야 합니다.

상품 수정 시 변경되는 상품의 사은품으로 자동 변경됩니다.

### 2. 배송지 변경

정기 결제 주소지를 입력해야 합니다.

### 3. 결제 정보 변경

변경한 카드가 해당 정기 결제의 메인 카드가 됩니다.

### 4. 배송 주기 변경

정기 결제 상품에 대해 설정할 수 있는 배송 주기를 입력해야 합니다.

### 5. 종료 회차 변경

정기 결제의 종료 회차를 설정하지 않으려면 0으로 보내주세요.

### 이용 대기 상태

이용 대기 상태는 결제 정보, 종료 회차만 변경 가능합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| recurringPaymentId    | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### PUT /recurring-payments/{recurringPaymentId}/status

**요약**: 정기결제 상태 변경

**설명**:

## 부가설명 및 특이사항

정기결제 신청건의 상태를 변경하는 API 입니다.

모든 신청건의 상태를 성공적으로 변경 시 204(noContent) 응답을 반환합니다.

참고: 아래와 같은 상태변경만 가능합니다.

### 이용중 (ACTIVE) -> 일시중지 (USER_PAUSED)

### 일시중지 (USER_PAUSED) -> 이용중 (ACTIVE)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| recurringPaymentId    | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### PUT /recurring-payments/card/{cardNo}/main

**요약**: 정기결제 메인 카드 설정

**설명**:

## 부가설명 및 특이사항

정기결제 메인 카드를 설정하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| cardNo                | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### POST /recurring-payments/{recurringPaymentId}/skip/next

**요약**: 정기결제 회차 건너뛰기

**설명**:

## 부가설명 및 특이사항

정기결제의 다음 회차를 건너뛰도록 설정합니다.

모든 정기결제의 회차 건너뛰가 성공적으로 설정 시 204(noContent) 응답을 반환합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| recurringPaymentId    | path   | string | ✅   | -                                             |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

## UnidentifiedDepositors

### GET /unidentifiedDepositors

**요약**: [샵바이프로 전용] 미확인 입급자 조회하기

**설명**:

## 부가설명 및 특이사항

미확인 입금자를 조회하는 API 입니다.

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                          |
| ---------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| mallNo     | query  | string | ✅   | 쇼핑몰 번호^                                  | 1              |
| depositYmd | query  | string | ✅   | 입금일^                                       | YYYY-MM-DD     |
| name       | query  | string | ✅   | 입금자명^                                     | test           |
| page       | query  | string | ✅   | 페이지 번호 (1 이상)^                         | 1              |
| size       | query  | string | ✅   | 페이지당 노출 개수^                           | 30             |
| Version    | header | string | ✅   | API 버전^                                     | 1.0            |
| clientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| platform   | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| language   | header | string | ❌   | 언어 (기본 값: ko)^                           | ko             |

**응답**:

- **200**: 200

---

### GET /unidentifiedDepositors/config

**요약**: [샵바이프로 전용] 미확인 입금자 설정 조회하기

**설명**:

## 부가설명 및 특이사항

미확인 입금자 설정을 조회하는 API 입니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| language | header | string | ❌   | 언어 (기본 값: ko)^                           | ko             |

**응답**:

- **200**: 200

---

## Wish

### GET /wish

**요약**: 위시리스트 리스트 가져오기

**설명**:

## 부가설명 및 특이사항

위시리스트를 조회하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /wish

**요약**: 위시리스트 등록하기

**설명**:

## 부가설명 및 특이사항

위시리스트를 등록하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /wish

**요약**: 위시리스트 수정하기

**설명**:

## 부가설명 및 특이사항

위시리스트를 수정하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### DELETE /wish

**요약**: 위시리스트 삭제하기

**설명**:

## 부가설명 및 특이사항

위시리스트를 삭제하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| wishNos               | query  | number | ✅   | 위 번호^                                      | 1,2,3                    |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /wish/count

**요약**: 위시리스트 개수 가져오기

**설명**:

## 부가설명 및 특이사항

위시리스트 개수를 조회하는 API 입니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | ko                       |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰^                             | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---
