# product-shop

**버전**: 0.0.1-SNAPSHOT
**서버**: https://shop-api.e-ncp.com

상품(product)관련 shop API입니다.

---

## Additional Discount

### GET /additional-discounts/by-product-no

**요약**: 추가할인 정보 조회하기

**설명**:

## 부가설명 및 특이사항

상품번호로 추가할인 정보 조회하는 API입니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

  ***

## [구매수량할인 사용시]

### 구매수량할인 정액할인: (옵션금액 - 정액할인금액) \* 수량

예시) 옵션금액 100원 일때, 옵션단위 5개 이상 10개 미만 구매시 **50원** 할인
| 상품(옵션) | 구매수량 | 구매수량할인 | 구매수량할인적용 | 최종금액 |
| -------- | ------- | ------- | ------- | ------- |
| 볼펜(빨강) | 3 | 적용불가 | - | 300 |
| 볼펜(검정) | 5 | 적용가능 | (100-50) \* 5 | 250 |
| 볼펜(파랑) | 10 | 적용불가 | - | 1000 |

---

### 구매수량할인 정률할인: (옵션금액 _ 수량) _ (100 - 정률할인)%

예시) 옵션금액 100원 일때, 옵션단위 5개 이상 10개 미만 구매시 **10%** 할인
| 상품(옵션) | 구매수량 | 구매수량할인 | 구매수량할인적용 | 최종금액 |
| -------- | ------- | ------- | ------- | ------- |
| 볼펜(빨강) | 3 | 적용불가 | - | 300 |
| 볼펜(검정) | 5 | 적용가능 | (100 _ 5) _ (100-10)% | 450 |
| 볼펜(파랑) | 10 | 적용불가 | - | 1000 |

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo             | query  | number | ✅   | 상품번호                                                                                                                             |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

## Brand

### GET /display/brands

**요약**: 브랜드 목록 조회하기

**설명**:

## 부가설명 및 특이사항

브랜드 목록 조회하는 API입니다

Paging 기능 제공합니다

상품에 매핑된 브랜드를 조회합니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                   | 위치   | 타입    | 필수 | 설명                                                                                                                                                   |
| ---------------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| filter.name            | query  | string  | ❌   | 검색할 브랜드명                                                                                                                                        |
| filter.categoryNo      | query  | number  | ❌   | 검색할 카테고리 번호                                                                                                                                   |
| filter.soldOutIncluded | query  | boolean | ❌   | 품절 상품 포함 여부(default: false)                                                                                                                    |
| pageNumber             | query  | number  | ❌   | 페이지 번호                                                                                                                                            |
| pageSize               | query  | number  | ❌   | 한 페이지당 노출 수                                                                                                                                    |
| hasTotalCount          | query  | boolean | ❌   | 전체 브랜드 수 포함 여부(default: false)                                                                                                               |
| fromDB                 | query  | boolean | ❌   | DB검색 사용 (default: false , 검색엔진 사용)                                                                                                           |
| sort.criterion         | query  | string  | ❌   | 정렬 필드 (null 또는 값 없음(default) - 브랜드명 가나다순 / PRODUCT_COUNT - 브랜드 상품 매핑 수로 정렬 후, 브랜드 가나다순 / REGISTER_DATE - 등록일순) |
| sort.direction         | query  | string  | ❌   | 정렬 방식 (ASC - 오름차순, DESC - 내림차순 / 정렬 필드가 있는 경우에만 적용됩니다.)                                                                    |
| Version                | header | string  | ✅   | API 버전                                                                                                                                               |
| clientId               | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                                               |
| platform               | header | string  | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시                   |
| language               | header | string  | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                                                |

**응답**:

- **200**: 200

---

### GET /display/brands/extraInfo

**요약**: 브랜드 추가 정보 조회하기

**설명**:

## 부가설명 및 특이사항

### 브랜드 추가정보 조회하는 API입니다.

- 브랜드 요청 번호는 최대 30개 까지 가능합니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름            | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| displayBrandNos | query  | number | ✅   | 전시 브랜드 번호                                                                                                                     |
| Version         | header | string | ✅   | API 버전                                                                                                                             |
| clientId        | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform        | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language        | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

### GET /display/brands/search

**요약**: 브랜드 조회하기

**설명**:

## 부가설명 및 특이사항

브랜드 조회하는 API입니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름          | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| ------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| brandName     | query  | string | ❌   | 검색할 브랜드명(없는 경우, 전체 브랜드 조회)                                                                                         |
| pageNumber    | query  | number | ❌   | 페이지 번호(default: 1)                                                                                                              |
| pageSize      | query  | number | ❌   | 한 페이지당 노출 수                                                                                                                  |
| sortCriterion | query  | string | ❌   | 정렬 필드(default: BRAND_NAME), (BRAND_NAME:브랜드명, LIKE_COUNT:브랜드 좋아요 수)                                                   |
| sortDirection | query  | string | ❌   | 정렬 방식(default: DESC), (ASC:오름차순, DESC:내림차순)                                                                              |
| Version       | header | string | ✅   | API 버전                                                                                                                             |
| clientId      | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform      | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language      | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

### GET /display/brands/search-by-nos

**요약**: 브랜드번호로 브랜드정보 조회하기

**설명**:

## 부가설명 및 특이사항

브랜드번호로 브랜드정보 조회하는 API입니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름            | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| displayBrandNos | query  | string | ❌   | 브랜드번호                                                                                                                           |
| Version         | header | string | ✅   | API 버전                                                                                                                             |
| clientId        | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform        | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language        | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

### GET /display/brands/tree

**요약**: 브랜드 트리 조회하기

**설명**:

## 부가설명 및 특이사항

브랜드 트리 조회하는 API입니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| -------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Version  | header | string | ✅   | API 버전                                                                                                                             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

### GET /display/brands/{displayBrandNo}

**요약**: 브랜드 상세 조회하기

**설명**:

## 부가설명 및 특이사항

브랜드 상세 조회하는 API입니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름           | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| -------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| displayBrandNo | path   | string | ✅   | 전시브랜드 번호                                                                                                                      |
| Version        | header | string | ✅   | API 버전                                                                                                                             |
| clientId       | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform       | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language       | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

### GET /display/brands/{displayBrandNo}/children

**요약**: 자식 브랜드 조회하기

**설명**:

## 부가설명 및 특이사항

자식 브랜드를 조회하는 API입니다

- 해당 브랜드의 바로 하위 브랜드의 정보를 조회합니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름           | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| -------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| displayBrandNo | path   | string | ✅   | -                                                                                                                                    |
| Version        | header | string | ✅   | API 버전                                                                                                                             |
| clientId       | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform       | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language       | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

## Free Gift

### GET /free-gift-condition/order-amount

**요약**: 사은품 지급가능한 조건 조회하기 (주문금액기준)

**설명**:

## 부가설명 및 특이사항

주문금액에 해당하는 지급가능한 조건 조회하는 API입니다

orderAmt(주문금액)을 입력하면 해당 주문금액에 맞는 조건만 조회됩니다

orderAmt(주문금액)을 입력하지 않으면 모든 조건을 조회합니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| orderAmt              | query  | number | ❌   | 주문금액                                                                                                                             |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /free-gift-condition/{productNo}

**요약**: 사은품 지급가능한 조건 조회하기

**설명**:

## 부가설명 및 특이사항

상품번호에 해당하는 지급가능한 조건 조회하는 API입니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo             | path   | string | ✅   | 상품번호                                                                                                                             |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

## Profile

### GET /guest/recent-products

**요약**: 비회원용 최근 본 상품 조회하기

**설명**:

## 부가설명 및 특이사항

비회원용 최근 본 상품 조회하는 API입니다

localStorage에 저장한 mallProductNos로 최근 본 상품을 조회합니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## 화면 예시

[![guest-recently-viewed-img](<http://image.toast.com/aaaaahb/api-description/product/%EC%B5%9C%EA%B7%BC%EC%83%81%ED%92%88/[GET]%20profile_recent-products%20%EC%B5%9C%EA%B7%BC%20%EB%B3%B8%20%EC%83%81%ED%92%88%20%EC%A1%B0%ED%9A%8C(%EB%B9%84%ED%9A%8C%EC%9B%90).png?autox150>)](<http://image.toast.com/aaaaahb/api-description/product/%EC%B5%9C%EA%B7%BC%EC%83%81%ED%92%88/[GET]%20profile_recent-products%20%EC%B5%9C%EA%B7%BC%20%EB%B3%B8%20%EC%83%81%ED%92%88%20%EC%A1%B0%ED%9A%8C(%EB%B9%84%ED%9A%8C%EC%9B%90).png>)

## [상품 금액 적용]

### 기본 상품 판매가

- 옵션이 없는 상품
  - 상품 등록 시, 기입한 판매가 그대로 적용
- 옵션이 있는 상품
  - 상품 등록 시, 기입한 판매가 + 옵션가 적용
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) 인 경우\|\, 옵션1 구매가격은 10000원 옵션2 구매가격은 11000원
- 세트 상품
  - 세트 상품의 옵션에 구성된 옵션(옵션있는 상품들의 옵션으로 세트 옵션 구성)의 구매가격의 합
  - 세트 옵션 구성이 달라질 수 있기때문에 당연히 옵션마다 가격 상이 함

### 즉시 할인

- 옵션이 없는 상품
  - 판매가에 즉시할인이 적용된 가격
- 옵션있는 상품\, 세트 상품
  - 판매가에 즉시할인이 적용된 가격 + 옵션가 가 최종 가격
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\) 이고 즉시 할인율 10% 인 경우\,
    옵션별 가격은 판매가 \*0.8 + 옵션가 이므로 따라서
    옵션 1 의 판매가격은 9000원, 옵션 2의 판매가격은 10000원, 옵션3의 판매가격은 11000원

