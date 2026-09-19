# t54 verdict — 후니 MES 주문·파일 수신 이음매 실독

카드: **t54** (오픈일정 S6-B · class C · SPEC 없음 · 조사·문서 · 읽기전용)
워크트리: `.claude/worktrees/t54` · 브랜치: `WT-mes-intake-seam` (`WT-unlisted-rejudge` 머지 후 시작)
대상 저장소: `/Users/innojini/Dev/TS.BackOffice.Huni` — **Read/Grep 만. 쓰기 0 · 빌드 0 · 실행 0 · git 조작 0.**
계약: `../CONTRACT.md` 보충 1~4.

---

## 0. 이 카드가 낸 것

| 파일 | 카드 항목 | 내용 |
|---|---|---|
| `parts/workers.md` | ① | 무인 작업자 13개 × (입력·기동방식·처리·호출 프로시저·상태회신) 전수표 |
| `parts/intake-file-lifecycle.md` | ② | 접수파일 수명주기 4단계 + **주문↔파일 조인 키 2겹** |
| `parts/webapi.md` | ③ | WebApi 주문 생성 경로·인증·멱등성·배포 증거 |
| `parts/shopby-map.md` | ④ | 샵바이 스펙 11개 ↔ 사내 선례 1:1 매핑 + 재사용 판정 |
| `parts/pitstop-slots.md` | ⑤ | 검판 결과가 들어갈 자리 후보 5개(테이블·게이트·화면·로깅) |
| `verify_citations.py` | 검산 | `parts/*.md` 의 `path:line` 인용을 저장소에 기계 대조 |

**`screens.csv` 는 내지 않는다.** mes/edicus/pitstop 화면·기능 원장 134행은 **t50 이 이미 소유**하고 있고(`../t50/screens.csv`),
이 카드의 지시는 "화면 원장"이 아니라 "코드로 이음매를 확정"이다. 같은 기능을 두 번 세면 계약 보충 3의 이중계상이 된다.
이 카드가 발견한 것 중 원장에 반영할 것은 §7 에 **t51/t50 앞으로 넘길 형태**로 적었다.

**`*-decisions.md` 신규 0건.** 이 조사에서 나온 미결은 전부 t50 `pitstop-decisions.md`(7건)·`edicus-decisions.md`(2건)에
이미 등재된 안건의 하위 사실이다. 같은 안건을 다시 만들지 않았다.

---

## 1. 실행한 검산 명령과 출력

### (1) 인용 검산 — `python3 verify_citations.py`

```
저장소 색인 파일 1198개
인용 총계 361 — 유일해소·통과 281 / 축약(검산불가) 80 / 문제 0
  intake-file-lifecycle.md: 65건
  pitstop-slots.md: 19건
  shopby-map.md: 35건
  webapi.md: 122건
  workers.md: 120건
```

검사 내용: 인용 경로가 저장소에서 **유일하게 해소되는가**, 그 **줄번호가 파일 길이 안에 있는가**. 281건 전부 통과, 초과·부존재 0건.
**검사하지 않는 것**: 그 줄의 *내용*이 주장과 맞는가. 그건 아래 (2) 의 표본 재실행으로 사람이 봤다.

축약 80건은 `Program.cs:107` 처럼 파일명만 쓴 인용이다. 이 저장소에는 `Program.cs` 가 17개, `OrderDac.cs` 가 4개, `OrderBiz.cs` 가 4개,
`ThumbnailService.cs` 가 2개 있어 **파일명만으로는 지목되지 않는다.** 검산기 초안은 "문서 문맥으로 추정 해소"를 했는데,
그 추정이 엉뚱한 파일에 줄번호를 대고 "초과"를 3건 만들어 냈다(예: `Program.cs:287` 을 66줄짜리 `DesignFileCopyToNas/Program.cs` 로 해소).
**추정 해소를 버리고 "축약 = 검산 대상 밖"으로 분류했다** — 없는 결함을 만들어 내는 쪽이 더 나쁘다.
이 카드가 쓴 두 문서(`intake-file-lifecycle.md`·`pitstop-slots.md`)의 축약은 전부 전체경로로 승격했다.

