# t54 ② 접수파일(디자인파일) 수명주기 — 코드 실독

대상: `/Users/innojini/Dev/TS.BackOffice.Huni` (읽기전용 Read/Grep 만). 아래 경로는 모두 **저장소 루트 기준 상대경로**이며
줄번호는 `grep -n` / `sed -n` 으로 실제 확인한 값이다. `docs/**` 는 문서일 뿐 구현 증거가 아니므로, 구현 주장은 전부 `.cs`(또는 실제 `.sql` 스크립트)로 댄다.

---

## 0. 한 줄 요약

Edicus(모션원) 렌더 완료 → **SQS 웹훅** → MotionOneInterface 가 파일을 **S3 에 2벌(Original/Design) 올리고** →
**WCF 경유 저장프로시저**로 주문상세·파일행을 쓰고 주문상태를 올린다 → S3 업로드 이벤트가 **다시 SQS 로** 흘러
썸네일 생성기와 NAS 복사기를 깨운다. **주문과 파일을 잇는 키는 두 겹이다 — DB 는 `(ORD_CD, ORD_DTL_SEQ, ORD_DTL_ITEM_NBR)`,
S3 이벤트 경로는 `S3 키의 디렉터리 이름`.**

---

## 1. 파이프라인 4단계

| # | 단계 | 실행 주체 | 입력 | 출력 |
|---|---|---|---|---|
| 1 | 렌더 완료 수신 | `CRT.EasyMES.V2.Console.MotionOneInterface` | SQS 큐(`AWS_QUEUE_URL`) 의 `EdicusRenderInfo` | 메시지 파일 저장 + 2~3단계 트리거 |
| 2 | S3 업로드(2벌) | 같은 작업자 `UploadFiles` | 모션원 로컬/공유 디스크의 렌더 PDF | `…/Order/Original/…` 업로드 + `…/Order/Design/…` S3 내부 Copy |
| 3 | 접수파일 등록 | 같은 작업자 → WCF → SP | 위 S3 키 목록 | `T_ORD_ORDER_FILES` 행 + 주문상세 갱신 + 주문상태 변경 |
| 4-a | 썸네일 생성 | `CRT.EasyMES.V2.DesignFileThumbnailCreator` | S3 업로드 EventBridge 이벤트(SQS) | `FILE_THUMB` 행 + 썸네일 S3 객체 |
| 4-b | NAS 배포 | `CRT.EasyMES.V2.DesignFileCopyToNas` | 같은 종류의 S3 이벤트(SQS) | 생산용 NAS 폴더로 파일 이동 |

---

## 2. 1단계 — 렌더 완료 웹훅 수신

- 진입점: `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:46` (`static async Task Main`).
  클래스 주석이 스스로 "MontionOne Render 완료 WebHook 처리 콘솔 프로그램 / SQS 메세지 수신 후 S3 업로드 및 주문정보 저장"이라고 밝힌다 (`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:41-42`).
- 입력은 **HTTP 웹훅 수신이 아니라 SQS 폴링**이다 — `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:105-107` 에서 `AwsConfig` → `SqsClient(awsConfig, AWS_QUEUE_URL)` → `GetMessagesAsync<EdicusRenderInfo>` 로 끌어온다.
  큐 URL 은 설정키 `AWS_QUEUE_URL`(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:35`), 키/리전은 `AWS_KEY`/`AWS_SECRET_KEY`/`AWS_REGION`(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:32-34`)에서 읽는다. **값은 이 문서에 옮기지 않는다.**
