# t55 — 열림PnP ↔ 후니 MES 뼈대 대조·이식 조건 (사실표)

- 카드: t55 (class C · SPEC 없음 · 조사·문서 · 읽기전용) · 레인: 본 세션 · 작성 260919
- 대상: `/Users/innojini/Dev/CRT.DigitalEdit.V2`(열림PnP 납품본, 이하 **열림**) ·
  `/Users/innojini/Dev/TS.BackOffice.Huni`(후니 MES, 이하 **후니**) — 두 저장소 **Read/Grep 만**, 빌드·실행·쓰기 0
- 산출: `verdict.md`(이 문서) · `facts.csv`(F-01~F-50 사실 원장) · 재현 스크립트 4종 · `inventory.json`·`projmeta.json`·`apidiff.json`
- **결론은 판정이 아니다.** 「옮길 수 있다/없다」를 쓰지 않았다. 「무엇이 같고 무엇이 다른가」만 적는다.

## 0. 이 문서를 읽기 전에 [HARD]

1. **열림은 타 고객 납품 코드다.** 후니 원장 행의 `status` 근거로 쓰지 않는다. pitstop 행은 `미착수`/`미확인` 그대로 둔다.
2. **인용한 `path:line` 은 전부 이 세션에서 직접 열어 확인했다.** 선행 문서 `pitstop-clues-CRT.md` 의
   미검증 인용을 그대로 옮기지 않았다 — 재사용한 5건(`ActionsSetList.cs:19` · `Program.cs:654-659` ·
   `PitStopConfiguration.cs:13`·`:16`·`:289`)은 §6 에 재대조 결과를 적었다.
3. **자격증명 값은 옮기지 않았다.** 설정 키 이름과 파일 위치만 적는다.
4. **날짜 추정 0.** 커밋일은 `git log` 출력 그대로다.
5. **`facts.csv` 가 원장이고 이 문서는 그 읽는 법이다.** 숫자는 `facts.csv` 를 따른다.

---

## 1. ① 공통 CRT.Framework.* 9개 — 차이 규모

### 1-A. 프로젝트 집합 (리드 확인 사항 재실측 = 일치)

| 구분 | 목록 |
|---|---|
| **공통 9** | AWS · Asset · Core · DevExpr · Extensions · PDF · PDF.Objects · Utils · WinForms |
| **열림 전용 4** | Attribute · Barcode · **Pitstop** · Security |
| **후니 전용 3** | JSON · Net · Utils.ZipLib |

리드가 카드에 적은 「공통 9개 · Pitstop 은 열림에만」은 **재실측으로 일치**했다(F-01~F-03).

### 1-B. 파일 단위 규모

| 지표 | 열림 | 후니 |
|---|---|---|
| 공통 9개 `.cs` 파일 수 | 104 | 97 |
| 공통 9개 `.cs` 총 줄수 | 16,213 | 15,825 |
| 같은 이름 · **내용 동일**(md5 일치) | \| 51 \| (양쪽 공통) |
| 같은 이름 · **내용 다름** | \| 36 \| (양쪽 공통) |
| 한쪽에만 있는 파일 | 17 | 10 |

**읽는 법**: 이름이 겹치는 87개 중 **51개(59%)는 바이트 단위로 완전히 같다**. 두 저장소는 같은 뿌리에서
갈라져 나온 사본이고, 절반 이상이 아직 갈라지지 않았다. 프로젝트별 분포는 `filediff.py` 출력에 전수로 있다.

프로젝트별 요약(`inventory.py` 출력):

| project | Y파일 | H파일 | Y줄 | H줄 | 동일 | 변경 | 한쪽 |
|---|---|---|---|---|---|---|---|
| AWS | 5 | 5 | 454 | 743 | 1 | 3 | 2 |
| Asset | 4 | 4 | 439 | 450 | 2 | 2 | 0 |
| Core | 8 | 8 | 648 | 601 | 4 | 4 | 0 |
| DevExpr | 30 | 32 | 5336 | 6057 | 19 | 8 | 8 |
| Extensions | 13 | 13 | 3785 | 3819 | 11 | 2 | 0 |
| PDF | 8 | 8 | 1618 | 1117 | 1 | 5 | 4 |
| PDF.Objects | 14 | 7 | 1178 | 390 | 2 | 5 | 7 |
| Utils | 4 | 6 | 305 | 478 | 2 | 2 | 2 |
| WinForms | 18 | 14 | 2450 | 2170 | 9 | 5 | 4 |

