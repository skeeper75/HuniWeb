# Shopby 적립금(accumulation)·웹훅·주문 API 명세 추출 — 선불 충전금(프린트머니) 설계용

> 작성 2026-09-15. 출처 = 온라인 최신 OpenAPI 명세를 직접 내려받아 파싱(`https://docs.shopby.co.kr/spec/*.yml` = Shop API, `https://server-docs.shopby.co.kr/spec/*.yml` = Server API; 명세 내 예시 타임스탬프 2026-09-02~09-14). 내려받는 방법은 `_workspace/huni-shopby/16_bank-transfer/BANK-TRANSFER-API-260903.md` §0·머리말과 동일(`environment.json` → `config.json` → `spec/<name>.yml`, Shop 12개·Server 12개 = 24개 파일, 총 666개 엔드포인트).
> 원본 사본: `/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/d5d77812-d764-4091-8a8b-6fb71ed18230/scratchpad/shopby-spec/*.yml`(세션 임시), 평탄화 덤프 `*.dump.txt`, 파서 `dump.py`.
> 로컬 구 사본(`docs/shopby/shopby-api/*.yml`, 2026-06-22)과 적립금 엔드포인트 단위로 대조함(§7). 로컬 운영자 매뉴얼(`docs/shopby/shopby_enterprise_docs/management/accumulation-setting.mdx`)도 참조.
> 표기: 필드명·열거값은 명세 원문(영문) 그대로. 출처는 각 표 머리·행에 `파일명 §경로`로 적음. 명세에서 확인하지 못한 것은 **「미확인」**.

## 0. 한 장 요약

| 질문 | 답 | 출처 |
|---|---|---|
| Shopby 에 「예치금/선불 충전금」 개념이 있는가 | **없다.** 24개 명세 전체에서 `예치금`·`prepaid`·`deposit(예치)`·`charge(충전)` 의미의 엔드포인트·필드는 0건. `PREPAID_DELIVERY`(배송비 선불), `naverPayInfo.chargeAmountPaymentAmount`(네이버페이 충전금), `confirm-deposit`(교환 추가결제 입금확인)만 있고 모두 무관 | 전 명세 grep |
| 대신 쓸 수 있는 것 | **적립금(accumulation)**. Server API 로 즉시 지급/차감/조회, Shop API 로 회원 잔액·이력 조회, 주문서 `calculate`·`reserve` 에서 `subPayAmt` 로 사용. 결제수단 열거형에 **`ACCUMULATION: 적립금 전액 사용`**·**`ZERO_PAY: 0원결제`** 가 존재 | `manage-server-public.yml`, `manage-shop-public.yml`, `order-shop-public.yml` |
| 표시명을 「프린트머니」로 바꿀 수 있는가 | **있다(어드민 설정).** 몰 설정 `accumulationConfig.accumulationName`(적립금명)·`accumulationUnit`(표시단위)이 Shop API `GET /malls` 로 내려온다. 매뉴얼: 「적립금 명칭 기본값 '적립금', 표시단위 기본값 '원' … 쇼핑몰에만 반영되며 어드민에는 미반영」. API 로 설정을 바꾸는 엔드포인트는 **없음** | `admin-shop-public.yml` §GET /malls · `accumulation-setting.mdx` |
| 지급 API | `POST /profile/accumulations` — `memberNo`(또는 `memberId`)·`accumulationAmt`·`expireYmd`·`notificationChannels`·`externalKey`(60자)·`reasonDetail`·`isManual` | `manage-server-public.yml` |
| 차감 API | `DELETE /profile/accumulations` — 쿼리 `accumulationAmt`·`entireSubtracted`·`memberNo`/`memberId`·`detailReason`·`externalKey`·`isManual`. 잔액 부족이면 400 `code: "A0002"` | 〃 |
| 잔액 조회 | 단건 `GET /profile/accumulations`(`totalAmt` = 최종 사용가능 금액), 다건 `POST /accumulations/members/available`(최대 500명) | 〃 |
| 주문 이벤트 | 웹훅 이벤트 타입 열거에 `CREATE_ORDER`·`CHANGE_ORDER_STATUS`·`ACCUMULATION_ADDED`·`ACCUMULATION_SUBTRACTED`·`ACCUMULATION_SUBTRACT_ROLLBACK` 등이 있으나, **웹훅 등록 API·페이로드 스키마는 명세에 없음**(실패 이력 조회 `GET /webhooks/failed` 만 존재). 등록은 워크스페이스 앱 설정으로 추정 —「미확인」 | `workspace-server-public.yml` |
| 상품형 충전(충전권 상품 주문→적립금 지급) | 가능성 있음. Server `GET /orders` 를 `searchType=MALL_PRODUCT_NO`·`searchDateType=PAY_DONE`·`orderRequestTypes=PAY_DONE` 로 조회 → `memberNo` 로 `POST /profile/accumulations`. 이중 적립 방지 = 상품 등록/수정 시 `accumulationRate: 0`(「0 이면 설정안함」) + `accumulationUseYn: "N"`(충전권을 적립금으로 사는 것 차단) | `order-server-public.yml`, `product-server-public.yml` |

## 1. Server API — 적립금(Accumulations) 패밀리

파일: `manage-server-public.yml`(title `manage-server`, version 1.0), 태그 `Accumulations`, 총 10개. 기본 호스트 `https://server-api.shopby.co.kr`. 공통 헤더는 §6. 명세 공통 주석: 「기본 적립금 단위는 정수형으로 지원합니다. ex) 1000 / Global Mall의 경우 소수점 2자리」.

### 1-1. 엔드포인트 목록

