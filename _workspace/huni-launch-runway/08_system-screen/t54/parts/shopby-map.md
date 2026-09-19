# 샵바이 스펙 11개 엔드포인트 ↔ 사내 선례 1:1 매핑 (t54 과제 ④)

- 조사 대상 저장소: `/Users/innojini/Dev/TS.BackOffice.Huni` (후니프린팅 MES) — **읽기전용 실독**.
- 경로 표기: 저장소 루트 기준 상대경로. 줄번호는 `grep -n` / `sed -n` 으로 실제 확인한 값만 기재.
- 원칙: **문서는 구현 증거가 아니다.** `docs/api/shopby-integration-api.yaml` 은 설계 스펙이며, 구현 유무는 `.cs` grep 으로만 판정했다.

---

## 0. 직접 돌린 grep — 구현 0건 확인

t50 의 판정을 그대로 옮기지 않고 같은 grep 을 직접 재실행했다.

### 명령 1 — `.cs` 한정

```
$ cd /Users/innojini/Dev/TS.BackOffice.Huni
$ grep -rli "shopby" --include="*.cs" .
$ echo "count=$(grep -rli "shopby" --include="*.cs" . | wc -l | tr -d ' ')"
```

출력:

```
(파일 목록 없음 — 빈 출력)
count=0
```

> 주: 최초 시도에서 zsh 가 따옴표 없는 `--include=*.cs` 를 glob 으로 해석해 `no matches found` 로 실패했다. 따옴표를 씌운 위 명령이 유효한 실행이며, 결과는 **0건**이다.

### 명령 2 — 전 파일(확장자 무관)

```
$ grep -rli "shopby" . 2>/dev/null
```

출력:

```
docs/SWAGGER-TEST-GUIDE.md
docs/design/02-기본설계서-API연동.md
docs/design/01-기초설계서.md
docs/design/README.md
docs/design/diagrams/ERD.md
docs/design/03-상세설계서.md
docs/api/shopby-integration-api.yaml
```

**판정(직접 확인):** `shopby` 문자열은 저장소 전체에서 **문서 6개 + 스펙 yaml 1개 = 7개 파일에만** 존재한다.
`.cs` 구현 파일 **0건**. 즉 **샵바이 연동 구현 코드는 이 저장소에 존재하지 않는다.**
부수적으로 확인된 사실: `DATABASE-SCHEMA.md` 와 `api-simulator/` 는 히트 목록에 없다 → **DB 스키마 문서에도 샵바이 매핑 테이블 언급이 없고, 시뮬레이터에도 샵바이 목(mock)이 없다.**

---

## 1. 엔드포인트 전수 — 개수 직접 센 결과

### 경로 수

```
$ grep -n "^  /" docs/api/shopby-integration-api.yaml
43:  /products/sync:
91:  /products:
130:  /products/{shopbyId}:
160:  /products/{shopbyId}/mapping:
200:  /orders/receive:
235:  /orders:
286:  /orders/{shopbyOrderNo}:
316:  /inventory/push:
347:  /inventory/sync:
376:  /webhook:
413:  /webhook/events:
```

→ **경로 11개.**

### 오퍼레이션 수

```
$ grep -c "      operationId:" docs/api/shopby-integration-api.yaml
11
$ grep -n "operationId:" docs/api/shopby-integration-api.yaml
53:syncProducts   97:getProducts    136:getProductById  166:updateProductMapping
210:receiveOrder  241:getOrders     292:getOrderByNo    322:pushInventory
353:syncInventory 390:receiveWebhook 419:getWebhookEvents
```

→ **오퍼레이션 11개.** 경로마다 메서드가 정확히 1개씩이므로 경로 수 = 오퍼레이션 수 = **11**. t50 의 "11개" 는 맞다(직접 확인).

### 전수 표 (메서드·요약·핵심 스키마 필드)

