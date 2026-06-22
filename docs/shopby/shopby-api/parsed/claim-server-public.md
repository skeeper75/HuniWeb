# claim-server

**버전**: unspecified
**서버**: https://server-api.e-ncp.com

클레임(claim) 관련 server API입니다.

---

## CancelExchange

### POST /cancel-exchanges

**요약**: 취소교환 신청

**설명**:

## 부가설명 및 특이사항

옵션 취소 교환을 신청하는 API입니다.

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
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /cancel-exchanges/{no}/confirm-deposit

**요약**: 취소교환 추가결제 입금확인

**설명**:

## 부가설명 및 특이사항

추가 결제 내역을 입금 확인처리 합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| no        | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

## Claim

### GET /claims

**요약**: 클레임 목록 조회하기

**설명**:

## 부가설명 및 특이사항

다수의 클레임 정보를 조회합니다.

## 클레임 상태 값 정의

- ## 취소

  | 상태 값                    | 한글 정의          |
  | -------------------------- | ------------------ |
  | CANCEL_NO_REFUND           | 취소완료[환불없음] |
  | CANCEL_REQUEST             | 취소신청[승인대기] |
  | CANCEL_PROC_REQUEST_REFUND | 취소처리[환불보류] |
  | CANCEL_PROC_WAITING_REFUND | 취소처리[환불대기] |
  | CANCEL_DONE                | 취소완료[환불완료] |

- ## 교환

  | 상태 값                      | 한글 정의              |
  | ---------------------------- | ---------------------- |
  | EXCHANGE_REQUEST             | 교환신청[승인대기]     |
  | EXCHANGE_REJECT_REQUEST      | 교환처리[철회대기]     |
  | EXCHANGE_PROC_BEFORE_RECEIVE | 교환처리[수거진행]     |
  | EXCHANGE_PROC_REQUEST_PAY    | 교환처리[결제대기]     |
  | EXCHANGE_PROC_REQUEST_REFUND | 교환처리[환불보류]     |
  | EXCHANGE_PROC_WAITING        | 교환처리[처리대기]     |
  | EXCHANGE_PROC_WAITING_PAY    | 교환처리[입금처리대기] |
  | EXCHANGE_PROC_WAITING_REFUND | 교환처리[환불대기]     |
  | EXCHANGE_DONE_PAY_DONE       | 교환완료[결제완료]     |
  | EXCHANGE_DONE_REFUND_DONE    | 교환완료[환불완료]     |
  | EXCHANGE_DONE                | 교환완료[차액없음]     |

- ## 반품
  | 상태 값                            | 한글 정의          |
  | ---------------------------------- | ------------------ |
  | RETURN_NO_REFUND                   | 반품완료[환불없음] |
  | RETURN_REQUEST                     | 반품신청[승인대기] |
  | RETURN_REJECT_REQUEST              | 반품신청[철회대기] |
  | RETURN_PROC_BEFORE_RECEIVE         | 반품처리[수거진행] |
  | RETURN_PROC_REQUEST_REFUND         | 반품처리[환불보류] |
  | RETURN_PROC_WAITING_REFUND         | 반품처리[환불대기] |
  | RETURN_DONE                        | 반품완료[환불완료] |
  | RETURN_REFUND_AMT_ADJUST_REQUESTED | 반품처리[조정요청] |

**파라미터**:

