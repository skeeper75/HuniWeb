# product-server

**버전**: 0.0.1-SNAPSHOT
**서버**: https://server-api.e-ncp.com

상품(product)관련 server API입니다.

---

## Brand

### GET /brands

**요약**: 브랜드 전체 조회하기

**설명**:

## 부가설명 및 특이사항

브랜드 전체 조회하는 API입니다

아래의 응답값 필드들은 Deprecated 되었으며, 더 이상 사용되지 않습니다.

- brandNo, mainImageContents, detailContents

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### POST /brands

**요약**: 브랜드 생성하기

**설명**:

## 부가설명 및 특이사항

브랜드를 생성하는 API 입니다.

한 번에 최대 500개까지 생성할 수 있습니다.

브랜드명 타입(`NAME_KO`, `NAME_EN`)에 따라 한글 또는 영문 브랜드명이 표시됩니다.

- 동일한 타입에 대해 동일한 브랜드명이 있는 경우, 브랜드 생성이 되지 않고 기존 브랜드가 응답에 포함됩니다.

- 예시: `NAME_KO` 타입의 `나이키`라는 한글 브랜드명이 기존에 존재할 때, 동일하게 `NAME_KO` 타입의 한글 브랜드명 `나이키`를 요청한 경우

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /brands

**요약**: 브랜드 수정하기

**설명**:

## 부가설명 및 특이사항

브랜드를 수정하는 API 입니다.

한 번에 최대 500개까지 수정할 수 있습니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### DELETE /brands

**요약**: 브랜드 삭제하기

**설명**:

## 부가설명 및 특이사항

브랜드를 삭제하는 API 입니다.

한 번에 최대 500개까지 삭제할 수 있습니다.

**파라미터**:

| 이름            | 위치   | 타입   | 필수 | 설명                                               |
| --------------- | ------ | ------ | ---- | -------------------------------------------------- |
| displayBrandNos | query  | number | ✅   | 삭제할 전시브랜드번호 ','로 다수건 삭제 (1,122,31) |
| systemKey       | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### GET /brands/

**요약**: 브랜드 전체 조회하기(트리 구조) version 2.0

**설명**:

## 부가설명 및 특이사항

브랜드 전체 조회(트리 구조)하는 API입니다

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명     |
| --------- | ------ | ------ | ---- | -------- |
| version   | header | string | ✅   | API 버전 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |

**응답**:

- **200**: 200

---

### POST /brands/

**요약**: 브랜드 생성하기 version 2.0

**설명**:

## 부가설명 및 특이사항

브랜드를 생성하는 API 입니다.

한 번에 최대 500개까지 생성할 수 있습니다.

동일한 브랜드명이 기존에 저장되었더라도 새롭게 요청이 들어오면 신규 브랜드가 생성됩니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명     |
| --------- | ------ | ------ | ---- | -------- |
| version   | header | string | ✅   | API 버전 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |

**응답**:

- **204**: 204

---

### GET /brands/{displayBrandNo}

**요약**: 브랜드 상세 조회하기

**설명**:

## 부가설명 및 특이사항

브랜드 상세 조회하는 API입니다

- 조회하고자하는 브랜드의 depth 순서와는 무관하게 조회 가능합니다.

**파라미터**:

| 이름           | 위치   | 타입   | 필수 | 설명            |
| -------------- | ------ | ------ | ---- | --------------- |
| displayBrandNo | path   | string | ✅   | 전시브랜드 번호 |
| systemKey      | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

## Custom Property

### GET /custom-properties

**요약**: 상품 추가항목 전체 조회하기

**설명**:

## 부가설명 및 특이사항

전체 상품 추가항목을 조회하는 API입니다

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

## Duty Category

### GET /duty-categories

**요약**: 상품 정보 고시 항목 조회하기

**설명**:

## 부가설명 및 특이사항

상품 정보 고시 항목 조회하는 API입니다

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

## Profile

### GET /like-products

**요약**: 회원이 좋아하는 상품목록 조회하기

**설명**:

## 부가설명 및 특이사항

회원이 좋아한 상품을 조회하는 API입니다

memberId와 memberNo 둘 중 하나 필수 값이며 memberId가 우선 적용되어 조회됩니다.

**파라미터**:

| 이름            | 위치   | 타입    | 필수 | 설명                                       |
| --------------- | ------ | ------- | ---- | ------------------------------------------ |
| mallNo          | query  | number  | ✅   | 몰 번호                                    |
| memberId        | query  | string  | ✅   | 회원 id                                    |
| memberNo        | query  | number  | ✅   | 회원 번호                                  |
| platform        | query  | string  | ✅   | 플랫폼 타입(PC, MOBILE_WEB, MOBILE)        |
| hasTotalCount   | query  | boolean | ✅   | 전체 상품 수 포함 여부(default: false)     |
| hasMaxCouponAmt | query  | boolean | ✅   | 최대쿠폰 할인가격 포함여부(default: false) |
| pageNumber      | query  | number  | ✅   | 페이지 번호                                |
| pageSize        | query  | number  | ✅   | 한 페이지당 노출 수                        |
| systemKey       | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

## Product

### GET /products

**요약**: 판매자 관리코드로 상품 조회하기

**설명**:

## 부가설명 및 특이사항

판매자 관리코드로 상품 조회하는 API입니다

- partnerNo 파라미터는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.

- partnerNo를 요청 파라미터에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.

- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

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

| 이름                | 위치   | 타입   | 필수 | 설명                     |
| ------------------- | ------ | ------ | ---- | ------------------------ |
| productManagementCd | query  | string | ✅   | 상품 관리 코드           |
| partnerNo           | query  | number | ❌   | 파트너 번호(설명란 참조) |
| systemKey           | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### POST /products

**요약**: 상품(옵션포함) 등록하기 - DEPRECATED. 2.0을 사용하세요

**설명**:

## 부가설명 및 특이사항

상품 단건, 옵션 복수건 등록

- 기본 템플릿 사용을 원할 경우, 템플릿 타입 type 값만 입력하여 호출
- 기본 템플릿 사용을 원하지 않는 경우, 템플릿 타입 type 값과 안내 내용은 content에 넣어 전달
- 단, 표준 카테고리가 "주류"인 경우 주류 기본 템플릿(=주류 통신판매 위임고시)이 필수이므로 content 가 null 인 경우 주류 기본 템플릿 저장
- 템플릿 타입 값의 경우, DELIVERY:배송, AFTER_SERVICE:A/S, REFUND:환불, EXCHANGE:교환, DELEGATION_BY_LIQUOR:주류

## 플랜별 상품 등록 제한

- basic : 50 건
- pro : 30,000 건
- enterprise : 무제한

## 판매방식, 판매수수료 Valid Flow

| SaleMethodType | commissionRateType | possible | description                        |
| -------------- | ------------------ | -------- | ---------------------------------- |
| PURCHASE       | NULL               | true     | purchasePrice 설정O                |
|                | PRODUCT            | false    |                                    |
|                | CATEGORY           | false    |                                    |
|                | PARTNER            | false    |                                    |
|                | PURCHASE_PRICE     | false    |                                    |
| CONSIGNMENT    | NULL               | false    |                                    |
|                | PRODUCT            | true     | commissionRate 설정O               |
|                | CATEGORY           | true     | 카테고리 수수료율로 자동 설정      |
|                | PARTNER            | true     | 계약된 파트너 수수료율로 자동 설정 |
|                | PURCHASE_PRICE     | true     | purchasePrice 설정O                |
| NULL           | NULL               | true     | default 값 으로 저장               |
|                | PRODUCT            | false    |                                    |
|                | CATEGORY           | false    |                                    |
|                | PARTNER            | false    |                                    |
|                | PURCHASE_PRICE     | false    |                                    |

## extraJson - 네이버 쇼핑 EP 및 네이버 페이 설정

- extraJson 에 네이버 쇼핑 EP 정보 입력 가능
- 도서 카테고리의 경우, 네이버 포인트 적립 불가

### extraJson - 렌탈 상품의 경우 아래의 값을 추가로 입력 받습니다.

| key              | value  | description                                              |
| ---------------- | ------ | -------------------------------------------------------- |
| manufactureName  | String | 제조사명 - 필수 / 영문,숫자,한글 최대 15자 (공백 가능)   |
| productModelName | String | 제품모델명 - 필수 / 영문,숫자,한글 최대 20자 (공백 가능) |
| serialNumber     | String | 시리얼 번호 - 선택 / 숫자,영문 최대 20자 (공백 불가)     |

## 주문환불 가능 설정

- refundableYn, refundableInfo.refundableYn 값이 다른경우 refundableYn을 우선순위로 판단합니다.
- refundableYn 값이 Y이면 모두 환불가능, 환불불가능 세부 설정은 refundableInfo.nonRefundableInfo 항목 확인해주세요.

## 상품 안내 정보 (productGuides)

