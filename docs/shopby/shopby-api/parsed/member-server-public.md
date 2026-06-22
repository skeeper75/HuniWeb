# member-server

**버전**: 1.0
**서버**: https://server-api.e-ncp.com

쇼핑몰 회원(member) 관련 server API입니다.

---

## Configuration

### PATCH /configurations/member/app-card

**요약**: 앱카드 storeId 수정

**설명**:
앱카드 storeId 수정

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### GET /configurations/member/common-join-config

**요약**: 회원가입항목 config 조회

**설명**:
회원가입항목 config 조회

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### GET /configurations/member/extra-info-config

**요약**: 추가항목 config 조회

**설명**:
추가항목 config 조회

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### GET /configurations/member/open-id/{providerType}

**요약**: 프로바이더별 간편회원가입 config 조회

**설명**:
프로바이더별 간편회원가입 config 조회

**파라미터**:

| 이름         | 위치   | 타입   | 필수 | 설명                                                                            |
| ------------ | ------ | ------ | ---- | ------------------------------------------------------------------------------- |
| providerType | path   | string | ✅   | 프로바이더 타입(PAYCO, NAVER, KAKAO, KAKAO_SYNC, FACEBOOK, LINE, APPLE, GOOGLE) |
| systemKey    | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### PATCH /configurations/member/open-id/{providerType}

**요약**: 프로바이더별 간편회원가입 config 수정

**설명**:
프로바이더별 간편회원가입 config 수정

**파라미터**:

| 이름         | 위치   | 타입   | 필수 | 설명                                                                                      |
| ------------ | ------ | ------ | ---- | ----------------------------------------------------------------------------------------- |
| providerType | path   | string | ✅   | 프로바이더 타입(PAYCO, NAVER, KAKAO, KAKAO_SYNC, FACEBOOK, LINE, APPLE, GOOGLE, APP_CARD) |
| systemKey    | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

## MemberGrade

### GET /grades

**요약**: 회원등급 목록 조회하기

**설명**:

## 부가설명 및 특이사항

회원등급 목록을 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### PUT /profile/grades

**요약**: 회원등급 수정하기

**설명**:

## 부가설명 및 특이사항

회원들의 회원등급을 수정합니다. (최대: 1000명)
issueCoupon이 true 인 경우, 회원등급 쿠폰을 발행합니다.
issueCoupon이 null 인 경우, false로 간주합니다. (default: null)

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

## Group

### GET /member-groups

**요약**: 회원 그룹 목록 조회

**설명**:

## 부가설명 및 특이사항

회원 그룹 목록을 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### POST /member-groups

**요약**: 회원 그룹 생성

**설명**:

## 부가설명 및 특이사항

회원 그룹을 생성합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **201**: 201

---

### GET /member-groups/{groupNo}

**요약**: 회원 그룹 단건 조회

**설명**:

## 부가설명 및 특이사항

회원 그룹을 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입    | 필수 | 설명           |
| --------- | ------ | ------- | ---- | -------------- |
| groupNo   | path   | integer | ✅   | 회원 그룹 번호 |
| systemKey | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### PUT /member-groups/{groupNo}

**요약**: 회원 그룹 수정

**설명**:

## 부가설명 및 특이사항

회원 그룹을 수정합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| groupNo   | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### DELETE /member-groups/{groupNo}

**요약**: 회원 그룹 삭제

**설명**:

## 부가설명 및 특이사항

회원 그룹을 삭제합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| groupNo   | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

## Member

### GET /members

**요약**: 회원 목록 조회하기 V1.2

**설명**:

## 부가설명 및 특이사항

회원 목록을 조회합니다.

- searchType 기본설정값은 `USER_ID` 입니다.
- 가입일자, 수정일자 둘 중 하나는 반드시 입력해야 합니다.
- 마지막 로그인일자 기간 검색 시, 회원 가입일자 기간을 필수로 입력해야 하고 각각 1년 이내 범위만 검색이 가능합니다.

## V1.2

- header의 Version을 1.2로 해주세요
- includesCount 값을 false 로 하면 조회 속도가 향상됩니다.
- keySet search 방식 지원 : searchAfter 필수 (최초 조회 시 생략 가능. response의 lastId 값 사용.)

**파라미터**:

| 이름               | 위치   | 타입    | 필수 | 설명                                                                                                       |
| ------------------ | ------ | ------- | ---- | ---------------------------------------------------------------------------------------------------------- |
| includesCount      | query  | string  | ❌   | totalCount 포함 여부 - 기본값 false - 1.2에서만 지원 (nullable)                                            |
| searchAfter        | query  | string  | ❌   | keySet search 방식 검색의 경우 searchAfter 값 필수(첫 페이지 검색시 생략 가능) - 1.2에서만 지원 (nullable) |
| searchType         | query  | string  | ❌   | 검색 유형 (MEMBER_NO, USER_ID, EMAIL, MOBILE, NAME, NICKNAME) (nullable)                                   |
| startSignUpDate    | query  | string  | ❌   | 가입일자 검색 시작일 (yyyy-MM-dd) (nullable)                                                               |
| endSignUpDate      | query  | string  | ❌   | 가입일자 검색 종료일 (yyyy-MM-dd) (nullable)                                                               |
| startUpdateDate    | query  | string  | ❌   | 수정일자 검색 시작일 (yyyy-MM-dd) (nullable)                                                               |
| endUpdateDate      | query  | string  | ❌   | 수정일자 검색 종료일 (yyyy-MM-dd) (nullable)                                                               |
| startLastLoginDate | query  | string  | ❌   | 마지막로그인일자 검색 시작일 (yyyy-MM-dd) (nullable)                                                       |
| endLastLoginDate   | query  | string  | ❌   | 마지막로그인일자 검색 종료일 (yyyy-MM-dd) (nullable)                                                       |
| keywords           | query  | string  | ❌   | 검색어 (최대 100개) (nullable)                                                                             |
| status             | query  | string  | ❌   | 회원상태 (nullable)                                                                                        |
| type               | query  | string  | ❌   | 회원타입 (nullable)                                                                                        |
| blacklisted        | query  | boolean | ❌   | 블랙리스트 여부 (nullable)                                                                                 |
| emailAgreed        | query  | boolean | ❌   | 이메일 수신 동의 여부 (nullable)                                                                           |
| smsAgreed          | query  | boolean | ❌   | SMS 수신 동의 여부 (nullable)                                                                              |
| gradeNo            | query  | number  | ❌   | 등급 번호 (nullable)                                                                                       |
| groupNo            | query  | number  | ❌   | 그룹 번호 (nullable)                                                                                       |
| pageNumber         | query  | number  | ❌   | 페이지 번호 - 1.2에서만 지원 (nullable)                                                                    |
| pageSize           | query  | number  | ❌   | 페이지 사이즈 (기본 10, 최대 10000) - 1.2에서만 지원 (nullable)                                            |
| systemKey          | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.2 |

**응답**:

- **200**: 200

---

### GET /members/expelled-members

**요약**: 탈퇴 회원 조회하기 V1.1

**설명**:

## 부가설명 및 특이사항

특정 날짜에 탈퇴한 회원을 조회합니다.
응답 목록은 탈퇴시간 순으로 정렬되어 노출됩니다.
회원 탈퇴 후 5일이 지나면 회원 정보를 파기하기 때문에 과거 날짜로 검색할 시 결과가 없을 수 있습니다.

## Ver 1.0

- MemberType = [MALL: 쇼핑몰 회원, OPENID: 연동형 회원, NEOID: 간편로그인 회원]
- MemberStatus = [WAITING: 대기, ACTIVE: 가입완료, FREEZE or DORMANT: 휴면 , PAUSED :이용정지]

## Ver 1.1

- MemberType = [MALL: 쇼핑몰 회원, SYNC_ID: 연동형 회원, OPEN_ID: 간편로그인 회원]
- MemberStatus = [WAITING: 대기, ACTIVE: 가입완료, WITHDRAWN: 탈퇴, FREEZE or DORMANT: 휴면 , PAUSED :이용정지, PENDING: 승인대기]

**파라미터**:

| 이름               | 위치   | 타입    | 필수 | 설명                 |
| ------------------ | ------ | ------- | ---- | -------------------- | ---------- |
| targetDate         | query  | string  | ✅   | 회원 탈퇴일시^       | 2025-10-28 |
| memberType         | query  | string  | ❌   | 회원 타입 (nullable) |
| additionalInfoUsed | query  | boolean | ❌   | 추가 정보 사용 여부^ | true       |
| systemKey          | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### POST /members/external

**요약**: 외부회원연동 회원가입

**설명**:

## 부가설명 및 특이사항

외부회원연동 회원가입

자체회원연동(=외부회원연동) 을 사용하는 몰의 회원을 직접 가입시키는 API 입니다.