\* **옵션가격에서 즉시 할인이 적용 되는 것이 아님**

### 추가 할인

- 할인 적용 순서 : 즉시 할인 -> 추가 할인
- 즉시 할인 적용 된 판매가격에 추가 할인 적용
  - 예) 10000원 상품에 즉시 할인으로 1000원일 할인된다면, 9000원에서 추가 할인 설정에 따라 할인 적용

**즉시 할인**과의 차이점이라면 적용되는 가격인데 즉시 할인의 경우 상품을 등록 할 때에 입력한 판매가 적용하지만, **추가 할인**은 실제 해당 상품의 구매 가격에 적용 (상품등록 시에 판매가에 적용되는 것이 아닌 실제 구매 금액에 적용)

- 예) A상품(판매가15000원)

  \- 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\)

  \- 즉시 할인 : 5000원

  \- 추가 할인 : 10%

  옵션 1 구매가격 : ((15000-5000) + 0)\*0.9 = 9000

  옵션 2 구매가격 : ((15000-5000) + 1000)\*0.9 = 9900

  옵션 2 구매가격 : ((15000-5000) + 2000)\*0.9 = 10800

**파라미터**:

| 이름            | 위치   | 타입    | 필수 | 설명                                                                                                                                 |
| --------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| mallProductNos  | query  | string  | ✅   | 상품 번호 리스트                                                                                                                     |
| soldout         | query  | boolean | ✅   | 품절상품 포함 여부(default : true)                                                                                                   |
| hasOptionValues | query  | boolean | ✅   | 옵션 값 포함 여부 (default: false)                                                                                                   |
| Version         | header | string  | ✅   | API 버전                                                                                                                             |
| clientId        | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform        | header | string  | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language        | header | string  | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

### GET /profile/like-brands

**요약**: 브랜드 좋아요 목록 전체 조회하기

**설명**:

## 부가설명 및 특이사항

좋아요한 브랜드 목록을 전체 조회하는 API입니다.

더보기 방식으로 조회를 원할 경우 displayBrandNo를 추가해주시면 됩니다.(pageNumber는 제외 하고 요청)

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름           | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| -------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| pageNumber     | query  | number | ❌   | 페이지 번호                                                                                                                          |
| pageSize       | query  | number | ❌   | 한 페이지당 노출 수                                                                                                                  |
| displayBrandNo | query  | number | ❌   | 브랜드 번호                                                                                                                          |
| Version        | header | string | ✅   | API 버전                                                                                                                             |
| clientId       | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform       | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language       | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

### GET /profile/like-products

**요약**: 회원이 좋아하는 상품목록 조회하기

**설명**:

## 부가설명 및 특이사항

회원이 좋아하는 상품목록 조회하는 API입니다

로그인 이후에만 호출 가능합니다(accessToken)

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## [상품 금액 적용]

### 기본 상품 판매가

- 옵션이 없는 상품
  - 상품 등록 시, 기입한 판매가 그대로 적용
- 옵션이 있는 상품
  - 상품 등록 시, 기입한 판매가 + 옵션가 적용
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) 인 경우\|\, 옵션1 구매가격은 10000원 옵션2 구매가격은 11000원
- 세트 상품
  - 세트 상품의 옵션에 구성된 옵션(옵션있는 상품들의 옵션으로 세트 옵션 구성)의 구매가격의 합
  - 세트 옵션 구성이 달라질 수 있기때문에 당연히 옵션마다 가격 상이 함

### 즉시 할인

- 옵션이 없는 상품
  - 판매가에 즉시할인이 적용된 가격
- 옵션있는 상품\, 세트 상품
  - 판매가에 즉시할인이 적용된 가격 + 옵션가 가 최종 가격
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\) 이고 즉시 할인율 10% 인 경우\,
    옵션별 가격은 판매가 \*0.8 + 옵션가 이므로 따라서
    옵션 1 의 판매가격은 9000원, 옵션 2의 판매가격은 10000원, 옵션3의 판매가격은 11000원

\* **옵션가격에서 즉시 할인이 적용 되는 것이 아님**

### 추가 할인

- 할인 적용 순서 : 즉시 할인 -> 추가 할인
- 즉시 할인 적용 된 판매가격에 추가 할인 적용
  - 예) 10000원 상품에 즉시 할인으로 1000원일 할인된다면, 9000원에서 추가 할인 설정에 따라 할인 적용

**즉시 할인**과의 차이점이라면 적용되는 가격인데 즉시 할인의 경우 상품을 등록 할 때에 입력한 판매가 적용하지만, **추가 할인**은 실제 해당 상품의 구매 가격에 적용 (상품등록 시에 판매가에 적용되는 것이 아닌 실제 구매 금액에 적용)

- 예) A상품(판매가15000원)

  \- 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\)

  \- 즉시 할인 : 5000원

  \- 추가 할인 : 10%

  옵션 1 구매가격 : ((15000-5000) + 0)\*0.9 = 9000

  옵션 2 구매가격 : ((15000-5000) + 1000)\*0.9 = 9900

  옵션 2 구매가격 : ((15000-5000) + 2000)\*0.9 = 10800

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| pageNumber            | query  | number | ❌   | 페이지 번호                                                                                                                          |
| pageSize              | query  | number | ❌   | 한 페이지당 노출 수                                                                                                                  |
| hasTotalCount         | query  | string | ❌   | 전체 상품 수 포함 여부(default: false)                                                                                               |
| hasMaxCouponAmt       | query  | string | ❌   | 최대쿠폰 할인가격 포함여부(default: false)                                                                                           |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰 - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                           |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙) - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                   |

**응답**:

- **200**: 200

---

### POST /profile/like-products

**요약**: 회원이 상품을 좋아한다고 추가/삭제하기

**설명**:

## 부가설명 및 특이사항

회원이 좋아하는 상품목록 추가/삭제하는 API입니다

로그인 이후에만 호출 가능합니다(accessToken)

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰 - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                           |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙) - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                   |

**응답**:

- **200**: 200

---

### GET /profile/recent-products

**요약**: 최근 본 상품 조회하기

**설명**:

## 부가설명 및 특이사항

최근 본 상품 조회하는 API입니다

로그인 이후에만 호출 가능(accessToken)합니다

Paging 기능 이용 시, 사이즈는 최대 50건까지 가능합니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## 화면 예시

[![recently-viewed-img](http://image.toast.com/aaaaahb/api-description/product/%EC%B5%9C%EA%B7%BC%EC%83%81%ED%92%88/[DELETE]%20profile_recent-products%20%EC%B5%9C%EA%B7%BC%20%EB%B3%B8%20%EC%83%81%ED%92%88%20%EC%82%AD%EC%A0%9C.png?autox150)](http://image.toast.com/aaaaahb/api-description/product/%EC%B5%9C%EA%B7%BC%EC%83%81%ED%92%88/[DELETE]%20profile_recent-products%20%EC%B5%9C%EA%B7%BC%20%EB%B3%B8%20%EC%83%81%ED%92%88%20%EC%82%AD%EC%A0%9C.png)

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## [상품 금액 적용]

### 기본 상품 판매가

- 옵션이 없는 상품
  - 상품 등록 시, 기입한 판매가 그대로 적용
- 옵션이 있는 상품
  - 상품 등록 시, 기입한 판매가 + 옵션가 적용
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) 인 경우\|\, 옵션1 구매가격은 10000원 옵션2 구매가격은 11000원
- 세트 상품
  - 세트 상품의 옵션에 구성된 옵션(옵션있는 상품들의 옵션으로 세트 옵션 구성)의 구매가격의 합
  - 세트 옵션 구성이 달라질 수 있기때문에 당연히 옵션마다 가격 상이 함

### 즉시 할인

- 옵션이 없는 상품
  - 판매가에 즉시할인이 적용된 가격
- 옵션있는 상품\, 세트 상품
  - 판매가에 즉시할인이 적용된 가격 + 옵션가 가 최종 가격
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\) 이고 즉시 할인율 10% 인 경우\,
    옵션별 가격은 판매가 \*0.8 + 옵션가 이므로 따라서
    옵션 1 의 판매가격은 9000원, 옵션 2의 판매가격은 10000원, 옵션3의 판매가격은 11000원

\* **옵션가격에서 즉시 할인이 적용 되는 것이 아님**

### 추가 할인

- 할인 적용 순서 : 즉시 할인 -> 추가 할인
- 즉시 할인 적용 된 판매가격에 추가 할인 적용
  - 예) 10000원 상품에 즉시 할인으로 1000원일 할인된다면, 9000원에서 추가 할인 설정에 따라 할인 적용

**즉시 할인**과의 차이점이라면 적용되는 가격인데 즉시 할인의 경우 상품을 등록 할 때에 입력한 판매가 적용하지만, **추가 할인**은 실제 해당 상품의 구매 가격에 적용 (상품등록 시에 판매가에 적용되는 것이 아닌 실제 구매 금액에 적용)

