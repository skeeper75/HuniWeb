# marketing-server

**버전**: 1.0
**서버**: https://server-api.e-ncp.com

샵바이 마케팅 Server to Server API

---

## Campaign

### POST /campaigns

**요약**: 연동정보로 캠페인 수정

**설명**:

외부 연동정보로 캠페인을 수정합니다.

**현재는 shop by의 상점번호를 이용한 수정만 가능합니다.**

## request

- godosno: shop by 상점번호
- status: 변경할 캠페인 상태. 중지 요청(PAUSED_BY_SYSTEM)만 가능

## response

- campaignNo: 캠페인 번호
- name: 캠페인 이름
- status: 캠페인 상태
- dailyBudget: 일 단위의 캠페인 평균 예산
- mallNo: 캠페인이 속한 쇼핑몰 번호
- startDate: 캠페인 시작일(yyyy-MM-dd)
- startDateTime: 캠페인 시작일시(yyyy-MM-ddTHH:mm:ss)
- endDate: 캠페인 종료일(yyyy-MM-dd)
- endDateTime: 캠페인 종료일시(yyyy-MM-ddTHH:mm:ss)

## Enums

### status

- PENDING: 대기중
- PAUSED_BY_SYSTEM: 중지됨(시스템에 의한 강제 중지)
- PAUSED: 중지됨
- ENABLED: 진행중
- PENDING_BY_PRODUCT: 상품 연동 대기중
- READY: 준비중
- REMOVED: 삭제

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명        |
| --------- | ------ | ------ | ---- | ----------- |
| Version   | header | string | ✅   | API 버전    |
| systemKey | header | string | ✅   | API 연동 키 |

**응답**:

- **200**: 200

---

## Marketing

### PUT /marketing/display

**요약**: 마케팅 상품 일괄 노출여부 변경

**설명**:

## 부가설명 및 특이사항

마케팅 상품 일괄 노출여부 변경

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
  | partnerId | header | string | ❌ |
  파트너 아이디 (파트너사 로그인계정)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### PUT /marketing/product

**요약**: 마케팅 상품 등록/수정하기

**설명**:

## 부가설명 및 특이사항

마케팅 상품 등록/수정하기

## 부가설명 및 특이사항

- channelType NAVER_SHOPPING 인 경우에만 additionalInfo 정보 기입 가능합니다.
- 도서 카테고리인 상품은, 네이버 포인트 적립 불가합니다.

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
  | partnerId | header | string | ❌ |
  파트너 아이디 (파트너사 로그인계정)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **204**: 204

---

### GET /marketing/products/settings

**요약**: 상품 번호로 네이버 쇼핑 설정 정보 조회하기

**설명**:

## 부가설명 및 특이사항

상품 번호로 네이버 쇼핑 설정 정보 조회하는 API 입니다.

상품 번호는 최대 200개 까지 조회 가능합니다.

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명      |
| ---------- | ------ | ------ | ---- | --------- |
| productNos | query  | number | ✅   | 상품 번호 |
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
  | partnerId | header | string | ❌ |
  파트너 아이디 (파트너사 로그인계정)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br>

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br>

(Authorization 입력했을 경우, partnerId와 mallKey는 null로 보내시길 바랍니다.)<br>

|
| Version | header | string | ✅ | API 버전 |

**응답**:

- **200**: 200

---