- 배송비 템플릿 type 값만 입력하여 호출 시 해당 파트너에 등록된 상품 안내 정보 템플릿 정보로 저장됩니다.
- 템플릿이 아닌 직접 정보를 입력하고 싶은 경우, type과 content 를 입력하여 호출합니다.

## extraInfo - 임의로 활용 가능한 String 타입의 필드입니다. 최대 8000자까지 저장 가능하고, 요청 온 값을 조회 시에 그대로 반환합니다. |

## dutyInfo - 상품정보제공고시

- dutyInfo.contents 항목에서 key값에 아래 '상품정보고시항목 조회하기'의 dutyCategoryContents.displayOrder 요청시 dutyCategoryContents.contentName 값으로 대치됩니다.
- https://server-docs.shopby.co.kr/?url.primaryName=product/#/DUTY_CATEGORY/get-duty-categories
  ex)
- input : "contents": [{"1":"상품상세 참조"},{"2":"상품상세 참조"},{"3":"상품상세 참조"},{"4":"상품상세 참조"},{"5":"상품상세 참조"},{"6":"상품상세 참조"},{"7":"상품상세 참조"},{"8":"상품상세 참조"},{"9":"상품상세 참조"},{"10":"상품상세 참조"},{"11":"상품상세 참조"},{"12":"상품상세 참조"}]}"
- output : "contents": [{"품명": "상품상세 참조"}, {"KC 인증정보": "상품상세 참조"}, {"색상": "상품상세 참조"}, {"구성품": "상품상세 참조"}, {"주요 소재": "상품상세 참조"}, {"제조자": "상품상세 참조"}, {"제조국": "상품상세 참조"}, {"크기": "상품상세 참조"}, {"배송·설치비용": "상품상세 참조"}, {"품질보증기준": "상품상세 참조"}, {"재공급 사유 및 하자 부위에 관한 정보": "상품상세 참조"}, {"A/S 책임자와 전화번호": "상품상세 참조"}]

## 필수/선택형 옵션

- 해당 옵션을 사용할 경우 optionData.options[].optionType = REQUIRED 의 옵션 타입 요청이 필요합니다.
- 해당 옵션은 최소 1개 이상의 필수옵션이 필요합니다.
- optionData.options[].isRequiredOption의 Boolean값을 통해 필수/선택 옵션 여부를 설정할 수 있습니다.
- optionName은 `필수옵션` or `선택옵션`으로 고정 되기 때문에 `필수옵션` or `선택옵션`으로 요청해주세요.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /products

**요약**: 상품 (옵션포함) 수정하기

**설명**:

## 부가설명 및 특이사항

상품 단건, 옵션 복수건 (등록 OR 수정)

- 기본 템플릿 사용을 원할 경우, 템플릿 타입 type 값만 입력하여 호출
- 기본 템플릿 사용을 원하지 않는 경우, 템플릿 타입 type 값과 안내 내용은 content에 넣어 전달
- 단, 표준 카테고리가 "주류"인 경우 주류 기본 템플릿(=주류 통신판매 위임고시)이 필수이므로 content 가 null 인 경우 주류 기본 템플릿 저장
- 템플릿 타입 값의 경우, DELIVERY:배송, AFTER_SERVICE:A/S, REFUND:환불, EXCHANGE:교환, DELEGATION_BY_LIQUOR:주류

## 판매방식, 판매수수료 Valid Flow

| SaleMethodType | CommissionType | possible | description                        |
| -------------- | -------------- | -------- | ---------------------------------- |
| PURCHASE       | NULL           | true     | purchasePrice 설정O                |
|                | PRODUCT        | true     | purchasePrice 설정O                |
|                | CATEGORY       | false    |                                    |
|                | PARTNER        | false    |                                    |
|                | PURCHASE_PRICE | false    |                                    |
| CONSIGNMENT    | NULL           | false    |                                    |
|                | PRODUCT        | true     | commissionRate 설정O               |
|                | CATEGORY       | true     | 카테고리 수수료율로 자동 설정      |
|                | PARTNER        | true     | 계약된 파트너 수수료율로 자동 설정 |
|                | PURCHASE_PRICE | true     | purchasePrice 설정O                |
| NULL           | NULL           | true     | default 값 으로 저장               |
|                | PRODUCT        | false    |                                    |
|                | CATEGORY       | false    |                                    |
|                | PARTNER        | false    |                                    |
|                | PURCHASE_PRICE | false    |                                    |

## extraJson - 네이버 쇼핑 EP 및 네이버 페이 설정

## dutyInfo - 상품정보제공고시

- dutyInfo.contents 항목에서 key값에 아래 '상품정보고시항목 조회하기'의 dutyCategoryContents.displayOrder 요청시 dutyCategoryContents.contentName 값으로 대치됩니다.
- https://server-docs.shopby.co.kr/?url.primaryName=product/#/DUTY_CATEGORY/get-duty-categories
  ex)
- input : "contents": [{"1":"상품상세 참조"},{"2":"상품상세 참조"},{"3":"상품상세 참조"},{"4":"상품상세 참조"},{"5":"상품상세 참조"},{"6":"상품상세 참조"},{"7":"상품상세 참조"},{"8":"상품상세 참조"},{"9":"상품상세 참조"},{"10":"상품상세 참조"},{"11":"상품상세 참조"},{"12":"상품상세 참조"}]}"
- output : "contents": [{"품명": "상품상세 참조"}, {"KC 인증정보": "상품상세 참조"}, {"색상": "상품상세 참조"}, {"구성품": "상품상세 참조"}, {"주요 소재": "상품상세 참조"}, {"제조자": "상품상세 참조"}, {"제조국": "상품상세 참조"}, {"크기": "상품상세 참조"}, {"배송·설치비용": "상품상세 참조"}, {"품질보증기준": "상품상세 참조"}, {"재공급 사유 및 하자 부위에 관한 정보": "상품상세 참조"}, {"A/S 책임자와 전화번호": "상품상세 참조"}]

### extraJson - 렌탈 상품의 경우 아래의 값을 추가로 입력 받습니다.

| key              | value  | description                                              |
| ---------------- | ------ | -------------------------------------------------------- |
| manufactureName  | String | 제조사명 - 필수 / 영문,숫자,한글 최대 15자 (공백 가능)   |
| productModelName | String | 제품모델명 - 필수 / 영문,숫자,한글 최대 20자 (공백 가능) |
| serialNumber     | String | 시리얼 번호 - 선택 / 숫자,영문 최대 20자 (공백 불가)     |

- PRO 의 경우, extraJson 에 네이버 쇼핑 EP 정보 입력 가능
- 도서 카테고리의 경우, 네이버 포인트 적립 불가

## 상품 안내 정보 (productGuides)

- 배송비 템플릿 type 값만 입력하여 호출 시 해당 파트너에 등록된 상품 안내 정보 템플릿 정보로 저장됩니다.
- 템플릿이 아닌 직접 정보를 입력하고 싶은 경우, type과 content 를 입력하여 호출합니다.

## extraInfo - 임의로 활용 가능한 String 타입의 필드입니다. 최대 8000자까지 저장 가능하고, 요청 온 값을 조회 시에 그대로 반환합니다.

## 필수/선택형 옵션

- 해당 옵션을 사용할 경우 optionData.options[].optionType = REQUIRED 의 옵션 타입 요청이 필요합니다.
- 해당 옵션은 최소 1개 이상의 필수옵션이 필요합니다.
- optionData.options[].isRequiredOption의 Boolean값을 통해 필수/선택 옵션 여부를 설정할 수 있습니다.
- optionName은 `필수옵션` or `선택옵션`으로 고정 되기 때문에 `필수옵션` or `선택옵션`으로 요청해주세요.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### POST /products/

**요약**: 상품(옵션포함) 등록하기 version 2.0

**설명**:

## 부가설명 및 특이사항

상품 단건, 옵션 복수건 등록

- 기본 템플릿 사용을 원할 경우, 템플릿 타입 type 값만 입력하여 호출
- 기본 템플릿 사용을 원하지 않는 경우, 템플릿 타입 type 값과 안내 내용은 content에 넣어 전달
- 단, 표준 카테고리가 "주류"인 경우 주류 기본 템플릿(=주류 통신판매 위임고시)이 필수이므로 content 가 null 인 경우 주류 기본 템플릿 저장
- 템플릿 타입 값의 경우, DELIVERY:배송, AFTER_SERVICE:A/S, REFUND:환불, EXCHANGE:교환, DELEGATION_BY_LIQUOR:주류

## 플랜별 상품 등록 제한

- basic : 50 건
- pro : 30,000 건
- enterprise : 무제한

## 판매방식, 판매수수료 Valid Flow

