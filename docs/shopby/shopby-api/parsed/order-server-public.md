# order-server

**버전**: 0.1.0-SNAPSHOT
**서버**: https://server-api.e-ncp.com

주문(order) 관련 server API입니다.

---

## Orders

### GET /accounts/orders

**요약**: 무통장 미입금 주문 리스트 조회

**설명**:
PG연동을 하지 않고 쇼핑몰의 계좌로 입금을 받는 무통장입금 주문에 대한 주문 조회입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **200**: 200

---

### PUT /accounts/orders/confirmation

**요약**: 무통장 입금 확인

**설명**:
무통장 입금 확인

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **200**: 200

---

### GET /accounts/orders/{orderNo}

**요약**: 무통장 미입금 주문 조회

**설명**:
무통장 미입금 주문 조회

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | ---------------- |
| orderNo   | path   | string | ✅   | 주문번호^ | 2020042100000001 |
| Version   | header | string | ✅   | API 버전^ | 1.0              |
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

**응답**:

- **200**: 200

---

### GET /orders

**요약**: 주문 조회하기 v1.1

**설명**:

## 부가설명 및 특이사항

주문 리스트 조회하는 API 입니다.

응답 데이터는 주문번호의 내림차순으로 정렬됩니다.

### v1.0

페이징 처리를 위한 totalCount를 제공하지 않습니다.
응답은 리스트 형식으로 되어 있습니다. 아래 내용 참고 바랍니다.

```
[
 {
 "orderNo": "",
 ...
 },
 ...
]
```

### v1.1

페이징 처리를 위한 totalCount를 제공합니다.
주문 리스트는 contents 파라미터에 포함됩니다.
자세한 정보는 Responses 항목 참고 바랍니다.

**파라미터**:

