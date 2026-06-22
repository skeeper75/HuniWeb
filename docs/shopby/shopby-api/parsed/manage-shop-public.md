# manage-shop

**버전**: 1.0
**서버**: https://shop-api.e-ncp.com

쇼핑몰 운영(manage) 관련 shop API입니다.

---

## Address

### GET /addresses/search

**요약**: 주소 조회하기

**설명**:

## 부가설명 및 특이사항

검색 키워드로 주소정보를 검색하는 API 입니다.

##Request 요청
| name | type | required | default value | description |
|-----------|-----------|-----------|---------------|------------------|
| keyword | String | Y | | 검색 키워드 |
| pageNumber| Int | N | 1 | 페이지 번호 |
| pageSize | Int | N | 10(MAX = 1000)| 한 페이지당 노출 수 |

## pageSize가 최대 사이즈(1000)를 초과할 경우 최대 사이즈 만큼 조회됩니다.

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                         |
| ---------- | ------ | ------ | ---- | -------------------------------------------- |
| pageNumber | query  | number | ❌   | 페이지 번호                                  |
| pageSize   | query  | number | ❌   | 페이지 사이즈                                |
| keyword    | query  | string | ✅   | 검색 키워드                                  |
| Version    | header | string | ✅   | API 버전                                     |
| clientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform   | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| language   | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

### GET /addresses/search/jp

**요약**: 일본 주소 검색

**설명**:
일본 주소 검색

### 3.2 **응답 필드 설명**

| **필드**       | **타입** | **설명**                                      | 예제 값                                                |
| -------------- | -------- | --------------------------------------------- | ------------------------------------------------------ |
| zipCode        | String   | 우편번호 (하이픈 제거)                        | 1056322                                                |
| prefCode       | String   | 도도부현 코드 (2자리)                         | 13                                                     |
| jisCode        | String   | JIS 코드                                      | 130001                                                 |
| address        | String   | 전체 주소                                     | 東京都港区虎ノ門虎ノ門ヒルズ森タワー２２階             |
| addressEnglish | String   | 전체 주소 (영문)                              | TORANOMON TORANOMONHIRUZUMORITAWA, MINATO KU, TOKYO TO |
| addressList    | Array    | 입력된 우편번호에 해당하는 복수의 주소 리스트 | ['宮城県 伊具郡丸森町 赤堀', '宮城県 伊具郡丸森町 泉'] |
| state          | String   | 도도부현 이름                                 | 東京都                                                 |
| city           | String   | 시/구/읍/면 이름                              | 港区                                                   |
| streetAddress  | String   | 상세 주소                                     | 虎ノ門虎ノ門ヒルズ森タワー２２階                       |

**파라미터**:

| 이름    | 위치  | 타입   | 필수 | 설명     |
| ------- | ----- | ------ | ---- | -------- |
| zipCode | query | string | ✅   | 우편번호 |

**응답**:

- **200**: 200

---

## Board

### GET /boards/configurations

**요약**: 게시판 설정 조회하기

**설명**:

## 부가설명 및 특이사항

전체 게시판의 설정정보를 조회하는 API 입니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                         |
| -------- | ------ | ------ | ---- | -------------------------------------------- |
| Version  | header | string | ✅   | API 버전                                     |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| language | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

### POST /boards/posts

**요약**: 게시글 리스트 조회하기(버전2)

**설명**:

## 부가설명 및 특이사항

특정 게시판(게시판 번호 기준) or 몰 단위의 게시글 리스트를 조회하는 API version2 입니다.

Request Body에 boardNoOrId값을 null 보낼 시 몰 단위로 게시글 리스트를 검색할 수 있습니다.

**파라미터**:

| 이름        | 위치   | 타입    | 필수 | 설명                                         |
| ----------- | ------ | ------- | ---- | -------------------------------------------- |
| page        | query  | integer | ❌   | 페이지 번호 (default:1)                      |
| pageSize    | query  | integer | ❌   | 한 페이지당 노출 수 (default:10)             |
| Version     | header | string  | ✅   | API 버전                                     |
| clientId    | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string  | ❌   | 회원 엑세스 토큰                             |
| language    | header | string  | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

### GET /boards/{boardNo}/articles

**요약**: 게시글 리스트 조회하기

**설명**:

## 부가설명 및 특이사항

특정 게시판(게시판 번호 기준)의 게시글 리스트를 조회하는 API 입니다.

**파라미터**:

| 이름               | 위치   | 타입    | 필수 | 설명                                                                                                             |
| ------------------ | ------ | ------- | ---- | ---------------------------------------------------------------------------------------------------------------- |
| boardNo            | path   | string  | ✅   | 조회할 게시판 번호(숫자) 또는 게시판id(문자열)                                                                   |
| pageNumber         | query  | integer | ❌   | 페이지 번호                                                                                                      |
| pageSize           | query  | integer | ❌   | 한 페이지당 노출 수                                                                                              |
| hasTotalCount      | query  | boolean | ❌   | 목록 카운트 포함 여부(false: 미포함(default), true: 포함)                                                        |
| keyword            | query  | string  | ❌   | 검색어                                                                                                           |
| searchType         | query  | string  | ❌   | 검색유형 (ALL: 전체, TITLE: 제목, CONTENT: 내용, WRITER: 작성자)                                                 |
| categoryNo         | query  | integer | ❌   | 게시판 카테고리                                                                                                  |
| startYmd           | query  | string  | ❌   | 조회일 시작일(yyyy-MM-dd, default: 3개월)                                                                        |
| endYmd             | query  | string  | ❌   | 조회일 종료일(yyyy-MM-dd, default: 오늘)                                                                         |
| withReplied        | query  | boolean | ❌   | 답글도 리스트에 같이 조회할지 여부 (false: 답글 미포함(default), true: 답글 포함)                                |
| direction          | query  | string  | ❌   | 정렬방식(ASC: 오래된 순, DESC: 최신 순, RECOMMEND_COUNT: 추천수 많은 순, READ_COUNT: 조회수 많은 순)             |
| isMine             | query  | boolean | ❌   | 본인이 작성한 글만 조회 여부(false: 전체 조회(default), true: 본인 글만 조회)                                    |
| myRecommendOnly    | query  | boolean | ❌   | 본인이 추천한 게시글만 조회 여부(false: 전체 조회(default), true: 추천한 게시글만 조회)                          |
| includeRecommended | query  | boolean | ❌   | 본인이 해당 게시글을 추천했는지 여부(false: 본인 추천 포함x(default), true: 본인 추천 포함)                      |
| isNoticed          | query  | boolean | ❌   | 공지글 조회 여부(null: 공지+일반 게시글 전체 조회(default), false: 일반 게시글만 조회, true: 공지글만 조회       |
| isSecreted         | query  | boolean | ❌   | 비밀글 조회 여부(null: 공개+비밀 게시글 전체 조회(default), false: 공개 게시글만 조회, true: 비밀 게시글만 조회) |
| Version            | header | string  | ✅   | API 버전                                                                                                         |
| clientId           | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                                         |
| platform           | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)                                                                     |
| accessToken        | header | string  | ❌   | 회원 엑세스 토큰                                                                                                 |
| language           | header | string  | ❌   | 언어 (기본값: ko)                                                                                                |

**응답**:

- **200**: 200

---

### POST /boards/{boardNo}/articles

**요약**: 게시글 작성하기

**설명**:

## 부가설명 및 특이사항

게시글을 작성하는 API 입니다.

images 값은 조회 시, '게시글 상세 조회 하기 API의 'attachments로 조회됩니다.

첨부파일은 최대 10개까지 업로드 가능합니다.

| 저장 시                 | 조회 시(게시글 상세 조회 하기 API) | 설명             | 예시                   |
| ----------------------- | ---------------------------------- | ---------------- | ---------------------- |
| images.originalFileName | attachments.originalFileName       | 원본 파일명      | 홍길동.jpg             |
| images.uploadedFileName | attachments.uploadedFileName       | 업로드 된 파일명 | https://mycdn/hong.jpg |
| images.uploadedFileName | attachments.downloadFileUrl        | 업로드 된 파일명 | https://mycdn/hong.jpg |

### thumbnailUrl는 조회 시, 게시글 상세 조회 하기 API의 'imageUrl'로 조회됩니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                           |
| ----------- | ------ | ------ | ---- | ---------------------------------------------- |
| boardNo     | path   | string | ✅   | 조회할 게시판 번호(숫자) 또는 게시판id(문자열) |
| Version     | header | string | ✅   | API 버전                                       |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                       |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)   |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                               |
| language    | header | string | ❌   | 언어 (기본값: ko)                              |

**응답**:

- **204**: 204

---

### GET /boards/{boardNo}/categories

**요약**: 게시판 카테고리 목록 조회하기

**설명**:

## 부가설명 및 특이사항

특정 게시판(게시판 번호 기준)의 카테고리를 조회하는 API 입니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                           |
| -------- | ------ | ------ | ---- | ---------------------------------------------- |
| boardNo  | path   | string | ✅   | 조회할 게시판 번호(숫자) 또는 게시판id(문자열) |
| Version  | header | string | ✅   | API 버전                                       |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디                       |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)   |
| language | header | string | ❌   | 언어 (기본값: ko)                              |

**응답**:

- **200**: 200

---

### POST /boards/posts/scrap/{postNo}

**요약**: 게시글 스크랩

**설명**:
게시글 스크랩

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| postNo      | path   | string | ✅   | 스크랩할 게시글 번호                         |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ✅   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **204**: 204

---

### DELETE /boards/posts/scrap/{postNo}

**요약**: 게시글 스크랩 취소

**설명**:
게시글 스크랩 취소

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| postNo      | path   | string | ✅   | 스크랩할 게시글 번호                         |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ✅   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **204**: 204

---

### GET /boards/{boardNo}/articles/{articleNo}

**요약**: 게시글 상세 조회하기

**설명**:

## 부가설명 및 특이사항

특정 게시글(게시글 번호 기준)을 상세 조회하는 API 입니다.

imageUrl은 게시글 작성하기 API의 thumbnailUrl과 동일합니다.

attachments는 게시글 작성하기 API의 images와 동일합니다.

| 조회 시                      | 저장 시(게시글 작성하기 API) | 설명             | 예시                   |
| ---------------------------- | ---------------------------- | ---------------- | ---------------------- |
| attachments.originalFileName | images.originalFileName      | 원본 파일명      | 홍길동.jpg             |
| attachments.uploadedFileName | images.uploadedFileName      | 업로드 된 파일명 | https://mycdn/hong.jpg |
| attachments.downloadFileUrl  | images.uploadedFileName      | 업로드 된 파일명 | https://mycdn/hong.jpg |

**파라미터**:

| 이름        | 위치   | 타입    | 필수 | 설명                                                                              |
| ----------- | ------ | ------- | ---- | --------------------------------------------------------------------------------- |
| boardNo     | path   | string  | ✅   | 조회할 게시판 번호(숫자) 또는 게시판id(문자열)                                    |
| articleNo   | path   | string  | ✅   | 조회할 게시글 번호                                                                |
| password    | query  | string  | ❌   | 비회원 글 확인용 비밀번호                                                         |
| withReplied | query  | boolean | ❌   | 답글도 리스트에 같이 조회할지 여부 (false: 답글 미포함, true: 답글 포함(default)) |
| Version     | header | string  | ✅   | API 버전                                                                          |
| clientId    | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                          |
| platform    | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)                                      |
| accessToken | header | string  | ❌   | 회원 엑세스 토큰                                                                  |
| language    | header | string  | ❌   | 언어 (기본값: ko)                                                                 |