| 이름                 | 위치   | 타입   | 필수 | 설명                                                                                        |
| -------------------- | ------ | ------ | ---- | ------------------------------------------------------------------------------------------- | --------------------------- |
| claimStatusTypes     | query  | string | ❌   | 클레임 상태 리스트^                                                                         | CANCEL_REQUEST, CANCEL_DONE |
| endYmd               | query  | string | ✅   | 조회종료일^                                                                                 | yyyy-mm-dd                  |
| page                 | query  | string | ✅   | 페이지 번호 (1 이상)^                                                                       | 1                           |
| searchDateType       | query  | string | ✅   | 검색일자타입(APPLY_YMDT: 클레임일자, COMPLETE_YMDT: 클레임완료일자)^                        | APPLY_YMDT                  |
| searchType           | query  | string | ✅   | 클레임 검색 타입(ALL: 전체, CLAIM_NO: 클레임번호, ORDER_NO: 주문번호, MEMBER_NO: 회원번호)^ | ORDER_NO                    |
| searchValues         | query  | string | ❌   | 클레임 검색 값^                                                                             | 1,2,3                       |
| size                 | query  | string | ✅   | 페이지 사이즈^                                                                              | 30                          |
| startYmd             | query  | string | ✅   | 조회시작일^                                                                                 | yyyy-mm-dd                  |
| treatmentStatusTypes | query  | string | ❌   | 클레임 처리 상태 리스트^                                                                    | WITHDRAW, WITHDRAW_APPROVE  |
| systemKey            | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

### PUT /claims/{claimNo}/already-delivery

**요약**: 이미출고

**설명**:

## 부가설명 및 특이사항

옵션취소, 취소교환 신청된 클레임의 배송이 이미 출고된 경우 호출합니다.
신청된 클레임을 철회하고, 배송정보를 저장하여 배송중 상태로 변경합니다.

**파라미터**:

| 이름      | 위치   | 타입    | 필수 | 설명         |
| --------- | ------ | ------- | ---- | ------------ | --- |
| claimNo   | path   | integer | ✅   | 클레임 번호^ | 1   |
| systemKey | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /claims/{claimNo}/approve

**요약**: 클레임 승인

**설명**:

## 부가설명 및 특이사항

클레임 신청을 승인하는 API 입니다.
클레임 종류별로 이후 진행 단계가 상이하니, 아래 항목을 반드시 숙지해주세요.
특히, 승인 즉시 환불이 되는 경우가 있으니 유의 바랍니다.

- 반품
  - 배송안함 상품 : API 호출에 성공하는 즉시 클레임이 완료(반품이 완료)됩니다.
  - 그 외 상품 : API 호출에 성공하면, 클레임이 완료되지 않고 수거진행 상태가 됩니다.

- 옵션 취소
  - API 호출에 성공하는 즉시 클레임이 완료(옵션이 취소)됩니다.

- 주문 취소
  - API 호출에 성공하는 즉시 클레임이 완료(주문이 취소)됩니다.

- 옵션 취소 교환
  - API 호출에 성공하는 즉시 클레임이 완료(옵션이 교환)됩니다.

- 반품 교환
  - API 호출 성공 이후, 클레임이 완료되지 않고 수거 진행 상태가 됩니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| claimNo   | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /claims/{claimNo}/assign-return-invoice

**요약**: 반품 송장번호 할당

**설명**:

## 부가설명 및 특이사항

반품 송장번호를 할당하는 API 입니다.
클레임이 반품, 반품교환인 경우만 사용 가능합니다.

**파라미터**:

| 이름      | 위치   | 타입    | 필수 | 설명         |
| --------- | ------ | ------- | ---- | ------------ | --- |
| claimNo   | path   | integer | ✅   | 클레임 번호^ | 1   |
| systemKey | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /claims/{claimNo}/withdraw

**요약**: 클레임 철회

**설명**:

## 부가설명 및 특이사항

클레임을 철회하는 API 입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| claimNo   | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### GET /claims/{orderNo}/exchange-infos

**요약**: 교환 전/후 정보 조회

**설명**:

## 부가설명 및 특이사항

교환 완료된 클레임의 전/후 옵션 정보를 반환합니다.

- 철회된 클레임은 조회되지 않습니다.
- 응답값 중, exchangedOrderCnt 는 `현재 상태` 기준입니다. (스냅샷 X)
  - 교환출고 옵션 `전체`를 다시 클레임하는 경우는 exchangedOrderCnt 가 교환출고된 개수와 동일합니다.
  - 교환출고 옵션의 일부를 다시 클레임하여 옵션이 쪼개지는 경우, exchangeOrderCnt 가 최초 교환출고된 개수와 달라질 수 있습니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| orderNo   | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **200**: 200