### 1-C. 공개 API 단위 규모

정규식 근사로 `public`/`protected` 타입·멤버를 센다(`apidiff.py`). **완전한 C# 파서가 아니다** —
`.Designer.cs`·`AssemblyInfo.cs` 제외, 한 줄에 선언이 끝나지 않는 형태는 놓칠 수 있다. 자릿수 비교용이다.

| 지표 | 열림 | 후니 |
|---|---|---|
| 공개 타입 수 | 115 | 91 |
| 공개 멤버 수 | 632 | 512 |
| 한쪽에만 있는 공개 타입 | 36 | 12 |

한쪽에만 있는 공개 타입 전수는 `apidiff.json` 에 있다. 성격이 갈리는 대표 4건:

- **AWS** — 열림만 9종(`S3JsonMessage` 이하 S3 원본 이벤트 DTO 일습) / 후니만 1종(`SqsLogSink`)
- **PDF.Objects** — 열림만 12종(`Marks/` 계층 전체 — `IMark`·`MarkText`·`MarkQRBarocde`·`MarkDataMatrixBarocde`·`MarkConvertor`·`BoundingRectangle`·`Pages`) / 후니만 0종
- **WinForms** — 열림만 6종(우편번호 조회 `FrmZipCode`·`ZipCodeRest`·`ZipCodeResult` 일습) / 후니만 0종
- **DevExpr** — 접두만 갈렸다: `CPSContextMenu`/`CPSGlobalColor`/`CPSMaskType`(열림) ↔ `CRTContextMenu`/`CRTGlobalColor`/`CRTMaskType`(후니). 파일 줄수가 82줄로 같다(F-16)

### 1-D. 어느 쪽이 최신인가 — **후니**

| 지표 | 열림 | 후니 |
|---|---|---|
| 저장소 총 커밋 수 | **18** | **244** |
| 공통 9개 프로젝트 최종 커밋일 | 8개가 **2025-02-02 「초기 커밋.」** · PDF.Objects 만 2025-04-09 | **2026-02-19 ~ 2026-09-01** |
| 저장소 최종 커밋 | 2025-04-24 | 2026-09-16 |

공통 9개 **전부** 후니 쪽 최종 커밋이 더 늦다. 열림 저장소의 프레임워크는 2025-02-02 초기 임포트 이후
사실상 정지해 있고(PDF.Objects 1건만 2025-04-09), 후니 쪽은 계속 수정되고 있다 — AWS 는 2026-07-23,
DevExpr·Utils 는 2026-09-01.

**단, 이 판단의 한계**: 열림 저장소는 **납품 스냅샷**이라 커밋 18건이 벤더의 실제 개발 이력이 아닐 수 있다.
「후니 저장소 안의 사본이 더 최근에 손질됐다」는 사실이고, 「열림 제품이 더 낡았다」는 이 데이터로 말할 수 없다.

패키지 버전은 **한 방향이 아니다**: AWSSDK 는 열림이 더 높고(Core 3.7.401.4 vs 3.7.303.18),
`System.Text.Json` 등 전이 의존은 후니가 더 높다(10.0.3 vs 7.0.3)(F-36).

> **함정 주의 (F-50)**: 후니 `Framework/` 12개 중 **8개의 `packages.config` 가 md5 `078435635886cf070ccb2b271e298a0c` 로 완전히 같다.**
> 프로젝트별 실제 의존이 아니라 복사된 공용 목록이다. `projmeta.py` 의 「패키지 차이」 출력에서
> `Y=- H=Magick.NET…` 류가 대량으로 뜨는 것은 이 보일러플레이트 때문이며, **의존성 차이로 읽으면 안 된다.**

---

## 2. ② `CRT.Framework.Pitstop` + `Utils/CommandLine.cs` 이식 조건

### 2-A. 대상 프레임워크 — 같다

양쪽 전 프로젝트가 `<TargetFrameworkVersion>v4.7.2`, 구형 MSBuild csproj(비 SDK-style) + `packages.config`.
형식 변환이 필요한 자리는 없다(F-20·F-21).