| 이름                | 위치   | 타입    | 필수 | 설명                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ------------------- | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------ |
| startYmd            | query  | string  | ❌   | 시작일(YYYY-MM-DD) [default: 3개월 전]^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | 2020-12-30               |
| endYmd              | query  | string  | ❌   | 종료일(YYYY-MM-DD) [default: 오늘]^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 2020-12-30               |
| startYmdt           | query  | string  | ❌   | 종료일시(YYYY-MM-DD HH:mm:ss) (startYmd 보다 우선순위 높음) [default: 3개월 전]^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | 2020-12-30 00:00:00      |
| endYmdt             | query  | string  | ❌   | 종료일시(YYYY-MM-DD HH:mm:ss) (endYmd 보다 우선순위 높음) [default: 오늘]^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | 2020-12-30 00:00:00      |
| orderOptionNos      | query  | string  | ❌   | 주문 옵션 번호 리스트^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 360001,360002            |
| orderRequestTypes   | query  | string  | ❌   | 주문상태 타입 (DEPOSIT_WAIT: Deposit Wait, PAY_DONE: Pay Done, PRODUCT_PREPARE: Product Prepare, DELIVERY_PREPARE: Delivery Prepare, DELIVERY_ING: Delivering, DELIVERY_DONE: Delivery Done, BUY_CONFIRM: Buy Confirm, CANCEL_DONE: Cancel Done, RETURN_DONE: Return Done, EXCHANGE_DONE: Exchange Done, CANCEL_PROCESSING: 취소처리중, RETURN_PROCESSING: 반품처리중, EXCHANGE_WAITING: 교환대기중, EXCHANGE_PROCESSING: 교환처리중)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | DEPOSIT_WAIT,CANCEL_DONE |
| searchDateType      | query  | string  | ❌   | 조회하려는 주문일시 유형 [default: ORDER_START] (ORDER_START: 주문 발생일, PAY_DONE: 입금 확인일, PRODUCT_PREPARE: 주문 접수일, DELIVERY_PREPARE: 출고 준비일, DELIVERY_ING: 출고일, DELIVERY_DONE: 배송 완료일, BUY_CONFIRM: 구매확정일, STATUS_CHANGE: 최종 상태 변경일)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | ORDER_START              |
| memberNo            | query  | number  | ❌   | 회원번호^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 1                        |
| searchType          | query  | string  | ❌   | 검색 유형(주문번호, 상품번호) (ALL, ORDER_NO, MALL_PRODUCT_NO)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | ALL                      |
| searchValues        | query  | string  | ❌   | 검색 값^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 11111111,2222222         |
| deliveryCompanyType | query  | string  | ❌   | 택배사 타입 (CJ: CJ Logistics, POST: Post Office, HANJIN: Hanjin Transportation, GTX: GTX LOGIS, LOTTE: Lotte Global Logistics Corporation, KGB: KGB LOGIS, LOGEN: Logen, GSI: gsi Express, KGL: KG LOGIS, INTRAS: INTRAS, UPS: UPS, CHUNIL: Chunil Express, KDEXP: Kyungdong Express, HDEXP: Hapdong Express, ILYANG: Ilyang Logis, POST_EMS: Post Office EMS, DAESIN: daesin, CVS: CVS Convenience Shop Delivery Service, DHL: DHL, FEDEX: FEDEX, GSM: GSM International Courier, WARPEX: WarpEx, WIZWA: WIZWA, ACI: ACI Express, PANTOS: LX Pantos, CJ_INTERNATIONAL: CJ Logistics(international courier), TNT: TNT, CU: CU Convenience Shop Delivery Service, KUNYOUNG: Geonyoung Express, LOTTE_INTERNATIONAL: Lotte Global Logistics Corporation(international courier), HONAM: Honam Express, HANIPS: Hanui Sarang Express, IPARCEL: i-Parcel, SLX: SLX Express, USPS: USPS, WONDERS: wonders quick, REGISTPOST: Regist Post, DHLDE: DHL(germany), EZUSA: EZUSA, SWGEXP: Sungwon Global, DAEWOON: Daewoon Global, DODOFLEX: dodoFlex, NH_LOGIS: NongHyup Logis, UFO: UFO, TODAY_PICKUP: Today Pickup, QEXPRESS: Q Express, PINGPONG: PingPong, CR_LOGITECH: CR Logitech, TODAY: Today, SELLUV: Selluv, EXMATE: EXMATE, WINION_LOGIS: Winion Logistics, ETC: ETC)^ | CJ                       |
| ordererContact1     | query  | string  | ❌   | 주문자 연락처^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | 010-0000-0000            |
| receiverContact1    | query  | string  | ❌   | 수령자 연락처^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | 010-0000-0000            |
| shippingAreaType    | query  | string  | ❌   | 배송구분 (PARTNER_SHIPPING_AREA: Partner Delivery, MALL_SHIPPING_AREA: Shipping Mall Delivery)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | PARTNER_SHIPPING_AREA    |
| payType             | query  | string  | ❌   | 결제수단 (CREDIT_CARD: Credit Card, ACCOUNT: Deposit without bankbook, MOBILE: Mobile payment, REALTIME_ACCOUNT_TRANSFER: Real-time bank transfer, VIRTUAL_ACCOUNT: Virtual account, GIFT: Gift card, ATM: ATM, PAYCO: PAYCO, ZERO_PAY: Zero payment, ACCUMULATION: Accumulation, PHONE_BILL: Phone payment, POINT: Point payment, YPAY: Yello Pay, KPAY: K Pay, PAYPIN: Paypin, INIPAY: INIPay, PAYPAL: PAYPAL, STRIPE: STRIPE, NAVER_PAY: Naver Pay, KAKAO_PAY: Kakao Pay, NAVER_EASY_PAY: Naver Pay, SAMSUNG_PAY: Samsung Pay, CHAI: Chai, TOSS_PAY: Toss Pay, SK_PAY: SK Pay, APPLE_PAY: Apple Pay, LPAY: L Pay, ESCROW_REALTIME_ACCOUNT_TRANSFER: Real-time bank transfer - Escrow, ESCROW_VIRTUAL_ACCOUNT: Virtual account - Escrow, RENTAL: Rental payment, VERITRANS_CARD: Veritrans CreditCard, TOASTCAM: ToastCam, UNION_PAY: UnionPay, ALIPAY: AliPay Plus, WECHAT_PAY: WeChat Pay, PINPAY: Pin Pay, EXTERNAL_PAY: 외부 결제 전액 사용, HMG_PAY: HMG pay, APP_CARD: App Card, PAY_PAY: Pay Pay, E_CONTEXT: E Context, HAPPY_VOUCHER: National Happiness Card, ETC: Other payment methods)^                                                                                                                                                                    | CREDIT_CARD              |
| pageNumber          | query  | number  | ❌   | 페이지 번호 (1 이상) [default: 1]^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | 1                        |
| pageSize            | query  | number  | ❌   | 페이지 크기(최대 200) [default: 20]^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 20                       |
| partnerNo           | query  | number  | ❌   | 파트너 번호^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | 1                        |
| desc                | query  | boolean | ❌   | 정렬 기준 (true: 내림차순, false: 오름차순)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | true                     |
| Version             | header | string  | ✅   | API 버전^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 1.1                      |
| systemKey           | header | string  | ✅   |

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

