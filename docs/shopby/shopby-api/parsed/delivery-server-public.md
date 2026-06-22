# delivery-server

**버전**: 1.0
**서버**: https://server-api.e-ncp.com

배송(delivery)관련 server API입니다.

---

## AreaFee

### GET /areafees

**요약**: 지역별 추가배송비 설정 내역 조회하기

**설명**:

## 부가설명 및 특이사항

파트너의 지역별 추가배송비 설정 내역을 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| page      | query  | number | ✅   | 시작 번호[페이징 처리] (1 이상)^                      | 1   |
| size      | query  | number | ✅   | 종료 번호[페이징 처리]^                               | 30  |
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

### POST /areafees

**요약**: 지역별 추가배송비 설정 생성하기

**설명**:

## 부가설명 및 특이사항

파트너의 지역별 추가배송비 설정을 생성합니다.

### areaNo

- 198,인천광역시 강화군 교동면
- 199,인천광역시 강화군 삼산면
- 200,인천광역시 강화군 서도면
- 201,인천광역시 옹진군 대청면
- 202,인천광역시 옹진군 덕적면
- 203,인천광역시 옹진군 백령면
- 204,인천광역시 옹진군 북도면
- 205,인천광역시 옹진군 연평면
- 206,인천광역시 옹진군 자월면
- 207,인천광역시 중구 무의동
- 208,전라북도 군산시 옥도면
- 209,전라북도 부안군 위도면
- 210,부산광역시 강서구 눌차동
- 211,부산광역시 강서구 대항동
- 212,부산광역시 강서구 동선동
- 213,부산광역시 강서구 성북동
- 214,부산광역시 강서구 천성동
- 215,경상남도 거제시 장목면 시방리
- 216,경상남도 거제시 둔덕면 술역리
- 217,경상남도 사천시 마도동
- 218,경상남도 사천시 신수동
- 219,경상남도 통영시 사량면
- 220,경상남도 통영시 욕지면
- 221,경상남도 통영시 용남면 어의리
- 222,경상남도 통영시 용남면 지도리
- 223,경상남도 통영시 한산면
- 224,경상남도 통영시 산양읍 저림리
- 225,경상남도 통영시 산양읍 추도리
- 226,경상남도 통영시 산양읍 연곡리
- 227,경상남도 통영시 산양읍 곤리리
- 228,제주특별자치도 제주시
- 229,제주특별자치도 제주시 우도면
- 230,제주특별자치도 제주시 추자면
- 231,제주특별자치도 서귀포시
- 232,경상북도 울릉군 북면
- 233,경상북도 울릉군 서면
- 234,경상북도 울릉군 울릉읍
- 235,경상북도 상주시 화북면
- 236,경상북도 상주시 외서면 대전리
- 237,충청남도 당진시 석문면 난지도리
- 238,충청남도 당진시 신평면 매산리
- 239,충청남도 보령시 오천면 녹도리
- 240,충청남도 보령시 오천면 삽시도리
- 241,충청남도 보령시 오천면 외연도리
- 242,충청남도 보령시 오천면 원산도리
- 243,충청남도 보령시 오천면 효자도리
- 244,충청남도 서산시 지곡면 중왕리
- 245,충청남도 태안군 근흥면 가의도리
- 246,전라남도 고흥군 봉래면 사양리
- 247,전라남도 고흥군 도양읍 시산리
- 248,전라남도 고흥군 도양읍 봉암리 상화도
- 249,전라남도 고흥군 도양읍 봉암리 하화도
- 250,전라남도 고흥군 도양읍 득량리
- 251,전라남도 고흥군 도화면 지죽리
- 252,전라남도 목포시 달동
- 253,전라남도 목포시 율도동
- 254,전라남도 신안군 도초면
- 255,전라남도 신안군 비금면
- 256,전라남도 신안군 신의면
- 257,전라남도 신안군 안좌면
- 258,전라남도 신안군 암태면
- 259,전라남도 신안군 압해읍 가란리
- 260,전라남도 신안군 압해읍 고이리
- 261,전라남도 신안군 압해읍 매화리
- 262,전라남도 신안군 임자면
- 263,전라남도 신안군 자은면
- 264,전라남도 신안군 지도읍 어의리
- 265,전라남도 신안군 지도읍 선도리
- 266,전라남도 신안군 장산면
- 267,전라남도 신안군 증도면 병풍리
- 268,전라남도 신안군 팔금면
- 269,전라남도 신안군 하의면
- 270,전라남도 신안군 흑산면
- 271,전라남도 여수시 경호동
- 272,전라남도 여수시 남면
- 273,전라남도 여수시 묘도동
- 274,전라남도 여수시 삼산면
- 275,전라남도 여수시 화정면 개도리
- 276,전라남도 여수시 화정면 낭도리
- 277,전라남도 여수시 화정면 상화리
- 278,전라남도 여수시 화정면 여자리
- 279,전라남도 여수시 화정면 월호리
- 280,전라남도 여수시 화정면 적금리
- 281,전라남도 여수시 화정면 제도리
- 282,전라남도 여수시 화정면 조발리
- 283,전라남도 여수시 화정면 하화리
- 284,전라남도 영광군 낙월면
- 285,전라남도 완도군 군외면 당인리
- 286,전라남도 완도군 군외면 불목리
- 287,전라남도 완도군 군외면 영풍리
- 288,전라남도 완도군 군외면 황진리
- 289,전라남도 완도군 금당면
- 290,전라남도 완도군 금일읍
- 291,전라남도 완도군 약산면
- 292,전라남도 완도군 고금면
- 293,전라남도 완도군 노화읍
- 294,전라남도 완도군 보길면
- 295,전라남도 완도군 생일면
- 296,전라남도 완도군 소안면
- 297,전라남도 완도군 청산면
- 298,전라남도 진도군 조도면
- 299,전라남도 진도군 의신면 모도리
- 300,전라남도 보성군 벌교읍 장도리
- 301,경기도 안산시 단원구 풍도동

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