| # | 메서드·경로 | 명세 제목 | 용도(프린트머니 관점) |
|---|---|---|---|
| 1 | `POST /profile/accumulations` | 적립금 지급하기 | **충전 반영(지급)** |
| 2 | `DELETE /profile/accumulations` | 적립금 차감하기 | **회수/정정(차감)** |
| 3 | `GET /profile/accumulations` | 적립금 상태 조회하기 | 회원 1명 잔액·내역 |
| 4 | `POST /accumulations/members/available` | 회원 보유 적립금 조회(다건) | 여러 회원 가용잔액 일괄 |
| 5 | `GET /accumulations` | 적립금 조회하기 | 몰 전체 적립금 건 검색(등록/시작/만료일 기준), `externalKey` 로 검색 |
| 6 | `GET /accumulations/settlement` | 적립금 지급/차감 이력 조회 | 트랜잭션 원장(seq) |
| 7 | `GET /accumulations/usage` | 적립금 사용처 추적하기 | 지급건이 어느 주문에 쓰였는지 |
| 8 | `GET /accumulations/assembles` | 적립금 변동 요청 조회 | 어드민 예약/일괄 지급 요청 현황(조회만) |
| 9 | `GET /accumulations/externals` | 외부적립금 연동 이력 조회 | 「외부적립금 연동을 사용하는 몰」 전용 이력 |
| 10 | `PUT /profile/accumulations/{accumulationNo}/expire` | 적립금 만료 처리 | 특정 지급건 잔액 강제 만료 |

**없는 것**: 일괄 지급(bulk grant) 쓰기 API — `/accumulations/assembles` 는 GET 뿐이라 예약·일괄 지급 요청을 API 로 만들 수 없다(어드민 화면 전용). 다건 지급은 #1 을 회원 수만큼 반복 호출해야 한다. 설정(적립금명·유효기간·사용조건) 변경 API 도 없다.

### 1-2. `POST /profile/accumulations` — 적립금 지급하기

명세 설명: 「특정 회원에게 적립금을 즉시 지급하는 API 입니다.」 바디 `application/json`:

| 필드 | 타입 | 필수 | 명세 설명(원문) | 예시 |
|---|---|---|---|---|
| `memberNo` | number | ✅ | 회원 번호(회원 조회용) | 1 |
| `memberId` | string | – | 회원 아이디(회원 조회용) (nullable) | test |
| `accumulationAmt` | number | ✅ | 적립금 지급 금액 | 1000.0 |
| `expireYmd` | string | ✅(스키마상) | 적립금 만료일. 생략하면 몰 적립금 기본 설정의 적립금 유효기간 반영 | YYYY-MM-DD |
| `notificationChannels` | array | ✅(스키마상) | 만료 알림 수단 (복수 설정) [EMAIL, SMS] | [EMAIL, SMS] |
| `externalKey` | string | – | 외부 키(조회용)(최대 60자) (nullable) | abecedary |
| `reasonDetail` | string | – | 지급 상세사유. 생략하면 '운영자 지급' 으로 저장. 200자까지 입력가능. (nullable) | 수동 지급 |
| `isManual` | boolean | – | 운영자 수동 지급 여부 (true: 수동 (어드민에서 내역 조회 가능), false: 자동) (nullable) | false |

응답 200: `{ memberNo, accumulationNo }`(「생성된 적립금 번호」).

주의: `expireYmd`·`notificationChannels` 가 `required` 로 표시돼 있으나 설명문은 「생략하면 …」이라 실제로 생략 가능한지는 **「미확인」**(테스트몰 실측 필요). 명세 예시 요청값은 `"expireYmd": null, "notificationChannels": []`. `externalKey` 는 후니 충전 트랜잭션 ID(예: 주문번호)를 넣어 멱등 키·역추적 키로 쓸 수 있고, `GET /accumulations?externalKey=` 로 검색된다(§1-4). 단, 서버가 `externalKey` 중복을 거부하는지는 **「미확인」**(명세에 유일성 언급 없음 → 후니 쪽에서 중복 지급 방지 필요).

### 1-3. `DELETE /profile/accumulations` — 적립금 차감하기

명세 설명: 「특정 회원의 적립금을 차감하는 API 입니다. 회원의 보유 적립금 보다 많은 금액 차감 시, 차감 실패」. 파라미터는 전부 **query**:

| 필드 | 타입 | 명세 설명 | 예시 |
|---|---|---|---|
| `accumulationAmt` | number | 적립금 차감 금액 | 100.0 |
| `entireSubtracted` | boolean | 전체 적립금 차감 여부 | false |
| `memberId` | string | 회원 아이디(회원 조회용) | test |
| `memberNo` | number | 회원 번호(회원 조회용) | 1 |
| `detailReason` | string | 적립금 차감 사유(최대 200자) | 차감 테스트 |
| `externalKey` | string | 외부 키(조회용)(최대 60자) | aaabdcd |
| `isManual` | boolean | 운영자 수동 지급 여부 (true: 수동 (어드민에서 내역 조회 가능), false: 자동) | false |

응답 200: `subtractedAmt`, `memberNo`, `accumulationNo`(「생성된 적립금 번호(차감)」), `subtractionRelatedAccumulations[]{accumulationNo, changeAmt, expireDateTime, registerDateTime}` — 어느 지급건에서 얼마씩 깎였는지 반환(선입선출로 추정, 순서 규칙은 「미확인」).

에러 응답 예시(명세 원문):
```json
{ "timestamp":"2025-04-28 13:44:57", "path":"DELETE /server/profile/accumulations", "status":400, "error":[ ], "code":"A0002",
  "message":"지급 받은 적립금 중 17,900 적립금이 부족하여 처리할 수 없습니다. 부족한 적립금에 대해 확인 후 진행해 주세요." }
```
명세에 등장하는 적립금 에러코드는 `A0002`(잔액 부족)·`A0034`(「이미 만료된 적립금입니다」, expire API)뿐이다. 전체 코드표는 **「미확인」**.

### 1-4. 조회 API 상세

**`GET /profile/accumulations`** (회원 1명) — query `memberId` | `memberNo`, `startYmd`, `endYmd`, `page`, `pageSize`(최대 10000). 응답: `memberNo`, **`totalAmt`**(「전체 기간 중 해당 고객이 최종적으로 사용 가능한 적립금 금액」), `itemsTotalRestAmt`, `totalCount`, `items[]`:
`accumulationNo`, `accumulationAmt`, `restAccumulationAmt`(「적립금액 중 사용 가능 금액」), `accumulationStatus`, `accumulationReserveReason`, `reasonDetail`, `externalKey`, `orderNo`, `productDisplayName`, `startYmdt`, `expireYmdt`, `registerYmdt`.

