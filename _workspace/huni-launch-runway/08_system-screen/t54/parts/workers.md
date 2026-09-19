# MES 무인 작업자(BackOffice.Console) 13개 원장

조사 대상 저장소: `/Users/innojini/Dev/TS.BackOffice.Huni` (읽기전용 실독).
아래 모든 `path:line` 은 저장소 루트 기준 상대경로이며 `grep -n` / `sed -n` 으로 실제 확인한 줄번호다.
구현 근거는 `.cs` / `.csproj` / `.config` 파일만 사용했다(문서 인용 시 "문서 주장"이라고 명시).

**[주의] `CRT.EasyMES.V2.Console.MotionOneInterface` 는 다른 레인 담당이라 1줄 요약만 있다.**

---

## 1. 요약 표 (13개)

| # | 작업자 | ① 입력 | ② 기동 방식 | ③ 처리 | ④ 호출 프로시저/DB 진입점 | ⑤ 상태 회신(push-back) |
|---|---|---|---|---|---|---|
| 1 | `CRT.EasyMES.V2.Console.Cafe24Interface` | SQS. 설정키 `QUEUE_URL` (`BackOffice.Console/CRT.EasyMES.V2.Console.Cafe24Interface/Program.cs:95`) → `sqsClient.GetMessagesAsync<OrderWebhookPayload>` (`:128`). 보조로 Cafe24 Admin API GET 주문조회(`:587`) | 1회 실행 후 종료(스케줄러). `Main` 에 while/서비스호스트 없음 (`:46`~`:178`). 인자 있으면 JSON 파일 재처리 모드(`:169`~`:174`). **중복실행 가드 없음** | 카페24 주문 웹훅(SQS) 수신 → 주문 조회 → MES 주문 생성/취소 반영 | `OrderBiz.COrderByExcel` (`:427`) → `USP_ORD_EXL_IMPORT_C`(`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:339`), `USP_ORD_ORDER_EXCEL_C`(`:439`), `USP_ORD_ORDER_DTL_EXCEL_C`(`:597`), `USP_ORD_ORDER_FILES_C`(`:1020`), `USP_DLV_PACKAGE_CU`(`Dac/DeliveryDac.cs:153`), `USP_DLV_PACKAGE_DTL_C`(`:167`) / `DeliveryBiz.CPackageDetailBundlingWithMarketOrdItemNo`(`Program.cs:453`) → `USP_DLV_PACKAGE_DTL_BUNDLING_WITH_MARKET_ORD_ITEM_NO`(`Dac/DeliveryDac.cs:307`) / `OrderBiz.CancelOrderByMarketOrdNo`(`Program.cs:558`) → `USP_ORD_ORDER_CANCEL_BY_USR_ORD_CD`(`Dac/OrderDac.cs:253`) / `CustomerBiz.GetCustomer`(`Program.cs:615`) → `USP_CUS_CUST_S`(`Dac/CustomerDac.cs:52`) | **없음(수신 전용).** 이 앱은 Cafe24 로 GET 조회만 한다(`Program.cs:587`). 상태 회신은 아래 `.Update` 가 담당 |
| 2 | `CRT.EasyMES.V2.Console.Cafe24Interface.Token` | 없음(큐·웹훅 아님). 설정값 + DB 토큰 저장소. 설정키 `CMPNY_CD/CAFE24_MALL_ID/CAFE24_CLIENT_ID/CAFE24_CLIENT_SEC_ID/CAFE24_REDIRECT_URI` (`.../Cafe24Interface.Token/Program.cs:17`~`:21`), 인자로 authorization code 수용(`:54`~`:57`) | 1회 실행 후 종료(스케줄러). `Main` 에 루프 없음(`:23`~`:83`). **중복실행 가드 없음** | Cafe24 OAuth 액세스 토큰 발급/갱신 후 DB 저장 | `DbTokenStore.Load/Save`(`.../Cafe24Interface.Token/Common/DbTokenStore.cs:29`, `:57`) → `TokenBiz.GetCafe24Token`/`CUCafe24Token` → `USP_IF_CAFE24_TOKEN_S`(`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/TokenDac.cs:24`), `USP_IF_CAFE24_TOKEN_CU`(`:37`) | **없음.** 외부 호출은 Cafe24 `/api/v2/oauth/token` POST(`.../Cafe24Interface.Token/Common/Cafe24AuthClient.cs:51`, `:72`) — 토큰 발급이지 상태 회신이 아님 |
| 3 | `CRT.EasyMES.V2.Console.Cafe24Interface.Update` | **DB 폴링**(큐 아님). 설정 파일에 `QUEUE_URL` 없음. 대상 조회 = `OrderBiz.GetOrderDetailForCafe24Prepare`(`.../Cafe24Interface.Update/Program.cs:129`), `DeliveryBiz.GetOrderDetailForDeliveryReadyInterface2`(`:239`) | 1회 실행 후 종료. 인자로 모드 분기: 무인자 또는 `READY`(`:93`), `SHIPPING`(`:99`). **중복실행 가드 없음** | MES 상태를 카페24로 밀어 올림: 배송준비중 상태변경 + 송장(배송정보) 등록 | `USP_IF_MARKET_STATUS_PREPARE_S`(`Dac/OrderDac.cs:105`), `USP_IF_MARKET_STATUS_PREPARE_U`(`:119`, 호출 `Program.cs:207`), `USP_IF_DELIVER_READY_S2`(`Dac/DeliveryDac.cs:336`), `USP_IF_DELIVER_READY_U2`(`:365`, 호출 `Program.cs:320`·`:354`) | **있음.** Cafe24 Admin API — 주문 상태변경 `PUT /api/v2/admin/orders`(`Program.cs:385`, 메서드 `UpdateCafe24OrderStatusToReady` `:378`), 송장 등록 `POST /api/v2/admin/shipments`(`:300`) |
| 4 | `CRT.EasyMES.V2.Console.ItfLogConsumer` | SQS. 설정키 `QUEUE_URL`(`.../ItfLogConsumer/ItfLogService.cs:50`) → long polling 20초 수신(`:127`) | **상주 서비스.** Topshelf 호스트(`.../ItfLogConsumer/Program.cs:41`~`:62`), 내부 `while` 폴링 루프(`ItfLogService.cs:121`). 서비스 복구 재시작 설정(`Program.cs:58`~`:61`). 중복실행 가드는 Windows 서비스 등록 자체(`SERVICE_NAME` `Program.cs:37`) | 각 연동 앱의 ItfTrace 로그 메시지를 최대 10건씩 받아 한 트랜잭션으로 일괄 저장 | `LogBiz.CItfTraceBatch`(`ItfLogService.cs:157`) / `LogBiz.CItfTrace`(`:180`) → `USP_LOG_ITF_TRACE_C`(`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/LogDac.cs:39`) | **없음**(내부 로그 소비자) |
| 5 | `CRT.EasyMES.V2.Console.MotionOneInterface` | SQS. 설정키 `AWS_QUEUE_URL`(`.../MotionOneInterface/Program.cs:36`) → `GetMessagesAsync<EdicusRenderInfo>`(`:107`). 기동 = 무인자 1회 실행(`:46` Main, `:102` `args.Length == 0`). **(다른 레인 담당 — 이 이상 파지 않음)** | — | — | — | — |
| 6 | `CRT.EasyMES.V2.Console.SWOrderInterface` | **외부 API 폴링**(큐 아님, 설정에 `QUEUE_URL` 없음). 성원 파트너 API `partner.adpiamall.com/api/outsourcing.php?action=findList` 페이지 루프(`.../SWOrderInterface/Program.cs:762`, 루프 `:759`) + 작지서 `action=orderbill`(`:785`). AWS 정보는 DB에서(`:104` `authBiz.GetAwsInfo`) | 1회 실행 후 종료. 인자 `WORK` 면 출고완료 처리 경로, 그 외 주문수집 경로(`:83`). **중복실행 가드 없음** | 성원(외주) 주문을 수집해 MES 주문으로 적재하고, 출고완료 건을 성원 사이트에 회신 | `OrderBiz.COrderByExcel`(`:324`, SP 체인은 #1과 동일), `DeliveryBiz.CPackageDetailBundlingWithUsrOrdCd`(`:349`) → `USP_DLV_PACKAGE_DTL_BUNDLING_WITH_USR_ORD_CD`(`Dac/DeliveryDac.cs:292`), `DeliveryBiz.GetOrderDetailForDeliveryReadyInterface`(`:409`) → `USP_IF_DELIVER_READY_S`(`Dac/DeliveryDac.cs:322`), `UOrderDetailForDeliveryReadyInterface`(`:635`) → `USP_IF_DELIVER_READY_U`(`Dac/DeliveryDac.cs:350`), `AuthBiz.GetAwsInfo`(`:104`) → `USP_SYS_AWS_INFO_S`(`Dac/AuthDac.cs:261`) | **있음.** 성원 API 호출로 상태 회신: `action=setStatus&type=view`(OTS30 외주확인, `:367`), `action=setStatus&type=work`(`:458`), 송장번호 `action=setInvoiceNo`(`:515`), 제품발송 `action=SendDelv`(`:532`) |
| 7 | `CRT.EasyMES.V2.DesignFileCopyToNas` | SQS(S3 EventBridge 메시지). 설정키 `QUEUE_URL`(`.../DesignFileCopyToNas/ThumbnailService.cs:58`) → `GetMessagesAsync<EventBridgeS3Message>`(`:163`) | 1회 실행 후 종료(스케줄러). `Program.cs:52`~`:62` — 무인자면 `DoOneTimeWork()` 1회, 인자면 JSON 파일 모드. Topshelf 를 using 하지만 호스트를 띄우지 않음. **중복실행 가드 없음** | S3 디자인 원본 파일을 받아 온프렘 NAS 대상 디렉터리로 복사 | **WCF 경유**(On-Prem, DB 직접접근 불가 — `Program.cs:22`): `OrderData.GetOrderDesignFiles`(`ThumbnailService.cs:250`, `:262`) → 서버측 `USP_ORD_ORDER_DESIGN_FILES_S`(`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:980`). 쓰기 DB 호출은 확인되지 않음(파일 복사만) | **없음** |
| 8 | `CRT.EasyMES.V2.DesignFileThumbnailCreator` | SQS(S3 EventBridge 메시지). 설정키 `QUEUE_URL`(`.../DesignFileThumbnailCreator/ThumbnailService.cs:81`) → `GetMessagesAsync<EventBridgeS3Message>`(`:214`) | 1회 실행 후 종료(스케줄러). `Program.cs:85`~`:95`. **중복실행 가드 있음 — 13개 중 유일**: `MAX_INSTANCES`(기본 3) 프로세스 카운트 가드(`Program.cs:39`~`:54`) | 디자인 원본에서 썸네일을 생성해 DB에 등록 | `OrderBiz.GetOrderFromS3Key`(`ThumbnailService.cs:353`) → `USP_ORD_ORDER_S3`(`Dac/OrderDac.cs:57`), `DeleteOrderThumbFilesByS3Key`(`:406`) → `USP_ORD_ORDER_FILES_THUMB_D`(`Dac/OrderDac.cs:1082`), `COrderThumbnail`(`:462`,`:521`,`:599`) → `USP_ORD_ORDER_THUMB_C`(`Dac/OrderDac.cs:1057`) | **없음** |
| 9 | `TS.BackOffice.SendData.ECount` | **DB 폴링**(수신 큐 없음; `QUEUE_URL` 은 *발신*용). 대상 조회 `OrderBiz.GetOrderForECount`(`.../SendData.ECount/Program.cs:46`) | 1회 실행 후 종료. `Main` 에 루프 없음(`Program.cs:39`~`:132`). **중복실행 가드 없음** | 접수완료·이카운트번호 없는 주문을 이카운트 ERP로 전송 → 받은 전표번호 DB 반영 → 우커머스 상태변경 명령을 SQS로 발행 → 슬랙 알림 | `USP_ORD_ORDER_FOR_ECOUNT_S`(`BackOffice.Console/TS.BackOffice.SendData.ECount/Database/Dac/OrderDac.cs:30`), `USP_ORD_ORDER_ECOUNT_ORDERCD_U`(`:40`, 호출 `Program.cs:95`) | **있음(간접).** 우커머스 주문상태 `DSG-READY` 갱신 명령을 FIFO SQS로 발행(`Program.cs:101`~`:108`, `SQS/SQSHelper.cs:14`·설정키 `QUEUE_URL` `:19`) → 실제 REST 호출은 #13 `CommandHandler` 가 수행. 이카운트 전송은 `POST /SaleOrder/SaveSaleOrder`(`Rest/ECountHelper.cs:98`), 슬랙 알림(`Program.cs:114`) |
| 10 | `TS.BackOffice.WebHookHandler.Monitor` | **파일시스템 폴링.** 설정키 `MONITOR_DIR`, `LIMIT_MINUTE`(`.../WebHookHandler.Monitor/Program.cs:14`~`:15`) → 날짜 폴더의 `*.json` 스캔(`:41`~`:44`), `Error` 폴더 스캔(`:71`~`:73`) | 1회 실행 후 종료(스케줄러). `Main` 에 루프 없음(`:29`~`:96`). **중복실행 가드 없음** | 웹훅 JSON 이 제한시간 내 처리되지 않았거나 Error 폴더에 남아 있으면 슬랙 알림 후 `Slack` 폴더로 이동(재알림 방지) | **DB 접근 없음**(프로젝트에 Database 디렉터리 자체가 없음) | **없음**(슬랙 알림만, `Program.cs:50`·`:79`, `SlackHelper.cs:25`) |
| 11 | `TS.BackOffice.WebHookHandler.WooCommerce` | SQS. 설정키 `QUEUE_URL`(`.../WebHookHandler.WooCommerce/WebHookService.cs:42`) → `sqsClient.Subscribe<WebHookMessage>`(`:83`). **HTTP 수신 리스너 없음** (웹훅은 앞단에서 큐로 적재됨) | **상주 서비스.** Topshelf 호스트(`.../WebHookHandler.WooCommerce/Program.cs:31`~`:54`), 서비스 복구 재시작(`:50`~`:53`). 중복실행 가드는 Windows 서비스 등록(`SERVICE_NAME` `Program.cs:27`) | 우커머스 주문/상품/고객 웹훅 메시지를 순차 처리해 MES DB에 적재 | `OrderBiz/ProductBiz/CustomerBiz.InsertWebHookMessage`(`WebHookService.cs:144`~`:161`) → `USP_ORD_ORDER_ITF_CU`(`Database/Dac/OrderDac.cs:64`), `USP_ORD_ORDER_ITF_D`(`:78`), `USP_ORD_ORDER_DTL_ITF_C`(`:120`), `USP_ORD_ORDER_DTL_ITF_D`(`:134`), `USP_ORD_ORDER_FILES_ITF_C`(`:151`), `USP_ORD_ORDER_FILES_ITF_D`(`:164`), `USP_ORD_ORDER_COUPON_ITF_C`(`:179`), `USP_ORD_ORDER_COUPON_ITF_D`(`:187`), `USP_CUS_CUST_CU2`(`Database/Dac/CustomerDac.cs:39`), `USP_CUS_CUST_D2`(`:50`), `USP_PRD_ITEM_ITF_S`(`Database/Dac/ProductDac.cs:62`), `USP_PRD_OPT_S`(`:81`), `USP_PRD_ITEM_MDL_BRANCH_OPT_S`(`:93`), `USP_COM_INTERFACE_HIST_C/U`(`Database/Dac/CommonDac.cs:40`·`:54`), `USP_COM_CMPNY_BRANCH_S`(`:75`), `USP_COM_CD_S`(`:113`) | **없음**(수신 전용) |
| 12 | `TS.BackOffice.WooCommerce.Command` | 해당 없음 — **실행 파일이 아님(클래스 라이브러리)** | 해당 없음 | SQS 명령 메시지의 DTO 정의(`BaseCommand.cs`, `UpdateStatusCmd.cs`, `UpdateTrackingCmd.cs`, `Enums.cs`). `Program.cs` 자체가 없음 | 없음 | 없음 |
| 13 | `TS.BackOffice.WooCommerce.CommandHandler` | SQS. 설정키 `QUEUE_URL`(`.../WooCommerce.CommandHandler/CommandService.cs:48`) → `sqsClient.Subscribe<BaseCommand>`(`:80`) | **상주 서비스.** Topshelf 호스트(`.../WooCommerce.CommandHandler/Program.cs:29`~`:51`), 서비스 복구 재시작(`:47`~`:50`). 중복실행 가드는 Windows 서비스 등록(`SERVICE_NAME` `Program.cs:25`) | SQS로 받은 명령을 우커머스 REST API 호출로 실행(주문상태 변경 / 송장) | `CommonDac.GetCompanyBranch`(`CommandService.cs:76`) → `USP_COM_CMPNY_BRANCH_S`(`Database/Dac/CommonDac.cs:36`), `OrderBiz.GetOrderBranch`(`CommandService.cs:229`) → `USP_ORD_ORDER_BRANCH_S`(`Database/Dac/OrderDac.cs:24`), `USP_COM_CD_S`(`Database/Dac/CommonDac.cs:74`) | **있음.** 우커머스 주문 상태 갱신 `wc.Order.UpdateWithNull(...)`(`CommandService.cs:198`, 메서드 `UpdateStatus` `:185`). **단, 송장 갱신 `UpdateTracking`(`:206`~`:214`) 은 분기 이름만 있고 본문이 비어 있다 — 호출해도 아무 것도 전송하지 않는다** |

---

## 2. 작업자별 세부 절

### 2.1 Cafe24 3종
- **Cafe24Interface (수신)**: SQS 메시지 1건씩 → `ItfTrace.SetContext(cafe24OrderId, sqsMsgId)`(`Program.cs:143`) → 원문 파일 저장(`:151`) → `DoWebHookJob`(`:155`) → 성공 시 `DeleteMessageQueue`(`:158`, 실제 삭제 `:567`). 이벤트 분기는 `CreateOrder` / `CancellationComplete` 만 처리하고 나머지는 no-op(`:184`~`:199`).
- **Cafe24Interface.Token**: 토큰만 다룬다. 실패해도 예외를 잡아 `ItfTrace.Fail("TOKEN_REFRESH", ...)` 로 남기고 종료(`Program.cs:77`~`:81`).
- **Cafe24Interface.Update (회신)**: 13개 중 카페24로 상태를 밀어 올리는 유일한 앱. HTTP 422(이미 변경된 상태)를 SKIP 으로 흡수하는 분기가 양쪽 경로에 있다(`Program.cs:181`, `:349`).

### 2.2 ItfLogConsumer
Topshelf 상주 서비스이며, 인자가 `.json` 파일이면 SQS 없이 DB 저장만 태우는 로컬 검증 모드로 빠진다(`Program.cs:32`~`:35`, `:69`~`:95`). 폴링 루프는 취소토큰 기반(`ItfLogService.cs:121`), 폴링 예외 시 5초 후 재시도(`:143`~`:145`).

### 2.3 SWOrderInterface
- 인증: 성원 파트너 사이트 로그인 쿠키(`OS_LOGIN_INFO`)를 **소스에 상수로 하드코딩**해 쿠키 컨테이너에 주입한다 — 위치 `BackOffice.Console/CRT.EasyMES.V2.Console.SWOrderInterface/Program.cs:46`(상수 선언), `:52`(쿠키 주입). (값은 전사하지 않음. 설정 파일이 아니라 소스에 있다는 점이 특이사항.)
- 페이지 루프 `while (true)`(`:759`)는 상주 루프가 아니라 페이징 루프이며, 조회 실패 시 `break` 로 무한 재조회를 막는다(`:768`~`:770`).

### 2.4 디자인파일 2종
- `DesignFileCopyToNas` 는 On-Prem 이라 DB 직접접근이 불가해 **WCF(Log.svc / Order.svc) 경유**로 동작한다(`Program.cs:22`~`:24`).
- `DesignFileThumbnailCreator` 는 VPC 앱이라 DB 직접 sink 를 쓴다(`Program.cs:56`~`:58`). 콘솔창 포커스 탈취 방지를 위해 `ShowWindow(SW_SHOWMINNOACTIVE)` 를 호출한다(`Program.cs:28`~`:32`).

### 2.5 ECount / Monitor / WooCommerce 3종
- `SendData.ECount` 는 MES → ECount → (SQS) → 우커머스 로 이어지는 체인의 시작점이다. 다만 `Program.cs:48` 의 조건문이 `if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count > 0)` 형태라, **null/빈 결과 가드와 "건수 > 0" 조건이 같은 `||` 로 묶여 있다** — 정상 경로 판정이 뒤집혀 있고 `ds == null` 일 때 바로 뒤 `:50` 에서 `ds.Tables[0]` 를 평가한다(근거: `Program.cs:48`·`:50`).
- `WebHookHandler.Monitor` 는 DB를 전혀 쓰지 않는 파일 감시자다.
- `WooCommerce.Command` 는 §3.1 참조 — 라이브러리.

---

## 3. 추가 질문에 대한 답

### 3.1 실행 파일이 아닌 것
**`TS.BackOffice.WooCommerce.Command` 하나뿐이다.**
- 근거: `BackOffice.Console/TS.BackOffice.WooCommerce.Command/TS.BackOffice.WooCommerce.Command.csproj:8` 이 `<OutputType>Library</OutputType>`. 나머지 12개는 모두 각 `.csproj:8` 이 `<OutputType>Exe</OutputType>`.
- 보조 근거: 이 디렉터리에만 `Program.cs` 가 없다(`BaseCommand.cs`, `UpdateStatusCmd.cs`, `UpdateTrackingCmd.cs`, `Enums.cs` 만 존재).

### 3.2 중앙 로깅 `ItfTrace` 의 경로와 소비자
- 구현: `BackOffice.Server/CRT.EasyMES.V2.Data/Logging/ItfTrace.cs:21`(정적 클래스). 앱 이름 상수는 `:24`~`:33`(`Apps.Cafe24Interface` 등 7개).
- 기록 경로(sink)는 3가지이며 `ItfTrace.cs:46`~`:51` 주석·필드에 명시:
  1. 기본 = DB 직접(`LogBiz`) — VPC 앱,
  2. WCF(`Log.svc`) — On-Prem 앱. `DesignFileCopyToNas` 가 `ItfTrace.UseSink(dto => new LogData().CItfTrace(dto))` 로 주입(`BackOffice.Console/CRT.EasyMES.V2.DesignFileCopyToNas/Program.cs:24`),
  3. SQS 로그 큐(`SqsLogSink`, 구현 `Framework/CRT.Framework.AWS/SqsLogSink.cs`) — 설정키 `ITF_LOG_QUEUE_URL` 이 있을 때만 켜진다. 주입 코드가 6개 앱에 동일 패턴으로 존재: `Cafe24Interface/Program.cs:64`, `Cafe24Interface.Token/Program.cs:41`, `Cafe24Interface.Update/Program.cs:67`, `SWOrderInterface/Program.cs:73`, `DesignFileCopyToNas/Program.cs:38`, `DesignFileThumbnailCreator/Program.cs:71`.
- **소비자 = `CRT.EasyMES.V2.Console.ItfLogConsumer`**. SQS 로그 큐를 폴링해(`ItfLogService.cs:127`) `LogBiz.CItfTraceBatch`(`:157`)로 일괄 저장하며, 최종 저장 프로시저는 `USP_LOG_ITF_TRACE_C`(`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/LogDac.cs:39`), 대상 테이블은 `T_LOG_ITF_TRACE`(`BackOffice.Console/CRT.EasyMES.V2.Console.ItfLogConsumer/Program.cs:16` 주석, `BackOffice.Server/CRT.EasyMES.V2.Web/Log.svc.cs:14` 주석).
- 그 외 소비자: 저장된 로그를 **읽는** 코드는 `.cs` 에서 발견되지 않았다. 읽기는 저장소 내 운영 도구/문서 쪽에만 있다 — `.claude/commands/trace-order.md`, `docs/sql/T_LOG_ITF_TRACE.sql`, `docs/report/DAILY-LOG-REPORT.md`(문서/스크립트 주장이며 구현 증거 아님).
- AWS 키 해석은 공통 헬퍼 `AwsInfoResolver.Resolve`(`BackOffice.Server/CRT.EasyMES.V2.Data/Logging/AwsInfoResolver.cs:20`): DB(`USP_SYS_AWS_INFO_S` → `Dac/AuthDac.cs:261`) 우선, 실패 시 설정키 `AWS_KEY`/`AWS_SECRET_KEY`/`AWS_REGION` 폴백(`AwsInfoResolver.cs:52`~`:54`).

### 3.3 재시도 / 격리(DLQ) 처리 유무

**코드에 재시도·DLQ 인지 로직이 있는 작업자**

| 작업자 | 근거 |
|---|---|
| `ItfLogConsumer` | 일괄 저장 실패 → 개별 저장 폴백(`ItfLogService.cs:174`~`:191`), 개별 저장도 실패하면 **삭제하지 않아** visibility timeout 후 재수신 → `maxReceiveCount` 초과 시 DLQ(`:187`). 폴링 예외 5초 백오프(`:143`~`:145`). 클래스 주석에도 명시(`:19`~`:22`) |
| `DesignFileThumbnailCreator` | DB 교착 전용 재시도 헬퍼 `ExecuteWithDeadlockRetry`(`ThumbnailService.cs:793`, 호출 `:462`·`:521`·`:599`). 적응형 visibility 백오프 + `maxReceiveCount 48` 예산 계산 주석(`:376`~`:382`). 영구 실패는 메시지를 삭제해 DLQ 무한루프를 끊음(`:330`, `:706`), 반복 시 `dlq-triage` 재복원 상한 언급(`:723`, `:820`) |
| `DesignFileCopyToNas` | DB에 파일정보가 아직 없으면 **삭제하지 않고 재전달로 재시도**(`ThumbnailService.cs:280`·`:285` 주석: "삭제하지 말고 Invisible 메시지가 다시 Visible 될 때 처리"), 상태 불일치 건도 삭제하지 않고 skip(`:294`·`:299`) |
| `MotionOneInterface` | DLQ 격리 전제 주석 2곳(`Program.cs:172`, `:371`) — (상세는 다른 레인) |
| `SWOrderInterface` | API 조회 실패 시 `break` 로 무한 재조회 차단(`Program.cs:768`~`:770`). SQS 가 아니므로 DLQ 개념 없음 |

**코드에 재시도·DLQ 로직이 없는 작업자**
- `Cafe24Interface`: 예외를 `ItfTrace.Fail` 후 `throw`(`Program.cs:203`~`:204`)하고, 성공 경로에서만 `DeleteMessageQueue`(`:158`) — 실패 시 미삭제로 자연 재전달은 되지만 **앱 내 재시도/DLQ 분기 코드는 없다**.
- `Cafe24Interface.Token`: catch 후 로그만(`Program.cs:77`~`:81`).
- `Cafe24Interface.Update`: 422 를 SKIP 처리하는 분기는 있으나(`:181`, `:349`) 재시도 루프·DLQ 없음.
- `WebHookHandler.WooCommerce`: 실패 시 파일을 Error 디렉터리로 옮기고 로그만 남긴다(`WebHookService.cs:179`~`:182`). 메시지는 삭제하지 않아 재전달되지만 재시도 카운터·DLQ 분기 코드는 없음. 예외적으로 `id < 12700` 인 구 테스트 주문은 삭제(`:171`~`:176`).
- `WooCommerce.CommandHandler`: 실패 시 Error 디렉터리 이동 + 슬랙 알림(`CommandService.cs:150`~`:159`). 재시도·DLQ 분기 없음.
- `SendData.ECount`: 실패 시 `throw new Exception(...)` 으로 프로세스 종료(`Program.cs:67`, `:74`, `:123`). 재시도 없음.
- `WebHookHandler.Monitor`: 알림 전용, 해당 없음.
- `WooCommerce.Command`: 라이브러리, 해당 없음.

### 3.4 작업자별 설정 키 이름 목록 (값 금지)

`App.config` 는 대부분 `ConfigurationFileName` 하나만 두고, 실제 키는 `FoxConfiguration.*.config` 에 있다(예: `BackOffice.Console/CRT.EasyMES.V2.Console.Cafe24Interface/App.config:7`).
아래는 각 설정 파일의 `<add name="...">` 전수이며, 주석 처리된 키는 `(주석)` 표시. 줄번호는 해당 설정 파일 기준. 값은 의도적으로 기재하지 않는다.

| 작업자 | 설정 파일 | 키 이름 |
|---|---|---|
| Cafe24Interface | `.../Cafe24Interface/FoxConfiguration.Cafe24Interface.config` | `WEBHOOK_MSG_LOG`(주석·:5), `CMPNY_CD`(:6), `BRANCH_CD`(:7), `CUST_CD`(:8), `CAFE24_MALL_ID`(:9), `CAFE24_CLIENT_ID`(:10), `CAFE24_CLIENT_SEC_ID`(:11), `USR_NM`(:13), `AWS_REGION`(:15), `AWS_KEY`(:16), `AWS_SECRET_KEY`(:17), `QUEUE_URL`(:18), `MAX_MESSAGE_AT_A_TIME`(:19), `ITF_LOG_QUEUE_URL`(주석·:22), `CAFE24_TOKEN_FILE_PATH`(주석·:25) |
| Cafe24Interface.Token | `.../Cafe24Interface.Token/FoxConfiguration.Cafe24Interface.Token.config` | `CMPNY_CD`(:4), `CAFE24_MALL_ID`(:5), `CAFE24_CLIENT_ID`(:6), `CAFE24_CLIENT_SEC_ID`(:7), `CAFE24_REDIRECT_URI`(:8), `CAFE24_AUTH_CODE`(주석·:9), `AWS_REGION`/`AWS_KEY`/`AWS_SECRET_KEY`/`ITF_LOG_QUEUE_URL`(모두 주석·:12~:15) |
| Cafe24Interface.Update | `.../Cafe24Interface.Update/FoxConfiguration.Cafe24Interface.Update.config` | `WEBHOOK_MSG_LOG`(주석·:5), `CMPNY_CD`(:6), `BRANCH_CD`(:7), `CUST_CD`(:8), `CAFE24_MALL_ID`(:9), `CAFE24_CLIENT_ID`(:10), `CAFE24_CLIENT_SEC_ID`(:11), `SHIPPING_COMPANY_CODE`(:12), `SHIPPING_COMPANY_CODE_VISIT`(:13), `USR_NM`(:14), `AWS_REGION`/`AWS_KEY`/`AWS_SECRET_KEY`/`ITF_LOG_QUEUE_URL`(모두 주석·:17~:20) |
| ItfLogConsumer | `.../ItfLogConsumer/FoxConfiguration.ItfLogConsumer.config` | `SERVICE_NAME`(:4), `DISPLAY_NAME`(:5), `DESCRIPTION`(:6), `AWS_REGION`(:11), `QUEUE_URL`(:12), `MAX_MESSAGE_AT_A_TIME`(:14) |
| MotionOneInterface | `.../MotionOneInterface/CRT.EasyMES.V2.Console.MotionOneInterface.config` | `WEBHOOK_MSG_LOG`(주석·:5), `CMPNY_CD`(:6), `BRANCH_CD`(:7), `CUST_CD`(:8), `USR_NM`(:10), `AWS_REGION`(:12), `AWS_KEY`(:13), `AWS_SECRET_KEY`(:14), `AWS_QUEUE_URL`(:15), `MAX_MESSAGE_AT_A_TIME`(:16), `AWS_BUCKET`(:17) |
| SWOrderInterface | `.../SWOrderInterface/FoxConfiguration.SWOrderInterface.config` | `WEBHOOK_MSG_LOG`(주석·:5), `CMPNY_CD`(:6), `BRANCH_CD`(:7), `CUST_CD`(:8), `USR_NM`(:9), `SW_CMPNY_ID`(:11), `SW_OUTSRC_STATUS`(:12), `DELIV_PARTNER_NO`(:14), `DELIV_PRICE`(:15), `AWS_REGION`/`AWS_KEY`/`AWS_SECRET_KEY`/`ITF_LOG_QUEUE_URL`(모두 주석·:18~:21) |
| DesignFileCopyToNas | `.../DesignFileCopyToNas/FoxConfiguration.DesignFileCopyToNas.config` | `SERVICE_NAME`(:4), `DISPLAY_NAME`(:5), `DESCRIPTION`(:6), `AWS_REGION`(:8), `AWS_KEY`(:9), `AWS_SECRET_KEY`(:10), `QUEUE_URL`(:11), `MAX_MESSAGE_AT_A_TIME`(:12), `ITF_LOG_QUEUE_URL`(주석·:15), `DOWNLOAD_STATUS`(:17), `TARGET_DIRECTORY`(:18), `WEBHOOK_MSG_LOG`(주석·:20), `CMPNY_CD`(:21), `USR_NM`(:22) |
| DesignFileThumbnailCreator | `.../DesignFileThumbnailCreator/FoxConfiguration.DesignFileThumbnailCreator.config` | `SERVICE_NAME`(:4), `DISPLAY_NAME`(:5), `DESCRIPTION`(:6), `AWS_REGION`(:8), `AWS_KEY`(:9), `AWS_SECRET_KEY`(:10), `QUEUE_URL`(:11), `MAX_MESSAGE_AT_A_TIME`(:12), `THUMB_MAX_FILE_SIZE`(:19), `MAX_INSTANCES`(:23), `ITF_LOG_QUEUE_URL`(주석·:26), `WEBHOOK_MSG_LOG`(주석·:28), `CMPNY_CD`(:29), `USR_NM`(:30), `THUMB_DPI`(:31), `THUMB_MAX_PIXEL`(:38) |
| SendData.ECount | `.../SendData.ECount/FoxConfiguration.SendData.ECount.config` | `CMPNY_CD`(:4), `ECOUNT_COM_CODE`(:5), `ECOUNT_LOGIN_ID`(:6), `ECOUNT_CERT_KEY`(:8), `ECOUNT_API_BASE_URL`(주석·:10 / 활성·:12), `SLACK_CHANNEL_ID`(:14), `SLACK_TOKEN`(:15), `AWS_REGION`(:17), `AWS_KEY`(:18), `AWS_SECRET_KEY`(:19), `QUEUE_URL`(:20), `MAX_MESSAGE_AT_A_TIME`(:21) |
| WebHookHandler.Monitor | `.../WebHookHandler.Monitor/App.config` (FoxConfiguration 파일 없음) | `SLACK_CHANNEL_ID`(:7), `SLACK_TOKEN`(:8), `LIMIT_MINUTE`(:9), `MONITOR_DIR`(:10) |
| WebHookHandler.WooCommerce | `.../WebHookHandler.WooCommerce/FoxConfiguration.WebHookHandler.WooCommerce.config` | `SERVICE_NAME`(:4), `DISPLAY_NAME`(:5), `DESCRIPTION`(:6), `AWS_REGION`(:8), `AWS_KEY`(:9), `AWS_SECRET_KEY`(:10), `QUEUE_URL`(:11), `MAX_MESSAGE_AT_A_TIME`(:12), `WEBHOOK_MSG_LOG`(:14), `CMPNY_CD`(:15) |
| WooCommerce.Command | `.../WooCommerce.Command/App.config` | `<add name=...>` 항목 없음(라이브러리) |
| WooCommerce.CommandHandler | `.../WooCommerce.CommandHandler/FoxConfiguration.WooCommerce.CommandHandler.config` | `SERVICE_NAME`(:4), `DISPLAY_NAME`(:5), `DESCRIPTION`(:6), `AWS_REGION`(:8), `AWS_KEY`(:9), `AWS_SECRET_KEY`(:10), `QUEUE_URL`(:11), `MAX_MESSAGE_AT_A_TIME`(:12), `COMMAND_MSG_LOG`(:14), `CMPNY_CD`(:15), `SLACK_CHANNEL_ID`(:17), `SLACK_TOKEN`(:19) |

> **보안 메모(위치만, 값 미기재)**: 위 `FoxConfiguration.*.config` 들에는 AWS 키·카페24 클라이언트 시크릿·슬랙 토큰·이카운트 인증키 값이 평문으로 들어 있고 git 에 추적되고 있다. 추가로 DB 연결문자열(계정/비밀번호 포함)이 같은 파일의 `<database><connectionStrings>` 절에 있다(예: `.../Cafe24Interface/FoxConfiguration.Cafe24Interface.config:34`). 성원 로그인 쿠키는 설정이 아니라 소스 상수다(`.../SWOrderInterface/Program.cs:46`).

---

## 4. 확인 못 한 것

1. **각 작업자의 실제 실행 주기.** "1회 실행 후 종료 = 스케줄러가 주기 실행"은 `Main` 에 루프가 없다는 코드 사실에서만 추론했다. Windows 작업 스케줄러 등록 내용(주기·트리거)은 저장소 코드에 없어 확인 불가. `DesignFileThumbnailCreator/Program.cs:35`~`:38` 주석이 "wscript 경유 스케줄러"를 언급하지만 이는 주석 주장이다.
2. **SQS 큐의 redrive(DLQ) 정책 실제 설정값.** 코드 주석은 `maxReceiveCount`/DLQ 를 전제하지만(`ItfLogService.cs:22`, `ThumbnailService.cs:382`), 실제 큐 속성은 AWS 콘솔 또는 `docs/aws/create-itf-log-queue.ps1`(스크립트, 구현 증거 아님) 밖에 없어 미확인. **ItfLogConsumer 로그 큐 외 나머지 큐의 DLQ 존재 여부는 확인하지 못했다.**
3. **`dlq-triage`(새벽 DLQ 복원) 의 구현체.** `ThumbnailService.cs:330`·`:723`·`:820` 주석이 언급하나 해당 실행체를 `BackOffice.Console` 13개 안에서 찾지 못했다 — 별도 스크립트/람다 가능성. 미확인.
4. **`DesignFileCopyToNas` 의 DB 쓰기 여부.** 읽기(`GetOrderDesignFiles`)만 확인했고 `ThumbnailService.cs` 434줄 전체를 정독하지 않아 쓰기 호출이 더 있는지는 단정하지 않는다.
5. **저장 프로시저 본문.** 모든 `USP_*` 는 호출 지점(문자열 리터럴)까지만 확인했고, SP 내부에서 어떤 테이블을 건드리는지는 이 저장소의 `.cs` 로 확인 불가.
6. **`MotionOneInterface` 의 처리·프로시저·회신.** 과제 지시에 따라 입력·기동만 확인하고 의도적으로 파지 않았다.
7. **`WebHookHandler.WooCommerce` 앞단의 HTTP 수신 주체.** 이 작업자는 SQS 소비자일 뿐이고, 우커머스 웹훅을 실제로 HTTP 로 받는 지점(API Gateway 등)은 `BackOffice.Console` 밖이라 미확인.
8. **`UpdateTracking` 미구현이 운영상 의도인지 결함인지.** 코드상 본문이 비어 있다는 사실만 확인했다(`CommandService.cs:206`~`:214`).
9. **`SendData.ECount` 의 `Program.cs:48` 조건식이 실제 운영에서 문제를 일으키는지.** 코드 형태만 지적했고 런타임 동작은 실행하지 않아 확인 불가.