> 부수 사실: **이 저장소에서 `path:line` 축약 인용은 위험하다.** 계약 보충 3의 병합 키 정정(`path:line` 단독 키는 오병합)이
> MES 저장소에서도 같은 이유로 성립한다 — 같은 파일명이 프로젝트마다 반복된다.

### (2) 다른 레인 주장의 표본 재실행 (계약 보충 4: 인용하는 쪽이 직접 확인)

아래는 **내가 직접 돌려 출력을 본 것**이다. 남의 결론을 옮겨 적지 않았다.

| 검증한 주장 | 돌린 명령 | 결과 |
|---|---|---|
| 샵바이 구현 0건 | `grep -rli "shopby" --include="*.cs" . \| grep -v '/obj/\|/bin/' \| wc -l` | **0** |
| 스펙 엔드포인트 11개 | `grep -c "^  /" docs/api/shopby-integration-api.yaml` / `grep -c "      operationId:"` | **11 / 11** (경로 11개 열거 확인) |
| OrderCore 인증 0 | `grep -c "RequireAuthorization" .../OrderCoreEndPoints.cs` · `grep -c "\.Map(Get\|Post\|Put\|Delete)"` | **0 / 6** |
| 로그인 하드코딩 | `sed -n '120,126p' .../AuthEndPoints.cs` | 주석 "샘플: 하드코딩된 사용자로 검증(실제 구현에서는 DB 조회 필요)" + 리터럴 비교 확인 |
| WebApi 빌드 제외 | `grep -n "BackOffice.WebApi" TS.BackOffice.Huni.sln` | **1행뿐** — `{2150E333-…}`(VS **솔루션 폴더** GUID), csproj 항목 0 |
| 카페24 주문생성 SP | `sed -n '427p' Cafe24Interface/Program.cs` → `OrderBiz.cs:269` → `OrderDac.cs:439` | `COrderByExcel` → **`USP_ORD_ORDER_EXCEL_C`** |
| 그 SP 실재 / WebApi SP 실재 | `grep -c "USP_ORD_ORDER_EXCEL_C" ref/db/huni-db-script.sql` · 같은 명령 `USP_T_ORD_ORDER_C` | **4 / 0** |
| 우커머스 서명검증 | `grep -rn "Signature\|HMAC\|x-wc-webhook" .../WebHookHandler.WooCommerce/` | 헤더 6종 읽지만 **`x-wc-webhook-signature` 는 읽지 않음** = 검증 없음 |
| 인바운드 HTTP 라우트 | `grep -rn --include="*.cs" "HttpListener\|MapPost(\"/webhook\|UseEndpoints" BackOffice.Console/ BackOffice.Server/` | **출력 없음** |
| `WooCommerce.Command` 가 라이브러리 | `grep -n OutputType .../csproj` · `ls .../Program.cs` | `<OutputType>Library</OutputType>` · Program.cs **없음** |
| `MAX_INSTANCES` 가드 유일 | `grep -rn "MAX_INSTANCES" --include="*.cs" BackOffice.Console/` | **`DesignFileThumbnailCreator/Program.cs:37,42,51` 뿐** |
| `UpdateTracking` 빈 본문 | `grep -n -A12 "UpdateTracking" CommandHandler/CommandService.cs` | `:206-214` — 지점 조회 후 **아무 것도 전송하지 않고 끝남** |
| PitStop 흔적 | `grep -rli "pitstop"` (cs / 전체) · `grep -rn -i "preflight\|검판\|전산검수"` | **셋 다 출력 없음** |

### (3) 내가 직접 뜬 전수 — WebApi 엔드포인트별 인증 적용

```
$ for f in EndPoints/*.cs; do  (Map 수 / 인증 수)
```
인증 0인 파일 **3개**: `CustomerEndPoints.cs`(Map 8 / 0) · **`OrderCoreEndPoints.cs`(6 / 0)** · `WcfMappingVerificationEndPoints.cs`(4 / 0).
나머지 23개 파일은 Map 수 이상으로 `RequireAuthorization`/`[Authorize]` 가 붙어 있다.
→ **미보호 라우트 18개**이며 그중 6개가 주문 CRUD 전부다.