**`POST /accumulations/members/available`** — 바디 `memberNos`(「회원 번호 리스트(콤마 구분)(개발중)」), `memberIds`(「회원 아이디 리스트(콤마 구분)」); 「합산하여 최대 500건」. 응답 `count`, `items[]{memberNo, memberId, amount(가용 적립금)}`. `memberNos` 가 「개발중」 표기이므로 아이디 기준이 안전.

**`GET /accumulations`** — query `periodType`*(REGISTER|START|EXPIRE), `startYmd`*, `endYmd`*, `accumulationNos`, `isOnlyAvailable`, **`externalKey`**(「외부 키(조회용)」), `page`, `pageSize`. 응답 `items[]` 에 `restAmount`, `accumulationAmt`, `accumulationStatus`, `accumulationReserveReason`, `externalKey`, `memberNo`, `orderNo` 등.

**`GET /accumulations/settlement`** — `startYmd`*, `endYmd`*(예시는 `YYYY-MM-DD HH:mm:ss`). 응답 `items[]{seq(트랜잭션 아이디), accumulationNo, relatedAccumulationNo, amount, reason, reasonDetail, accumulationStatus, mappingType, mappingValue(주문 시 'orderOptionNo'), memberNo, registerYmdt, description}`.

**`GET /accumulations/usage`** — `accumulationNos`*(최대 1000개). 응답 `[]{accumulationNo, startAmount, restAmount, usages[]{orderNo, useDateTime, useAmount}}` — 지급한 충전금이 어떤 주문에 얼마 쓰였는지 추적.

**`GET /accumulations/externals`** — 「외부적립금 연동을 사용하는 몰에서 적립금 연동 이력을 조회」. query `requestType`(ADD, SUB, SUB_ROLLBACK), `mappingKeyType`(REVIEW, ORDER, ORDER_OPTION), `mappingKeys`, `externalNos`, `seqs`, `success`. 응답 `items[]{seq, requestType, memberKey, mappingKeyType, mappingKey, externalNo, amount, success, requestJson, responseJson, requestDateTime}`. → Shopby 에 「외부적립금 연동」 모드가 존재함을 시사하나(적립금 원장을 외부 시스템이 갖는 형태), 그 계약(외부 시스템이 구현해야 할 수신 API)은 이 명세에 없다 — **「미확인」**.

### 1-5. 열거값(명세 원문)

`accumulationStatus`(Server): `GIVE: 지급`, `GIVE_BY_CANCELED: 차감롤백`, `SUBTRACTION: 차감`, `SUBTRACTION_BY_CANCELED: 지급롤백`.

`accumulationReserveReason`(적립 사유, Server·Shop 공통): `ADD_AFTER_PAYMENT: 상품 구매확정 적립`, `ADD_AFTER_EVENT_PAYMENT`, `ADD_AFTER_REPLACE_PAYMENT`, `ADD_POSTING: 상품평 작성 적립`, `ADD_CANCEL: 주문취소 재적립`, `ADD_RETURN: 반품 재적립`, **`ADD_MANUAL: 운영자 지급`**, `ADD_EVENT`, `ADD_SIGNUP`, `ADD_BIRTHDAY`, `ADD_APP_INSTALL`, `ADD_APP_ORDER`, `ADD_APP_NOTIFICATION`, `ADD_GRADE`, `ADD_GRADE_BENEFIT`, `ADD_COUPON`, **`SUB_PAYMENT_USED: 상품 결제 사용 차감`**, `SUB_EXTRA_PAYMENT_USED`, `SUB_CANCEL: 사용적립금 주문취소 재적립`, `SUB_RETURN`, `SUB_DELETE_POSTING`, `SUB_EXPIRED: 유효기간 만료`, **`SUB_MANUAL: 운영자 차감`**, `SUB_DELETE_ACCOUNT: 회원탈퇴 차감`, `EXTERNAL_ACCUMULATION: 외부적립금`.
→ API 지급/차감은 `ADD_MANUAL`/`SUB_MANUAL` 로 기록될 것으로 보이나 명세가 명시하지는 않음(「미확인」). 사유 코드를 호출자가 지정하는 필드는 없다.

`requestType`(assembles): `DIRECT_ADD, DIRECT_SUB, RESERVE_ADD, ORDER_RESERVE_ADD`.

## 2. Server API — 주문 조회·상태 변경, 웹훅

### 2-1. 주문 조회 (`order-server-public.yml`, 태그 `Orders`)

**`GET /orders`** (「주문 조회하기 v1.1」, 헤더 `Version: 1.1` 시 `contents[]`+`totalCount`) — 충전권 주문 감지에 쓰는 query:

| 파라미터 | 명세 설명 |
|---|---|
| `startYmd`/`endYmd`, `startYmdt`/`endYmdt` | 조회 기간(기본 3개월 전~오늘; `*Ymdt` 가 우선) |
| `searchDateType` | 조회하려는 주문일시 유형 [default: ORDER_START] (`ORDER_START, PAY_DONE, PRODUCT_PREPARE, DELIVERY_PREPARE, DELIVERY_ING, DELIVERY_DONE, BUY_CONFIRM, STATUS_CHANGE`) |
| `orderRequestTypes` | 주문상태 타입 (`DEPOSIT_WAIT, PAY_DONE, PRODUCT_PREPARE, DELIVERY_PREPARE, DELIVERY_ING, DELIVERY_DONE, BUY_CONFIRM, CANCEL_DONE, RETURN_DONE, …`) |
| `searchType` + `searchValues` | 검색 유형(주문번호, 상품번호) (`ALL, ORDER_NO, MALL_PRODUCT_NO`) + 검색 값(콤마 구분) |
| `memberNo` | 회원번호 |
| `payType` | 결제수단(§3-3 열거와 동일; `ACCUMULATION`, `ZERO_PAY` 포함) |
| `pageNumber`, `pageSize`(최대 200), `desc` | 페이징 |