자체회원연동 이후, 아래 가이드의 응답값을 이용하여 쇼핑몰 회원가입을 진행합니다.
[자체회원 연동 가이드](https://workspace-help.nhn-commerce.com/recommendedcontents/contents/prm_member_guide)

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### POST /members/prohibit

**요약**: 회원 이용 정지

**설명**:

## 부가설명 및 특이사항

회원 이용 정지

- 알림 종류 : KAKAO | SMS | EMAIL | ALL,
- 변경시킬 회원 상태:
  PAUSED : 일시정지
  BLOCKED : 영구정지

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

## Profile

### GET /profile

**요약**: 회원 정보 조회하기

**설명**:

## 부가설명 및 특이사항

회원 정보를 조회합니다.

**파라미터**:

| 이름                   | 위치   | 타입   | 필수 | 설명                                    |
| ---------------------- | ------ | ------ | ---- | --------------------------------------- |
| memberId               | query  | string | ❌   | 아이디 (회원 조회용) (nullable)         |
| memberNo               | query  | number | ❌   | 회원 번호 (회원 조회용) (nullable)      |
| oauthIdNo              | query  | string | ❌   | oauth 인증번호 (회원 조회용) (nullable) |
| email                  | query  | string | ❌   | 이메일 (회원 조회용) (nullable)         |
| representativeMemberNo | query  | number | ❌   | 대표몰회원번호 (회원 조회용) (nullable) |
| systemKey              | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### PUT /profile

**요약**: 회원 정보 수정하기

**설명**:

## 부가설명 및 특이사항

회원 정보를 수정합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### DELETE /profile

**요약**: 회원 탈퇴 시키기

**설명**:

## 부가설명 및 특이사항

특정 회원을 탈퇴시킵니다.
memberNo 혹은 memberId 혹은 oauthIdNo 셋중 하나는 필수입니다

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                           |
| --------- | ------ | ------ | ---- | ------------------------------ |
| memberId  | query  | string | ❌   | 회원 아이디 (nullable)         |
| memberNo  | query  | number | ❌   | 회원 번호 (nullable)           |
| oauthIdNo | query  | string | ❌   | oauth 인증 일련번호 (nullable) |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /profile/blocked-release

**요약**: 차단 회원 해제

**설명**:

## 부가설명 및 특이사항

차단자(=blocker)가 차단한 회원(=blocked)을 차단 해제합니다.
대상 회원번호(=targetMemberNo) 혹은 대상 회원아이디(=targetMemberId) 둘 중 하나는 존재해야합니다.

##

| name           |  type   | required | default value | description           |
| :------------- | :-----: | :------: | :-----------: | :-------------------- |
| memberNo       | integer |    Y     |       -       | 차단자 회원번호       |
| targetMemberNo | integer |    N     |       -       | 차단 대상 회원 번호   |
| targetMemberId | string  |    N     |       -       | 차단 대상 회원 아이디 |

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /profile/bulk

**요약**: 대량 회원 정보 수정하기

**설명**:

## 부가설명 및 특이사항

대량의 회원 정보를 수정합니다.
최대 1000명의 회원까지 가능합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### POST /profile/bulk-delete

**요약**: 복수의 회원 탈퇴 처리하기

**설명**:

## 부가설명 및 특이사항

최대 500명의 회원을 동시에 탈퇴시킵니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### GET /profile/dormant

**요약**: 휴면 회원 조회하기 V1.1

**설명**:

## 부가설명 및 특이사항

휴면 상태의 회원을 조회합니다

개인정보 보호법에 따라 2021년 8월 1일부터 분리보관된 휴면 회원의 개인정보를 제공하지 않도록 변경됩니다.

- 아이디: 일반 아이디는 기존과 동일하게 제공되지만, 이메일 형식의 아이디는 '@' 이후의 도메인이 마스킹되어 제공됩니다.
- 이메일: 삭제

## Ver 1.0

- MemberType = [MALL: 쇼핑몰 회원, OPENID: 연동형 회원, NEOID: 간편로그인 회원]
- MemberStatus = [WAITING: 대기, ACTIVE: 가입완료, FREEZE or DORMANT: 휴면 , PAUSED :이용정지]
- page = 페이지 번호
- pageSize = 페이지 사이즈

## Ver 1.1

- MemberType = [MALL: 쇼핑몰 회원, SYNC_ID: 연동형 회원, OPEN_ID: 간편로그인 회원]
- MemberStatus = [WAITING: 대기, ACTIVE: 가입완료, WITHDRAWN: 탈퇴, FREEZE or DORMANT: 휴면 , PAUSED :이용정지, PENDING: 승인대기]
- page = 페이지 번호 (Ver 1.0 과 동일)
- size = 페이지 사이즈 (pageSize -> size 로 변동)

**파라미터**:

| 이름             | 위치   | 타입    | 필수 | 설명                        |
| ---------------- | ------ | ------- | ---- | --------------------------- | ---------- |
| page             | query  | integer | ❌   | 페이지 번호 (1 based index) |
| size             | query  | integer | ❌   | 페이지 사이즈               |
| startDormantDate | query  | string  | ✅   | 휴면전환일시 검색 시작일^   | 2025-10-28 |
| endDormantDate   | query  | string  | ✅   | 휴면전환일시 검색 종료일^   | 2025-10-28 |
| systemKey        | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### PUT /profile/dormant

**요약**: 휴면 회원 전환하기

**설명**:

## 부가설명 및 특이사항

휴면 회원으로 전환합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                      |
| --------- | ------ | ------ | ---- | ------------------------- |
| memberId  | query  | string | ❌   | 회원 아이디 (회원 조회용) |
| memberNo  | query  | number | ❌   | 회원 번호 (회원 조회용)   |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /profile/dormant-release

**요약**: 휴면 회원 해제

**설명**:

## 부가설명 및 특이사항

회원의 휴면 상태를 해제합니다.
회원 아이디 혹은 회원번호, 둘 중 하나는 존재해야합니다.

##

| name     |  type   | required | default value | description |
| :------- | :-----: | :------: | :-----------: | :---------- |
| mallNo   | integer |    Y     |       -       | 쇼핑몰 번호 |
| memberId | string  |    N     |       -       | 회원 아이디 |
| memberNo | integer |    N     |       -       | 회원 번호   |

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### GET /profile/groups

**요약**: 회원의 그룹 조회

**설명**:

## 부가설명 및 특이사항

회원의 그룹을 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                 |
| --------- | ------ | ------ | ---- | ------------------------------------ |
| memberNo  | query  | string | ❌   | 회원 번호 (회원 조회용) (nullable)   |
| memberId  | query  | string | ❌   | 회원 아이디 (회원 조회용) (nullable) |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### POST /profile/groups

**요약**: 회원을 그룹에 추가하기

**설명**:

## 부가설명 및 특이사항

회원을 그룹을 추가합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **201**: 201

---

### DELETE /profile/groups

**요약**: 회원을 그룹에서 삭제하기

**설명**:

## 부가설명 및 특이사항

회원을 그룹에서 삭제합니다.

**파라미터**:

| 이름          | 위치   | 타입   | 필수 | 설명                                 |
| ------------- | ------ | ------ | ---- | ------------------------------------ |
| memberNo      | query  | string | ❌   | 회원 번호 (회원 조회용) (nullable)   |
| memberId      | query  | string | ❌   | 회원 아이디 (회원 조회용) (nullable) |
| memberGroupNo | query  | string | ❌   | 회원 그룹 번호 (nullable)            |
| systemKey     | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### DELETE /profile/logout

**요약**: 회원 로그아웃 시키기

**설명**:

## 부가설명 및 특이사항

회원을 로그아웃 처리 합니다.
회원번호 혹은 oauthId 둘 중 하나는 존재해야합니다.

##

| name      |  type   | required | default value | description         |
| :-------- | :-----: | :------: | :-----------: | :------------------ |
| oauthIdNo | string  |    N     |       -       | oauth 인증 일련번호 |
| memberNo  | integer |    N     |       -       | 회원 번호           |

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                           |
| --------- | ------ | ------ | ---- | ------------------------------ |
| oauthIdNo | query  | string | ❌   | oauth 인증 일련번호 (nullable) |
| memberNo  | query  | number | ❌   | 회원 번호 (nullable)           |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /profile/restore

**요약**: 회원 탈퇴 철회시키기

**설명**:

## 부가설명 및 특이사항

특정 회원의 탈퇴를 철회 시킵니다.
(단, 이미 삭제된 회원인 경우, 탈퇴 철회가 불가능합니다.)
memberNo 혹은 memberId 혹은 oauthIdNo 셋중 하나는 필수입니다

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                           |
| --------- | ------ | ------ | ---- | ------------------------------ |
| memberId  | query  | string | ❌   | 회원 아이디 (nullable)         |
| memberNo  | query  | number | ❌   | 회원 번호 (nullable)           |
| oauthIdNo | query  | string | ❌   | oauth 인증 일련번호 (nullable) |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer authorizationToken |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>
Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>
(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---