> 두 레인의 서술이 겉보기에 충돌했다(한쪽 "JWT 보호", 다른 쪽 "인증 없음"). 전수를 떠 보니 **둘 다 맞다** — 파일마다 다르다.
> 충돌을 말로 중재하지 않고 분모를 세어 해소했다.

---

## 2. ① 무인 작업자 13개 — 결론

전수표는 `parts/workers.md`. 요지:

| 축 | 분포 |
|---|---|
| 입력 | **SQS 7** (Cafe24Interface · ItfLogConsumer · MotionOne · CopyToNas · ThumbnailCreator · WooCommerce WebHook · CommandHandler) · **DB 폴링 2**(Cafe24 `.Update` · ECount) · **외부 API 폴링 1**(SWOrder) · **파일시스템 폴링 1**(Monitor) · **입력 없음 1**(Cafe24 `.Token`) · **실행체 아님 1**(`WooCommerce.Command`) |
| 기동 | **상주 Windows 서비스(Topshelf) 3** — ItfLogConsumer · WooCommerce WebHook · CommandHandler / **나머지는 1회 실행 후 종료**(외부 스케줄러가 돌린다는 전제) |
| 중복실행 가드 | **`DesignFileThumbnailCreator` 1개뿐**(`MAX_INSTANCES`, 기본 3). 상주 3종은 Windows 서비스 등록이 사실상 가드. **나머지 1회실행 작업자 6종은 가드 없음** |
| 상태 회신(push-back) | **3개만** — Cafe24 `.Update`(주문상태 `PUT /orders`·송장 `POST /shipments`) · SWOrder(성원 setStatus/setInvoiceNo/SendDelv) · CommandHandler(우커머스 주문상태) |
| 재시도/DLQ 처리 | **있음 5**(ItfLogConsumer · ThumbnailCreator · CopyToNas · MotionOne · SWOrder) / **없음 6**(Cafe24 3종 · Woo WebHook · CommandHandler · ECount) |

**실행 파일이 아닌 것**: `TS.BackOffice.WooCommerce.Command` — `<OutputType>Library</OutputType>`, `Program.cs` 부재.
SQS 명령 DTO(`UpdateStatusCmd`·`UpdateTrackingCmd`)만 담는다. **"무인 작업자 13개"는 실은 실행체 12 + 라이브러리 1이다.**

**중앙 로깅**: 모든 작업자가 `ItfTrace` 로 이벤트를 남기고, sink 는 3갈래(DB 직접 / WCF `Log.svc` / SQS `ITF_LOG_QUEUE_URL`)다.
SQS 갈래의 **소비자는 `ItfLogConsumer` 하나**이고 `USP_LOG_ITF_TRACE_C` → `T_LOG_ITF_TRACE` 로 배치 저장한다.
그 테이블을 **읽는 `.cs` 코드는 없다**(읽기는 문서·슬래시명령 쪽). → 추적 데이터는 쌓이지만 화면이 없다.

**발견 2건(사실 기록, 판정 아님)**
1. `CommandHandler.UpdateTracking`(`CommandService.cs:206-214`) — 분기는 있는데 **본문이 비어 있다.** 송장 명령을 받아도 우커머스로 아무 것도 보내지 않고
   `:144` 에서 SQS 메시지를 삭제한다. 의도인지 미구현인지는 코드로 알 수 없다.
2. `SendData.ECount/Program.cs:48` 의 null 가드가 `||` 로 "건수>0" 조건과 묶여 있어 판정이 뒤집히는 형태다. **런타임 영향은 확인하지 않았다.**

---

## 3. ② 접수파일 수명주기 — 결론 (전문: `parts/intake-file-lifecycle.md`)

```
Edicus(모션원) 렌더완료
  └SQS→ MotionOneInterface ─S3 업로드 2벌─→ {CMPNY_CD}/Order/Original/{ORD_YMD}/{ORD_CD}/{파일}
                             │                {CMPNY_CD}/Order/Design/{ORD_YMD}/{ORD_CD}/{파일}  (S3 내부 Copy)
                             └WCF→ USP_ORD_ORDER_S4(조회) → USP_ORD_ORDER_DTL_EDICUS_CU
                                    → USP_ORD_ORDER_FILES_D(기존 삭제) → USP_ORD_ORDER_FILES_C(재삽입)
                                    → USP_ORD_ORDER_DTL_EDICUS_COMPLETE(주문상태)
  S3 업로드 이벤트 ─EventBridge→SQS→ ① ThumbnailCreator (FILE_THUMB 생성)
                                      ② DesignFileCopyToNas (상태 게이트 통과 시 NAS 배포)
```