응답 `contents[]` 주요 필드: `orderNo`, `memberNo`, `memberId`, `orderYmdt`, `firstPayYmdt`, `payType`, `payTypeLabel`, **`firstMainPayAmt`/`lastMainPayAmt`**(「실제결제금액(적립금제외)」), **`firstSubPayAmt`/`lastSubPayAmt`**(「포인트 사용금액」), `paymentInfo.complexPayInfo.mainPayAmt`, `deliveryGroups[].orderProducts[]{mallProductNo, productName, orderProductNo, orderProductOptions[]{orderStatusType, payYmdt, orderYmdt, memberAccumulationRate, mallProductAccumulationRate, …}}`.

`orderStatusType` 열거: `DEPOSIT_WAIT, PAY_DONE, PRODUCT_PREPARE, DELIVERY_PREPARE, DELIVERY_ING, DELIVERY_DONE, BUY_CONFIRM, CANCEL_DONE, RETURN_DONE, EXCHANGE_DONE, PAY_WAIT, PAY_CANCEL, PAY_FAIL, DELETE, EXCHANGE_WAIT, REFUND_DONE`.

**`GET /orders/{orderNo}`** — 단건. `payments[].balance{mainPayAmt(실결제금액), subPayAmt(보조결제금액(적립금))}`, `payments[].paymentInfo{bankInfo, cardInfo, tradeNo, naverPayInfo…}`.

**`GET /orders/deliveries`** — 배송번호 기준, `searchType` 에 `ORDER_OPTION_NO` 추가.

상태 변경 계열(참고): `PUT /orders/prepare-product`, `/orders/prepare-delivery`, `/orders/delivery`, `/orders/delivery-ing`, `/orders/receive`, **`PUT /orders/confirm`**(구매확정 — 「서비스 어드민 권한으로만 호출 가능」), `PUT /orders/change-status/by-shipping-no`(바디 `orderStatusType` + `changeStatusList[]{shippingNo, deliveryCompanyType, invoiceNo}`; 응답 `failures[]{errorCode ex OD0010}`). 충전권 상품은 배송이 없으므로 결제완료 후 `prepare-product → … → confirm` 을 어떻게 닫을지는 운영 설계 몫(디지털/무배송 상품 처리 규칙은 명세에 없음 — 「미확인」).

### 2-2. 웹훅 (`workspace-server-public.yml`, 태그 `Webhook`)

workspace-server 의 전체 경로: `/app-installed/extend`, `/app-installed/status`, `/auth/me`, `/auth/token`, `/auth/token/long-lived`, `/auth/token/revoke`, `/external-script`, `/oauth/token`, **`/webhooks/failed`**. 즉 **웹훅 등록/수정/삭제 API 는 없다.** 실패 이력 조회만 있다:

**`GET /webhooks/failed`** 「실패한 웹훅 조회하기」 — 「웹훅 발송 시 실패했던 내역을 조회합니다. 7일 이내의 검색 기간에 한해서만 조회가 가능합니다. 웹훅 실패 내역의 보관기간은 생성일로부터 6개월」. query `startDateTime`*, `endDateTime`*, `mallNos`, `eventType`, `direction`, `page`, `pageSize`. 응답 `contents[]{eventType, webhookUrl(웹훅 수신 URL), httpMethod(POST), data(웹훅 송신 데이터, string), exceptionType, exceptionMessage, exceptionDateTime, mallNo, solutionType(SHOPBY|GODO), shopNo}`.

`eventType` 열거(명세 원문, 샵바이 쪽만 발췌; `GD_*` 는 고도몰):

| 그룹 | 이벤트 |
|---|---|
| 앱 | `CHANGE_APP_STATUS: 앱 설치/삭제` |
| 게시판 | `PRODUCT_INQUIRY_ADDED/DELETED`, `PRODUCT_REVIEW_ADDED/DELETED`, `INQUIRY_ADDED/MODIFIED/DELETED` |
| **적립금** | **`ACCUMULATION_ADDED: 적립금 지급`, `ACCUMULATION_SUBTRACTED: 적립금 차감`, `ACCUMULATION_SUBTRACT_ROLLBACK: 적립금 차감 취소`** |
| 회원 | `MEMBER_CREATED, MEMBER_INFO_CHANGED, MEMBER_GRADE_CHANGED, MEMBER_GROUP_CHANGED, MEMBER_WITHDRAW, MEMBER_DORMANT, MEMBER_RELEASED` |
| **주문** | **`CREATE_ORDER: 주문생성`, `CHANGE_ORDER_STATUS: 주문상태변경`, `UPDATE_RECEIVER: 수령자 정보 변경`, `UPDATE_INVOICE: 송장 등록/변경`** |
| 기타 | `ADD_TASK_MESSAGE/UPDATE_TASK_MESSAGE/DELETE_TASK_MESSAGE`, `ADD_CART`, `PRODUCT_UPDATED`, `COUPON_ADDED/MODIFIED/DELETED` |

「미확인」: (a) 웹훅 수신 URL 을 어디서 등록하는지(명세에 없음; `webhookUrl`·`CHANGE_APP_STATUS`·`/app-installed/*` 로 미루어 **워크스페이스의 앱 설정**에 딸린 기능으로 추정), (b) 각 이벤트의 페이로드 스키마(`data` 가 문자열로만 정의됨; `PAY_DONE` 이 `CHANGE_ORDER_STATUS` 로 오는지 여부 포함), (c) 재시도 정책·서명 검증. `https://docs.shopby.co.kr/guide`·`https://server-docs.shopby.co.kr/guide`·`https://workspace.godo.co.kr/guide/skin/dev-cover/order` 는 JS 렌더링 페이지라 curl 로 본문을 얻지 못했고, gitbook 엔터프라이즈 매뉴얼 첫 페이지에도 웹훅 항목은 없었다. 로컬 `docs/shopby/shopby_enterprise_docs/` 전체에도 「웹훅」 언급 0건.