- 예) A상품(판매가15000원)

  \- 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\)

  \- 즉시 할인 : 5000원

  \- 추가 할인 : 10%

  옵션 1 구매가격 : ((15000-5000) + 0)\*0.9 = 9000

  옵션 2 구매가격 : ((15000-5000) + 1000)\*0.9 = 9900

  옵션 2 구매가격 : ((15000-5000) + 2000)\*0.9 = 10800

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| soldout               | query  | boolean | ✅   | 품절상품 포함 여부(default : true)                                                                                                   |
| hasMaxCouponAmt       | query  | boolean | ✅   | 최대쿠폰 할인가격 포함여부(default: false)                                                                                           |
| hasOptionValues       | query  | boolean | ✅   | 옵션 값 포함 여부 (default: false)                                                                                                   |
| pageNumber            | query  | number  | ❌   | 페이지 번호(default: 1)                                                                                                              |
| pageSize              | query  | number  | ❌   | 한 페이지당 노출 수(default: 50)                                                                                                     |
| Version               | header | string  | ✅   | API 버전                                                                                                                             |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string  | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string  | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰 - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                           |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙) - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                   |

**응답**:

- **200**: 200

---

### POST /profile/recent-products

**요약**: 최근 본 상품 등록하기

**설명**:

## 부가설명 및 특이사항

최근 본 상품 등록하는 API입니다

로그인 이후에만 호출 가능(accessToken)합니다

최근 본 50개 상품까지 서버에서 저장합니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰 - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                           |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙) - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                   |

**응답**:

- **204**: 204

---

### DELETE /profile/recent-products

**요약**: 최근 본 상품 삭제하기

**설명**:

## 부가설명 및 특이사항

최근 본 상품 삭제하는 API입니다

로그인 이후에만 호출 가능(accessToken)합니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo             | query  | number | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰 - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                           |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙) - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                   |

**응답**:

- **204**: 204

---

### POST /profile/like-brands/

**요약**: 브랜드에 대한 좋아요 설정 및 해제하기

**설명**:

## 부가설명 및 특이사항

브랜드에 대한 좋아요 설정 및 해제를 하는 API입니다.

로그인 이후에만 호출 가능합니다(accessToken)

1명의 회원이 좋아요할 수 있는 브랜드 개수는 최대 50개 입니다.

50개를 넘게 등록했을 경우 최근 등록된 좋아요 브랜드 정보만 남게 됩니다.

해당 회원이 이미 좋아요한 브랜드를 중복으로 요청할 경우 좋아요 수는 카운팅 되지 않습니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰 - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                           |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙) - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                   |

**응답**:

- **204**: 204

---

### GET /profile/like-brands/count

**요약**: 브랜드 좋아요 수 목록 조회

**설명**:

## 부가설명 및 특이사항

브랜드별 좋아요 수를 조회하는 API입니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름            | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| displayBrandNos | query  | number | ✅   | 브랜드 번호                                                                                                                          |
| sort.criterion  | query  | number | ❌   | 정렬 기준(default : DISPLAY_BRAND_NO) (DISPLAY_BRAND_NO: 브랜드 번호, LIKE_COUNT: 좋아요 수)                                         |
| sort.direction  | query  | number | ❌   | 정렬 방식(default : DESC) (ASC: 오름차순, DESC: 내림차순)                                                                            |
| Version         | header | string | ✅   | API 버전                                                                                                                             |
| clientId        | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform        | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language        | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

### GET /profile/like-brands/member

**요약**: 회원이 좋아요한 브랜드 목록 조회하기

**설명**:

## 부가설명 및 특이사항

내가 좋아요한 브랜드 목록을 조회할 수 있는 API입니다.

로그인 이후에만 호출 가능합니다(accessToken)

좋아요한 브랜드가 없을 경우 응답값에서 제외됩니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| displayBrandNos       | query  | number | ❌   | 브랜드 번호                                                                                                                          |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰 - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                           |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙) - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                   |

**응답**:

- **200**: 200

---

### POST /profile/like-products/

**요약**: 상품에 대한 좋아요 설정 및 해제하기

**설명**:

## 부가설명 및 특이사항

상품에 대한 좋아요 설정 및 해제를 하는 API입니다.

- 기존 '회원이 상품을 좋아한다고 추가/삭제하기' API에서 명시적인 '좋아요 설정 및 해제' 요청이 추가되었습니다.

- 기존에 '좋아요 설정'을 하지 않았던 상품에 대한 '좋아요 해제' 요청은 응답에 포함되지 않습니다.

로그인 이후에만 호출 가능합니다(accessToken)

header의 `Version` 값은 1.1로 요청해야합니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰 - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                           |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙) - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                   |

**응답**:

- **200**: 200

---

### GET /profile/like-products/count

**요약**: 회원이 좋아하는 상품 수 조회하기

**설명**:

## 부가설명 및 특이사항

회원이 좋아하는 상품 수를 조회하는 API입니다

로그인 이후에만 호출 가능합니다(accessToken)

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰 - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                           |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙) - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                   |

**응답**:

- **200**: 200

---

## Product

### GET /products/bundle-shipping

**요약**: 묶음 배송 상품 목록 조회하기

**설명**:

## 부가설명 및 특이사항

묶음 배송 상품 목록 조회하는 API입니다

hasBrandAndCategoryValues는 되도록 false로 설정해주세요.(성능 이슈)

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## [상품 금액 적용]

### 기본 상품 판매가

- 옵션이 없는 상품
  - 상품 등록 시, 기입한 판매가 그대로 적용
- 옵션이 있는 상품
  - 상품 등록 시, 기입한 판매가 + 옵션가 적용
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) 인 경우\|\, 옵션1 구매가격은 10000원 옵션2 구매가격은 11000원
- 세트 상품
  - 세트 상품의 옵션에 구성된 옵션(옵션있는 상품들의 옵션으로 세트 옵션 구성)의 구매가격의 합
  - 세트 옵션 구성이 달라질 수 있기때문에 당연히 옵션마다 가격 상이 함

### 즉시 할인

- 옵션이 없는 상품
  - 판매가에 즉시할인이 적용된 가격
- 옵션있는 상품\, 세트 상품
  - 판매가에 즉시할인이 적용된 가격 + 옵션가 가 최종 가격
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\) 이고 즉시 할인율 10% 인 경우\,
    옵션별 가격은 판매가 \*0.8 + 옵션가 이므로 따라서
    옵션 1 의 판매가격은 9000원, 옵션 2의 판매가격은 10000원, 옵션3의 판매가격은 11000원

\* **옵션가격에서 즉시 할인이 적용 되는 것이 아님**

### 추가 할인

- 할인 적용 순서 : 즉시 할인 -> 추가 할인
- 즉시 할인 적용 된 판매가격에 추가 할인 적용
  - 예) 10000원 상품에 즉시 할인으로 1000원일 할인된다면, 9000원에서 추가 할인 설정에 따라 할인 적용

**즉시 할인**과의 차이점이라면 적용되는 가격인데 즉시 할인의 경우 상품을 등록 할 때에 입력한 판매가 적용하지만, **추가 할인**은 실제 해당 상품의 구매 가격에 적용 (상품등록 시에 판매가에 적용되는 것이 아닌 실제 구매 금액에 적용)

- 예) A상품(판매가15000원)

  \- 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\)

  \- 즉시 할인 : 5000원

  \- 추가 할인 : 10%

  옵션 1 구매가격 : ((15000-5000) + 0)\*0.9 = 9000

  옵션 2 구매가격 : ((15000-5000) + 1000)\*0.9 = 9900

  옵션 2 구매가격 : ((15000-5000) + 2000)\*0.9 = 10800

**파라미터**:

| 이름                      | 위치   | 타입    | 필수 | 설명                                                                                                                                 |
| ------------------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| deliveryTemplateNo        | query  | number  | ✅   | 배송 템플릿 번호                                                                                                                     |
| hasOptionValues           | query  | boolean | ❌   | 옵션값 출력 여부 (default : false) (nullable)                                                                                        |
| hasBrandAndCategoryValues | query  | boolean | ❌   | 브랜드/카테고리 출력 여부 (default : false) (nullable)                                                                               |
| pageSize                  | query  | number  | ❌   | 한 페이지당 노출 수 (default : 30) (nullable)                                                                                        |
| pageNumber                | query  | number  | ❌   | 페이지 번호 (default : 1) (nullable)                                                                                                 |
| productSort.criterion     | query  | string  | ❌   | 정렬 기준 (default : RECENT_PRODUCT) (nullable)                                                                                      |
| productSort.direction     | query  | string  | ❌   | 정렬 방법 (default : DESCDeliveryFeignClient) (nullable)                                                                             |
| Version                   | header | string  | ✅   | API 버전                                                                                                                             |
| clientId                  | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform                  | header | string  | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language                  | header | string  | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

### GET /products/extraInfo

**요약**: 상품 번호 리스트로 추가 정보 조회

**설명**:

## 부가설명 및 특이사항

상품번호를 통해 extraInfo(추가정보)를 조회하는 API 입니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNos            | query  | string | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/favoriteKeywords

**요약**: 인기 검색어 조회하기

**설명**:

## 부가설명 및 특이사항

인기 검색어 조회하는 API입니다

- 인기 검색어는 현재 날짜를 기준으로 전 날에 유입된 검색어를 기준으로 노출합니다.

- 예시: 2023년 1월 12일에 조회하는 경우, 2023년 1월 11일까지 유입된 검색어를 바탕으로 노출합니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| size                  | query  | number | ❌   | 사이즈                                                                                                                               |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### POST /products/group-management-code

**요약**: 그룹관리코드 조회하기

**설명**:

## 부가설명 및 특이사항

그룹관리코드 조회하는 API입니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/public-info

**요약**: 상품 공개용 기본정보 조회 API

**설명**:

## 부가설명 및 특이사항

상품번호를 통해 공개용 기본정보들을 조회하는 API 입니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNos            | query  | string | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/regular-delivery

**요약**: 변경 가능한 정기 결제 상품 조회하기

**설명**:

## 부가설명 및 특이사항