**응답**:

- **200**: 200

---

### PUT /orders/cash-receipt

**요약**: 현금영수증 발행결과 업데이트

**설명**:

## 부가설명 및 특이사항

현금영수증 발행 결과를 업데이트하는 API 입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **204**: 204

---

### PUT /orders/confirm

**요약**: 구매확정 상태 변경 요청하기

**설명**:

## 부가설명 및 특이사항

입력한 optionList의 상태를 구매확정으로 변경하는 API 입니다.

Body엔 orderOptionNo 리스트를 입력합니다. <br /> ex) [1, 2, 3]

서비스 어드민 권한으로만 호출 가능합니다.

요청한 옵션 중 하나라도 실패하면 나머지 옵션도 변경되지 않습니다.

실패한 첫 번째 옵션 번호는 에러 메시지에서 확인할 수 있습니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **204**: 204

---

### GET /orders/deliveries

**요약**: 주문 조회하기 (배송번호 기준)

**설명**:

## 부가설명 및 특이사항

배송번호 기준 주문 리스트 조회하는 API 입니다.

주문 리스트는 contents 파라미터에 포함됩니다.
자세한 정보는 Responses 항목 참고 바랍니다.

**파라미터**:

| 이름                           | 위치   | 타입    | 필수 | 설명                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ------------------------------ | ------ | ------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------ |
| startYmd                       | query  | string  | ❌   | 시작일(YYYY-MM-DD)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 2020-12-30               |
| endYmd                         | query  | string  | ❌   | 종료일(YYYY-MM-DD)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 2020-12-30               |
| startYmdt                      | query  | string  | ❌   | 종료일시(YYYY-MM-DD HH:mm:ss) (startYmd 보다 우선순위 높음)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | 2020-12-30 00:00:00      |
| endYmdt                        | query  | string  | ❌   | 종료일시(YYYY-MM-DD HH:mm:ss) (endYmd 보다 우선순위 높음)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | 2020-12-30 00:00:00      |
| orderRequestTypes              | query  | string  | ❌   | 주문상태 타입 (DEPOSIT_WAIT: Deposit Wait, PAY_DONE: Pay Done, PRODUCT_PREPARE: Product Prepare, DELIVERY_PREPARE: Delivery Prepare, DELIVERY_ING: Delivering, DELIVERY_DONE: Delivery Done, BUY_CONFIRM: Buy Confirm, CANCEL_DONE: Cancel Done, RETURN_DONE: Return Done, EXCHANGE_DONE: Exchange Done, CANCEL_PROCESSING: 취소처리중, RETURN_PROCESSING: 반품처리중, EXCHANGE_WAITING: 교환대기중, EXCHANGE_PROCESSING: 교환처리중)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | DEPOSIT_WAIT,CANCEL_DONE |
| searchDateType                 | query  | string  | ❌   | 조회하려는 주문일시 유형 (ORDER_START: 주문 발생일, PAY_DONE: 입금 확인일, PRODUCT_PREPARE: 주문 접수일, DELIVERY_PREPARE: 출고 준비일, DELIVERY_ING: 출고일, DELIVERY_DONE: 배송 완료일, BUY_CONFIRM: 구매확정일, STATUS_CHANGE: 최종 상태 변경일)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | ORDER_START              |
| memberNo                       | query  | number  | ❌   | 회원번호^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 1                        |
| searchType                     | query  | string  | ❌   | 검색 유형(배송번호, 주문번호, 상품번호) (ALL, DELIVERY_NO, ORDER_NO, MALL_PRODUCT_NO, ORDER_OPTION_NO)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | ALL                      |
| searchValues                   | query  | string  | ❌   | 검색 값^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 11111111,2222222         |
| excludeOptionNos               | query  | string  | ❌   | 검색 시 제외할 주문옵션번호^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | 11111111,2222222         |
| excludeDeliveryNos             | query  | string  | ❌   | 검색 시 제외할 배송번호^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 11111111,2222222         |
| deliveryCompanyType            | query  | string  | ❌   | 택배사 타입 (CJ: CJ Logistics, POST: Post Office, HANJIN: Hanjin Transportation, GTX: GTX LOGIS, LOTTE: Lotte Global Logistics Corporation, KGB: KGB LOGIS, LOGEN: Logen, GSI: gsi Express, KGL: KG LOGIS, INTRAS: INTRAS, UPS: UPS, CHUNIL: Chunil Express, KDEXP: Kyungdong Express, HDEXP: Hapdong Express, ILYANG: Ilyang Logis, POST_EMS: Post Office EMS, DAESIN: daesin, CVS: CVS Convenience Shop Delivery Service, DHL: DHL, FEDEX: FEDEX, GSM: GSM International Courier, WARPEX: WarpEx, WIZWA: WIZWA, ACI: ACI Express, PANTOS: LX Pantos, CJ_INTERNATIONAL: CJ Logistics(international courier), TNT: TNT, CU: CU Convenience Shop Delivery Service, KUNYOUNG: Geonyoung Express, LOTTE_INTERNATIONAL: Lotte Global Logistics Corporation(international courier), HONAM: Honam Express, HANIPS: Hanui Sarang Express, IPARCEL: i-Parcel, SLX: SLX Express, USPS: USPS, WONDERS: wonders quick, REGISTPOST: Regist Post, DHLDE: DHL(germany), EZUSA: EZUSA, SWGEXP: Sungwon Global, DAEWOON: Daewoon Global, DODOFLEX: dodoFlex, NH_LOGIS: NongHyup Logis, UFO: UFO, TODAY_PICKUP: Today Pickup, QEXPRESS: Q Express, PINGPONG: PingPong, CR_LOGITECH: CR Logitech, TODAY: Today, SELLUV: Selluv, EXMATE: EXMATE, WINION_LOGIS: Winion Logistics, ETC: ETC)^ | CJ                       |
| assignsInvoice                 | query  | boolean | ❌   | 송장할당여부^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | false                    |
| includeNoneDeliveryCompanyType | query  | boolean | ❌   | 택배사가 입력되지 않은 주문 포함 여부 (택배사를 조회할 때 적용됨)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | false                    |
| partnerNo                      | query  | number  | ❌   | 파트너 번호^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | 0                        |
| pageNumber                     | query  | number  | ❌   | 페이지 번호 (1 이상)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 1                        |
| pageSize                       | query  | number  | ❌   | 페이지 크기(최대 200)^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 20                       |
| Version                        | header | string  | ✅   | API 버전^                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 1.0                      |
| systemKey                      | header | string  | ✅   |

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