| SaleMethodType | commissionRateType | possible | description                        |
| -------------- | ------------------ | -------- | ---------------------------------- |
| PURCHASE       | NULL               | true     | purchasePrice 설정O                |
|                | PRODUCT            | false    |                                    |
|                | CATEGORY           | false    |                                    |
|                | PARTNER            | false    |                                    |
|                | PURCHASE_PRICE     | false    |                                    |
| CONSIGNMENT    | NULL               | false    |                                    |
|                | PRODUCT            | true     | commissionRate 설정O               |
|                | CATEGORY           | true     | 카테고리 수수료율로 자동 설정      |
|                | PARTNER            | true     | 계약된 파트너 수수료율로 자동 설정 |
|                | PURCHASE_PRICE     | true     | purchasePrice 설정O                |
| NULL           | NULL               | true     | default 값 으로 저장               |
|                | PRODUCT            | false    |                                    |
|                | CATEGORY           | false    |                                    |
|                | PARTNER            | false    |                                    |
|                | PURCHASE_PRICE     | false    |                                    |

## extraJson - 네이버 쇼핑 EP 및 네이버 페이 설정

- extraJson 에 네이버 쇼핑 EP 정보 입력 가능
- 도서 카테고리의 경우, 네이버 포인트 적립 불가

### extraJson - 렌탈 상품의 경우 아래의 값을 추가로 입력 받습니다.

| key              | value  | description                                              |
| ---------------- | ------ | -------------------------------------------------------- |
| manufactureName  | String | 제조사명 - 필수 / 영문,숫자,한글 최대 15자 (공백 가능)   |
| productModelName | String | 제품모델명 - 필수 / 영문,숫자,한글 최대 20자 (공백 가능) |
| serialNumber     | String | 시리얼 번호 - 선택 / 숫자,영문 최대 20자 (공백 불가)     |

## dutyInfo - 상품정보제공고시

- dutyInfo.contents 항목에서 key값에 아래 '상품정보고시항목 조회하기'의 dutyCategoryContents.displayOrder 요청시 dutyCategoryContents.contentName 값으로 대치됩니다.
- https://server-docs.shopby.co.kr/?url.primaryName=product/#/DUTY_CATEGORY/get-duty-categories
  ex)
- input : "contents": [{"1":"상품상세 참조"},{"2":"상품상세 참조"},{"3":"상품상세 참조"},{"4":"상품상세 참조"},{"5":"상품상세 참조"},{"6":"상품상세 참조"},{"7":"상품상세 참조"},{"8":"상품상세 참조"},{"9":"상품상세 참조"},{"10":"상품상세 참조"},{"11":"상품상세 참조"},{"12":"상품상세 참조"}]}"
- output : "contents": [{"품명": "상품상세 참조"}, {"KC 인증정보": "상품상세 참조"}, {"색상": "상품상세 참조"}, {"구성품": "상품상세 참조"}, {"주요 소재": "상품상세 참조"}, {"제조자": "상품상세 참조"}, {"제조국": "상품상세 참조"}, {"크기": "상품상세 참조"}, {"배송·설치비용": "상품상세 참조"}, {"품질보증기준": "상품상세 참조"}, {"재공급 사유 및 하자 부위에 관한 정보": "상품상세 참조"}, {"A/S 책임자와 전화번호": "상품상세 참조"}]

## 주문환불 가능 설정

- refundableInfo.refundable 값이 true이면 모두 환불가능, 환불불가능 세부 설정은 refundableInfo.nonRefundTypes 항목 확인해주세요.

## 상품 안내 정보 (productGuides)

- 배송비 템플릿 type 값만 입력하여 호출 시 해당 파트너에 등록된 상품 안내 정보 템플릿 정보로 저장됩니다.
- 템플릿이 아닌 직접 정보를 입력하고 싶은 경우, type과 content 를 입력하여 호출합니다.

## extraInfo - 임의로 활용 가능한 String 타입의 필드입니다. 최대 8000자까지 저장 가능하고, 요청 온 값을 조회 시에 그대로 반환합니다.

## 필수/선택형 옵션

- 해당 옵션을 사용할 경우 optionData.options[].optionType = REQUIRED 의 옵션 타입 요청이 필요합니다.
- 해당 옵션은 최소 1개 이상의 필수옵션이 필요합니다.
- option.options[].isRequiredOption의 Boolean값을 통해 필수/선택 옵션 여부를 설정할 수 있습니다.
- optionName은 `필수옵션` or `선택옵션`으로 고정 되기 때문에 `필수옵션` or `선택옵션`으로 요청해주세요.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명     |
| --------- | ------ | ------ | ---- | -------- |
| version   | header | string | ✅   | API 버전 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |

**응답**:

- **200**: 200

---

### GET /products/by-stickers

**요약**: 스티커 번호로 상품 정보 조회하기

**설명**:

## 부가설명 및 특이사항

스티커 번호로 상품 정보를 조회하는 API입니다

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                            |
| ----------- | ------ | ------ | ---- | ------------------------------- |
| stickerNos  | query  | string | ✅   | 스티커 번호(쉼표 구분)          |
| size        | query  | number | ❌   | 조회할 상품 개수(default: 10)   |
| searchAfter | query  | number | ✅   | 검색 기준 값(response의 lastId) |
| systemKey   | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/changed

**요약**: 변경된 상품 번호 목록 조회

**설명**:

## 부가설명 및 특이사항

조회 기준시점을 기준으로 이후에 등록 / 수정된 상품번호 목록을 조회할 수 있습니다.<br />

- 정렬순서(direction)을 설정하지 않는 경우 ASC(오름차순)이 적용됩니다.<br />
- 정렬기준이 UPDATED_AT 일때 `재고변경이력 포함여부`가 사용 가능합니다.<br />
- partnerNo 파라미터는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.<br />
- partnerNo를 요청 파라미터에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.<br />
- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

## 검색 방식

- 아래 두 가지 검색방식을 모두 지원합니다.
- (기존) paging search : page 값 필수 (최초 조회 시 생략 가능)
- (신규) keySet search : searchAfter 필수, 정렬기준이 REGISTERED_AT 일때만 사용가능. (최초 조회 시 생략 가능. response의 lastId 값 사용.)

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                                                         |
| --------------------- | ------ | ------- | ---- | ---------------------------------------------------------------------------- |
| asOf                  | query  | string  | ✅   | 조회 기준시점                                                                |
| sortBy                | query  | string  | ✅   | 정렬 기준 Enum: [ REGISTERED_AT: 등록일, UPDATED_AT: 수정일 ]                |
| direction             | query  | string  | ❌   | 정렬 방향 Enum: [ ASC: 오름차순, DESC: 내림차순 ]                            |
| includingStockChanges | query  | boolean | ❌   | 재고변경이력 포함여부 (default: true, 정렬기준이 UPDATED_AT 일때만 적용가능) |
| page                  | query  | number  | ❌   | 페이지 번호(default: 1)                                                      |
| size                  | query  | number  | ✅   | 페이지 사이즈                                                                |
| searchAfter           | query  | string  | ❌   | 검색 기준 값(lastId)                                                         |
| systemKey             | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/extraInfo

**요약**: 추가정보 조회하기

**설명**:

## 부가설명 및 특이사항

상품번호로 추가정보를 조회하는 API입니다

- 최대 100개의 상품을 동시 조회 가능합니다.

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                 |
| ---------- | ------ | ------ | ---- | -------------------- |
| productNos | query  | string | ✅   | 상품 번호(쉼표 구분) |
| systemKey  | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /products/partial

**요약**: 상품 부분(판매상태, 전시상태, 품절처리, 옵션) 수정하기

**설명**:

## 부가설명 및 특이사항

상품 수정하는 API입니다

상품 상태를 수정합니다(판매상태, 전시상태 변경 API, 품절처리 등)

request 에 옵션번호가 있을 경우 옵션번호로, 옵션번호가 없고 옵션관리코드가 있는 경우에는 옵션관리코드가 동일한 옵션을 수정하게 됩니다.

옵션번호 옵션관리코드는 변경대상이 아닙니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /products/sale-agreements

**요약**: 상품 판매합의 승인/거절하기

**설명**:

## 부가설명 및 특이사항

상품 합의판매 승인/거절하는 API입니다

합의판매 승인/거절 가능 최대 상품 수: 50개

message 내용에 따라 상품 정보 확인 및 수정해 주세요
아래는 메시지 내용의 일부 입니다.

- 상품의 판매합의정보가 존재하지 않습니다.

- 판매합의진행 상태가 아닙니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/search

**요약**: 상품 검색하기

**설명**:

## 부가설명 및 특이사항

상품 검색하는 API입니다

- partnerNo 파라미터는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.

- partnerNo를 요청 파라미터에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.

- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

검색 방식

- 아래 두 가지 검색방식을 모두 지원합니다.

- (기존) paging search : page 값 필수 (최초 조회 시 생략 가능)

- (신규) keySet search : searchAfter 필수 (최초 조회 시 생략 가능. response의 lastId 값 사용.)

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