변경 가능한 정기 결제 상품 조회 API 입니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| page                  | query  | number | ❌   | 페이지 번호 (default : 1) (nullable)                                                                                                 |
| size                  | query  | number | ❌   | 한 페이지당 노출 수 (default : 10) (nullable)                                                                                        |
| displayCategoryNos    | query  | string | ❌   | 전시 카테고리 번호 정보 (nullable)                                                                                                   |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### POST /products/restock

**요약**: 재입고 알림 신청

**설명**:

## 부가설명 및 특이사항

재입고 알림 신청하는 API입니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **204**: 204

---

### GET /products/search

**요약**: 상품 검색(search engine)하기

**설명**:

## 부가설명 및 특이사항

상품 목록 조회하는 API입니다.

- Paging 기능 제공합니다. (페이지당 조회가능한 최대 상품 개수는 500개 입니다.)
- 아래 Parameters에 해당하는 검색조건들의 경우, 매 10분 마다 캐시가 됩니다 ( ex. 10시 10분, 10시 20분, 10시 30분...)
- ex. 10시 13분에 상품명을 [테스트 상품 -> 임시 상품]으로 변경 후 '임시 상품'으로 검색 시, 10시 19분까지 검색되지않고, 10시 20분이후에 검색 가능합니다.

## 화면 예시

[![product-search-img-1](<http://image.toast.com/aaaaahb/api-description/product/%EC%83%81%ED%92%88/[GET]%20product_search%20%EC%83%81%ED%92%88%20%EA%B2%80%EC%83%89(search%20engine).png?autox150>)](<http://image.toast.com/aaaaahb/api-description/product/%EC%83%81%ED%92%88/[GET]%20product_search%20%EC%83%81%ED%92%88%20%EA%B2%80%EC%83%89(search%20engine).png>)

---

## 참고

상세 상품 정렬 기준 (order.by 파라미터)

- MD추천순(MD_RECOMMEND): [서비스어드민 > 전시관리 > 전시상품 우선순위 관리] 메뉴에서 설정하신 정렬 순서로 상품이 노출됩니다.
  - ASC: 우선순위가 높은(숫자가 낮은) 상품 순으로 정렬됩니다. (1순위 -> 2순위 -> 3순위...)
  - DESC: 우선순위가 낮은(숫자가 높은) 상품 순으로 정렬됩니다. (3순위 -> 2순위 -> 1순위...)

- 총판매량순(SALE_CNT): 현재까지 해당 상품이 판매된 판매량 순서입니다.
  - ASC: 총 판매량 수가 낮은 상품 순으로 정렬됩니다. (1개 판매 -> 2개 판매 -> 3개 판매...)
  - DESC: 총 판매량 수가 높은 상품 순으로 정렬됩니다. (3개 판매 -> 2개 판매 -> 1개 판매...)
  - “결제완료” 시점에 상품 수량을 카운트(+)하며, “임금대기” 건은 카운트하지 않음.
  - 클레임 처리 시 환불 시점에 차감 (-)되며, 교환 처리 시, 교환 상품은 차감되고 교환추가상품은 카운트됨.

- 판매인기순(POPULAR): 판매가 및 인기도(1주일간 구매수량, 상품후기점수, 좋아요 수 등)에 점수를 부여하여 산출한 순서로 점수 산정 기준은 아래와 같습니다.
  - ASC: 인기점수가 낮은 상품 순으로 정렬됩니다. (100점 -> 200점 -> 300점...)
  - DESC: 인기점수가 높은 상품 순으로 정렬됩니다. (300점 -> 200점 -> 100점...)
  - 점수 기준
    - ```
      25 * 최근 1주일 구매횟수 * 가격별포인트 +
      10 * 최근 1주일 장바구니(cart) 추가 횟수 +
      10 * 최근 1주일 상품 좋아요(like) 클릭 횟수 +
      10 * 최근 1주일 위시리스트(찜하기) 추가 횟수 +
      5  * 최근 1주일 리뷰점수 평균
      ```
  - 가격별 포인트
    - ```
      0~1,000         1점
      1,000~5,000     2점
      5,000~10,000    3점
      10,000~30,000   4점
      30,000~50,000   5점
      50,000~70,000   6점
      70,000~         7점
      ```
- 판매일자(SALE_YMD), 판매종료일자(SALE_END_YMD): 판매시작/종료일 순으로 상품을 정렬합니다.
  - ASC: 판매시작/종료일자 과거순으로 상품이 정렬됩니다. (1월1일 -> 2월10일...)
  - DESC: 판매시작/종료일자 최신순으로 상품이 정렬됩니다. (2월10일 -> 1월1일...)
- 최근상품순(RECENT_PRODUCT): 상품 등록일 기준으로 상품을 정렬합니다.
  - ASC: 상품 등록일이 과거순으로 상품이 정렬됩니다. (1월1일 -> 2월10일...)
  - DESC: 상품 등록일이 최신순으로 상품이 정렬됩니다. (2월10일 -> 1월1일...)
- 유효일자(EXPIRATION_DATE): 상품 유효일자 기준으로 상품을 정렬합니다.
  - ASC: 현재 날짜 기준으로 유효일자가 과거순으로 정렬됩니다. (1월1일 -> 2월10일...)
  - DESC: 현재 날짜 기준으로 유효일자가 최신순으로 정렬됩니다. (2월10일 -> 1월1일...)
  - 유효일자 정렬의 경우, 유효일자가 설정된 상품이 우선으로 나옵니다. (유효일자 있는 상품 > 유효일자 없는 상품 + 유효일자 지난 상품 - 나머지 상품은 상품번호가 최신순으로 정렬)
  - 유효일자와 현재 날짜가 동일한 경우, 유효일자가 있는 상품으로 취급합니다.

상품항목추가정보 검색

- 하나의 항목에서 여러개의 다중 항목 값을 검색할 경우 (SPACE 구분으로 검색) (아래 예시 참고)
  - filter.customProperties.propNos : 100
  - filter.customProperties.propValueNos : 1 2 3
- 다중 항목에서 여러개의 다중 항목 값을 검색할 경우 (콤마(,) 구분으로 검색) (아래 예시 참고)
  - ※ 다중 항목으로 검색 시 콤마(,) 갯수를 맞춰줘야 합니다.
  - filter.customProperties.propNos : 100,101,102
  - filter.customProperties.propValueNos : 1 2 3,4 5 6,7 8 9
- 항목 값(propNos, propValueNos)은 GET /products/custom-properties API를 참조하면됩니다.
- filter.customProperties.propOperator : 상품항목 추가정보 조회 조건을 선택합니다.
  - AND: 항목값들을 모두 만족시키는 상품이 조회됩니다.
    - "propNo: 100, propValueNos: 1 2 3" 이 경우 propNo에 해당하는 propValueNos가 1 AND 2 AND 3으로 조회됩니다.
  - OR: 항목값 중 하나라도 만족되는 상품이 조회됩니다.
    - "propNo: 100, propValueNos: 1 2 3" 이 경우 propNo에 해당하는 propValueNos가 1 OR 2 OR 3으로 조회됩니다.

유효일자 검색

- 유효일자 검색 시, expirationDate에 "2023-10-31"로 검색하는 경우 아래와 같이 검색됩니다.
  - 현재시간을 "2023-10-21"이라고 할 때, "2023-10-21 ~ 2023-10-31"에 해당하는 유효일자를 검색합니다.
  - 양 끝 범위에 해당하는 일자는 포함해서 검색합니다.

상품평점 검색

- 입력된 리뷰 평점 범위의 상품들로 필터링되어 검색합니다.
- minReviewRating, maxReviewRating 중 한개만 입력시 이상 또는 이하의 범위로 필터링 합니다.
  - 예) minReviewRating = 3.0일 경우, 3.0 이상의 리뷰 평점 상품 검색
  - 예) maxReviewRating = 5.0일 경우, 5.0 이하의 리뷰 평점 상품 검색
- minReviewRating, maxReviewRating 모두 입력시 minReviewRating <= x <= maxReviewRating의 범위로 필터링 합니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## [상품 금액 적용]

### 기본 상품 판매가

- 옵션이 없는 상품
  - 상품 등록 시, 기입한 판매가 그대로 적용
- 옵션이 있는 상품
  - 상품 등록 시, 기입한 판매가 + 옵션가 적용
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) 인 경우\|\, 옵션1 구매가격은 10000원 옵션2 구매가격은 11000원
- 세트 상품
  - 세트 상품의 옵션에 구성된 옵션(옵션있는 상품들의 옵션으로 세트 옵션 구성)의 구매가격의 합
  - 세트 옵션 구성이 달라질 수 있기때문에 당연히 옵션마다 가격 상이 함

### 즉시 할인

- 옵션이 없는 상품
  - 판매가에 즉시할인이 적용된 가격
- 옵션있는 상품\, 세트 상품
  - 판매가에 즉시할인이 적용된 가격 + 옵션가 가 최종 가격
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\) 이고 즉시 할인율 10% 인 경우\,
    옵션별 가격은 판매가 \*0.8 + 옵션가 이므로 따라서
    옵션 1 의 판매가격은 9000원, 옵션 2의 판매가격은 10000원, 옵션3의 판매가격은 11000원

\* **옵션가격에서 즉시 할인이 적용 되는 것이 아님**

### 추가 할인

- 할인 적용 순서 : 즉시 할인 -> 추가 할인
- 즉시 할인 적용 된 판매가격에 추가 할인 적용
  - 예) 10000원 상품에 즉시 할인으로 1000원일 할인된다면, 9000원에서 추가 할인 설정에 따라 할인 적용