**응답**:

- **200**: 200

---

### PUT /orders/delivery

**요약**: 상품준비중 상태 목록을 배송중 상태로 변경하기

**설명**:

## 부가설명 및 특이사항

입력한 '상품준비중 optionList'의 상태를 '배송중'으로 변경하는 API 입니다

API 를 통해 '상품준비중→배송중'으로 변경 요청 시

시스템상으로는 '상품준비중→배송준비중→배송중'으로 변경됩니다.

API 요청 시 '배송준비중'으로 변경되며, alpha 서버에서는 30분 간격 / real 서버에서는 1분 간격으로 요청 건을 수집하여 '배송중'으로 일괄 변경처리합니다.

'배송중' 처리 시까지 시간차가 발생할 수 있습니다

요청한 옵션 중 하나라도 실패하면 나머지 옵션도 변경되지 않습니다.

실패한 첫 번째 옵션 번호는 에러 메시지에서 확인할 수 있습니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **204**: 204

---

### PUT /orders/delivery-ing

**요약**: 배송준비중 상태를 목록을 배송중 상태로 변경하기

**설명**:

## 부가설명 및 특이사항

입력한 배송준비중 optionList 의 상태를 배송중으로 변경하는 API 입니다.

요청한 옵션 중 하나라도 실패하면 나머지 옵션도 변경되지 않습니다.

실패한 첫 번째 옵션 번호는 에러 메시지에서 확인할 수 있습니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **204**: 204

---

### PUT /orders/extra-data

**요약**: 주문의 추가 정보 입력

**설명**:

## 부가설명 및 특이사항

주문의 부가 정보를 저장합니다.

extraData 필드에 key, value 형태로 저장됩니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **204**: 204

---

### PUT /orders/prepare-delivery

**요약**: 배송준비중 상태 변경 요청하기

**설명**:

## 부가설명 및 특이사항