### 2-B. NuGet 의존 — 선언과 실사용이 다르다

`CRT.Framework.Pitstop.csproj` 가 **선언**하는 것은 둘이다.

- `Newtonsoft.Json 13.0.3` (`packages.config` · csproj `:36-38`)
- `ProjectReference ..\CRT.Framework.PDF\CRT.Framework.PDF.csproj` (csproj `:63-66`)

그런데 **소스 4파일이 실제로 쓰는 것은 BCL 뿐이다**:

- `grep "CRT\." CRT.Framework.Pitstop/*.cs` → **0건** (CRT 타입 참조 없음)
- `grep "^using"` → 전부 `System.*` (`Xml.Serialization` · `Xml` · `Xml.Linq` · `Xml.XPath` · `IO` · `Linq` · `Text` · `Collections.Generic` · `Threading.Tasks`)
- Newtonsoft 네임스페이스 using 0건 · `JsonProperty` 등 사용 0건 — 직렬화는 전부 `System.Xml.Serialization`

즉 **선언된 두 의존 모두 소스에서 미사용**이다. 실제로 옮겨야 하는 것은 4파일 753줄이다(F-19·F-23·F-24):

| 파일 | 줄 | 역할 |
|---|---|---|
| `PitStopConfiguration.cs` | 318 | 설정 XML 타입 직렬화기 (`Configuration.Save()`) |
| `EnfocusReport.cs` | 289 | 리포트 XML 파서 (warnings/fixes/errors/failures + Location/ActionID) |
| `PitStopEnums.cs` | 93 | 열거형 |
| `VariableSet.cs` | 53 | `.evs` 템플릿 → `.evl` 치환기 |

후니에도 `Newtonsoft.Json 13.0.3` 이 있으므로(F-22), 참조를 떼든 남기든 버전 충돌은 없다.

### 2-C. `Utils/CommandLine.cs` — **후니에 이미 있다. 그리고 동작이 다르다**

이 카드에서 가장 조심해야 할 사실이다.

| | 열림 (88줄) | 후니 (85줄) |
|---|---|---|
| 시그니처 | `Execute(string exePath, string args, ref string outputString, int timeoutSecond = 300, bool hiddenWindow = false)` | 동일하되 5번째 인자명이 **`windowHidden`** |
| `CreateNoWindow` | **항상 `true`** | **`windowHidden == true` 일 때만 `true`** (기본 `false`) |
| `WindowStyle = Hidden` | `hiddenWindow` 일 때 설정 | 해당 코드 없음 |
| 반환 계약 | `ExitCode==0` → true·stdout / 아니면 false·stderr / 타임아웃 → `"Process Execute TimeOut!!"` | 동일 |

`diff -u` 결과(양쪽 `CRT.Framework.Utils/CommandLine.cs`, 후니 쪽 `:24-25` 에 `// <- key line` 주석):

```
-                process.StartInfo.CreateNoWindow = true;
-                if (hiddenWindow) { process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden; }
+                if (windowHidden)
+                    process.StartInfo.CreateNoWindow = true; // <- key line
```

**이식 조건으로서의 의미 2가지**:
1. 열림의 PitStop 호출부는 5번째 인자를 넘기지 않는다(`Program.cs:659` — 4인자 호출). 열림에서는 창이 안 뜨고,
   같은 호출을 후니 `CommandLine` 으로 하면 **기본값 `false` 라 콘솔 창이 뜬다.** 상주 워커에서는 동작 차이가 된다.
2. 인자 이름이 다르므로 **named argument(`hiddenWindow:`)로 쓴 호출부는 컴파일이 깨진다.** 현재 열림 저장소 안에
   named 호출은 없으나, 옮기는 쪽에서 새로 쓸 때의 함정이다.

즉 **`CommandLine.cs` 는 「옮길 파일」이 아니라 「동작 차이를 확인할 파일」이다.**

### 2-D. 설정(FoxConfiguration) 방식 — 기계는 같고 관습이 다르다