**즉시 할인**과의 차이점이라면 적용되는 가격인데 즉시 할인의 경우 상품을 등록 할 때에 입력한 판매가 적용하지만, **추가 할인**은 실제 해당 상품의 구매 가격에 적용 (상품등록 시에 판매가에 적용되는 것이 아닌 실제 구매 금액에 적용)

- 예) A상품(판매가15000원)

  \- 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\)

  \- 즉시 할인 : 5000원

  \- 추가 할인 : 10%

  옵션 1 구매가격 : ((15000-5000) + 0)\*0.9 = 9000

  옵션 2 구매가격 : ((15000-5000) + 1000)\*0.9 = 9900

  옵션 2 구매가격 : ((15000-5000) + 2000)\*0.9 = 10800

**파라미터**:

| 이름                                 | 위치   | 타입    | 필수 | 설명                                                                                                                                                                                                                                   |
| ------------------------------------ | ------ | ------- | ---- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| filter.discountedPrices              | query  | number  | ❌   | 판매가 - 즉시할인 - 추가상품할인이 적용된 "최종 할인가격", between검색일 경우 입력값 2개 필요(다수 정보는 항목 추가 필요                                                                                                               |
| filter.keywords                      | query  | string  | ❌   | 검색어(여러 검색어일 경우 space 로 구분 AND 연산)                                                                                                                                                                                      |
| filter.keywordInResult               | query  | string  | ❌   | 결과내 검색(결과 내 검색의 검색어 space 구분 AND 연산)                                                                                                                                                                                 |
| filter.discountedComparison          | query  | string  | ❌   | 최종 할인가격 검색 조건 (GT: 초과 - GREATER THAN, LTE: 미만 -LESS GREATER THAN, GTE: 이상 - GREATER THAN or EQUAL, EQ: 동등 - EQUAL, BETWEEN: 사이의                                                                                   |
| filter.deliveryConditionType         | query  | string  | ❌   | 배송비 타입 (FREE: 무료, CONDITIONAL: 조건부 무료, FIXED_FEE: 유료(고정 배송비))                                                                                                                                                       |
| filter.saleStatus                    | query  | string  | ❌   | 판매 상태 ( 전체 판매 상태 조회: ALL_CONDITIONS, 판매대기와 판매중 상품 조회: READY_ONSALE, 판매중 상품만 조회: ONSALE - default, 예약판매중인 상품과 판매중인 상품만 조회: RESERVATION_AND_ONSALE)                                    |
| filter.soldout                       | query  | boolean | ❌   | 품절 상품 포함 여부(default: false)                                                                                                                                                                                                    |
| filter.totalReviewCount              | query  | boolean | ❌   | 총 상품평 수 포함 여부(default: false, false 설정 시 무조건 0)                                                                                                                                                                         |
| filter.familyMalls                   | query  | boolean | ❌   | 서비스에 계약된 모든 쇼핑몰 조회 여부 (default: false)                                                                                                                                                                                 |
| filter.productManagementCd           | query  | string  | ❌   | 판매자관리코드 같은 상품 검색                                                                                                                                                                                                          |
| filter.excludeMallProductNo          | query  | integer | ❌   | 조회시 제외할 상품번호                                                                                                                                                                                                                 |
| filter.includeMallProductNo          | query  | integer | ❌   | 조회할 상품번호                                                                                                                                                                                                                        |
| filter.includeNonDisplayableCategory | query  | boolean | ❌   | 전시카테고리 포함 여부 - categoryNos 조건이 있을 때 하위 뎁스 중 하나라도 ‘전시 안 함’이면 결과에서 제외됩니다. (default: false)                                                                                                       |
| filter.customProperties.propNos      | query  | string  | ❌   | 조회할 상품항목추가정보 번호                                                                                                                                                                                                           |
| filter.customProperties.propValueNos | query  | string  | ❌   | 조회할 상품항목추가정보 값                                                                                                                                                                                                             |
| filter.customProperties.propOperator | query  | string  | ❌   | 상품항목추가정보 조회 조건 (AND : 모두 만족하는 상품만 조회, OR : 하나라도 포함되는 상품 조회)                                                                                                                                         |
| filter.stickerNos                    | query  | integer | ❌   | 조회할 스티커번호                                                                                                                                                                                                                      |
| filter.minReviewRating               | query  | integer | ❌   | 상품평 최소 범위 조회 조건                                                                                                                                                                                                             |
| filter.maxReviewRating               | query  | integer | ❌   | 상품평 최대 범위 조회 조건                                                                                                                                                                                                             |
| filter.includeStopProducts           | query  | boolean | ❌   | 판매중지 상품을 포함할지 여부를 선택할 수 있습니다.(default: false)                                                                                                                                                                    |
| order.by                             | query  | string  | ❌   | POPULAR:판매인기순 (DEFAULT), SALE_YMD:판매일자, SALE_END_YMD:판매종료일자, DISCOUNTED_PRICE:가격순, REVIEW:상품평, SALE_CNT:총판매량순, RECENT_PRODUCT:최근상품순, MD_RECOMMEND:MD추천순, LIKE_CNT: 좋아요, EXPIRATION_DATE: 유효일자 |
| order.direction                      | query  | string  | ❌   | 정렬기준(default : DESC)                                                                                                                                                                                                               |
| order.soldoutPlaceEnd                | query  | boolean | ❌   | 품절상품 뒤로 배치 여부(default = false)                                                                                                                                                                                               |
| categoryNos                          | query  | string  | ❌   | 전시 카테고리 번호(여러개 일 경우 항목 추가)                                                                                                                                                                                           |
| excludeCategoryNos                   | query  | string  | ❌   | 제외할 전시 카테고리 번호(여러개 일 경우 항목 추가, 번호에 속한 모든 하위 카테고리 제외)                                                                                                                                               |
| categoryOperator                     | query  | string  | ❌   | 전시카테고리 검색 조건 (AND : 모두다 포함, OR : 한개라도 포함), default: OR                                                                                                                                                            |
| brandNos                             | query  | string  | ❌   | 브랜드 번호(여러개 일 경우 항목 추가)                                                                                                                                                                                                  |
| partnerNo                            | query  | integer | ❌   | 파트너 번호(상품 공급업체 번호)                                                                                                                                                                                                        |
| clientKey                            | query  | integer | ❌   | 클라이언트 키                                                                                                                                                                                                                          |
| pageNumber                           | query  | integer | ❌   | 페이지 번호                                                                                                                                                                                                                            |
| pageSize                             | query  | integer | ❌   | 한 페이지당 노출 수 (최대 요청 가능: 500개)                                                                                                                                                                                            |
| onlySaleProduct                      | query  | boolean | ❌   | 세일 상품만 조회 여부(default: false)                                                                                                                                                                                                  |
| hasMaxCouponAmt                      | query  | boolean | ❌   | 목록에 최대 할인 쿠폰 가격 포함 여부(default: false)                                                                                                                                                                                   |
| hasTotalCount                        | query  | boolean | ❌   | 전체 상품 수 포함 여부(default: false)                                                                                                                                                                                                 |
| hasOptionValues                      | query  | boolean | ❌   | 목록에 옵션 value 포함 여부(default: false)                                                                                                                                                                                            |
| includeSummaryInfo                   | query  | boolean | ❌   | summary 정보 포함 여부(deprecated, 제공 안함)                                                                                                                                                                                          |
| shippingAreaType                     | query  | string  | ❌   | 배송 구분 (Enum: [ PARTNER: 파트너 배송, MALL: 쇼핑몰 배송 ])                                                                                                                                                                          |
| expirationDate                       | query  | string  | ❌   | 유효일자                                                                                                                                                                                                                               |
| groupManagementCode                  | query  | string  | ❌   | 상품 그룹관리코드                                                                                                                                                                                                                      |
| Version                              | header | string  | ✅   | API 버전                                                                                                                                                                                                                               |
| clientId                             | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                                                                                                                               |
| platform                             | header | string  | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시                                                                                                   |
| language                             | header | string  | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                                                                                                                                |
| accessToken                          | header | string  | ❌   | 회원 엑세스 토큰                                                                                                                                                                                                                       |
| Shop-By-Authorization                | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                                                                                                                               |

**응답**:

- **200**: 200

---

### POST /products/search-by-nos

**요약**: 상품번호 리스트로 상품 조회

**설명**:

## 부가설명 및 특이사항

상품번호 리스트로 상품을 조회하는 API입니다.

(hasOptionValues: 옵션값 포함여부, default: false)

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## [상품 금액 적용]

### 기본 상품 판매가

- 옵션이 없는 상품
  - 상품 등록 시, 기입한 판매가 그대로 적용
- 옵션이 있는 상품
  - 상품 등록 시, 기입한 판매가 + 옵션가 적용
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) 인 경우\|\, 옵션1 구매가격은 10000원 옵션2 구매가격은 11000원
- 세트 상품
  - 세트 상품의 옵션에 구성된 옵션(옵션있는 상품들의 옵션으로 세트 옵션 구성)의 구매가격의 합
  - 세트 옵션 구성이 달라질 수 있기때문에 당연히 옵션마다 가격 상이 함

### 즉시 할인

- 옵션이 없는 상품
  - 판매가에 즉시할인이 적용된 가격
- 옵션있는 상품\, 세트 상품
  - 판매가에 즉시할인이 적용된 가격 + 옵션가 가 최종 가격
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\) 이고 즉시 할인율 10% 인 경우\,
    옵션별 가격은 판매가 \*0.8 + 옵션가 이므로 따라서
    옵션 1 의 판매가격은 9000원, 옵션 2의 판매가격은 10000원, 옵션3의 판매가격은 11000원

\* **옵션가격에서 즉시 할인이 적용 되는 것이 아님**

### 추가 할인