| 이름        | 위치   | 타입   | 필수 | 설명                            |
| ----------- | ------ | ------ | ---- | ------------------------------- |
| page        | query  | number | ❌   | 페이지 번호(default: 1)         |
| size        | query  | number | ✅   | 페이지 사이즈(default: 20)      |
| partnerNo   | query  | number | ❌   | 파트너 번호(설명란 참조)        |
| searchAfter | query  | number | ❌   | 검색 기준 값(lastId - 상품번호) |
| systemKey   | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/search-by-nos

**요약**: 상품 리스트로 상품 검색하기

**설명**:

## 부가설명 및 특이사항

상품 리스트로 상품 검색하는 API입니다

- partnerNo 파라미터는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.

- partnerNo를 요청 파라미터에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.

- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

- 상품 리스트 내 상품 최대 개수는 100개로 제한됩니다.

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

| 이름       | 위치   | 타입   | 필수 | 설명                     |
| ---------- | ------ | ------ | ---- | ------------------------ |
| productNos | query  | string | ✅   | 검색 할 상품 번호들      |
| partnerNo  | query  | number | ❌   | 파트너 번호(설명란 참조) |
| systemKey  | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /products/stock-with-product-management-code

**요약**: 상품 관리코드로 재고 변경하기

**설명**:

## 부가설명 및 특이사항

상품(옵션없음)별 재고를 수정할 수 있습니다.<br />
요청당 최대 100건 까지 수정 가능합니다.

## 응답

- 전체 성공: 200(OK)
- 부분 성공: 207(MULTI_STATUS)

## 에러 코드

| 코드     | 내용                  |
| -------- | --------------------- |
| PMEC0001 | 상품 존재하지 않음    |
| PMEC0002 | 권한 없음             |
| PMEC0003 | 옵션 없는 상품이 아님 |
| PMEC9999 | 변경 실패             |

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **207**: 207

---

### POST /products/temporary

**요약**: 상품 임시 등록하기

**설명**:

## 부가설명 및 특이사항

상품을 임시 등록하는 API입니다

상품을 등록대기 상태로 등록합니다

## 플랜별 상품 등록 제한

- basic : 50 건

- pro : 30,000 건

- enterprise : 무제한

## 상품 안내 정보 (productGuides)

- templateNo 를 모르는 경우 type 값만 입력하여 호출 시 해당 파트너에 등록된 상품 안내 정보 템플릿 정보로 저장됩니다.

- 템플릿이 아닌 직접 정보를 입력하고 싶은 경우, type, content 를 입력하여 호출합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/{mallProductNo}

**요약**: 상품 상세 조회하기

**설명**:

## 부가설명 및 특이사항

상품 상세 조회하는 API입니다

- partnerNo 파라미터는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.

- partnerNo를 요청 파라미터에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.

- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

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

| 이름          | 위치   | 타입   | 필수 | 설명     |
| ------------- | ------ | ------ | ---- | -------- |
| mallProductNo | path   | string | ✅   | 상품번호 |
| systemKey     | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PATCH /products/{mallProductNo}

**요약**: 상품 부분 수정하기 (Version 3.0)

**설명**:

## Version 3.0 변경점 안내

상품 상세 조회하기(Version 3.0) API는 상품 부분 수정하기(Version 3.0)의 요청 모델을 바탕으로 구성되어, 모델 간 일관성을 유지하고 사용자의 요청 작성 편의성을 높였습니다

## 부가설명 및 특이사항

상품의 일부를 수정하는 API입니다 (Version 3.0)

수정을 원하는 일부의 값만 수정합니다.