| | 열림 | 후니 |
|---|---|---|
| 진입 | `App.config` `<appSettings><add key="ConfigurationFileName" value="…">` (`ServerProcess/App.config:36`) | 동일 (`ItfLogConsumer/App.config:7`) |
| 읽기 | `FoxConfigurationManager.AppSettings["키"]` (`using TheOne.Configuration`) | 동일 |
| 제공 어셈블리 | `TheOne.4.0` · HintPath `C:\Program Files (x86)\TheOne Technology\NeoDEEX 4.0\Assembly\` (`CRT.Yeolim.ServerProcess.csproj:55-57`) | **같은 어셈블리·같은 절대경로** (`CRT.EasyMES.V2.Console.ItfLogConsumer.csproj:56-58`) |
| 키 명명 | PascalCase — `AwsRegion`·`AwsKey`·`PitStop_ExeFileName` | UPPER_SNAKE — `AWS_REGION`·`AWS_KEY`·`QUEUE_URL` |

메커니즘·빌드 선행조건(NeoDEEX 4.0 설치)은 **같다**(F-29·F-30). 갈리는 것은 키 이름 관습뿐이다(F-31).

### 2-E. 네임스페이스 — 같다

후니 `Framework/` 도 `CRT.Framework.*` 를 그대로 쓴다(리브랜딩 없음). `CRT.Framework.Pitstop` 이
후니 솔루션에서 이름 충돌을 일으킬 자리는 없다(F-25).

### 2-F. **Framework 밖에 남는 것** — 여기가 실제 부피다

`CRT.Framework.Pitstop` 은 XML 직렬화기와 리포트 파서일 뿐이다. 「PitStop 을 부른다」를 성립시키는
오케스트레이션은 **앱 프로젝트에 있고 이식 대상에 포함돼 있지 않다**(F-32):

| 위치 | 줄 | 내용 |
|---|---|---|
| `CRT.Yeolim.ServerProcess/Program.cs` | 1,357 | 3회 호출 흐름(구조검사→본처리→폰트플래튼)·옵션→액션 선택·후처리·상태전이 |
| `CRT.Yeolim.ServerProcess/Common/ActionsSetList.cs` | 113 | 액션 카탈로그. `PitStopAction_{EnumActionType}` appSetting 규약 |
| `CRT.Yeolim.ServerProcess/Common/AppArguments.cs` | 97 | 인자 파싱(파일명 접두에서 jobId 복원) |
| `CRT.Yeolim.ServerProcess/Common/AppReturnValue.cs` | 67 | 반환 규약 |

즉 **753줄을 옮기는 일**과 **PitStop 파이프라인을 세우는 일**은 규모가 다르다. 전자는 파일 복사에 가깝고,
후자는 위 1,634줄의 등가물 + 저장소 밖 자산(§4)이 필요하다.

### 2-G. 호출 계약 (재확인한 사실)

```
CommandLine.Execute(pitStopActionSet.ExeFileName,
                    $" -config \"{configFilePath}\"",
                    ref outputString, executeTimeoutSec)