**응답**:

- **200**: 200

---

### PUT /boards/{boardNo}/articles/{articleNo}

**요약**: 게시글 수정하기

**설명**:

## 부가설명 및 특이사항

특정 게시글(게시글 번호 기준)을 수정하는 API 입니다.

첨부파일은 최대 10개까지 업로드 가능합니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                           |
| ----------- | ------ | ------ | ---- | ---------------------------------------------- |
| boardNo     | path   | string | ✅   | 조회할 게시판 번호(숫자) 또는 게시판id(문자열) |
| articleNo   | path   | string | ✅   | 수정할 게시글 번호                             |
| Version     | header | string | ✅   | API 버전                                       |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                       |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)   |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                               |
| language    | header | string | ❌   | 언어 (기본값: ko)                              |

**응답**:

- **204**: 204

---

### DELETE /boards/{boardNo}/articles/{articleNo}

**요약**: 게시글 삭제하기

**설명**:

## 부가설명 및 특이사항

특정 게시글(게시글 번호 기준)을 삭제하는 API 입니다.

비회원으로 작성한 경우, 해당 게시글 작성 비밀번호를 전달해야 합니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                           |
| ----------- | ------ | ------ | ---- | ---------------------------------------------- |
| boardNo     | path   | string | ✅   | 조회할 게시판 번호(숫자) 또는 게시판id(문자열) |
| articleNo   | path   | string | ✅   | 삭제할 게시글 번호                             |
| Version     | header | string | ✅   | API 버전                                       |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                       |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)   |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                               |
| language    | header | string | ❌   | 언어 (기본값: ko)                              |

**응답**:

- **204**: 204

---

### GET /boards/{boardNo}/posts/{postNo}

**요약**: 게시글 상세 조회하기(버전2)

**설명**:

## 부가설명 및 특이사항

특정 게시글(게시글 번호 기준)을 상세 조회하는 Version2 API 입니다.
해당 api에서는 서비스 어드민의 게시판 권한 설정이 적용됩니다.

imageUrl은 게시글 작성하기 API의 thumbnailUrl과 동일합니다.

attachments는 게시글 작성하기 API의 images와 동일합니다.

| 조회 시                      | 저장 시(게시글 작성하기 API) | 설명             | 예시                   |
| ---------------------------- | ---------------------------- | ---------------- | ---------------------- |
| attachments.originalFileName | images.originalFileName      | 원본 파일명      | 홍길동.jpg             |
| attachments.uploadedFileName | images.uploadedFileName      | 업로드 된 파일명 | https://mycdn/hong.jpg |
| attachments.downloadFileUrl  | images.uploadedFileName      | 업로드 된 파일명 | https://mycdn/hong.jpg |

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                           |
| ----------- | ------ | ------ | ---- | ---------------------------------------------- |
| boardNo     | path   | string | ✅   | 조회할 게시판 번호(숫자) 또는 게시판id(문자열) |
| postNo      | path   | string | ✅   | 조회할 게시글 번호                             |
| password    | query  | string | ❌   | 비회원 글 확인용 비밀번호                      |
| Version     | header | string | ✅   | API 버전                                       |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                       |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)   |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                               |
| language    | header | string | ❌   | 언어 (기본값: ko)                              |

**응답**:

- **200**: 200

---

### PUT /boards/{boardNo}/articles/{articleNo}/editable

**요약**: 게시글 수정가능 여부 확인하기

**설명**:

## 부가설명 및 특이사항

특정 게시글(게시글 번호 기준)의 수정가능 여부를 확인하는 API 입니다.

비회원으로 작성한 경우, 해당 게시글 작성 비밀번호를 전달해야 합니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                           |
| ----------- | ------ | ------ | ---- | ---------------------------------------------- |
| boardNo     | path   | string | ✅   | 조회할 게시판 번호(숫자) 또는 게시판id(문자열) |
| articleNo   | path   | string | ✅   | 확인할 게시글 번호                             |
| Version     | header | string | ✅   | API 버전                                       |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                       |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)   |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                               |
| language    | header | string | ❌   | 언어 (기본값: ko)                              |

**응답**:

- **204**: 204

---

### POST /boards/{boardNo}/articles/{articleNo}/recommend

**요약**: 게시글 추천

**설명**:
게시글 추천

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| boardNo     | path   | string | ✅   | 게시판 번호                                  |
| articleNo   | path   | string | ✅   | 추천할 게시글 번호                           |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **204**: 204

---

### DELETE /boards/{boardNo}/articles/{articleNo}/recommend

**요약**: 게시글 추천 취소

**설명**:
게시글 추천 취소

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| boardNo     | path   | string | ✅   | 게시판 번호                                  |
| articleNo   | path   | string | ✅   | 추천할 게시글 번호                           |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **204**: 204

---

### GET /boards/{boardNo}/articles/{articleNo}/replies

**요약**: 게시글 답글 리스트 조회하기

**설명**:

## 부가설명 및 특이사항

특정 게시판(게시판 번호 기준)의 게시글 리스트를 조회하는 API 입니다.

**파라미터**:

| 이름               | 위치   | 타입    | 필수 | 설명                                                                                                 |
| ------------------ | ------ | ------- | ---- | ---------------------------------------------------------------------------------------------------- |
| boardNo            | path   | string  | ✅   | 조회할 게시판 번호(숫자) 또는 게시판id(문자열)                                                       |
| articleNo          | path   | string  | ✅   | 조회할 게시글 번호                                                                                   |
| page               | query  | integer | ❌   | 페이지 번호 (default:1)                                                                              |
| pageSize           | query  | integer | ❌   | 한 페이지당 노출 수 (default:10)                                                                     |
| includeRecommended | query  | boolean | ❌   | 본인이 해당 게시글을 추천했는지 여부(false: 본인 추천 포함x(default), true: 본인 추천 포함)          |
| direction          | query  | string  | ❌   | 정렬방식(ASC: 오래된 순, DESC: 최신 순, RECOMMEND_COUNT: 추천수 많은 순, READ_COUNT: 조회수 많은 순) |
| Version            | header | string  | ✅   | API 버전                                                                                             |
| clientId           | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                             |
| platform           | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)                                                         |
| language           | header | string  | ❌   | 언어 (기본값: ko)                                                                                    |

**응답**:

- **200**: 200

---

### POST /boards/{boardNo}/articles/{articleNo}/report

**요약**: 게시글 신고하기

**설명**:

## 부가설명 및 특이사항

특정 게시글을 신고하는 API 입니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                           |
| ----------- | ------ | ------ | ---- | ---------------------------------------------- |
| boardNo     | path   | string | ✅   | 신고할 게시판 번호(숫자) 또는 게시판id(문자열) |
| articleNo   | path   | string | ✅   | 신고할 게시글 번호                             |
| Version     | header | string | ✅   | API 버전                                       |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                       |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)   |
| accessToken | header | string | ✅   | 회원 엑세스 토큰                               |
| language    | header | string | ❌   | 언어 (기본값: ko)                              |

**응답**:

- **204**: 204

---

### DELETE /boards/{boardNo}/articles/{articleNo}/report

**요약**: 게시글 신고 취소

**설명**:
게시글 신고 취소

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| boardNo     | path   | string | ✅   | 게시판 번호                                  |
| articleNo   | path   | string | ✅   | 신고 취소할 게시글 번호                      |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ✅   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **204**: 204

---

### GET /boards/{boardNo}/posts/{postNo}/file

**요약**: 게시글 첨부파일 다운로드

**설명**:

## 부가설명 및 특이사항

게시글 등록된 첨부파일을 다운로드하는 API 입니다.

**파라미터**:

| 이름             | 위치   | 타입   | 필수 | 설명                                           |
| ---------------- | ------ | ------ | ---- | ---------------------------------------------- |
| boardNo          | path   | string | ✅   | 조회할 게시판 번호(숫자) 또는 게시판id(문자열) |
| postNo           | path   | string | ✅   | 조회할 게시글 번호                             |
| uploadedFileName | query  | string | ✅   | 업로드한 파일이름                              |
| Version          | header | string | ✅   | API 버전                                       |
| clientId         | header | string | ✅   | 쇼핑몰 클라이언트 아이디                       |
| platform         | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)   |
| accessToken      | header | string | ✅   | 회원 엑세스 토큰                               |
| language         | header | string | ❌   | 언어 (기본값: ko)                              |

**응답**:

- **200**: 200

---

### GET /boards/{boardNo}/posts/{postNo}/replies

**요약**: 게시글 답글 리스트 조회하기(버전2)

**설명**:

## 부가설명 및 특이사항

특정 게시판(게시판 번호 기준)의 게시글 리스트를 조회하는 API V2 입니다.

**파라미터**:

| 이름        | 위치   | 타입    | 필수 | 설명                                                                                                 |
| ----------- | ------ | ------- | ---- | ---------------------------------------------------------------------------------------------------- |
| boardNo     | path   | string  | ✅   | 조회할 게시판 번호(숫자) 또는 게시판id(문자열)                                                       |
| postNo      | path   | string  | ✅   | 조회할 게시글 번호                                                                                   |
| page        | query  | integer | ❌   | 페이지 번호 (default:1)                                                                              |
| pageSize    | query  | integer | ❌   | 한 페이지당 노출 수 (default:10)                                                                     |
| direction   | query  | string  | ❌   | 정렬방식(ASC: 오래된 순, DESC: 최신 순, RECOMMEND_COUNT: 추천수 많은 순, READ_COUNT: 조회수 많은 순) |
| Version     | header | string  | ✅   | API 버전                                                                                             |
| clientId    | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                             |
| platform    | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)                                                         |
| accessToken | header | string  | ❌   | 회원 엑세스 토큰                                                                                     |
| language    | header | string  | ❌   | 언어 (기본값: ko)                                                                                    |

**응답**:

- **200**: 200

---

## Holiday

### GET /holiday

**요약**: 요청한 달에 해당하는 공휴일 조회하기

**설명**:

## 부가설명 및 특이사항

해당 연도와 월에 존재하는 공휴일을 조회하는 API 입니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                         |
| -------- | ------ | ------ | ---- | -------------------------------------------- |
| year     | query  | number | ❌   | 검색할 연도                                  |
| month    | query  | number | ❌   | 검색할 월                                    |
| Version  | header | string | ✅   | API 버전                                     |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| language | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

## Inquiry

### GET /inquiries

**요약**: 1:1 문의 내역 조회하기

**설명**:

## 부가설명 및 특이사항

1:1 문의글 목록을 전체 검색하는 API 입니다.

문의 상태 : inquiryStatus와 inqiryStatuses가 있으며, 두 개를 동시에 요청파라미터로 넣으면 그 둘을 합한 상태를 조회합니다.

- inquiryStatus: 하나의 1:1문의 상태에 대해서 조회 가능.
- inquiryStatuses, 여러 개의 1:1문의 상태 조회 가능. ','로 구분.
- (ASKED: 레거시 호환용, ISSUED와 같다.)

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/inquiry/get_inquiries.png'><img src='http://image.toast.com/aaaaahb/api-description/member/inquiry/get_inquiries.png?autox150'></a>

