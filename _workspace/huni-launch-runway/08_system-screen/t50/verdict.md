# t50 verdict — mes · edicus · pitstop 화면·기능 원장

카드: **t50** (오픈일정 S3) · 레인: lane-4 · 워크트리: `.claude/worktrees/t50` · 브랜치: `WT-mes-edicus-screens`
계약: `../CONTRACT.md` (260919 · 보충 1~4 반영) · 산출: `screens.csv` **134행**

---

## 1. 행수·분포 (검산 명령 출력 그대로)

`python3 merge_screens.py` 출력:

```
총 134행
system     : {'mes': 88, 'edicus': 23, 'pitstop': 23}
work_type  : {'build': 78, 'integrate': 38, 'provided': 13, 'manual': 3, 'config': 2}
status     : {'완료': 90, '미착수': 38, '진행': 3, '미확인': 3}
role       : {'관리자': 11, '운영자(CS·상품)': 43, '생산(MES)': 28, '시스템(무인)': 45, '고객': 7}
plan_row_id: NEW 74 / 원장매핑 60
integrate  : 38행
분모밖     : 62행 (분모 안 72행)
  분모밖 system: {'mes': 59, 'edicus': 3}
중복 (screen_id, function): 0건
위반 0건
```

### 분모 안 72행 — 이번 오픈에 실제로 걸리는 것

| system | 행수 | status |
|---|---|---|
| mes | 29 | 완료 18 · 미착수 11 |
| edicus | 20 | 완료 11 · 진행 3 · 미착수 4 · 미확인 2 |
| pitstop | 23 | **미착수 23 (전부)** |

분모 안 work_type: build 29 · integrate 28 · provided 10 · manual 3 · config 2
분모 안 integrate 28행의 `owner_side`: webadmin 11 · **미정 11** · widget 4 · mes 2

### 분모밖 62행 (계약 보충 1)

mes 59 · edicus 3. work_type 은 보충 3 축을 따름(build 49 · integrate 10 · provided 3).
`evidence` 맨 앞 `[오픈분모밖] ` 접두로 표시 — t51 이 여기서 `scope`(in/out) 열을 파생한다.

**미확인 3행 · 진행 3행 (전부 edicus)**

- 미확인: EDI-09 토큰 만료 재발급 · EDI-10 project_id 저장 · EDI-23 참조코드 토큰 본문 불일치
- 진행: EDI-07 위젯→webadmin 편집기 진입 · EDI-12 디자인 보관함 · EDI-14 산출물 인쇄용 변환·주문 연결

미확인 3건의 공통 원인: 라이브 프론트엔드가 `huni-skin-shopby`(이 저장소 밖)라 실동작을 확정할 수 없었다.
`docs/edicus.man` 은 별개 참조 저장소(`edicus-man`)이며 라이브 위젯이 아니다 — 그 코드를 근거로 완료 판정하지 않았다.

---

## 2. 실행한 검산 명령과 출력

| 명령 | 목적 | 결과 |
|---|---|---|
| `python3 slice_planrows.py` | 9/17 원장 735행 → 시스템별 후보 슬라이스 | mes 127 · edicus 28 · pitstop 36행 |
| `python3 merge_screens.py` | parts 병합 + 계약 전수 검사 | **위반 0건** · 134행 · 중복 0건 |
| `python3 scan_unmeasured.py` | 원장의 「MES 소스 없음/미실측」 문구 행 추출 | 127행 중 **5행** → `unmeasured-candidates.csv` |

`merge_screens.py` 가 기계 검사하는 항목: 헤더 13열 고정 · system 허용 8종 · work_type 5값 · status 4값 ·
role 5값 · integrate 행의 counterpart/direction/owner_side 필수 · plan_row_id 가 원장 row_id 이거나 `NEW` ·
evidence 빈 행 금지 · 분모밖 접두의 **위치**(evidence 맨 앞) · (screen_id, function) 중복.

