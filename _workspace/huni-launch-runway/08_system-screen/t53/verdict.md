# t53 — 열림PnP PitStop 파이프라인 실독 (260919 · 레인 t53 · 브랜치 WT-pitstop-precedent)

카드 t53(class C · SPEC 없음 · 조사·문서 · 읽기전용). DB write 0 · 라이브 접속 0 · 빌드/실행 0 · 대상 저장소 git 쓰기 0.
입력 = `08_system-screen/pitstop-clues-CRT.md`(리드 메모 128줄 · 인용 대부분 미검증).
대상 = `/Users/innojini/Dev/CRT.DigitalEdit.V2`(C# · .NET Framework 4.7.2 · `.cs` 397개). Read/Grep 만 사용.

> **[HARD] 타 고객(열림PnP) 납품 코드다.** 여기 적힌 어떤 사실도 후니 원장 행의 `status` 근거가 아니다.
> pitstop 23행은 `미착수`/`미확인` 그대로 둔다. 가져갈 것은 호출 방법과 구간 나눔뿐이다.

## 1. 판정 한 줄

메모의 큰 그림(**PitStop 을 부르는 길은 CLI + 설정 XML 하나뿐**)은 실독으로 유지된다. 다만 메모의
**핵심 문장 하나가 사실과 다르고**(변수세트를 PitStop01 이 채운다), **선례의 갈래가 메모보다 하나 더 있다**
— 열림은 같은 파이프라인을 **DB 결합 판(SQS)과 DB 0 판(HotFolder) 두 벌**로 만들어 두었다.
이 두 번째 판이 STD-ART-034 의 실질을 바꾼다(§4).

## 2. ① 메모 인용 55건 전수 재대조

산출 = `t53/recheck.csv`(id · 메모줄 · 주장 요지 · 인용 경로 · 인용 행 · 판정 · 실측).

| 판정 | 건수 | 뜻 |
|---|---:|---|
| 일치 | 48 | 그 줄에 그 사실이 있다 |
| 부분 | 5 | 사실은 맞는데 줄 지정이 넓거나 좁다 / 단서가 빠졌다 |
| 어긋남 | 2 | 그 줄에 그 사실이 없다 |

메모가 스스로 표본 재대조했다고 적은 7건(§0-2)은 전부 재확인했다 — `AppArguments.cs` JobId 파싱의
`:52 → :57` 정정도 맞다(`CRT.Yeolim.ServerProcess/Common/AppArguments.cs:57`).

### 어긋남 2건 (메모 수정 필요)

**A. 변수세트는 PitStop01 이 채우지 않는다** — 메모 §1 마지막 문단은 「설정 XML 에 채우는 것(정본 블록
`CRT.Yeolim.ServerProcess/Program.cs:607-649`)」에 `SmartPreflight/VariableSet`(`.evl`)을 넣었다. 그 블록의 해당 줄
`CRT.Yeolim.ServerProcess/Program.cs:639` 는 **주석 처리**돼 있고, 같은 블록의 변수세트 경로 변수
`CRT.Yeolim.ServerProcess/Program.cs:587` 도 주석이다.

살아있는 대입은 **두 곳뿐이고 둘 다 PitStop02** 다 — `CRT.Yeolim.ServerProcess/Program.cs:1019` ·
`CRT.Yeolim.ServerProcess.HotFolder/Program.cs:1051`. PitStop01·PitStop03 은 세 판본 모두 주석이다
(`CRT.Yeolim.ServerProcess/Program.cs:639`·`:1225`, `CRT.Yeolim.ServerProcess.HotFolder/Program.cs:618`·`:1257`).
→ **변수세트(색상 타깃·DPI·근접거리·리샘플 DPI)는 본 처리 단계에만 걸린다.** 구조 검사와 폰트 플래튼은
변수 없이 돈다. 후니가 「어느 단계에 파라미터가 필요한가」를 설계할 때 이 구분이 그대로 쓸모 있다.

**B. SQS 롱폴 20초·최대 10건의 근거 줄이 틀렸다** — 메모 §4 ⑥은 `CRT.Yeolim.SQSMonitorService/Program.cs:109-110`
을 댔는데 그 두 줄에는 어느 숫자도 없다. 실제 출처는 둘로 갈린다:
`CRT.Framework.AWS/SqsClient.cs:52` 의 기본 인자 `iWaitTimeSeconds = 20`(호출부가 덮지 않는다) 와
`CRT.Yeolim.SQSMonitorService/FoxConfigurationSQSMonitor.config:11` 의 `MaxMsgCntAtATime=10`.

### 부분 5건 (단서 보강)

| id | 메모 인용 | 보강 |
|---|---|---|
| C07 | `PitStopConfiguration.cs:16` 로 「스키마 22 / BestEffort」 | `:16` 은 `VersioningStrategy=BestEffort` 뿐. 스키마 22 의 근거는 같은 파일 `:289`·`:307` |
| C10 | `ProcessOptions.cs:12-58` 을 「불리언」이라 함 | 그 클래스는 컨테이너다 — `CutSize`·`ArtSize` + `FontOptions`·`ChangeColorToCMYK`·`PageOptions`·`EtcOptions`·`WaringOptions` 5종. 불리언은 중첩 클래스 안에 있다 |
| C11 | 선택 블록 `CRT.Yeolim.ServerProcess/Program.cs:782-943` | 선언은 `:780`, 블록 뒤 `:945` 에 무조건 수행 `SyncCropBoxAndTrimBox` 가 이어진다(옵션과 무관한 고정 액션이 하나 더 있다) |
| C13 | 액션 enum `CRT.Yeolim.ServerProcess/Common/ActionsSetList.cs:82-113` | 멤버는 `:82-111`(`None` 포함 23종), `:112-113` 은 닫는 괄호 |
| C39 | 「결과 복사 → STAT_050」 | 기본은 **STAT_040**(`CRT.Yeolim.ServerProcess/Program.cs:424`)이고 `bucketNm` 이 비었을 때만 STAT_050(`:425-428`). 「검판용」도 하드코딩이 아니라 appSetting `PostfixForOutoutFileName`(`CRT.Yeolim.ServerProcess/FoxConfigurationServerProcess.config:10`) |

메모가 「코드만으로는 알 수 없다」고 적은 `FileSystemWatcher` 0건은 재확인했다 — 저장소 전체에
`FileSystemWatcher`·`ServiceBase`·`Topshelf`·`TaskScheduler` **0건**. 핫폴더를 감시해 exe 를 띄우는 주체는
여전히 저장소 밖이다.

## 3. ② 메모가 얕게 본 곳 — 보강

### 3-1. PitStop 호출은 3단계 × 2판본 = 6지점, 전부 같은 모양

살아있는 `-config` 호출 6건: `CRT.Yeolim.ServerProcess/Program.cs:655`·`:1038`·`:1244` ·
`CRT.Yeolim.ServerProcess.HotFolder/Program.cs:634`·`:1070`·`:1276`. 메모의 「6회 반복」은 정확하다.
양쪽 저장소에 **`ProgramOld.cs` 죽은 사본**이 한 벌씩 더 있어(`CRT.Yeolim.ServerProcess/ProgramOld.cs` ·
`CRT.Yeolim.ServerProcess.HotFolder/ProgramOld.cs`) grep 하면 같은 줄이 6건 더 나온다 — 인용할 때 구분해야 한다.

| 단계 | 하는 일 | 액션리스트 | 변수세트 | 조건 |
|---|---|---|---|---|
| PitStop01 | 문서 구조 검사 | 고정 1종(`CheckDocumentStructureProblems`) | 없음 | 무조건 |
| PitStop02 | 본 처리 | 옵션 JSON 으로 조립(+고정 `SyncCropBoxAndTrimBox`) | **있음** | 무조건 |
| PitStop03 | 폰트 플래튼 | 플래튼 액션 | 없음 | 폰트 미임베드 **그리고** 옵션 켬 |

근거: `CRT.Yeolim.ServerProcess/Program.cs:554`(PitStop01)·`:580-583`(고정 액션)·`:753`(PitStop02)·
`:1019`(변수세트)·`:191`(PitStop03 조건).

### 3-2. `ServerProcess.HotFolder` 판 — DB 를 한 줄도 안 쓴다 (가장 값진 선례)

`CRT.Yeolim.ServerProcess.HotFolder/Program.cs`(1389줄)는 SQS 판(1357줄)과 같은 3단계 구조인데
**DB 호출이 전부 주석**이다: `CJobLog` 가 나오는 7곳(`:294`·`:352`·`:436`·`:458`·`:712`·`:1142`·`:1348`)이
모두 `//` 로 죽어 있고, 살아있는 `CJobLog` 호출은 **0건**(검산 P5 재계산).

대신 **인자로 모든 것을 받는다** — `CRT.Yeolim.ServerProcess.HotFolder/Common/AppArguments.cs:20-49`:

| 인자 | 뜻 |
|---|---|
| `-i/--in` (필수) | 처리할 PDF 경로 |
| `-c/--config` (필수) | **옵션 JSON 파일 경로** — PitStop XML 이 아니라 `ProcessOptions` 직렬화본 |
| `-o/--out` (필수) | 출력 디렉터리 |
| `-r/--original` | 원본 보관 디렉터리 |
| `-m/--min` · `--showPagesInfoInEnfocusReport` · `--hideDateInOutputDir` | 표시 옵션 |

JSON 은 실행 시점에 읽어 역직렬화한다(`CRT.Yeolim.ServerProcess.HotFolder/Program.cs:103`).
`JobId` 도 DB id 가 아니라 **파일명 규약**에서 뽑는다 — `yyMMdd_코드_…` 두 토큰을 이어 붙인다
(`CRT.Yeolim.ServerProcess.HotFolder/Common/AppArguments.cs:66-99`, 주석 예시 `250218_A0034_[문학동네]_[여유내지].pdf`).
SQS 판의 규약(숫자 jobId 접두 `Split('_')[0]`, `CRT.Yeolim.ServerProcess/Common/AppArguments.cs:57`)과 **다르다.**

결과도 DB 가 아니라 파일로 낸다. 판정 3갈래는 기계 규칙이다 — 오류>0 이면 `오류`, 경고>0 이면 `주의`,
아니면 `정상`(`CRT.Yeolim.ServerProcess.HotFolder/Common/AppReturnValue.cs:274-288`), 그 문자열이
`{이름}_레포트_{정상|주의|오류}.json` 과 `.pdf` 파일명에 박힌다
(`CRT.Yeolim.ServerProcess.HotFolder/Program.cs:510-521`).

HotFolder 판만 가진 것 둘 더: **원본 파일 보관 폴더 이동**(`:467`) 과 리포트 항목 상한
`MaxReportedNbItemsPerCategory`(프레임워크 기본 50 → 설정 500 으로 올림 ·
`CRT.Framework.Pitstop/PitStopConfiguration.cs:56`, `CRT.Yeolim.ServerProcess.HotFolder/Program.cs:743`·`:1030`).

### 3-3. 액션 카탈로그는 두 판본이 다르다

| | 액션 enum(`None` 포함) | `PitStopAction_` 설정 |
|---|---:|---:|
| `CRT.Yeolim.ServerProcess` | 23 | 22 |
| `CRT.Yeolim.ServerProcess.HotFolder` | 26 | 25 |

HotFolder 판에만 있는 3종: `ConvertRemoveOverPrintWhiteObject` · `CheckObjectCloseToPageOuter` ·
`CheckInkCoverage`(`CRT.Yeolim.ServerProcess.HotFolder/FoxConfigurationServerProcessHotFolder.config`).
뒤 둘은 책자 현장용이다 — `CheckObjectCloseToPageOuter` 가 §2 의 제본 방향 파일명 토큰
(`CRT.Yeolim.ServerProcess.HotFolder/Utils/ObjectCloseToPageOuter.cs:11-57`)과 짝을 이룬다.
**`.eal`/`.evs` 실물은 저장소에 0개**이고 설정은 전부 개발자 PC 의
`…\Enfocus Prefs Folder\Action Lists\한영문화사\` 를 가리킨다(메모 §5 재확인).

### 3-4. `PitStopConfig` · `RunPitstopCLI` — 최소 완결 예제 둘

- `RunPitstopCLI/Form1.cs`(184줄)가 **한 화면에 전 구간**을 담고 있다: 변수세트 로드·치환(`:114-119`) →
  `Configuration` 조립(`:125`) → `config.Save`(`:164`) → `-config` 인자(`:168`) → `CommandLine.Execute`(`:170`)
  → `EnfocusReport.Deserialize`(`:174`). 후니가 PoC 를 만들 때 그대로 베낄 수 있는 유일한 파일이다(값은 하드코딩).
- `PitStopConfig/Form1.cs`(76줄)는 설정 XML 생성만 시험한다(`:54` `config.Save`). 여기서만
  `SmartPreflight.VariableSet` 을 직접 넣어 본다(`:46`).

### 3-5. PDF 도구 8종은 파이프라인 단계가 아니다

`SaveAsErrorPdf`·`PdfClearMargin`·`PdfResize`·`PdfBarcodeWriter`·`FoxitSaveAs`·`MergePdfs`·`AddMarginPdf`·
`UnEmbededFontList` — 저장소 전체 grep 결과 **파이프라인에서 이들 exe 를 부르는 곳이 0건**이다(각 프로젝트
자기 파일·로그 설정 외 호출 없음). 워커의 후처리는 별도 exe 가 아니라 자체 라이브러리 직접 호출이다
(`CRT.Yeolim.ServerProcess/Program.cs:235` `PDFLibHelper.ResizePdf` · `:293` `PDFLibHelper.ClearMargin`).
즉 이 8종은 **운영자·개발자용 독립 유틸리티**다.

그중 둘은 **후니가 절대 따라 하면 안 되는 방식**이다 — `CRT.Yeolim.SaveAsErrorPdf/Program.cs:166-172` 와
`FoxitSaveAs/Form1.cs:71-77` 이 Win32 `FindWindow`/`FindWindowEx`/`SetForegroundWindow` 로
**Foxit GUI 창을 원격 조작**한다. 무인 서버에서 포커스·창 제목에 의존하는 자동화는 조용히 깨진다.
(별건으로 `CRT.Framework.Barcode/ZXingHelper.cs:58`·`:142` 는 외부 `magick` CLI 에 의존한다 — 메모에 없던 의존성.)

### 3-6. `USP_JOB_*` 호출 목록과 「상태는 로그로 전이한다」

저장소 전체 `USP_` 인용 32건 중 `USP_JOB` 인용 14건 — 살아있는 호출 13건(12건이 `CRT.Yeolim.Data/Dac/OrderDac.cs`, 1건이 `CRT.Yeolim.Data/Dac/StatisticDac.cs`):

| 프로시저 | 줄 | 쓰임 |
|---|---|---|
| `USP_JOB_JOB_GRP_C` | `:25` | 작업 그룹 생성 |
| `USP_JOB_JOB_C` | `:53` | **작업 행 생성**(STAT_010 · 두 JSON 동결) |
| `USP_JOB_JOB_D` | `:61` | 작업 삭제 |
| `USP_JOB_JOB_S` / `_S2` | `:75` / `:84` | 목록 조회 2종 |
| `USP_JOB_LOG_C` | `:121` | **상태 전이 전용 창구** |
| `USP_JOB_LOG_S` | `:130` | 로그 조회 |
| `USP_JOB_PRCS_OPT_CU` / `_D` / `_S` | `:154` / `:164` / `:173` | 옵션 프리셋 CRUD |
| `USP_JOB_JOB_DEBUG_S` | `:182` | 디버그 조회 |
| `USP_JOB_JOB_GRP_NOTI_S` | `:191` | 완료 토스트 원천 |
| `USP_JOB_STATISTIC01_S` | `StatisticDac.cs:31` | 통계 |

**구조적 사실**: 상태 전용 UPDATE 는 죽어 있다 — `OrderDac.cs:133-143` 의 `UJobStatus` 가 `return -1` 로
즉시 빠지고 `USP_JOB_STATUS_U` 호출은 `:142` 주석이다. STAT_010 을 뺀 **모든 상태 전이가
`USP_JOB_LOG_C`(로그 삽입)로만 일어난다.** 사용자 취소도 같다(`CRT.Yeolim.Module.Order/FrmOrder.cs:421`).
즉 상태는 테이블 컬럼이 아니라 **추가 전용 로그의 최신 행**이다. 로그 삽입 시 단계 산출물도 같이 실린다 —
`PITSTOP_CONFIG`·`VARIABLE_SET`·`PITSTOP_REPORT` 3컬럼(`OrderDac.cs:112-117`, 있을 때만 붙임).

### 3-7. 워커 동시성 — 메모의 「워커 4개가 사실상 상한」은 정정이 필요하다

`CRT.Yeolim.SQSMonitorService/Program.cs`(194줄)는 **상주 서비스가 아니다.** 루프가 없고 SQS 를 한 번
받아(`:109-110`) 처리하고 끝난다(`:177` "종료!!"). 따라서 이것도 저장소 밖의 무언가가 반복 기동해야 한다
— §2 의 핫폴더 감시자 부재와 같은 공백이다.

동시성은 **두 층**인데 둘 다 PitStop 동시 실행 수를 묶지 못한다:

1. **프로세스 수**: `Process.GetProcessesByName(...).Length > ExecuteProcessCnt` 이면 종료
   (`CRT.Yeolim.SQSMonitorService/Program.cs:41-46`, 설정 `ExecuteProcessCnt=4`
   `FoxConfigurationSQSMonitor.config:15`). 비교가 `>` 라 **4개가 아니라 최대 5개**가 공존한다(off-by-one).
2. **프로세스 안**: 받은 메시지마다 `Task.Run` 을 만들어 전부 동시에 띄우고 `Task.WhenAll` 로 기다린다
   (`CRT.Yeolim.SQSMonitorService/Program.cs:116-175`). 상한은 `MaxMsgCntAtATime=10` 뿐 — **내부 동시성 제한이 없다.**

곱하면 최악 **5 × 10 = 50개의 `ServerProcess.exe`** 가 동시에 돌고, 각자 PitStop CLI 를 3회까지 부른다.
PitStop 라이선스 동시 실행 한도를 넘길 구조다. 메모의 「4개가 사실상 상한」은 이 두 층을 합쳐 읽은 결과로 보이며,
코드 근거로는 성립하지 않는다.

**추가 결함(메모에 없음)**: 그 병렬 블록 안에서 캡처 변수 `savePdfFileDirectory` 자체를 재대입한다
(`CRT.Yeolim.SQSMonitorService/Program.cs:120-121`). 동시 실행되는 태스크가 같은 변수를 겹쳐 덮어
`…/2026-09-19/2026-09-19/…` 처럼 날짜가 중첩된 경로가 만들어질 수 있다.

메모가 적은 결함 둘은 그대로 확인됐다 — 실패 시 SQS 메시지를 지우지 않아 작업 전체가 재실행되고
(`:109` `bDeleteMsgOnSuccess: false` + `:155` 성공 시에만 `DeleteMessageAsync`), 멱등 가드는 없다.
타임아웃은 PitStop 단계 1800초(`CRT.Yeolim.ServerProcess/FoxConfigurationServerProcess.config:52`) ·
바깥 워커 2400초(`FoxConfigurationSQSMonitor.config:13`), **재시도 없음**.

## 4. ③ 후니 결정 사슬에 붙이는 사실

> 반복: 아래는 **열림 선례의 유무**일 뿐 후니 구현 상태가 아니다. 후니 pitstop 23행 `status` 는 그대로다.

### STD-ART-034 — 「핫폴더 vs CLI」: 열림 선례는 이 질문에 답하지 않는다

**열림은 둘 다 만들었고, 둘 다 CLI 다.** `CRT.Yeolim.ServerProcess.HotFolder` 의 「HotFolder」는 Enfocus
제품의 핫폴더 기능이 아니라 **자체 exe 이름**이고, 내부는 SQS 판과 똑같이 `PitStopServerCLI.exe -config`
를 3회 부른다(§3-1 의 6지점). Enfocus 핫폴더 API·SDK 바인딩은 저장소에 0건이고, `.ppp` 프리플라이트
프로파일도 쓰지 않는다(`PreflightProfile = String.Empty` · `CRT.Yeolim.ServerProcess/Program.cs:636`).

선례에서 **실제로 갈린 축은 「PitStop 을 어떻게 부르나」가 아니라 「작업 지시를 어디서 받나」**다:

| | A · SQS 판 (`CRT.Yeolim.ServerProcess`) | B · 파일 판 (`…ServerProcess.HotFolder`) |
|---|---|---|
| 입력 | S3 이벤트 → SQS → 다운로드 | 파일 경로 인자 `-i` |
| 옵션 출처 | DB `SETTING_JSON`(주문 시점 동결) | **JSON 파일 인자 `-c`** |
| 작업 식별 | DB `jobId` = 파일명 숫자 접두 | 파일명 규약 `yyMMdd_코드` |
| 상태·결과 | DB 로그(`USP_JOB_LOG_C`) + 클라이언트 그리드 | **파일**(`_레포트_{정상\|주의\|오류}.json/.pdf`) |
| DB 결합 | 있음 | **0** |

→ 후니가 STD-ART-034 를 정할 때 선례가 주는 선택지는 **A(큐+DB) / B(파일+JSON 인자)** 이고,
「핫폴더냐 CLI 냐」는 애초에 배타적 선택이 아니다. 결정 문장을 그 축으로 다시 쓰는 편이 정확하다.
B 는 webadmin 이 옵션 JSON 을 파일로 떨구고 exe 를 부르면 되므로 **PitStop 서버가 후니 DB 를 전혀 모르게**
만들 수 있다 — 후니 쪽 결합면이 가장 얇은 선례다.

### STD-ART-035 네 갈래 — 갈래별 선례 유무

| 갈래 | 선례 | 실독 근거 |
|---|---|---|
| **상품별 프로파일** | **없음** (상품 개념 자체가 없다) | 열림은 상품코드가 아니라 **작업별 옵션 불리언**으로 액션을 고른다(`CRT.Yeolim.ServerProcess/Program.cs:782-945`). 부분 선례는 **enum→appSetting 카탈로그 방식**(`CRT.Yeolim.ServerProcess/Common/ActionsSetList.cs:55-70`)과 PDF 실측 기반 2건(폰트 미임베드 `:784` · TrimBox `:884`). `.eal`·`.evs` 실물 0개 → **후니용은 새로 작성해야 한다**(작업량이 PitStop 에서 프로파일을 만드는 쪽에 있다) |
| **S3↔서버 파일 이동** | **있음(A 판 전 구간)** | 업로드 `Original/yyyy-MM-dd/{jobId}_{이름}.pdf`(`CRT.Yeolim.Module.Order/FrmOrderNew3.cs:407-417`) → S3 이벤트→SQS(저장소 밖) → 다운로드(`CRT.Yeolim.SQSMonitorService/Program.cs:136`) → 최종 폴더 복사(`CRT.Yeolim.ServerProcess/Program.cs:404-441`). **결함 동반**: `publicRead: true`(`FrmOrderNew3.cs:416`)·크기/MIME 검사 없음·DB 행 생성 후 업로드 실패 시 보상 삭제 없음. B 판은 S3 없이 로컬 파일만 다룬다 |
| **결과 표시** | **있음 · 두 가지** | (A) DB 컬럼 `RPT_DESC_WARN/FIX/FAIL/ERR/NCRI` → 클라이언트 그리드 4개(`CRT.Yeolim.Module.Order/FrmOrder.cs:634-637`) + 완료 토스트(`:818-840`). (B) 파일 리포트 + 기계 판정 3갈래(`CRT.Yeolim.ServerProcess.HotFolder/Common/AppReturnValue.cs:274-288`). 판정 입력은 리포트 XML 5범주(`CRT.Framework.Pitstop/EnfocusReport.cs:66-162`) + 종료코드 + 출력 실재(`CRT.Yeolim.ServerProcess/Program.cs:676-680`) |
| **대용량 테스트** | **부분** | 있는 것: S3 멀티파트 업로드 · 타임아웃 1800/2400초 · 리포트 항목 상한 500(`CRT.Yeolim.ServerProcess.HotFolder/Program.cs:743`). **없는 것**: 재시도, 멱등 가드, 동시 실행 한도(§3-7 — 최악 50 동시), 업로드 크기 상한. → 후니의 대용량 작업량은 **선례를 베끼는 쪽이 아니라 선례에 없는 안전장치를 새로 넣는 쪽**에 있다 |

### STD-ART-033(일정) 으로 가기 전에 남는 공백

열림 코드로도 못 메우는 것 3가지 — 후니에서 새로 정해야 한다: ① 기동 주체(감시자·스케줄러가 저장소 밖) ·
② PitStop 종료코드의 의미와 라이선스 동시 실행 한도 · ③ **PitStop→MES 인계**(선례 0 — `CRT.Yeolim.IF` 는
WCF 서비스 계약일 뿐이고, 유일한 흔적은 리포트 어셈블리 네임스페이스 공유
`CRT.Yeolim.ServerProcess.HotFolder/Program.cs:24`). 메모 §7·§8 의 이 판단은 실독으로 유지된다.

## 5. 검산 — 실행한 명령과 출력

```
$ python3 t53/verify.py
P3 인용 실재 검사 55건 · P4 verdict 근거 검사 59건
P5 재계산: 액션 enum(ServerProcess)=23 · 액션 enum(HotFolder)=26 ·
           PitStopAction_ 설정(ServerProcess)=22 · PitStopAction_ 설정(HotFolder)=25 ·
           CLI -config 호출(살아있는 코드)=6 · HotFolder CJobLog(주석 아닌 것)=0 ·
           SmartPreflight 대입(주석 아닌 것)=2 · USP_ 인용(저장소 전체)=32 ·
           USP_JOB 계열(주석 포함 인용)=14 · PDF 도구 exe 호출부=0
판정 분포: 부분 5 · 어긋남 2 · 일치 48
PASS P1~P6
```

게이트: **P1** 메모 인용 55건 전수 수록(id 연번) · **P2** 판정 3분류 전수 · **P3** 인용 파일·행이 대상
저장소에 실재 · **P4** 이 문서가 댄 `path:line` 근거 59건 전수 실재(짧게 적힌 인용은 basename 으로
해석하고, 동명 파일이 둘 이상이면 **FAIL** 시켜 전체 경로로 고치게 한다 — 실제로 이 게이트가 초판의
짧은 인용 4건을 잡아 교정했다) · **P5** 본문이 적은 전수 수치 10종을 검산기가 대상 저장소에서 다시
세어 대조(주석·`ProgramOld.cs` 사본을 걸러 낸다) · **P6** 자격증명 값이 산출물에 전사되지 않음(§6).

## 6. 자격증명 — 위치만 (값 전사 0)

메모 §6 의 3곳을 재확인했고 **값은 옮기지 않았다.** `t53/verify.py` 의 P6 가 이 카드 산출물 전체를
매번 다시 훑어 값이 새어 들어가면 FAIL 한다.

- `CRT.Yeolim.SQSMonitorService/FoxConfigurationSQSMonitor.config:8-9` — AWS 액세스키·시크릿키가 평문으로 커밋
- `FtpTlsTest/Form1.cs:24` — FTP 계정이 생성자 인자에 평문
- `CRT.Yeolim.Main/FrmLogin.cs:173-180` — 로그인 응답이 사용자별 FTP 4종·AWS 3종 자격증명을 내려준다

같은 config 에 SQS 큐 URL 과 AWS 계정번호도 평문으로 있다(`:10`). 후니로 옮길 때 이 배치 자체를 따라가면 안 된다.

## 7. 한계 — 이 카드가 확정하지 못한 것

1. **실행·빌드 0** 이므로 「코드가 이렇게 쓰여 있다」까지만 사실이다. 실제 운영에서 그 경로가 도는지,
   `.eal` 이 무엇을 검사하는지는 확인하지 못했다(저장소에 `.eal`·`.evs` 0개).
2. **저장소 밖 3가지**(핫폴더 감시자 · SQS 가시성 타임아웃/DLQ · 저장 프로시저 본문)는 여전히 공백이다.
3. `ProgramOld.cs` 죽은 사본 두 벌이 있어 grep 인용 시 살아있는 `Program.cs` 와 반드시 구분해야 한다.
   이 문서의 모든 인용은 살아있는 쪽만 쓴다(검산 P5 가 주석·사본을 걸러 다시 센다).
4. 동시 진행 카드 t54(후니 MES 수신 이음매) · t55(두 저장소 뼈대 대조)의 발견은 **인용하지 않았다** —
   계약 보충 4 에 따라 교차 사실은 인용하는 쪽이 직접 확인해야 하고, 이 카드는 그럴 시간을 쓰지 않았다.

## 8. 산출물

| 파일 | 내용 |
|---|---|
| `t53/verdict.md` | 이 문서(완료 신호) |
| `t53/recheck.csv` | 메모 인용 55건 재대조 원장(정본) |
| `t53/verify.py` | 6게이트 검산기(대상 저장소 읽기전용) |