**파라미터**:

| 이름            | 위치   | 타입    | 필수 | 설명                                                                                                              |
| --------------- | ------ | ------- | ---- | ----------------------------------------------------------------------------------------------------------------- |
| pageNumber      | query  | integer | ❌   | 페이지 번호                                                                                                       |
| pageSize        | query  | integer | ❌   | 한 페이지당 노출 수                                                                                               |
| hasTotalCount   | query  | boolean | ❌   | 목록 카운트 포함 여부(false: 미포함(default), true: 포함)                                                         |
| inquiryTypeNo   | query  | number  | ❌   | 1:1 문의 유형 번호                                                                                                |
| inquiryStatus   | query  | string  | ❌   | 1:1 문의 상태 (ISSUED(ASKED-이전버전 호환용): 답변대기, IN_PROGRESS: 답변 진행중, ANSWERED: 답변완료)             |
| inquiryStatuses | query  | string  | ❌   | 1:1 문의 상태 복수개 지정 (ISSUED(ASKED-이전버전 호환용): 답변대기, IN_PROGRESS: 답변 진행중, ANSWERED: 답변완료) |
| startYmd        | query  | string  | ❌   | 조회기간 시작시간                                                                                                 |
| endYmd          | query  | string  | ❌   | 조회기간 종료시간                                                                                                 |
| keyword         | query  | string  | ❌   | 검색어                                                                                                            |
| searchType      | query  | string  | ❌   | 검색 타입 (ALL: 전체, TITLE: 제목, CONTENT: 내용)                                                                 |
| Version         | header | string  | ✅   | API 버전                                                                                                          |
| clientId        | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                                          |
| platform        | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)                                                                      |
| accessToken     | header | string  | ✅   | 회원 엑세스 토큰                                                                                                  |
| language        | header | string  | ❌   | 언어 (기본값: ko)                                                                                                 |

**응답**:

- **200**: 200

---

### POST /inquiries

**요약**: 1:1 문의 등록하기

**설명**:

## 부가설명 및 특이사항

1:1 문의를 등록하는 API 입니다.

샵바이엔터프라이즈 쇼핑몰에서만 비회원 1:1문의가 가능합니다.
비회원 등록 시에는 email을 필수로 입력해야 합니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/inquiry/post_inquiries.png'><img src='http://image.toast.com/aaaaahb/api-description/member/inquiry/post_inquiries.png?autox150'></a>

<hr>

## 참고: 이미지 파일(첨부파일) 업로드 방법 안내

이미지파일 업로드 API를 호출하여 이미지 등록 이후 1:1문의 등록 시 업로드 된 파일명 항목에 등록한 image url 을 입력하여 호출해 주시면 됩니다.

참고로 이미지 업로드 시 이미지 업로드되는 도메인인 base url은 shopby-images.cdn-nhncommerce.com입니다.

이미지 업로드는 관련해서는 아래 내용으로 참고 부탁드립니다.

※해당 API는 별도 API문서가 없습니다.(하이퍼링크 연결 안되는것이 맞음)

POST http://shop-api.e-ncp.com/files/images (리얼)

### header 정보

- Version : 1.0
- clientId : {몰의 clientId}
- platform : (PC, MOBILE_WEB, IOS, AOS 중 하나로 해당 API 를 호출하는 플랫폼의 유형)
- Content-Type : multipart/form-data

### Body :

- file:'image data'

### Request

imageUrl : 이미지 URL

originName : 원본 파일명

파일명의 경우 2~255자 범위내에 있어야합니다.

파일 용량의 경우, 12MB 이하의 이미지 파일만 업로드 가능합니다.

지원하는 확장자는 아래와 같습니다.

bmp, tif, tiff, miff, gif, jpe, jpeg, jpg, jps, pjpeg, jng, mng, png

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

### GET /inquiries/configurations

**요약**: 1:1 문의 설정 조회하기

**설명**:

## 부가설명 및 특이사항

1:1 문의 설정을 조회하는 API 입니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

### GET /inquiries/types

**요약**: 1:1 문의 유형 조회

**설명**:

## 부가설명 및 특이사항

1:1 문의 유형을 조회하는 API 입니다.

## request parameters direction 설명

- ADMIN: 서비스 어드민에서 정렬한 순서
- CREATED_ASC: 최초 등록순
- CREATED_DESC: 최신 등록순

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                         |
| --------- | ------ | ------ | ---- | -------------------------------------------- |
| direction | query  | string | ❌   | 정렬방식(default: ADMIN)                     |
| Version   | header | string | ✅   | API 버전                                     |
| clientId  | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform  | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| language  | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

### GET /inquiries/{inquiryNo}

**요약**: 1:1 문의 상세 조회하기 (문의번호 기준)

**설명**:

## 부가설명 및 특이사항

특정 1:1 문의(문의번호 기준)를 상세 조회하는 API 입니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/inquiry/get_inquiries_inquiryNo.png'><img src='http://image.toast.com/aaaaahb/api-description/member/inquiry/get_inquiries_inquiryNo.png?autox150'></a>

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| inquiryNo   | path   | string | ✅   | 1:1 문의 번호                                |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ✅   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

### PUT /inquiries/{inquiryNo}

**요약**: 1:1 문의 변경하기

**설명**:

## 부가설명 및 특이사항

특정 1:1 문의(문의번호 기준)를 수정하는 API 입니다.

image 삭제는 '1:1 문의 부분 변경하기' API를 통해 해야합니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/inquiry/put_inquiries_inquiryNo.png'><img src='http://image.toast.com/aaaaahb/api-description/member/inquiry/put_inquiries_inquiryNo.png?autox150'></a>

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| inquiryNo   | path   | string | ✅   | 1:1 문의 번호                                |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ✅   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **204**: 204