- 할인 적용 순서 : 즉시 할인 -> 추가 할인
- 즉시 할인 적용 된 판매가격에 추가 할인 적용
  - 예) 10000원 상품에 즉시 할인으로 1000원일 할인된다면, 9000원에서 추가 할인 설정에 따라 할인 적용

**즉시 할인**과의 차이점이라면 적용되는 가격인데 즉시 할인의 경우 상품을 등록 할 때에 입력한 판매가 적용하지만, **추가 할인**은 실제 해당 상품의 구매 가격에 적용 (상품등록 시에 판매가에 적용되는 것이 아닌 실제 구매 금액에 적용)

- 예) A상품(판매가15000원)

  \- 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\)

  \- 즉시 할인 : 5000원

  \- 추가 할인 : 10%

  옵션 1 구매가격 : ((15000-5000) + 0)\*0.9 = 9000

  옵션 2 구매가격 : ((15000-5000) + 1000)\*0.9 = 9900

  옵션 2 구매가격 : ((15000-5000) + 2000)\*0.9 = 10800

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/shipping-info

**요약**: 상품번호를 통한 배송 정보 및 배송 불가 국가 조회 API

**설명**:

## 부가설명 및 특이사항

상품번호를 통해 배송 정보 및 배송 불가 국가를 조회하는 API 입니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNos            | query  | string | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/{productNo}

**요약**: 상품 상세 조회하기

**설명**:

## 부가설명 및 특이사항

해당 상품 번호에 대한 상세, 이미지, 옵션 정보를 조회하는 API입니다

## 화면 예시

[![product-detail-img-1](http://image.toast.com/aaaaahb/api-description/product/%EC%83%81%ED%92%88/[GET]%20product_productNo%20%EC%83%81%ED%92%88%20%EC%83%81%EC%84%B8%201-3.png?autox150)](http://image.toast.com/aaaaahb/api-description/product/%EC%83%81%ED%92%88/[GET]%20product_productNo%20%EC%83%81%ED%92%88%20%EC%83%81%EC%84%B8%201-3.png)

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## [상품 금액 적용]

### 기본 상품 판매가

- 옵션이 없는 상품
  - 상품 등록 시, 기입한 판매가 그대로 적용
- 옵션이 있는 상품
  - 상품 등록 시, 기입한 판매가 + 옵션가 적용
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) 인 경우\|\, 옵션1 구매가격은 10000원 옵션2 구매가격은 11000원
- 세트 상품
  - 세트 상품의 옵션에 구성된 옵션(옵션있는 상품들의 옵션으로 세트 옵션 구성)의 구매가격의 합
  - 세트 옵션 구성이 달라질 수 있기때문에 당연히 옵션마다 가격 상이 함

### 즉시 할인

- 옵션이 없는 상품
  - 판매가에 즉시할인이 적용된 가격
- 옵션있는 상품\, 세트 상품
  - 판매가에 즉시할인이 적용된 가격 + 옵션가 가 최종 가격
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\) 이고 즉시 할인율 10% 인 경우\,
    옵션별 가격은 판매가 \*0.8 + 옵션가 이므로 따라서
    옵션 1 의 판매가격은 9000원, 옵션 2의 판매가격은 10000원, 옵션3의 판매가격은 11000원

\* **옵션가격에서 즉시 할인이 적용 되는 것이 아님**

### 추가 할인

- 할인 적용 순서 : 즉시 할인 -> 추가 할인
- 즉시 할인 적용 된 판매가격에 추가 할인 적용
  - 예) 10000원 상품에 즉시 할인으로 1000원일 할인된다면, 9000원에서 추가 할인 설정에 따라 할인 적용

**즉시 할인**과의 차이점이라면 적용되는 가격인데 즉시 할인의 경우 상품을 등록 할 때에 입력한 판매가 적용하지만, **추가 할인**은 실제 해당 상품의 구매 가격에 적용 (상품등록 시에 판매가에 적용되는 것이 아닌 실제 구매 금액에 적용)

- 예) A상품(판매가15000원)

  \- 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\)

  \- 즉시 할인 : 5000원

  \- 추가 할인 : 10%

  옵션 1 구매가격 : ((15000-5000) + 0)\*0.9 = 9000

  옵션 2 구매가격 : ((15000-5000) + 1000)\*0.9 = 9900

  옵션 2 구매가격 : ((15000-5000) + 2000)\*0.9 = 10800

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo             | path   | string | ✅   | 상품번호                                                                                                                             |
| channelType           | query  | string | ❌   | 인입 채널 유형(NAVER_EP, DANAWA, ENURI, WONDER, COOCHA, FACEBOOK 또는 사용자 설정)                                                   |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/best-review/search

**요약**: 베스트 리뷰 상품 검색(search engine)하기

**설명**:

## 부가설명 및 특이사항

베스트 리뷰 상품 검색하는 API입니다.

전일 ~ 7일 전까지의 평점과 전체기간 평점을 합산한 최종 점수로 정렬된 상품을 조회합니다.

동일한 점수의 경우 베스트 리뷰 점수 -> 총 리뷰 개수 -> 최근 등록 순으로 정렬합니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## 화면 예시

[![best-review-product-search-img-1](<http://image.toast.com/aaaaahb/api-description/product/%EC%83%81%ED%92%88/[GET]%20product_best-seller_search%20%EB%B2%A0%EC%8A%A4%ED%8A%B8%20%EC%85%80%EB%9F%AC%20%EC%83%81%ED%92%88%20%EA%B2%80%EC%83%89(search%20engine).png?autox150>)](<http://image.toast.com/aaaaahb/api-description/product/%EC%83%81%ED%92%88/[GET]%20product_best-seller_search%20%EB%B2%A0%EC%8A%A4%ED%8A%B8%20%EC%85%80%EB%9F%AC%20%EC%83%81%ED%92%88%20%EA%B2%80%EC%83%89(search%20engine).png>)

## [상품 금액 적용]

### 기본 상품 판매가

- 옵션이 없는 상품
  - 상품 등록 시, 기입한 판매가 그대로 적용
- 옵션이 있는 상품
  - 상품 등록 시, 기입한 판매가 + 옵션가 적용
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) 인 경우\|\, 옵션1 구매가격은 10000원 옵션2 구매가격은 11000원
- 세트 상품
  - 세트 상품의 옵션에 구성된 옵션(옵션있는 상품들의 옵션으로 세트 옵션 구성)의 구매가격의 합
  - 세트 옵션 구성이 달라질 수 있기때문에 당연히 옵션마다 가격 상이 함

### 즉시 할인

- 옵션이 없는 상품
  - 판매가에 즉시할인이 적용된 가격
- 옵션있는 상품\, 세트 상품
  - 판매가에 즉시할인이 적용된 가격 + 옵션가 가 최종 가격
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\) 이고 즉시 할인율 10% 인 경우\,
    옵션별 가격은 판매가 \*0.8 + 옵션가 이므로 따라서
    옵션 1 의 판매가격은 9000원, 옵션 2의 판매가격은 10000원, 옵션3의 판매가격은 11000원

\* **옵션가격에서 즉시 할인이 적용 되는 것이 아님**

### 추가 할인

- 할인 적용 순서 : 즉시 할인 -> 추가 할인
- 즉시 할인 적용 된 판매가격에 추가 할인 적용
  - 예) 10000원 상품에 즉시 할인으로 1000원일 할인된다면, 9000원에서 추가 할인 설정에 따라 할인 적용

**즉시 할인**과의 차이점이라면 적용되는 가격인데 즉시 할인의 경우 상품을 등록 할 때에 입력한 판매가 적용하지만, **추가 할인**은 실제 해당 상품의 구매 가격에 적용 (상품등록 시에 판매가에 적용되는 것이 아닌 실제 구매 금액에 적용)

- 예) A상품(판매가15000원)

  \- 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\)

  \- 즉시 할인 : 5000원

  \- 추가 할인 : 10%

  옵션 1 구매가격 : ((15000-5000) + 0)\*0.9 = 9000

  옵션 2 구매가격 : ((15000-5000) + 1000)\*0.9 = 9900

  옵션 2 구매가격 : ((15000-5000) + 2000)\*0.9 = 10800

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| filter.familyMalls    | query  | boolean | ❌   | 서비스에 계약된 모든 쇼핑몰 조회 여부 (default: false)                                                                               |
| categoryNos           | query  | integer | ❌   | 카테고리 번호(여러개 일 경우 항목 추가)                                                                                              |
| clientKey             | query  | integer | ❌   | 클라이언트 키                                                                                                                        |
| pageNumber            | query  | integer | ❌   | 페이지 번호                                                                                                                          |
| pageSize              | query  | integer | ❌   | 한 페이지당 노출 수                                                                                                                  |
| hasTotalCount         | query  | boolean | ❌   | 전체 상품 수 포함 여부(default: false)                                                                                               |
| hasOptionValues       | query  | boolean | ❌   | 목록에 옵션 value 포함 여부(default: false)                                                                                          |
| Version               | header | string  | ✅   | API 버전                                                                                                                             |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string  | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string  | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/best-seller/search

**요약**: 베스트 셀러 상품 검색(search engine)하기

**설명**:

## 부가설명 및 특이사항

베스트 셀러 상품 검색하는 API입니다

1주일전 ~ 현재까지의 판매수로 정렬된 상품을 조회합니다

예시: 2023-07-25 13:00:00 기준, 2023-07-18 13:00:00 ~ 2023-07-25 13:00:00 사이에 판매된 수를 기준으로 조회합니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## 화면 예시

