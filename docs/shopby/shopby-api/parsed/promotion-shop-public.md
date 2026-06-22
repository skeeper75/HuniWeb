# promotion-shop

**버전**: 0.1.0-SNAPSHOT
**서버**: https://shop-api.e-ncp.com

프로모션 혜택(promotion)관련 shop API입니다.

---

## Coupon

### GET /coupons

**요약**: 내 쿠폰 가져오기

**설명**:

## 부가설명 및 특이사항

로그인한 사용자가 보유한 쿠폰중 사용가능한 쿠폰과 이미 사용한 쿠폰을 구분하여 조회합니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/order/coupon/[GET]%20coupons%20%EB%82%B4%20%EC%BF%A0%ED%8F%B0%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0(%EB%A7%88%EC%9D%B4%ED%8E%98%EC%9D%B4%EC%A7%80).png'><img src='http://image.toast.com/aaaaahb/api-description/order/coupon/[GET]%20coupons%20%EB%82%B4%20%EC%BF%A0%ED%8F%B0%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0(%EB%A7%88%EC%9D%B4%ED%8E%98%EC%9D%B4%EC%A7%80).png?autox150'></a>

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                     |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------ | ------------------------ |
| couponNos             | query  | string | ❌   | 쿠폰 번호^                                                               | [1, 2, 3]                |
| desc                  | query  | string | ❌   | 내림차순 정렬 여부^                                                      | false                    |
| endYmd                | query  | string | ❌   | 검색 종료 일 (지정 하지 않을 시 오늘 날짜까지 조회)^                     | yyyy-MM-dd               |
| pageNumber            | query  | string | ✅   | 페이지 번호^                                                             | 1                        |
| pageSize              | query  | string | ✅   | 한 페이지당 노출 수^                                                     | 30                       |
| searchDateType        | query  | string | ❌   | 기간 검색타입 (REGISTER_YMD: 등록일(default), USE_END_YMD: 사용 종료일)^ | REGISTER_YMD             |
| startYmd              | query  | string | ❌   | 검색 시작 일 (지정 하지 않을 시 3개월 전 오늘 날짜부터 조회)^            | yyyy-MM-dd               |
| usable                | query  | string | ❌   | 사용가능 여부 (true: 사용 가능 / false: 사용 불가능 / null: 조건 없음)^  | true                     |
| Version               | header | string | ✅   | API 버전^                                                                | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                                           | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                                                | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                                | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                            | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                                                      | PC                       |

**응답**:

- **200**: 200

---

### POST /coupons/download

**요약**: 쿠폰 일괄 다운로드하기

**설명**:

## 부가설명 및 특이사항

쿠폰번호 리스트를 입력 받아 다운로드 쿠폰을 발급 받습니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### GET /coupons/issuable

**요약**: 발급 가능한 쿠폰 조회하기

**설명**:

## 부가설명 및 특이사항

상품과 상관없이 오늘 날짜 기준으로 다운로드 가능한 쿠폰을 모두 조회합니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/order/coupon/[GET]%20coupons_issuable%20%EC%98%A4%EB%8A%98%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C%20%EA%B0%80%EB%8A%A5%ED%95%9C%20%EC%BF%A0%ED%8F%B0%20%EC%A1%B0%ED%9A%8C.png'><img src='http://image.toast.com/aaaaahb/api-description/order/coupon/[GET]%20coupons_issuable%20%EC%98%A4%EB%8A%98%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C%20%EA%B0%80%EB%8A%A5%ED%95%9C%20%EC%BF%A0%ED%8F%B0%20%EC%A1%B0%ED%9A%8C.png?autox150'></a>

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| channelType           | query  | string | ❌   | 채널 타입^                                    | NAVER_EP, FACEBOOK       |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### GET /coupons/summary

**요약**: 내 쿠폰 요약정보 가져오기

**설명**:

## 부가설명 및 특이사항

로그인한 사용자가 보유한 쿠폰의 정보를 요약하여 조회합니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/order/coupon/[GET]%20coupons_summary%20%EB%82%B4%20%EC%BF%A0%ED%8F%B0%20%EC%9A%94%EC%95%BD%EC%A0%95%EB%B3%B4.png'><img src='http://image.toast.com/aaaaahb/api-description/order/coupon/[GET]%20coupons_summary%20%EB%82%B4%20%EC%BF%A0%ED%8F%B0%20%EC%9A%94%EC%95%BD%EC%A0%95%EB%B3%B4.png?autox150'></a>

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| expireDay             | query  | string | ❌   | 현재 ~ (현재 + 만료일) 기준으로 검색됩니다.^  | 7                        |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### POST /coupons/products/download

