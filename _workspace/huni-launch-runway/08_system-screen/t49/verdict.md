# t49 verdict — webadmin · widget · pagebuilder 화면·기능 원장

- 카드 t49 (Factory Mode · lane-3) · 워크트리 `.claude/worktrees/t49` · 브랜치 `WT-admin-widget-screens`
- 산출 `_workspace/huni-launch-runway/08_system-screen/t49/screens.csv`
- 계약 `08_system-screen/CONTRACT.md` 본문 + 보충 1(개정 포함) · 2 · 3 · 4 전부 반영
- 읽기전용 준수: DB write 0 · 라이브 COMMIT 0 · MES 저장소 접근 0 · 브라우저 미사용

## 1. 행수와 분포

**342행 · 화면 188종** (webadmin 147 / widget 133 / pagebuilder 62)

| system | 행 | 화면종 | build | integrate | config | provided | manual |
|---|---|---|---|---|---|---|---|
| webadmin | 147 | 65 | 127 | 20 | 0 | 0 | 0 |
| widget | 133 | 61 | 108 | 22 | 2 | 0 | 1 |
| pagebuilder | 62 | 62 | 6 | 16 | 23 | 17 | 0 |
| **합계** | **342** | **188** | **241** | **58** | **25** | **17** | **1** |

| system | 완료 | 진행 | 미착수 | 미확인 |
|---|---|---|---|---|
| webadmin | 146 | 0 | 0 | 1 |
| widget | 128 | 2 | 0 | 3 |
| pagebuilder | 0 | 1 | 44 | 17 |
| **합계** | **274** | **3** | **44** | **21** |

- **미확인 21**
- **NEW 103** (webadmin 12 · widget 71 · pagebuilder 20) — 사유는 각 행 `evidence` 에 인라인
- **오픈 분모 밖 2** (보충 1) — `pc-design-workspace` · `pc-project-kanban`
- **결정·관리 안건으로 분리 3** (보충 4) — `pagebuilder-decisions.md`
- 역할: 운영자(CS·상품) 273 · 시스템(무인) 39 · 고객 23 · 관리자 7
- 연동 상대: webadmin 17 · huni-mall 15 · s3 8 · widget 8 · shopby 5 · pagebuilder 4 · edicus 1

## 2. 실행한 검산 명령과 출력

```
$ python3 _assemble.py            # 3개 부분 CSV 조립 + 계약 규칙 기계 검사
rows=342
system: {'pagebuilder': 62, 'webadmin': 147, 'widget': 133}
work_type: {'integrate': 58, 'config': 25, 'provided': 17, 'build': 241, 'manual': 1}
status: {'미확인': 21, '미착수': 44, '진행': 3, '완료': 274}
NEW: 103
분모밖(보충 1): 2
errors=0
$ echo $?
0
```

출력 원본 `_verify.txt`(`.gitignore:106` 의 `*.log` 에 걸려 커밋되지 않으므로 확장자를 바꿔 보존했다 — 인용한 근거 경로가 감사 시점에 열리지 않으면 근거가 아니다). `_assemble.py` 가 실제로 건 검사 9종:

1. 헤더가 계약 13열과 **바이트 일치**
2. `system` 이 계약 8종 안
3. `work_type` 이 5종 안 (6번째 값 신설 0)
4. `role` 이 5종 안
5. `status` 가 4종 안
6. **`evidence` 빈칸 0** — 계약 「근거 없는 행 금지」
7. `integrate` 58행 전부 `counterpart`·`direction`·`owner_side` 채움 / **비-integrate 284행은 그 3열 공란**
8. `plan_row_id` 가 `NEW` 가 아닌 239행 전부 `plan-rows.csv` 735행에 **실재**(미존재 ID 0)
9. `(system, screen_id, function)` 중복 0

보조 검산:

```
$ python3 _dedup.py               # webadmin↔widget 이중 계상 해소
_part-webadmin.csv: 154 -> 147 (뺀 행 7)
_part-widget.csv: 140 -> 130 (뺀 행 10)
이중 계상 해소 합계 17행

$ python3 _normalize.py           # 연동 상대 이름을 계약 용어로 통일
_part-webadmin.csv: 10행 이름 통일
```

## 3. status=완료 의 근거 범위 [중요]

**`완료` 274행은 「코드·앱 내장 매뉴얼 원고에서 구현 실재를 확인한 것」이지 라이브 실화면 확인이 아니다.**
이번 카드는 읽기전용·브라우저 미사용이었다. 리드가 t51 에 「실화면 미확인」 주석으로 승계하기로 접수함.

라이브 판정을 화면으로 대조하라는 도메인 규칙(`huni-webadmin-manual-first.md` 「라이브 판정은 화면으로 대조한다」)이 아직 이 원장에 적용되지 않았다는 뜻이다. 실화면 대조는 별도 과업이다.

**표본 재대조**: 리드 규율(주장이 아니라 파일을 읽는다)대로 각 몫에서 표본을 뽑아 `path:line` 이 실제로 그 내용을 담는지 확인했다.

