# 과제 ③ — `BackOffice.WebApi/` 주문 생성 경로·인증 코드 확정

- 대상 저장소: `/Users/innojini/Dev/TS.BackOffice.Huni` (읽기전용 실독)
- 이하 모든 `path:line` 은 **저장소 루트 상대경로**. 줄번호는 `grep -n` / `sed -n` 실측값.
- 문서(`docs/**`, `*.md`)는 "문서 주장"으로만 표기하고 구현 근거로 쓰지 않았다.

---

## 0. 한 줄 결론

`BackOffice.WebApi` 는 **솔루션에 포함되지 않은(빌드 대상 아님) 신규 재작성 API 스캐폴드**이고,
주문 생성 엔드포인트(`POST /api/{companyCode}/orders`)는 **인증이 걸려 있지 않으며**,
호출하는 저장 프로시저 `USP_T_ORD_ORDER_C` 는 **라이브 DB 스크립트에 존재하지 않는다**.
현행 카페24/우커머스 실적 주문은 **WebApi 가 아니라 SQS 웹훅 콘솔 작업자**로 들어온다.

---

## 1. 주문 관련 엔드포인트 전수

등록 지점은 전부 minimal API (`Program.cs` 에서 확장 메서드 호출).
`Program.cs:260` `app.ConfigureOrderCoreEndpoints();` / `Program.cs:265` `app.ConfigureOrderEndPoints();` /
`Program.cs:266` `app.ConfigureCrudOrderEndpoints();`

### 1-1. OrderCore (`/api/{companyCode}/orders` 그룹)

그룹 정의: `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/EndPoints/OrderCoreEndPoints.cs:27`
`var orderGroup = app.MapGroup("/api/{companyCode}/orders").WithTags("Order");`

| HTTP | 라우트 | 핸들러 | 등록 path:line | 인증 |
|---|---|---|---|---|
| GET | `/api/{companyCode}/orders` | `GetOrders` | `EndPoints/OrderCoreEndPoints.cs:31` | **없음** |
| GET | `/api/{companyCode}/orders/{orderCode}` | `GetOrderById` | `EndPoints/OrderCoreEndPoints.cs:45` | **없음** |
| POST | `/api/{companyCode}/orders` | `CreateOrder` | `EndPoints/OrderCoreEndPoints.cs:59` | **없음** |
| PUT | `/api/{companyCode}/orders/{orderCode}` | `UpdateOrder` | `EndPoints/OrderCoreEndPoints.cs:73` | **없음** |
| DELETE | `/api/{companyCode}/orders/{orderCode}` | `DeleteOrder` | `EndPoints/OrderCoreEndPoints.cs:88` | **없음** |
| PUT | `/api/{companyCode}/orders/{orderCode}/status` | `UpdateOrderStatus` | `EndPoints/OrderCoreEndPoints.cs:103` | **없음** |

핸들러 본체 시작 줄: `GetOrders`=125, `GetOrderById`=197, `CreateOrder`=266, `UpdateOrder`=342,
`DeleteOrder`=452, `UpdateOrderStatus`=522 (모두 `EndPoints/OrderCoreEndPoints.cs`).

> 주의: `Program.cs:39` 부근 Swagger 설명문은 주문 API 를 `/api/v1/orders` 로 안내하지만,
> 실제 코드의 마운트 경로는 `/api/{companyCode}/orders` 다(`EndPoints/OrderCoreEndPoints.cs:27`).
> Swagger 설명은 **문서 주장**이며 코드와 불일치.

### 1-2. 레거시/보조 주문 엔드포인트

| HTTP | 라우트 | 핸들러 | 등록 path:line | 인증 |
|---|---|---|---|---|
| GET | `/api/CrudOrder/GetAll` | `GetAll` | `EndPoints/CrudOrderEndPoints.cs:18` | `RequireAuthorization()` (`:20`) |
| GET | `/api/Order/GetJobOrderReport` | `GetJobOrderReport` | `EndPoints/OrderEndPoints.cs:14` | `RequireAuthorization()` (`:16`) |
| POST | `/api/estimations/{estimationCode}/convert-to-order` | `ConvertToOrder` | `EndPoints/EstimationEndpoints.cs:176` | 있음(파일 내 11 map / 11 RequireAuthorization) |
| GET | `/api/v1/statistics/orders/summary` | `GetOrdersSummary` | `EndPoints/StatisticsEndpoints.cs:45` | 있음 |
| GET | `/api/v1/statistics/orders/by-status` | `GetOrdersByStatus` | `EndPoints/StatisticsEndpoints.cs:66` | 있음 |
| GET | `/api/v1/statistics/orders/by-customer` | `GetOrdersByCustomer` | `EndPoints/StatisticsEndpoints.cs:84` | 있음 |
| GET | `/api/v1/statistics/orders/trends` | `GetOrderTrends` | `EndPoints/StatisticsEndpoints.cs:103` | 있음 |
| GET | `/api/deliveries/by-order/{orderCode}` | `GetDeliveriesByOrderCode` | `EndPoints/DeliveryEndpoints.cs:135` | 있음 |

