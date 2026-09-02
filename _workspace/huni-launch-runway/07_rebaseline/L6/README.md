# L6 — 엑셀 5시트 생성기 · 인터랙티브 아티팩트 생성기

원장 CSV 한 개를 넣으면 **엑셀 · 대시보드 · LEDGER.md** 가 나온다.
P1 이 원장을 v2 로 갱신하면 **경로만 바꿔서 다시 돌린다.**

## 다시 만드는 명령 (한 줄)

```bash
cd _workspace/huni-launch-runway/07_rebaseline && L=L5/P1/unified-ledger-v2.csv && python3 L6/build_xlsx.py --ledger $L && python3 L6/build_artifact.py --ledger $L
```

원장 경로를 안 주면 현재 원장(`L5/unified-ledger-assigned.csv`)을 쓴다.

```bash
python3 L6/build_xlsx.py        # 엑셀만
python3 L6/build_artifact.py    # 대시보드 + JSON + LEDGER.md
```

두 생성기 다 **끝나면 검산 결과를 찍고, 하나라도 틀리면 exit 1** 을 낸다.

## 무엇이 나오나

| 산출 | 경로 |
|---|---|
| 엑셀 5시트 | `docs/huni/후니프린팅_통합IA_일정_역할분담_260902.xlsx` |
| 인터랙티브 대시보드 | `L6/runway-dashboard.html` (단일 파일) |
| 대시보드 데이터 | `L6/runway-data.json` |
| 원장 요약 | `07_rebaseline/LEDGER.md` |
| 렌더 캡처 | `L6/shots/` |

**260616 원본은 읽기만 한다.** 생성기가 원본을 여는 곳은 검산(시트명·열 구조 대조) 한 곳뿐이다.

## 입력

| 입력 | 기본 경로 | 바꾸는 인자 |
|---|---|---|
| 원장 CSV | `L5/unified-ledger-assigned.csv` | `--ledger` |
| 게이트 원문 | `L5/O2/gates.md` | `--gates` |
| 의존 그래프 | `L5/O2/dep-graph.json` | `--dep` |
| 시나리오 | `L5/O1/scenario-matrix.csv` | `--scen` |
| X·P 트랙 | `L5/O3/xp-track.csv` | `--xp` |
| 닫기팩 | `L5/O3/close-pack/` | `--close` |
| 양식 SOT(읽기 전용) | `docs/huni/…_260616.xlsx` | `--template` |

## 엑셀 — 02_IA마스터 11열 매핑표

260616 의 열 이름·순서를 그대로 쓴다. 원장에 축이 없는 3열은 **지어내지 않고 「미판정」**이다.

| 260616 열 | 원장 열 | 규칙 |
|---|---|---|
| No | — | 원장 정렬 순서 1..N |
| 시스템 | `대분류` | 규칙표로 4종에 묶는다 — 생산·공정→`생산·MES` · `운영자·*`/`정산·통계`→`관리자` · `시스템·플랫폼`→그대로 · 나머지→`쇼핑몰` |
| 영역 | `중분류` | 그대로 |
| 기능 | `기능` | 그대로 |
| 우선순위 | `오픈차단여부` | 값 그대로 — `차단(외부)` / `작업 항목` / `오픈 무관` / `미판정`. 260616 의 P0·P1·P2 축은 원장에 없어 이 축으로 대체 |
| 담당 | `담당` | 그대로 |
| 개발규모 | — | **미판정** — 원장에 규모 축 없음 |
| 진행상태 | `상태` | done→완료 · partial→진행중 · todo→미착수 · new→신규발견 · 미판정→미판정 |
| Phase | — | **미판정** — 이 판의 일정 축은 게이트다(`03_페이즈일정`) |
| 확인·결정 필요사항 (선행조건) | `done_criteria` | 비었으면 미판정. 열 이름은 260616 그대로 두고 뜻은 `00_읽는법` 에 적었다 |
| 비고 | `비고`+플래그 | `신규발견 · 돈 · 주문 · 트랙:web · <원장 비고> · std_id · legacy_id` 를 `·` 로 이어 붙임 |

### 260616 과 의도적으로 다른 3가지

