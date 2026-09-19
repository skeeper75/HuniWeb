# t54 ⑤ PitStop 검사 결과·검판 PDF 가 MES 에 들어갈 자리 후보

대상: `/Users/innojini/Dev/TS.BackOffice.Huni` (읽기전용). 경로는 저장소 루트 기준 상대경로, 줄번호는 `grep -n`/`sed -n` 실측값.
**이 문서는 설계안이 아니라 「빈 자리가 어디인가」의 사실 목록**이다. 무엇을 택할지는 결정권자 몫이고, 그 결정은 아직 없다(t50 `pitstop-decisions.md` 7건).

---

## 1. 출발점 — MES 안에 PitStop 은 **한 글자도 없다**

직접 돌린 명령과 출력:

```
$ cd /Users/innojini/Dev/TS.BackOffice.Huni
$ grep -rli "pitstop" --include="*.cs" . | grep -v '/obj/\|/bin/'
(출력 없음)

$ grep -rli "pitstop" . --exclude-dir=obj --exclude-dir=bin --exclude-dir=.git
(출력 없음)

$ grep -rn --include="*.cs" -i "preflight\|검판\|전산검수" . | grep -v '/obj/\|/bin/'
(출력 없음)
```

**코드 0건 · 문서 0건 · 유사 개념어 0건.** t50 이 "pitstop 23행 전부 미착수"로 판정한 것과 모순되지 않는다.
따라서 아래는 전부 **기존 그릇에 빈 자리가 있는가**를 본 것이지, 구현이 있다는 뜻이 아니다.

---

## 2. 후보 A — 파일 테이블 `T_ORD_ORDER_FILES` (검판 PDF 를 파일 한 종류로 받는다)

### 그릇
`ref/db/huni-db-script.sql:2498-2519` (CREATE TABLE):

| 컬럼 | 타입 | 줄 |
|---|---|---|
| `SEQ` | int IDENTITY, PK | :2499 |
| `ORD_CD` / `ORD_DTL_SEQ` / `ORD_DTL_ITEM_NBR` | varchar(50) / int / varchar(50) | :2500-2502 |
| `PRCS_CD` | varchar(10) — 공정 | :2503 |
| **`FILE_TYP`** | **varchar(10)** | **:2504** |
| `FILE_PATH` / `FILE_EXT` / `S3KEY` | varchar(8000) / (10) / (1000) | :2505-2507 |
| `PAGE_NO` / `PAGE_CNT` | int | :2508-2509 |
| **`UPR_SEQ`** | int — 상위 파일 SEQ | :2510 |
| 감사컬럼 4 | | :2511-2514 |

### 이 후보가 성립하는 근거
- `FILE_TYP` 은 **코드표로 관리되는 도메인**이다: `LEFT OUTER JOIN T_COM_CD C ON F.FILE_TYP = C.CD AND C.CD_GRP = 'FILE_TYP'`
  (`ref/db/huni-db-script.sql:7843`, 같은 조인이 `:8070`·`:20611` 에도 있다). 즉 **값을 늘리는 길이 이미 열려 있다**(코드 등록 + 코드 사용처 반영).
- `UPR_SEQ` 로 **파일 간 부모-자식**을 표현한다(`docs/sql/hapbaesong/03_usp_dlv_orders_for_package_s.sql` 의 `LEFT OUTER JOIN T_ORD_ORDER_FILES FD ON F.UPR_SEQ = FD.SEQ`, 같은 조인 `ref/db/huni-db-script.sql:7844`).
  → 검판 PDF 를 **검사 대상 원고 행의 자식**으로 달 수 있는 축이 이미 있다.
- `PRCS_CD` 로 **공정별 파일**을 구분한다(`:2503`) — 검판을 하나의 공정으로 볼 여지.

