# promotion-server

**버전**: 0.1.0-SNAPSHOT
**서버**: https://server-api.e-ncp.com

프로모션 혜택(promotion)관련 server API입니다.

---

## Coupon

### GET /coupons

**요약**: 쿠폰 검색하기

**설명**:

## 부가설명 및 특이사항

검색 조건을 기반으로 쇼핑몰이 가지고 있는 쿠폰 정보를 검색합니다.

couponNos에 입력한 쿠폰번호 리스트와 keyword로 입력한 쿠폰번호는 AND 조건으로 검색됩니다.

**파라미터**:

| 이름                 | 위치   | 타입    | 필수 | 설명                                                                                                                                                                            |
| -------------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| page                 | query  | integer | ✅   | 페이지 번호^                                                                                                                                                                    | 1                   |
| size                 | query  | integer | ✅   | 페이지 크기^                                                                                                                                                                    | 30                  |
| searchDateType       | query  | string  | ✅   | 날짜 검색 타입(REGISTER_YMD: 등록일, ISSUE_START_YMD: 발행시작일, ISSUE_END_YMD: 발행종료일, UPDATE_YMD: 수정일)^                                                               | REGISTER_YMD        |
| startYmd             | query  | string  | ✅   | 조회 시작일^                                                                                                                                                                    | 2025-06-29          |
| endYmd               | query  | string  | ✅   | 조회 종료일^                                                                                                                                                                    | 2025-09-29          |
| issueType            | query  | string  | ❌   | 쿠폰 발급 타입(DOWNLOAD: 다운로드 발급, CODE_DESIGNATE: 지정코드 발급, CODE_RANDOM: 난수코드 발급, INSERT: 인서트 발급, CODE_DESIGNATE_ADMIN_ONLY: 지정코드 발급(어드민 전용))^ | DOWNLOAD            |
| couponType           | query  | string  | ❌   | 혜택 구분 타입(PRODUCT: 상품적용 쿠폰, PRODUCT_PLUS: 상품 금액 할인(플러스), CART: 주문적용 쿠폰, CART_DELIVERY: 장바구니 배송비 할인, GIFT: 기프트 쿠폰)^                      | CART                |
| statusTypes          | query  | string  | ❌   | 쿠폰 상태 타입 리스트(ISSUE_READY: 발급대기, ISSUE_ING: 발급 중, ISSUE_STOP: 발급중지, ISSUE_END: 발급종료)^                                                                    | ISSUE_ING,ISSUE_END |
| searchKeywordType    | query  | string  | ❌   | 검색어 타입(ALL: 전체, COUPON_NAME: 쿠폰명, COUPON_NO: 쿠폰번호, REGISTER_ADMIN: 등록자)^                                                                                       | COUPON_NO           |
| keyword              | query  | string  | ❌   | 검색어^                                                                                                                                                                         | 검색어              |
| couponNos            | query  | string  | ❌   | 쿠폰번호 리스트^                                                                                                                                                                | 1,2,3               |
| exceptIssueEndCoupon | query  | boolean | ❌   | 사용불가 쿠폰 제외 여부 (true: 사용불가 쿠폰 제외, false: 사용불가 쿠폰 포함)^                                                                                                  | false               |
| memberGradeNo        | query  | number  | ❌   | 회원 등급 번호^                                                                                                                                                                 | 1                   |
| memberGroupNo        | query  | number  | ❌   | 회원 그룹 번호^                                                                                                                                                                 | 1                   |
| systemKey            | header | string  | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키)                                                                                                                           |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### POST /coupons

**요약**: 쿠폰 생성하기

**설명**:

## 부가설명 및 특이사항

쿠폰을 신규 생성합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- |
| systemKey | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### GET /coupons/codes

**요약**: 쿠폰 랜덤코드 조회하기 (개발중)

**설명**:

## 부가설명 및 특이사항