- widget 10행 무작위 표본 중 인용 5건 직접 확인 — `widget_manual_content.py:231`(분류 머리글 접기) · `widget.js:331`(`setEditorResult`) · `urls.py:211`(`widget_rollback`) · `urls.py:284`(메인이미지 서빙) · `widget_manual_content.py:783`(`COMMON_PROPS`). **불일치 0**
- pagebuilder 6행 표본 전건 확인 — `pie-canvas-model.md:39/44/81`(사이트·프로젝트·Header/Footer) · `proposal.md:144/202`(성능 실측·ShopBy 리뷰 임베드) · `pie-canvas-engine-capabilities.md:225`(CSV 일괄 가져오기). **불일치 0**

## 4. 계약 보충 반영

| 보충 | 지시 | 반영 |
|---|---|---|
| 1 | 분모밖 기존 자산은 행 유지 + `evidence` 에 `[오픈분모밖] ` 접두 | 2행. 조사 3인 전원 「억지로 만들지 말 것」 지침대로 전수 확인 후 webadmin 0 · widget 0 · pagebuilder 2 |
| 1 개정 | `work_type=provided` 강제 철회 | 되돌릴 행 없음 — 2행 모두 `provided` 가 **원래 성격**(파트너사가 그대로 제공, 우리 작업 0). 검산에서 work_type 강제 규칙만 제거 |
| 2 | `config` = 코드 0 · 설정·등록만. 자사 화면도 포함. `manual` 은 검수·응대·수기 전달에만 | 적용. 이 판정이 보충 3 의 계기가 됨 |
| 3 | `work_type` 은 「어떻게 생기는가」, 「남은 일인가」는 `status` 가 진다 | widget `config` 34행 행별 재판정 → 34행 전량 `build` 로 이동(전부 「…지정/배치/토글」 = 빌더가 가진 능력), 과업 성격 2행만 분할해 `config` 유지. webadmin 127 build 는 그대로 |
| 4 | 화면도 기능도 없는 결정·관리 안건은 행이 아님 | 전수 스캔. `manual` 행 0건·「결정」 매치 5건은 전부 오탐(동작 서술). pagebuilder 3건 분리 → `pagebuilder-decisions.md` |

`config` 쌍둥이를 기계적으로 만들지 말라는 [HARD] 준수: 원장 대응이 있는 config 후보 21건 중 **2건만** 남겼다. 게시 관련 4행은 과업이 하나라 config 행도 하나(`T2-2`)만 뒀다.

## 5. 이중 계상 해소 (레인 내부)

webadmin 몫과 widget 몫이 같은 `urls.py` 라우트를 **16개에서 이중 계상**했다(17행). 귀속 기준 = **코드가 사는 쪽**(리드 승인).

- **widget 으로** — `sdk/guide`·`sdk/demo`·`sdk/cart-guide`(242·243·246) · 원고 업로드 `presign`·`multipart`(251·254) · Edicus 브리지 `editor/resolve`·`editor/token`(275·276). 근거: 카드가 「위젯↔webadmin 가격 API·Edicus 브리지는 integrate 행으로 분리」라고 명시
- **webadmin 으로** — `cart/*`(262·263·265, 호출 주체가 위젯이 아니라 쇼핑몰 서버 · `X-Huni-Server-Key`) · 자사몰 서버용 서빙 `swatch`·`guides`·`main-image(s)`·`designs`·`design-image`(278·281·284·286·288·290) · 위젯빌더 매뉴얼 문서 서빙(399)

연동 상대 이름도 통일했다: `huni-skin-shopby`(저장소명) 10행 → `huni-mall`(계약 용어). 안 했으면 t51 이 같은 시스템을 둘로 셌다.

## 6. 미확인 21행 — 무엇을 못 봤는가

| system | 건 | 내용 |
|---|---|---|
| webadmin | 1 | `price_sim_products`(`urls.py:176`) — 가격 시뮬레이터 상품 목록 API 인데 위젯빌더 팔레트 소스와 공용(`urls.py:184` 주석)이라 어느 화면 소유인지 매뉴얼로 확정 불가 |
| widget | 3 | 빌더 미리보기 업로드 `presign`·`multipart`(`urls.py:196·198`) 등 — 라우트·주석만 읽고 구현 미독 |
| pagebuilder | 17 | Pie Canvas **편집기 실화면을 연 적이 없다**(테스트 계정 사이트 0개 + 편집기 하드 내비 HTTP 500). 블록·바인딩 관련 다수가 번들 코드 역공학 근거 |

## 7. 이 원장이 드러낸 오픈 리스크

**pagebuilder 62행 중 `완료` 0행.** 설계 산출 디렉터리 `02_research`·`03_inventory`·`04_design`·`05_ops-sim` 가 전부 비어 있고(실측: 파일 0), 하네스 게이트는 NO-GO(대외배포)/CONDITIONAL(파일럿)이다. 화면 수·탭 수는 제안서의 **설계값이지 실무 실측값이 아니다**.

**파트너사 코드 변경이 필요한 행 = 우리가 만들 수 없는 것** (전부 `owner_side=pagebuilder`):