결제완료 및 상품준비중 옵션을 배송준비중 상태로 변경하는 API 입니다.

Body에는 orderOptionNo 리스트를 입력합니다. <br /> ex) [1, 2, 3]

요청한 옵션 중 하나라도 실패하면 나머지 옵션도 변경되지 않습니다.

실패한 첫 번째 옵션 번호는 에러 메시지에서 확인할 수 있습니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **204**: 204

---

### PUT /orders/prepare-product

**요약**: 상품준비중 상태 변경 요청하기

**설명**:

## 부가설명 및 특이사항

결제완료된 상품을 상품준비중 상태로 변경하는 API 입니다.

Body에는 orderOptionNo 리스트를 입력합니다. <br /> ex) [1, 2, 3]

요청한 옵션 중 하나라도 실패하면 나머지 옵션도 변경되지 않습니다.

실패한 첫 번째 옵션 번호는 에러 메시지에서 확인할 수 있습니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **204**: 204

---

### PUT /orders/receive

**요약**: 주문상품 수취확인처리 요청하기

**설명**:

## 부가설명 및 특이사항

입력한 optionList의 상태를 수취확인으로 변경하는 API 입니다.(배송완료처리)

Body엔 orderOptionNo 리스트를 입력합니다. <br /> ex) [1, 2, 3]

요청한 옵션 중 하나라도 실패하면 나머지 옵션도 변경되지 않습니다.

실패한 첫 번째 옵션 번호는 에러 메시지에서 확인할 수 있습니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **204**: 204

---

### PUT /orders/reserve-to-normal

**요약**: 예약 주문 일반주문으로 변경 요청하기

**설명**:

## 부가설명 및 특이사항

예약주문을 일반주문으로 변경하는 API 입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **204**: 204

---

### PUT /orders/tax-invoice

**요약**: 세금계산서 발행결과 업데이트

**설명**:

## 부가설명 및 특이사항

세금계산서 발행 결과를 업데이트하는 API 입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **204**: 204

---

### PUT /orders/update-invoices

**요약**: 송장번호 변경

**설명**:
송장번호 변경

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **200**: 200

---

### GET /orders/{orderNo}

**요약**: 주문 상세 조회

**설명**:

## 부가설명 및 특이사항

주문에 대한 상세를 조회하는 API 입니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명       |
| --------- | ------ | ------ | ---- | ---------- | ------------------ |
| orderNo   | path   | string | ✅   | 주문 번호^ | 202206151234567890 |
| Version   | header | string | ✅   | API 버전^  | 1.0                |
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

**응답**:

- **200**: 200

---

### PUT /orders/change-status/by-shipping-no

**요약**: 주문 상태 일괄 변경 요청하기

**설명**:

## 부가설명 및 특이사항

주문 상태를 일괄로 변경하는 API 입니다. 배송번호 단위로 처리 됩니다.

상태 변경 대상 목록(changeStatusList)은 최대 100개까지 입력할 수 있습니다.

송장정보는 배송중 이전 [PAY_DONE, PRODUCT_PREPARE, DELIVERY_PREPARE] 상태에서,
배송중 이후 [DELIVERY_ING, DELIVERY_DONE, BUY_CONFIRM] 상태로 변경 시
입력 가능합니다.

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **200**: 200

---

## Cart

### GET /cart

**요약**: 장바구니 가져오기

**설명**:

## 부가설명 및 특이사항

장바구니를 조회하는 API 입니다.

조회기간은 최대 3개월까지 설정 가능합니다.

**파라미터**:

| 이름           | 위치   | 타입    | 필수 | 설명                                                  |
| -------------- | ------ | ------- | ---- | ----------------------------------------------------- | ------------------- |
| memberNos      | query  | string  | ❌   | 회원 번호 리스트^                                     | 1,2,3               |
| searchDateType | query  | string  | ❌   | [개발중] 날짜 검색 조건 (REGISTER_YMDT, UPDATE_YMDT)^ | REGISTER_YMDT       |
| startYmdt      | query  | string  | ❌   | 조회 시작일시^                                        | 2025-10-24 11:17:29 |
| endYmdt        | query  | string  | ❌   | 조회 종료일시^                                        | 2025-10-27 11:17:29 |
| groupId        | query  | string  | ❌   | 장바구니 그룹 아이디^                                 | cartGroupId         |
| page           | query  | integer | ❌   | 페이지 번호^                                          | 1                   |
| size           | query  | integer | ❌   | 페이지당 노출 개수(최대 200)^                         | 20                  |
| Version        | header | string  | ✅   | API 버전^                                             | 1.0                 |
| systemKey      | header | string  | ✅   |

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

