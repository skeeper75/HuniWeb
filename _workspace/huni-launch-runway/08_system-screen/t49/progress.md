# t49 진행 기록 — 오픈일정 S2: webadmin · widget · pagebuilder 화면·기능 원장

- 카드: t49 (Factory Mode · lane-3)
- 워크트리: `.claude/worktrees/t49` · 브랜치 `WT-admin-widget-screens`
- 계약: `_workspace/huni-launch-runway/08_system-screen/CONTRACT.md`
- 산출: `_workspace/huni-launch-runway/08_system-screen/t49/screens.csv`
- 원칙: 읽기전용 · DB write 0 · 라이브 COMMIT 0 · 숫자 날조 0

## 원천 우선순위 (계약 「앱 내장 매뉴얼 2종 1차 참조」 = 도메인 룰 `huni-webadmin-manual-first.md`)

| 순위 | 원천 | 경로 |
|---|---|---|
| 1 | 운영자 매뉴얼 원고 | `raw/webadmin/tools/manual_content.py` (1,468행) |
| 2 | 위젯빌더 매뉴얼 원고 | `raw/webadmin/tools/widget_manual_content.py` (1,117행) |
| 3 | 라우트 전수 | `raw/webadmin/webadmin/config/urls.py` (405행) — `path:line` 근거의 주 원천 |
| 4 | 뷰·템플릿·런타임 JS | `raw/webadmin/webadmin/catalog/` — 교차검증에만 |
| — | pagebuilder(Pie Canvas) | `_workspace/huni-page-compose/01_recon/` · `99_proposal/` (파트너사 소유 SaaS · 코어 수정 통제 밖) |

`raw/` 는 미트래킹이라 워크트리에 없다 → 메인 체크아웃 절대경로로 읽었다.
`plan-rows.csv`(735행)는 반대로 워크트리(origin/main)에만 있다 — 메인 체크아웃은 origin/main 대비 30 커밋 뒤처져 있어 `07_rebaseline/S/S5-plan/` 자체가 없다.

## 작업 방식

세 시스템을 병렬 조사 에이전트 3인에 팬아웃(읽기전용) → 각자 `_part-<system>.csv` 산출 →
lane 이 `_assemble.py` 로 합치고 계약 규칙을 기계 검산 → `screens.csv` 1개.
계약 검산 항목: 헤더 고정 · system/work_type/role/status 허용값 · evidence 빈칸 0 ·
`integrate` 행의 counterpart/direction/owner_side 필수 · 비-integrate 행의 그 3열 공란 ·
`plan_row_id` 가 735행에 실재(아니면 `NEW`) · (system, screen_id, function) 중복 0 ·
보충 1 접두 `[오픈분모밖] ` 가 고정 문자열이고 그 행의 work_type 이 `provided` 인지.

## 계약 보충 1 (260919 · 리드 lane-1 · t50 제기) 수신·반영

오픈과 인과관계가 없는 기존 자산은 **행을 빼지 않고** `work_type=provided` + `evidence` 맨 앞에
`[오픈분모밖] ` 고정 접두. work_type 6번째 값은 만들지 않는다. verdict 에 분모밖 행수를 따로 적는다.
→ 조사 에이전트 3인에 전달, `_assemble.py` 에 접두·work_type 정합 검사와 집계 추가.
판정은 보수적으로 — 「이미 있다」만으로는 부족하고 오픈과 인과관계가 없어야 분모밖이다.

## 진행

- [x] 계약·카드 정독, 원천 위치 확정
- [x] 워크트리 생성 + 브랜치 `WT-admin-widget-screens`
- [x] plan-rows 735행 → 매핑용 부분집합 3종 추출 (`_planrows-A/B/misc.csv`)
- [x] 조립·검산 스크립트 `_assemble.py`
- [x] 3시스템 실측 (병렬) — webadmin 154 · widget 140 · pagebuilder 65 초안
- [x] 이중 계상 17행 해소 · 연동 상대 이름 통일(`huni-skin-shopby`→`huni-mall`)
- [x] 리드 보충 1(개정)·2·3·4 반영 — widget config 34행 재판정, 안건 3건 분리
- [x] 조립 + 검산(errors=0) + `verdict.md` — **342행 · 화면 188종**

## 확인된 사실 (근거 있는 것만)

- pagebuilder = **Pie Canvas** — 파트너사 소유 SaaS. 하네스 게이트 판정 NO-GO(대외배포)/CONDITIONAL(파일럿),
  「파트너사 필수 수정 없음」 결론은 2026-07-29 조건부 강등됨
  (`_workspace/huni-page-compose/CHANGELOG.md` 첫 행). 이 두 가지에 기댄 행은 완료로 올리지 않는다.
- A5(상세페이지·가이드·홈 콘텐츠) 원장 행은 `STD-*` 체계(예 `STD-CAT-034` 상세페이지 탭 6종 자동 등록,
  `STD-INF-007` 가이드북 고객 화면)이고, 상당수는 pagebuilder 가 아니라 huni-mall(스킨) 소관이다 —
  이 카드 범위 밖이므로 가져오지 않는다.