```
`CRT.Yeolim.ServerProcess/Program.cs:654-659`. 플래그는 `-config` **하나뿐**이다.

설정 XML 의 스키마 좌표(`CRT.Framework.Pitstop/PitStopConfiguration.cs`):
- `:289` — `[XmlRoot(ElementName="Configuration", Namespace="http://www.enfocus.com/PitStop/22/PitStopServerCLI_Configuration.xsd")]`
- `:13` — `Versioning.Version` 기본값 **10**
- `:16` — `VersioningStrategy = BestEffort`
- `:303-315` — `Save(filePath)` (`xsi`·`cf` 네임스페이스를 붙여 직렬화)

**코드 스키마 22 · 설정 파일 기본 Version 10 · 설치본 23** 세 숫자가 서로 다르고 `BestEffort` 로 넘긴다(F-34).

---

## 3. ③ AWS 구성 대조 — 후니는 이미 같은 골격을 돌리고 있다

### 3-A. 구조 — 같다

| 단계 | 열림 | 후니 |
|---|---|---|
| 업로드 | 윈폼 클라이언트가 S3 멀티파트 업로드 | 앱이 S3 업로드 (`S3Client.MultiPartUploadFileAsync` 2종) |
| 이벤트 | S3 객체 생성 → SQS | S3 객체 생성 → **EventBridge** → SQS |
| 소비 | `CRT.Yeolim.SQSMonitorService` 폴링 → 자식 프로세스 실행 | `DesignFileCopyToNas`·`DesignFileThumbnailCreator` 가 `Subscribe<EventBridgeS3Message>` 로 소비 |

「S3 에 올라온 파일을 SQS 로 알려 워커가 집어 처리한다」는 골격은 **후니가 이미 운영 중이다**
(`DesignFileThumbnailCreator/ThumbnailService.cs:135` · `DesignFileCopyToNas/ThumbnailService.cs:85`)(F-37).

### 3-B. 갈리는 지점 4가지

| # | 항목 | 열림 | 후니 |
|---|---|---|---|
| 1 | **이벤트 메시지 형식** | S3 원본 알림 JSON `{Records:[…]}` — `CRT.Framework.AWS/S3JsonMessage.cs:6` (Framework 안) | **EventBridge** 형식 `{detail-type, detail.bucket.name, detail.object.key}` — `DesignFileCopyToNas/Common/EventBridgeS3Message.cs:12` (**앱 프로젝트에 각자 복사**) |
| 2 | **SQS 소비 API** | `GetMessagesAsync` 직접 호출 | `GetMessagesAsync` + `Subscribe` 콜백 폴링 루프(`SqsClient.cs:28`) · `errorAction` 훅 |
| 3 | **SQS 클라이언트 능력** | 5 메서드 | 13 메서드 — 배치 삭제(`DeleteMessageBatch`) · 가시성 변경(`ChangeMessageVisibility`) · 문자열 오버로드 · `Unsubscribe`/`IsListening` |
| 4 | **실패 처리** | 재시도 없음 · DLQ 코드/설정 0 | DLQ 운용 — `huni-itf-trace-log-dlq`(보존 14일 · `maxReceiveCount` 5 · 가시성 120초) · `docs/report/dlq-triage.ps1` · 30분 백오프(`git log` 2026-07-23) |

메시지 형식이 다르다는 것(1)은 **열림의 `S3JsonMessage` 를 그대로 가져와도 후니 큐의 메시지를 못 읽는다**는 뜻이다.
반대도 같다. 둘 중 무엇을 쓸지는 **AWS 콘솔 쪽 설정**(S3 이벤트 알림을 SQS 로 직접 보낼지, EventBridge 를 경유할지)이 정하고,
그 설정은 **두 저장소 어디에도 없다** — 열림 `⑤ S3 ObjectCreated → SQS` 구간은 선행 문서에서도 「AWS 쪽 설정·저장소에 없음」으로 남아 있다.

### 3-C. 같은 것

`AwsConfig.cs` 는 **양쪽 md5 가 일치한다**(45줄, `AwsConfig(awsKey, awsSecKey, awsRegion)` → `BasicAWSCredentials`).
자격증명 주입 방식은 손댈 것이 없다(F-35).

### 3-D. 자격증명·버킷·큐의 위치 (값 아님)

| 무엇 | 열림 위치 | 후니 위치 |
|---|---|---|
| 키·시크릿·리전 | `CRT.Yeolim.ServerProcess/FoxConfigurationServerProcess.config:13-16` (`AwsRegion`/`AwsKey`/`AwsSecKey`) · `CRT.Yeolim.SQSMonitorService/FoxConfigurationSQSMonitor.config:4,8,9` | `FoxConfiguration.example.config:30-32` (`AWS_REGION`/`AWS_KEY`/`AWS_SECRET_KEY`) — 실값은 배포 서버의 `FoxConfiguration.*.config` |
| 큐 URL | `FoxConfigurationSQSMonitor.config:10` (`AwsQueueUrl`) | `FoxConfiguration.example.config:33` (`QUEUE_URL`) · 로그 큐는 `ITF_LOG_QUEUE_URL`(`:39`, 주석 처리) |
| 버킷 | `FoxConfigurationServerProcess.config:14` (`AwsBucketNm`) | `BackOffice.UI/CRT.EasyMES.V2.Core/AwsInfo.cs` — 생성자 인자 `bucketName` + `GetS3Url()` 로 URL 조립(`:33-56`) |

후니 리전 기본값은 `ap-northeast-2`(`AwsInfo.cs:33` · `FoxConfiguration.example.config:30`).
열림 리전은 설정값이라 저장소만으로는 확정 못 한다 — **미확인**(F-42).
`docs/aws/create-itf-log-queue.ps1:3` 에 후니 AWS 계정번호가 평문으로 적혀 있다(값은 여기 옮기지 않는다).

---

## 4. ④ 배포·실행 환경 — 「같은 서버에 얹히는가」

### 4-A. 같은 것

| 항목 | 사실 |
|---|---|
| 런타임 | 양쪽 .NET Framework 4.7.2 · 인스톨러 선행조건도 「Microsoft .NET Framework 4.7.2 (x86 and x64)」로 동일 |
| 플랫폼 | 양쪽 Setup `.vdproj` 의 `TargetPlatform = 3:1` (x64) |
| 배포 도구 | 양쪽 VS Setup 프로젝트(`.vdproj`) + `WiRunSQL.vbs` + `FoxConfigurationApp.config` |
| 자동업데이트 | 양쪽 `CRT.Console.AutoUpdateZip` 보유. 6파일 중 3개(`AutoUpdateZipSettings.cs`·`UpdateXml.cs`·`GenerateAutoUpdateFiles.bat`) 내용 완전 동일 |
| 빌드 선행조건 | 양쪽 NeoDEEX 4.0 이 `C:\Program Files (x86)\TheOne Technology\NeoDEEX 4.0\Assembly\` 에 설치돼 있어야 한다 |

### 4-B. 다른 것

| 항목 | 열림 | 후니 |
|---|---|---|
| **워커 상주화** | **Topshelf 사용 0건.** 콘솔 `Exe` 를 프로세스 개수 제한으로 다중 실행 — `SQSMonitorService/Program.cs:41-46` 이 `ExecuteProcessCnt` 를 넘으면 즉시 `return`. 이름이 "…Service" 일 뿐 **Windows 서비스가 아니다** | **Topshelf 로 Windows 서비스 등록** 4개(`ItfLogConsumer`·`WooCommerce.CommandHandler`·`WebHookHandler.WooCommerce`·`DesignFileCopyToNas`) — `RunAsLocalSystem`(`ItfLogConsumer/Program.cs:41-52`). 나머지는 작업 스케줄러 실행형 + `MAX_INSTANCES` 제한(`DesignFileThumbnailCreator/Program.cs:38-54`) |
| **인스톨러 동봉물** | NanumGothic 3종 + `vcredist_x64.exe` 동봉 | 동봉 없음 |
| 콘솔 워커 수 | 2 (`SQSMonitorService` · `ServerProcess`) + 보조 도구 다수 | 13 (`BackOffice.Console/`) + `BackOffice.WebApi` |

> **함정 (F-49)**: 후니 저장소 루트의 `install.cmd` 는 **MES 배포 스크립트가 아니라 Claude Code 설치 스크립트**다
> (`install.cmd:4` "Claude Code Windows CMD Bootstrap Script"). 배포 문서로 인용하면 안 된다.

### 4-C. PitStop Server 설치 요건 — 저장소로 확정되는 것과 안 되는 것

**확정되는 것:**
- 워커는 설정값 `PitStop_ExeFileName` 으로 받은 실행파일을 자식 프로세스로 띄운다
  (`ActionsSetList.cs:19` → `Program.cs:659`). 설정 파일의 키는 `FoxConfigurationServerProcess.config:20`.
- 선행 문서가 읽은 그 값은 `…\Enfocus PitStop Server 23\` 경로였다 → **PitStop Server 를 워커와 같은 Windows 머신에 설치**해야 한다(로컬 실행파일 호출이므로 원격 호출 경로가 없다).
- PitStop 자산 3종이 **저장소 밖 파일시스템에 있어야 한다**: `.eal` 액션리스트(appSetting `PitStopAction_*` **22개** · `FoxConfigurationServerProcess.config:22-50`) · `.evs` 변수세트 템플릿(`PitStop_VariableSetTemplateFilePath` `:19`) · 폰트 폴더(`PitStop_FontDir` `:18`).

**확정되지 않는 것 — 미확인으로 남긴다:**
- PitStop Server 23 의 **라이선스 형태·동시 처리 수·CPU/메모리 요건**: 두 저장소 어디에도 없다(Enfocus 문서 영역).
- **같은 서버에 얹히는가**: 후니 MES 워커가 실제로 도는 서버의 OS·사양·여유가 저장소에 없다.
  후니 `CLAUDE.md:22`·`:147` 은 콘솔 워커 11개와 NAS/ImageMagick 사용을 적을 뿐 서버 스펙을 적지 않는다.
  **이 질문은 코드로 답할 수 없다** — 현장 서버 실사 또는 인프라 담당 확인이 필요하다.
- 후니 저장소에 **PitStop 흔적은 0건**이다(`grep -ril pitstop` 0).

---

## 5. ⑤ 결론 대신 — 사실 요약

「옮길 수 있다/없다」를 쓰지 않는다. 같은 것과 다른 것만 남긴다.

**같은 것 (손댈 필요 없는 자리)**
- 런타임·csproj 형식·플랫폼(x64)·인스톨러 방식·자동업데이트 구조
- 설정 메커니즘(FoxConfiguration / NeoDEEX 4.0, 같은 절대경로)
- 네임스페이스 규약(`CRT.Framework.*`)
- `AwsConfig` (바이트 단위 동일)
- S3→SQS→워커 **골격** — 후니가 이미 운영 중
- 공통 9개 프로젝트 파일의 59%(87개 중 51개)가 바이트 단위 동일

**다른 것 (확인·결정이 필요한 자리)**
1. `CommandLine.Execute` 의 `CreateNoWindow` 동작과 인자명 — 후니 사본을 쓰면 상주 워커에 콘솔 창이 뜬다
2. S3 이벤트 메시지 형식(원본 알림 ↔ EventBridge) — DTO 호환 안 됨. AWS 콘솔 설정이 정하고 저장소에 없다
3. 실패 처리 성숙도 — 열림 재시도 0/DLQ 0 ↔ 후니 DLQ·백오프·triage 스크립트 운용
4. 워커 상주화(프로세스 개수 제한 ↔ Topshelf 서비스)
5. 설정 키 명명 관습(PascalCase ↔ UPPER_SNAKE)
6. 공통 9개의 나머지 41%(변경 36 + 한쪽만 27) — 양쪽 사본이 각자 갈라진 부분
7. 후니 사본이 전부 더 최근에 손질됐다 — 열림 코드를 가져오면 **후니의 최신 수정을 덮어쓸 위험**이 생기는 자리

**저장소로 답이 안 나오는 것 (미확인)**
- PitStop Server 23 의 라이선스·사양·동시성 요건
- 후니 워커 서버의 실제 사양·여유 → 「같은 서버에 얹히는가」
- 열림 AWS 리전·버킷·큐 실값(설정 파일 값 영역, 전사하지 않음)
- S3→SQS 사이 AWS 콘솔 설정(양쪽 저장소 모두 없음)

---

## 6. 선행 인용 재대조 (`pitstop-clues-CRT.md` 미검증분)

이 카드가 재사용한 5건을 직접 열어 확인했다. **5건 전부 정확**하다.

| 인용 | 선행 문서 | 이 세션 재확인 | 결과 |
|---|---|---|---|
| `ServerProcess/Common/ActionsSetList.cs:19` | `PitStop_ExeFileName` appSetting | `this.ExeFileName = FoxConfigurationManager.AppSettings["PitStop_ExeFileName"];` | 일치 |
| `ServerProcess/Program.cs:654-655` | ` -config "<XML>"` 한 플래그 | `:654` `StringBuilder args` · `:655` `args.Append($" -config \"{configFilePath}\"")` | 일치 |
| `PitStopConfiguration.cs:289` | XmlRoot 네임스페이스 `/PitStop/22/` | 동일 | 일치 |
| `PitStopConfiguration.cs:303-315` | `Save()` | `:303` `public void Save(string filePath)` ~ `:315` | 일치 |
| `PitStopConfiguration.cs:16` | `VersioningStrategy = BestEffort` | 동일 | 일치 |

**보강 1건**: 선행 문서에 없던 사실 — `Versioning.Version` 기본값이 **10**(`:13`)이다.
따라서 버전 숫자는 2개가 아니라 **3개**(코드 Version 10 · 스키마 ns 22 · 설치본 23)가 서로 다르다.

**정정 1건**: 선행 문서 §2 는 「액션 카탈로그」를 설명하며 `ActionsSetList.cs:55-70`·enum `:82-113` 을 든다.
이 세션은 그 두 범위를 열어보지 않았으므로 **인용하지 않았다.** 대신 설정 파일에서 `PitStopAction_*` 키를
직접 세어 **22개**로 확정했다(`grep -c` = 22).

---

## 7. 검산 — 실행한 명령과 출력

산출물은 전부 재현 가능하다. `t55/` 에서:

```
python3 inventory.py   # 프로젝트 집합 + 파일/줄수 + md5 → inventory.json
python3 filediff.py    # 공통 9개 파일 단위 동일/변경/한쪽 전수
python3 projmeta.py    # TFM·AssemblyVersion·OutputType·패키지 → projmeta.json
python3 apidiff.py     # 공개 타입·멤버 차이 → apidiff.json
python3 verify.py      # facts.csv 집계 숫자 재계산 (검산)
```

`verify.py` 출력 (facts.csv 집계 행의 근거):

```
F-04 공통9 .cs 파일수      Y=104 H=97
F-05 공통9 .cs 총줄수      Y=16213 H=15825
F-06 같은이름·내용동일     51
F-07 같은이름·내용다름     36
F-08 한쪽에만 있는 파일    열림만=17 후니만=10
F-12 공개 타입수           Y=115 H=91
F-13 공개 멤버수           Y=632 H=512
F-14 한쪽에만 있는 공개타입 열림만=36 후니만=12
```

**검산으로 잡아 고친 초안 오류 4건**(정직하게 남긴다): `F-05` 후니 줄수 15,425→**15,825** ·
`F-08` 후니만 14→**10** · `F-14` 후니만 10→**12** · `F-48` 액션키 26→**22**.
넷 다 초안 작성 중 어림한 숫자였고, 재계산·재grep 으로 교체했다.

그 밖에 직접 실행한 확인 명령:

```
diff -u <열림>/CRT.Framework.Utils/CommandLine.cs <후니>/Framework/CRT.Framework.Utils/CommandLine.cs
grep -n "CRT\." <열림>/CRT.Framework.Pitstop/*.cs                      # 0건
grep -n "^using" <열림>/CRT.Framework.Pitstop/*.cs                     # 전부 System.*
md5 <후니>/Framework/*/packages.config                                 # 8개 동일 → 보일러플레이트
grep -c "PitStopAction_" <열림>/.../FoxConfigurationServerProcess.config  # 22
grep -rln "Topshelf" <열림>                                            # 0건
git -C <repo> log -1 --format='%ad %s' --date=short -- <projdir>       # 프로젝트별 최종 커밋일
git -C <repo> log --oneline | wc -l                                    # 18 / 244
```

**금지 준수**: DB write 0 · 라이브 접속 0 · 두 대상 저장소 쓰기 0 · 빌드/실행 0 ·
자격증명 **값** 전사 0(키 이름과 파일 위치만) · 날짜 추정 0.

## 8. 계약 대응

| 계약 조항 | 이 카드의 처리 |
|---|---|
| 보충 1 (오픈 분모 밖) | 해당 없음 — `screens.csv` 를 내지 않는 조사 카드다. 원장 행 0 |
| 보충 2 (`config` 판정) | 해당 없음 |
| 보충 3 (`work_type` 축) | 해당 없음. 단 §0-1 대로 **pitstop 행의 `status` 근거로 이 문서를 쓰지 않는다** |
| 보충 4 (결정·관리 안건은 행이 아니다) | §4-C 「미확인」 3건(PitStop 라이선스·사양 / 서버 여유 / AWS 콘솔 설정)은 **결정 안건**이다. 이 문서에 사실로 남겼고 `screens.csv` 행으로 만들지 않았다 |
| 레인 간 교차 사실 | `pitstop-clues-CRT.md` 인용분 5건을 **직접 재확인**했다(§6). 미확인 범위는 인용하지 않았다 |

**집계**: 사실 행 50 (`facts.csv` F-01~F-50) · 미확인 4 (F-42·F-47 + §4-C 서버 여유·AWS 콘솔 설정) ·
`screens.csv` 행 0 · 결정 안건 3 · 선행 인용 재대조 5건 전건 일치 · 초안 오류 자체 정정 4건.