코드 발급(자동생성) 유형의 쿠폰 랜덤코드를 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입    | 필수 | 설명                                                  |
| --------- | ------ | ------- | ---- | ----------------------------------------------------- | ---- |
| couponNos | query  | integer | ✅   | 쿠폰 번호 리스트^                                     | 1    |
| page      | query  | integer | ✅   | 페이지 번호^                                          | 1    |
| size      | query  | integer | ✅   | 페이지 크기^                                          | 30   |
| issued    | query  | boolean | ✅   | 회원 발급 여부 (true: 발급, false: 미발급)^           | true |
| systemKey | header | string  | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### GET /coupons/exclude-targets

**요약**: 쿠폰의 제외 대상 조회

**설명**:

## 부가설명 및 특이사항

쿠폰 번호를 입력받아 쿠폰의 제외 대상을 조회합니다.

쿠폰 번호를 입력하지 않는 경우, 해당 쇼핑몰 전체를 대상으로 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입    | 필수 | 설명                                                  |
| --------- | ------ | ------- | ---- | ----------------------------------------------------- | ----- |
| couponNos | query  | string  | ❌   | 쿠폰 번호 목록^                                       | 1,2,3 |
| page      | query  | integer | ❌   | 페이지 번호 (1 이상)^                                 | 1     |
| size      | query  | integer | ❌   | 페이지 크기^                                          | 30    |
| systemKey | header | string  | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### GET /coupons/targets

**요약**: 쿠폰의 대상 조회

**설명**:

## 부가설명 및 특이사항

쿠폰 번호를 입력받아 쿠폰의 대상을 조회합니다.

쿠폰 번호를 입력하지 않는 경우, 해당 쇼핑몰 전체를 대상으로 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입    | 필수 | 설명                                                  |
| --------- | ------ | ------- | ---- | ----------------------------------------------------- | ----- |
| couponNos | query  | string  | ❌   | 쿠폰 번호 목록^                                       | 1,2,3 |
| page      | query  | integer | ❌   | 페이지 번호 (1 이상)^                                 | 1     |
| size      | query  | integer | ❌   | 페이지 크기^                                          | 30    |
| systemKey | header | string  | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### PUT /coupons/withdraw

**요약**: 쿠폰 철회

**설명**:

## 부가설명 및 특이사항

쿠폰 지급 번호를 입력받아 발급된 쿠폰을 철회합니다.

`사용 가능` 상태인 쿠폰이면 발급된 위치에 상관없이 철회할 수 있습니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- |
| systemKey | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /coupons/withdraw-bulk

**요약**: 쿠폰 번호로 쿠폰 지급 철회하기

**설명**:

## 부가설명 및 특이사항

입력받은 쿠폰번호로 지급된 모든 쿠폰을 철회합니다.
10만건 이상은 해당 api 사용하지 마시고 1:1 문의 요청 바랍니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- |
| systemKey | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### GET /coupons/{couponNo}

**요약**: 쿠폰 정보 조회하기

**설명**:

## 부가설명 및 특이사항

하나의 쿠폰에 대한 상세 정보를 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| couponNo  | path   | number | ✅   | 쿠폰 번호^                                            | 1   |
| systemKey | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### PUT /coupons/{couponNo}

**요약**: 쿠폰 수정하기

**설명**:

## 부가설명 및 특이사항

쿠폰 상세 정보를 수정합니다.

발행 전/후 수정할 수 있는 항목이 다릅니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| couponNo  | path   | number | ✅   | 쿠폰 번호^                                            | 1   |
| systemKey | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /coupons/{couponNo}/use-stop

**요약**: 쿠폰 사용 중지/재개

**설명**:

## 부가설명 및 특이사항

쿠폰을 사용 중지 또는 재개 처리 합니다

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- |
| couponNo  | path   | string | ✅   | -                                                     |
| systemKey | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

## CouponIssue

### GET /coupons/issues

**요약**: 지급된 쿠폰 검색하기

**설명**:

## 부가설명 및 특이사항

회원에게 지급된 쿠폰 정보를 조회합니다.

memberNos, memberIds, couponNos, couponIssueNos 중 적어도 하나의 필드에는 값을 입력해야 합니다.
couponIssueNos (쿠폰 지급 번호) 입력 시 startYmd/endYmd 값을 입력하지 않아도 조회할 수 있습니다.
couponIssueNos 입력하지 않는 경우 startYmd/endYmd 값을 필수로 입력해야 합니다.