검산 과정에서 실제로 잡아 되돌린 계약 위반 (에이전트 자기보고로는 드러나지 않았던 것):

| 위반 | 건수 | 조치 |
|---|---|---|
| role 허용값 밖 `대표(구매)` | 2 | `관리자` + 결정 주체를 evidence 로 보존 |
| role 허용값 밖 `영업` | 4 | `운영자(CS·상품)` + 담당 정보를 evidence 로 보존 |
| status 에 타 스키마 값 `부분`·`미실측` | 4 | `진행`·`미확인` (CARDS-S §2 `process-status.csv` 값을 섞은 것) |
| `manual` 오용 (결정·관리 안건) | 8 | `screens.csv` 밖 `*-decisions.md` 로 이동 → 계약 보충 4 |
| work_type 축 오판 (`provided` 덮어쓰기) | 77 | 보충 3 축으로 재분류 → 아래 §4 |
| 지시 미반영 (구 메시지 처리) | 1레인 | 파일 직접 읽어 적발 → 재지시 |

---

## 3. 결정·관리 안건 — 이 원장 밖으로 분리 (보충 4)

화면도 기능도 없는 결정·관리 안건은 `screens.csv` 의 행이 아니다(9/17 원장 735행이 그 자리 · 이중계상 방지).

- `pitstop-decisions.md` — **7건**
- `edicus-decisions.md` — **2건**

합계 9건. 전부 `plan_row_id` 로 9/17 원장에서 추적 가능하다 — 정보 손실 없음.

---

## 4. 판정 근거를 남겨야 하는 것 — MES 를 `build` 로 둔 이유

**MES 는 외부 벤더 제품이 아니라 후니프린팅 자체 시스템이다.** 조사 초기에 한 레인이
"pre-existing vendor screen" 이라고 서술했고 리드에게도 그렇게 보고될 뻔했으나, 저장소 안 증거가 반대였다:

| 근거 | 내용 |
|---|---|
| `/Users/innojini/Dev/TS.BackOffice.Huni/CLAUDE.md:9-11` | "후니프린팅(Huni Printing) MES 백오피스 시스템" 자기 서술 |
| `README.md:391` | `MIT License` — 벤더 상용 제품이면 고객사가 MIT 로 재라이선스하지 않는다 |
| `git log` | 244커밋 · 2025-05-02~2026-09-16 · 커미터 `SeoHeeHang` = 원장이 MES 담당으로 지정한 서희항 대표 |
| `CLAUDE.md:15-40` | TheOne/NeoDEEX·DevExpress 는 **구매한 UI/유틸 라이브러리**이지 MES 전체가 벤더 제품이라는 근거가 아니다 |

따라서 `work_type=build`(기능이 생기는 방식 = 후니가 만들었다) + `status=완료` 가 맞고,
`provided`(외부가 그대로 제공)는 오기다.

**CARDS-S §0-B 가 MES 를 "외부"로 분류한 것은 조직 경계를 뜻한다** — 벤더라는 뜻이 아니라,
이 문서의 개발 레인(HuniWeb·webadmin·스킨)이 쓰지 않는 별개 저장소·별개 워크스트림이라는 뜻이다.
이유를 틀리게 남기면 다음 사람이 "MES 는 손댈 수 없다"고 오해한다.

판정 불가로 남긴 것: `CRT.EasyMES.V2` 라는 제품명이 원래 백지에서 나온 것인지, 화이트라벨 베이스코드에
후니가 이름을 붙인 것인지는 저장소 안 증거로 확정할 수 없다(LICENSE 파일 없음 · 벤더 저작권 헤더 grep 0건).
추측하지 않았다.

---

## 5. 원장 정정 — 9/17 원장이 MES 코드를 읽지 않아 생긴 과소평가

