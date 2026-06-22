# member-shop

**버전**: 1.0
**서버**: https://shop-api.e-ncp.com

쇼핑몰 회원(member) 관련 shop API입니다.

---

## Company

### GET /companies/business-exist

**요약**: 사업자회원 사업자등록번호 중복체크

**설명**:

## 부가설명 및 특이사항

사업자등록번호 중복체크하는 API 입니다.

**파라미터**:

| 이름         | 위치   | 타입   | 필수 | 설명                                          |
| ------------ | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| registration | query  | string | ✅   | 사업자등록번호 (10자리)^                      | 1234567890     |
| Version      | header | string | ✅   | API 버전^                                     | 1.0            |
| platform     | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId     | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language     | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

## Member-Config

### GET /config/member-extra-info

**요약**: 회원정보 추가항목 Config 조회

**설명**:

쇼핑몰 회원정보 추가항목 관련된 설정을 조회합니다

- 타입종류 : 텍스트박스(TEXTBOX), 라디오버튼(RADIOBUTTON), 체크박스(CHECKBOX), 드롭다운(DROPDOWN), 이미지(IMAGE)
- 상태종류 : 필수(REQUIRED), 사용(USED)

## Response

|        name         |  type  | description            |
| :-----------------: | :----: | :--------------------- |
|  extraInfoContents  | array  | 회원정보 추가항목 목록 |
|     extraInfoNo     | number | 항목 번호              |
|    extraInfoName    | string | 항목 명                |
|       status        | string | 사용 상태              |
|    extraInfoType    | string | 항목 타입              |
|  extraInfoOptions   | array  | 옵션 목록              |
|  extraInfoOptionNo  | number | 옵션 번호              |
| extraInfoOptionName | string | 옵션 명                |

|

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

## Member-Grade

### GET /member-grades

**요약**: 회원 등급 정보 조회하기

**설명**:

## 부가설명 및 특이사항

회원 등급 번호를 통해 회원 등급 정보를 조회하는 API 입니다. <br>
회원 등급 번호 미 입력 시 쇼핑몰에 등록된 모든 회원 등급 정보를 조회합니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                                                                  |
| -------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------- | -------------- |
| gradeNos | query  | string | ❌   | 회원 등급 번호 리스트 (미 입력 시 쇼핑몰에 등록된 모든 회원 등급 정보를 조회합니다.)^ | 1,2,3          |
| Version  | header | string | ✅   | API 버전^                                                                             | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                                         | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                                             | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                                                                    | ko             |

**응답**:

- **200**: 200

---

## Member-Group

### GET /member-groups

**요약**: 회원 그룹 정보 조회하기

**설명**:

## 부가설명 및 특이사항

회원 그룹 번호를 통해 회원 그룹 정보를 조회하는 API 입니다. <br>
회원 그룹 번호 미 입력 시 쇼핑몰에 등록된 모든 그룹 정보를 조회합니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                                                             |
| -------- | ------ | ------ | ---- | -------------------------------------------------------------------------------- | -------------- |
| groupNos | query  | string | ❌   | 회원 그룹 번호 리스트 (미 입력 시 쇼핑몰에 등록된 모든 그룹 정보를 조회합니다.)^ | 1,2,3          |
| Version  | header | string | ✅   | API 버전^                                                                        | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                                    | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                                        | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                                                               | ko             |

**응답**:

- **200**: 200

---

## Profile

### GET /profile

**요약**: 회원정보 조회하기

**설명**:

## 부가설명 및 특이사항

회원 정보를 조회합니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /profile

**요약**: 프로필 생성하기

**설명**:

## 부가설명 및 특이사항

회원 프로필 등록 시 사용하는 API 입니다.