[![best-seller-product-search-img-1](<http://image.toast.com/aaaaahb/api-description/product/%EC%83%81%ED%92%88/[GET]%20product_best-seller_search%20%EB%B2%A0%EC%8A%A4%ED%8A%B8%20%EC%85%80%EB%9F%AC%20%EC%83%81%ED%92%88%20%EA%B2%80%EC%83%89(search%20engine).png?autox150>)](<http://image.toast.com/aaaaahb/api-description/product/%EC%83%81%ED%92%88/[GET]%20product_best-seller_search%20%EB%B2%A0%EC%8A%A4%ED%8A%B8%20%EC%85%80%EB%9F%AC%20%EC%83%81%ED%92%88%20%EA%B2%80%EC%83%89(search%20engine).png>)

## [상품 금액 적용]

### 기본 상품 판매가

- 옵션이 없는 상품
  - 상품 등록 시, 기입한 판매가 그대로 적용
- 옵션이 있는 상품
  - 상품 등록 시, 기입한 판매가 + 옵션가 적용
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) 인 경우\|\, 옵션1 구매가격은 10000원 옵션2 구매가격은 11000원
- 세트 상품
  - 세트 상품의 옵션에 구성된 옵션(옵션있는 상품들의 옵션으로 세트 옵션 구성)의 구매가격의 합
  - 세트 옵션 구성이 달라질 수 있기때문에 당연히 옵션마다 가격 상이 함

### 즉시 할인

- 옵션이 없는 상품
  - 판매가에 즉시할인이 적용된 가격
- 옵션있는 상품\, 세트 상품
  - 판매가에 즉시할인이 적용된 가격 + 옵션가 가 최종 가격
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\) 이고 즉시 할인율 10% 인 경우\,
    옵션별 가격은 판매가 \*0.8 + 옵션가 이므로 따라서
    옵션 1 의 판매가격은 9000원, 옵션 2의 판매가격은 10000원, 옵션3의 판매가격은 11000원

\* **옵션가격에서 즉시 할인이 적용 되는 것이 아님**

### 추가 할인

- 할인 적용 순서 : 즉시 할인 -> 추가 할인
- 즉시 할인 적용 된 판매가격에 추가 할인 적용
  - 예) 10000원 상품에 즉시 할인으로 1000원일 할인된다면, 9000원에서 추가 할인 설정에 따라 할인 적용

**즉시 할인**과의 차이점이라면 적용되는 가격인데 즉시 할인의 경우 상품을 등록 할 때에 입력한 판매가 적용하지만, **추가 할인**은 실제 해당 상품의 구매 가격에 적용 (상품등록 시에 판매가에 적용되는 것이 아닌 실제 구매 금액에 적용)

- 예) A상품(판매가15000원)

  \- 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\)

  \- 즉시 할인 : 5000원

  \- 추가 할인 : 10%

  옵션 1 구매가격 : ((15000-5000) + 0)\*0.9 = 9000

  옵션 2 구매가격 : ((15000-5000) + 1000)\*0.9 = 9900

  옵션 2 구매가격 : ((15000-5000) + 2000)\*0.9 = 10800

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| filter.familyMalls    | query  | boolean | ❌   | 서비스에 계약된 모든 쇼핑몰 조회 여부 (default: false)                                                                               |
| categoryNos           | query  | integer | ❌   | 카테고리 번호(여러개 일 경우 항목 추가)                                                                                              |
| clientKey             | query  | integer | ❌   | 클라이언트 키                                                                                                                        |
| pageNumber            | query  | integer | ❌   | 페이지 번호                                                                                                                          |
| pageSize              | query  | integer | ❌   | 한 페이지당 노출 수                                                                                                                  |
| hasTotalCount         | query  | boolean | ❌   | 전체 상품 수 포함 여부(default: false)                                                                                               |
| hasOptionValues       | query  | boolean | ❌   | 목록에 옵션 value 포함 여부(default: false)                                                                                          |
| Version               | header | string  | ✅   | API 버전                                                                                                                             |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string  | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string  | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string  | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/regular-delivery/search

**요약**: 상품 번호 리스트로 정기 결제 상품 조회하기

**설명**:

## 부가설명 및 특이사항

상품번호 리스트로 정기 결제 상품 조회 API 입니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNos            | query  | number | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/search/keywords

**요약**: 상품 번호 리스트로 검색어 조회

**설명**:

## 부가설명 및 특이사항

상품번호를 통해 어드민에 등록된 검색어를 조회하는 API 입니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNos            | query  | number | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/search/summary

**요약**: 상품 검색 결과 Summary 정보 조회(search engine)하기

**설명**:

## 부가설명 및 특이사항

상품 검색 결과의 Summary 정보만 응답하는 API입니다

- 상품 검색 결과의 Summary 정보를 제공합니다. (displayCategories, brands 등)

- 아래 Parameters에 해당하는 검색조건들의 경우, 매 10분 마다 캐시가 됩니다 ( ex. 10시 10분, 10시 20분, 10시 30분...)

- ex. 10시 13분에 상품명을 [테스트 상품 -> 임시 상품]으로 변경 후 '임시 상품'으로 검색 시, 10시 19분까지 검색되지않고, 10시 20분이후에 검색 가능합니다.

- 항목 값(propNos, propValueNos)은 GET /products/custom-properties API를 참조하면됩니다.

- filter.customProperties.propOperator : 상품항목 추가정보 조회 조건을 선택합니다.
  - AND: 항목값들을 모두 만족시키는 상품이 조회됩니다.
    - "propNo: 100, propValueNos: 1 2 3" 이 경우 propNo에 해당하는 propValueNos가 1 AND 2 AND 3으로 조회됩니다.
  - OR: 항목값 중 하나라도 만족되는 상품이 조회됩니다.
    - "propNo: 100, propValueNos: 1 2 3" 이 경우 propNo에 해당하는 propValueNos가 1 OR 2 OR 3으로 조회됩니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                                 | 위치   | 타입    | 필수 | 설명                                                                                                                                                                                                |
| ------------------------------------ | ------ | ------- | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| filter.discountedPrices              | query  | number  | ❌   | 판매가 - 즉시할인 - 추가상품할인이 적용된 "최종 할인가격", between검색일 경우 입력값 2개 필요(다수 정보는 항목 추가 필요                                                                            |
| filter.keywords                      | query  | string  | ❌   | 검색어(여러 검색어일 경우 space 로 구분 AND 연산)                                                                                                                                                   |
| filter.keywordInResult               | query  | string  | ❌   | 결과내 검색(결과 내 검색의 검색어 space 구분 AND 연산)                                                                                                                                              |
| filter.discountedComparison          | query  | string  | ❌   | 최종 할인가격 검색 조건 (GT: 초과 - GREATER THAN, LTE: 미만 -LESS GREATER THAN, GTE: 이상 - GREATER THAN or EQUAL, EQ: 동등 - EQUAL, BETWEEN: 사이의                                                |
| filter.deliveryConditionType         | query  | string  | ❌   | 배송비 타입 (FREE: 무료, CONDITIONAL: 조건부 무료, FIXED_FEE: 유료(고정 배송비))                                                                                                                    |
| filter.saleStatus                    | query  | string  | ❌   | 판매 상태 ( 전체 판매 상태 조회: ALL_CONDITIONS, 판매대기와 판매중 상품 조회: READY_ONSALE, 판매중 상품만 조회: ONSALE - default, 예약판매중인 상품과 판매중인 상품만 조회: RESERVATION_AND_ONSALE) |
| filter.soldout                       | query  | boolean | ❌   | 품절 상품 포함 여부(default: false)                                                                                                                                                                 |
| filter.totalReviewCount              | query  | boolean | ❌   | 총 상품평 수 포함 여부(default: false, false 설정 시 무조건 0)                                                                                                                                      |
| filter.familyMalls                   | query  | boolean | ❌   | 서비스에 계약된 모든 쇼핑몰 조회 여부 (default: false)                                                                                                                                              |
| filter.productManagementCd           | query  | string  | ❌   | 판매자관리코드 같은 상품 검색                                                                                                                                                                       |
| filter.excludeMallProductNo          | query  | integer | ❌   | 조회시 제외할 상품번호                                                                                                                                                                              |
| filter.includeMallProductNo          | query  | integer | ❌   | 조회할 상품번호                                                                                                                                                                                     |
| filter.includeNonDisplayableCategory | query  | boolean | ❌   | 전시카테고리 포함 여부 - categoryNos 조건이 있을 때 하위 뎁스 중 하나라도 ‘전시 안 함’이면 결과에서 제외됩니다. (default: false)                                                                    |
| filter.customProperties.propNos      | query  | string  | ❌   | 조회할 상품추가항목 번호                                                                                                                                                                            |
| filter.customProperties.propValueNos | query  | string  | ❌   | 조회할 상품추가항목 값                                                                                                                                                                              |
| filter.customProperties.propOperator | query  | string  | ❌   | 상품항목추가정보 조회 조건 (AND : 모두 만족하는 상품만 조회, OR : 하나라도 포함되는 상품 조회)                                                                                                      |
| filter.stickerNos                    | query  | integer | ❌   | 조회할 스티커번호                                                                                                                                                                                   |
| filter.minReviewRating               | query  | integer | ❌   | 상품평 최소 범위 조회 조건                                                                                                                                                                          |
| filter.maxReviewRating               | query  | integer | ❌   | 상품평 최대 범위 조회 조건                                                                                                                                                                          |
| categoryNos                          | query  | string  | ❌   | 전시 카테고리 번호(여러개 일 경우 항목 추가)                                                                                                                                                        |
| excludeCategoryNos                   | query  | string  | ❌   | 제외할 전시 카테고리 번호(여러개 일 경우 항목 추가, 번호에 속한 모든 하위 카테고리 제외)                                                                                                            |
| categoryOperator                     | query  | string  | ❌   | 전시카테고리 검색 조건 (AND : 모두다 포함, OR : 한개라도 포함), default: OR                                                                                                                         |
| brandNos                             | query  | string  | ❌   | 브랜드 번호(여러개 일 경우 항목 추가)                                                                                                                                                               |
| partnerNo                            | query  | integer | ❌   | 파트너 번호(상품 공급업체 번호)                                                                                                                                                                     |
| onlySaleProduct                      | query  | boolean | ❌   | 세일 상품만 조회 여부(default: false)                                                                                                                                                               |
| shippingAreaType                     | query  | string  | ❌   | 배송 구분 (Enum: [ PARTNER: 파트너 배송, MALL: 쇼핑몰 배송 ])                                                                                                                                       |
| Version                              | header | string  | ✅   | API 버전                                                                                                                                                                                            |
| clientId                             | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                                                                                            |
| platform                             | header | string  | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시                                                                |
| language                             | header | string  | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                                                                                             |
| accessToken                          | header | string  | ❌   | 회원 엑세스 토큰                                                                                                                                                                                    |
| Shop-By-Authorization                | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                                                                                            |

**응답**:

- **200**: 200

---

### GET /products/{productNo}/display-categories

**요약**: 상품번호에 해당하는 모든 전시카테고리 조회하기

**설명**:

## 부가설명 및 특이사항

상품번호에 해당하는 모든 전시카테고리 조회하기 API입니다

마지막 뎁스 번호는 depth5No, 전체 전시카테고리 경로는 fullCategoryName 으로 확인할 수 있습니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo             | path   | string | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/{productNo}/extra-products

**요약**: 추가상품 조회하기

**설명**:

## 부가설명 및 특이사항

상품 번호에 대한 추가상품을 조회하는 API입니다

2가지 옵션 목록(계층, 원본)을 제공합니다

필수/선택 옵션인 경우 multiOptions(분리형 옵션)노출방식이 변경됩니다.

- multiOptions[].optionValue(옵션값)는 빈값으로 노출됩니다.

- 필수옵션 및 선택옵션의 옵션 값들은 multiOptions.children[]의 1depth로만 노출됩니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo             | path   | string | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/{productNo}/purchasable

**요약**: 상품번호로 상품우선구매권한 조회

**설명**:

## 부가설명 및 특이사항

상품에 매핑된 상품우선구매권한 정보를 조회하는 API 입니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo             | path   | string | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰 - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                           |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙) - (accessToken 또는 Shop-By-Authorization 중 하나는 필수)                                                   |

**응답**:

- **200**: 200

---

### GET /products/{productNo}/related-products

**요약**: 관련 상품 정보 조회하기

**설명**:

## 부가설명 및 특이사항

관련 상품 정보를 조회하는 API입니다

관련 상품은 설정된 기준에 따라 최대 500개까지 조회할 수 있습니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## [상품 금액 적용]

### 기본 상품 판매가

- 옵션이 없는 상품
  - 상품 등록 시, 기입한 판매가 그대로 적용
- 옵션이 있는 상품
  - 상품 등록 시, 기입한 판매가 + 옵션가 적용
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) 인 경우\|\, 옵션1 구매가격은 10000원 옵션2 구매가격은 11000원
- 세트 상품
  - 세트 상품의 옵션에 구성된 옵션(옵션있는 상품들의 옵션으로 세트 옵션 구성)의 구매가격의 합
  - 세트 옵션 구성이 달라질 수 있기때문에 당연히 옵션마다 가격 상이 함