`scan_unmeasured.py` 로 원장 127행 중 「MES 소스 없음 / 미실측」 문구를 쓴 행 **5건**을 추출해 전수 확인했다
(`unmeasured-candidates.csv`).

### 확정 정정 2건 — 코드가 실재한다

| plan_row_id | 항목 | 실재 근거 (직접 확인) |
|---|---|---|
| **STD-MFG-060** | Edicus Prepress 렌더링 결과 접수파일 등록 | `BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:41,107-166,267` — `EdicusRenderInfo` SQS webhook 수신 · `DoWebHookJob` 호출 · 성공 시 삭제 |
| **STD-MFG-061** | 접수파일 썸네일 자동 생성 | `BackOffice.Console/CRT.EasyMES.V2.DesignFileThumbnailCreator/Program.cs:34-51` — `MAX_INSTANCES`(기본 3) 중복실행 가드가 붙은 무인 스케줄러 |

이 2건은 **교차모순으로 잡혔다**: edicus 레인은 같은 기능을 "미실측"으로, mes 레인은 "코드 실재"로 판정했다.
서로 다른 저장소만 봐서 생긴 모순이며(edicus 레인은 HuniWeb 만, mes 레인은 MES 만), 양쪽 다 정직했다.
해소 방식은 계약 보충 4 의 규칙대로 — **인용하는 쪽이 직접 확인**했다(edicus 레인이 MES 저장소를 읽기전용으로
직접 열어 위 path:line 을 재확인). 남의 주장을 증거로 옮겨 적지 않았다.

### 재조사했으나 근거 없음 2건 — 원장 판정이 뒤집히지 않았다

| plan_row_id | 항목 | 돌린 grep 과 결과 |
|---|---|---|
| **STD-MFG-059** | 품목관리 디자인파일여부 Y/N → 원본 자동접수 | `디자인파일여부\|자동접수\|AutoAccept\|USE_DSG\|DSG_YN` 등 → 매칭 2건, 둘 다 무관(`FrmSettings.Designer.cs` 의 "원본 PDF 저장 폴더" UI 라벨). `IManufactureService.cs` 전체 메서드에도 해당 플래그·트리거 없음 |
| **STD-MFG-090** | 앞공정 미완료 시 다음공정 차단(interlock) | `interlock\|선행공정\|PrevProc\|공정.*차단` → 1건(`Interlocked.Increment`, .NET 스레딩 원시함수 · 완전 오탐). `공정순서\|다음공정\|ProcessBlock\|공정.*의존` → 0건. WebApi `WorkOrderEndPoints/ProductionRecordEndPoints/ManufactureEndPoints` 도 0건 |

두 건은 **행을 만들지 않았다**. 근거 없이 `미착수` 행을 만들면 MES 팀 기존 기능 유무에 대한 이 카드 범위 밖
판정이 되고, 없는 것을 있는 것처럼 세게 된다.

### 겹침 1건 — 행을 만들지 않았다

**STD-MFG-133**(오프라인 주문 등록)은 `BackOffice.Server/.../XlsOrder/ExcelInfoOffline.cs` 에도 관련 데이터
오브젝트가 있으나, mes-ui 레인이 이미 `BackOffice.UI/.../FrmOrderOffline.cs:38` 로 같은 원장 id 를 갖고 있다.
보충 3 의 "같은 `path:line` 이 겹치면 코드가 사는 쪽(owner_side) 레인이 갖는다" 에 따라 중복 행을 만들지 않았다.

### t51 점검 요청
위 5건 외에도 원장의 다른 `STD-MFG-*` 항목이 같은 이유(MES 코드 미독)로 과소평가돼 있을 수 있다.
`unmeasured-candidates.csv` 는 **문구 일치로 뽑은 후보**이며 확정 결함이 아니다 — 문구를 쓰지 않은 채
과소평가된 행은 이 스캔에 안 걸린다.

---

## 6. 오픈 판단에 직접 걸리는 발견 3건