**주문과 파일을 잇는 키는 두 겹이고 성질이 다르다.**

| 겹 | 키 | 성질 |
|---|---|---|
| 외부주문 → MES주문 | `USR_ORD_CD` + `MARKET_ORD_ITEM_NO` + `EDICUS_EDITOR_ITEM_ID` | 코드 주석이 각각 "네이버 주문번호 / 네이버 상품주문번호 / 에디쿠스 편집아이템ID" 라고 적는다 |
| MES주문 → 파일행 | `ORD_CD` + `ORD_DTL_SEQ` + `ORD_DTL_ITEM_NBR` | `ORD_DTL_SEQ` 미존재 시 `EditorItemIndex` 대체, `ORD_DTL_ITEM_NBR` 은 신규 GUID |
| **S3 이벤트 → 주문** | **S3 키 문자열의 부모 디렉터리 이름** | 썸네일·NAS 두 작업자가 `parentDirectory.Name` 을 `ORD_CD` 로 쓴다 — **경로 규칙이 곧 조인 키** |

오픈에 직접 걸리는 사실 3가지:
1. **렌더 경로의 "접수파일"은 원본의 S3 내부 복사본**이다(주석: "원본 파일 = 디자인접수파일 인 경우"). 검수를 거친 산출물이라는 의미가 코드에 없다.
2. **S3 키 경로가 계약이다.** 샵바이 경로를 새로 만들 때 `…/{ORD_YMD}/{ORD_CD}/{파일명}` 모양을 깨면 하류 두 작업자가 **조용히** 주문을 못 찾는다(예외가 아니라 skip 이다).
3. **샵바이의 무엇이 `USR_ORD_CD`/`MARKET_ORD_ITEM_NO` 가 되는지는 이 저장소 어디에도 정해져 있지 않다.** 스펙 yaml 은 `orderNo`·`items[].productId` 만 정의한다.

---

## 4. ③ WebApi — 결론 (전문: `parts/webapi.md`)

| 질문 | 답 | 근거 |
|---|---|---|
| 주문 CRUD 경로 | `/api/{companyCode}/orders` — GET·GET/{code}·**POST**·PUT·DELETE·PUT/status 6개 | `OrderCoreEndPoints.cs:27` `MapGroup`, POST `:59` |
| `CrudOrder` | **`[Obsolete]` 스텁** — 리포지토리가 빈 컬렉션 반환 | `CrudOrderEndPoints.cs:13` |
| `Order` | 작업지시서 조회 1건뿐(`USP_ORD_JOBORDER_REPORT_S2`) | `OrderEndPoints.cs:14` |
| 인증 | JWT Bearer 단독. `FallbackPolicy` 없음 → **`RequireAuthorization` 없는 엔드포인트는 익명**. OrderCore 6개 전부 익명 | §1-(3) 전수 |
| 로그인 | **소스 하드코딩 리터럴과 직접 비교**(주석이 "샘플"이라 자인) | `AuthEndPoints.cs:123-124` |
| 멱등성 | **없음.** DTO 에 외부 주문번호 필드 자체가 없고 주문코드는 매 호출 새 GUID. `Idempot/Duplicate/Exists/UNIQUE/Upsert/MERGE/X-Request-Id` 전 패턴 0건 | `OrderCoreEndPoints.cs:293` |
| 생성 종착 SP | `USP_T_ORD_ORDER_C` — **저장소 DB 아티팩트에 0건**. 반면 콘솔이 쓰는 `USP_ORD_ORDER_EXCEL_C` 는 4건 실재 | §1-(2) |
| 배포 증거 | **없고, 반증이 있다** — `.sln` 의 `BackOffice.WebApi` 는 **솔루션 폴더**이고 csproj 항목 0. 별도 sln·Dockerfile·CI·Setup 포함 전무 | `TS.BackOffice.Huni.sln:102` |
| 외부 주문 실제 유입 경로 | **WebApi 가 아니라 콘솔(SQS/폴링) 작업자** | 카페24 `COrderByExcel`→`USP_ORD_ORDER_EXCEL_C`, 우커머스 `USP_ORD_ORDER_ITF_CU`, 성원 동일 |