| # | 메서드 · 경로 | yaml 줄 | 요약 | 인증(yaml) | 요청/응답 핵심 필드 |
|---|---|---|---|---|---|
| 1 | POST `/products/sync` | 43–89 | 상품 동기화(full/incremental) | bearerAuth (55) | req `ProductSyncRequest`: `syncMode`(enum full/incremental, 필수), `productCodes[]` (569–587) / res `syncedCount`,`failedCount`,`errors[]` (589–607) |
| 2 | GET `/products` | 91–128 | 연동 상품 매핑 목록 | bearerAuth (99) | query `shopbyProductId`,`localProductCode`,`status`,`page`,`size` (101–117) / res `ProductMappingListResponse` (698) |
| 3 | GET `/products/{shopbyId}` | 130–158 | 매핑 상세 + 동기화 이력 | bearerAuth (138) | path `shopbyId` / res `ProductMappingDetailResponse`(708) + `SyncHistoryEntry`(724) |
| 4 | PUT `/products/{shopbyId}/mapping` | 160–198 | 상품 매핑 수정 | bearerAuth (168) | req `localProductCode`,`priceMapping`,`stockSyncEnabled` (748–758) / res `ProductMapping`(636) |
| 5 | POST `/orders/receive` | 200–233 | **주문 수신(웹훅)** | **webhookSignature** (212) | req `ShopbyOrderPayload`: 필수 `orderNo`,`orderDate`,`orderer`,`items`; 외 `receiver`,`paymentInfo`,`memo` (769–797). item = `productId`,`optionId`,`quantity`,`price`,`totalPrice` (825–843) |
| 6 | GET `/orders` | 235–284 | 수신 주문 목록 | bearerAuth (243) | query `shopbyOrderNo`,`localOrderCode`,`status`,`fromDate`,`toDate`,`page`,`size` (245–273) |
| 7 | GET `/orders/{shopbyOrderNo}` | 286–314 | 주문 상세 | bearerAuth (294) | path `shopbyOrderNo` / res `ShopbyOrderDetailResponse`(940) + `OrderStatusHistory`(964) |
| 8 | POST `/inventory/push` | 316–345 | **로컬 재고 → Shopby 전송** | bearerAuth (324) | req `productMappings[]`(필수) = `shopbyProductId`(필수),`localProductCode`,`quantity`(필수, min 0),`optionId` (978–1006) |
| 9 | POST `/inventory/sync` | 347–374 | **재고 양방향 동기화** | bearerAuth (355) | req `productCodes[]`, `direction`(enum both/local_to_shopby/shopby_to_local, default both) (1037–1052) |
| 10 | POST `/webhook` | 376–411 | **이벤트 웹훅 수신**(ORDER_CREATED/PAID/CANCELLED, PRODUCT_UPDATED, STOCK_CHANGED) | **webhookSignature** (392) | req `WebhookPayload`: 필수 `eventType`,`payload`(free-form),`signature`(HMAC-SHA256), `timestamp` (1087–1106) |
| 11 | GET `/webhook/events` | 413–458 | 웹훅 이벤트 로그 조회 | bearerAuth (421) | query `eventType`,`status`,`fromDate`,`toDate`,`page`,`size` (423–446) |

---

## 2. 방향(direction) · 서버/클라이언트 — yaml 근거

`servers` 블록(`docs/api/shopby-integration-api.yaml:24–30`)의 base URL 은
`https://api.huniprinting.com/api/integration/shopby` 다. **이 yaml 이 정의하는 11개 API 는 전부 후니 측(MES/백오피스)이 "서버"로서 제공하는 엔드포인트다.** 샵바이가 제공하는 API 스펙이 아니다.

다만 **HTTP 호출 방향과 업무 데이터 방향은 별개**이므로 둘 다 적는다.