→ 설계상 웹훅은 **보조 신호**로만 두고, 진실은 `GET /orders`(`searchDateType=PAY_DONE`) 주기 조회로 확정하는 편이 안전하다(웹훅 유실 시 `GET /webhooks/failed` 로 7일 내 보정 가능).

## 3. Shop API — 회원이 적립금을 쓰는 흐름

파일: `order-shop-public.yml`(주문서·결제), `manage-shop-public.yml`(적립금 조회), `admin-shop-public.yml`(몰 설정). 호스트 `https://shop-api.shopby.co.kr`. 공통 헤더는 16_bank-transfer 노트 §2 와 동일(`Version`, `clientId`, `platform`, `accessToken`).

### 3-1. 주문서 조회 `GET /order-sheets/{orderSheetNo}` — 적립금 관련 응답

| 필드 | 명세 설명 |
|---|---|
| `paymentInfo.accumulationAmt` | 보유한 적립금 |
| `paymentInfo.availableMaxAccumulationAmt` | 최대 사용가능한 적립금 |
| `paymentInfo.minAccumulationLimit` | 적립금을 사용할 수 있는 최소 적립금 기준 |
| `paymentInfo.minPriceLimit` | 적립금을 사용할 수 있는 최소 결제 금액 기준 |
| `paymentInfo.isAvailableAccumulation` | 적립금 사용 가능 여부 (true: 가능, false: 불가능) |
| `paymentInfo.usedAccumulationAmt` | 사용한 적립금 |
| `paymentInfo.paymentAmt` | 「paymentAmt[결제예정금액] = buyAmt − cartCouponAmt + deliveryAmt + remoteDeliveryAmt + salesTaxAmt (− usedAccumulationAmt[사용한적립금]: OrderSheet시점에는 hidden) − 외부 결제금액」 |
| `paymentInfo.accumulationAmtWhenBuyConfirm` | 구매확정시 예상 적립금 |
| `orderSheetPromotionSummary.myAccumulationAmt` | 사용가능한 적립금 |
| `blockUseAccumulationWhenUseCoupon` | 쿠폰, 적립금 동시 사용 차단 여부 |
| `deliveryGroups[].orderProducts[].accumulationUsable` | 적립금 사용 가능 여부(상품별) |
| `availablePayTypes[]{payType, pgTypes[], payTypeLabel}` | 사용 가능한 결제수단(§3-3 열거) |

### 3-2. 금액 재계산 `POST /order-sheets/{orderSheetNo}/calculate`

「쿠폰 및 배송지 정보가 적용된 금액 조회하기」. 바디 `required: [accumulationUseAmt, addressRequest, couponRequest, shippingAddresses]`:

| 필드 | 명세 설명 |
|---|---|
| **`accumulationUseAmt`** (number, 필수) | 적립금 사용액 |
| `addressRequest{…}` | 주소(지역별 추가배송비 계산에 `jibunAddress` 필요) |
| `couponRequest{productCoupons[], cartCouponIssueNo, promotionCode}` | 쿠폰 |
| `externalPayInfos[]` | 외부결제수단정보 (nullable) |

응답 `paymentInfo` 는 §3-1 과 같은 구조(`paymentAmt`, `usedAccumulationAmt`, `availableMaxAccumulationAmt`, `minAccumulationLimit`, `minPriceLimit`, `isAvailableAccumulation` …) + `availablePayTypes[]`. → 적립금을 넣은 뒤 `paymentAmt` 가 0 이 되는지, 그때 `availablePayTypes` 에 어떤 `payType` 이 내려오는지(`ZERO_PAY`/`ACCUMULATION`)는 **테스트몰 실측 필요 「미확인」**.

### 3-3. 주문 예약 `POST /payments/reserve` — 적립금 관련 바디

| 필드 | 타입 | 명세 설명 |
|---|---|---|
| **`subPayAmt`** (필수) | number | 보조결제 수단 결제액(적립금 사용액) |
| `paymentAmtForVerification` | number | 검증을위한 결제예정금액(적립금사용후) |
| `availableAccumulationByOptions[]{mallOptionNo, availableAccumulationRate, availableAccumulationAmt}` | array | 옵션별 사용가능 적립금 정보 / 사용가능 적립금 한도율 / 한도 |
| `payType` (필수) | enum | 아래 |
| `pgType` (필수) | enum | `DUMMY: 없음`, `NONE: PG없음`, `KCP`, `INICIS`, `TOSS_PAYMENTS`, `NAVER_EASY_PAY`, `KAKAO_PAY` … |

`payType` 열거(원문 일부): `CREDIT_CARD: 신용카드`, `ACCOUNT: 무통장입금`, `MOBILE`, `REALTIME_ACCOUNT_TRANSFER`, `VIRTUAL_ACCOUNT`, `GIFT`, `ATM`, `PAYCO`, **`ZERO_PAY: 0원결제`**, **`ACCUMULATION: 적립금 전액 사용`**, `PHONE_BILL`, **`POINT: 포인트결제`**, `NAVER_PAY: 네이버페이 주문형`, `KAKAO_PAY`, `NAVER_EASY_PAY: 네이버페이 결제형`, `TOSS_PAY`, `APPLE_PAY`, `EXTERNAL_PAY: 외부 결제 전액 사용`, `APP_CARD`, `EXTERNAL_ORDER: 외부연동주문 결제`, `ETC: 기타결제수단` 등 44종.