### 즉시 할인

- 옵션이 없는 상품
  - 판매가에 즉시할인이 적용된 가격
- 옵션있는 상품\, 세트 상품
  - 판매가에 즉시할인이 적용된 가격 + 옵션가 가 최종 가격
  - 예\) A상품\(판매가10000원\)에 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\) 이고 즉시 할인율 10% 인 경우\,
    옵션별 가격은 판매가 \*0.8 + 옵션가 이므로 따라서
    옵션 1 의 판매가격은 9000원, 옵션 2의 판매가격은 10000원, 옵션3의 판매가격은 11000원

\* **옵션가격에서 즉시 할인이 적용 되는 것이 아님**

### 추가 할인

- 할인 적용 순서 : 즉시 할인 -> 추가 할인
- 즉시 할인 적용 된 판매가격에 추가 할인 적용
  - 예) 10000원 상품에 즉시 할인으로 1000원일 할인된다면, 9000원에서 추가 할인 설정에 따라 할인 적용

**즉시 할인**과의 차이점이라면 적용되는 가격인데 즉시 할인의 경우 상품을 등록 할 때에 입력한 판매가 적용하지만, **추가 할인**은 실제 해당 상품의 구매 가격에 적용 (상품등록 시에 판매가에 적용되는 것이 아닌 실제 구매 금액에 적용)

- 예) A상품(판매가15000원)

  \- 옵션 1\(\+0원\) \| 옵션2\(\+1000원\) \| 옵션3\(\+2000원\)

  \- 즉시 할인 : 5000원

  \- 추가 할인 : 10%

  옵션 1 구매가격 : ((15000-5000) + 0)\*0.9 = 9000

  옵션 2 구매가격 : ((15000-5000) + 1000)\*0.9 = 9900

  옵션 2 구매가격 : ((15000-5000) + 2000)\*0.9 = 10800

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo             | path   | string | ✅   | 상품번호                                                                                                                             |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/{productNo}/standard-category

**요약**: 상품번호에 해당하는 표준카테고리 조회하기

**설명**:

## 부가설명 및 특이사항

상품번호에 해당하는 표준 카테고리를 조회하는 API입니다

마지막 뎁스 번호는 depth4No, 전체 표준 카테고리 경로는 fullCategoryName 으로 확인할 수 있습니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo             | path   | string | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/{productNo}/url-shortening

**요약**: 상품 번호와 쇼핑몰 번호에 해당하는 단축URL 조회하기

**설명**:

## 부가설명 및 특이사항

상품번호와 쇼핑몰 번호에 해당하는 단축URL 조회하는 API입니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                     |
| --------- | ------ | ------ | ---- | ------------------------ |
| productNo | path   | string | ✅   | 상품번호                 |
| clientId  | header | string | ✅   | 쇼핑몰 클라이언트 아이디 |

**응답**:

- **200**: 200

---

## Custom Property

### GET /products/custom-properties

**요약**: 상품 항목 조회하기

**설명**:

## 부가설명 및 특이사항

상품 항목을 조회하는 API입니다

사용여부 = Y 인 상품 항목만 조횝니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| -------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Version  | header | string | ✅   | API 버전                                                                                                                             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

## Product Option

### GET /products/options

**요약**: 옵션 목록 조회하기

**설명**:

## 부가설명 및 특이사항

옵션 목록을 조회하는 API입니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNos            | query  | number | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/{productNo}/options

**요약**: 옵션 조회하기

**설명**:

## 부가설명 및 특이사항

해당 상품 번호에 대한 옵션 정보를 조회하는 API입니다

2가지 옵션 목록(계층, 원본)을 제공합니다

필수/선택 옵션인 경우 multiLevelOptions(분리형 옵션)노출방식이 변경됩니다.

- multiLevelOptions[].value(옵션값)는 빈값으로 노출됩니다.

- 필수옵션 및 선택옵션의 옵션 값들은 multiLevelOptions.children[]의 1depth로만 노출됩니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo             | path   | string | ✅   | 상품 번호                                                                                                                            |
| Version               | header | string | ✅   | API 버전                                                                                                                             |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform              | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language              | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |
| accessToken           | header | string | ❌   | 회원 엑세스 토큰                                                                                                                     |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)                                                                                                             |

**응답**:

- **200**: 200

---

### GET /products/{productNo}/options/images

**요약**: 상품에 해당하는 옵션 이미지 목록 조회하기

**설명**:

## 부가설명 및 특이사항

상품에 해당하는 옵션 이미지 목록 조회하는 API입니다

옵션 상세 보기 시, 사용합니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo | path   | string | ✅   | 상품 번호                                                                                                                            |
| Version   | header | string | ✅   | API 버전                                                                                                                             |
| clientId  | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform  | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language  | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

### GET /products/{productNo}/options/{optionNo}/images

**요약**: 옵션의 이미지 정보 조회하기

**설명**:

## 부가설명 및 특이사항

옵션의 이미지 목록을 조회하는 API입니다

옵션 상세 보기 시, 사용합니다

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| --------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| productNo | path   | string | ✅   | 상품 번호                                                                                                                            |
| optionNo  | path   | string | ✅   | 옵션 번호                                                                                                                            |
| Version   | header | string | ✅   | API 버전                                                                                                                             |
| clientId  | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform  | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language  | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---

## Configuration

### GET /products/configuration/naver-shopping

**요약**: 네이버 쇼핑 설정정보 조회

**설명**:

## 부가설명 및 특이사항

쇼핑몰에서 설정한 네이버 쇼핑 설정 정보를 조회할 수 있습니다.

### OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                                                                                                                 |
| -------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Version  | header | string | ✅   | API 버전                                                                                                                             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                             |
| platform | header | string | ✅   | PC - PC 웹 브라우저에서 접근 시, MOBILE_WEB - 모바일 웹 브라우저에서 접근 시, AOS - Android 앱에서 접근 시, IOS - iOS 앱에서 접근 시 |
| language | header | string | ❌   | 언어 (기본값: ko, 지원: en - 영어, jp - 일본어, zh - 중국어) (nullable)                                                              |

**응답**:

- **200**: 200

---
