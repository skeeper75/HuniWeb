# admin-server

**버전**: 1.0
**서버**: https://server-api.e-ncp.com

server API란? 외부 시스템에서 shop by와 연동하는 등 shop by서버에 저장된 데이터를 또 따른 서버에서 호출할 때 사용할 수 있는 API입니다.
기본 정보 관리(admin) 관련 server API입니다.

---

## Admin

### GET /admins

**요약**: 샵바이 어드민 권한 조회

**설명**:
샵바이에 등록된 어드민의 권한 정보를 조회한다.
MASTER 어드민일 경우 권한이 존재하지 않습니다.
MASTER 어드민을 조회 할 경우 권한그룹: "", 개인정보 권한: true 로 응답됩니다.

Authorization 은 필수값입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /admins/merchandisers

**요약**: 쇼핑몰 상품담당 MD 운영자 조회

**설명**:
특정 쇼핑몰의 상품담당 MD 운영자를 조회하는 API 입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /admins/{adminNo}

**요약**: 샵바이 어드민 조회

**설명**:

### 어드민 상태

- WAITING: 등록대기
- INVESTIGATION: 검토중
- ACTIVE: 등록완료
- DELETE: 삭제
- LOCKED: 로그인 잠금
- DORMANT: 휴면

### 어드민 권한

- MASTER: 마스터
- NORMAL: 일반

### 어드민 타입

- PLATFORM: 플랫폼 어드민
- SERVICE: 서비스 어드민
- PARTNER: 파트너 어드민
- SHOPBY: 샵바이 어드민
- DEVELOPER: 개발자

샵바이에 등록된 어드민 정보를 조회한다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명        |
| --------- | ------ | ------ | ---- | ----------- |
| adminNo   | path   | string | ✅   | 어드민 번호 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

## Mall-Domain

### GET /configurations/admin/domains

**요약**: 몰 도메인 조회

**설명**:

### 몰 도메인 정보를 조회 합니다.

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                         |
| ---------- | ------ | ------ | ---- | -------------------------------------------- |
| deviceType | query  | string | ❌   | 디바이스 타입. 없으면 전체검색 (PC / MOBILE) |
| systemKey  | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

## Contract

### GET /contracts

**요약**: 계약서 조회하기

**설명**:
계약서를 조회한다.

#### 정산 유형

- DAY: 일 정산
- WEEK: 주 정산
- MONTH: 월 정산

#### 정산 타입

- TOMORROW: 전일
- YESTERDAY: 익일

#### 정산요일

[MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY]

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                |
| ---------- | ------ | ------ | ---- | ----------------------------------- |
| page       | query  | number | ❌   | 페이지 번호                         |
| pageSize   | query  | number | ❌   | 페이지 사이즈                       |
| partnerNos | query  | string | ❌   | 파트너 번호들(미입력 시, 전체 조회) |
| systemKey  | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### POST /contracts

**요약**: 신규 계약 등록하기

**설명**:

등록되어있는 파트너와 신규 계약을 등록한다.
이미 쇼핑몰 - 파트너간 계약관계가 존재한다면 새로 등록할 수 없다.

- memo 는 필수값이 아님
- contractContent는 입점계약서를 사용할 경우 필수

#### 정산 유형

- DAY: 일 정산
- WEEK: 주 정산
- MONTH: 월 정산

#### 정산 타입

- TOMORROW: 전일
- YESTERDAY: 익일

#### 정산요일

[MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY]

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### PUT /contracts

**요약**: 계약서 상태 수정하기

**설명**:
몰과 파트너간의 계약 상태를 수정한다.

#### 계약 상태

- APPROVAL: 계약 동의
- DISAPPROVAL: 계약 반려
- SUSPEND: 계약 일시정지
- UNSUSPEND: 계약 일시정지 해제

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### GET /contracts/{partnerNo}

**요약**: 계약서 상세 조회하기

**설명**:

쇼핑몰 - 파트너간의 계약정보 상세 조회

### 거래 유형

- ELECTRONIC: 전자계약
- HANDWRITING: 수기계약

### 거래 상태

