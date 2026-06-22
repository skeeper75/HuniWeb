# display-server

**버전**: 0.0.1-SNAPSHOT
**서버**: https://server-api.e-ncp.com

상품 전시(display) 관련 server API입니다.

---

## Banner

### GET /banners

**요약**: 배너 조회하기

**설명**:

## 부가설명 및 특이사항

배너 코드 또는 ID 정보로 배너를 조회하는 API입니다

5분 캐시하여 사용하고 있습니다. (cached)

## 화면 예시

[![banner-list-img](<http://image.toast.com/aaaaahb/api-description/display/[GET]%20display_banners_bannerSectionCodes%20%EB%B0%B0%EB%84%88%EB%AA%A9%EB%A1%9D%20%EC%A1%B0%ED%9A%8C%20(cached).png?autox150>)](<http://image.toast.com/aaaaahb/api-description/display/[GET]%20display_banners_bannerSectionCodes%20%EB%B0%B0%EB%84%88%EB%AA%A9%EB%A1%9D%20%EC%A1%B0%ED%9A%8C%20(cached).png>)

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                      |
| ----------- | ------ | ------ | ---- | ------------------------- |
| keywords    | query  | string | ✅   | 배너 코드 또는 ID         |
| keywordType | query  | string | ✅   | 검색 타입, (CODE, ID, NO) |
| systemKey   | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

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

### POST /banners

**요약**: 배너 섹션 등록

**설명**:
배너 섹션 등록

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

### DELETE /banners

**요약**: 배너 섹션 삭제

**설명**:
배너 섹션 삭제

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명             |
| --------- | ------ | ------ | ---- | ---------------- |
| bannerNos | query  | string | ✅   | 삭제할 배너 번호 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

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

### GET /banners/extraInfo

**요약**: 배너 추가정보 조회하기

**설명**:

## 부가설명 및 특이사항

배너 추가정보를 조회 API입니다.

- 배너 섹션 번호 또는 배너 번호 리스트로 조회 가능합니다. 두 값 중 하나 필수 입력. (두 값 모두 존재하는 경우, 배너 섹션 번호로 조회)

**파라미터**:

| 이름            | 위치   | 타입   | 필수 | 설명                                                   |
| --------------- | ------ | ------ | ---- | ------------------------------------------------------ |
| bannerSectionNo | query  | number | ❌   | 배너 섹션 번호                                         |
| bannerNos       | query  | string | ❌   | 배너 번호 리스트(쉼표 구분, 최대 100개 동시 호출 가능) |
| systemKey       | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

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

### POST /banners/extraInfo

**요약**: 배너 추가정보 등록하기

**설명**:

## 부가설명 및 특이사항

배너 추가정보를 등록하는 API입니다.

- 이미 삭제된 섹션, 구좌의 배너이거나, 삭제된 배너의 경우에는 생성이 불가능합니다.

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

### PUT /banners/extraInfo

**요약**: 배너 추가정보 수정하기

**설명**:

## 부가설명 및 특이사항

배너 추가정보를 수정하는 API입니다.

- 이미 삭제된 섹션, 구좌의 배너이거나, 삭제된 배너의 경우에는 수정이 불가능합니다.

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

### DELETE /banners/extraInfo

**요약**: 배너 추가정보 삭제하기

**설명**:

## 부가설명 및 특이사항

배너 추가정보를 삭제하는 API입니다.

- 이미 삭제된 섹션, 구좌의 배너이거나, 삭제된 배너의 경우에는 삭제가 불가능합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                               |
| --------- | ------ | ------ | ---- | ---------------------------------- |
| bannerNos | query  | string | ✅   | 삭제할 배너 번호 리스트(쉼표 구분) |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

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

### GET /banners/groups

**요약**: 배너 그룹 조회하기

**설명**:

## 부가설명 및 특이사항

배너 그룹 조회 API입니다.

- 배너 섹션 번호 또는 배너 번호 리스트로 조회 가능합니다. 두 값 중 하나 필수 입력. (두 값 모두 존재하는 경우, 배너 섹션 번호로 조회)

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

### GET /banners/simple-infos

**요약**: 헤드리스 배너 조회

**설명**:
헤드리스 배너 조회

**파라미터**:

| 이름                    | 위치   | 타입   | 필수 | 설명                                                               |
| ----------------------- | ------ | ------ | ---- | ------------------------------------------------------------------ |
| keywordInfo.keywords    | query  | string | ❌   | 검색어(쉼표 구분)                                                  |
| keywordInfo.keywordType | query  | string | ❌   | 검색어 타입 : (BANNER_GROUP_NO, BANNER_NO, BANNER_ID, BANNER_CODE) |
| lastBannerNo            | query  | number | ❌   | 조회할 다음 배너 번호                                              |
| size                    | query  | number | ❌   | 페이지당 조회 수                                                   |
| systemKey               | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

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

### PUT /banners/{bannerNo}

**요약**: 배너 섹션 수정

**설명**:
배너 섹션 수정

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| bannerNo  | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

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

## Category

### GET /categories

**요약**: 표준 카테고리 조회하기

**설명**:

## 부가설명 및 특이사항

표준 카테고리 조회하는 API입니다

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

### GET /categories/display-categories

**요약**: 전시 카테고리 조회하기

**설명**:

## 부가설명 및 특이사항

전시 카테고리 조회하는 API입니다

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

### GET /categories/display-categories/tree

**요약**: 전시카테고리 트리 조회하기

**설명**:

## 부가설명 및 특이사항

전시카테고리 트리를 조회하는 API입니다

**파라미터**:

| 이름            | 위치   | 타입    | 필수 | 설명                     |
| --------------- | ------ | ------- | ---- | ------------------------ |
| hasProductCount | query  | boolean | ❌   | 연결된 상품 수 포함 여부 |
| systemKey       | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

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

## Event

### GET /events

**요약**: 기획전 검색

**설명**:

## 부가설명 및 특이사항

기획전을 검색하는 API입니다

- 검색 기간 타입: - REGISTER_YMDT: 등록일

* DISPLAY_YMDT: 전시기간

- 검색어 타입: - EVENT_NAME: 기획전명

* EVENT_NO: 기획전 번호
* ADMIN: 담당자
* EVENT_ID: 기획전 Id

- 기획전 유형: - GENERAL: 일반

* EXTERNAL: 외부링크

- 진행상태: - ALL: 전체

* READY: 진행대기
* ING: 진행중
* END: 진행종료

**파라미터**:

| 이름                | 위치   | 타입   | 필수 | 설명           |
| ------------------- | ------ | ------ | ---- | -------------- |
| searchDateType      | query  | string | ❌   | 조회 기간 타입 |
| datePeriod.startYmd | query  | string | ❌   | 조회 시작일    |
| datePeriod.endYmd   | query  | string | ❌   | 조회 종료일    |
| searchType          | query  | string | ❌   | 검색어 타입    |
| keyword             | query  | string | ❌   | 검색어         |
| progressStatus      | query  | string | ❌   | 진행상태       |
| eventType           | query  | string | ❌   | 기획전 유형    |
| page                | query  | number | ❌   | 시작 페이지    |
| size                | query  | number | ❌   | 조회 수        |
| systemKey           | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |
| App-Key | header | string | ❌ | 어플리케이션 키 |

**응답**:

- **200**: 200

---

### GET /events/{eventNo}

**요약**: 기획전 단건 조회

**설명**:
기획전 상세 정보를 조회하는 API입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명        |
| --------- | ------ | ------ | ---- | ----------- |
| eventNo   | path   | string | ✅   | 기획전 번호 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |
| App-Key | header | string | ❌ | 어플리케이션 키 |

**응답**:

- **200**: 200

---

## ProductInquiry

### GET /inquiry

**요약**: 상품문의 조회하기

**설명**:

## 부가설명 및 특이사항

상품문의 조회하는 API입니다

**파라미터**:

| 이름           | 위치   | 타입   | 필수 | 설명                                                                                |
| -------------- | ------ | ------ | ---- | ----------------------------------------------------------------------------------- |
| startYmd       | query  | string | ❌   | 조회 시작일 (입력 안 할 경우 - 3개월 전)                                            |
| endYmd         | query  | string | ❌   | 조회 종료일 (입력 안 할 경우 - 오늘)                                                |
| replyYn        | query  | string | ❌   | 답변여부 (입력 안 할 경우 - 전체조회)                                               |
| inquiryNo      | query  | number | ❌   | 문의번호 (입력 안 할 경우 - 전체조회)                                               |
| searchDateType | query  | string | ❌   | 기간 검색 종류 (DEFAULT: REGISTER_YMDT) (등록일: REGISTER_YMDT, 답변일: REPLY_YMDT) |
| member.type    | query  | string | ❌   | 회원검색조건 - 회원검색타입 (NAME, ID, NO)                                          |
| member.keyword | query  | string | ❌   | 회원검새조건 - 회원ID or 회원명                                                     |
| systemKey      | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |
| App-Key | header | string | ❌ | 어플리케이션 키 |

**응답**:

- **200**: 200

---

### GET /inquiry/replies

**요약**: 상품문의 답변 조회하기

**설명**:

## 부가설명 및 특이사항

상품문의에 등록된 답변을 조회하는 API입니다

- 상품문의 조회 API를 통해 조회된 문의의 답변을 조회하고자 하는 경우 inquiryNos 를 이용하여 조회

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                             |
| ---------- | ------ | ------ | ---- | ------------------------------------------------ |
| inquiryNos | query  | number | ❌   | 답글이 달린 문의 번호 (최대 100개까지 조회 가능) |
| systemKey  | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |
| App-Key | header | string | ❌ | 어플리케이션 키 |

**응답**:

- **200**: 200

---

### PUT /inquiry/{inquiryNo}/display-status

**요약**: 상품 문의 전시 상태 변경하기

**설명**:

## 부가설명 및 특이사항

상품 문의 전시 상태를 변경하는 API입니다

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명           |
| --------- | ------ | ------ | ---- | -------------- |
| inquiryNo | path   | string | ✅   | 상품 문의 번호 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |
| App-Key | header | string | ❌ | 어플리케이션 키 |

**응답**:

- **204**: 204

---

### POST /inquiry/{inquiryNo}/reply

**요약**: 상품문의 답변 등록하기

**설명**:

## 부가설명 및 특이사항

상품문의 답변 등록하는 API입니다

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명           |
| --------- | ------ | ------ | ---- | -------------- |
| inquiryNo | path   | string | ✅   | 상품 문의 번호 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

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

## Review

### GET /reviews

**요약**: 상품평 조회하기

**설명**:

## 부가설명 및 특이사항

상품평 조회하는 API입니다

검색 방식

- 아래 두 가지 검색방식을 모두 지원합니다.

- (기존) paging search : page 값 필수 (최초 조회 시 생략 가능)

- (신규) keySet search : searchAfter 필수 (최초 조회 시 생략 가능. response의 lastId 값 사용.)

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                     |
| ----------- | ------ | ------ | ---- | ---------------------------------------- |
| startYmd    | query  | string | ❌   | 작성일시 시작 (입력 안 할 경우 3개월 전) |
| endYmd      | query  | string | ❌   | 작성일시 끝 (입력 안 할 경우 오늘)       |
| page        | query  | number | ❌   | 페이지 번호                              |
| size        | query  | number | ❌   | 조회 수                                  |
| reviewNo    | query  | number | ❌   | 상품평 번호                              |
| searchAfter | query  | string | ❌   | 검색 기준 값(lastId)                     |
| systemKey   | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

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

### POST /reviews

**요약**: 상품평 검색하기

**설명**:

## 부가설명 및 특이사항

상품평 검색 API입니다.
배송 파트너정보로 호출하는 경우 모든 상품의 상품평이 검색되며 그 이외에는 파트너가 등록한 상품의 상품평만 조회됩니다.

검색 방식

- 아래 두 가지 검색방식을 모두 지원합니다.

- (기존) paging search : page 값 필수 (최초 조회 시 생략 가능)

- (신규) keySet search : searchAfter 필수 (최초 조회 시 생략 가능. response의 lastId 값 사용.)

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

### PUT /reviews/best-review

**요약**: 상품평 베스트 리뷰 일괄 변경

**설명**:

## 부가설명 및 특이사항

상품평 베스트 리뷰 일괄 변경 API입니다.
최대 1000개까지 일괄 수정 가능합니다.

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

### POST /reviews/external-site

**요약**: 외부 상품평 등록하기

**설명**:

## 부가설명 및 특이사항

외부 상품평 등록 API입니다.

- 상품평 등록은 한번에 최대 100개까지 요청 가능합니다.

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

### PUT /reviews/extraJson

**요약**: 상품평 extraJson 일괄 변경

**설명**:

## 부가설명 및 특이사항

상품평 extraJson 일괄 변경 API입니다.
최대 1000개까지 일괄 수정 가능합니다.

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

### POST /reviews/product-reviews

**요약**: 상품평 등록하기

**설명**:

## 부가설명 및 특이사항

상품평 등록 API입니다.

- 상품평 등록은 한번에 최대 100개까지 요청 가능합니다.

- 상품 평점을 소수점으로 요청시 소수점 아래부분은 버림처리 됩니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ✅ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /reviews/product-reviews

**요약**: 상품평 수정하기

**설명**:

## 부가설명 및 특이사항

상품평 수정 API입니다.

- 상품평 수정은 한번에 최대 100개까지 요청 가능합니다.

- 상품 평점을 소수점으로 요청시 소수점 아래부분은 버림처리 됩니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ✅ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### DELETE /reviews/product-reviews

**요약**: 상품평 삭제하기

**설명**:

## 부가설명 및 특이사항

상품평 삭제 API입니다.

- 상품평 삭제는 한번에 최대 100개까지 요청 가능합니다.

- 상품평번호와 작성자번호를 콤마 기준으로 매칭시켜 요청바랍니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                    |
| ----------- | ------ | ------ | ---- | --------------------------------------- |
| reviewNos   | query  | string | ✅   | 삭제할 상품 리뷰 번호 리스트(쉼표 구분) |
| registerNos | query  | string | ✅   | 작성자 번호 리스트(쉼표 구분)           |
| systemKey   | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ✅ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  |
  | Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---

### PUT /reviews/status

**요약**: 상품평 전시상태 일괄 변경

**설명**:

## 부가설명 및 특이사항

상품평 전시상태 일괄 변경 API입니다.
최대 1000개까지 일괄 수정 가능합니다.

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

## Sticker

### GET /stickers

**요약**: 스티커 목록 조회하기

**설명**:

## 부가설명 및 특이사항

몰에 등록된 스티커 목록 조회 API입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                             |
| --------- | ------ | ------ | ---- | -------------------------------- |
| page      | query  | number | ❌   | 페이지 번호                      |
| size      | query  | number | ❌   | 한 페이지에 조회되는 상품평 갯수 |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 전달받은 토큰)

- 형식: Bearer + 발급받은 access_token

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