**파라미터**:

| 이름           | 위치   | 타입    | 필수 | 설명                                                                                                                          |
| -------------- | ------ | ------- | ---- | ----------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| memberNos      | query  | string  | ❌   | 회원 번호 목록^                                                                                                               | 1,2,3             |
| memberIds      | query  | string  | ❌   | 회원 ID 목록^                                                                                                                 | test1,test2,test3 |
| couponNos      | query  | string  | ❌   | 쿠폰 번호 목록^                                                                                                               | 1,2,3             |
| couponIssueNos | query  | string  | ❌   | 쿠폰 지급 번호 목록^                                                                                                          | 1,2,3             |
| searchDateType | query  | string  | ✅   | 날짜검색타입(ISSUE_START_YMD: 쿠폰발행시작일, ISSUE_END_YMD: 쿠폰발행종료일, ISSUE_YMD: 쿠폰지급일, USE_END_YMD: 쿠폰만료일)^ | ISSUE_YMD         |
| startYmd       | query  | string  | ✅   | 조회 시작일^                                                                                                                  | 2025-06-29        |
| endYmd         | query  | string  | ✅   | 조회 종료일^                                                                                                                  | 2025-09-29        |
| page           | query  | integer | ✅   | 페이지 번호^                                                                                                                  | 1                 |
| size           | query  | integer | ✅   | 페이지 크기 (최대 10,000)^                                                                                                    | 30                |
| systemKey      | header | string  | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키)                                                                         |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### POST /coupons/issues

**요약**: 회원번호와 쿠폰번호로 쿠폰 발급하기

**설명**:

## 부가설명 및 특이사항

회원정보, 쿠폰번호를 기반으로 쿠폰을 발행합니다.

해당 API로 쿠폰 발급하는 경우에는 쿠폰 발급 상태, 쿠폰 발급 제한 수량을 검증하지 않습니다.

memberNos 필드와 memberIds 필드는 동시 요청 시 400 error가 발생합니다. 하나의 필드에만 값을 입력해야 합니다.

response의 크기는 request의 (회원 수 \* 쿠폰 수)와 같거나 작을 수 있습니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- |
| systemKey | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

## CouponUse

### GET /coupons/use

**요약**: 사용된 쿠폰 정보 검색하기

**설명**:

## 부가설명 및 특이사항

이미 사용된 쿠폰 정보를 검색합니다.

**파라미터**:

| 이름              | 위치   | 타입    | 필수 | 설명                                                  |
| ----------------- | ------ | ------- | ---- | ----------------------------------------------------- | ------------------------------------ |
| keyword           | query  | string  | ✅   | 검색어^                                               | 123                                  |
| searchKeywordType | query  | string  | ✅   | 검색어타입[ORDER_NO, COUPON_NO]^                      | ORDER_NO                             |
| page              | query  | integer | ✅   | 페이지 번호 (1 이상)^                                 | 1                                    |
| size              | query  | integer | ✅   | 페이지 사이즈^                                        | 100                                  |
| searchDateType    | query  | string  | ❌   | 날짜 검색 타입^                                       | [ISSUE_YMD: 지급일, USE_YMD: 사용일] |
| startYmd          | query  | string  | ❌   | 검색 시작일^                                          | 2024-09-12                           |
| endYmd            | query  | string  | ❌   | 검색 종료일^                                          | 2024-09-14                           |
| systemKey         | header | string  | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### POST /coupons/use

**요약**: 쿠폰 사용하기

**설명**:

## 부가설명 및 특이사항

발급된 쿠폰을 사용처리하여 이후에 주문에 사용하지 못하도록 할때 사용합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- |
| systemKey | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### POST /coupons/use/rollback

**요약**: 쿠폰 취소하기(오프라인 전용)

**설명**:
쿠폰 취소하기(오프라인 전용)

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- |
| systemKey | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ | 인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)
- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />
Authorization을을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />
Authorization을 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />
^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---