- WAITING: 거래대기
- INVESTIGATION: 검토중
- ACTIVE: 거래중
- SUSPEND: 일시중지

#### 정산 유형

- DAY: 일 정산
- WEEK: 주 정산
- MONTH: 월 정산

#### 정산 타입

- TOMORROW: 전일
- YESTERDAY: 익일

#### 정산요일

[MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY]

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| partnerNo | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /contracts/{partnerNo}

**요약**: 계약서 수정하기

**설명**:
계약서를 수정한다.

#### 정산 유형

- DAY: 일 정산
- WEEK: 주 정산
- MONTH: 월 정산

#### 정산 타입

- TOMORROW: 전일
- YESTERDAY: 익일

#### 정산요일

[MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY]

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| partnerNo | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

## Currency

### GET /currencies

**요약**: 몰 환율 설정 조회

**설명**:

몰의 환율 설정을 조회한다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /currencies/{currencyCode}

**요약**: 몰 환율 설정 수정

**설명**:

몰의 환율 설정을 수정한다.

**파라미터**:

| 이름         | 위치   | 타입   | 필수 | 설명                      |
| ------------ | ------ | ------ | ---- | ------------------------- |
| currencyCode | path   | string | ✅   | 통화 - CNY, USD, JPY, KRW |
| systemKey    | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

## Mall

### GET /malls

**요약**: 쇼핑몰 상세 조회

**설명**:

### Mall 정보를 조회 합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /malls/shopby-partner

**요약**: 쇼핑몰 자체 파트너 조회

**설명**:

### 몰의 쇼핑몰 자체 파트너를 조회하는 API입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

## Partner

### GET /malls/contracts/partners

**요약**: 계약된 파트너 정보 조회하기

**설명**:

## 부가설명 및 특이사항

mallKey를 기준으로 계약된 파트너 정보를 조회하는 API 입니다.

mallKey는 반드시 입력해야하며 파트너 번호가 없는 경우 모든 파트너에 대해 조회합니다.

#### 정산 유형

- DAY: 일 정산
- WEEK: 주 정산
- MONTH: 월 정산

#### 정산 타입

- TOMORROW: 전일
- YESTERDAY: 익일

#### 정산 요일

[MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY]

**파라미터**:

| 이름               | 위치   | 타입   | 필수 | 설명             |
| ------------------ | ------ | ------ | ---- | ---------------- |
| partnerNos         | query  | string | ❌   | 파트너 번호 목록 |
| partnerMappingKeys | query  | string | ❌   | 파트너 매핑키    |
| systemKey          | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### POST /partners

**요약**: 파트너 등록하기

**설명**:

## 부가설명 및 특이사항

쇼핑몰에 파트너를 등록하는 API 입니다.

- 국내 파트너사에 경우에만 API로 파트너 등록 가능합니다. 해외 파트너사는 서비스어드민을 통해서 등록하시기 바랍니다.
- API로 파트너를 등록하는 경우 개인정보 수집 및 이용 동의 절차를 진행하지 않기에 파트너사에 별도로 개인정보 수집 및 이용 동의를 받아야 합니다.
- API로 파트너 등록 시 입점 계약서는 '사용 안 함' 상태로 등록됩니다.
  - 입점 계약서 사용을 원하시는 경우 파트너 등록 후 [서비스어드민> 파트너관리> 파트너조회]에서 해당 파트너사의 거래쇼핑몰 '계약등록'하시면 됩니다.
- API로 파트너 등록 시 마스터운영자 휴대폰 번호는 본인인증 절차 없이 등록됩니다.
  - 휴대폰 번호를 잘못 입력한 경우 '운영자 휴대폰 인증'이 되지 않기에 유효하지 않은 휴대폰번호가 등록되는 일이 없도록 꼭 확인하시기 바랍니다.
- 비밀번호가 공유되지 않도록 파트너 등록 후 파트너사 운영자에게 비밀번호를 수정할 수 있도록 안내 부탁드립니다.

## 참고

