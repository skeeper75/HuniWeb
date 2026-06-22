# manage-server

**버전**: 1.0
**서버**: https://server-api.e-ncp.com

쇼핑몰 운영(manage) 관련 server API입니다.

---

## Accumulations

### GET /accumulations

**요약**: 적립금 조회하기

**설명**:

## 부가설명 및 특이사항

등록일/시작일/만료일로 적립금 상태를 검색/조회하는 API 입니다.

기본 적립금 단위는 정수형으로 지원합니다. ex) 1000
Global Mall의 경우, 적립금은 소수점 2자리까지 지원합니다. ex) 1000.00

**파라미터**:

| 이름            | 위치   | 타입    | 필수 | 설명                                              |
| --------------- | ------ | ------- | ---- | ------------------------------------------------- | -------------- | ---------------- |
| page            | query  | number  | ❌   | 페이지 번호                                       |
| pageSize        | query  | number  | ❌   | 페이지 사이즈 (최대 10000)                        |
| periodType      | query  | string  | ✅   | 기간 설정 타입 (REGISTER : 등록일                 | START : 생성일 | EXPIRE : 만료일) |
| accumulationNos | query  | string  | ❌   | 적립금 번호 리스트                                |
| startYmd        | query  | string  | ✅   | 검색 시작일                                       |
| endYmd          | query  | string  | ✅   | 검색 종료일                                       |
| isOnlyAvailable | query  | boolean | ❌   | 사용가능한 적립금만 조회 여부 ( default : false ) |
| externalKey     | query  | string  | ❌   | 외부 키(조회용)                                   |
| systemKey       | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | partnerId | header | string | ❌ |
  파트너 아이디 (파트너사 로그인계정)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
  |
  | Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /accumulations/assembles

**요약**: 어셈블 적립금 요청 목록 조회

**설명**:
필터(회원번호, 상태 등)로 적립금 어셈블 요청을 페이지 조회합니다.

**파라미터**:

| 이름             | 위치   | 타입    | 필수 | 설명                       |
| ---------------- | ------ | ------- | ---- | -------------------------- |
| page             | query  | number  | ❌   | 페이지 번호                |
| pageSize         | query  | number  | ❌   | 페이지 사이즈 (최대 10000) |
| mallNos          | query  | number  | ❌   | 쇼핑몰 번호                |
| searchType       | query  | string  | ❌   | 검색 유형                  |
| keyword          | query  | string  | ❌   | 검색 내용                  |
| periodType       | query  | string  | ❌   | 검색 기간 유형             |
| startDateTime    | query  | string  | ❌   | 시작일                     |
| endDateTime      | query  | string  | ❌   | 종료일                     |
| immediately      | query  | boolean | ❌   | 즉시지급 여부              |
| requestGroupType | query  | string  | ❌   | 전체/지급/차감             |
| requestTypes     | query  | string  | ❌   | 예약지급/즉시지급/즉시차감 |
| statuses         | query  | string  | ❌   | 지급요청 유형 리스트       |
| systemKey        | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | partnerId | header | string | ❌ |
  파트너 아이디 (파트너사 로그인계정)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
  |
  | Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /accumulations/externals

**요약**: 외부적립금 연동 이력 조회

**설명**:

## 부가설명 및 특이사항

외부적립금 연동을 사용하는 몰에서 적립금 연동 이력을 조회합니다.

**파라미터**:

| 이름           | 위치   | 타입    | 필수 | 설명                                                                       |
| -------------- | ------ | ------- | ---- | -------------------------------------------------------------------------- |
| page           | query  | number  | ❌   | 페이지 번호                                                                |
| pageSize       | query  | number  | ❌   | 페이지 사이즈 (최대 10000)                                                 |
| startYmdt      | query  | string  | ✅   | 조회 시작일                                                                |
| endYmdt        | query  | string  | ✅   | 조회 종료일                                                                |
| success        | query  | boolean | ❌   | 성공여부                                                                   |
| requestType    | query  | string  | ❌   | 요청타입 (ADD, SUB, SUB_ROLLBACK)                                          |
| mappingKeyType | query  | string  | ❌   | 매핑키 종류 - mappingKeys 와 같이 보내야 함. (REVIEW, ORDER, ORDER_OPTION) |
| mappingKeys    | query  | string  | ❌   | 매핑키 값 - mappingKeyType과 같이 보내야 함. 컴마로 연결                   |
| externalNos    | query  | string  | ❌   | 외부연동키. 컴마로 연결                                                    |
| seqs           | query  | string  | ❌   | 트랜잭션 ID 리스트                                                         |
| systemKey      | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | partnerId | header | string | ❌ |
  파트너 아이디 (파트너사 로그인계정)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
  |
  | Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /accumulations/settlement