- **201**: 201

---

### GET /areafees/{areaFeeNo}

**요약**: 지역별 추가배송비 설정 조회하기

**설명**:

## 부가설명 및 특이사항

파트너의 지역별 추가배송비 설정을 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| areaFeeNo | path   | number | ✅   | 지역별 추가배송비 번호^                               | 1   |
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

### PUT /areafees/{areaFeeNo}

**요약**: 지역별 추가배송비 설정 수정하기

**설명**:

## 부가설명 및 특이사항

파트너의 지역별 추가배송비 설정을 수정합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| areaFeeNo | path   | number | ✅   | 지역별 추가배송비 번호^                               | 1   |
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

### GET /areas

**요약**: 배송비 설정을 위한 지역 조회

**설명**:

## 부가설명 및 특이사항

배송비 설정을 위한 지역을 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| countryCd | query  | string | ✅   | 국가 코드^                                            | KR  |
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

## Delivery

### GET /deliveries

**요약**: 배송비 템플릿 조회하기

**설명**:

## 부가설명 및 특이사항

파트너사의 배송비 템플릿뿐만 아니라 쇼핑몰 배송 템플릿도 조회합니다.

shippingAreaType : MALL_SHIPPING_AREA (쇼핑몰 배송), PARTNER_SHIPPING_AREA (파트너사 배송)

**파라미터**:

| 이름             | 위치   | 타입   | 필수 | 설명                                                  |
| ---------------- | ------ | ------ | ---- | ----------------------------------------------------- | --------------------- |
| shippingAreaType | query  | string | ❌   | 배송 구분^                                            | PARTNER_SHIPPING_AREA |
| systemKey        | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

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

### GET /deliveries/template-groups

**요약**: 배송비 템플릿 그룹 내역 조회하기