수정이 필요한 필드의 키와 값만 넣습니다.(nullable 한 필드값에 `null` 값으로 요청하는 경우, `null` 값이 반영됩니다.

객체를 수정하는 경우, 객체 내에 수정할 정보를 제외한 나머지는 기존 정보 그대로 입력해야합니다.

- 상품 부분 수정 API는 request body의 1depth를 기준으로 수정이 됩니다.

- 예를 들어 상품 이미지(request body에서 `mallProductImages.imageUrl`)를 수정하려고 하는 경우, 수정하는 값(`mallProductImages.imageUrl`) 외에 다른 값(`mallProductImages.mainYn`, `mallProductImages.imageUrlType` 등은 기존 값을 그대로 입력해야합니다.

- 따라서 `mallProductImages.imageUrl`만 수정해서 요청하는 경우, 다른 값(imageUrlType) 등은 기본 값으로 대체됩니다.

## 상품 안내 정보 (productGuides)

- templateNo 를 모르는 경우 type 값만 입력하여 호출 시 해당 파트너에 등록된 상품 안내 정보 템플릿 정보로 저장됩니다.

- 템플릿이 아닌 직접 정보를 입력하고 싶은 경우, type, content 를 입력하여 호출합니다.

## 필수/선택형 옵션

- 해당 옵션을 사용할 경우 optionType = REQUIRED 의 옵션 타입 요청이 필요합니다.

- 해당 옵션은 최소 1개 이상의 필수옵션이 필요합니다.

- options[].isRequiredOption의 Boolean값을 통해 필수/선택 옵션 여부를 설정할 수 있습니다.

- optionName은 `필수옵션` or `선택옵션`으로 고정 되기 때문에 `필수옵션` or `선택옵션`으로 요청해주세요.

**파라미터**:

| 이름          | 위치   | 타입   | 필수 | 설명     |
| ------------- | ------ | ------ | ---- | -------- |
| mallProductNo | path   | string | ✅   | 상품번호 |
| version       | header | string | ✅   | API 버전 |
| systemKey     | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |

**응답**:

- **204**: 204

---

### POST /products/{productNo}

**요약**: 재고연동상품 등록하기

**설명**:

## 부가설명 및 특이사항

상품 재고연동 생성하는 API입니다

기존 상품의 재고를 연동하여 상품을 새로 생성할 수 있습니다.

## 플랜별 상품 등록 제한

- basic : 50 건

- pro : 30,000 건

- enterprise : 무제한

## 상품 안내 정보 (productGuides)

- templateNo 를 모르는 경우 type 값만 입력하여 호출 시 해당 파트너에 등록된 상품 안내 정보 템플릿 정보로 저장됩니다.

- 템플릿이 아닌 직접 정보를 입력하고 싶은 경우, type, content 를 입력하여 호출합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명     |
| --------- | ------ | ------ | ---- | -------- |
| productNo | path   | string | ✅   | 상품번호 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PATCH /products/{productNo}

**요약**: 상품 부분 수정하기

**설명**:

## 부가설명 및 특이사항

상품의 일부를 수정하는 API입니다

수정을 원하는 일부의 값만 수정합니다.

수정이 필요한 필드의 키와 값만 넣습니다.(nullable 한 필드값에 `null` 값으로 요청하는 경우, `null` 값이 반영됩니다.

객체를 수정하는 경우, 객체 내에 수정할 정보를 제외한 나머지는 기존 정보 그대로 입력해야합니다.

- 예를 들어, `productImages`에서 `imageUrl`만 수정하려면 `mallImageNo`, `order`, `mainYn` 등은 기존 정보를 입력합니다.

## 상품 안내 정보 (productGuides)

- templateNo 를 모르는 경우 type 값만 입력하여 호출 시 해당 파트너에 등록된 상품 안내 정보 템플릿 정보로 저장됩니다.

- 템플릿이 아닌 직접 정보를 입력하고 싶은 경우, type, content 를 입력하여 호출합니다.

## 필수/선택형 옵션

- 해당 옵션을 사용할 경우 optionData.options[].optionType = REQUIRED 의 옵션 타입 요청이 필요합니다.

- 해당 옵션은 최소 1개 이상의 필수옵션이 필요합니다.

- optionData.options[].isRequiredOption의 Boolean값을 통해 필수/선택 옵션 여부를 설정할 수 있습니다.

- optionName은 `필수옵션` or `선택옵션`으로 고정 되기 때문에 `필수옵션` or `선택옵션`으로 요청해주세요.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| productNo | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### GET /products/global/by-global-nos

**요약**: 글로벌 번호로 상품 번호 조회하기

**설명**:

## 부가설명 및 특이사항

글로벌 번호로 상품 번호를 조회하는 API입니다

- globalProductNo는 최대 100 개까지 조회할 수 있습니다.

- productNo가 있는 globalProductNo만 조회됩니다.

- partnerNo는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.

- partnerNo를 요청 바디에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.

- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

**파라미터**:

| 이름             | 위치   | 타입   | 필수 | 설명                    |
| ---------------- | ------ | ------ | ---- | ----------------------- |
| globalProductNos | query  | number | ✅   | 글로벌 상품 번호 리스트 |
| systemKey        | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/global/by-product-nos

**요약**: 상품 번호로 글로벌 번호 조회하기

**설명**:

## 부가설명 및 특이사항

상품 번호로 글로벌 번호를 조회하는 API입니다

- productNos는 최대 100 개까지 조회할 수 있습니다.

- globalProductNo가 있는 productNo만 조회됩니다.

- partnerNo는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.

- partnerNo를 요청 바디에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.

- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명             |
| ---------- | ------ | ------ | ---- | ---------------- |
| productNos | query  | number | ✅   | 상품 번호 리스트 |
| systemKey  | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/inspections/approval-waiting

**요약**: 심사대상 상품 조회

**설명**:

## 부가설명 및 특이사항

심사대상 상품 조회 조회 API

- partnerNo 파라미터는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.

- partnerNo를 요청 파라미터에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.

- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

- 심사대상 상품을 조회할 수 있습니다.<br />
  심사 상태는 컴마(,)로 구분하여 복수 상태로 조회가능합니다.

### 심사 상태

- APPROVAL_READY: 심사대기
- AFTER_APPROVAL_READY: 수정후 심사대기

### 검색어 종류

- MALL_PRODUCT_NO: 상품번호
- PRODUCT_NAME: 상품명
- PRODUCT_MANAGEMENT_CD: 상품관리코드
- PRODUCT_MANAGEMENT_CD_LIKE: 상품관리코드|부분검색
- GROUP_MANAGEMENT_CODE: 그룹관리코드
- GLOBAL_PRODUCT_NO: 글로벌번호

### 검색 기간 종류

- REGISTER_DATE: 등록일
- SALE_START_DATE: 판매시작일
- SALE_END_DATE: 판매종료일
- LAST_UPDATE_DATE: 최종수정일

**파라미터**:

| 이름            | 위치   | 타입   | 필수 | 설명                 |
| --------------- | ------ | ------ | ---- | -------------------- |
| partnerNo       | query  | number | ❌   | 파트너 번호          |
| adminNo         | query  | number | ❌   | 담당자 번호          |
| applyStatus     | query  | string | ❌   | 승인 상태            |
| keywords        | query  | string | ❌   | 검색어               |
| periodType      | query  | string | ✅   | 검색기간 종류        |
| searchStartDate | query  | string | ✅   | 검색기간 시작일      |
| searchEndDate   | query  | string | ✅   | 검색기간 종료일      |
| keywordType     | query  | string | ✅   | 검색어 종류          |
| page            | query  | number | ✅   | 조회할 페이지 번호   |
| size            | query  | number | ✅   | 한번에 조회할 상품수 |
| systemKey       | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /products/inspections/confirm

**요약**: 상품 심사 승인하기

**설명**:

## 부가설명 및 특이사항

상품 심사 승인하는 API입니다

심사승인 가능 최대 상품 수: 50개

errorCode 는 NON_EDITABLE_PRODUCT 로 통일되어있으며, message 내용에 따라 상품 정보 확인 및 수정해 주세요
아래는 메시지 내용의 일부 입니다.

- 해당 상품은 수정이 불가능한 상태 입니다. (실제 없는 상품 번호의 경우)

- 상품번호[xxxxxx] 상품심사정보가 존재하지 않습니다.

- 상품번호[xxxxxx]는 상품심사진행 상태가 아닙니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /products/inspections/reject

**요약**: 상품 심사 거절하기

**설명**:

## 부가설명 및 특이사항

상품 심사 거절 API입니다

심사 거절 가능 최대 상품 수: 50개

상품 심사 거절 API의 승인 거절 사유는 `별도 승인거부 의견`으로 고정됩니다.

errorCode 는 NON_EDITABLE_PRODUCT 로 통일되어있으며, message 내용에 따라 상품 정보 확인 및 수정해 주세요
아래는 메시지 내용의 일부 입니다.

- 해당 상품은 수정이 불가능한 상태 입니다. (실제 없는 상품 번호의 경우)

- 상품번호[xxxxxx] 상품심사정보가 존재하지 않습니다.

- 상품번호[xxxxxx]는 상품심사진행 상태가 아닙니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/options/stocks

**요약**: 상품재고관리 옵션 리스트 조회

**설명**:
상품재고관리 옵션 리스트 조회 API 입니다.

**파라미터**:

| 이름                   | 위치   | 타입    | 필수 | 설명                                                                                              |
| ---------------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------- |
| partnerNo              | query  | integer | ✅   | 파트너 번호 (SA: nullable, BPC: 사용하지 않음)                                                    |
| brandNo                | query  | integer | ✅   | 브랜드 번호                                                                                       |
| periodType             | query  | string  | ✅   | 검색 기간 조건 종류 ()                                                                            |
| startYmdt              | query  | string  | ✅   | 조회기간 시작 일자                                                                                |
| endYmdt                | query  | string  | ✅   | 조회기간 종료 일자 (default: 현재)                                                                |
| saleStatusTypes        | query  | string  | ✅   | 판매 상태, (ON_PRE_SALE: 예약판매중, WAITING_SALE: 판매대기, ON_SALE: 판매중, END_SALE: 판매종료) |
| saleSettingStatusTypes | query  | string  | ✅   | 판매 설정, (AVAILABLE_FOR_SALE: 판매가능, STOP_SELLING: 판매중지, PROHIBITION_SALE: 판매금지)     |
| allowsFrontDisplay     | query  | string  | ✅   | 전시 여부(default: ALL), (ALL: 전체, Y: 가능, N: 불가능)                                          |
| page                   | query  | integer | ✅   | 페이지 번호                                                                                       |
| size                   | query  | integer | ✅   | 페이지 사이즈                                                                                     |
| searchAfter            | query  | integer | ❌   | 검색 기준 값(lastId)                                                                              |
| systemKey              | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PATCH /products/partial/quick

**요약**: 상품 부분수정 (상품별 요청값 부분수정, 벌크 가능)

**설명**:

## 부가설명 및 특이사항

상품을 부분수정 하는 API입니다

변경하고자 하는 항목들만 전달받고, 벌크로 빠르게 수정처리 해줍니다. (최대 100개)

승인 완료된 상품만 업데이트 가능하며, 심사를 타지 않는 항목 또는 요청자만 사용 가능합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/search/engine

**요약**: 상품 검색하기 (검색엔진)

**설명**:

## 부가설명 및 특이사항

검색엔진을 사용하여 상품을 검색하는 API 입니다

**승인 이전 상품**, **판매 불가(금지, 중지, 종료) 상품**은 노출되지 않습니다.

페이지 사이즈는 최대 100건까지 가능합니다.

검색 방식

- 아래 두 가지 검색방식을 모두 지원합니다.

- (기존) paging search : pageNumber 필수 (최초 조회 시 생략 가능)

- (신규) keySet search : searchAfter 필수 (최초 조회 시 생략 가능. response의 lastId 값 사용.)

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

| 이름                         | 위치   | 타입    | 필수 | 설명                                                                                                                                                                                                                                                                |
| ---------------------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| filter.discountedPrices      | query  | number  | ❌   | 판매가 - 즉시할인 - 추가상품할인이 적용된 "최종 할인가격", between 검색일 경우 입력값 2개 필요(다수 정보는 항목 추가 필요                                                                                                                                           |
| filter.keywords              | query  | string  | ❌   | 검색어(여러 검색어일 경우 space 로 구분 AND 연산)                                                                                                                                                                                                                   |
| filter.keywordInResult       | query  | string  | ❌   | 결과내 검색(결과 내 검색의 검색어 space 구분 AND 연산)                                                                                                                                                                                                              |
| filter.discountedComparison  | query  | string  | ❌   | 최종 할인가격 검색 조건 (GT: 초과 - GREATER THAN, LTE: 미만 -LESS GREATER THAN, GTE: 이상 - GREATER THAN or EQUAL, EQ: 동등 - EQUAL, BETWEEN: 사이의                                                                                                                |
| filter.deliveryConditionType | query  | string  | ❌   | 배송비 타입 Enum: [ FREE: 무료, CONDITIONAL: 조건부 무료, FIXED_FEE: 유료(고정 배송비) ]                                                                                                                                                                            |
| filter.saleStatus            | query  | string  | ❌   | 판매 상태 (default:ONSALE) (전체 판매 상태 조회: ALL_CONDITIONS, 판매대기와 판매중 상품 조회: READY_ONSALE, 판매중 상품만 조회: ONSALE, 예약판매중인 상품과 판매중인 상품만 조회: RESERVATION_AND_ONSALE, 판매대기와 예약판매중 상품만 조회: READY_AND_RESERVATION) |
| filter.soldout               | query  | boolean | ❌   | 품절 상품 포함 여부(default: false)                                                                                                                                                                                                                                 |
| filter.totalReviewCount      | query  | boolean | ❌   | 총 상품평 수 포함 여부(default: false, false 설정 시 무조건 0)                                                                                                                                                                                                      |
| filter.familyMalls           | query  | boolean | ❌   | 서비스에 계약된 모든 쇼핑몰 조회 여부 (default: false)                                                                                                                                                                                                              |
| filter.productManagementCd   | query  | string  | ❌   | 판매자관리코드 같은 상품 검색                                                                                                                                                                                                                                       |
| filter.excludeMallProductNo  | query  | integer | ❌   | 조회시 제외할 상품번호                                                                                                                                                                                                                                              |
| filter.includeMallProductNo  | query  | integer | ❌   | 조회할 상품번호                                                                                                                                                                                                                                                     |
| order.by                     | query  | string  | ❌   | POPULAR:판매인기순, SALE_YMD:판매일자, DISCOUNTED_PRICE:가격순, REVIEW:상품평, SALE_CNT:총판매량순, RECENT_PRODUCT:최근상품순, MD_RECOMMEND:MD추천순, LIKE_CNT: 좋아요                                                                                              |
| order.direction              | query  | string  | ❌   | 정렬기준(default : DESC)                                                                                                                                                                                                                                            |
| order.soldoutPlaceEnd        | query  | boolean | ❌   | 품절상품 뒤로 배치 여부(default = false)                                                                                                                                                                                                                            |
| displayCategoryNos           | query  | string  | ❌   | 전시 카테고리 번호(여러개 일 경우 항목 추가)                                                                                                                                                                                                                        |
| displayBrandNos              | query  | string  | ❌   | 전시 브랜드 번호(여러개 일 경우 항목 추가)                                                                                                                                                                                                                          |
| partnerNo                    | query  | integer | ❌   | 파트너 번호(상품 공급업체 번호)                                                                                                                                                                                                                                     |
| clientKey                    | query  | integer | ❌   | 클라이언트 키                                                                                                                                                                                                                                                       |
| pageNumber                   | query  | integer | ❌   | 페이지 번호(default: 1)                                                                                                                                                                                                                                             |
| pageSize                     | query  | integer | ❌   | 한 페이지당 노출 수                                                                                                                                                                                                                                                 |
| onlySaleProduct              | query  | boolean | ❌   | 세일 상품만 조회 여부(default: false)                                                                                                                                                                                                                               |
| hasMaxCouponAmt              | query  | boolean | ❌   | 목록에 최대 할인 쿠폰 가격 포함 여부(default: false)                                                                                                                                                                                                                |
| hasTotalCount                | query  | boolean | ❌   | 전체 상품 수 포함 여부(default: false)                                                                                                                                                                                                                              |
| hasOptionValues              | query  | boolean | ❌   | 목록에 옵션 value 포함 여부(default: false)                                                                                                                                                                                                                         |
| includeSummaryInfo           | query  | boolean | ❌   | summary 정보 포함 여부(default: false)                                                                                                                                                                                                                              |
| shippingAreaType             | query  | string  | ❌   | 배송 구분 (Enum: [ PARTNER: 파트너 배송, MALL: 쇼핑몰 배송 ])                                                                                                                                                                                                       |
| platformType                 | query  | string  | ❌   | 플랫폼 타입 (Enum: [ PC: PC, MOBILE_WEB: 모바일 웹, MOBILE: 모바일 앱 ])                                                                                                                                                                                            |
| memberNo                     | query  | number  | ❌   | 회원번호 (비회원인 경우 null)                                                                                                                                                                                                                                       |
| frontDisplay                 | query  | string  | ❌   | 전시 여부 (default: Y) - Y(전시함), N(전시안함), ALL(전체)                                                                                                                                                                                                          |
| searchAfter                  | query  | string  | ❌   | 검색 기준 값(lastId)                                                                                                                                                                                                                                                |
| systemKey                    | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |
| useCache | header | string | ✅ | 캐시 사용 여부 |

**응답**:

- **200**: 200

---

### GET /products/{mallProductNo}/

**요약**: 상품 상세 조회하기 (Version 3.0)

**설명**:

## Version 3.0 변경점 안내

상품 상세 조회하기(Version 3.0) API는 상품 부분 수정하기(Version 3.0)의 요청 모델을 바탕으로 구성되어, 모델 간 일관성을 유지하고 사용자의 요청 작성 편의성을 높였습니다

## 부가설명 및 특이사항

상품 상세 조회하는 API입니다 (Version 3.0)

- partnerNo 파라미터는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.

- partnerNo를 요청 파라미터에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.

- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

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

| 이름          | 위치   | 타입   | 필수 | 설명     |
| ------------- | ------ | ------ | ---- | -------- |
| mallProductNo | path   | string | ✅   | 상품번호 |
| version       | header | string | ✅   | API 버전 |
| systemKey     | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |

**응답**:

- **200**: 200

---

### PUT /products/{mallProductNo}/status

**요약**: 상품 상태 변경하기

**설명**:

## 부가설명 및 특이사항

상품 상태 변경하는 API입니다

**파라미터**:

| 이름          | 위치   | 타입   | 필수 | 설명     |
| ------------- | ------ | ------ | ---- | -------- |
| mallProductNo | path   | string | ✅   | 상품번호 |
| systemKey     | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /products/{productNo}/

**요약**: 상품 (옵션포함) 수정하기 version 2.0

**설명**:

## 부가설명 및 특이사항

상품 단건, 옵션 복수건 등록

- 기본 템플릿 사용을 원할 경우, 템플릿 타입 type 값만 입력하여 호출
- 기본 템플릿 사용을 원하지 않는 경우, 템플릿 타입 type 값과 안내 내용은 content에 넣어 전달
- 단, 표준 카테고리가 "주류"인 경우 주류 기본 템플릿(=주류 통신판매 위임고시)이 필수이므로 content 가 null 인 경우 주류 기본 템플릿 저장
- 템플릿 타입 값의 경우, DELIVERY:배송, AFTER_SERVICE:A/S, REFUND:환불, EXCHANGE:교환, DELEGATION_BY_LIQUOR:주류

## 판매방식, 판매수수료 Valid Flow

| SaleMethodType | CommissionType | possible | description                        |
| -------------- | -------------- | -------- | ---------------------------------- |
| PURCHASE       | NULL           | true     | purchasePrice 설정O                |
|                | PRODUCT        | true     | purchasePrice 설정O                |
|                | CATEGORY       | false    |                                    |
|                | PARTNER        | false    |                                    |
|                | PURCHASE_PRICE | false    |                                    |
| CONSIGNMENT    | NULL           | false    |                                    |
|                | PRODUCT        | true     | commissionRate 설정O               |
|                | CATEGORY       | true     | 카테고리 수수료율로 자동 설정      |
|                | PARTNER        | true     | 계약된 파트너 수수료율로 자동 설정 |
|                | PURCHASE_PRICE | true     | purchasePrice 설정O                |
| NULL           | NULL           | true     | default 값 으로 저장               |
|                | PRODUCT        | false    |                                    |
|                | CATEGORY       | false    |                                    |
|                | PARTNER        | false    |                                    |
|                | PURCHASE_PRICE | false    |                                    |

## extraJson - 네이버 쇼핑 EP 및 네이버 페이 설정

### extraJson - 렌탈 상품의 경우 아래의 값을 추가로 입력 받습니다.

| key              | value  | description                                              |
| ---------------- | ------ | -------------------------------------------------------- |
| manufactureName  | String | 제조사명 - 필수 / 영문,숫자,한글 최대 15자 (공백 가능)   |
| productModelName | String | 제품모델명 - 필수 / 영문,숫자,한글 최대 20자 (공백 가능) |
| serialNumber     | String | 시리얼 번호 - 선택 / 숫자,영문 최대 20자 (공백 불가)     |

- PRO 의 경우, extraJson 에 네이버 쇼핑 EP 정보 입력 가능
- 도서 카테고리의 경우, 네이버 포인트 적립 불가

## 상품 안내 정보 (productGuides)

- 배송비 템플릿 type 값만 입력하여 호출 시 해당 파트너에 등록된 상품 안내 정보 템플릿 정보로 저장됩니다.
- 템플릿이 아닌 직접 정보를 입력하고 싶은 경우, type과 content 를 입력하여 호출합니다.

## extraInfo - 임의로 활용 가능한 String 타입의 필드입니다. 최대 8000자까지 저장 가능하고, 요청 온 값을 조회 시에 그대로 반환합니다.

## dutyInfo - 상품정보제공고시

- dutyInfo.contents 항목에서 key값에 아래 '상품정보고시항목 조회하기'의 dutyCategoryContents.displayOrder 요청시 dutyCategoryContents.contentName 값으로 대치됩니다.
- https://server-docs.shopby.co.kr/?url.primaryName=product/#/DUTY_CATEGORY/get-duty-categories
  ex)
- input : "contents": [{"1":"상품상세 참조"},{"2":"상품상세 참조"},{"3":"상품상세 참조"},{"4":"상품상세 참조"},{"5":"상품상세 참조"},{"6":"상품상세 참조"},{"7":"상품상세 참조"},{"8":"상품상세 참조"},{"9":"상품상세 참조"},{"10":"상품상세 참조"},{"11":"상품상세 참조"},{"12":"상품상세 참조"}]}"
- output : "contents": [{"품명": "상품상세 참조"}, {"KC 인증정보": "상품상세 참조"}, {"색상": "상품상세 참조"}, {"구성품": "상품상세 참조"}, {"주요 소재": "상품상세 참조"}, {"제조자": "상품상세 참조"}, {"제조국": "상품상세 참조"}, {"크기": "상품상세 참조"}, {"배송·설치비용": "상품상세 참조"}, {"품질보증기준": "상품상세 참조"}, {"재공급 사유 및 하자 부위에 관한 정보": "상품상세 참조"}, {"A/S 책임자와 전화번호": "상품상세 참조"}]

## 필수/선택형 옵션

- 해당 옵션을 사용할 경우 optionData.options[].optionType = REQUIRED 의 옵션 타입 요청이 필요합니다.
- 해당 옵션은 최소 1개 이상의 필수옵션이 필요합니다.
- option.options[].isRequiredOption의 Boolean값을 통해 필수/선택 옵션 여부를 설정할 수 있습니다.
- optionName은 `필수옵션` or `선택옵션`으로 고정 되기 때문에 `필수옵션` or `선택옵션`으로 요청해주세요.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명     |
| --------- | ------ | ------ | ---- | -------- |
| productNo | path   | string | ✅   | -        |
| version   | header | string | ✅   | API 버전 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |

**응답**:

- **200**: 200

---

### PATCH /products/{productNo}/

**요약**: 상품 부분 수정하기 (version 2.0)

**설명**:

## 부가설명 및 특이사항

상품의 일부를 수정하는 API입니다

수정을 원하는 일부의 값만 수정합니다.

수정이 필요한 필드의 키와 값만 넣습니다.(nullable 한 필드값에 `null` 값으로 요청하는 경우, `null` 값이 반영됩니다.

객체를 수정하는 경우, 객체 내에 수정할 정보를 제외한 나머지는 기존 정보 그대로 입력해야합니다.

- 상품 부분 수정 API는 request body의 1depth를 기준으로 수정이 됩니다.

- 예를 들어 상품 이미지(request body에서 `image.images`)를 수정하려고 하는 경우, 수정하는 값(`image.images`) 외에 다른 값(`image.listImage`, `image.usesExternalImage` 등은 기존 값을 그대로 입력해야합니다.

- 따라서 `image.images`만 수정해서 요청하는 경우, 다른 값(usesExternalImage, listImage) 등은 기본 값으로 대체됩니다.

## 상품 안내 정보 (productGuides)

- templateNo 를 모르는 경우 type 값만 입력하여 호출 시 해당 파트너에 등록된 상품 안내 정보 템플릿 정보로 저장됩니다.

- 템플릿이 아닌 직접 정보를 입력하고 싶은 경우, type, content 를 입력하여 호출합니다.

## 필수/선택형 옵션

- 해당 옵션을 사용할 경우 optionData.options[].optionType = REQUIRED 의 옵션 타입 요청이 필요합니다.

- 해당 옵션은 최소 1개 이상의 필수옵션이 필요합니다.

- option.options[].isRequiredOption의 Boolean값을 통해 필수/선택 옵션 여부를 설정할 수 있습니다.

- optionName은 `필수옵션` or `선택옵션`으로 고정 되기 때문에 `필수옵션` or `선택옵션`으로 요청해주세요.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명     |
| --------- | ------ | ------ | ---- | -------- |
| productNo | path   | string | ✅   | -        |
| version   | header | string | ✅   | API 버전 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |

**응답**:

- **204**: 204

---

### GET /products/{productNo}/histories

**요약**: 상품 변경 히스토리 조회

**설명**:

## 부가설명 및 특이사항

상품 변경 히스토리 조회 API

- partnerNo 파라미터는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.

- partnerNo를 요청 파라미터에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.

- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                     |
| --------- | ------ | ------ | ---- | ------------------------ |
| productNo | path   | string | ✅   | 상품번호                 |
| partnerNo | query  | number | ❌   | 파트너 번호(설명란 참조) |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/{productNo}/options

**요약**: 옵션 조회하기

**설명**:

## 부가설명 및 특이사항

해당 상품 번호에 대한 옵션 정보를 조회하는 API입니다

2가지 옵션 목록(계층, 원본)을 제공합니다

- partnerNo 파라미터는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.

- partnerNo를 요청 파라미터에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.

- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                     |
| --------- | ------ | ------ | ---- | ------------------------ |
| productNo | path   | string | ✅   | 상품 번호                |
| partnerNo | query  | number | ❌   | 파트너 번호(설명란 참조) |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/inspections/{productNo}/view

**요약**: 상품 심사 상세 조회

**설명**:

## 부가설명 및 특이사항

상품 심사 상세 조회 API

- partnerNo 파라미터는 자사파트너(쇼핑몰배송)의 경우에만 사용 가능합니다. 그 외의 경우(일반파트너사)는 사용 불가능합니다.

- partnerNo를 요청 파라미터에 넣는 경우, 해당 파트너사의 상품만 조회됩니다.

- 단, 일반파트너사의 경우에는 partnerNo를 사용하지 않아도 해당 파트너사의 상품만 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명        |
| --------- | ------ | ------ | ---- | ----------- |
| productNo | path   | string | ✅   | 상품번호    |
| partnerNo | query  | number | ❌   | 파트너 번호 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /products/search/engine/

**요약**: 상품 검색하기 version 2.0 (검색엔진)

**설명**:

## 부가설명 및 특이사항

검색엔진을 사용하여 상품을 검색하는 API 입니다

페이지 사이즈는 최대 100건까지 가능합니다.

검색 방식

- 아래 두 가지 검색방식을 모두 지원합니다.

- (기존) paging search : pageNumber 필수 (최초 조회 시 생략 가능)

- (신규) keySet search : searchAfter 필수 (최초 조회 시 생략 가능. response의 lastId 값 사용.)

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

| 이름                         | 위치   | 타입    | 필수 | 설명                                                                                                                                                                                                                                                                                                                  |
| ---------------------------- | ------ | ------- | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| filter.keywords              | query  | string  | ❌   | 검색어(여러 검색어일 경우 space 로 구분 AND 연산)                                                                                                                                                                                                                                                                     |
| filter.deliveryConditionType | query  | string  | ❌   | 배송비 타입 Enum: [ FREE: 무료, CONDITIONAL: 조건부 무료, FIXED_FEE: 유료(고정 배송비) ]                                                                                                                                                                                                                              |
| filter.saleStatus            | query  | string  | ❌   | 판매 상태 (default:ONSALE) (전체 판매 상태 조회: ALL_CONDITIONS, 판매대기와 판매중 상품 조회: READY_ONSALE, 판매중 상품만 조회: ONSALE, 예약판매중인 상품과 판매중인 상품만 조회: RESERVATION_AND_ONSALE, 판매대기와 예약판매중 상품만 조회: READY_AND_RESERVATION)                                                   |
| filter.soldout               | query  | boolean | ❌   | 품절 상품 포함 여부(default: false)                                                                                                                                                                                                                                                                                   |
| filter.totalReviewCount      | query  | boolean | ❌   | 총 상품평 수 포함 여부(default: false, false 설정 시 무조건 0)                                                                                                                                                                                                                                                        |
| filter.familyMalls           | query  | boolean | ❌   | 서비스에 계약된 모든 쇼핑몰 조회 여부 (default: false)                                                                                                                                                                                                                                                                |
| filter.productManagementCd   | query  | string  | ❌   | 판매자관리코드 같은 상품 검색                                                                                                                                                                                                                                                                                         |
| filter.excludeMallProductNo  | query  | integer | ❌   | 조회시 제외할 상품번호                                                                                                                                                                                                                                                                                                |
| filter.includeMallProductNo  | query  | integer | ❌   | 조회할 상품번호                                                                                                                                                                                                                                                                                                       |
| order.by                     | query  | string  | ❌   | RECENT_PRODUCT:최근상품순(default), SALE_YMD:판매일자                                                                                                                                                                                                                                                                 |
| order.direction              | query  | string  | ❌   | 정렬기준(default : DESC)                                                                                                                                                                                                                                                                                              |
| order.soldoutPlaceEnd        | query  | boolean | ❌   | 품절상품 뒤로 배치 여부(default = false)                                                                                                                                                                                                                                                                              |
| displayCategoryNos           | query  | string  | ❌   | 전시 카테고리 번호(여러개 일 경우 항목 추가)                                                                                                                                                                                                                                                                          |
| displayBrandNos              | query  | string  | ❌   | 전시 브랜드 번호(여러개 일 경우 항목 추가)                                                                                                                                                                                                                                                                            |
| partnerNo                    | query  | integer | ❌   | 파트너 번호(상품 공급업체 번호)                                                                                                                                                                                                                                                                                       |
| pageNumber                   | query  | integer | ❌   | 페이지 번호(default: 1)                                                                                                                                                                                                                                                                                               |
| pageSize                     | query  | integer | ❌   | 한 페이지당 노출 수                                                                                                                                                                                                                                                                                                   |
| hasOptionValues              | query  | boolean | ❌   | 목록에 옵션 value 포함 여부(default: false)                                                                                                                                                                                                                                                                           |
| shippingAreaType             | query  | string  | ❌   | 배송 구분 (Enum: [ PARTNER: 파트너 배송, MALL: 쇼핑몰 배송 ])                                                                                                                                                                                                                                                         |
| platformType                 | query  | string  | ❌   | 플랫폼 타입 (Enum: [ PC: PC, MOBILE_WEB: 모바일 웹, MOBILE: 모바일 앱 ])                                                                                                                                                                                                                                              |
| frontDisplay                 | query  | string  | ❌   | 전시 여부 (default: ALL) - Y(전시함), N(전시안함), ALL(전체)                                                                                                                                                                                                                                                          |
| urlDirectDisplay             | query  | string  | ❌   | 프론트 미노출 여부 (default: ALL) - Y(노출안함), N(노출함), ALL(전체)                                                                                                                                                                                                                                                 |
| registrationPeriod.startYmdt | query  | string  | ❌   | 등록일 - 시작일                                                                                                                                                                                                                                                                                                       |
| registrationPeriod.endYmdt   | query  | string  | ❌   | 등록일 - 종료일                                                                                                                                                                                                                                                                                                       |
| modificationPeriod.startYmdt | query  | string  | ❌   | 수정일 - 시작일                                                                                                                                                                                                                                                                                                       |
| modificationPeriod.endYmdt   | query  | string  | ❌   | 수정일 - 종료일                                                                                                                                                                                                                                                                                                       |
| saleSettingTypes             | query  | string  | ❌   | 판매설정타입 (빈값인 경우 전체 조회 - Enum: [ AVAILABLE_FOR_SALE: 판매가능, STOP_SELLING: 판매중지, PROHIBITION_SALE: 판매금지 ])                                                                                                                                                                                     |
| searchAfter                  | query  | string  | ❌   | 검색 기준 값(lastId)                                                                                                                                                                                                                                                                                                  |
| applyStatusType              | query  | string  | ❌   | 승인상태(default: ALL), Enum: [ ALL: 전체, REGISTRATION_READY: 등록대기, APPROVAL_READY: 승인대기, APPROVAL_REJECTION: 승인거부, SALE_AGREEMENT_READY: 판매합의대기, SALE_AGREEMENT_REJECTION: 판매합의거부, FINISHED: 승인완료, AFTER_APPROVAL_READY: 수정 후 승인대기, AFTER_APPROVAL_REJECTION: 수정 후 승인거부 ] |
| saleMethodType               | query  | string  | ❌   | 판매방식(default: ALL), Enum: [ ALL: 전체, PURCHASE: 사입, CONSIGNMENT: 위탁 ]                                                                                                                                                                                                                                        |
| stockRange.type              | query  | string  | ❌   | 재고조건 - 재고 범위 종류, Enum: [ ALL: 전체, NONE: 재고없음, EXIST: 재고있음, EQ: ==, LT: <, LE: <=, GT: >, GE: >=, RANGE: <= and <= ]                                                                                                                                                                               |
| stockRange.stockCnt          | query  | number  | ❌   | 재고조건 - 재고 수                                                                                                                                                                                                                                                                                                    |
| stockRange.minStockCnt       | query  | number  | ❌   | 재고조건 - RANGE 일시 최소 수량                                                                                                                                                                                                                                                                                       |
| stockRange.maxStockCnt       | query  | number  | ❌   | 재고조건 - RANGE 일시 최대 수량                                                                                                                                                                                                                                                                                       |
| customPropertyValueNos       | query  | string  | ❌   | 추가항목                                                                                                                                                                                                                                                                                                              |
| adminNo                      | query  | number  | ❌   | 담당자번호                                                                                                                                                                                                                                                                                                            |
| version                      | header | string  | ✅   | API 버전                                                                                                                                                                                                                                                                                                              |
| systemKey                    | header | string  | ✅   | 시스템 키(외부시스템 연동을 위한 샵바이 API 호출 키)                                                                                                                                                                                                                                                                  |
| mallKey                      | header | string  | ✅   | 외부 API 연동키 (외부시스템연동 코드)                                                                                                                                                                                                                                                                                 |

**응답**:

- **200**: 200

---

## Product Guide

### POST /products/guides

**요약**: 상품 이용안내 템플릿 등록 및 수정

**설명**:

상품 이용안내 템플릿을 신규 등록할 수 있습니다.<br />
기존에 등록된 안내 템플릿이 존재하는 경우 수정된 내용으로 변경됩니다.<br />

### 템플릿 타입

- DELIVERY: 배송안내
- AFTER_SERVICE: AS안내
- REFUND: 환불안내
- EXCHANGE: 교환안내
- DELEGATION_BY_LIQUOR: 주류 통신판매 명령 위임고시

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

## Product Option

### PUT /products/options

**요약**: 옵션(구매자작성형) 수정하기

**설명**:

## 부가설명 및 특이사항

옵션(구매자작성형) 수정하는 API입니다

mallOptionNo가 있으면 수정 0이면 등록, 사용안함은 use_yn = 'N’으로 업데이트 해야합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /products/options/stock-with-id

**요약**: 옵션 번호로 재고 변경하기

**설명**:

## 부가설명 및 특이사항

옵션별 재고를 수정할 수 있습니다.
요청당 최대 100건 까지 수정 가능합니다.

## 응답

- 전체 성공: 200(OK)
- 부분 성공: 207(MULTI_STATUS)

## 에러 코드

| 코드     | 내용               |
| -------- | ------------------ |
| OSEC0001 | 옵션 존재하지 않음 |
| OSEC0002 | 권한 없음          |
| OSEC9999 | 변경 실패          |

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **207**: 207

---

### PUT /products/options/stock-with-management-code

**요약**: 옵션 관리코드로 재고 변경하기

**설명**:

## 부가설명 및 특이사항

옵션별 재고를 수정할 수 있습니다.<br />
요청당 최대 100건 까지 수정 가능합니다.

## 응답

- 전체 성공: 200(OK)
- 부분 성공: 207(MULTI_STATUS)

## 에러 코드

| 코드     | 내용                                        |
| -------- | ------------------------------------------- |
| OSEC0001 | 옵션 존재하지 않음                          |
| OSEC0002 | 권한 없음                                   |
| OSEC0003 | 옵선 관리코드에 복수개 옵션이 매핑되어 있음 |
| OSEC9999 | 변경 실패                                   |

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **207**: 207

---

## Purchase Permission

### POST /purchase-permission

**요약**: 상품우선구매권한 생성하기

**설명**:

## 부가설명 및 특이사항

상품 우선구매권한 생성 API 입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### DELETE /purchase-permission/{permissionNo}

**요약**: 상품우선구매권한 삭제하기

**설명**:

## 부가설명 및 특이사항

상품 우선구매권한 삭제 API 입니다.

**파라미터**:

| 이름         | 위치   | 타입   | 필수 | 설명         |
| ------------ | ------ | ------ | ---- | ------------ |
| permissionNo | path   | string | ✅   | 구매권한번호 |
| systemKey    | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### GET /purchase-permission/{productNo}

**요약**: 상품우선구매권한 조회하기

**설명**:

## 부가설명 및 특이사항

상품 우선구매권한 조회 API 입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명     |
| --------- | ------ | ------ | ---- | -------- |
| productNo | path   | string | ✅   | 상품번호 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /purchase-permission/member/{permissionNo}

**요약**: 회원우선구매권한 수정하기

**설명**:

## 부가설명 및 특이사항

회원 우선구매권한 수정 API 입니다.

**파라미터**:

| 이름         | 위치   | 타입   | 필수 | 설명         |
| ------------ | ------ | ------ | ---- | ------------ |
| permissionNo | path   | string | ✅   | 구매권한번호 |
| systemKey    | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### PUT /purchase-permission/product/{permissionNo}

**요약**: 상품우선구매권한 수정하기

**설명**:

## 부가설명 및 특이사항

상품 우선구매권한 수정 API 입니다.

**파라미터**:

| 이름         | 위치   | 타입   | 필수 | 설명         |
| ------------ | ------ | ------ | ---- | ------------ |
| permissionNo | path   | string | ✅   | 구매권한번호 |
| systemKey    | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### DELETE /purchase-permission/{permissionNo}/members

**요약**: 회원우선구매권한 삭제하기

**설명**:

## 부가설명 및 특이사항

회원 우선구매권한 삭제 API 입니다.

**파라미터**:

| 이름         | 위치   | 타입   | 필수 | 설명         |
| ------------ | ------ | ------ | ---- | ------------ |
| permissionNo | path   | string | ✅   | 구매권한번호 |
| memberNos    | query  | string | ✅   | 회원번호     |
| systemKey    | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  (nullable) |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

(nullable) |
| version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---