> **오독 위험 경고**: WebApi 는 주문 생성 엔드포인트가 있고 Swagger 문서도 있어 "주문 수신 API 가 이미 있다"로 읽힌다.
> 그러나 (a) 솔루션 빌드 대상이 아니고 (b) 호출하는 SP 가 DB 스크립트에 없고 (c) 주문 **아이템이 저장되지 않으며**
> (d) 코드가 스스로 `Notes = "New endpoint - WCF uses COrderByExcel for bulk import"` 라고 적어 두었다.
> **이것을 "샵바이를 붙이면 되는 기존 API" 로 취급하면 안 된다.**

---

## 5. ④ 샵바이 11개 ↔ 사내 선례 — 결론 (전문: `parts/shopby-map.md`)

- 스펙: `docs/api/shopby-integration-api.yaml`, **경로 11 · 오퍼레이션 11**(직접 셈). 구현 `.cs` **0건**.
- **11개 전부 MES 가 서버**(base `…/api/integration/shopby`). 그중 샵바이가 호출자인 인바운드 2(`POST /orders/receive`, `POST /webhook`),
  MES 가 샵바이 클라이언트가 되는 아웃바운드 3(`/products/sync` pull, `/inventory/push`, `/inventory/sync` 양방향), 나머지 6은 로컬 DB 전용.
- **재사용 판정: 복제 0 · 부분 9 · 신규 2.**

| 판정 | 건 | 이유 |
|---|---|---|
| **신규 2** | `POST /inventory/sync`(양방향) · `POST /webhook`(HMAC 인바운드) | 사내 연동은 전부 **단방향 전용 앱으로 분리**돼 있다(`Cafe24Interface` vs `.Update`) — 양방향 조정 로직 0건. 인바운드 HTTP 라우트 0건이고, HMAC 은 배송 쪽 **아웃바운드 서명 생성**만 있고 **검증 코드 0건** |
| **부분 9** | 나머지 | 형태(페이징 목록·단건 조회·JWT·FluentValidation)는 그대로 베낄 수 있으나 **대상 엔티티가 통째로 없다** — `ProductMapping`·수신주문·웹훅이벤트로그에 해당하는 모델/리포지토리/테이블이 코드에도 DB 스크립트에도 없다 |
| **복제 0** | — | 위 이유로 "대상만 바꾸면 되는" 것이 하나도 없다 |

**인증은 넷이 서로 다르고 샵바이와도 다르다**: 카페24=OAuth2(Basic→Bearer) · 우커머스=**서명검증 없음**(SQS 구독) · 성원=토큰 없음(쿠키+`company_id`) · 이카운트=`SESSION_ID` 쿼리스트링.
스펙의 `bearerAuth`(JWT)는 MES WebApi 자체 JWT 와 같아 **그대로 재사용 가능**하나, `X-Webhook-Signature`(HMAC-SHA256)는 **선례 없음**.

**가장 두꺼운 재사용 자산**: 외부 주문 → MES 주문 변환(`Cafe24Interface DoCreateOrder`, 우커머스 `CreateUpdateOrder`, `ProductItemFactory` 의 외부 라인아이템 → `ITEM_MDL_CD` 매칭).
즉 `POST /orders/receive` 는 **수신 층만 신규고 변환 층은 재사용**이다 — 이 카드가 낸 가장 실용적인 결론이다.

> **수신 형태가 현행과 다르다**는 점이 핵심 갭이다. 현행 4채널 중 **HTTP 웹훅을 직접 받는 것이 하나도 없다** —
> 전부 SQS 구독이거나 폴링이다. 샵바이 스펙은 MES 가 HTTP 엔드포인트를 노출하고 서명을 검증하라고 요구한다.
> 앞단에 큐를 두는 현행 방식을 유지할지, 스펙대로 직접 노출할지는 **결정이 필요한 사항이고 아직 결정되지 않았다.**