- **기동은 1회 실행 후 종료**다. `Main` 안에 상주 루프가 없다(`while (true)` 0건 — `BackOffice.Console` 전체 grep 에서 이 작업자에는 잡히지 않는다).
  코드 주석이 재시도 주기를 "15분마다"로 적고 있다(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:126`·`:236`·`:449`) — **이는 작성자 주석이며 스케줄러 등록 자체를 이 저장소에서 확인한 것은 아니다.**
- 인자 모드가 따로 있다: `args` 가 비어 있지 않으면 SQS 대신 **저장된 `.msg` 파일을 재처리**한다(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:188-193`, `EdicusRenderInfo.Load`). 수동 복구 경로다.
- 수신 계약(`Common/EdicusRenderInfo.cs`): `SizeCode:44`, `Output.RootPath:107`, `Output.UserData:110`,
  `UserData.OrderId:140` · `StoreItemId:143` · `EditorItemId:146` · `EditorItemIndex:149` · `EditorItemTotalCount:152` · `ProductionCount:155` · `ProductionRequestDatetime:161`.
  실패 통보에는 `output` 노드가 없어 `HasRenderOutput` 이 false 다(`EdicusRenderInfo.cs:54-63`).

### 수신 단계에서 버려지는 메시지 (SQS 삭제 후 종료)
| 조건 | 위치 |
|---|---|
| 렌더 실패 통보(`output` 없음) | `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:132-134` |
| `OrderId` 가 `T` 로 시작하는 테스트 건 | `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:156-159` |
| 취소·삭제된 주문(`DEL_YN='Y'` 또는 `ORD_STAT_CD` 가 `STAT_9` 로 시작) | `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:304-307` |
| `StoreItemId` 없는 렌더(주문 매칭 키 자체가 없음) | `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:453-458` |
| 저장된 요청시각보다 오래된 렌더(재렌더 역전 방지) | `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:347-356` |

실패 시에는 **메시지를 지우지 않아** 다음 주기에 재시도되고, 반복 실패는 큐의 DLQ(`maxReceiveCount`)가 격리한다 —
설계 의도가 `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:170-172` 주석에 명시돼 있다.

---

## 3. 2단계 — S3 업로드: 원본과 접수파일은 **같은 파일의 두 벌**이다

`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:486` `UploadFiles(...)`.

```
originalKey = {CMPNY_CD}/Order/Original/{ORD_YMD}/{ORD_CD}/{파일명}     // Program.cs:528
designKey   = {CMPNY_CD}/Order/Design/{ORD_YMD}/{ORD_CD}/{파일명}       // Program.cs:529
```