작업지시(work-order)는 별개 도메인: `EndPoints/WorkOrderEndPoints.cs:25,33,41,49,58,67`.

---

## 2. `CrudOrder` vs `Order` vs `OrderCore` 의 차이

| 이름 | 성격 | 근거 path:line |
|---|---|---|
| **`CrudOrder`** | **빈 껍데기(stub) + 공식 deprecated**. 클래스에 `[Obsolete(...)]`, 리포지토리는 빈 컬렉션 반환 | `EndPoints/CrudOrderEndPoints.cs:13` `[Obsolete("Use OrderCoreEndpoints (/api/v1/orders) instead...")]` / `Repository/CrudOrderRepository.cs` 주석 `TAG-STUB: Placeholder for future implementation` 과 `GetAllAsync` 내 `// TODO: Implement actual query` → `Task.FromResult(Enumerable.Empty<dynamic>())` |
| **`Order`** | **주문 생성과 무관. 작업지시서 조회 전용 1개 엔드포인트**. 레거시 MES SP 를 그대로 호출 | `EndPoints/OrderEndPoints.cs:14` (GET `GetJobOrderReport`) / `Repository/OrderRepository.cs` → `_readDbConnection.QueryMultipleAsync("USP_ORD_JOBORDER_REPORT_S2", new { CMPNY_CD, CUST_ORD_CD_SEQ }, CommandType.StoredProcedure)` |
| **`OrderCore`** | **유일한 주문 CRUD 층. 신규 재작성(WCF 대체) 경로** | `EndPoints/OrderCoreEndPoints.cs:14-19` 주석 `TAG-ORDER-CORE-001: 주문 조회, 생성, 수정, 삭제, 상태 변경 기능`, `EndPoints/OrderCoreEndPoints.cs:59` `MapPost("", CreateOrder)` |

**판정**: WebApi 안에서 "주문 생성 경로"는 **`OrderCore` 하나뿐**이다(`EndPoints/OrderCoreEndPoints.cs:59` → `:266` `CreateOrder`).
`CrudOrder` 는 스텁, `Order` 는 조회 전용이다.

또한 `OrderCoreEndPoints.cs:59-68` 의 `WcfMappingAttribute` 메타데이터가 스스로
`ServiceName="IOrderService", MethodName="N/A", Source=WcfMappingSource.NEW,
Notes="New endpoint - WCF uses COrderByExcel for bulk import"` 라고 선언한다 —
**즉 레거시 MES 의 실제 주문 생성은 `COrderByExcel` 이고, 이 POST 는 대응 WCF 메서드가 없는 신규 설계임을 코드가 자인**한다(8번 항목과 연결).

---

## 3. 주문 생성 요청 본문의 필수 필드

DTO: `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/DTOs/Order/OrderCreateDto.cs`
실제 런타임 검증기: `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/Validators/OrderCreateValidator.cs`
(핸들러가 `await validator.ValidateAsync(request)` 로 FluentValidation 을 명시 호출 — `EndPoints/OrderCoreEndPoints.cs:279`)

### `OrderCreateDto`

| 속성 | 타입 | 필수 | DataAnnotation 근거 | FluentValidation 근거 |
|---|---|---|---|---|
| `CustomerId` | `string` (required) | **필수** | `DTOs/Order/OrderCreateDto.cs:21-23` (`[Required]`, `[StringLength(50)]`) | `Validators/OrderCreateValidator.cs:16-18` (`NotEmpty`, `MaximumLength(50)`) |
| `CustomerName` | `string` (required) | **필수** | `DTOs/Order/OrderCreateDto.cs:32-34` (`[Required]`, `[StringLength(200)]`) | `Validators/OrderCreateValidator.cs:20-22` (`NotEmpty`, `MaximumLength(**100**)`) |
| `DueDate` | `DateTime` | **필수** | `DTOs/Order/OrderCreateDto.cs:44-45` | `Validators/OrderCreateValidator.cs:24-25` (`GreaterThan(DateTime.Now)`) |
| `Notes` | `string?` | 선택 | `DTOs/Order/OrderCreateDto.cs:54-55` (`[StringLength(1000)]`, nullable) | `Validators/OrderCreateValidator.cs:27-29` (`When(!IsNullOrEmpty)`) |
| `Items` | `List<OrderItemCreateDto>` (required) | **필수·1건 이상** | `DTOs/Order/OrderCreateDto.cs:64-66` (`[Required]`, `[MinLength(1)]`) | `Validators/OrderCreateValidator.cs:31-32` (`NotEmpty`), `:34` `RuleForEach(...).SetValidator(new OrderItemCreateValidator())` |

