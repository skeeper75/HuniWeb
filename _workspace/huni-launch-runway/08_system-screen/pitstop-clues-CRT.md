# PitStop Server 연동 단서 — CRT.DigitalEdit.V2 (열림PnP 납품본) 실독 정리

- 작성: 260919 · 리드 lane-1 · 지니 요청 · 읽기전용 탐색(Explore 에이전트, 도구 44회) 결과를 리드가 정리
- 대상 저장소: `/Users/innojini/Dev/CRT.DigitalEdit.V2` (C# · .NET Framework 4.7.2) — 아래 경로는 모두 이 저장소 기준 상대경로
- 소비처: t50(mes+edicus+pitstop) `integrate` 행 설계 참고, t51 프로세스 구조도의 PitStop 구간

## 0. 읽기 전에 [HARD]

1. **타 고객(열림PnP) 납품 코드다. 후니 구현이 아니다.** 후니 원장 행의 `status` 근거로 쓰지 않는다 — pitstop 행은 `미착수`/`미확인` 그대로 둔다. 여기서 가져갈 것은 「PitStop Server 를 코드로 부르는 방법」과 「업로드→처리→회신 구간을 어떻게 나누는가」다.
2. **줄번호는 재확인 후 인용한다.** 리드가 7건을 표본 재대조했다: 5건 정확 일치, 1건은 5줄 어긋남(`AppArguments.cs` JobId 파싱 — 보고 `:52` · 실제 `:57`), 1건(`FileSystemWatcher` 0건)은 grep 재실행으로 확인. 나머지 인용은 **리드 미검증**이다.
3. 자격증명 값은 옮기지 않았다. 위치만 기록한다(§6).

## 1. 핵심 — PitStop Server 를 부르는 방법은 하나다

**CLI 실행파일 + 생성한 설정 XML.** SDK·API 바인딩 없음, Enfocus 핫폴더 미사용, `.ppp` 프리플라이트 프로파일 미사용.

| 항목 | 사실 | 근거 |
|---|---|---|
| 실행파일 | `PitStopServerCLI.exe` (설정값: `…\Enfocus PitStop Server 23\`) — appSetting `PitStop_ExeFileName` | `CRT.Yeolim.ServerProcess/Common/ActionsSetList.cs:19` · `FoxConfigurationServerProcess.config:20` |
| 인자 | **플래그 하나** ` -config "<설정 XML 경로>"` | `CRT.Yeolim.ServerProcess/Program.cs:654-655` (리드 확인) — 동일 블록 6회 반복 |
| 프로세스 실행기 | stdout/stderr 리다이렉트 · `ExitCode==0` 이면 성공 · 타임아웃 시 실패 문자열 | `CRT.Framework.Utils/CommandLine.cs:13-86` |
| 설정 XML 생성기 | 타입 직렬화기. 루트 `Configuration`, 네임스페이스 `…/PitStop/22/PitStopServerCLI_Configuration.xsd` | `CRT.Framework.Pitstop/PitStopConfiguration.cs:289` (리드 확인) · `Save()` `:303-315` |
| 버전 어긋남 | 코드 스키마는 **22**, 설치본은 **23**. `VersioningStrategy=BestEffort` 로 넘긴다 | `PitStopConfiguration.cs:16` |

설정 XML 에 채우는 것(정본 블록 `Program.cs:607-649`): `Process@TaskID`(=jobId) · `InputPDF/InputPath` · `OutputPDF/OutputPath` · `Reports/ReportXML/ReportPath` · `Mutators/ActionList[]`(`.eal` 절대경로, **XML 순서대로 실행**) · `Mutators/PreflightProfile`(항상 빈 값 — `:636` 리드 확인) · `SmartPreflight/VariableSet`(`.evl`) · `Fonts/AdditionalFolder` · `MeasurementUnit=Millimeter`.

## 2. 입력 — 무엇을 어떤 규칙으로 고르나

- **액션리스트(`.eal`)가 전부다.** 프리플라이트도 액션리스트로만 한다.
- **선택 규칙은 상품코드가 아니라 작업별 옵션 JSON**이다. 업로드 화면에서 운영자가 고른 불리언(`ProcessOptions`)이 DB 에 `SETTING_JSON` 으로 얼려지고, 워커가 그걸 읽어 불리언마다 `.eal` 하나를 더한다 — `CRT.Yeolim.Objects/ProcessOptions.cs:12-58` · 선택 블록 `ServerProcess/Program.cs:782-943`.
- 액션 카탈로그는 **enum → appSetting 키** 규약: `PitStopAction_{EnumActionType}` — `ActionsSetList.cs:55-70`, enum `:82-113`.
- 옵션이 아니라 **PDF 실측으로 갈리는 것 2건**: 폰트가 전부 임베드되지 않았을 때만 `AddBackground`(`:784-788`), TrimBox 가 있을 때만 `RemovePrinterMarks`(`:884-885`).
- **변수 세트**: `.evs` 템플릿에 값을 치환해 `.evl` 로 저장 후 참조 — 치환기 `CRT.Framework.Pitstop/VariableSet.cs:28-49`. 넣는 변수: `01_TargetCyan`~`04_TargetBlack` · `DPI` · `CloseObjectDistance` · `ResampleDpi`(`Program.cs:976-982`). HotFolder 판은 `InkValue`·`InkIgnoreAreaPt`·홀짝 여백 8종 추가.
- **파일명에 박은 현장 규칙**(HotFolder 판): `#좌철#/#우철#/#상철#/#하철#` 토큰으로 제본 방향을 읽고 8쪽 이하면 무시 — `ServerProcess.HotFolder/Utils/ObjectCloseToPageOuter.cs:11-57`.

## 3. 결과 판정 — 신호 셋을 합친다

1. **종료코드** — 0 이 아니면 실패(`CommandLine.cs:67-74`). 어떤 코드가 「프리플라이트 오류」이고 어떤 코드가 「크래시」인지는 구분하지 않는다.
2. **출력 PDF 실재 확인** — 성공이어도 파일이 없으면 실패로 내린다(`Program.cs:676-680`).
3. **리포트 XML 해석** — `CRT.Framework.Pitstop/EnfocusReport.cs:11-163`. 건수(`warnings/fixes/errors/criticalfailures/noncriticalfailures`)와 항목별 `Message`·`Location[@page,@minX…]`·`@ActionID`. `Failures`/`Errors` 가 하나라도 있으면 작업 오류(`STAT_900`).

- 타임아웃: PitStop 단계 1800초 · 바깥 워커 2400초. **재시도 없음.**
- 리포트 문구는 DB 컬럼(`RPT_DESC_WARN/FAIL/FIX/ERR/NCRI`)으로 저장돼 클라이언트 그리드 4개에 뜬다 — `Module.Order/FrmOrder.cs:634-637`.
- HotFolder 판은 DB 대신 **리포트 파일**을 낸다: `{이름}_레포트_{정상|주의|오류}.json` 과 `.pdf` — `HotFolder/Program.cs:510-521`.

## 4. PDF 업로드 → PitStop 처리 → 회신 (지니가 짚은 구간)

**웹 업로드 엔드포인트는 없다.** `CRT.Yeolim.Web` 은 WCF SOAP 뿐이고 스트림/업로드 오퍼레이션이 0건이다. 업로드는 **윈폼 클라이언트가 S3/FTP 로 직접** 한다.

```
① 클라이언트: PDF 선택 → 로컬 분석(쪽수·크기 균일·폰트 임베드)      FrmOrderNew3.cs:518-519, :674
② DB 행 먼저 생성(jobId 확보) STATUS=STAT_010                      FrmOrderNew3.cs:404 → OrderDac.cs:28-53
     └─ PDF_INFO_JSON + SETTING_JSON(처리 옵션)을 이 시점에 얼린다
③ S3 멀티파트 업로드  key = Original/yyyy-MM-dd/{jobId}_{이름}.pdf   FrmOrderNew3.cs:407-417 (리드 확인)
④ 업로드 완료 표시 STAT_020                                        FrmOrderNew3.cs:420-431
⑤ S3 ObjectCreated 이벤트 → SQS 큐                                  (AWS 쪽 설정 — 저장소에 없음)
⑥ SQS 폴링(20초 롱폴·최대 10건) → 파일 내려받기                     SQSMonitorService/Program.cs:109-110, :136
⑦ 워커 자식 프로세스 실행  -in "<pdf>"                              SQSMonitorService/Program.cs:143-149 (리드 확인)
     └─ jobId 는 메시지가 아니라 **파일명 접두**에서 복원           ServerProcess/Common/AppArguments.cs:57 (리드 정정)
⑧ PitStop01 구조 검사 → ⑨ PitStop02 본 처리(+변수세트) → ⑩ PitStop03 폰트 플래튼(조건부)
                                                                   ServerProcess/Program.cs:554 / :753 / :191
⑪ 후처리(비-PitStop): 리사이즈 · 여백 제거                          Program.cs:235, :293
⑫ 결과 복사  [{jobId}] {이름}_검판용.pdf → STAT_050                 Program.cs:404-441
⑬ 회신: DB 상태·리포트 문구 → 클라이언트 그리드 + 완료 토스트        FrmOrder.cs:634-637, :818-840
```

**업로드와 결과를 잇는 끈은 셋**이다: 파일명 접두 `{jobId}_` · 설정 XML 의 `TaskID=jobId`(리포트에도 찍힘) · 출력 폴더 `…\yyyy-MM-dd\{jobId}\`. 단계마다 `[HHmmss] …_Config.xml / _Report.xml / _VariableSet.evl` 을 남겨 3회 호출을 각각 추적한다(`Program.cs:565-590`).

**상태 기계**

| 상태 | 뜻 | 세팅 주체 |
|---|---|---|
| `STAT_010` | 행 생성(업로드 전) | 클라이언트→DB `OrderDac.cs:47` |
| `STAT_020` | 업로드 완료·처리 대기 | 클라이언트 `FrmOrderNew3.cs:428` |
| `STAT_030` | 처리 중(단계마다 갱신) | 워커 `Program.cs:113` 외 |
| `STAT_040` | 처리 완료·파일 이동 중 | 워커 `Program.cs:363` |
| `STAT_050` | 완료 | 워커 `Program.cs:427`, `:509` |
| `STAT_900` | 오류 | 워커 각 단계 |
| `STAT_999` | 사용자 취소 | 클라이언트 `FrmOrder.cs:407` — **워커가 확인하지 않는다** |

## 5. 후니에 옮길 때 그대로 쓸 수 있는 것 / 버릴 것

**참고 설계로 재사용 가능(고객 결합 없음)**
- `CRT.Framework.Pitstop` 전체 — 설정 XML 작성기 · 리포트 해석기 · 변수세트 치환기. 의존성은 `System.Xml` 뿐.
- `CRT.Framework.Utils/CommandLine.cs` — 종료코드+타임아웃 실행기.
- `CRT.Framework.AWS` — `S3Client` · `SqsClient` · `S3JsonMessage`(S3 이벤트 봉투).
- enum→appSetting 액션 카탈로그 **방식**(내용물은 현장별).
- `RunPitstopCLI/Form1.cs` — 변수세트→설정→CLI→리포트 최소 완결 예제.

**현장 전용(다시 만들어야 함)**
- `.eal` 액션리스트·`.evs` 템플릿 — **저장소에 한 개도 커밋돼 있지 않다.** 설정은 개발자 PC 의 `…\Enfocus Prefs Folder\Action Lists\한영문화사\` 를 가리킨다. 후니용은 PitStop 에서 새로 작성해야 한다.
- 옵션 묶음(`ProcessOptions`) · 상태코드 · `USP_JOB_*` 저장 프로시저 · `검판용` 접미 · 제본 방향 파일명 규약.

**옮기지 말아야 할 결함(코드에서 관측)**
- 업로드 파일을 `publicRead:true` 로 올린다 — 원고가 공개 URL 이 된다(`FrmOrderNew3.cs:412-417`).
- FTPS 인증서 검증을 끈다(`FrmOrderNew3.cs:452-456`).
- 업로드 크기 상한·MIME 검사가 없다.
- 리포트 파일이 없으면 널 참조로 죽는다(`Program.cs:703` 무가드). CLI 뒤 고정 `Sleep(2000)`.
- 실패 시 SQS 메시지를 안 지워 **작업 전체가 재실행**되는데 멱등 가드가 없다(로그 중복).
- DB 행 생성 후 업로드가 실패하면 보상 삭제가 없어 `STAT_010` 에 고인다.

## 6. 자격증명 위치(값 미기재)

- `CRT.Yeolim.SQSMonitorService/FoxConfigurationSQSMonitor.config:8-9` — AWS 키가 평문으로 커밋돼 있음
- `FtpTlsTest/Form1.cs:24` — FTP 계정
- 로그인 응답이 사용자별 FTP/AWS 자격증명을 내려준다 — `CRT.Yeolim.Main/FrmLogin.cs:173-180`

## 7. 코드만으로는 알 수 없는 것

- **핫폴더를 누가 감시해 `ServerProcess.HotFolder.exe` 를 띄우는가** — 솔루션에 `FileSystemWatcher`·서비스·스케줄 정의가 0건(리드 grep 재확인). 저장소 밖.
- `.eal`/`.evs` 의 실제 검사·수정 내용.
- PitStop 종료코드 의미 · 동시 실행 라이선스 한도(설정상 워커 4개가 사실상 상한).
- SQS 가시성 타임아웃·DLQ(큐 쪽 설정) · 저장 프로시저 본문과 DB 스키마.
- FTP 로 올린 작업을 집어 가는 주체 — 저장소에서 못 찾음.
- **PitStop→MES 인계는 이 코드에 없다.** `CRT.Yeolim.IF` 는 WCF 서비스 계약일 뿐 MES/ERP 커넥터가 아니다. 유일한 흔적은 리포트 어셈블리 네임스페이스 `CRT.EasyMES.V2.Module.Reports` 공유(`HotFolder/Program.cs:24`).

## 8. 후니 `integrate` 행으로 옮길 때의 구간 나눔(제안 — status 는 전부 미착수)

| 구간 | A→B | 방식 후보(이 코드 기준) | owner_side 판단 포인트 |
|---|---|---|---|
| 원고 도착 알림 | 원고 저장소→처리 워커 | 저장소 이벤트→큐 폴링 | 워커 쪽 |
| 작업 식별 | 주문/원고→PitStop 작업 | 파일명 접두 + `TaskID` | 업로드 쪽이 규약을 정한다 |
| 처리 규칙 선택 | 주문 옵션→`.eal` 목록 | 옵션 JSON 을 주문 시점에 얼림 | 주문 쪽(후니는 상품·옵션 기반일 가능성 — 미확정) |
| PitStop 호출 | 워커→PitStop Server | CLI `-config` + 설정 XML | 워커 쪽 |
| 결과 판정 | PitStop→워커 | 종료코드 + 출력 실재 + 리포트 XML | 워커 쪽 |
| 결과 회신 | 워커→주문/고객 화면 | 상태·리포트 문구 저장 후 조회 | 주문 쪽 |
| 생산 인계 | 워커→MES | **선례 없음** | 미정 — 후니에서 새로 설계 |