**요약**: 적립금 지급/차감 이력 조회

**설명**:

## 부가설명 및 특이사항

적립금 지금/차감/차감롤백 이력을 조회합니다.

기본 적립금 단위는 정수형으로 지원합니다. ex) 1000
Global Mall의 경우, 적립금은 소수점 2자리까지 지원합니다. ex) 1000.00

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                       |
| --------- | ------ | ------ | ---- | -------------------------- |
| page      | query  | number | ❌   | 페이지 번호                |
| pageSize  | query  | number | ❌   | 페이지 사이즈 (최대 10000) |
| startYmd  | query  | string | ✅   | 조회 시작일                |
| endYmd    | query  | string | ✅   | 조회 종료일                |
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
  | partnerId | header | string | ❌ |
  파트너 아이디 (파트너사 로그인계정)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
  |
  | Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /accumulations/usage

**요약**: 적립금 사용처 추적하기

**설명**:

## 부가설명 및 특이사항

적립된 적립금의 번호를 넘기면 해당 적립금을 사용자가 어떤 주문에 사용했는지 추적해 줍니다.
input 으로 넘긴 적립금 번호가 차감일 경우 제외되고 조회됩니다.

기본 적립금 단위는 정수형으로 지원합니다. ex) 1000
Global Mall의 경우, 적립금은 소수점 2자리까지 지원합니다. ex) 1000.00

**파라미터**:

| 이름            | 위치   | 타입   | 필수 | 설명                            |
| --------------- | ------ | ------ | ---- | ------------------------------- |
| accumulationNos | query  | string | ✅   | 적립금 번호 리스트(최대 1000개) |
| systemKey       | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | partnerId | header | string | ❌ |
  파트너 아이디 (파트너사 로그인계정)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
  |
  | Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### POST /accumulations/members/available

**요약**: 회원 보유 적립금 조회(다건)

**설명**:
memberId 리스트로 회원 보유(가용) 적립금을 조회합니다.

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
  | partnerId | header | string | ❌ |
  파트너 아이디 (파트너사 로그인계정)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
  |
  | Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /profile/accumulations

**요약**: 적립금 상태 조회하기

**설명**:

## 부가설명 및 특이사항

특정 회원의 적립금 상태를 검색/조회하는 API 입니다.

기본 적립금 단위는 정수형으로 지원합니다. ex) 1000
Global Mall의 경우, 적립금은 소수점 2자리까지 지원합니다. ex) 1000.00

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                       |
| --------- | ------ | ------ | ---- | -------------------------- |
| page      | query  | number | ❌   | 페이지 번호                |
| pageSize  | query  | number | ❌   | 페이지 사이즈 (최대 10000) |
| memberId  | query  | string | ❌   | 회원 아이디(회원 조회용)   |
| memberNo  | query  | number | ❌   | 회원 번호(회원 조회용)     |
| startYmd  | query  | string | ❌   | 검색 시작일                |
| endYmd    | query  | string | ❌   | 검색 종료일                |
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
  | partnerId | header | string | ❌ |
  파트너 아이디 (파트너사 로그인계정)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
  |
  | Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### POST /profile/accumulations

**요약**: 적립금 지급하기

**설명**:

## 부가설명 및 특이사항

특정 회원에게 적립금을 즉시 지급하는 API 입니다.

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
  | partnerId | header | string | ❌ |
  파트너 아이디 (파트너사 로그인계정)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
  |
  | Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### DELETE /profile/accumulations

**요약**: 적립금 차감하기

**설명**:

## 부가설명 및 특이사항

특정 회원의 적립금을 차감하는 API 입니다.

회원의 보유 적립금 보다 많은 금액 차감 시, 차감 실패

응답 예시)