| # | 엔드포인트 | HTTP 호출자(client) → 수신자(server) | 업무 데이터 방향 | 근거 줄 |
|---|---|---|---|---|
| 1 | POST /products/sync | 후니 내부(운영 UI/스케줄러) → **MES 서버**. 처리 중 MES 가 **샵바이 API 클라이언트**가 되어 상품을 끌어온다 | shopby → mes (pull) | 49 "Shopby 상품 데이터를 로컬 시스템과 동기화" |
| 2 | GET /products | 후니 내부 → MES 서버 | 로컬 DB 읽기(외부 호출 없음) | 96 |
| 3 | GET /products/{shopbyId} | 후니 내부 → MES 서버 | 로컬 DB 읽기 | 135 |
| 4 | PUT /products/{shopbyId}/mapping | 후니 내부 → MES 서버 | 로컬 DB 쓰기 | 165 |
| 5 | POST /orders/receive | **샵바이 → MES 서버** (샵바이가 클라이언트) | shopby → mes | 208 "이 엔드포인트는 Shopby 웹훅으로부터 호출됩니다" |
| 6 | GET /orders | 후니 내부 → MES 서버 | 로컬 DB 읽기 | 240 |
| 7 | GET /orders/{shopbyOrderNo} | 후니 내부 → MES 서버 | 로컬 DB 읽기 | 291 |
| 8 | POST /inventory/push | 후니 내부 → MES 서버. 처리 중 MES 가 **샵바이 API 클라이언트**가 되어 재고를 밀어넣는다 | **mes → shopby** | 321 "로컬 재고 정보를 Shopby로 전송합니다" |
| 9 | POST /inventory/sync | 후니 내부 → MES 서버. 처리 중 **양방향** 호출 | mes ↔ shopby | 352 "양방향으로 동기화", 1046–1051 `direction` enum |
| 10 | POST /webhook | **샵바이 → MES 서버** | shopby → mes | 382 "Shopby에서 발생한 이벤트 웹훅을 수신합니다" |
| 11 | GET /webhook/events | 후니 내부 → MES 서버 | 로컬 DB 읽기 | 418 |