**응답**:

- **200**: 200

---

## PreviousOrder

### GET /previous-orders

**요약**: 이전주문 검색

**설명**:
이전주문 검색

**파라미터**:

| 이름       | 위치   | 타입    | 필수 | 설명                |
| ---------- | ------ | ------- | ---- | ------------------- | --------------------------------------------------------------------------------------------------- |
| searchType | query  | string  | ❌   | 검색 타입^          | ORDER_NO, ORDERER_NAME, ORDERER_CONTACT1, PRODUCT_NAME, RECEIVER_NAME, RECEIVER_CONTACT1, MEMBER_NO |
| keyword    | query  | string  | ❌   | 검색어^             | 홍길동                                                                                              |
| startYmd   | query  | string  | ❌   | 조회시작일^         | 2025-07-27                                                                                          |
| endYmd     | query  | string  | ❌   | 조회종료일^         | 2025-10-27                                                                                          |
| page       | query  | integer | ✅   | 페이지 번호^        | 1                                                                                                   |
| size       | query  | integer | ✅   | 페이지당 노출 개수^ | 30                                                                                                  |
| Version    | header | string  | ✅   | API 버전^           | 1.0                                                                                                 |
| systemKey  | header | string  | ✅   |

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

**응답**:

- **200**: 200

---

### POST /previous-orders

**요약**: 이전주문 등록

**설명**:
이전주문 등록

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **200**: 200

---

### POST /previous-orders/delete

**요약**: 이전주문 전체 삭제

**설명**:
이전주문 전체 삭제

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명         |
| --------- | ------ | ------ | ---- | ------------ | --------- |
| mallName  | query  | string | ✅   | 쇼핑몰 이름^ | mall-name |
| Version   | header | string | ✅   | API 버전^    | 1.0       |
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

**응답**:

- **200**: 200

---

### POST /previous-orders/delete/by-order-nos

**요약**: 이전주문 삭제

**설명**:
이전주문 삭제

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명         |
| --------- | ------ | ------ | ---- | ------------ | --------- |
| mallName  | query  | string | ✅   | 쇼핑몰 이름^ | mall-name |
| Version   | header | string | ✅   | API 버전^    | 1.0       |
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

**응답**:

- **200**: 200

---

## RecurringPayment

### GET /recurring-payments

**요약**: 정기결제(배송) 조회

**설명**:
정기결제(배송) 조회

**파라미터**:

| 이름        | 위치   | 타입    | 필수 | 설명             |
| ----------- | ------ | ------- | ---- | ---------------- | ----------------------- | -------------------- |
| memberNos   | query  | number  | ❌   | 회원번호 리스트^ | [1]                     |
| searchType  | query  | string  | ❌   | 검색 타입        | (RECURRING_PAYMENT_NO)^ | RECURRING_PAYMENT_NO |
| keywords    | query  | string  | ❌   | 검색어(리스트)^  | []                      |
| statusTypes | query  | string  | ❌   | 상태(리스트)^    | [ACTIVE]                |
| page        | query  | integer | ✅   | 페이지 번호^     | 1                       |
| size        | query  | integer | ✅   | 사이즈^          | 30                      |
| Version     | header | string  | ✅   | API 버전^        | 1.0                     |
| systemKey   | header | string  | ✅   |

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

**응답**:

- **200**: 200

---

## ShippingAddress

### GET /shipping-addresses

**요약**: 배송지 조회하기

**설명**:

## 부가설명 및 특이사항

배송지를 조회하는 API 입니다.

**파라미터**:

| 이름        | 위치   | 타입    | 필수 | 설명              |
| ----------- | ------ | ------- | ---- | ----------------- | ------------------------------------------------------- |
| memberNos   | query  | string  | ✅   | 회원 번호 리스트^ | [1]                                                     |
| addressType | query  | string  | ✅   | 배송지 타입^      | BOOK,RECENT,RECURRING_PAYMENT,RECURRING_PAYMENT_PRESENT |
| page        | query  | integer | ✅   | 페이지 번호^      | 1                                                       |
| size        | query  | integer | ✅   | 페이지 크기^      | 30                                                      |
| Version     | header | string  | ✅   | API 버전^         | 1.0                                                     |
| systemKey   | header | string  | ✅   |

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