### `OrderItemCreateDto`

| 속성 | 타입 | 필수 | DataAnnotation | FluentValidation |
|---|---|---|---|---|
| `ProductCode` | `string` (required) | **필수** | `DTOs/Order/OrderCreateDto.cs:85-87` | `Validators/OrderCreateValidator.cs:48-50` |
| `ProductName` | `string` (required) | **필수** | `DTOs/Order/OrderCreateDto.cs:96-98` (`StringLength(200)`) | `Validators/OrderCreateValidator.cs:52-54` (`MaximumLength(**100**)`) |
| `Quantity` | `int` | **필수, >0** | `DTOs/Order/OrderCreateDto.cs:108-110` (`[Range(1, int.MaxValue)]`) | `Validators/OrderCreateValidator.cs:56-57` (`GreaterThan(0)`) |
| `UnitPrice` | `decimal` | **필수** | `DTOs/Order/OrderCreateDto.cs:120-122` (`[Range(0, double.MaxValue)]` = **0 허용**) | `Validators/OrderCreateValidator.cs:59-60` (`GreaterThan(0)` = **0 불허**) |

### 불일치·결함 (코드 근거)

1. `CustomerName` / `ProductName` 길이 상한이 DTO 200 vs 검증기 100 으로 **불일치**
   (`DTOs/Order/OrderCreateDto.cs:33` vs `Validators/OrderCreateValidator.cs:22`;
   `DTOs/Order/OrderCreateDto.cs:97` vs `Validators/OrderCreateValidator.cs:54`).
   런타임은 검증기가 이기므로 실효 상한은 100.
2. `UnitPrice` 0 허용 여부도 DTO 와 검증기가 **반대**
   (`DTOs/Order/OrderCreateDto.cs:121` vs `Validators/OrderCreateValidator.cs:60`).
3. **외부 주문번호(마켓 주문번호) 필드가 DTO 에 아예 없다.** 6번(멱등성)의 직접 원인.
4. 회사코드는 본문이 아니라 라우트에서 받는다: `EndPoints/OrderCoreEndPoints.cs:270`
   `[FromRoute] string companyCode`. 그러나 `companyCode` 는 **로그 출력과 Location 헤더에만 쓰이고
   DB 파라미터로 전달되지 않는다**(`EndPoints/OrderCoreEndPoints.cs:317`, `:323`;
   `Repository/OrderCoreRepository.cs:39-51` 파라미터 목록에 회사코드 없음).
5. 헤더 `X-User-Id` 를 바인딩하지만(`EndPoints/OrderCoreEndPoints.cs:271`
   `[FromHeader(Name = "X-User-Id")] string? userId`) **본문에서 한 번도 사용되지 않는다**
   (`:274-332` 내 `userId` 사용처 없음).

---

## 4. 주문 생성이 최종적으로 호출하는 것

경로:
`EndPoints/OrderCoreEndPoints.cs:59` (MapPost)
→ `EndPoints/OrderCoreEndPoints.cs:266` `CreateOrder(...)`
→ `EndPoints/OrderCoreEndPoints.cs:291-313` 도메인 `Order` 조립 (주문코드 = `"ORD-" + Guid.NewGuid().ToString().Substring(0, 8)`, `EndPoints/OrderCoreEndPoints.cs:293`)
→ `EndPoints/OrderCoreEndPoints.cs:315` `await orderRepository.CreateAsync(order)`
→ `Repository/OrderCoreRepository.cs:35` `CreateAsync`
→ `Repository/OrderCoreRepository.cs:53-56`

```
var result = await _writeConnection.ExecuteAsync(
    "USP_T_ORD_ORDER_C",
    parameters,
    commandType: CommandType.StoredProcedure);
```

**최종 저장 프로시저 = `USP_T_ORD_ORDER_C`** (`Repository/OrderCoreRepository.cs:54`).

전달 파라미터(`Repository/OrderCoreRepository.cs:39-51`):
`OrderCode, CustomerId, CustomerName, OrderDate, DueDate, Status, TotalAmount, Notes, CreatedAt, IsActive`.

DI 등록: `Program.cs:196` `builder.Services.AddScoped<IOrderCoreRepository, OrderCoreRepository>();`
쓰기 커넥션 구현: `Program.cs:175` `AddScoped<IApplicationWriteDbConnection, ApplicationWriteDbConnection>()`,
연결문자열 키 `ConnectionStrings:DefaultConnection` (`Program.cs:173`).

### 4-1. 이 SP 는 저장소의 라이브 DB 스크립트에 존재하지 않는다

- `USP_T_ORD_ORDER_C` 문자열이 나오는 파일은 전 저장소에서 4개뿐이고, 모두 **호출측/테스터**다:
  `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/Repository/OrderCoreRepository.cs`,
  `sp-crud-tester/src/cli.ts`, `sp-crud-tester/src/data/ExistingDataFetcher.ts`,
  `sp-crud-tester/src/data/ExistingDataFetcher.test.ts`
  (`grep -rln "USP_T_ORD_ORDER_C" .` 결과).