### 이 후보를 택할 때 코드에서 실제로 걸리는 것 (사실)
1. **C# 열거형이 4값으로 닫혀 있다** — `BackOffice.Server/CRT.EasyMES.V2.Objects/Enums.cs:21-27`:
   `FILE_ORIGN` · `FILE_DSIGN` · `FILE_THUMB` · `FILE_NONE`. 새 종류를 추가하려면 이 열거형과, 이를 문자열로 쓰는 모든 지점이 바뀐다
   (예: `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:396`, `BackOffice.UI/CRT.EasyMES.V2.Module.UserControls/UcOrderDetail.cs:1111`·`:1577`, `BackOffice.Console/CRT.EasyMES.V2.DesignFileThumbnailCreator/ThumbnailService.cs:430`).
2. **`FILE_TYP` 은 varchar(10)** (`:2504`). 기존 값이 전부 11자 미만인 `FILE_*` 패턴이므로 새 값도 **10자 이내**여야 한다
   (예컨대 `FILE_PITSTOP` 는 12자로 들어가지 않는다). 컬럼을 늘리든 이름을 줄이든 **둘 중 하나는 결정해야 한다.**
3. **파일행은 재렌더마다 통째로 지워진다** — `USP_ORD_ORDER_FILES_D`(`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:1060-1073`)를
   `BackOffice.Server/CRT.EasyMES.V2.Data/Biz/OrderBiz.cs:138-173` 이 매 렌더 반영 전에 부른다. **검판 결과를 같은 테이블에 두면 재렌더 시 함께 날아갈 수 있다** — 삭제 범위(`FILE_TYP` 필터 유무)를 SP 본문에서 확인해야 한다(라이브 SP 미확인).
   참고로 `docs/sql/edicus-rerender/02_usp_ord_order_files_d.sql:53` 은 `AND FILE_TYP = 'FILE_THUMB'` 로 종류를 좁히는 구문을 담고 있다 — **그 스크립트가 라이브 판본인지는 확인하지 못했다.**

---

## 3. 후보 B — **상태 사다리의 「접수완료」 앞** (검판을 통과 조건으로 건다)

### 현행 상태 사다리 (실측)
`BackOffice.UI/CRT.EasyMES.V2.Core/AppConstants.cs`:

| 코드 | 이름 | 줄 |
|---|---|---|
| `STAT_0050` | 주문 대기 | :60 |
| `STAT_0100` | 주문 완료 | :64 |
| `STAT_0300` | 접수 중 | :68 |
| **`STAT_0400`** | **접수 완료** | **:72** |
| `STAT_0900` | 제작 대기 | :77 |
| `STAT_1000` | 제작 중 | :81 |
| `STAT_7000` | 출고 준비 중 | :85 |
| `STAT_7100` / `STAT_7200` / `STAT_8000` | 출고완료 / 배송중 / 배송완료 | :89·:93·:97 |
| `STAT_91818` / `STAT_9999` / `STAT_9900` | 삭제 / 취소 / 고객취소 | :101·:105·:109 |

### 이미 있는 「파일 검사 게이트」 — 그대로 확장할 자리
`BackOffice.UI/CRT.EasyMES.V2.Module.Order/FrmOrder2.cs`:

- `DoSave()` (`:438`, 주석 `:434-437` 이 "접수 완료 / `[STAT_0100] 주문 완료` → `[STAT_0400] 접수 완료` 로 상태값 변경"이라고 명시)
- 그 안의 선행 검사 3단:
  1. `[STAT_0100] 주문 완료` 상태인 것만 선택했는가 (`:460-478` · 경고 `:476`)
  2. 출고요청일 입력 여부 (`:484` 이후 region)
  3. **`접수파일 필수 일 경우 접수파일 업로드 여부 체크`** (`:518-544`) — `REQ_FILE_YN='Y'` 인 공정을 조회해(`:533`)
     `DSIGN_CNT == 0` 인 건을 모은 뒤(`:538`), 있으면 **"그래도 계속 진행하시겠습니까?" 확인창**을 띄운다(`:547-548`).
  4. 통과하면 `ORD_DTL_STAT_CD = STATUS_DSG_COMPLETED` 로 갱신(`:582`, `orderData.UOrderDetailState(param)` `:584`).