명세 설명: 「payType과 PgType 값은 … 응답값 내 availablePayTypes 참고」, 결제편의모듈(NCPPay) 가이드 참조. **적립금 전액 결제**는 `payType: "ACCUMULATION"` 이 그 용도(「적립금 전액 사용」)로 정의돼 있고, `ZERO_PAY` 는 0원결제(쿠폰 등으로 0원)이다. 어느 쪽을 써야 하는지, `pgType` 을 `NONE`/`DUMMY` 중 무엇으로 보내야 하는지, NCPPay 가 이를 결제창 없이 처리하는지는 **「미확인」**(명세 설명문 없음 → 실측). 참고로 클레임 명세의 `additionalPayType` 열거는 `CASH: 무통장입금 | ACCUMULATION: 적립금 전액 사용 | NAVER_PAY` 로, 교환 추가결제도 적립금 전액이 정식 수단이다(`claim-server-public.yml`). 환불 쪽 `refundType` 열거: `PG, ACCUMULATION, ACCOUNT, ZERO_REFUND, EXTERNAL_PAY, ADMIN_ETC, EXTERNAL_ORDER`.

`POINT: 포인트결제` 는 외부 포인트(PG 포인트) 결제로 보이며 몰 적립금과 무관 — 「미확인」.

### 3-4. 회원 적립금 조회 (`manage-shop-public.yml`, 태그 `Accumulation`, 4개)

| 메서드·경로 | 명세 제목 | 요청 | 응답 |
|---|---|---|---|
| `GET /profile/accumulations` | 적립금 이력 조회하기 | `pageNumber, pageSize, accumulationReason(ADD|SUB), startYmd, endYmd(default 3개월), direction` | `memberNo, totalAmt(적립 총액), totalCount, items[]{accumulationNo, accumulationAmt, accumulationRestAmt(잔여 적립금), totalAvailableAmt(적립금 총액), accumulationStatus(GIVE_AVAILABLE: 지급 / SUBTRACTION_CANCELED: 차감롤백 / SUBTRACTION_USED: 차감 / GIVE_CANCELED: 지급롤백), accumulationStatusGroupType(PAYMENT|DEDUCTION), accumulationReserveReason, accumulationReserveReasonDisplay, reasonDetail, orderNo, mappingKey(외부 적립금 사용 시에만), startYmdt, expireYmdt, registerYmdt}` |
| `GET /profile/accumulations/summary` | 적립금 요약 조회하기 | `expireStartYmdt, expireEndYmdt` | `totalAvailableAmt(사용가능한 총 적립금액), totalExpireAmt` |
| `GET /profile/accumulations/expiration` | 만료 예정 적립금 조회하기 | `startYmdt, endYmdt` | `expirations[]{accumulationNo, amount, expirationYmdt, accumulationReserveReasonDisplay, reasonDetail}, expiresAmount` |
| `GET /profile/accumulations/waiting` | 해당 회원의 예상 적립금 조회하기 | – | `waitingAccumulation` |

Shop 쪽 `accumulationStatus` 열거명이 Server 와 다름(`GIVE_AVAILABLE` vs `GIVE`) — 두 API 를 섞어 쓸 때 매핑 주의. 스킨의 「프린트머니 잔액」 표시는 `summary.totalAvailableAmt`, 내역은 `GET /profile/accumulations` 로 만들면 된다. `reasonDetail`(Server 지급 시 넣은 문구)이 그대로 내려오므로 「충전 10,000원(주문 2026…)」 같은 설명을 손님 화면에 보여줄 수 있다.

## 4. 몰 적립금 설정(표시명 커스터마이즈 포함)

`admin-shop-public.yml` §`GET /malls`(「몰 정보 조회하기」) 응답 `accumulationConfig` — 모두 nullable:

| 필드 | 명세 설명 | 예시 |
|---|---|---|
| **`accumulationName`** | 적립금명 | "구매 적립금" |
| **`accumulationUnit`** | 적립금 단위 | "포인트" |
| `accumulationRate` | 적립금 기본 적립률 | 10 |
| `useProductAccumulation` | 상품 적립 사용여부 | false |
| `useMemberAccumulation` | 회원 적립 사용여부 | false |
| `productAccumulationBasisType` | 상품 금액 기준 설정: `SALE_PRICE, SALE_STANDARD_PRICE, SALE_PROMOTION_PRICE, DISCOUNTED_PRICE, DISCOUNTED_STANDARD_PRICE, DISCOUNTED_PROMOTION_PRICE` | |
| `accumulationGivePoint` | 적립금 지급 시점: `IMMEDIATE, NEXTDAY, DAY_AFTER_TOMMOROW, AFTER_A_WEEK, AFTER_TWO_WEEK, AFTER_TWENTY_DAYS, AFTER_THIRTY_DAYS, NEXT_MONTH` | |
| `accumulationValidPeriod` | 적립금 유효기간 (month 기준) | 3 |
| `useExpireNotification` / `expireNotificationPoint` | 만료 알림 사용여부 / 알림 시점(day) | 30 |
| `limitMinPrice` / `accumulationUseMinPrice` | 적립금 사용 최소 적립금 제한 여부 / 최소 적립금 | 1000 |
| `limitMinProductPrice` / `accumulationUseMinProductPrice` | 사용 최소 상품금액 제한 여부 / 최소 상품금액 | 5000 |
| `limitMaxRate` / `accumulationUseMaxRate` | 사용 최대비율 제한 여부 / 최대비율 | 100 |
| `excludingReservePayAccumulation` / `excludingReservePayCoupon` | 적립금 사용 시 / 쿠폰할인 결제 시 적립금 지급 제외여부 | |
| `accumulationDisplayFormatType` | 노출 설정: `FIXED_AMT, FIXED_RATE, FIRST_FIXED_RATE, FIRST_FIXED_AMT` | |
| `useSignUpAccumulation` / `signUpAccumulation`, `useBirthdayAccumulation` / `birthdayAccumulation`, `useReviewsAccumulation` / `reviewsAccumulationDetail{…}` | 가입·생일·후기 적립금 | |
| `adminMemo` | 운영자 메모 | |

운영자 매뉴얼(`accumulation-setting.mdx`)에서 확인되는 설정 범위: 명칭/표시단위(기본 '적립금'/'원', 쇼핑몰에만 반영), 유효기간(1개월~71개월 또는 제한없음), 만료 알림(2/7/14/20/30일 전, SMS·이메일), 구매 적립(상품 개별 적립률 우선, 기본 적립률, 등급·그룹 중 큰 값), 사용 조건(최소 결제금액·최소 사용 적립금·최대 사용비율 %). 「적립금 관리와 관련 기능은 본사 어드민에만 제공」.