---

### DELETE /inquiries/{inquiryNo}

**요약**: 1:1문의 삭제하기

**설명**:

## 부가설명 및 특이사항

특정 1:1 문의(문의번호 기준)를 삭제하는 API 입니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/inquiry/delete_inquiries_inquiryNo.png'><img src='http://image.toast.com/aaaaahb/api-description/member/inquiry/delete_inquiries_inquiryNo.png?autox150'></a>

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| inquiryNo   | path   | string | ✅   | 1:1 문의 번호                                |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ✅   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **204**: 204

---

### PATCH /inquiries/{inquiryNo}

**요약**: 1:1 문의 부분 변경하기

**설명**:

## 부가설명 및 특이사항

특정 1:1 문의(문의번호 기준)를 부분 수정하는 API 입니다.

originalFileNames, uploadedFileNames 이 null 인 경우 첨부파일은 수정되지 않습니다.

ex) {
"originalFileNames" : null,
"uploadedFileNames" : null
}

originalFileNames, uploadedFileNames 이 빈 리스트일 경우 첨부파일은 모두 삭제 됩니다.

ex) {
"originalFileNames" : [],
"uploadedFileNames" : []
}

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/inquiry/put_inquiries_inquiryNo.png'><img src='http://image.toast.com/aaaaahb/api-description/member/inquiry/put_inquiries_inquiryNo.png?autox150'></a>

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| inquiryNo   | path   | string | ✅   | 1:1 문의 번호                                |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ✅   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **204**: 204

---

### GET /inquiries/{inquiryNo}/file

**요약**: 1:1 문의 및 답변 파일 다운로드

**설명**:

## 부가설명 및 특이사항

1:1 문의 및 답변 첨부 파일을 다운로드하는 API 입니다.

**파라미터**:

| 이름             | 위치   | 타입   | 필수 | 설명                                                                       |
| ---------------- | ------ | ------ | ---- | -------------------------------------------------------------------------- |
| inquiryNo        | path   | string | ✅   | 1:1 문의 번호                                                              |
| uploadedFileName | query  | string | ✅   | 업로드한 파일이름                                                          |
| type             | query  | string | ✅   | 파일 다운로드 타입(INQUIRY: 일대일 문의, INQUIRY_ANSWER: 일대일 문의 답변) |
| Version          | header | string | ✅   | API 버전                                                                   |
| clientId         | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                   |
| platform         | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)                               |
| accessToken      | header | string | ✅   | 회원 엑세스 토큰                                                           |
| language         | header | string | ❌   | 언어 (기본값: ko)                                                          |

**응답**:

- **200**: 200

---

## Page

### GET /page/scripts

**요약**: 외부스크립트 조회하기

**설명**:

## 부가설명 및 특이사항

외부 스크립트를 조회하는 API 입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| --------- | ------ | ------ | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| pageTypes | query  | string | ✅   | 페이지타입 리스트. "," 구분자 복수개 요청 가능. (MAIN: 메인 페이지, COMMON_HEAD: 상단 공통영역, COMMON_FOOTER: 하단 공통영역, PRODUCT: 상품 상세 페이지, PRODUCT_LIST: 상품 리스트 페이지, PRODUCT_SEARCH: 상품 검색결과 페이지, CART: 장바구니 페이지, ORDER: 주문하기 페이지, ORDER_DETAIL: 주문상세 페이지, ORDER_COMPLETE: 주문완료 페이지, DISPLAY_SECTION: 메인 싱품 분류지, MEMBER_JOIN_COMPLETE: 회원가입완료 페이지, MY_PAGE: 마이 페이지) |
| Version   | header | string | ✅   | API 버전                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| clientId  | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                                                                                                                                                                                                                                                                                                                                            |
| platform  | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)                                                                                                                                                                                                                                                                                                                                                                                                        |
| language  | header | string | ❌   | 언어 (기본값: ko)                                                                                                                                                                                                                                                                                                                                                                                                                                   |

**응답**:

- **200**: 200

---

## Accumulation

### GET /profile/accumulations

**요약**: 적립금 이력 조회하기

**설명**:

## 부가설명 및 특이사항

적립금 이력을 전체 검색하는 API 입니다.

기본 적립금 단위는 정수형으로 지원합니다. ex) 1000
Global Mall의 경우, 적립금은 소수점 2자리까지 지원합니다. ex) 1000.00

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/accumulation/get_profile_accumulations_summary.png'><img src='http://image.toast.com/aaaaahb/api-description/member/accumulation/get_profile_accumulations_summary.png?autox150'></a>

**파라미터**:

| 이름               | 위치   | 타입   | 필수 | 설명                                           |
| ------------------ | ------ | ------ | ---- | ---------------------------------------------- |
| pageNumber         | query  | number | ❌   | 페이지 번호                                    |
| pageSize           | query  | number | ❌   | 페이지 사이즈                                  |
| accumulationReason | query  | string | ❌   | 적립 유형(ADD: 지급, SUB: 차감)                |
| startYmd           | query  | string | ❌   | 조회일 시작일(yyyy-MM-dd, default: 3개월)      |
| endYmd             | query  | string | ❌   | 조회일 종료일(yyyy-MM-dd, default: 오늘)       |
| direction          | query  | string | ❌   | 정렬방식(DESC:내림차순(default), ASC:오름차순) |
| Version            | header | string | ✅   | API 버전                                       |
| clientId           | header | string | ✅   | 쇼핑몰 클라이언트 아이디                       |
| platform           | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)   |
| accessToken        | header | string | ❌   | 회원 엑세스 토큰                               |
| language           | header | string | ❌   | 언어 (기본값: ko)                              |