입력 항목에 대한 설명은 'API업데이트 > [신규] 파트너 등록하기 API - 추가'에서 확인하실 수 있습니다. [API업데이트 게시판 바로가기 >](https://workspace.nhn-commerce.com/apiUpdate)

- merchandiserNo(담당MD) :운영자번호 번호 입력 (거래쇼핑몰 권한 + 상품MD 권한이 있는 운영자만 지정 가능)
  - 서비스어드민> 서비스관리> 운영자 관리에서 운영자번호 확인 가능합니다.

- id(마스터 운영자 어드민 아이디) :
  - 중복불가 [어드민 아이디 중복 체크하기 API >](https://server-docs.shopby.co.kr/#/Partner/get-partners-exist-admin-id)
  - id 시작은 소문자로시작해야 합니다.
  - 그 뒤에는 영문 대소문자와 숫자로 구성된 4자에서 19자 사이의 문자열이 와야 합니다.
  - 전체 길이는 최소 5자(첫 소문자 + 4자)에서 최대 20자(첫 소문자 + 19자)입니다.
- partnerName(파트너명) : 중복불가 : [파트너명 중복 체크하기 API >](https://server-docs.shopby.co.kr/#/Partner/get-partners-exist-partner-name)
- bank(은행코드) : [은행코드 바로가기 >](https://workspace.nhn-commerce.com/support/recommendedContents/193355)
  - 은행코드를 제공하지 않는 은행인 경우 null로 입력 후 bankName(은행명)에 은행명을 기입하시기 바랍니다.

- bankName(은행명) :
  - bank(은행코드)에 은행코드를 입력한 경우 null로 입력
  - bank(은행코드) null로 입력한 경우 은행명 입력
- 이메일 유효성 검사 조건
  - 로컬 파트(@ 앞쪽): 허용되는 특수 문자(.!#-'\*+/-9=?A-Z^-~), 대문자, 숫자 등을 포함하는 0에서 64자 길이의 문자열.
  - 도메인 파트(@ 뒤쪽): 첫 글자는 영문자나 숫자로 시작하고, 중간에 하이픈을 포함할 수 있으며, 최대 63자 길이의 도메인 라벨.
  - ex) test@example.com, john.doe"@example.com, user.name+tag@sub.domain.com

- 전화번호 유효성 검사 조건
  - 숫자 2-4자리, 하이픈, 숫자 3-5자리, 하이픈, 숫자 4자리 (예: 123-456-7890)
  - 숫자 4자리, 하이픈, 숫자 4자리 (예: 1234-5678)
  - 숫자 8-12자리 연속된 숫자 (예: 12345678, 123456789012)

#### 과세형태

- NORMAL: 일반과세자
- SIMPLE: 간이과세자
- VAT_FREE: 부가세 면세사업자
- CORPORATION: 법인사업자
- FREE_CORPORATION: 면세법인사업자
- ETC: 기타

#### 정산 유형

- DAY: 일 정산
- WEEK: 주 정산
- MONTH: 월 정산

#### 정산 타입

- TOMORROW: 전일
- YESTERDAY: 익일

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### POST /partners/temp

**요약**: 임시 파트너 등록하기

**설명**:

## 부가설명 및 특이사항

쇼핑몰에 임시 파트너를 등록하는 API 입니다.

## 참고

- merchandiserNo(담당MD) :운영자번호 번호 입력 (거래쇼핑몰 권한 + 상품MD 권한이 있는 운영자만 지정 가능)
  - 서비스어드민> 서비스관리> 운영자 관리에서 운영자번호 확인 가능합니다.

- partnerName(파트너명) : 중복불가 : [파트너명 중복 체크하기 API >](https://server-docs.shopby.co.kr/#/Partner/get-partners-exist-partner-name)
- 이메일 유효성 검사 조건
  - 로컬 파트(@ 앞쪽): 허용되는 특수 문자(.!#-'\*+/-9=?A-Z^-~), 대문자, 숫자 등을 포함하는 0에서 64자 길이의 문자열.
  - 도메인 파트(@ 뒤쪽): 첫 글자는 영문자나 숫자로 시작하고, 중간에 하이픈을 포함할 수 있으며, 최대 63자 길이의 도메인 라벨.
  - ex) test@example.com, john.doe"@example.com, user.name+tag@sub.domain.com

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /partners/{partnerNo}

**요약**: 몰과 계약된 파트너 조회

**설명**:

## 부가설명 및 특이사항

쇼핑몰과 계약 파트너를 조회하는 api 입니다.

### 파트너 상태

- WAITING: 등록대기
- INVESTIGATION: 검토중
- ACTIVE: 등록완료

### 파트너 유형

- NORMAL: 일반
- MALLDELIVERY: 배송파트너 (deprecated)
- DELIVERY: 배송파트너
- SHOPBY: 샵바이 파트너

### 과세 형태

- NORMAL: 일반과세자
- SIMPLE: 간이과세자
- VAT_FREE: 부가세 면세사업자
- CORPORATION: 법인사업자
- FREE_CORPORATION: 면세법인사업자
- ETC: 기타

### 어드민 상태

- WAITING: 등록대기
- INVESTIGATION: 검토중
- ACTIVE: 등록완료
- DELETE: 삭제
- LOCKED: 로그인 잠금
- DORMANT: 휴면

### 어드민 권한

- MASTER: 마스터
- NORMAL: 일반

### 어드민 타입

- PLATFORM: 플랫폼 어드민
- SERVICE: 서비스 어드민
- PARTNER: 파트너 어드민
- SHOPBY: 샵바이 어드민
- DEVELOPER: 개발자

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명        |
| --------- | ------ | ------ | ---- | ----------- |
| partnerNo | path   | string | ✅   | 파트너 번호 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /partners/{partnerNo}

**요약**: 파트너 수정하기

**설명**:

## 부가설명 및 특이사항

쇼핑몰에 파트너를 수정하는 API 입니다.

- bank(은행코드) : [은행코드 바로가기 >](https://workspace.nhn-commerce.com/support/recommendedContents/193355)
  - 은행코드를 제공하지 않는 은행인 경우 null로 입력 후 bankName(은행명)에 은행명을 기입하시기 바랍니다.

- bankName(은행명) :
  - bank(은행코드)에 은행코드를 입력한 경우 null로 입력
  - bank(은행코드) null로 입력한 경우 은행명 입력
- 이메일 유효성 검사 조건
  - 로컬 파트(@ 앞쪽): 허용되는 특수 문자(.!#-'\*+/-9=?A-Z^-~), 대문자, 숫자 등을 포함하는 0에서 64자 길이의 문자열.
  - 도메인 파트(@ 뒤쪽): 첫 글자는 영문자나 숫자로 시작하고, 중간에 하이픈을 포함할 수 있으며, 최대 63자 길이의 도메인 라벨.
  - ex) test@example.com, john.doe"@example.com, user.name+tag@sub.domain.com

- 전화번호 유효성 검사 조건
  - 숫자 2-4자리, 하이픈, 숫자 3-5자리, 하이픈, 숫자 4자리 (예: 123-456-7890)
  - 숫자 4자리, 하이픈, 숫자 4자리 (예: 1234-5678)
  - 숫자 8-12자리 연속된 숫자 (예: 12345678, 123456789012)

#### 과세형태

- NORMAL: 일반과세자
- SIMPLE: 간이과세자
- VAT_FREE: 부가세 면세사업자
- CORPORATION: 법인사업자
- FREE_CORPORATION: 면세법인사업자
- ETC: 기타

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명        |
| --------- | ------ | ------ | ---- | ----------- |
| partnerNo | path   | string | ✅   | 파트너 번호 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### GET /partners/exist/admin-id

**요약**: 어드민아이디 중복 체크하기

**설명**:

## 부가설명 및 특이사항

어드민아이디 중복 체크하는 API입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명         |
| --------- | ------ | ------ | ---- | ------------ |
| adminId   | query  | string | ✅   | 어드민아이디 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /partners/exist/partner-name

**요약**: 파트너명 중복 체크하기

**설명**:

## 부가설명 및 특이사항

파트너명 중복 체크하는 API입니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명     |
| ----------- | ------ | ------ | ---- | -------- |
| partnerName | query  | string | ✅   | 파트너명 |
| systemKey   | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

## Service

### GET /services

**요약**: 서비스 상세 조회

**설명**:
서비스 상세 조회

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---