| screen_id | 내용 | 성격 |
|---|---|---|
| `pc-editor-hardnav` | 편집기 하드 내비·새로고침 HTTP 500 (P0 버그 B1 · 실측 사이트 3개 전부 재현) | 실무진에게는 「편집하다 새로고침하면 에러」 |
| `pc-link-product` · `pc-req-f3-link-1n` | `POST link-product` 의 `productId` 가 **단수** — 동적 페이지로 사이트 1개에 상품 N개를 담으면 연결이 무의미(C7 구조 충돌) | ⓐ 공식 확인 또는 ⓑ 1:N 개발이 착수 전제 |
| `pc-new-product` | `/sites/new-product` 가 「서비스 준비중」 미구현 | 후니 전용 진입점인데 자리만 있음 |
| `pc-req-s1-domain-allow` · `pc-block-external` | 외부 콘텐츠 허용 도메인 정책 미공개 | 등록 없이는 갤러리·리뷰 탭 2개가 막힘 |
| `pc-req-f1-display-cond` · `pc-req-f2-partial-override` | 표시 조건 · 부분 override | 있으면 좋은 것(착수 차단 아님) |

**가이드북의 실체는 pagebuilder 가 아니라 webadmin 이다.** 파일 업로드·관리가 `urls.py:72-89`, 조회가 `api/w/v1/guides` 이고 그 주석이 소비자를 「자사몰 웹서버」로 못박는다. Pie Canvas 가 이를 소비한다는 근거는 0건이라 해당 2행은 `미확인`. 상세페이지의 「디자인가이드」 **본문**만 Pie Canvas 페이지다.

## 8. 판단이 갈릴 수 있는 지점 (t51·리드 확인용)

1. **Edicus 브리지 `owner_side=widget`** — 브리지 코드가 `widget.js:414/593/613` 안에 있다. 파일이 webadmin static 에 배포되지만 호출·수명주기를 쥔 쪽은 위젯이라 widget 으로 잡았다. **배포 위치 기준**으로 세려면 webadmin 이다.
2. **빌더 운영 도구 자체에 대응하는 원장 행이 없다** — widget NEW 71행의 대부분. A3 가 「위젯 구성·기본값·게시」인데 실제 원장 행은 `T2-2` 하나뿐이다. 상단바·팔레트·캔버스·패널 접기를 런웨이에 올릴지는 판단이 필요하다.
3. **후가공 속성창이 NEW** — `STD-OPT-024~033`(코팅·박·형압·오시…) 개별 공정 행에 분산돼 「빌더의 후가공 속성 지정」 단위 행이 없다.
4. **`STD-CAT-043`**(시작가를 `GET /api/w/v1/catalog` 로 이관) — API 존재 기준 `완료` 지만 **이관 작업 자체는 미착수**인 별건.
5. **1회성 오픈 검증을 `manual` 로 칠 것인가** — `T2-4` 「위젯 견적·원고 업로드·편집기 경로 검증」은 사람이 하는 검증이나 「**반복 운영**」이 아니라 세우지 않았다. 친다면 1행 추가.
6. **`pc-req-f3-link-1n`** — C7 이 ⓐ(공식 확인) 갈래로 결론나면 1:N 개발이 사라지고 확인 안건만 남는다. 그때 이 행도 `pagebuilder-decisions.md` 로 옮겨야 한다.
7. **webadmin 고객 마스터(`t_cus_customers`)** — 신규몰 회원은 샵바이 소관이라 유휴 자산일 가능성이 있으나 실제 쓰임을 확인하지 않았다. 미검증 추정으로 분모 밖 판정을 내리는 건 근거 없는 주장이라 분모 안에 뒀다. **실무진 확인이 필요한 1건.**
8. **`manual_content.py:1210`** 「담당 개발자에게 데이터 정합성 검사를 요청하세요」 — 수기 요청 성격이라 webadmin 몫에 `manual` 행 후보가 될 수 있다(이번엔 세우지 않음).

## 9. 남은 것

- Pie Canvas **편집기 실화면 미개봉** — 테스트 계정 사이트 0개 + HTTP 500. pagebuilder 미확인 17행이 여기서 온다.
- webadmin·widget **라이브 실화면 대조 미수행**(§3).
- `03_inventory`·`05_ops-sim` 공란 — 컨텐츠 인벤토리·운영자 동선 실측 0건.

## 10. 산출 파일

| 파일 | 내용 |
|---|---|
| `screens.csv` | **342행 원장** (계약 13열) |
| `pagebuilder-decisions.md` | 결정·관리 안건 3건 (보충 4) |
| `progress.md` | 작업 경과·원천 우선순위·중단점 |
| `verdict.md` | 이 문서 |
| `_part-{webadmin,widget,pagebuilder}.csv` | 시스템별 원본 (조립 입력) |
| `_assemble.py` · `_dedup.py` · `_normalize.py` · `_stats.py` | 검산·조립 스크립트(재현용) |
| `_verify.txt` | 검산 출력 원본 |
| `_planrows-{A,B,misc}.csv` | 735행에서 뽑은 매핑용 부분집합 |