**응답**:

- **200**: 200

---

### GET /profile/accumulations/expiration

**요약**: 만료 예정 적립금 조회하기

**설명**:

## 부가설명 및 특이사항

만료 예정 적립금을 조회하는 API 입니다.

기본 적립금 단위는 정수형으로 지원합니다. ex) 1000
Global Mall의 경우, 적립금은 소수점 2자리까지 지원합니다. ex) 1000.00

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                                              |
| ----------- | ------ | ------ | ---- | ----------------------------------------------------------------- |
| startYmdt   | query  | string | ❌   | 만료 조회 시작일(YYYY-MM-DD HH:mm:ss, default: 현재 시간 한달 전) |
| endYmdt     | query  | string | ❌   | 만료 조회 종료일(YYYY-MM-DD HH:mm:ss, default: 현재 시간 한달 후) |
| Version     | header | string | ✅   | API 버전                                                          |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                          |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)                      |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                                                  |
| language    | header | string | ❌   | 언어 (기본값: ko)                                                 |

**응답**:

- **200**: 200

---

### GET /profile/accumulations/summary

**요약**: 적립금 요약 조회하기

**설명**:

## 부가설명 및 특이사항

적립금 요약정보를 조회하는 API 입니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/accumulation/get_profile_accumulations.png'><img src='http://image.toast.com/aaaaahb/api-description/member/accumulation/get_profile_accumulations.png?autox150'></a>

**파라미터**:

| 이름            | 위치   | 타입   | 필수 | 설명                                                 |
| --------------- | ------ | ------ | ---- | ---------------------------------------------------- |
| expireStartYmdt | query  | string | ❌   | 만료 조회 시작일(YYYY-MM-DD HH:mm:ss, default: 한달) |
| expireEndYmdt   | query  | string | ❌   | 만료 조회 종료일(YYYY-MM-DD HH:mm:ss, default: 한달) |
| Version         | header | string | ✅   | API 버전                                             |
| clientId        | header | string | ✅   | 쇼핑몰 클라이언트 아이디                             |
| platform        | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)         |
| accessToken     | header | string | ❌   | 회원 엑세스 토큰                                     |
| language        | header | string | ❌   | 언어 (기본값: ko)                                    |

**응답**:

- **200**: 200

---

### GET /profile/accumulations/waiting

**요약**: 해당 회원의 예상 적립금 조회하기

**설명**:

## 부가설명 및 특이사항

해당 회원의 예상 적립금(적립대기)을 조회하는 API 입니다.

몰 화폐 설정에 따라서 적립 금액의 단위가 다릅니다.

기본 적립금 단위는 정수형으로 지원합니다. ex) 1000
Global Mall의 경우, 적립금은 소수점 2자리까지 지원합니다. ex) 1000.00

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/accumulation/get_profile_accumulations_waiting.png'><img src='http://image.toast.com/aaaaahb/api-description/member/accumulation/get_profile_accumulations_waiting.png?autox150'></a>

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                         |
| ----------- | ------ | ------ | ---- | -------------------------------------------- |
| Version     | header | string | ✅   | API 버전                                     |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                             |
| language    | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

## Instagram

### GET /shopby/instagram/media

**요약**: instagram 피드(게시글 목록) 조회하기

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰의 인스타그램 게시글 목록을 조회하는 API 입니다.

조회간 에러 발생시, 에러 정보가 Response 객체에 포함됩니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                         |
| -------- | ------ | ------ | ---- | -------------------------------------------- |
| Version  | header | string | ✅   | API 버전                                     |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| language | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

## Terms

### GET /terms

**요약**: 적용 중인 몰 약관 조회하기

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰의 약관을 조회하는 API 입니다.

**파라미터**:

| 이름       | 위치   | 타입    | 필수 | 설명                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ---------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| termsTypes | query  | string  | ✅   | 조회할 약관 타입 리스트 (MALL_INTRODUCTION: 쇼핑몰/회사 소개, USE: 이용약관, E_COMMERCE: 전자금융거래 이용약관, PI_PROCESS: 개인정보처리방침, PI_COLLECTION_AND_USE_REQUIRED: 개인정보 수집/이용, PI_COLLECTION_AND_USE_OPTIONAL: 개인정보 수집/이용, PI_PROCESS_CONSIGNMENT: 개인정보 처리/위탁, PI_THIRD_PARTY_PROVISION: 개인정보 제3자 제공, PI_COLLECTION_AND_USE_FOR_GUEST_ON_ARTICLE: 개인정보 수집/이용, ACCESS_GUIDE: 이용안내, WITHDRAWAL_GUIDE: 탈퇴안내, PI_SELLER_PROVISION: 개인정보 판매자 제공, PI_COLLECTION_AND_USE_ON_ORDER: 개인정보 수집/이용, ORDER_INFO_AGREE: 구매 동의, CLEARANCE_INFO_COLLECTION_AND_USE: 통관정보 수집/이용, TRANSFER_AGREE: 개인정보 국외 이전 동의, REGULAR_PAYMENT_USE: 정기결제(배송) 이용약관, AUTO_APPROVAL_USE: 자동 승인 이용약관, PI_LIQUOR_PURCHASE_PROVISION: 주류구매 개인정보 수집/이용, PI_RESTOCK_NOTICE: 개인정보 수집/이용, PI_14_AGE: 만 14세 이상 가입 동의, PI_GIFT_ACCEPT_COLLECTION_AND_USE: 선물수락 개인정보 수집/이용) |
| usedOnly   | query  | boolean | ❌   | 사용중인 약관만 노출 여부 (default : false)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| Version    | header | string  | ✅   | API 버전                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| clientId   | header | string  | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| platform   | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| language   | header | string  | ❌   | 언어 (기본값: ko)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |

**응답**:

- **200**: 200

---

### POST /terms

**요약**: 적용 중인 몰 약관 조회하기 (ver 1.1)

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰의 약관을 조회하는 API 입니다. (ver 1.1)
치환하고 싶은 문구를 replacementPhrase 항목에 [key:value]형태로 넣어서 치환할 수 있습니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                         |
| -------- | ------ | ------ | ---- | -------------------------------------------- |
| Version  | header | string | ✅   | API 버전                                     |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| language | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

### POST /terms/custom

**요약**: 추가 약관 조회하기

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰의 추가 약관을 조회하는 API 입니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                         |
| -------- | ------ | ------ | ---- | -------------------------------------------- |
| Version  | header | string | ✅   | API 버전                                     |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| language | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

### GET /terms/history

**요약**: 약관 변경이력 조회하기

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰 약관의 변경이력을 조회하는 API 입니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/common/get_terms_history.png'><img src='http://image.toast.com/aaaaahb/api-description/member/common/get_terms_history.png?autox150'></a>

**파라미터**:

| 이름             | 위치   | 타입   | 필수 | 설명                                                                                                                                                                                          |
| ---------------- | ------ | ------ | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| termsType        | query  | string | ✅   | 조회할 약관 타입 리스트 (USE: 이용약관, E_COMMERCE: 전자금융거래 이용약관, PI_PROCESS: 개인정보처리방침, REGULAR_PAYMENT_USE: 정기결제(배송) 이용약관, AUTO_APPROVAL_USE: 자동 승인 이용약관) |
| futureDaysToShow | query  | string | ❌   | 조회할 현재부터 미래 날짜                                                                                                                                                                     |
| Version          | header | string | ✅   | API 버전                                                                                                                                                                                      |
| clientId         | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                                                                                      |
| platform         | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)                                                                                                                                                  |
| language         | header | string | ❌   | 언어 (기본값: ko)                                                                                                                                                                             |

**응답**:

- **200**: 200

---

### GET /terms/used

**요약**: 적용 중인 몰 약관 조회하기

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰의 현재 적용중인 약관타입만 조회하는 API 입니다.

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ---------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| termsTypes | query  | string | ✅   | 조회할 약관 타입 리스트 (MALL_INTRODUCTION: 쇼핑몰/회사 소개, USE: 이용약관, E_COMMERCE: 전자금융거래 이용약관, PI_PROCESS: 개인정보처리방침, PI_COLLECTION_AND_USE_REQUIRED: 개인정보 수집/이용, PI_COLLECTION_AND_USE_OPTIONAL: 개인정보 수집/이용, PI_PROCESS_CONSIGNMENT: 개인정보 처리/위탁, PI_THIRD_PARTY_PROVISION: 개인정보 제3자 제공, PI_COLLECTION_AND_USE_FOR_GUEST_ON_ARTICLE: 개인정보 수집/이용, ACCESS_GUIDE: 이용안내, WITHDRAWAL_GUIDE: 탈퇴안내, PI_SELLER_PROVISION: 개인정보 판매자 제공, PI_COLLECTION_AND_USE_ON_ORDER: 개인정보 수집/이용, ORDER_INFO_AGREE: 구매 동의, CLEARANCE_INFO_COLLECTION_AND_USE: 통관정보 수집/이용, TRANSFER_AGREE: 개인정보 국외 이전 동의, REGULAR_PAYMENT_USE: 정기결제(배송) 이용약관, AUTO_APPROVAL_USE: 자동 승인 이용약관, PI_LIQUOR_PURCHASE_PROVISION: 주류구매 개인정보 수집/이용, PI_RESTOCK_NOTICE: 개인정보 수집/이용, PI_14_AGE: 만 14세 이상 가입 동의, PI_GIFT_ACCEPT_COLLECTION_AND_USE: 선물수락 개인정보 수집/이용) |
| Version    | header | string | ✅   | API 버전                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| clientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| platform   | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| language   | header | string | ❌   | 언어 (기본값: ko)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |

**응답**:

- **200**: 200

---

### GET /terms/{termsNo}

**요약**: 약관 상세 조회하기

**설명**:

## 부가설명 및 특이사항

특정 약관(약관번호 기준)을 상세 조회하는 API 입니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/common/get_terms_termsno.png'><img src='http://image.toast.com/aaaaahb/api-description/member/common/get_terms_termsno.png?autox150'></a>

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                         |
| -------- | ------ | ------ | ---- | -------------------------------------------- |
| termsNo  | path   | string | ✅   | 조회할 약관 번호                             |
| Version  | header | string | ✅   | API 버전                                     |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| language | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---

### POST /terms/{termsNo}

**요약**: 약관 상세 조회하기 (ver 1.1)

**설명**:

## 부가설명 및 특이사항

특정 약관(약관번호 기준)을 상세 조회하는 API 입니다. (ver 1.1)
치환하고 싶은 문구를 replacementPhrase 항목에 [key:value]형태로 넣어서 치환할 수 있습니다.

## 화면 예시

<a target='_blank' href='http://image.toast.com/aaaaahb/api-description/member/common/get_terms_termsno.png'><img src='http://image.toast.com/aaaaahb/api-description/member/common/get_terms_termsno.png?autox150'></a>

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                         |
| -------- | ------ | ------ | ---- | -------------------------------------------- |
| termsNo  | path   | string | ✅   | 조회할 약관 번호                             |
| Version  | header | string | ✅   | API 버전                                     |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디                     |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS) |
| language | header | string | ❌   | 언어 (기본값: ko)                            |

**응답**:

- **200**: 200

---