- DB 정의 아티팩트(`ref/`, `docs/`, `DBSync/`, `DBUtils/`)에서 `USP_T_ORD_ORDER_C`,
  `USP_T_ORD_ORDER_R`, `USP_T_ORD_ORDER_L`, `USP_T_SAL_ESTIMATE_CONVERT_ORDER` 히트 **0건**.
  반면 레거시 경로의 `USP_ORD_ORDER_EXCEL_C` 는 `ref/db/huni-db-script.sql:19958` 에
  `CREATE PROCEDURE [dbo].[USP_ORD_ORDER_EXCEL_C]` 로 실재.
- 스키마도 어긋난다. 실제 테이블 `ref/db/huni-db-script.sql:831` `CREATE TABLE [dbo].[T_ORD_ORDER](`
  의 컬럼은 `ORD_CD`(832), `CUST_ORD_CD`(833), `USR_ORD_CD`(834), `CMPNY_CD`(835),
  `BRANCH_CD`(836), `CUST_CD`(841), `TOT_ORD_AMT`(856) … 형태인데,
  WebApi 가 넘기는 파라미터는 `OrderCode/CustomerId/CustomerName/...` 로 **명명 규칙 자체가 다르다**.

### 4-2. 주문 아이템은 저장되지 않는다

`EndPoints/OrderCoreEndPoints.cs:303-312` 에서 `order.Items` 를 채우지만,
`Repository/OrderCoreRepository.cs:39-51` 의 파라미터 객체에 `Items` 가 없고
`Repository/OrderCoreRepository.cs` 내에 주문상세를 쓰는 SP 호출도 없다
(`grep -n "USP_" Repository/OrderCoreRepository.cs` → `_C/_R/_L/_U/_STATUS_U/_D/_BY_STATUS_R/_BY_CUSTOMER_R/_BY_DATE_RANGE_R` 각 1회, 상세 SP 없음).
→ **헤더만 저장하고 라인아이템은 유실되는 구조**.

### 4-3. 참고 — 같은 리포지토리 내 raw SQL 혼용

`Repository/OrderCoreRepository.cs:113`
`"SELECT * FROM T_ORD_ORDER WHERE OrderId = @OrderId AND IsActive = 1"`
— 테이블명은 레거시(`T_ORD_ORDER`)인데 컬럼명은 신규 명명(`OrderId`, `IsActive`)이다.
실제 `T_ORD_ORDER` 에 그런 컬럼이 없으므로(`ref/db/huni-db-script.sql:832~` 참조) 이 쿼리는 성립하지 않는다.

---

## 5. 인증·인가

### 5-1. 방식 = JWT Bearer 단일. API Key 없음

- 스킴 등록: `Program.cs:114-137`.
  `Program.cs:114` `var jwtSettings = builder.Configuration.GetSection("JwtSettings").Get<JwtSettings>();`
  `Program.cs:119` `builder.Services.AddAuthentication(...)` → `AddJwtBearer`, 검증 파라미터
  (`ValidateIssuerSigningKey/ValidateIssuer/ValidateAudience/ValidateLifetime`, `ClockSkew = TimeSpan.Zero`).
- 파이프라인: `Program.cs:250` `app.UseAuthentication();`, `Program.cs:251` `app.UseAuthorization();`
- **API Key 미들웨어·헤더 검증·커스텀 미들웨어 없음**:
  `grep -rn "FallbackPolicy\|AddAuthorization\|DefaultPolicy\|ApiKey\|X-Api-Key\|X-API-KEY\|UseMiddleware" Program.cs EndPoints/ Common/ Services/`
  → **히트 0건**.
- Basic 인증 없음(같은 grep 및 `AddAuthentication` 등록이 JwtBearer 단독).

### 5-2. 키·자격증명의 출처 (값 전사 없음)

- JWT 서명키는 설정 섹션 `JwtSettings:SecretKey` 에서 읽는다
  (`Program.cs:114`, `Program.cs:117` `Encoding.ASCII.GetBytes(jwtSettings.SecretKey)`).
  바인딩 클래스 `Services/Authentication/JwtSettings.cs:12`(SecretKey), `:17`(Issuer), `:22`(Audience),
  `:27`(AccessTokenExpirationMinutes), `:32`(RefreshTokenExpirationDays).
  옵션 등록 `Program.cs:216` `builder.Services.Configure<JwtSettings>(builder.Configuration.GetSection("JwtSettings"));`