**설명**:

## 부가설명 및 특이사항

파트너사의 배송비 템플릿 그룹과 쇼핑몰 배송 템플릿 그룹도 함께 조회합니다.

- shippingAreaType : MALL_SHIPPING_AREA (쇼핑몰 배송), PARTNER_SHIPPING_AREA (파트너사 배송)

**파라미터**:

| 이름             | 위치   | 타입   | 필수 | 설명                                                  |
| ---------------- | ------ | ------ | ---- | ----------------------------------------------------- | --------------------- |
| shippingAreaType | query  | string | ❌   | 배송 구분^                                            | PARTNER_SHIPPING_AREA |
| systemKey        | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

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

### POST /deliveries/template-groups

**요약**: 배송비 템플릿 그룹 생성하기

**설명**:

## 부가설명 및 특이사항

파트너의 배송비 템플릿 그룹을 생성합니다.

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

- **201**: 201

---

### GET /deliveries/template-groups/{templateGroupNo}

**요약**: 배송비 템플릿 그룹 조회하기

**설명**:

## 부가설명 및 특이사항

파트너의 배송비 템플릿 그룹을 조회합니다.

**파라미터**:

| 이름            | 위치   | 타입   | 필수 | 설명                                                  |
| --------------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| templateGroupNo | path   | number | ✅   | 배송비 템플릿 그룹 번호^                              | 1   |
| systemKey       | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

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

### PUT /deliveries/template-groups/{templateGroupNo}

**요약**: 배송비 템플릿 그룹 수정하기

**설명**:

## 부가설명 및 특이사항

파트너의 배송비 템플릿 그룹을 수정합니다.

**파라미터**:

| 이름            | 위치   | 타입   | 필수 | 설명                                                  |
| --------------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| templateGroupNo | path   | number | ✅   | 배송비 템플릿 그룹 번호^                              | 1   |
| systemKey       | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

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

### GET /deliveries/templates/{templateNo}

**요약**: 배송비 템플릿 상세조회하기

**설명**:

## 부가설명 및 특이사항

배송비 템플릿 상세조회 API입니다.

**파라미터**:

| 이름       | 위치   | 타입   | 필수 | 설명                                                  |
| ---------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| templateNo | path   | number | ✅   | 배송 템플릿 번호^                                     | 1   |
| systemKey  | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

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

## Warehouse

### GET /warehouses

**요약**: 입출고 주소 내역 조회하기

**설명**:

## 부가설명 및 특이사항

파트너의 입출고 주소 내역을 조회합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                                  |
| --------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| page      | query  | number | ✅   | 시작 번호[페이징 처리] (1 이상)^                      | 1   |
| size      | query  | number | ✅   | 종료 번호[페이징 처리]^                               | 30  |
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

### POST /warehouses

**요약**: 입출고 주소 생성하기

**설명**:

## 부가설명 및 특이사항

파트너의 입출고 주소를 생성합니다.

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

- **201**: 201

---

### GET /warehouses/{warehouseNo}

**요약**: 입출고 주소 조회하기

**설명**:

## 부가설명 및 특이사항

파트너의 입출고 주소를 조회합니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                                  |
| ----------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| warehouseNo | path   | number | ✅   | 입출고 주소 번호^                                     | 1   |
| systemKey   | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

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

### PUT /warehouses/{warehouseNo}

**요약**: 입출고 주소 수정하기

**설명**:

## 부가설명 및 특이사항

파트너의 입출고 주소를 수정합니다.

**파라미터**:

| 이름        | 위치   | 타입   | 필수 | 설명                                                  |
| ----------- | ------ | ------ | ---- | ----------------------------------------------------- | --- |
| warehouseNo | path   | number | ✅   | 입출고 주소 번호^                                     | 1   |
| systemKey   | header | string | ✅   | 시스템 키 (외부시스템 연동을 위한 server API 호출 키) |

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