```json
{
   "timestamp":"2025-04-28 13:44:57",
   "path":"DELETE /server/profile/accumulations",
   "status":400,
   "error":[ ],
   "code":"A0002",
   "message":"지급 받은 적립금 중 17,900 적립금이 부족하여 처리할 수 없습니다. 부족한 적립금에 대해 확인 후 진행해 주세요."
}


**파라미터**:

| 이름 | 위치 | 타입 | 필수 | 설명 |
|------|------|------|------|------|
| accumulationAmt | query | number | ❌ | 적립금 차감 금액 |
| entireSubtracted | query | boolean | ❌ | 전체 적립금 차감 여부 |
| memberId | query | string | ❌ | 회원 아이디(회원 조회용) |
| memberNo | query | number | ❌ | 회원 번호(회원 조회용) |
| detailReason | query | string | ❌ | 적립금 차감 사유(최대 200자) |
| externalKey | query | string | ❌ | 외부 키(조회용)(최대 60자) |
| systemKey | header | string | ✅ |
 시스템 키 (외부시스템 연동을 위한 server API 호출 키)
 - 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
 - 앱 기준으로 systemKey 발급됨
 |
| Authorization | header | string | ❌ |

 인증토큰 (Bearer 발급받은 엑세스 토큰)

 - 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

 - 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
 |
| partnerId | header | string | ❌ |
 파트너 아이디 (파트너사 로그인계정)

 ※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

 Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

 (Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

 |
| mallKey | header | string | ❌ |  외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
 |
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /profile/accumulations/{accumulationNo}/expire

**요약**: 적립금 만료 처리

**설명**:
## 부가설명 및 특이사항
특정 적립금 만료하는 API입니다.

지정한 적립금의 남은 사용 가능한 적립금 금액을 만료 시킵니다.

이미 만료된 적립금은 만료되지 않습니다.
response 예시)
code : A0034, message : 이미 만료된 적립금입니다.


**파라미터**:

| 이름 | 위치 | 타입 | 필수 | 설명 |
|------|------|------|------|------|
| accumulationNo | path | string | ✅ | 적립금 번호 |
| systemKey | header | string | ✅ |
 시스템 키 (외부시스템 연동을 위한 server API 호출 키)
 - 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
 - 앱 기준으로 systemKey 발급됨
 |
| Authorization | header | string | ❌ |

 인증토큰 (Bearer 발급받은 엑세스 토큰)

 - 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

 - 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
 |
| partnerId | header | string | ❌ |
 파트너 아이디 (파트너사 로그인계정)

 ※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

 Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

 (Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

 |
| mallKey | header | string | ❌ |  외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
 |
| Version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

## Inquiry

### GET /inquiries

**요약**: 1:1문의 조회하기

**설명**:

답변 지연 여부는 문의 일시 기준으로 24시간 이내 답변 완료가 되지 않은 경우 **true**

검색 유형의 ISSUER 는 문의자 아이디, 문의자 이메일을 대상으로 검색함

담당자 미지정 여부 (isUnspecified)가 담당자 번호(assigneeNo)보다 우선순위에 있으며, 담당자를 설정하려면 담당자 미지정여부를 false로 설정해야 한다.

담당자 미지정여부가 false이고 assigneeNo를 지정하지 않을 경우에는 담당자 조건을 검사하지 않고 검색한다.

 ### 1:1문의 검색 타입

 값 | 설명 |
---|-----|
 ALL | 전체 |
 INQUIRY_NO | 문의번호 |
 TITLE | 문의제목 |
 CONTENT | 문의내용 |
 ISSUER | 문의자 |
 ASSIGNEE | 담당자명 |

 ### 1:1문의 상태

 값 | 설명 |
---|-----|
 ISSUED | 답변대기 |
 ASKED | 답변대기 |
 IN_PROGRESS | 진행중 |
 ANSWERED | 답변완료 |

 ### 문의자 상태

 값 | 설명 |
---|-----|
 WAITING | 가입대기 |
 ACTIVE | 가입완료 |
 DORMANT | 휴면 |
 PAUSED | 이용정지 |
 WITHDRAWN | 탈퇴 |
 GUEST | 비회원 |

 ### 날짜 검색 타입

 값 | 설명 |
---|-----|
 REGISTER | 등록일 |
 ANSWER | 답변일 |

 ### contents[].assignee.assigneeStatus

 값 | 설명 |
---|-----|
 WAITING | 등록대기 |
 INVESTIGATION | 검토중 |
 ACTIVE | 등록완료 |
 DELETE | 삭제 |
 LOCKED | 로그인 잠금 |
 DORMANT | 휴면 |
 UNASSIGNEED | 담당자미지정 |

 ### external
 inquiryTypeChannel이 NCP가 아닌 경우 값이 있다.
   * inquiryTypeChannel이 NAVER_PAY인 경우: external.naver

 ## assignee
* 담당자 미지정: 답변 완료되지 않은 1:1문의 중 담당자 운영자가 삭제되거나 1:1문의 등록 시점에 담당자가 없는 경우 해당 1:1문의는 담당자 미지정이다.
  * assigneeNo = 0
  * assigneeName = 담당자미지정
  * assigneeStatus = UNASSIGNEED
* 삭제 상태의 담당자: 답변 완료된 1:1문의 중 담당자 운영자가 삭제 상태에 있는 경우. 이 때는 운영자 정보는 남아있다.
  * assigneeNo = 운영자 번호
  * assigneeName = 운영자 이름
  * assigneeStatus = DELETE
* 삭제된 담당자: 답변 완료된 1:1문의 중 담당자 운영자가 완전히 삭제되었을 경우 삭제된 어드민이다.
  * assigneeNo = null
  * assigneeName = 삭제된 담당자
  * assigneeStatus = DELETE

 ### contents[].assignee.assigneeStatus

 값 | 설명 |
---|-----|
 WAITING | 등록대기 |
 INVESTIGATION | 검토중 |
 ACTIVE | 등록완료 |
 DELETE | 삭제 |
 LOCKED | 로그인 잠금 |
 DORMANT | 휴면 |
 UNASSIGNEED | 담당자미지정 |


**파라미터**:

| 이름 | 위치 | 타입 | 필수 | 설명 |
|------|------|------|------|------|
| page | query | number | ❌ | 페이지 번호 |
| pageSize | query | number | ❌ | 페이지 사이즈 (최대 10000) |
| searchType | query | string | ❌ | 검색 유형^|ALL | INQUIRY_NO | TITLE | CONTENT | ISSUER | ASSIGNEE |
| keyword | query | string | ❌ | 키워드 |
| inquiryTypeNo | query | number | ❌ | 문의 유형 번호 |
| assigneeNo | query | number | ❌ | 담당자 번호 |
| issuerNo | query | number | ❌ | 문의자 번호 |
| inquiryStatuses | query | string | ❌ | 문의 상태 (ISSUED(ASKED-이전버전 호환용): 답변대기, IN_PROGRESS: 답변 진행중, ANSWERED: 답변완료) |
| startDateTime | query | string | ❌ | 검색 기준 시작일 (미입력 시 현재 기준 3달 전) |
| endDateTime | query | string | ❌ | 검색 기준 종료일 (미입력 시 현재 시각) |
| isUnspecified | query | boolean | ❌ | 담당자 미지정 여부 (assigneeNo보다 우선순위이다. 기본값 = false) |
| searchDateType | query | string | ❌ | 검색 날짜 유형 (기본값 = REGISTER(등록일))^|REGISTER | ANSWER |
| systemKey | header | string | ✅ |
 시스템 키 (외부시스템 연동을 위한 server API 호출 키)
 - 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
 - 앱 기준으로 systemKey 발급됨
 |
| Authorization | header | string | ❌ |

 인증토큰 (Bearer 발급받은 엑세스 토큰)

 - 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

 - 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
 |
| partnerId | header | string | ❌ |
 파트너 아이디 (파트너사 로그인계정)

 ※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

 Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

 (Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

 |
| mallKey | header | string | ❌ |  외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
 |
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /inquiries/types

**요약**: 1:1문의 유형 조회하기

**설명**:

1:1문의 유형을 조회하는 server api 입니다.


**파라미터**:

| 이름 | 위치 | 타입 | 필수 | 설명 |
|------|------|------|------|------|
| systemKey | header | string | ✅ |
 시스템 키 (외부시스템 연동을 위한 server API 호출 키)
 - 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
 - 앱 기준으로 systemKey 발급됨
 |
| Authorization | header | string | ❌ |

 인증토큰 (Bearer 발급받은 엑세스 토큰)

 - 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

 - 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
 |
| partnerId | header | string | ❌ |
 파트너 아이디 (파트너사 로그인계정)

 ※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

 Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

 (Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

 |
| mallKey | header | string | ❌ |  외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
 |
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### POST /inquiries/types

**요약**: 1:1문의 유형 생성하기

**설명**:

1:1문의 유형을 생성하는 server api 입니다.


**파라미터**:

| 이름 | 위치 | 타입 | 필수 | 설명 |
|------|------|------|------|------|
| systemKey | header | string | ✅ |
 시스템 키 (외부시스템 연동을 위한 server API 호출 키)
 - 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
 - 앱 기준으로 systemKey 발급됨
 |
| Authorization | header | string | ❌ |

 인증토큰 (Bearer 발급받은 엑세스 토큰)

 - 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

 - 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
 |
| partnerId | header | string | ❌ |
 파트너 아이디 (파트너사 로그인계정)

 ※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

 Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

 (Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

 |
| mallKey | header | string | ❌ |  외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
 |
| Version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### POST /inquiries/{inquiryNo}/answer

**요약**: 1:1 문의 답변 등록

**설명**:
1:1 문의 답변 등록

**파라미터**:

| 이름 | 위치 | 타입 | 필수 | 설명 |
|------|------|------|------|------|
| inquiryNo | path | string | ✅ | 문의번호 |
| systemKey | header | string | ✅ |
 시스템 키 (외부시스템 연동을 위한 server API 호출 키)
 - 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
 - 앱 기준으로 systemKey 발급됨
 |
| Authorization | header | string | ❌ |

 인증토큰 (Bearer 발급받은 엑세스 토큰)

 - 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

 - 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
 |
| partnerId | header | string | ❌ |
 파트너 아이디 (파트너사 로그인계정)

 ※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

 Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

 (Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

 |
| mallKey | header | string | ❌ |  외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
 |
| Version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

## Kakao

### POST /kakao/send

**요약**: 카카오 알림톡 메시지 수동 전송

**설명**:

## 부가설명 및 특이사항
-카카오 알림톡 메시지 수동 전송 API입니다.

-몰 설정에 따라서 provider(비즈엠, 샵바이) 적용되어서 전송됩니다.
-전송에 필요한 치환코드가 모두(본문, 내용, 아이템 리스트, 아이템 요약, 버튼 설정 등) 포함되어야 전송됩니다.

 replaceMap 예시
 -"replaceMap" : {
  "nickName" : "홍길동",
  "smsAgreeDate" : "2025-01-01 23:59:59",
  "couponName" : "수동 지급 쿠폰 (5000원)"
}


**파라미터**:

| 이름 | 위치 | 타입 | 필수 | 설명 |
|------|------|------|------|------|
| systemKey | header | string | ✅ |
 시스템 키 (외부시스템 연동을 위한 server API 호출 키)
 - 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
 - 앱 기준으로 systemKey 발급됨
 |
| Authorization | header | string | ❌ |

 인증토큰 (Bearer 발급받은 엑세스 토큰)

 - 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

 - 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
 |
| partnerId | header | string | ❌ |
 파트너 아이디 (파트너사 로그인계정)

 ※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

 Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

 (Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

 |
| mallKey | header | string | ❌ |  외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
 |
| Version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

## Terms

### GET /terms

**요약**: 유형별 약관 조회

**설명**:

유형별 약관 조회
## termsTypes
- MALL_INTRODUCTION: 쇼핑몰/회사 소개
- USE: 이용약관
- E_COMMERCE: 전자금융거래 이용약관
- PI_PROCESS: 개인정보처리방침
- PI_COLLECTION_AND_USE_REQUIRED: 개인정보 수집/이용
- PI_COLLECTION_AND_USE_OPTIONAL: 개인정보 수집/이용
- PI_PROCESS_CONSIGNMENT: 개인정보 처리/위탁
- PI_THIRD_PARTY_PROVISION: 개인정보 제3자 제공
- PI_COLLECTION_AND_USE_FOR_GUEST_ON_ARTICLE: 개인정보 수집/이용
- ACCESS_GUIDE: 이용안내
- WITHDRAWAL_GUIDE: 탈퇴안내
- PI_SELLER_PROVISION: 개인정보 판매자 제공
- PI_COLLECTION_AND_USE_ON_ORDER: 개인정보 수집/이용
- ORDER_INFO_AGREE: 구매 동의
- CLEARANCE_INFO_COLLECTION_AND_USE: 통관정보 수집/이용
- TRANSFER_AGREE: 개인정보 국외 이전 동의
- REGULAR_PAYMENT_USE: 정기결제(배송) 이용약관
- AUTO_APPROVAL_USE: 자동 승인 이용약관
- PI_LIQUOR_PURCHASE_PROVISION: 주류구매 개인정보 수집/이용
- PI_RESTOCK_NOTICE: 개인정보 수집/이용
- PI_14_AGE: 만 14세 이상 가입 동의
- PI_GIFT_ACCEPT_COLLECTION_AND_USE: 선물수락 개인정보 수집/이용
 "," 구분자 또는 복수 파라미터로 LIST 요청 할 수 있습니다.


**파라미터**:

| 이름 | 위치 | 타입 | 필수 | 설명 |
|------|------|------|------|------|
| termsTypes | query | string | ✅ | 약관 유형 (MALL_INTRODUCTION: 쇼핑몰/회사 소개, USE: 이용약관, E_COMMERCE: 전자금융거래 이용약관, PI_PROCESS: 개인정보처리방침, PI_COLLECTION_AND_USE_REQUIRED: 개인정보 수집/이용, PI_COLLECTION_AND_USE_OPTIONAL: 개인정보 수집/이용, PI_PROCESS_CONSIGNMENT: 개인정보 처리/위탁, PI_THIRD_PARTY_PROVISION: 개인정보 제3자 제공, PI_COLLECTION_AND_USE_FOR_GUEST_ON_ARTICLE: 개인정보 수집/이용, ACCESS_GUIDE: 이용안내, WITHDRAWAL_GUIDE: 탈퇴안내, PI_SELLER_PROVISION: 개인정보 판매자 제공, PI_COLLECTION_AND_USE_ON_ORDER: 개인정보 수집/이용, ORDER_INFO_AGREE: 구매 동의, CLEARANCE_INFO_COLLECTION_AND_USE: 통관정보 수집/이용, TRANSFER_AGREE: 개인정보 국외 이전 동의, REGULAR_PAYMENT_USE: 정기결제(배송) 이용약관, AUTO_APPROVAL_USE: 자동 승인 이용약관, PI_LIQUOR_PURCHASE_PROVISION: 주류구매 개인정보 수집/이용, PI_RESTOCK_NOTICE: 개인정보 수집/이용, PI_14_AGE: 만 14세 이상 가입 동의, PI_GIFT_ACCEPT_COLLECTION_AND_USE: 선물수락 개인정보 수집/이용) |
| systemKey | header | string | ✅ |
 시스템 키 (외부시스템 연동을 위한 server API 호출 키)
 - 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
 - 앱 기준으로 systemKey 발급됨
 |
| Authorization | header | string | ❌ |

 인증토큰 (Bearer 발급받은 엑세스 토큰)

 - 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

 - 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
 |
| partnerId | header | string | ❌ |
 파트너 아이디 (파트너사 로그인계정)

 ※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

 Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

 (Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

 |
| mallKey | header | string | ❌ |  외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
 |
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### GET /terms/custom/{customTermsNo}/members

**요약**: 추가 약관 동의 회원 목록 조회

**설명**:
추가 약관에 동의한 회원 목록 조회

**파라미터**:

| 이름 | 위치 | 타입 | 필수 | 설명 |
|------|------|------|------|------|
| customTermsNo | path | string | ✅ | 추가 약관 번호 |
| page | query | string | ✅ | 페이지 번호 |
| pageSize | query | string | ✅ | 페이지 크기 |
| systemKey | header | string | ✅ |
 시스템 키 (외부시스템 연동을 위한 server API 호출 키)
 - 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
 - 앱 기준으로 systemKey 발급됨
 |
| Authorization | header | string | ❌ |

 인증토큰 (Bearer 발급받은 엑세스 토큰)

 - 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

 - 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
 |
| partnerId | header | string | ❌ |
 파트너 아이디 (파트너사 로그인계정)

 ※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

 Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

 (Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

 |
| mallKey | header | string | ❌ |  외부 API 연동키 (외부시스템연동 코드) - Authorization 사용 시 안보내도 됩니다.

- 파트너 : 파트너관리 > 파트너 정보 조회 > 거래쇼핑몰 > 외부시스템 연동코드
- 서비스 : 서비스관리 > 쇼핑몰관리 > 개발 연동 정보 > 외부 연동 키
- 샵바이 프로 : 설정 > 기본정책 > 외부서비스 설정 > 외부 API 연동 정보 > 외부 API 연동 Key
 |
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

```