프린트머니 설계 시 권장 설정값: `accumulationName="프린트머니"`, `accumulationUnit="원"`, `accumulationRate=0`·`useProductAccumulation=false`·`useMemberAccumulation=false`(구매 자동적립 끔), `useSignUpAccumulation=false`, `accumulationUseMaxRate=100`, 최소 사용 제한 해제, 유효기간은 정책에 따라(선불 충전금 소멸 시 약관 고지 필요 — 매뉴얼 경고). **설정 변경 API 는 없음** → 어드민 수동. 프린트머니를 자동적립과 공존시키려면 `reasonDetail`/`externalKey` 로 구분해 손님 화면에서 필터링해야 한다(Shop API 에 사유별 필터는 `accumulationReason=ADD|SUB` 뿐).

## 5. 상품형 충전(충전권 상품 → PG 결제 → 적립금 지급) 타당성

흐름: (1) 「프린트머니 10,000원 충전권」 을 일반 상품으로 등록 → (2) 손님이 PG 로 결제(`PAY_DONE`) → (3) 후니 서버가 감지 → (4) `POST /profile/accumulations` 로 동액 지급 → (5) 이후 인쇄 주문에서 `subPayAmt` 로 사용.

| 단계 | 근거 API·필드 | 비고 |
|---|---|---|
| 상품 등록 | `product-server-public.yml` §`POST /products`(「상품(옵션포함) 등록하기 (Version 3.0)」), `PATCH /products/{productNo}` | 바디 `accumulationRate`(「적립금적립 - %, 0 이면 설정안함(nullable)」), **`accumulationUseYn`**(「적립금 사용 가능 여부 - Y(가능), N(불가능)」), `accumulationLimitInfo{unitType(AMOUNT|PERCENT), limitValue}`(적립금 사용 한도율) |
| 이중 적립 방지 | 위 `accumulationRate: 0` + 몰 기본 적립률(`accumulationConfig.accumulationRate`)·회원등급 적립률 | 매뉴얼: 「상품 개별 적립률과 기본 적립률이 동시에 설정되어 있다면, 상품 개별 적립률이 적용」— 그러나 「개별 적립금을 설정하지 않은 상품의 경우 기본 적립률이 적용」이므로 `0` 이 「설정안함」으로 해석돼 기본 적립률로 떨어질 위험. 등급 적립률은 별도 합산(「기본 적립금과 회원등급 적립금 지급 = 5% (1%+4%)」) → **몰 기본 적립률·등급 적립률을 0/미사용으로 두는 것이 확실**. 충전권 상품의 `accumulationRate: 0` 이 실제로 0 적립을 보장하는지는 「미확인」 |
| 충전권을 적립금으로 사는 것 차단 | `accumulationUseYn: "N"` | 주문서 `orderProducts[].accumulationUsable`(「적립금 사용 가능 여부」)로 반영될 것으로 추정 — 두 필드의 연결은 명세에 명시돼 있지 않음 「미확인」 |
| 결제완료 감지(폴링) | `GET /orders` `searchType=MALL_PRODUCT_NO&searchValues=<충전권 productNo>&searchDateType=PAY_DONE&orderRequestTypes=PAY_DONE&startYmdt=<last>&endYmdt=<now>` (Version 1.1) | 응답 `contents[]{orderNo, memberNo, memberId, firstMainPayAmt, deliveryGroups[].orderProducts[].orderProductOptions[]{orderStatusType, payYmdt, orderCnt…}}`. 비회원 주문은 `memberNo` 없음 → 충전권은 **회원 전용**으로 제한 필요 |
| 결제완료 감지(웹훅) | `CHANGE_ORDER_STATUS` 이벤트 | 페이로드 「미확인」(§2-2). 보조 신호 |
| 지급 | `POST /profile/accumulations {memberNo, accumulationAmt, externalKey: "<orderNo>", reasonDetail: "프린트머니 충전 <orderNo>", isManual: false, expireYmd, notificationChannels}` | 응답 `accumulationNo` 를 후니 DB 에 주문번호와 함께 보관. 재실행 전 `GET /accumulations?externalKey=<orderNo>` 로 기지급 여부 확인(멱등) |
| 취소/환불 대응 | 충전권 주문 취소(`CANCEL_DONE`/`REFUND_DONE`) 감지 → `DELETE /profile/accumulations?memberNo&accumulationAmt&externalKey=<orderNo>` | 이미 일부 사용했으면 `A0002` → 취소 불가 정책 필요. 클레임 API(`claim-server`)는 적립금 결제분 환불에 `refundType: ACCUMULATION` 을 지원 |
| 주문 상태 마감 | `PUT /orders/prepare-product` → … → `PUT /orders/confirm`(서비스 어드민 권한) | 무배송 상품의 상태 흐름은 「미확인」. `orderStatusType=PAY_DONE` 에 머무는 주문이 어드민 목록에 쌓이는 문제 고려 |

주의: Server `GET /orders` 의 `searchDateType=PAY_DONE` 은 「입금/결제 확인일 기준」이므로 무통장(`ACCOUNT`) 충전도 `PUT /accounts/orders/confirmation` 후 같은 조회로 잡힌다(16_bank-transfer §3-2). 실제 정산 관점(충전금 = 선수금)은 Shopby 정산 통계가 「적립금 사용」으로 집계하므로 회계 처리는 별도 검토.

## 6. Server API 인증(요약, 16_bank-transfer §3·§3-1 과 동일)