- 원본을 먼저 `UploadFile` 하고(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:534`), **접수파일(Design)은 새로 올리지 않고 S3 내부 `CopyFile`** 로 복제한다(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:543-547`).
  주석이 "원본 파일 = 디자인접수파일 인 경우"라고 밝힌다(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:539`). → **Edicus 렌더 경로에서 접수파일은 원본의 사본이며, 사람이 검수해 만든 별개 산출물이 아니다.**
- 같은 로직이 JSON 구조 3갈래(`Prints[].Files[].Layers[]` / `Prints[].Files[].Filename` / `Prints[].Pages[].Layers[]`)에 **중복 구현**돼 있다
  (키 생성 지점 `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:528-529` / `:570-571` / `:620-621`). 세 갈래 모두 같은 키 규칙·같은 2벌 생성이다.
- 디스크에서 파일을 못 찾으면 조부모 디렉터리부터 재귀 탐색으로 한 번 더 찾는다(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:520` 외 2곳(`:563`·`:611`), 주석 "접수완료 된 폴더 이동 되는 경우가 있음").
- **누락이 하나라도 있으면 DB 를 쓰기 전에 예외를 던진다**(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:371-383`). 주석에 2026-09-04 사고(경로가 틀렸는데 0개 파일로 "정상 종료")로 도입됐다고 적혀 있다.

---

## 4. 3단계 — 접수파일 등록: 호출 사슬과 저장프로시저

호출 사슬(4층):

```
Console(Program.cs)
  → BackOffice.UI/CRT.EasyMES.V2.ServiceActivator/OrderData.cs   (WCF 프록시)
    → BackOffice.Server/CRT.EasyMES.V2.Web/Order.svc.cs          (WCF 서비스)
      → BackOffice.Server/CRT.EasyMES.V2.Data/Biz/OrderBiz.cs
        → BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs  → USP_*
```

| 호출 | Console | ServiceActivator | Order.svc | Biz | Dac | **저장프로시저** |
|---|---|---|---|---|---|---|
| 주문 조회 | `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:293` | `BackOffice.UI/CRT.EasyMES.V2.ServiceActivator/OrderData.cs:271` | `BackOffice.Server/CRT.EasyMES.V2.Web/Order.svc.cs:223` | `BackOffice.Server/CRT.EasyMES.V2.Data/Biz/OrderBiz.cs:52` | `BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:60` | **`USP_ORD_ORDER_S4`** (`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:67`) |
| 주문상세+파일 저장 | `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:421` | `BackOffice.UI/CRT.EasyMES.V2.ServiceActivator/OrderData.cs:280` | `BackOffice.Server/CRT.EasyMES.V2.Web/Order.svc.cs:232` | `BackOffice.Server/CRT.EasyMES.V2.Data/Biz/OrderBiz.cs:138` | — | 아래 4개 SP 조합 |
| 주문상태 변경 | `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:438` | `BackOffice.UI/CRT.EasyMES.V2.ServiceActivator/OrderData.cs:289` | `BackOffice.Server/CRT.EasyMES.V2.Web/Order.svc.cs:241` | `BackOffice.Server/CRT.EasyMES.V2.Data/Biz/OrderBiz.cs:174` | `BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:198` | **`USP_ORD_ORDER_DTL_EDICUS_COMPLETE`** (`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:205`) |

`UOrderDetailAndFilesForEdicusRender`(`BackOffice.Server/CRT.EasyMES.V2.Data/Biz/OrderBiz.cs:138-173`)가 한 트랜잭션 단위로 부르는 것:

1. `CUOrderDetailForEdicusRender` → **`USP_ORD_ORDER_DTL_EDICUS_CU`** (`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:170-183`) — 주문상세 생성/갱신, `ORD_DTL_SEQ` 반환
2. `DeleteOrderFiles` → **`USP_ORD_ORDER_FILES_D`** (`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:1060-1073`) — 그 편집아이템의 기존 파일행 삭제
3. `UOrderDetailEdicusRenderReqDtm` → **`USP_ORD_ORDER_DTL_EDICUS_RENDER_DTM_U`** (`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:189-197`) — 옛 렌더 차단 기준값 기록
4. 파일 수만큼 `COrderFiles` → **`USP_ORD_ORDER_FILES_C`** (`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:999-1021`)

> **삭제 후 재삽입 구조**다(`BackOffice.Server/CRT.EasyMES.V2.Data/Biz/OrderBiz.cs:145-148` 주석). 재렌더 시 같은 S3 키로 행이 중복되는 것을 막기 위한 것이며,
> 지우는 범위를 `ORD_DTL_ITEM_NBR` 까지 좁힌 이유가 주석에 명시돼 있다("하나의 ORD_DTL_SEQ 에 편집아이템이 둘인 주문도 있어 SEQ 단위로 지우면 안 됨").

파일행에 실리는 값(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:388-400`): `ORD_CD` · `ORD_DTL_SEQ` · `ORD_DTL_ITEM_NBR` · `PRCS_CD` · `FILE_TYP` · `FILE_PATH` · `FILE_EXT` · `S3KEY` · `PAGE_CNT`.
주문상세에 실리는 값(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:405-412`): `SIZE_NM_EX`(=렌더 `SizeCode`) · `EDICUS_PRODUCTION_CNT` · `EDICUS_EDITOR_ITEM_ID` · `EDICUS_EDITOR_ITEM_TOT_CNT` · `EDICUS_RENDER_REQ_DTM`.

---

## 5. **주문과 파일을 잇는 키** — 두 겹이고, 성질이 다르다

### (1) 외부 주문 → MES 주문: 3키 조회
`USP_ORD_ORDER_S4` 에 넘기는 3키(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:287-289`, `BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:62-65`):

| 파라미터 | 값의 출처 | Program.cs 주석이 밝히는 의미 |
|---|---|---|
| `USR_ORD_CD` | `Output.UserData.OrderId` | 네이버 주문번호 (`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:287`) |
| `MARKET_ORD_ITEM_NO` | `Output.UserData.StoreItemId` | 네이버 상품주문번호 (`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:288`) |
| `EDICUS_EDITOR_ITEM_ID` | `Output.UserData.EditorItemId` | 에디쿠스 편집아이템ID — 같은 상품주문번호 안에 여러 개 발생 가능 (`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:289`) |