**요약**: 상품번호 리스트로 쿠폰 일괄 다운로드하기

**설명**:

## 부가설명 및 특이사항

상품번호 리스트를 입력받아 다운로드 쿠폰을 발급 받습니다.
(특정 상품 상세 페이지에 추가상품이 설정된 경우,
해당 API를 사용하시면 해당 상품뿐만 아니라 추가상품에도 적용할 수 있는 쿠폰을 지급받을 수 있습니다.)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### POST /coupons/register-code/{promotionCode}

**요약**: 코드 쿠폰 발급하기

**설명**:

## 부가설명 및 특이사항

등록된 프로모션 코드를 이용해 쿠폰을 발급받습니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/order/coupon/[POST]%20coupons_register-code_%EC%BF%A0%ED%8F%B0%EC%BD%94%EB%93%9C%EB%A1%9C%20%EC%BF%A0%ED%8F%B0%20%EB%B0%9C%EA%B8%89.png'><img src='http://image.toast.com/aaaaahb/api-description/order/coupon/[POST]%20coupons_register-code_%EC%BF%A0%ED%8F%B0%EC%BD%94%EB%93%9C%EB%A1%9C%20%EC%BF%A0%ED%8F%B0%20%EB%B0%9C%EA%B8%89.png?autox150'></a>

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| promotionCode         | path   | string | ✅   | 프로모션 코드^                                | 2020EVENT                |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### POST /coupons/{couponNo}/download

**요약**: 쿠폰 발급하기

**설명**:

## 부가설명 및 특이사항

선택한 쿠폰번호에 해당하는 다운로드 쿠폰을 발급받습니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/order/coupon/[POST]%20coupons_download%20%EC%BF%A0%ED%8F%B0%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C.png'><img src='http://image.toast.com/aaaaahb/api-description/order/coupon/[POST]%20coupons_download%20%EC%BF%A0%ED%8F%B0%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C.png?autox150'></a>

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| couponNo              | path   | number | ✅   | 쿠폰번호^                                     | 1                        |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### GET /coupons/{couponNo}/exclude-targets

**요약**: 쿠폰번호로 제외 대상 조회하기

**설명**:

## 부가설명 및 특이사항

선택한 쿠폰번호에 해당하는 제외 대상의 목록을 조회합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| couponNo              | path   | number | ✅   | 쿠폰 번호^                                    | 1                        |
| pageNumber            | query  | string | ✅   | 페이지 번호^                                  | 1                        |
| pageSize              | query  | string | ✅   | 한 페이지당 노출 수^                          | 50                       |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### GET /coupons/{couponNo}/targets

**요약**: 쿠폰번호로 대상 조회하기

**설명**:

## 부가설명 및 특이사항

선택한 쿠폰번호에 해당하는 대상의 목록을 조회합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| couponNo              | path   | number | ✅   | 쿠폰 번호^                                    | 1                        |
| pageNumber            | query  | string | ✅   | 페이지 번호^                                  | 1                        |
| pageSize              | query  | string | ✅   | 한 페이지당 노출 수^                          | 50                       |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### POST /coupons/events/{eventNo}/download

**요약**: 기획전 번호로 쿠폰 발급하기

**설명**:

## 부가설명 및 특이사항

해당 기획전에서 다운로드받을 수 있는 모든 쿠폰을 발급합니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/order/coupon/[POST]%20coupons_events_download%20%EB%AA%A8%EB%93%A0%20%EC%BF%A0%ED%8F%B0%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C(%EC%9D%B4%EB%B2%A4%ED%8A%B8%ED%8E%98%EC%9D%B4%EC%A7%80).png'><img src='http://image.toast.com/aaaaahb/api-description/order/coupon/[POST]%20coupons_events_download%20%EB%AA%A8%EB%93%A0%20%EC%BF%A0%ED%8F%B0%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C(%EC%9D%B4%EB%B2%A4%ED%8A%B8%ED%8E%98%EC%9D%B4%EC%A7%80).png?autox150'></a>

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| eventNo               | path   | number | ✅   | 기획전 번호^                                  | 123                      |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### GET /coupons/products/issuable/coupons