- 설정 실체 파일: `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/appsettings.json`.
  이 파일에 `JwtSettings/SecretKey`, `JwtSettings/Issuer`, `JwtSettings/Audience`,
  `ConnectionStrings/DefaultConnection`(키 구성: `Server`, `database`, `uid`, `pwd`, `Encrypt`),
  `AppSettings/HttpPort`, `AppSettings/HttpsPort`, `AppSettings/CMPNY_CD` 가 들어 있다.
  **DB 계정/비밀번호와 JWT 서명키가 평문으로 이 파일에 존재**하며, `.gitignore` 에
  `appsettings` / `WebApi` 항목은 없다(`grep -n "appsettings\|WebApi" .gitignore` → 0건).
  ※ 과제 규칙에 따라 값은 전사하지 않는다. 위치만 기재.

### 5-3. 키 검증 로직이 무엇과 비교하는가

- **토큰 서명 검증**: `Program.cs:127-135` 의 `TokenValidationParameters` 가
  `jwtSettings.SecretKey` 로 만든 `SymmetricSecurityKey` 및 `jwtSettings.Issuer`/`jwtSettings.Audience` 와 대조.
- **로그인(토큰 발급) 검증**: DB 조회가 **아니라 소스에 하드코딩된 문자열 리터럴과 직접 비교**한다.
  `EndPoints/AuthEndPoints.cs:123` 주석 `// 샘플: 하드코딩된 사용자로 검증 (실제 구현에서는 DB 조회 필요)`
  `EndPoints/AuthEndPoints.cs:124` `if (request.Username != "…" || request.Password != "…") return Results.Unauthorized();`
  (값 전사 생략. 동일 자격증명이 `Program.cs:47-49` Swagger 설명문에도 평문으로 노출되어 있다.)
  발급은 `EndPoints/AuthEndPoints.cs:129-133` `jwtTokenService.GenerateAccessToken("admin-001", "admin", ...)` 로
  **고정 사용자 클레임**을 찍는다.
  → `IAuthRepository`/`AuthRepository` 는 DI 등록되어 있으나(`Program.cs:199`) 로그인 핸들러가 주입받지도 호출하지도 않는다
  (`EndPoints/AuthEndPoints.cs:106-109` 시그니처).

### 5-4. 익명 허용 엔드포인트 — 있다. 그것도 주문 생성 포함

`app.UseAuthorization()` 만 있고 `FallbackPolicy` 가 없으므로(§5-1 grep),
**`RequireAuthorization()` 이 붙지 않은 엔드포인트는 전부 익명 접근 가능**하다.
파일별 `Map*` 개수 대비 `RequireAuthorization` 개수 실측:

| 파일 | Map 수 | RequireAuthorization 수 | 판정 |
|---|---|---|---|
| `EndPoints/OrderCoreEndPoints.cs` | 6 | **0** | **전부 익명** ← 주문 CRUD 전체 |
| `EndPoints/CustomerEndPoints.cs` | 8 | **0** | **전부 익명** |
| `EndPoints/WcfMappingVerificationEndPoints.cs` | 4 | **0** | **전부 익명** |
| `EndPoints/AuthEndPoints.cs` | 4 | 1 | 로그인/갱신/로그아웃 익명(의도적), `/me` 만 보호(`:97`) |
| `EndPoints/AuthPasswordEndPoints.cs` | 3 | 1 | 2건 익명 |
| `EndPoints/ValidationEndPoints.cs` | 3 | 1 | 2건 익명 |
| 나머지 20개 파일 | — | Map 수와 동일 | 보호됨 |

그룹 단위 인증도 없다: `EndPoints/OrderCoreEndPoints.cs:27` 의 `MapGroup(...)` 체인은 `.WithTags("Order")` 뿐이다.

**결론: `POST /api/{companyCode}/orders` 는 인증 없이 호출 가능하다.**

### 5-5. 테스트는 이 사실을 가리고 있다

`BackOffice.WebApi/CRT.EasyMES.V2.Web.Api.Tests/EndPoints/OrderCoreEndpointsTests.cs:223`
`CreateOrder_WithoutAuthentication_ReturnsUnauthorized` 는 실제 HTTP 파이프라인을 태우지 않고
`SimulateCreateOrder(request, false, true, true)`(`:236`)라는 **테스트 내부 가짜 함수**를 호출해
`result.Message.Should().Contain("인증")`(`:240`)을 단언한다.
→ 이 테스트는 그린이어도 **실제 엔드포인트의 인증 여부를 증명하지 못한다**(위양성).

### 5-6. CORS

`Program.cs:149` `policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();` — 전면 개방.
적용 `Program.cs:245` `app.UseCors(allowOrigins);`.

---

## 6. 멱등성 — **없음**

같은 외부 주문번호로 두 번 호출하면 **주문이 두 건 생긴다**. 근거:

1. **요청 DTO 에 외부 주문번호 필드 자체가 없다** — `DTOs/Order/OrderCreateDto.cs:12-67` 전체 속성은
   `CustomerId, CustomerName, DueDate, Notes, Items` 뿐.