---

## 6. ⑤ PitStop 자리 후보 — 결론 (전문: `parts/pitstop-slots.md`)

PitStop 은 MES 에 **코드 0 · 문서 0 · 유사 개념어 0**이다. 따라서 아래는 "빈 자리" 목록이지 구현이 아니다.

| 후보 | 기존 그릇 | 새로 필요한 것(사실) |
|---|---|---|
| A. `T_ORD_ORDER_FILES` 에 파일 종류 추가 | `FILE_TYP` 이 `T_COM_CD`(`CD_GRP='FILE_TYP'`) 코드 도메인 · `UPR_SEQ` 부모-자식 축 · `PRCS_CD` 공정 축 | 코드값 추가(**varchar(10) — 10자 이내**) + C# `enum FileType` 4값 확장 + **재렌더 시 `USP_ORD_ORDER_FILES_D` 삭제 범위 확인** |
| B. 「접수완료」 게이트 | `FrmOrder2.DoSave()` 가 `STAT_0100 → STAT_0400` 올리기 전 **이미 파일필수 검사**를 한다(`REQ_FILE_YN`·`DSIGN_CNT==0` → 경고) | 검판 결과 조회 + 차단/경고 정책 결정. **선례가 같은 모양** |
| C. NAS 배포 게이트 | `DesignFileCopyToNas` 가 `ORD_DTL_STAT_CD != DOWNLOAD_STATUS` 면 복사하지 않는다 | **코드 변경 없이 상태값만으로 생산 차단 가능** |
| D. 주문상세 화면 | `UcOrderDetail` 에 원본/접수/공정 3격자 + 썸네일 탐색기 | 격자 1개 추가 또는 공정 격자에 합부 열 |
| E. `ItfTrace` | 전 작업자 공통, 컨텍스트가 이미 주문 단위 | 이벤트 코드 정의 |

**가장 실질적인 위험 1건**: A 를 택하면 검판 결과가 **재렌더 때 파일행과 함께 지워질 수 있다.**
`USP_ORD_ORDER_FILES_D` 는 매 렌더 반영 전에 호출된다. 라이브 SP 본문을 보지 못했으므로 "지워진다"가 아니라 **"확인해야 한다"**로 남긴다.

---

## 7. 원장(t50/t51)에 넘길 것

t50 `screens.csv` 는 이 카드의 코드 실독 이전에 만들어졌다. 아래는 **행을 고치라는 지시가 아니라 근거 보강 제안**이며,
반영 여부는 t50/t51 과 리드의 몫이다. 이 카드는 남의 원장을 직접 고치지 않았다.

| # | 제안 | 근거 |
|---|---|---|
| 1 | 샵바이 11행의 `owner_side` = **mes** 로 확정 가능 | 11개 전부 MES 가 서버(§5). 단 인바운드 2건의 "수신 형태"(직접 HTTP vs 앞단 큐)는 미결이므로 그 2행은 `미정` 유지가 맞다 |
| 2 | 샵바이 11행 evidence 에 **재사용 판정(복제0/부분9/신규2)** 을 덧붙이면 t51 작업량 집계의 해상도가 올라간다 | `parts/shopby-map.md` 매핑표 |
| 3 | **WebApi 주문 API 를 "있는 기능"으로 세지 말 것** — 솔루션 빌드 대상이 아니고 호출 SP 가 DB 에 없다 | §4 |
| 4 | 무인 작업자 행이 있다면 **`WooCommerce.Command` 는 화면·기능이 아니라 라이브러리**다 | §2 |
| 5 | 신규 관측 2건(`UpdateTracking` 빈 본문 · ECount 조건식)은 **오픈 분모 밖**(기존 자산)이나, 우커머스 잔존 운영이 오픈 후에도 있다면 별건으로 다룰 값어치가 있다 | §2 |

---

## 8. 확인 못 한 것 (합계 **미확인 19건**)

각 parts 문서의 "확인 못 한 것" 절을 합친 것이다.