`workspace-server-public.yml`(호스트 `https://server-api.e-ncp.com`): `POST /auth/token/long-lived`(「authorization code로 장기 토큰발급하기」, 서버 간 통신용·앱 등록 IP 제한), `POST /auth/token`(단기), `POST /auth/token/revoke`, `POST /oauth/token`(「client_credentials 로 S2S 토큰 발급하기」 — 신규 확인, 상세 「미확인」), `GET /auth/me`(토큰의 어드민/몰 정보, `scopes` 예시 `readable.ORDER`, `writable.ORDER`). 모든 Server API 호출 헤더: `Version: 1.0`(주문 조회는 `1.1`), `systemKey`(필수), `Authorization: Bearer {access_token}`(권장; 이때 `mallKey`·`partnerId` 는 null). 적립금 API 에 필요한 scope 명칭은 명세에 없음 — 「미확인」(앱 등록 시 권한 범위에 적립금/회원 항목이 있는지 워크스페이스에서 확인).

## 7. 로컬 구 사본(2026-06-22) 대비 변경

| 대상 | 차이 |
|---|---|
| Server `manage-server` 적립금 엔드포인트 | 경로 10개 **동일**(추가·삭제 없음) |
| `POST /profile/accumulations` | **`isManual` 필드 신규**(구판에 없음). 나머지 필드 동일 |
| `DELETE /profile/accumulations` | 구판 파라미터 `accumulationAmt, entireSubtracted, memberId, memberNo, detailReason, externalKey` → 신판에 **`isManual` 추가**. `A0002` 예시는 구판에도 있음 |
| `workspace-server` `/webhooks/failed`·이벤트 열거 | 구판에도 존재(`ACCUMULATION_ADDED` 등 동일). 파일이 1151 → 1246 줄로 늘었으나 웹훅 등록 API 는 여전히 없음 |
| Shop `payType` 열거 | `ZERO_PAY`·`ACCUMULATION` 은 구판에도 존재 |

(구 사본 `manage-server-public.yml` 은 PyYAML 파싱 오류(line 110)가 나서 텍스트 검색으로 대조함.)

## 8. 후니 적용 요약(설계 입력)

1. **원장은 Shopby 적립금**, 표시명은 어드민에서 「프린트머니」로. 후니 DB 는 충전 트랜잭션(주문번호 ↔ `accumulationNo` ↔ `externalKey`)만 보관.
2. **충전 경로 A(상품형)**: 충전권 상품 + PG 결제 → 폴링(`GET /orders` PAY_DONE) → `POST /profile/accumulations`. 웹훅은 보조.
3. **충전 경로 B(직접)**: 무통장 입금 확인(16_bank-transfer 흐름) 또는 운영자 수동 → 같은 지급 API.
4. **사용**: 스킨 체크아웃에서 `calculate(accumulationUseAmt)` → `reserve(subPayAmt, payType=ACCUMULATION 또는 ZERO_PAY, pgType 실측)`. 잔액·내역 화면은 Shop `GET /profile/accumulations(/summary)`.
5. **차감/환불**: `DELETE /profile/accumulations`(부족 시 `A0002`). 인쇄 주문을 취소하면 사용한 적립금은 Shopby 가 되돌리는 것으로 보임(사유 열거 `SUB_CANCEL: 사용적립금 주문취소 재적립`·`ADD_CANCEL: 주문취소 재적립` 근거; 동작 자체는 실측 「미확인」).
6. **자동적립 끄기**: 몰 기본 적립률·등급/그룹 적립률·가입/생일/후기 적립 모두 미사용, 충전권 `accumulationRate=0`·`accumulationUseYn=N`.

## 9. 확인 못 한 것

1. **웹훅 등록 방법·페이로드** — 명세에 등록 API 없음, `data` 는 문자열. 워크스페이스 앱 설정 화면(로그인 필요)에서 확인해야 함. `PAY_DONE` 전이가 `CHANGE_ORDER_STATUS` 로 오는지도 미확인.
2. **적립금 전액 결제의 실제 호출 조합** — `payType` 을 `ACCUMULATION` 으로 보낼지 `ZERO_PAY` 인지, `pgType` 은 `NONE`/`DUMMY` 중 무엇인지, NCPPay 가 결제창 없이 confirm 까지 가는지, `calculate` 후 `availablePayTypes` 에 무엇이 내려오는지 → 테스트몰에서 적립금 지급 후 실측 필요.
3. **`POST /profile/accumulations` 의 `expireYmd`·`notificationChannels` 생략 가능 여부**(스키마 required vs 설명 「생략하면」 충돌) 및 **`externalKey` 유일성 보장 여부**.
4. **API 지급/차감이 `ADD_MANUAL`/`SUB_MANUAL` 사유로 기록되는지**, `isManual=false` 일 때 어드민 화면·손님 이력에 어떻게 보이는지.
5. **차감 시 어느 지급건부터 깎이는지**(만료 임박 순/선입선출) — `subtractionRelatedAccumulations` 로 결과는 보이나 규칙은 미기재.
6. **충전권 상품 `accumulationRate: 0` 이 「설정안함 → 기본 적립률 적용」으로 해석되는지** — 몰 기본 적립률을 0/미사용으로 두면 회피 가능하나 실측 필요.
7. **무배송(충전권) 주문의 상태 마감 방법**과 `PUT /orders/confirm` 「서비스 어드민 권한」의 의미(앱 토큰으로 호출 가능한지).
8. **적립금 API 에 필요한 앱 권한(scope) 명칭**과 후니 플랜(스탠다드/프로/엔터프라이즈)별 사용 가능 여부.
9. **「외부적립금 연동」 모드**(`GET /accumulations/externals`, `EXTERNAL_ACCUMULATION`, `mappingKey`)의 계약 — 후니가 원장을 직접 보유하는 대안이 될 수 있으나 문서 없음.
10. **`POINT: 포인트결제`** 의 정체(몰 적립금과 별개인지), **`POST /oauth/token`(client_credentials)** 로 장기 토큰을 대체할 수 있는지.
11. **에러코드 전체 목록**(`A0002`, `A0034` 외).
12. 외부 가이드 페이지(`docs.shopby.co.kr/guide`, `server-docs.shopby.co.kr/guide`, `workspace.godo.co.kr/guide/...`)는 JS 렌더링이라 본문 미확인 — 브라우저(gstack/ego-browser)로 재조사 필요.