회원가입 화면구현 관련 자세한 내용은 [스킨개발가이드](https://workspace.nhn-commerce.com/guide/skin/dev-cover/join?lv=11) 참고하시길 바랍니다.

- 회원가입 항목 관리 기능 설정에 따라 필수/선택값이 달라질 수 있습니다. 해당 내용은 2024년 3월 27일 적용 예정입니다.
  회원가입 항목관리 설정 내용은 GET /malls 의 memberJoinConfig 에서 확인할 수 있습니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### PUT /profile

**요약**: 회원정보 수정하기 v1.0

**설명**:

## 부가설명 및 특이사항

회원정보를 수정합니다.

- V1.0 - 회원 정보를 수정합니다.
- V1.1 - 회원의 현재 비밀번호를 입력받아 비밀번호 확인을 한 후 회원의 정보를 수정합니다.
  리퀘스트는 Examples에서 확인해주세요.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### DELETE /profile

**요약**: 회원 탈퇴하기

**설명**:

## 부가설명 및 특이사항

회원 탈퇴 시 사용하는 API 입니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| reason                | query  | string | ❌   | 탈퇴 사유^                                    | 테스트용                 |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### PUT /profile/address

**요약**: 프로필 주소 변경하기

**설명**:

## 부가설명 및 특이사항

회원의 주소를 변경하는 API 입니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### GET /profile/blocked-members

**요약**: 차단된 회원 조회하기

**설명**:

## 부가설명 및 특이사항

내가 차단한 회원의 목록을 조회합니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입    | 필수 | 설명                                                       |
| --------------------- | ------ | ------- | ---- | ---------------------------------------------------------- | ------------------------ |
| pageNumber            | query  | integer | ❌   | 페이지 번호^                                               | 1                        |
| pageSize              | query  | integer | ❌   | 한 페이지당 노출 수^                                       | 1                        |
| hasTotalCount         | query  | boolean | ❌   | 목록 카운트 포함 여부(false: 미포함(default), true: 포함)^ | false                    |
| Version               | header | string  | ✅   | API 버전^                                                  | 1.0                      |
| platform              | header | string  | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^              | PC                       |
| clientId              | header | string  | ✅   | 쇼핑몰 클라이언트 아이디^                                  | test-client-id           |
| language              | header | string  | ❌   | 언어 (기본값: ko)^                                         | ko                       |
| accessToken           | header | string  | ❌   | 액세스 토큰^                                               | accessToken              |
| Shop-By-Authorization | header | string  | ❌   | 액세스 토큰(Oauth2 스펙)^                                  | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /profile/blocked-members

**요약**: 회원 차단하기

**설명**:

## 부가설명 및 특이사항

회원을 차단합니다. 차단 시 즉시 차단한 회원이 작성한 상품평, 게시글, 1:1문의 등의 내용을 차단합니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /profile/brand-oauth

**요약**: 브랜드 회원 회원가입 처리하기 Ver1.1

**설명**:

## 부가설명 및 특이사항

브랜드 회원의 회원 가입 처리 API입니다.

브랜드 로그인으로 서브몰에서 최초 로그인한 회원인 경우 위 API를 호출하여 가입 완료 처리를 해야합니다.
가입 처리시 약관 및 수신 동의 여부를 받을 수 있습니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## Ver 1.0

- MemberType = [MALL: 쇼핑몰 회원, OPENID: 연동형 회원, NEOID: 간편로그인 회원]
- MemberStatus = [WAITING: 대기, ACTIVE: 가입완료, FREEZE or DORMANT: 휴면 , PAUSED :이용정지]

## Ver 1.1

- MemberType = [MALL: 쇼핑몰 회원, SYNC_ID: 연동형 회원, OPEN_ID: 간편로그인 회원]
- MemberStatus = [WAITING: 대기, ACTIVE: 가입완료, WITHDRAWN: 탈퇴, FREEZE or DORMANT: 휴면 , PAUSED :이용정지, PENDING: 승인대기]

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /profile/change-password-after-cert

**요약**: 비밀번호 변경

**설명**:

## 부가설명 및 특이사항

회원 인증 후 비밀번호를 변경합니다. 기존에 사용중이던 비밀번호와 동일한 비밀번호로 변경할 수 없습니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **204**: 204

---

### POST /profile/check-password

**요약**: 비밀번호 확인하기

**설명**:

## 부가설명 및 특이사항

현재 로그인한 사용자가 맞는지 비밀번호를 한번 더 체크할 때 사용하는 API 입니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## 화면 예시

![img](http://image.toast.com/aaaaahb/api-description/member/profile/post_profile_check-password.png?autox150)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204
- **400**: 400

---

### GET /profile/dormancy

**요약**: 휴면 회원 조회하기

**설명**:

## 부가설명 및 특이사항

휴면 해제 화면에 노출할 휴면 계정 정보를 조회합니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /profile/dormancy

**요약**: 휴면 해제하기

**설명**:

## 부가설명 및 특이사항

회원의 휴면 상태를 해제합니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### PUT /profile/expel

**요약**: 비밀번호 검증 후 회원 탈퇴하기

**설명**:

## 부가설명 및 특이사항

쇼핑몰 회원일 경우 비밀번호 검증 후 회원 탈퇴합니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **204**: 204

---

### POST /profile/find-id

**요약**: 아이디 찾기

**설명**:

## 부가설명 및 특이사항

회원가입시 입력한 정보로 내 아이디를 검색합니다.

- 운영자가 이름을 필수 항목으로 설정한 경우 회원 이름을 같이 전달해야합니다.
- 이름의 경우, memberName 혹은 firstName,lastName 중 하나의 조합으로 전달해야합니다.
- 운영자가 인증번호 확인을 필수로 설정한 경우 인증번호를 같이 전달해야합니다.
- 인증번호 확인 또는 휴대폰 본인인증을 사용하지 않은 경우 아이디, 이름, 휴대폰번호, 이메일은 마스킹된 결과가 노출됩니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### POST /profile/find-password

**요약**: 비밀번호 찾기

**설명**:

## 부가설명 및 특이사항

회원 정보의 이메일로 비밀번호 재설정 주소 전달

## 화면 예시

[![img](http://image.toast.com/aaaaahb/api-description/member/profile/put_profile_password_sending-email-with-url.png?autox150)](http://image.toast.com/aaaaahb/api-description/member/profile/put_profile_password_sending-email-with-url.png)

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### GET /profile/grade

**요약**: 내 등급 조회하기

**설명**:

## 부가설명 및 특이사항

내 등급 정보를 가져옵니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/id

**요약**: 아이디 찾기 v1.1

**설명**:

## 부가설명 및 특이사항

모바일 or 이메일 인중 후 아이디를 조회할 수 있는 API 입니다. (version 1.1)

**파라미터**:

| 이름                | 위치   | 타입   | 필수 | 설명                                                                                   |
| ------------------- | ------ | ------ | ---- | -------------------------------------------------------------------------------------- | -------------- |
| companyNo           | query  | number | ❌   | 법인번호^                                                                              | 123            |
| memberName          | query  | string | ❌   | 이름 (쇼핑몰 회원가입 정보 설정에서 회원명을 사용함 또는 필수로 지정한 경우 필수입력)^ | 홍길동         |
| mobileNo            | query  | string | ❌   | 휴대전화 번호 (SMS 인증 찾기로 인증번호 전송시 입력)^                                  | 01012341234    |
| email               | query  | string | ❌   | 이메일 (이메일 찾기로 인증번호 전송시 입력)^                                           | aaa@bbb.ccc    |
| ci                  | query  | string | ❌   | CI^                                                                                    | ASDF1234       |
| certificationNumber | query  | string | ❌   | 인증번호^                                                                              | 123123         |
| Version             | header | string | ✅   | API 버전^                                                                              | 1.1            |
| platform            | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^                                          | PC             |
| clientId            | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                                                              | test-client-id |
| language            | header | string | ❌   | 언어 (기본값: ko)^                                                                     | ko             |

**응답**:

- **200**: 200

---

### PUT /profile/id

**요약**: 회원 아이디 변경하기

**설명**:

## 부가설명 및 특이사항

인증 후 회원 아이디를 변경할 수 있는 API 입니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **204**: 204

---

### GET /profile/next-grade

**요약**: 내 다음 등급 조회하기

**설명**:

## 부가설명 및 특이사항

내 다음 예상 등급 정보를 가져옵니다.
몰의 전체 등급 리스트와 현재 실적도 같이 내려줍니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /profile/non-masking

**요약**: 마스킹 해제된 회원정보 조회하기

**설명**:

## 부가설명 및 특이사항

비밀번호 인증으로 마스킹 해제된 회원정보를 조회합니다.
오픈아이디의 경우, 재인증을 통해 마스킹 해제된 회원정보를 조회할 수 있습니다.

- Oauth 스펙 - [오픈아이디 토큰 발급하기 - POST](https://docs.shopby.co.kr/?url.primaryName=auth/#/Authentication/post-oauth-openid)
  -> reauthenticate 인자값 사용
- Oauth2 스펙 - [오픈아이디 토큰 재인증 처리하기](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/put-oauth2-openid-reauthenticate)

## 쇼핑몰 회원인 경우 Request Body

| name     | type   | required | default value | description |
| -------- | ------ | -------- | ------------- | ----------- |
| password | String | Y        |               | 비밀번호    |

## 오픈아이디 회원의 경우 Request Body

### Body 값 없이 POST 요청

## 화면 예시

![img](http://image.toast.com/aaaaahb/api-description/member/profile/post_profile_check-password.png?autox150)

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /profile/openid

**요약**: 오픈 아이디 회원가입 처리하기 Ver1.1

**설명**:

## 부가설명 및 특이사항

오픈 아이디를 사용한 회원 가입 처리입니다.

간편 로그인으로 신규 가입을 하는 회원인 경우 위 API를 호출하여 가입 완료 처리를 해야합니다.<br/>
가입 처리시 추가적인 사용자 정보를 받을 수 있습니다.<br/>

카카오싱크 회원의 경우 약관은 카카오싱크 연동과 동시에 저장되기 때문에 joinTermsAgreements는 null로 보내주시면 됩니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

## Ver 1.0

- MemberType = [MALL: 쇼핑몰 회원, OPENID: 연동형 회원, NEOID: 간편로그인 회원]
- MemberStatus = [WAITING: 대기, ACTIVE: 가입완료, FREEZE or DORMANT: 휴면 , PAUSED :이용정지]

## Ver 1.1

- MemberType = [MALL: 쇼핑몰 회원, SYNC_ID: 연동형 회원, OPEN_ID: 간편로그인 회원]
- MemberStatus = [WAITING: 대기, ACTIVE: 가입완료, WITHDRAWN: 탈퇴, FREEZE or DORMANT: 휴면 , PAUSED :이용정지, PENDING: 승인대기]

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### PUT /profile/password

**요약**: 비밀번호 변경하기

**설명**:

## 부가설명 및 특이사항

인증이 완료된 사용자의 비밀번호를 변경합니다. (version 1.1)

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                          |
| ----------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version     | header | string | ✅   | API 버전^                                     | 1.1            |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| accessToken | header | string | ✅   | 액세스 토큰^                                  | accessToken    |

**응답**:

- **204**: 204

---

### POST /profile/rename

**요약**: NHN KCP 본인인증으로 회원 개인정보 갱신하기

**설명**:

## 부가설명 및 특이사항

NHN KCP에서 보내준 본인인증 확인키를 파라미터로 보내, 회원의 이름/성별/생년월일/CI 등의 정보를 본인인증 정보로 업데이트합니다.

(※ 본인인증 키는 KCP 본인확인 절차를 참고바랍니다)

단, 만약 이미 동일한 실명으로 인증된 회원이 있을 경우(자기 자신 제외) 본인인증 정보가 갱신되지 않습니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /profile/report

**요약**: 회원 신고하기

**설명**:

## 부가설명 및 특이사항

회원을 신고합니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### POST /profile/synchronize

**요약**: 기존 회원을 오픈 아이디 회원으로 전환하기(카카오싱크 전용)

**설명**:

## 부가설명 및 특이사항

기존 회원을 오픈 아이디 회원으로 전환합니다.

오픈 아이디 회원으로 가입시, 같은 이메일을 가진 기존 일반 회원을 합칠 때 사용합니다.

일반 회원에서 오픈 아이디 회원으로 전환이 완료되면 가입 완료 처리가 됩니다.

전환 완료시, 기존 토큰은 만료처리되고 새로운 토큰이 발급됩니다.

이후, ID/PW 로그인을 불가능하며 전환한 오픈 아이디 회원으로 로그인이 가능합니다.

현재는 카카오싱크 회원만 지원합니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/ci/exists

**요약**: CI 중복확인하기

**설명**:

## 부가설명 및 특이사항

쇼핑몰에 동일한 CI를 사용중인 회원이 있는지 확인합니다.
현재 회원이 로그인중인 경우, 엑세스 토큰을 함께 전달하면 본인을 제외하고 동일한 CI를 사용중인 회원이 있는지 확인합니다.

휴대폰 본인인증을 사용하는 경우 여러 사용자가 동일한 CI로 회원가입할 수 없습니다.
회원가입 / 수정 전 CI를 반드시 확인해주세요.

요청 CI 값은 [KCP 본인인증 결과 조회하기 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/KCPCertification/get-kcp-id-verification-response) Response 객체의 CI 값을 이용합니다.
CI는 특수문자를 포함하고 있기때문에, [URL 인코딩](https://www.urlencoder.org/ko/) 을 한 뒤에 전달해야합니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                          |
| ----------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| ci          | query  | string | ✅   | CI^                                           | abcde          |
| Version     | header | string | ✅   | API 버전^                                     | 1.0            |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language    | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |
| accessToken | header | string | ❌   | 회원 엑세스 토큰                              |

**응답**:

- **200**: 200

---

### GET /profile/ci/myself

**요약**: CI 일치 확인하기

**설명**:

## 부가설명 및 특이사항

쇼핑몰 회원의 CI와 요청 CI 값이 일치하는지 확인합니다.
엑세스 토큰을 함께 전달하여 본인의 CI 값과 요청 CI를 비교하여 일치하는지 확인합니다.

요청 CI 값은 [KCP 본인인증 결과 조회하기 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/KCPCertification/get-kcp-id-verification-response) Response 객체의 CI 값을 이용합니다.
CI는 특수문자를 포함하고 있기때문에, [URL 인코딩](https://www.urlencoder.org/ko/) 을 한 뒤에 전달해야합니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                          |
| ----------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| ci          | query  | string | ✅   | 임의로 생성된 개인인증 값^                    | abcde          |
| Version     | header | string | ✅   | API 버전^                                     | 1.0            |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language    | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |
| accessToken | header | string | ✅   | 회원 엑세스 토큰                              |

**응답**:

- **200**: 200

---

### GET /profile/email/exist

**요약**: 해당 쇼핑몰에 이메일 중복여부 체크하기

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰에 입력한 이메일을 가진 회원이 있는지 확인합니다.
true가 회신되는 경우 이미 해당 이메일로 가입한 회원이 존재합니다. (이메일 중복 입력)

## Parameters

|    name     |  type  | required | default value | description                                                                              |
| :---------: | :----: | :------: | :-----------: | :--------------------------------------------------------------------------------------- |
|    email    | string |    Y     |       -       | 이메일                                                                                   |
| memberTypes | string |    N     |       -       | 회원 유형(list) <br> MALL: 일반 회원<br>SYNC_ID: 연동형 회원<br>OPEN_ID: 간편로그인 회원 |

## 화면 예시

![img](http://image.toast.com/aaaaahb/api-description/member/profile/get_profile_email_exist.png?autox150)

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                          |
| ----------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| email       | query  | string | ✅   | 회원 이메일 주소^                             | test@test.com  |
| memberTypes | query  | string | ❌   | 회원유형 리스트 (기본 - 쇼핑몰 회원(MALL)     |
| Version     | header | string | ✅   | API 버전^                                     | 1.0            |
| platform    | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId    | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language    | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### POST /profile/external-member/exist

**요약**: 외부회원 중복확인하기

**설명**:

## 부가설명 및 특이사항

전달 받은 openAccessToken을 활용하여 해당 토큰에 해당하는 회원이 이미 가입되어있는지 확인합니다.
외부회원연동을 사용하는 몰에서만 사용가능합니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### POST /profile/id/email

**요약**: ID 변경 메일 발송하기

**설명**:

## 부가설명 및 특이사항

ID를 변경할 수 있는 내용을 첨부한 email을 발송하는 API 입니다.

## OAUTH2 참고사항

- [Oauth2 API](https://docs.shopby.co.kr/?url.primaryName=auth/#/OAUTH2/post-oauth2-token) 를 사용하여 토큰을 발급받은 경우,
- 기존 accessToken 대신 Shop-By-Authorization 로 액세스 토큰을 전달해야합니다.
- ex) Shop-By-Authorization : Bearer test-access-token

**파라미터**:

| 이름                  | 위치   | 타입   | 필수 | 설명                                          |
| --------------------- | ------ | ------ | ---- | --------------------------------------------- | ------------------------ |
| Version               | header | string | ✅   | API 버전^                                     | 1.0                      |
| platform              | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC                       |
| clientId              | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id           |
| language              | header | string | ❌   | 언어 (기본값: ko)^                            | ko                       |
| accessToken           | header | string | ❌   | 액세스 토큰^                                  | accessToken              |
| Shop-By-Authorization | header | string | ❌   | 액세스 토큰(Oauth2 스펙)^                     | Bearer test-access-token |

**응답**:

- **200**: 200

---

### GET /profile/id/exist

**요약**: 해당 쇼핑몰에 아이디 중복여부 체크하기

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰에 입력한 아이디로 가진 회원이 있는지 확인합니다.
true가 회신되는 경우 이미 해당 아이디로 가입한 회원이 존재합니다. (아이디 중복 입력)

## 화면 예시

![img](http://image.toast.com/aaaaahb/api-description/member/profile/get_profile_id_exist.png?autox150)

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| memberId | query  | string | ✅   | 회원 ID^                                      | memberId       |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### GET /profile/member/extra-infos

**요약**: 회원별 추가항목 조회

**설명**:

## 부가설명 및 특이사항

회원별 추가항목 정보를 조회합니다.
추가항목 공개여부가 Y 인 항목들만 조회가 가능합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                          |
| --------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| memberNos | query  | string | ✅   | 회원 번호 목록^                               | 1,2,3          |
| Version   | header | string | ✅   | API 버전^                                     | 1.0            |
| platform  | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId  | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language  | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### GET /profile/mobile/exist

**요약**: 해당 쇼핑몰에 휴대폰 번호 중복여부 확인하기

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰에 입력한 휴대폰번호가 있는지 확인하는 API 입니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| mobileNo | query  | string | ✅   | 휴대전화 번호^                                | 01012345678    |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### GET /profile/nickname/exist

**요약**: 해당 쇼핑몰에 닉네임 중복여부 체크하기

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰에 입력한 닉네임으로 가진 회원이 있는지 확인합니다.
true가 회신되는 경우 이미 해당 닉네임으로 가입한 회원이 존재합니다. (닉네임 중복 입력)

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| nickname | query  | string | ✅   | 회원 닉네임^                                  | jinsu          |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### GET /profile/password/search-account

**요약**: 비밀번호 찾기를 위한 계정 조회하기

**설명**:

## 부가설명 및 특이사항

비밀번호 찾기를 위한 계정 정보를 조회합니다.
개인정보 항목인 이름, 휴대폰번호, 이메일은 마스킹된 값으로 조회됩니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| memberId | query  | string | ✅   | 검색할 회원 아이디^                           | memberId       |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### PUT /profile/password/sending-email-with-url

**요약**: 비밀번호 변경/초기화 URL의 이메일 발송하기

**설명**:

## 부가설명 및 특이사항

비밀번호 변경 또는 초기화하는 URL을 해당 사용자의 이메일로 발송합니다

## 화면 예시

![img](http://image.toast.com/aaaaahb/api-description/member/profile/put_profile_password_sending-email-with-url.png?autox150)

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **204**: 204

---

### GET /profile/member/equals/with-email

**요약**: 해당 쇼핑몰 아이디, 이름, 이메일 검증하기

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰에 입력한 아이디, 이름, 이메일과 동일한 회원이 있는지 여부 확인합니다.
true이면 회원이 존재합니다.

## 화면 예시

![img](http://image.toast.com/aaaaahb/api-description/member/profile/get_profile_member_equals_with-mobile1.png?autox150)
![img](http://image.toast.com/aaaaahb/api-description/member/profile/get_profile_member_equals_with-mobile2.png?autox150)

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                          |
| ---------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| memberId   | query  | string | ✅   | 아이디                                        |
| memberName | query  | string | ✅   | 이름                                          |
| email      | query  | string | ✅   | 이메일                                        |
| Version    | header | string | ✅   | API 버전^                                     | 1.0            |
| platform   | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language   | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### GET /profile/member/equals/with-mobile

**요약**: 해당 쇼핑몰 아이디, 이름, 휴대폰 번호 검증하기

**설명**:

## 부가설명 및 특이사항

해당 쇼핑몰에 입력한 아이디, 이름, 휴대폰 번호와 동일한 사용자가 있는지 여부 확인합니다.
true이면 회원이 존재합니다.

## 화면 예시

![img](http://image.toast.com/aaaaahb/api-description/member/profile/get_profile_member_equals_with-mobile1.png?autox150)
![img](http://image.toast.com/aaaaahb/api-description/member/profile/get_profile_member_equals_with-mobile2.png?autox150)

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                          |
| ---------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| memberId   | query  | string | ✅   | 아이디^                                       | test001        |
| memberName | query  | string | ✅   | 이름^                                         | 홍길동         |
| mobileNo   | query  | string | ✅   | 휴대폰 번호^                                  | aaa@bbb.ccc    |
| Version    | header | string | ✅   | API 버전^                                     | 1.0            |
| platform   | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId   | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language   | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **200**: 200

---

### PUT /profile/password/no-authentication/after-certification

**요약**: 본인인증 후 비밀번호 변경하기

**설명**:

## 부가설명 및 특이사항

로그인하지 않음 사용자의 비밀번호를 변경합니다.
본인인증 후의 단계 이므로 이전단계인 본인인증 관련 API는 본인인증 API링크 참고 바랍니다. [본인인증](https://docs.shopby.co.kr/?urls.primaryName=auth#/%5BProfile%5D%20%3E%20KCPCertification/render_kcp_form)

## 화면 예시

[![sample](https://image.toast.com/aaaaahb/api-description/member/profile/put_profile_password_no-authenication_after-certification.png?autox150)](https://image.toast.com/aaaaahb/api-description/member/profile/put_profile_password_no-authenication_after-certification.png)

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **204**: 204

---

### PUT /profile/password/no-authentication/certificated-by-email

**요약**: 이메일 인증 후 패스워드 변경하기.

**설명**:

## 부가설명 및 특이사항

로그인하지 않음 사용자의 비밀번호를 변경합니다.
본인인증 후의 단계 이므로 이전단계인 본인인증 관련 API는 본인인증 API링크 참고 바랍니다. [본인인증](https://docs.shopby.co.kr/?urls.primaryName=auth#/%5BProfile%5D%20%3E%20KCPCertification/render_kcp_form)

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **204**: 204

---

### PUT /profile/password/no-authentication/certificated-by-sms

**요약**: SMS 인증 후 패스워드 변경하기

**설명**:

## 부가설명 및 특이사항

로그인하지않은 사용자의 비밀번호를 변경합니다. (SMS 인증 사용)

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, AOS, IOS)^ | PC             |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| language | header | string | ❌   | 언어 (기본값: ko)^                            | ko             |

**응답**:

- **204**: 204

---