2. **주문코드는 매 호출 새 GUID 로 생성** — `EndPoints/OrderCoreEndPoints.cs:293`
   `OrderCode = "ORD-" + Guid.NewGuid().ToString().Substring(0, 8)`.
   즉 동일 입력이어도 매번 다른 키가 만들어진다.
3. **중복 검사·upsert·멱등키 코드 없음** — 돌린 grep 패턴(대상:
   `EndPoints/OrderCoreEndPoints.cs`, `Repository/OrderCoreRepository.cs`,
   `Repository/IOrderCoreRepository.cs`, `DTOs/Order/`, `Validators/OrderCreateValidator.cs`):
   `Idempot`, `idempot`, `Duplicate`, `duplicate`, `Exists`, `UNIQUE`, `Upsert`, `upsert`, `MERGE `,
   `ExternalOrder`, `X-Request-Id`, `RequestId`, `중복`
   → **전 패턴 히트 0건**.
4. `CreateAsync` 는 단순 `ExecuteAsync(... StoredProcedure)` 1회 — 선조회/조건분기 없음
   (`Repository/OrderCoreRepository.cs:35-67`).

### 6-1. 대조 — 레거시 경로에는 중복 방지 장치가 있다(WebApi 에는 없음)

- 외부 주문번호 기준 존재 검사 SP: `USP_ORD_EXISTS_USR_ORD_CD_S`
  (`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:452`, 래퍼 `:446`,
  Biz `BackOffice.Server/CRT.EasyMES.V2.Data/Biz/OrderBiz.cs:359,363`,
  WCF 노출 `BackOffice.Server/CRT.EasyMES.V2.Web/Order.svc.cs:150,154`).
- 호출처는 **WinForms 엑셀 임포트 화면 3곳뿐**:
  `BackOffice.UI/CRT.EasyMES.V2.Module.Order/FrmOrderExcelImportFuji.cs:588`,
  `.../FrmOrderExcelImportContinue.cs:564`, `.../FrmOrderExcelImportBizHows.cs:603`.
- **카페24 콘솔 경로에서는 호출하지 않는다**
  (`BackOffice.Console/CRT.EasyMES.V2.Console.Cafe24Interface/Program.cs` 에 `GetOrderExistsUsrOrdCd` 히트 0건).
- DB 유니크 제약도 외부 주문번호에는 없다. `T_ORD_ORDER` 의 유일한 UNIQUE 인덱스는
  `ref/db/huni-db-script.sql:3918-3921` `CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20250817-193656]
  ON [dbo].[T_ORD_ORDER] ( [CUST_ORD_CD] ASC )` — **내부 주문코드 `CUST_ORD_CD` 기준이며 외부번호 `USR_ORD_CD` 가 아니다**.
  (`USR_ORD_CD` 는 `ref/db/huni-db-script.sql:3895` 의 INCLUDE 컬럼으로만 등장.)
  SP 내부 주석은 `USR_ORD_CD` 가 유니크하길 기대하지만 테스트 DB에서는 중복이 존재한다고 스스로 적고 있다
  (`ref/db/huni-db-script.sql:8268`, `:8277`).
- 단, 카페24 취소 처리에는 의도적 멱등 주석이 있다
  (`BackOffice.Console/CRT.EasyMES.V2.Console.Cafe24Interface/Program.cs:469`
  "이미 취소된 주문을 다시 취소해도 결과가 같으므로(멱등)") — **취소만 멱등, 생성은 아니다**.

---

## 7. WebApi 가 실제로 배포·기동되는 증거

**결론: 저장소 안에서 배포·기동 증거를 찾지 못했다. 오히려 반증이 있다.**