**요약**: 상품번호 리스트로 발급 가능한 쿠폰 조회하기

**설명**:

## 부가설명 및 특이사항

상품번호 리스트를 입력받아 발급 가능한 쿠폰 리스트를 조회합니다.
(특정 상품 상세 페이지에 추가상품이 설정된 경우
해당 API를 사용하시면 해당 상품뿐만 아니라 추가상품에도 적용할 수 있는 쿠폰을 조회할 수 있습니다.)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### POST /coupons/products/{productNo}/download

**요약**: 상품 번호로 쿠폰 발급하기

**설명**:

## 부가설명 및 특이사항

해당 상품에서 다운로드받을 수 있는 모든 쿠폰을 발급합니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/order/coupon/[POST]%20coupons_products_download%20%EB%AA%A8%EB%93%A0%20%EC%BF%A0%ED%8F%B0%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C(%EC%83%81%ED%92%88%ED%8E%98%EC%9D%B4%EC%A7%80).png'><img src='http://image.toast.com/aaaaahb/api-description/order/coupon/[POST]%20coupons_products_download%20%EB%AA%A8%EB%93%A0%20%EC%BF%A0%ED%8F%B0%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C(%EC%83%81%ED%92%88%ED%8E%98%EC%9D%B4%EC%A7%80).png?autox150'></a>

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| productNo             | path   | number | ✅   | 상품번호^                                     | 123412                   |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### GET /coupons/targets/issuable/coupons

**요약**: 특정 할인대상으로 발급 가능한 쿠폰 조회하기

**설명**:

## 부가설명 및 특이사항

특정 할인대상으로 발급 가능한 쿠폰 조회하기
(할인대상: 브랜드/카테고리/파트너)

`targetNo` 또는 `targetNos` 중 하나는 반드시 입력해야 합니다.

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| channelType           | query  | string | ❌   | 채널 타입^                                    | NAVER_EP, FACEBOOK       |
| couponTargetType      | query  | string | ✅   | 쿠폰 할인 대상^                               | BRAND, CATEGORY, PARTNER |
| targetNo              | query  | string | ❌   | 할인 대상 번호^                               | 123                      |
| targetNos             | query  | string | ❌   | 할인 대상 번호 리스트^                        | 123,456                  |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

### GET /coupons/products/{productNo}/issuable/coupons

**요약**: 상품 번호로 발급 가능한 쿠폰 조회하기

**설명**:

## 부가설명 및 특이사항

해당 상품 상세정보에서 다운로드 할수 있는 모든 쿠폰을 조회합니다.
상품번호 뿐만 아니라 해당 상품의 브랜드, 파트너, 카테고리로 할인대상 설정된 쿠폰도 조회합니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/order/coupon/[GET]%20coupons_products_issuable_coupons%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C%20%EA%B0%80%EB%8A%A5%ED%95%9C%20%EC%BF%A0%ED%8F%B0%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0.png'><img src='http://image.toast.com/aaaaahb/api-description/order/coupon/[GET]%20coupons_products_issuable_coupons%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C%20%EA%B0%80%EB%8A%A5%ED%95%9C%20%EC%BF%A0%ED%8F%B0%20%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0.png?autox150'></a>

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| productNo             | path   | number | ✅   | 상품번호^                                     | 1                        |
| channelType           | query  | string | ❌   | 채널 타입^                                    | NAVER_EP, FACEBOOK       |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **200**: 200

---

## CouponIssue

### POST /coupons/issues/{couponIssueNo}/use

**요약**: 쿠폰 사용하기

**설명**:

## 부가설명 및 특이사항

기프트 쿠폰만 사용 처리 가능하며, <br />
기프트 쿠폰 사용 처리 시 혜택이 지급됩니다. (예, 적립금)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| couponIssueNo         | path   | number | ✅   | 쿠폰 지급 번호^                               | 1                        |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| accessToken           | header | string | ❌   | 로그인 인증키^                                | test-access-token        |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| language              | header | string | ❌   | 언어 (기본 값: ko)^                           | PC                       |

**응답**:

- **204**: 204

---