> **여기가 사람이 "이 원고로 생산해도 된다"고 판단하는 지점이다.** 검판 결과를 붙일 가장 자연스러운 자리이고,
> **선례가 이미 같은 모양**(파일 있음/없음 검사 → 경고 → 진행)이다. 다만 현행 검사는 **강제 차단이 아니라 경고 후 진행 허용**임에 유의(`:547` `MessageBoxButtons.OKCancel`).

### 파일필수 축이 붙어 있는 그릇
`T_ORD_ORDER_DTL_ITEM_PRCS`(`ref/db/huni-db-script.sql:2434`) — 주문상세 아이템의 **공정별 행**. 여기에 `REQ_FILE_YN` 이 살고
(`BackOffice.Server/CRT.EasyMES.V2.Data/Dac/ProductDac.cs:597`, 조회 SP 파라미터 `BackOffice.Server/CRT.EasyMES.V2.Data/Dac/OrderDac.cs:993-994`),
화면에는 "파일필수"·"접수파일 수" 열로 나온다(`BackOffice.UI/CRT.EasyMES.V2.Module.UserControls/UcOrderDetail.cs:822-823`). **공정 단위 합부(合否)를 담는 축이 이미 이 테이블이다.**

---

## 4. 후보 C — **NAS 배포 게이트** (검판 통과 전에는 생산 폴더로 안 나간다)

`BackOffice.Console/CRT.EasyMES.V2.DesignFileCopyToNas/ThumbnailService.cs`:

- 설정키 `DOWNLOAD_STATUS` (`:60`)
- 게이트: `if (orderDetailStatusCd != DownloadStatus) { … continue; }` (`:296-305`).
  주석이 "주문상세정보가 다운로드 가능한 상태가 아니므로 Skip … 제작대기가 될 때까지 재전달로 재시도"라고 적는다(`:295-299`).
- 복사가 실제로 끝난 뒤에만 SQS 메시지를 지운다(`:334`).

> **파일이 생산으로 풀리는 문은 이 한 줄이다.** 검판 미통과 건을 물리적으로 막고 싶다면 코드를 새로 짤 필요 없이
> **상태값 하나로 막힌다**(검판 통과가 `DOWNLOAD_STATUS` 도달의 선행조건이 되면 된다).
> 단, `DOWNLOAD_STATUS` 의 실제 설정값은 `.config` 에 있고 이 조사에서 **값을 확인하지 않았다**(자격·설정 값 전사 금지 + 라이브 미접속).

---

## 5. 후보 D — 화면: 주문상세 파일 패널

`BackOffice.UI/CRT.EasyMES.V2.Module.UserControls/UcOrderDetail.cs` 안에 이미 **세 개의 파일 격자**가 있다:

| 격자 | 무엇 | 줄 |
|---|---|---|
| `gvOriginalFiles` | 원본파일 목록(파일명 열, 삭제 열) | :798, :805 |
| `gvDesignFiles` | 접수파일 목록(파일명 열, 삭제 열) | :834, :841 |
| `gvOrdDtlItemPrcs` | 공정별 — "파일필수"·"접수파일 수" | :822-823 |
| 썸네일 탐색기 | 썸네일 파일명 표시 | :885, :917 |

업로드 동선도 이미 있다: 수동 업로드(`:1503` 이후, 구분 "원본파일"/"접수파일" `:1518`·`:1523`, `FileType.FILE_DSIGN` `:1524`),
S3 업로드 후 DB Insert(`:1084`·`:1097`·`:1111`), 다운로드(`:1601`), 삭제(`:1443`).

> 검판 결과를 **네 번째 격자**로 붙이거나, `gvOrdDtlItemPrcs` 에 합부 열을 더하는 두 갈래가 화면 쪽 자리다.

---

## 6. 후보 E — 중앙 로깅 `ItfTrace` (검사 이력을 추적 가능한 이벤트로 남긴다)