> **주의**: 주석이 부르는 이름은 "네이버" 다(현행 채널 기준). 샵바이로 갈아탈 때 이 세 키에 **무엇을 넣을지가 계약의 핵심**이 된다.

### (2) MES 주문 → 파일행: 3키 저장
`ORD_CD` + `ORD_DTL_SEQ` + `ORD_DTL_ITEM_NBR` (`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:392-394`).
`ORD_DTL_SEQ` 가 없으면(-1) `EditorItemIndex` 로 대체하고, 0이 아니면 `ORD_DTL_ITEM_NBR` 을 **새 GUID 로 생성**한다(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:313-327`).

### (3) S3 이벤트 → 주문: **경로에서 잘라낸다** (가장 약한 고리)
썸네일/NAS 작업자는 S3 키 문자열의 **부모 디렉터리 이름을 `ORD_CD` 로, 조부모를 주문일자로** 쓴다:

- `BackOffice.Console/CRT.EasyMES.V2.DesignFileThumbnailCreator/ThumbnailService.cs:847-854` (`GetOrderCd` = `parentDirectory.Name`)
- 같은 파일 `:856-864` (`GetOrderDate` = `grandParentDirectory.Name`)
- 호출: `BackOffice.Console/CRT.EasyMES.V2.DesignFileThumbnailCreator/ThumbnailService.cs:305-306`
- NAS 쪽 동일 구현: `BackOffice.Console/CRT.EasyMES.V2.DesignFileCopyToNas/ThumbnailService.cs:243`, `:415`

즉 **§3 의 S3 키 규칙이 곧 조인 키다.** 키 규칙을 바꾸면 썸네일·NAS 두 작업자가 조용히 주문을 못 찾는다.
(샵바이 연동에서 새 업로드 경로를 만들 때 반드시 같은 `…/{ORD_YMD}/{ORD_CD}/{파일명}` 모양을 지켜야 한다는 뜻이다.)

---

## 6. 4단계 — 하류 두 작업자

### 4-a 썸네일 생성기
- 입력: EventBridge S3 이벤트가 실린 SQS 메시지(`BackOffice.Console/CRT.EasyMES.V2.DesignFileThumbnailCreator/ThumbnailService.cs:285-286` `jsonMsg.Detail.Object.Key` / `Detail.Bucket.Name`).
- 주문 존재 확인: `orderBiz.GetOrderFromS3Key(CmpnyCd, orderCd, s3key)` (`BackOffice.Console/CRT.EasyMES.V2.DesignFileThumbnailCreator/ThumbnailService.cs:353`). 0건이면 **삭제하지 않고 재시도**하되,
  업로드 후 1시간 경과 전은 INFO, 그 뒤는 ERROR 로 승격한다(`:355-370`). 주석이 밝히는 정상 레이스 원인 = 엑셀 일괄등록(`FrmOrderExcelImportBizHows`)이 **S3 업로드 후 주문을 생성**하기 때문(`:356-358`).
- 기존 썸네일 삭제 후 재생성: `DeleteOrderThumbFilesByS3Key` (`:406`), 저장 `COrderThumbnail` (`:462`, `:521`, `:599`) — `FILE_TYP = FILE_THUMB`(`:430`, `:456`).
- **영구 실패는 큐에서 뺀다**: S3 에 파일 없음(`:311-322`), 크기 상한 초과(`:333-350` — 주석에 2026-08-18~24 사이 407회 재시도 루프 사고 기록). 주석은 "썸네일이 없어도 주문·생산은 정상 진행"이라고 명시한다.

### 4-b NAS 복사기 — **여기에 상태 게이트가 있다**
- 입력: 같은 모양의 S3 이벤트 SQS(`DesignFileCopyToNas/ThumbnailService.cs:240-241`), 큐 설정키 `QUEUE_URL`(`:58`).
- DB 조회: `GetOrderDesignFiles` → **`USP_ORD_ORDER_DESIGN_FILES_S`**
  (`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:968-981`, Biz `BackOffice.Server/CRT.EasyMES.V2.Data/Biz/OrderBiz.cs:392`, 호출 `DesignFileCopyToNas/ThumbnailService.cs:250`).
- **게이트**: `ORD_DTL_STAT_CD != DOWNLOAD_STATUS` 면 복사하지 않고 메시지도 지우지 않는다(`:296-305`).
  `DOWNLOAD_STATUS` 는 설정키(`:60`)이고, 주석이 그 의미를 "제작대기가 될 때까지 재전달로 재시도"라고 적는다(`:299`).
  → **주문상세 상태가 지정 상태에 도달해야 생산용 파일이 NAS 로 나간다.** 파일이 생산에 풀리는 문(門)이 이 한 줄이다.
- 복사 대상 경로·파일명은 SP 가 돌려준 `TARGET_SUBDIR` · `TARGET_FILE_NM` 을 쓴다(`:306-307`), 임시폴더 다운로드 후 `File.Move`(`:316-332`), **이동이 끝난 뒤에만 SQS 삭제**(`:334`).
- DB 에 파일정보가 아직 없으면 삭제하지 않고 재시도(`:277-288`) — 주석이 밝히는 원인 = 업로드 주체가 "S3 먼저 → DB 나중" 순서.

---

## 7. 이 수명주기에서 오픈 때 걸리는 지점 (사실만)

1. **접수파일은 렌더 경로에서 원본의 S3 내부 복사본이다**(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:540-548`). "검수를 거친 파일"이라는 의미가 코드에 없다 — 검수 산출물을 넣을 자리는 따로 만들어야 한다(→ `pitstop-slots.md`).
2. **S3 키 경로가 조인 키**다(§5-(3)). 샵바이 경로를 새로 만들 때 경로 규칙이 계약이다.
3. **NAS 배포는 주문상세 상태 한 값에 걸려 있다**(`DesignFileCopyToNas/ThumbnailService.cs:296-305`). 검수 단계를 끼워 넣을 자연스러운 문이 여기다.
4. **주문 3키가 네이버 명칭으로 고정돼 있다**(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:287-289` 주석). 샵바이의 무엇이 `USR_ORD_CD`/`MARKET_ORD_ITEM_NO` 가 되는지는 **아직 어디에도 정해져 있지 않다**(이 저장소 안 근거 없음).
5. 렌더 웹훅이 주문 수집보다 먼저 도착하는 레이스를 **정상 흐름으로 설계**해 두었다(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:461-470`). 샵바이로 바꿔도 이 성질은 남는다.