---

## OptionCancel

### POST /option-cancels

**요약**: 옵션 취소 신청하기

**설명**:

## 부가설명 및 특이사항

옵션 취소 신청 API입니다.

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
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### POST /option-cancels/sold-out

**요약**: 품절 취소처리하기

**설명**:

## 부가설명 및 특이사항

선택한 주문옵션을 품절 취소하고 금액을 환불하는 API입니다.

### 특이사항

이벤트 처리 방식으로 주문을 취소처리하는 API입니다.
요청 완료 후 실제로 품절 취소되는데 일정 시간이 소요될 수 있습니다.

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
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### POST /option-cancels/sold-out/set-option

**요약**: 세트옵션 품절취소처리하기

**설명**:

## 부가설명 및 특이사항

선택한 주문옵션의 세트구성옵션을 품절 취소하고 금액을 환불하는 API입니다.

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
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

## OrderCancel

### POST /order-cancels

**요약**: 주문 취소하기

**설명**:

## 부가설명 및 특이사항

주문 취소 신청 API입니다.
주문 취소 신청은 입금대기, 결제완료 상태에서 가능합니다.

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
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

## ReturnExchange

### POST /return-exchanges

**요약**: 반품교환 신청

**설명**:

## 부가설명 및 특이사항

반품 교환을 신청하는 API입니다.
배송안함 상품에는 사용할 수 없습니다.

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
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /return-exchanges/{no}/collect

**요약**: 반품교환 수거완료

**설명**:

## 부가설명 및 특이사항

반품교환에서 클레임된 상품의 수거를 완료처리하는 API입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| no        | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /return-exchanges/{no}/confirm-deposit

**요약**: 반품교환 추가결제 입금확인

**설명**:

## 부가설명 및 특이사항

추가 결제 내역을 입금 확인처리 합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명 |
| --------- | ------ | ------ | ---- | ---- |
| no        | path   | string | ✅   | -    |
| systemKey | header | string | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

## Return

### POST /returns

**요약**: 반품신청하기

**설명**:

## 부가설명 및 특이사항

반품 신청 API입니다.

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
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---

### PUT /returns/{no}/collect

**요약**: 반품수거 완료하기

**설명**:

## 부가설명 및 특이사항

반품 수거 완료처리를 위한 API입니다.

**파라미터**:

| 이름      | 위치   | 타입    | 필수 | 설명         |
| --------- | ------ | ------- | ---- | ------------ | --- |
| no        | path   | integer | ✅   | 클레임 번호^ | 1   |
| systemKey | header | string  | ✅   |

시스템 키 (외부시스템 연동을 위한 server API 호출 키)

- 발급경로: 워크스페이스> 셀러어드민> 신규 앱(App) 등록 시 수정페이지에서 확인가능
- 앱 기준으로 systemKey 발급됨
  ^|test-system-key |
  | Authorization | header | string | ❌ |

인증토큰 (Bearer 발급받은 엑세스 토큰)

- 형식: Bearer {access_token} (중간에 띄어쓰기 필수입니다.)

- 발급경로: POST /auth/token 또는 POST /auth/token/long-lived 의 응답 값으로 내려온 access_token
  ^|Bearer ABCDERAdjflaskjdfosiaetlkfs |
  | mallKey | header | string | ❌ | 외부 API 연동키 (외부시스템연동 코드)

※ server API 호출하는 기존 방식으로, 향후 fade out될 수 있습니다.<br />

Authorization을 입력을 통한 serverAPI 호출방식 권장드립니다.<br />

(Authorization 입력했을 경우, mallKey는 null로 보내시길 바랍니다.)<br />

^|각 어드민에서 복사된 값 |
| Version | header | string | ✅ | API 버전^|1.0 |

**응답**:

- **204**: 204

---