### (1) 샵바이 ↔ MES: 스펙 11개 · 구현 0

MES 저장소 전체 `grep -rli "shopby" --include=*.cs` = **0건**. 있는 것은 설계 문서뿐:
`docs/api/shopby-integration-api.yaml`(yaml 을 직접 세서 paths 11개 · post 6 · get 5).

`screens.csv` 에 11개 엔드포인트를 전부 펼쳤다 — 전부 `integrate` · `미착수` · `owner_side=미정`,
evidence 에 스펙 `path:line` + "컨트롤러/구현 코드 0건(grep 재확인) · 이 spec 은 설계문서일 뿐 구현 아님" 병기.

**주의 — 오독 위험**: MES `docs/design/README.md` 가 이 스펙을 "엔드포인트 수 11개"로 서술해서
**이미 구현된 것처럼 읽힌다**. 문서만 보면 완성으로 착각할 수 있다.

### (2) 두 이음매의 위험도가 다르다

| 구간 | 사내 선례 | 타사 선례 | 상태 |
|---|---|---|---|
| 샵바이 → MES | **있음** — 카페24(SQS webhook 수신 + 상태 push-back) · 우커머스 · 성원(외주) 연동이 전부 완성 코드 | — | 스펙 11 · 구현 0 |
| **PitStop → MES** | **없음** | **없음** | 결정 자체가 미결 |

PitStop→MES 인계는 사내 선례도, 타 고객 선례도 없는 **완전 신규 설계**다.
(타사 참고: 열림PnP 납품 코드 `CRT.DigitalEdit.V2` 에도 PitStop→MES 인계가 없다 — 리드 정리본
`../pitstop-clues-CRT.md`. **타 고객 코드이므로 후니 행의 status 근거로 쓰지 않았다**. 그 문서의 줄번호는
리드가 표본 7건 재대조에서 1건 5줄 어긋남을 확인했으므로 인용하지 않았다.)

이것이 분모 안 integrate 28행 중 `owner_side=미정` 이 11건인 이유다 — 누가 코드를 갖는지가 안 정해졌다.

### (3) PitStop 구간은 작업량 추정 자체가 불가능하다

pitstop 23행 **전부 `미착수`**이고, 그 위의 결정 7건이 사슬로 묶여 있다(`pitstop-decisions.md`):

```
STD-ART-034 연동방식 결정(핫폴더 vs CLI)  ─선행─▶  STD-ART-035 작업범위 산정(4갈래)
                                                      └─▶ STD-ART-033 일정 안건 상정
STD-ART-016  ─선행─▶  STD-MYP-024 연동 담당 확정
BLK-S2-4 구매 진행상태(대표 결정) · T4-3 검수경로 결정(status="없음") · STD-ADO-010 게이트 결정
```

연동방식이 안 정해져 작업범위를 산정할 수 없고, 작업범위가 없으니 일정을 낼 수 없다.
결정 주체도 5건 중 4건이 `미정` 또는 `대표`다. **"PitStop 은 며칠"이라는 수를 지금 낼 수 없다** —
낸다면 근거 없는 숫자다.

---

## 7. 미검증 (Gaps) — 명시적으로 못 본 것

1. **MES 라이브 메뉴 등록 여부**. 메뉴가 소스에 없다 — `CtlNavMenuBar.cs` 가 런타임에 DB `MenuInfo`
   (MENU_CD/MENU_NM/PROG_CD)를 읽고 `FrmMain.cs:287-310` 이 PROG_CD→클래스를 리플렉션으로 해소한다.
   DB 미접속 제약상 **"이 화면이 지금 메뉴에 등록돼 사용자가 클릭할 수 있다"를 확인하지 못했다.**
   대신 코드 구조로 판정했다(`BaseForm` 상속 = 메뉴형 화면 / `BasePopupForm` = 상위 화면의 팝업) —
   125개 Designer 폼 → 57행. 팝업 25개·백업중복 5개 제외.
   `status=완료` 는 "폼 코드를 실제로 읽어 존재·캡션·로직을 확인" 이라는 뜻이며 메뉴 등록 확정과는 별개다.