---

## 8. 확인 못 한 것

1. **스케줄러 등록 실체** — 이 작업자들이 실제로 몇 분 주기로 도는지는 저장소 밖(운영 서버 작업 스케줄러)이다. "15분"은 코드 주석 주장이다.
2. **저장프로시저 본문** — `USP_ORD_ORDER_S4` 등의 실제 T-SQL 은 라이브 DB 에 있다. `docs/sql/edicus-rerender/04_usp_ord_order_s4.sql` 같은 스크립트 파일이 저장소에 있으나 **그것이 라이브에 반영된 판본인지는 확인할 수 없다**(DB 미접속).
3. **`T_COM_CD` 의 `FILE_TYP` 코드값 실적재** — 코드표 조인은 SQL 로 확인했으나(§`pitstop-slots.md` §2) 라이브에 어떤 값이 등록돼 있는지는 미확인.
4. **`UPR_SEQ` 의 실제 사용** — `.cs` 전체 grep 0건. SP/SQL 쪽에서만 쓰인다(`docs/sql/hapbaesong/03_usp_dlv_orders_for_package_s.sql`).
5. **모션원(Edicus) 쪽 송신 코드** — 이 저장소 밖이다. 수신 계약(`EdicusRenderInfo`)만 확인했다.
6. **라이브 동작 확인 0** — 실주문이 이 파이프라인을 통과하는 것을 본 것이 아니라 코드만 읽었다.