**공통 성격의 한계 4**
1. **라이브 DB 미접속** — 저장프로시저 본문을 하나도 보지 못했다. SP **이름**은 `.cs` 로 확정했으나 **무엇을 하는지는 확인하지 않았다.**
2. **라이브 화면 미확인** — MES 실화면을 띄우지 않았다. 폼·엔드포인트 코드만 읽었다.
3. **실행 스케줄 미확인** — 1회실행 작업자들이 실제로 몇 분마다 도는지는 운영 서버 작업 스케줄러에 있다. 코드 주석의 "15분"은 **작성자 주장**이다.
4. **`docs/**` 의 SQL 스크립트가 라이브 판본인지 미확인** — `docs/sql/**` 에 실제 T-SQL 이 있으나 배포 여부는 알 수 없다.

**개별 15**
5. 작업자별 큐의 DLQ 실제 설정(`maxReceiveCount`) — 코드 주석에만 나온다
6. `dlq-triage` 구현체의 소재
7. `DesignFileCopyToNas` 의 DB 쓰기 유무(파일 복사만 확인)
8. `CommandHandler.UpdateTracking` 빈 본문이 의도인지 미구현인지
9. `SendData.ECount/Program.cs:48` 조건식의 런타임 영향
10. 우커머스 웹훅이 SQS 로 들어오기 **전 단계**(API Gateway/Lambda 등) — 이 저장소 밖일 수 있다. "서명검증 전무"는 **이 저장소 기준**이다
11. WebApi 계열 SP 10종의 라이브 실재 여부
12. WebApi 프로세스의 실기동 여부(별도 배포 파이프라인이 저장소 밖에 있을 가능성)
13. `appsettings.json`·`FoxConfiguration.*.config` 의 git 추적 여부 — **워크트리 격리로 대상 저장소에 git 을 실행하지 않았다**(카드 제약)
14. 샵바이 스펙의 "로컬 상품/재고"가 MES DB 인지 Railway/webadmin DB 인지 — **스펙에도 코드에도 근거가 없다**
15. `USP_ORD_ORDER_FILES_D` 의 `FILE_TYP` 필터 유무(§6 위험 1건의 확정 조건)
16. `DOWNLOAD_STATUS` 설정 실제값
17. `UPR_SEQ` 의 C# 사용처 0건 — SQL 에서만 쓰인다
18. PitStop 산출물의 실제 모양(검판 PDF 개수·리포트 포맷·합부 형태) — 저장소 근거 0
19. 모션원(Edicus) 송신 측 코드 — 저장소 밖. 수신 계약만 확인

---

## 9. 잔여 위험

1. **이 카드는 코드를 읽었을 뿐 MES 팀과 대조하지 않았다.** 정확성은 MES 담당(서희항 대표) 확인을 받아야 확정된다.
2. **"없다"는 전부 "찾지 못했다"이다.** PitStop 0건, 인바운드 HTTP 0건, 멱등성 0건 모두 돌린 grep 패턴을 문서에 적어 두었으니,
   패턴 밖에 있는 구현이 있다면 이 판정은 틀린다.
3. **축약 인용 80건은 기계검산 대상 밖이다**(§1-(1)). 다른 레인이 쓴 문서의 축약 인용을 재사용할 때는 전체경로로 먼저 승격해야 한다.
4. **샵바이 수신 형태(직접 HTTP vs 앞단 큐)가 미결**인 한, `POST /orders/receive`·`POST /webhook` 두 행의 작업량은 산정할 수 없다.
   현행 선례가 전부 큐 방식이므로 "스펙대로 직접 노출"을 고르면 **사내 선례가 없는 구간이 2개 더 생긴다.**
5. **검판 결과를 파일 테이블에 두면 재렌더로 유실될 수 있다**(§6). 설계를 확정하기 전에 SP 본문 확인이 선행돼야 한다.

---

금지사항 준수: **MES 저장소 쓰기 0 · 빌드 0 · 실행 0 · git 조작 0 · DB write 0 · 라이브 접속 0 · 푸시 0 ·
자격증명 값 전사 0**(설정키 이름과 읽는 위치만 기록) **· 날짜 추정 0 · 작업량(일수) 추정 0.**