| 확인 항목 | 결과 | 근거 |
|---|---|---|
| 호스팅 코드 | 있음(코드로서는 완전) | `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/Program.cs:306` `app.Urls.Add($"http://*:{httpPort}");`, `Program.cs:303` 기본 포트 8080, `Program.cs:322` `app.Run();` |
| **솔루션 포함 여부** | **미포함** | `TS.BackOffice.Huni.sln:102` 의 `"BackOffice.WebApi"` 항목은 프로젝트 GUID `{2150E333-8FDC-42A3-9474-1A3956D46DE8}` = **솔루션 폴더**이며 csproj 경로가 없다. `grep -n "Web.Api\|Web.Domain\|Web.Persistence" TS.BackOffice.Huni.sln` → **히트 0건**. 즉 `CRT.EasyMES.V2.Web.Api.csproj` 는 솔루션 빌드 대상이 아니다 |
| 별도 솔루션 파일 | **없음** | `ls BackOffice.WebApi/*.sln` → 없음. (단 `PROJECT-STRUCTURE.md:143` 는 `BackOffice.WebApi.sln` 이 있다고 **문서 주장** — 실재하지 않음) |
| Setup(설치 패키지) 포함 | **미포함** | `Setup/CRT.EasyMES.V2.Setup/CRT.EasyMES.V2.Setup.vdproj` 내 `Web.Api` 히트 **0건**. Setup 디렉터리 구성물은 `.vdproj`, `APP_LOGO.ico`, `WiRunSQL.vbs`, `FoxConfigurationApp.config` 뿐 |
| IIS 배포 산출물 | **없음** | 저장소 전체에서 `web.config` 는 레거시 WCF 서버 `BackOffice.Server/CRT.EasyMES.V2.Web/Web.config` 하나뿐. `Dockerfile`, `*.pubxml` **0건** |
| CI/CD | **없음** | 루트에 `.github` 없음, `find . -maxdepth 3 -name "*.yml"` → 0건 (`install.cmd` 는 Claude Code 설치 스크립트로 무관) |
| 개발 실행 프로필 | 로컬 전용 | `BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/Properties/launchSettings.json` — `http://localhost:5245`, IIS Express `http://localhost:1724`, 둘 다 `ASPNETCORE_ENVIRONMENT=Development` |
| 대조군(실제 배포되는 것) | 레거시 콘솔/서버는 솔루션에 정식 포함 | `TS.BackOffice.Huni.sln:100,104,106,108,110,114` (SWOrderInterface, Cafe24Interface×3, MotionOneInterface, ItfLogConsumer), `:90` (`CRT.EasyMES.V2.Web` = WCF) |

보조 정황: Swagger 는 환경 무관 상시 노출(`Program.cs:235-236` `app.UseSwagger(); app.UseSwaggerUI();`,
개발환경 분기는 `Program.cs:229-233` 에서 주석 처리됨) — 운영 배포를 전제한 설정이 아니다.

---

## 8. 외부 쇼핑몰 주문의 MES 진입 경로 — **콘솔 작업자(SQS 웹훅)**

### 판정

현행 카페24·우커머스 실적 주문은 **WebApi 를 거치지 않는다.**
**AWS SQS 큐를 폴링하는 .NET 콘솔 작업자**가 웹훅 메시지를 받아, 쇼핑몰 API 로 주문 상세를 조회한 뒤
레거시 Biz/Dac 층을 통해 저장 프로시저로 직접 적재한다.

### 카페24 경로 (근거 체인)

1. SQS 폴링 — `BackOffice.Console/CRT.EasyMES.V2.Console.Cafe24Interface/Program.cs:40` `static SqsClient sqsClient;`,
   `:120` `WriteLog(..., "SQS 데이타 불러오기 시작")`, `:125` `// SQS 데이타 불러오기`,
   `:145` `ItfTrace.Event("SQS_RECEIVED", $"웹훅 수신: {orderMsg.Resource.EventCode}", ...)`,
   `:158` `DeleteMessageQueue(orderMsg);`, `:565` `static void DeleteMessageQueue(...)`.
2. 웹훅 분기 — `:180` `static async Task DoWebHookJob(OrderWebhookPayload orderMsg)` →
   `:216` `DoCreateOrder`, `:500` `DoUpdatePayment`, `:512` `DoOrderCancel`.
3. 카페24 API 로 주문 조회 — `:223` `orderInfo = await GetOrderInfo(orderMsg);`, 구현 `:578`.
4. **MES 적재 진입점** — `:426-427`
   `OrderBiz orderBiz = new OrderBiz(); orderBiz.COrderByExcel(CMPMY_CD, xlsImportData, false);`
   (`:428` `ItfTrace.Event("DB_SAVE_ORDER", "COrderByExcel 저장 완료", ...)`)
5. 구현 — `BackOffice.Server/CRT.EasyMES.V2.Data/Biz/OrderBiz.cs:269` `COrderByExcel(...)`
   → `:286` `dac.CExcelImport(...)`(T_EXL_IMPORT)
   → `:306` `dac.COrderExcel(companyCd, excelInfo.GetParameterSetOrder(), excelImportseq)`
   → `:321` `dac.COrderDetailExcel(...)`, `:328` `dac.COrderFiles(ps)`
   → 패키징 `:316` `dlvrDac.CUPackage(...)`, `:338` `dlvrDac.CPackageDetail(...)`
6. **최종 SP** — `BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:439`
   `return (string)this.DbAccess.ExecuteSpScalar("USP_ORD_ORDER_EXCEL_C", parameters);` (`COrderExcel`, 선언 `:342`)
   실재 정의: `ref/db/huni-db-script.sql:19958` `CREATE PROCEDURE [dbo].[USP_ORD_ORDER_EXCEL_C] (`
7. 취소 — `Program.cs:551` `CancelOrderInMes(...)` → `OrderDac.cs:253` `USP_ORD_ORDER_CANCEL_BY_USR_ORD_CD`.

### 우커머스 경로 (근거 체인)