요약: **MES 가 서버인 것 11/11**, 그중 **샵바이가 호출자인 인바운드 웹훅 2건**(#5, #10), **MES 가 샵바이 API 클라이언트로 아웃바운드 호출을 수행하는 것 3건**(#1 pull, #8 push, #9 양방향), 나머지 6건은 로컬 DB 조회/수정 전용이다.

---

## 3. 현행 사내 선례들의 인증 방식 — 실코드 확인

| 선례 | 인증 방식 | 근거 `path:line` |
|---|---|---|
| **카페24 (수집)** | OAuth2. `Basic` 헤더로 토큰 발급/갱신(`grant_type=authorization_code` / `refresh_token`), 이후 API 는 `Authorization: Bearer {access_token}` + `X-Cafe24-Api-Version` 헤더. 토큰은 **DB 저장소**(`DbTokenStore`)에서 로드 | `BackOffice.Console/CRT.EasyMES.V2.Console.Cafe24Interface.Token/Common/Cafe24AuthClient.cs:45` (Basic 헤더), `:51`,`:55` (authorization_code), `:70`,`:76`,`:77` (refresh_token), `:90` (`GetValidAccessTokenAsync` 만료 마진·재발급 분기) / `BackOffice.Console/CRT.EasyMES.V2.Console.Cafe24Interface/Program.cs:78–79` (DbTokenStore 로드), `:588–589` (Bearer 호출) |
| **카페24 (push-back)** | 동일 Bearer | `BackOffice.Console/CRT.EasyMES.V2.Console.Cafe24Interface.Update/Program.cs:301–303`, `:386–387` |
| **우커머스 (웹훅)** | **서명 검증 없음.** 웹훅을 HTTP 로 직접 받지 않고 **AWS SQS 큐를 구독**해 소비한다. 신뢰 판단은 `WebHookSourceUrl` → 지점코드 매핑으로만 한다 | `BackOffice.Console/TS.BackOffice.WebHookHandler.WooCommerce/WebHookService.cs:42` (QUEUE_URL), `:82–83` (`sqsClient.Subscribe<WebHookMessage>`), `:126` (SourceUrl 로 BranchCode 판정), `:129`/`:163` (DeleteMessage) |
| **SW(성원, 외주)** | **토큰 없음.** 쿠키 컨테이너 + 쿼리스트링 `company_id` 로 식별 | `BackOffice.Console/CRT.EasyMES.V2.Console.SWOrderInterface/Program.cs:48` (`_swCookieContainer`), `:938–947` (`CallSwApi`, CookieContainer 주입), `:762` (`...&company_id={huniCmpnyId}`) |
| **이카운트** | Zone 조회 → `OAPILogin` 으로 `SESSION_ID` 발급 → 이후 **쿼리스트링에 SESSION_ID** 를 실어 호출 | `BackOffice.Console/TS.BackOffice.SendData.ECount/Rest/ECountHelper.cs:19`(Zone), `:50`,`:63–66`(OAPILogin/API_CERT_KEY), `:98`(`/SaleOrder/SaveSaleOrder?SESSION_ID=...`) |
| **MES 내부 API** | **자체 발급 JWT Bearer** (Issuer/Audience/Lifetime 검증, `SymmetricSecurityKey`), 엔드포인트에 `[Authorize]` | `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/Program.cs:119–137`, `:78–100`(Swagger Bearer 정의), `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/EndPoints/ProductionRecordEndPoints.cs:72` (`[Authorize]`) |

### 샵바이 스펙이 요구하는 인증과의 대조

- 스펙 요구: `bearerAuth` = **JWT Bearer** (`docs/api/shopby-integration-api.yaml:461–465`), `webhookSignature` = **`X-Webhook-Signature` 헤더의 HMAC-SHA256** (`:466–470`).
- **JWT Bearer 는 같다.** MES WebApi 가 이미 자체 JWT 발급·검증을 하고 있다(Program.cs:119–137) → 9개 bearerAuth 엔드포인트의 인증 층은 기존 배선 그대로 재사용 가능.
  - 단, 카페24의 Bearer 는 **남의 토큰을 받아 쓰는 클라이언트 측** Bearer 이고, 샵바이 스펙의 bearerAuth 는 **MES 가 검증하는 서버 측** Bearer 다. 방향이 반대다.
- **HMAC 서명 검증은 다르다(선례 없음).** 저장소 전체에서 HMAC 관련 코드는 단 한 곳:

  ```
  $ grep -rn "HMACSHA256\|X-Webhook-Signature\|ComputeHash\|signature" --include="*.cs" .
  BackOffice.Server/CRT.EasyMES.V2.Web/Delivery.svc.cs:347,349,357,359
  ```

  이것은 택배 API 호출 시 **아웃바운드로 서명을 "생성"** 하는 코드(`GenerateHmacHeader` / `ComputeHmacSha256`, `Delivery.svc.cs:337–365`)이며, **인바운드 요청의 서명을 "검증"하는 코드는 0건**이다. `X-Webhook-Signature` 문자열도 `.cs` 에 존재하지 않는다.
- **인바운드 HTTP 웹훅 수신 라우트 자체가 0건.** `grep -rn "webhook\|WebHook" --include="*.cs" BackOffice.WebApi BackOffice.Server` → 빈 출력. 현행 카페24/우커머스 웹훅은 전부 **외부에서 SQS 로 적재된 것을 콘솔 앱이 폴링/구독**하는 구조다(Cafe24Interface/Program.cs:126–128 `GetMessagesAsync`, WooCommerce/WebHookService.cs:82–83 `Subscribe`).

---

## 4. 11행 1:1 매핑표 — 엔드포인트 ↔ 가장 가까운 사내 선례

판정 기준(코드 사실): ① 호출 방향이 같은가 ② 인증 방식이 같은가 ③ 데이터 모양(엔티티·계약)이 같은가.
`복제` = 세 가지가 거의 일치해 대상만 바꾸면 됨 / `부분` = 뼈대는 있으나 ②③ 중 하나 이상이 달라 상당 부분 신규 / `신규` = 대응 선례 없음.

| # | 엔드포인트 | 가장 가까운 사내 선례 `path:line` | 그 선례가 하는 일 | 판정 | 판정 근거(코드 사실) |
|---|---|---|---|---|---|
| 1 | POST `/products/sync` | `BackOffice.Console/CRT.EasyMES.V2.Console.SWOrderInterface/Program.cs:746` (`GetOrders`) + `:762` 페이지 루프 URL / 인증형은 `BackOffice.Console/CRT.EasyMES.V2.Console.Cafe24Interface/Program.cs:578`,`:587–589` (`GetOrderInfo`, Bearer) | 외부 API 를 page/pageSize 로 반복 호출해 목록을 끌어와 로컬 DB 에 반영 | **부분** | ① 아웃바운드 pull 로 방향 같음 ② Bearer 호출 뼈대 있음 ③ **그러나 선례는 전부 "주문" 도메인이다. 어느 채널에 대해서도 상품 동기화를 하는 `.cs` 가 없다** — `syncMode` full/incremental 개념, `ProductMapping` 엔티티, `SyncError` 누적 응답 모두 대응 코드 없음 |
| 2 | GET `/products` | `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/EndPoints/ProductEndpoints.cs:57` (라우트) → `:346` (`GetProducts`, `[FromQuery] page/pageSize/필터`, `:356–357` 범위 보정, `:359` 리포지토리 `GetListAsync`, `:372–375` Total/CurrentPage 응답) | JWT 보호 minimal-API 페이징 목록 | **부분** | ① 방향 같음(MES 서버) ② 인증 같음(자체 JWT) ③ **대상 엔티티가 다르다.** `ProductMapping` 에 해당하는 모델/리포지토리가 없다(`grep -rli shopby --include=*.cs` = 0, DB 스키마 문서에도 없음) → 엔드포인트 형태는 그대로 베끼되 엔티티·리포지토리·DTO 는 신규 |
| 3 | GET `/products/{shopbyId}` | `BackOffice.WebApi/.../EndPoints/ProductEndpoints.cs:43` (라우트) → `:317` (`GetProductByCode`) | 코드 단건 조회, 미존재 시 404 | **부분** | ①② 같음 ③ 매핑 엔티티 + `SyncHistoryEntry`(yaml 724) 이력 테이블이 없다 |
| 4 | PUT `/products/{shopbyId}/mapping` | `BackOffice.WebApi/.../EndPoints/ProductEndpoints.cs:71` (라우트) → `:395` (`UpdateProduct`: `[FromBody] DTO` + `IValidator` 검증 `:404–412` + 404 처리 `:414–418`) | JWT 보호 단건 수정 + FluentValidation | **부분** | ①② 같음, 검증 파이프라인까지 그대로 재사용 가능 ③ `priceMapping`,`stockSyncEnabled` 를 담을 테이블·DTO·Validator 가 전무 |
| 5 | POST `/orders/receive` | `BackOffice.Console/CRT.EasyMES.V2.Console.Cafe24Interface/Program.cs:180` (`DoWebHookJob`) → `:216` (`DoCreateOrder`) / 우커머스 측 `BackOffice.Console/TS.BackOffice.WebHookHandler.WooCommerce/WebHookService.cs:113` (`DoWork`) → `Database/Biz/OrderBiz.cs:84` (`CreateUpdateOrder`), 상품 매칭 `Common/ProductItemFactory.cs:20`,`:38` (외부 라인아이템 → `ITEM_MDL_CD` 해석) | 외부 쇼핑몰 주문 이벤트를 받아 MES 주문/품목으로 생성 | **부분** | ③ **업무 로직(외부 주문 → MES 주문 변환, 옵션→품목 매칭)은 가장 두꺼운 선례가 있다.** 그러나 ① **수신 형태가 다르다**: 현행은 HTTP 수신이 아니라 SQS 구독/폴링(WebHookService.cs:82–83, Cafe24Interface/Program.cs:126–128) ② **인증이 다르다**: 현행은 서명 검증 없음, 스펙은 `X-Webhook-Signature` 필수(yaml:212, 466–470) → 수신 층은 신규, 변환 층은 재사용 |
| 6 | GET `/orders` | `BackOffice.WebApi/.../EndPoints/ProductEndpoints.cs:346` (페이징 목록 패턴) — 주문 도메인 쪽은 `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/EndPoints/OrderEndPoints.cs:14` 에 `GetJobOrderReport` **1개만** 존재 | 페이징 목록 조회 | **부분** | ①② 같음 ③ 조회 대상이 "샵바이에서 수신한 주문" 테이블인데 그 테이블/리포지토리가 없다. `OrderEndPoints.cs` 에는 목록 조회 선례조차 없어(라우트 1개) 다른 도메인(Product/Inventory)의 패턴을 빌려와야 한다 |
| 7 | GET `/orders/{shopbyOrderNo}` | `BackOffice.WebApi/.../EndPoints/ProductEndpoints.cs:317` (`GetProductByCode`) 단건 패턴 | 키 단건 조회 + 404 | **부분** | ①② 같음 ③ `ShopbyOrderDetailResponse`(yaml 940) + `OrderStatusHistory`(964) 에 해당하는 상태이력 저장소 없음 |
| 8 | POST `/inventory/push` | 아웃바운드 push 뼈대: `BackOffice.Console/CRT.EasyMES.V2.Console.Cafe24Interface.Update/Program.cs:295–306` (`POST /api/v2/admin/shipments`, Bearer, JSON 바디) 및 `:378–389` (`PUT /api/v2/admin/orders`) / `BackOffice.Console/TS.BackOffice.SendData.ECount/Rest/ECountHelper.cs:86` (`SaveSaleOrder`) — 재고 원장 쪽은 `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/EndPoints/InventoryEndpoints.cs:102`,`:118` | 로컬 상태를 외부 시스템으로 밀어넣는 REST 호출 / MES 내부 재고 조회 | **부분** | ① 방향 같음(mes→외부 push) ② Bearer 호출 뼈대 있음 ③ **"재고를 외부 채널로 push" 하는 코드는 0건**. 현행 push-back 은 전부 **주문상태·송장**이다(Update/Program.cs:279 `ShippingStatus.shipping`, `:314–322` 송장코드 DB 반영). 재고 원장(InventoryEndpoints)과 외부 push 코드가 서로 연결된 적이 없다 |
| 9 | POST `/inventory/sync` (양방향) | **대응 선례 없음.** 가장 가까운 것도 단방향뿐: pull = `SWOrderInterface/Program.cs:746`, push = `Cafe24Interface.Update/Program.cs:300` | — | **신규** | 저장소 내 모든 외부 연동은 **단방향 단일 목적** 콘솔 앱이다(수집 전용 / 갱신 전용으로 프로젝트가 아예 분리: `Cafe24Interface` vs `Cafe24Interface.Update`). `direction` enum(both/local_to_shopby/shopby_to_local, yaml:1046–1051) 같은 양방향 조정·충돌해소 로직에 대응하는 코드가 없다 |
| 10 | POST `/webhook` (HMAC 검증 인바운드) | **대응 선례 없음.** HMAC 코드는 `BackOffice.Server/CRT.EasyMES.V2.Web/Delivery.svc.cs:337` (`GenerateHmacHeader`), `:352–365` (`ComputeHmacSha256`) 단 한 곳 | 택배 API 호출용 **아웃바운드 서명 생성** | **신규** | ① **인바운드 HTTP 웹훅 수신 라우트가 저장소에 0건** (`grep -rn "webhook\|WebHook" --include="*.cs" BackOffice.WebApi BackOffice.Server` → 빈 출력) ② **서명 "검증" 코드 0건** — 있는 것은 생성뿐이고 방향이 반대다 ③ `eventType` 5종 디스패치(yaml:385–389) 대응 코드 없음. 해시 계산 유틸(`ComputeHmacSha256`)만 부품으로 가져다 쓸 수 있다 |
| 11 | GET `/webhook/events` | 적재 측: `BackOffice.Console/TS.BackOffice.WebHookHandler.WooCommerce/Database/Biz/OrderBiz.cs:29` (`InsertWebHookMessage`) — 수신 웹훅 메시지를 DB 에 남김 / 조회 측 페이징 패턴: `BackOffice.WebApi/.../EndPoints/ProductEndpoints.cs:346` | 수신 웹훅 원문 적재 / JWT 페이징 목록 | **부분** | ③ **"웹훅 메시지를 DB 에 남긴다"는 개념은 이미 있다**(OrderBiz.cs:29, 파일 저장도 Cafe24Interface/Program.cs:151 `orderMsg.Save`) ②① 같음. 다만 그 로그를 **조회하는 API 는 없고**, `WebhookEventStatus`(yaml 1128) 같은 처리상태 축도 현행 적재 테이블에 대응이 없다 |

### 분포

| 판정 | 건수 | 해당 # |
|---|---|---|
| 복제 | **0** | — |
| 부분 | **9** | 1, 2, 3, 4, 5, 6, 7, 8, 11 |
| 신규 | **2** | 9 (`/inventory/sync` 양방향), 10 (`/webhook` HMAC 인바운드) |

**"복제 0" 의 근거:** `복제` 는 "같은 모양의 코드가 이미 있어 대상만 바꾸면 되는 것" 이다. 11개 중 어느 것도 이 조건을 만족하지 못하는 이유는 공통적으로 **③ 데이터 모양**이다 — 샵바이 매핑 엔티티(`ProductMapping`, 수신 주문, 웹훅 이벤트 로그)가 `.cs` 에도 DB 스키마 문서에도 전혀 없음이 §0 grep 으로 확인됐다. 추가로 인바운드 2건(#5, #10)은 ①(수신 형태: HTTP vs SQS)과 ②(서명 검증 유무)까지 다르다.

---

## 5. 선례 없는 구간 (사내 어디에도 대응이 없는 것)

1. **인바운드 HTTP 웹훅 수신 자체** (#5, #10) — MES 는 지금까지 웹훅을 **직접 HTTP 로 받은 적이 없다**. 카페24·우커머스 모두 외부에서 SQS 에 적재된 것을 콘솔 앱이 꺼내 쓴다(`WebHookService.cs:82–83`, `Cafe24Interface/Program.cs:126–128`). 웹훅 수신용 라우트·미들웨어·중복수신(idempotency) 처리 선례 0건.
2. **인바운드 HMAC 서명 검증** (#5, #10) — `X-Webhook-Signature` 문자열 `.cs` 0건. HMAC 은 아웃바운드 생성만(`Delivery.svc.cs:337–365`).
3. **상품 동기화(product sync)** (#1, 부분적으로 #2~#4) — 어떤 채널에 대해서도 상품을 동기화하는 코드가 없다. 현행 연동은 전부 주문(+ 송장/상태) 도메인이다.
4. **외부 채널로의 재고 push** (#8) — 재고 원장은 MES 내부에 있으나(`InventoryEndpoints.cs:102` 등), 그것을 외부 쇼핑몰로 내보낸 선례 0건.
5. **양방향 동기화 / 충돌 해소** (#9) — 저장소의 모든 연동이 단방향 전용 앱으로 분리되어 있어 대응 없음.
6. **`/api/integration/*` 네임스페이스의 외부 연동용 서버 API 그룹** — 현행 WebApi 의 EndPoints 26개(`BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/EndPoints/`)는 전부 내부 업무용이며, 외부 채널 연동 전용 엔드포인트 그룹이 존재하지 않는다. `Controllers/` 에는 `HealthCheckController.cs` **1개뿐**이다(나머지는 minimal-API EndPoints 방식).

---

## 6. 확인 못 한 것 (미확인·가설로 남김)

1. **"로컬 상품/재고" 가 어느 DB 인지** — yaml 은 `localProductCode`/`local_to_shopby` 라고만 쓴다(569–587, 978–1006). 이것이 MES DB 인지 후니 라이브 Railway/webadmin DB 인지 **스펙에도 코드에도 근거가 없다.** 미확정.
2. **`docs/design/*.md` 4개 문서의 샵바이 서술 내용** — §0 grep 에서 히트했으나 본 과제는 구현 유무 판정이 목적이어서 정독하지 않았다. 설계 문서이므로 어차피 구현 증거는 아니다.
3. **`BackOffice.Server/CRT.EasyMES.V2.Web` (WCF) 전체** — `Delivery.svc.cs` 의 HMAC 부분만 확인했다. 이 레거시 WCF 계층에 다른 외부 연동 선례가 더 있는지 전수 조사하지 않았다.
4. **`CRT.EasyMES.V2.Console.MotionOneInterface`** — 과제에서 지정한 후보 선례 목록에 없어 열어보지 않았다. 또 다른 외부 연동 선례일 가능성이 있다.
5. **웹훅이 SQS 로 들어오기 전 단계(AWS API Gateway/Lambda 등)** — 이 저장소 밖에 있을 가능성이 크다. 따라서 "서명 검증이 사내 어디에도 없다" 는 **이 저장소 기준**의 사실이며, 인프라 계층에 존재할 가능성은 배제하지 못한다.
6. **`api-simulator/`, `DBSync/`, `DBUtils/`, `Framework/` 내부** — §0 전 파일 grep 에서 `shopby` 가 히트하지 않았다는 사실만 확인했고, 다른 이름의 유사 선례가 있는지는 조사하지 않았다.
7. **빌드·실행 검증 없음** — 과제 금지사항에 따라 빌드/실행을 하지 않았다. 모든 판정은 정적 실독 근거다.