2. **MES 화면 한글명은 `designer.cs` 캡션에서 추론한 값**이고, 운영자가 실제로 보는 메뉴 문자열
   (DB `MENU_NM`)이 아니다. 다를 수 있다.
3. **라이브 화면·실주문 확인 0**. 이 카드는 코드·문서 실독만 했다. webadmin/위젯/MES 실화면을 띄워
   동작을 본 것이 아니다.
4. **edicus 미확인 3건** — 라이브 프론트엔드(`huni-skin-shopby`)가 이 저장소 밖이라 실동작 미확정.
5. **`module.Reports` 는 화면으로 세지 않았다** — `Frm*` 화면이 없고 `Rpt*` 인쇄 템플릿만 있어,
   그 템플릿을 인스턴스화하는 화면에 "출력" 기능 행으로 붙였다(호출 지점 path:line 근거).
6. **`ConnectionWizard/FrmMain` 은 별개 실행파일**(`: Form`, `BaseForm` 아님)이라 메인 메뉴 도달 여부를
   코드로 확정하지 못했다. 1행으로 넣고 evidence 에 그 사실을 적었다.
7. **STD-MFG-059 · 090** — 재조사했으나 근거 없음. "없다"를 확정한 것이 아니라 "찾지 못했다"이다.

---

## 8. 잔여 위험

1. **분모 판정은 레인의 제안이다.** 62행을 분모밖으로 둔 것은 "신규 파이프라인이 그 화면을 통과하는가"로
   판정했고, 힌트(plan_row_id 매핑)와 다르게 판정한 7건은 evidence 에 `[힌트대비 판정근거]` 로 이유를 남겼다.
   최종 판정은 리드 몫이다. 이 판정이 틀리면 t51 의 작업량 집계가 그만큼 틀린다.
2. **NEW 74행은 9/17 원장의 분모가 이 원장보다 거칠다는 뜻**이다(원장이 화면 단위로 항목화하지 않았다).
   t51 이 두 원장을 합칠 때 NEW 74행의 처리 방침이 필요하다.
3. **`owner_side=미정` 11건은 일정의 구멍이다.** 코드를 누가 갖는지 안 정해진 구간은 담당·일정 산정이
   불가능하다 — 분모 안 integrate 28행 중 11건.
4. **MES 는 이 카드가 쓰기 금지인 별개 저장소**다. 88행의 정확성은 MES 팀(서희항 대표)의 확인을 받아야
   확정된다. 이 카드는 코드를 읽었을 뿐 MES 팀과 대조하지 않았다.
5. **status=완료 90행은 "코드가 있다"이지 "이번 오픈 시나리오에서 동작한다"가 아니다.** 실주문이 통과한
   것을 본 행은 0이다.

---

## 9. 산출물

| 파일 | 내용 |
|---|---|
| `screens.csv` | 134행 원장 (계약 13열 · 위반 0) |
| `pitstop-decisions.md` | 결정·관리 안건 7건 (보충 4) |
| `edicus-decisions.md` | 결정·관리 안건 2건 (보충 4) |
| `unmeasured-candidates.csv` | 「MES 소스 없음」 물려받기 후보 5건 (확정 2 + 미확인 3) |
| `parts/*.csv` | 레인별 원본 4종 + 원장 슬라이스 3종 |
| `merge_screens.py` | 병합 + 계약 전수 검산 |
| `slice_planrows.py` · `scan_unmeasured.py` | 입력 준비 · 원장 스캔 |

금지사항 준수: DB write 0 · 라이브 COMMIT 0 · **MES 저장소 쓰기 0**(Read/Grep 만) · 숫자 날조 0 ·
날짜 추정 0(선행·순서·사슬만 적었다).