1. SQS 폴링 — `BackOffice.Console/TS.BackOffice.WebHookHandler.WooCommerce/WebHookService.cs:31`
   `public static string QueueUrl { get; set; }`, `:42` `QueueUrl = FoxConfigurationManager.AppSettings["QUEUE_URL"];`,
   `:82` `sqsClient = new SqsClient(awsConfig, QueueUrl);`,
   `:113` `private void DoWork(List<WebHookMessage> webHookMsgList)`,
   `:135` 로그에 `SQS ReceiptHandle / WebHook Id / WebHook DeliveryId / WebHook SourceUrl`.
2. **최종 SP** — `BackOffice.Console/TS.BackOffice.WebHookHandler.WooCommerce/Database/Dac/OrderDac.cs:64`
   `USP_ORD_ORDER_ITF_CU`(주문 헤더 C/U), `:120` `USP_ORD_ORDER_DTL_ITF_C`(상세),
   `:151` `USP_ORD_ORDER_FILES_ITF_C`(원고 파일), `:179` `USP_ORD_ORDER_COUPON_ITF_C`,
   삭제 대응 `:78 / :134 / :164 / :187`.
   (SP 계열 실재 확인: `docs/DB-SCHEMA-LIVE.md:610` — **문서 주장**이나, 호출은 위 `.cs` 로 실증)

### 성원(SW) 경로도 동일 패턴

`BackOffice.Console/CRT.EasyMES.V2.Console.SWOrderInterface/Program.cs:324`
`orderBiz.COrderByExcel(CMPMY_CD, xlsImportData, false);` — 카페24와 같은 적재 진입점.

### WebApi 가 그 경로가 아니라는 반증

- 세 콘솔 작업자 모두 **WebApi 를 HTTP 로 호출하지 않는다**(위 체인 어디에도 WebApi 엔드포인트 호출 없음;
  적재는 `OrderBiz`/`OrderDac` 직접 호출).
- WebApi 의 주문 생성 SP `USP_T_ORD_ORDER_C` 는 라이브 DB 스크립트에 없고(§4-1),
  실적 경로의 `USP_ORD_ORDER_EXCEL_C` / `USP_ORD_ORDER_ITF_CU` 는 있다.
- WebApi 코드 스스로 인정: `EndPoints/OrderCoreEndPoints.cs:66-67`
  `Source = WcfMappingSource.NEW, Notes = "New endpoint - WCF uses COrderByExcel for bulk import"`.
- 세 콘솔 프로젝트는 솔루션 정식 멤버(`TS.BackOffice.Huni.sln:100,104,106,108,110,114`),
  WebApi 는 아님(§7).

---

## 확인 못 한 것

1. **`USP_T_ORD_ORDER_C` 외 WebApi 계열 SP 9종의 실재 여부 — 라이브 DB 미조회.**
   저장소 아티팩트(`ref/db/huni-db-script.sql`, `docs/sql/**`, `DBSync/`, `DBUtils/`)에 없다는 것까지만 확인했다.
   `ref/db/huni-db-script.sql` 이 라이브 전체 스냅샷인지 부분인지도 미확인.
   (해당 SP: `USP_T_ORD_ORDER_C/_R/_L/_U/_STATUS_U/_D/_BY_STATUS_R/_BY_CUSTOMER_R/_BY_DATE_RANGE_R`,
   `Repository/OrderCoreRepository.cs:54,80,159,197,227,254,285,315,351`; `USP_T_SAL_ESTIMATE_CONVERT_ORDER`
   `Repository/EstimationRepository.cs:240`)
2. **WebApi 프로세스가 어딘가 실제 기동 중인지** — 저장소 밖 사실이라 코드로 판정 불가.
   서버 접속·프로세스 확인·Swagger 실호출을 하지 않았다(읽기전용 과제 범위 밖).
3. **`appsettings.json` 의 git 추적 여부** — 워크트리 격리 정책상 대상 저장소에 git 명령을 실행하지 않았다.
   `.gitignore` 에 제외 규칙이 없다는 것까지만 확인.
4. **`sp-crud-tester`(TypeScript)가 `USP_T_ORD_ORDER_C` 를 어떤 맥락으로 참조하는지** — 파일 목록만 확인하고 내부는 정독하지 않았다.
5. **`OrderCoreEndPoints.cs` 의 나머지 핸들러(Update/Delete/UpdateOrderStatus) 본문 상세** —
   등록부와 리포지토리 SP 매핑만 확인했고 본문 로직은 `CreateOrder` 만 정독했다.
6. **카페24 `DoCreateOrder` 의 260~426행 구간(ITEM_CD 매핑·엑셀 셀 조립)** — 적재 진입점 확정에 필요한 만큼만 읽었고 전 구간 정독은 하지 않았다.
7. **API 게이트웨이/리버스 프록시 레이어 존재 여부** — 저장소에 관련 설정이 없어 판단 불가.