1. **우선순위**가 P0/P1/P2 가 아니라 원장의 **오픈차단여부**다. `개발규모`·`Phase` 2열은 원장에 축이 없어 미판정.
2. `04_진행현황` 의 첫 집계 축을 **우선순위 → 진행상태**로 바꿨다. 오픈을 막는 축은 새로 붙인 **⑤ 오픈차단여부 × 담당** · **⑥ 차단(외부) 전건** 두 표가 맡는다.
3. `03_페이즈일정` 이 Phase 1~3 대신 **게이트 G0~G5** 다. 내용은 `L5/O2/gates.md` 를 기계 파싱해 채우고,
   이탈 조건 문장을 키워드 규칙표(`GATE_OWNER_RULES`)로 담당 3열에 배정한다.

## 대시보드

- 탭 6개 — 원장 · 게이트 G0~G5 · 시나리오 · X·P 트랙 · 의존·임계경로 · 닫기팩
- 원장 필터 — 담당 · 상태 · **차단 등급** · 대분류 · 돈 Y · 주문 Y · 안 닫힌 것만 · 검색
- **차단(외부)** 행은 왼쪽 빨간 띠 + 「차단」 배지로 강조된다. KPI 에 「차단(외부) N」 · 「오픈 무관 N」
- 체크 상태 = `localStorage['huni-runway-checks']` 의 객체. **키는 `legacy_id`, 없으면 `std_id`**
- 테마 = `prefers-color-scheme` 자동 + 우상단 토글(`localStorage['huni-runway-theme']`)
- 외부 CDN 은 **cdnjs(mermaid) · Google Fonts** 만. 검산이 화이트리스트를 강제한다

### [HARD] mermaid 를 고칠 때 조심할 것

`<pre class="mermaid">` 안에 **날것 `<br/>` 를 넣으면 안 된다.** HTML 파서가 진짜 BR 태그로 먹어
`textContent` 에서 사라지고, 노드 라벨이 줄바꿈 없이 붙어 버린다(2026-09-02 실측).
`html_escape_mermaid()` 가 `&lt;br/&gt;` 로 바꿔 넣고, 검산이 날것 `<br>` 0건을 확인한다.

도식은 **보이는 탭에서만** 그린다. 숨은 탭에서 그리면 폭·높이가 0이라 좌표가 `NaN` 이 된다.

### 캡처 다시 찍기

`file://` 은 브라우저가 막는다. 로컬 서버로 띄운다.

```bash
python3 -m http.server 8791 --bind 127.0.0.1 &
B=~/.claude/skills/gstack/browse/dist/browse
$B viewport 1440x1000
$B goto "http://127.0.0.1:8791/L6/runway-dashboard.html?v=$(date +%s)"   # ?v= 없으면 옛 파일이 캐시된다
$B screenshot --viewport L6/shots/01-light.png                            # --viewport 없으면 8만px 세로 캡처
```

## 검산 (생성기가 스스로 찍는다)

| # | 무엇 | 어디서 |
|---|---|---|
| ① | 시트명 5종 · `02_IA마스터` 11열이 260616 과 일치 | `build_xlsx.py` — openpyxl 로 원본과 대조 |
| ② | 대시보드 항목 수 = 원장 행 수 | `build_artifact.py` — HTML 안 `DATA.ledger` 를 다시 파싱해 셈 |
| ⑤ | mermaid `<br/>` 이스케이프 | `build_artifact.py` — 소스형 + `<pre>` 주입형 둘 다 |
| ⑥ | 원장에 없는 항목 창작 0 | 두 생성기 — `기능` 문자열이 전건 원장 유래인지 + 비고에 `std_id` 있는지 |
| L6b | `우선순위` 빈칸 0 · 값이 원장 `오픈차단여부` 와 전건 일치 | `build_xlsx.py` — 504행 열 대조 |
| L6b | 대시보드 `block` 키 504행 · 분포가 원장과 일치 | `build_artifact.py` — HTML 안 `DATA.ledger` 재파싱 |
| · | 외부 CDN 화이트리스트 | `build_artifact.py` — HTML 안 모든 `https://` URL |

③(라이트/다크 캡처) ④(체크 새로고침 유지) ⑦(재실행)은 브라우저가 필요해 `progress.md` 에 증거를 적었다.