**응답**:

- **200**: 200

---

## TaskMessage

### GET /task-messages

**요약**: 업무 메세지 조회하기

**설명**:

## 부가설명 및 특이사항

업무메세지를 조회하는 API 입니다.

**파라미터**:

| 이름          | 위치   | 타입   | 필수 | 설명                                                                                                |
| ------------- | ------ | ------ | ---- | --------------------------------------------------------------------------------------------------- | ------------------- |
| dateType      | query  | string | ✅   | 기간 검색 타입 (REGISTER: Registration date, UPDATE: Modification date, COMPLETE: Completion date)^ | REGISTER            |
| startDateTime | query  | string | ✅   | 조회 시작 일시^                                                                                     | YYYY-MM-DD HH:mm:ss |
| endDateTime   | query  | string | ✅   | 조회 종료 일시^                                                                                     | YYYY-MM-DD HH:mm:ss |
| page          | query  | number | ❌   | 페이지 번호 (1 이상)^                                                                               | 1                   |
| size          | query  | number | ❌   | 페이지당 노출 개수^                                                                                 | 10                  |
| Version       | header | string | ✅   | API 버전^                                                                                           | 1.0                 |
| systemKey     | header | string | ✅   |

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

**응답**:

- **200**: 200

---

### POST /task-messages

**요약**: 업무 메시지 등록

**설명**:
업무 메시지 등록

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명      |
| --------- | ------ | ------ | ---- | --------- | --- |
| Version   | header | string | ✅   | API 버전^ | 1.0 |
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

**응답**:

- **200**: 200

---

### PUT /task-messages/{taskMessageNo}

**요약**: 업무 메시지 수정

**설명**:
업무 메시지 수정

**파라미터**:

| 이름          | 위치   | 타입    | 필수 | 설명              |
| ------------- | ------ | ------- | ---- | ----------------- | ---- |
| taskMessageNo | path   | integer | ✅   | 업무 메시지 번호^ | 1813 |
| Version       | header | string  | ✅   | API 버전^         | 1.0  |
| systemKey     | header | string  | ✅   |

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

**응답**:

- **204**: 204

---

### POST /task-messages/{taskMessageNo}/details

**요약**: 상세 업무 메시지 등록

**설명**:
상세 업무 메시지 등록

**파라미터**:

| 이름          | 위치   | 타입    | 필수 | 설명              |
| ------------- | ------ | ------- | ---- | ----------------- | ---- |
| taskMessageNo | path   | integer | ✅   | 업무 메시지 번호^ | 1813 |
| Version       | header | string  | ✅   | API 버전^         | 1.0  |
| systemKey     | header | string  | ✅   |

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

**응답**:

- **200**: 200

---

### PUT /task-messages/{taskMessageNo}/details/{taskMessageDetailNo}

**요약**: 상세 업무 메시지 수정

**설명**:
상세 업무 메시지 수정

**파라미터**:

| 이름                | 위치   | 타입    | 필수 | 설명              |
| ------------------- | ------ | ------- | ---- | ----------------- | ---- |
| taskMessageNo       | path   | integer | ✅   | 업무 메시지 번호^ | 1813 |
| taskMessageDetailNo | path   | integer | ✅   | 상세 메시지 번호^ | 5123 |
| Version             | header | string  | ✅   | API 버전^         | 1.0  |
| systemKey           | header | string  | ✅   |

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

**응답**:

- **204**: 204

---

## Wish

### GET /wish

**요약**: 위시리스트 가져오기

**설명**:

## 부가설명 및 특이사항

위시리스트를 조회하는 API 입니다.

조회기간은 최대 3개월까지 설정 가능합니다.

**파라미터**:

| 이름      | 위치   | 타입    | 필수 | 설명                  |
| --------- | ------ | ------- | ---- | --------------------- | ------------------- |
| startYmdt | query  | string  | ❌   | 조회 시작일시^        | 2025-10-24 11:17:23 |
| endYmdt   | query  | string  | ❌   | 조회 종료일시^        | 2025-10-27 11:17:23 |
| page      | query  | integer | ❌   | 페이지 번호 (1 이상)^ | 1                   |
| size      | query  | integer | ❌   | 페이지당 노출 개수^   | 20                  |
| Version   | header | string  | ✅   | API 버전^             | 1.0                 |
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

**응답**:

- **200**: 200

---