모든 무인 작업자가 공통으로 쓰는 이벤트 로깅 축이 이미 있다 —
예: `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:52-53`(`ItfTrace.Init` / `UseSink`), 이벤트 기록 `:150`(`SQS_RECEIVED`) · `:333`(`ORDER_LOOKUP`) · `:361`(`S3_UPLOAD`) · `:424`(`DB_SAVE_DETAIL`) · `:441`(`STATE_UPDATE`).
컨텍스트 키가 `ordCd` · `usrOrdCd` · `marketOrdItemNo` · `sqsMsgId` 로 이미 주문 단위다(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:147-148`).
테이블 스크립트도 저장소에 있다(`docs/sql/T_LOG_ITF_TRACE.sql` — **스크립트이며 라이브 반영 여부는 미확인**).

> 검판 **결과 파일**은 후보 A/D 가 받고, 검판 **수행 이력**(언제 어느 판본으로 검사했고 무엇이 걸렸는가)은 이 축이 받는 모양이 자연스럽다.

---

## 7. 자리 후보 요약

| 후보 | 무엇을 받는가 | 기존 그릇 | 새로 필요한 것(사실) |
|---|---|---|---|
| A. `T_ORD_ORDER_FILES` | 검판 PDF 파일 자체 | 테이블·`UPR_SEQ`·`PRCS_CD`·`T_COM_CD` 코드축 | `FILE_TYP` 새 코드(10자 이내) + `BackOffice.Server/CRT.EasyMES.V2.Objects/Enums.cs:21-27` 확장 + 재렌더 삭제 범위 확인 |
| B. `DoSave()` 접수완료 게이트 | 합부 판정을 통과 조건으로 | `BackOffice.UI/CRT.EasyMES.V2.Module.Order/FrmOrder2.cs:518-544` 의 동형 선례 | 검판 결과를 읽는 조회 + 차단/경고 정책 결정 |
| C. NAS 배포 게이트 | 미통과 건의 생산 차단 | `BackOffice.Console/CRT.EasyMES.V2.DesignFileCopyToNas/ThumbnailService.cs:296-305` | **코드 변경 없이 상태값만으로 가능** |
| D. 주문상세 화면 | 운영자가 보는 자리 | `UcOrderDetail.cs` 파일 격자 3종 | 격자 1개 추가 또는 공정 격자에 합부 열 |
| E. `ItfTrace` | 검사 수행 이력 | 전 작업자 공통 로깅 | 이벤트 코드 정의 |

**어느 것도 배타적이지 않다.** A+B+E 조합이 현행 구조와 가장 덜 부딪치지만, **이는 관찰이지 결정이 아니다.**

---

## 8. 확인 못 한 것 (중요)

1. **PitStop 쪽 산출물의 실제 모양을 모른다** — 이 저장소에 근거가 0이다. 검판 PDF 가 몇 개인지, 리포트가 XML/JSON 인지, 합부 판정이 이진인지 등급인지 전부 미확인.
2. **연동 방식(핫폴더 vs CLI)이 미결**이다(t50 `pitstop-decisions.md` STD-ART-034). 방식이 정해지지 않으면 **누가 MES 에 넣는가**(무인 작업자 신설 vs 기존 작업자 확장 vs 사람이 업로드)가 정해지지 않는다.
3. **저장프로시저 본문 미확인** — `USP_ORD_ORDER_FILES_D` 가 `FILE_TYP` 으로 삭제 범위를 좁히는지 라이브에서 보지 못했다(§2-3). 이건 "검판 결과가 재렌더로 사라지는가"라는 실질 위험이다.
4. **`DOWNLOAD_STATUS` 설정 실제값 미확인**(§4).
5. **라이브 화면 확인 0** — MES 실화면을 띄워 본 것이 아니라 폼 코드만 읽었다.
6. **`UPR_SEQ` 의 C# 사용처 0건** — `grep -rn --include="*.cs" "UPR_SEQ"` 출력 없음. SQL 쪽에서만 쓰이므로, C# 층에서 부모-자식을 다루려면 새 배선이 필요하다.
7. **후보 C 가 "코드 변경 없이 가능"하다는 것은 파일 차단에 한한 것**이다. 검판을 수행하고 결과를 받아 상태를 올리는 경로 자체는 전부 신규다.
