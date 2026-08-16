# Huni-WorldModel 트랙 — 다음 세션 인계 (HANDOFF)

> 최종 갱신: 2026-08-16. 이 파일은 **재시작 포인터**. 상세 이력=`CHANGELOG.md`,
> 판정 기록=`05_gate/`, 설계=`04_design/design-FINAL.md`, SPEC=`.moai/specs/SPEC-WORLDMODEL-001/`.
> source_session_id: `250a060e-6d22-495b-851e-f6cf0ed0ba4d`

## 한 줄 현황

**SPEC 작성이 끝났고 게이트 재심까지 마쳤습니다. 구현(S1)은 한 줄도 시작하지 않았습니다.**
설계 등급 **AMEND(CONDITIONAL_GO)** · S1 착수 차단 조건 **없음** · 남은 채무는 전부 S2 이후 또는 별건.

## 다음 세션 최우선 액션

**S1 구현 착수** — 결정론 층만 만든다. LLM 은 이 단계에 들어오지 않는다.

S1 산출물 6개 (`design-FINAL.md` §7):
```
simcore/_bindings.py                 import 모음 (심볼 12종)
simcore/joint.py                     JointTransition (a)~(g)
loop/frontier.py + loop/rollout.py   후보 열거 · 읽기전용 트랜잭션 + 무조건 롤백
gates/premise.py                     G0 / G0.5a / G0.5b / G0.9
gates/golden_rollout.py              골든 측정
gates/sql_control.py                 순수 SQL 대조군 (G9)
```

착수 즉시 걸리는 것 2개:
- **AC-TR-06** (S1 산출물 경계) — 6산출물 실재 + 금지 심볼 5종 grep 0건
- **FU-7 어긋남** — 재심은 *"S1 범위에 `loop.Scorer` 포함"* 을 전제로 R-02 를 S1 차단으로 판정했으나, 위 6산출물에 `Scorer` 가 없다. **구현 시 Scorer 를 S1 에 넣을지 말지가 첫 결정**이며, 넣지 않으면 R-02 의 S1 차단 근거가 사라진다(판정 자체는 게이트 소관 — 되돌리지 말 것).

## 대안 진입점 (S1 대신 고를 수 있는 것)

| | 무엇 | 상태 |
|---|---|---|
| clone 리허설 | `brew install postgresql@18` → 덤프·복원·동일성 검사 1회 | G6 오라클을 **실측으로** 닫는다. 현재 FEASIBLE 은 *"차단요인 부재의 실측"* 이지 *"성공 실행의 관측"* 이 아님 |
| 루브릭 개정 ①~⑤ | `evaluation-rubric.md` v1.0 → v1.1 심의 | 다음 검증 라운드 **전** 필수. 개정 시 사전선언성이 깨지지 않도록 **개정 이력 필수** |
| 파일럿 상품군 선정 | 6기준을 288 전건에 읽기전용 SELECT 적용 | 6번째 기준(`use_dims` 빈 구성요소 보유)이 P-05 를 첫 파일럿에서 드러나게 하는 **유일한 장치** — 마지막에 완화 |

## 현재 판정 상태

```
설계 등급        AMEND (CONDITIONAL_GO) · amend_cleared = false
재심 결과        재심 대상 8규칙 중 CLOSED 5 · STILL_OPEN 3
                 CLOSED     RULE-05 · 09 · 12 · 13 · 14
                 STILL_OPEN RULE-02(교정됨·재심 미판정) · RULE-10(S2) · RULE-18(교정됨·재심 미판정)
루브릭 커버리지   18/18 · 미검증 0 · 부분검증 0
요구사항 추적성   64건 전건 §H 등장 · 직접 51 · 간접 9 · 미커버 4 (6.3%)
fail-closed      13지점
자율 레벨        룰베이스 ~ 플로우 가이드 (세미 오토노머스 아님 · 의도적)
```

**주의**: R-02·R-18 은 이번 세션에서 **교정했으나 게이트 재심을 받지 않았다.** `design-FINAL.md` §8 의 "교정 후 충족" 은 **자기평가**이며 재심 권한은 게이트에 있다.

## 남은 채무

| ID | 내용 | 차단 |
|---|---|---|
| **R-10** (=CS2-01) | `rule_cd` 배선 — **명세 완료 · 구현 미착수** | **S2** 착수 전 |
| **FU-6** | `esc_kind` 채번(`RULE_ID_UNRESOLVED`) — 7종→8종 + `route_to` 1행 + `U-007.1` 갱신을 **한 묶음으로** | M2-c |
| **FU-7** | 재심 전제(`Scorer` S1 포함) ↔ 산출물 목록 어긋남 | 다음 재심 |
| **FU-5** | `soft_prefs.dir` 의미 미확정(등급? 표시순서? 가격?) | **M3 전** 필수 |
| 조건 ⑧ | 루브릭 개정 ①~⑤ 심의 | 다음 검증 라운드 전 |
| 미측정 2건 | `rule_nm` 중복 실재 여부 · `nm` 이 `"제약"` 으로 떨어지는 행 수 | S2 첫 실측 |
| clone 리허설 | `pg_dump` 0회 실행 상태 | 없음(권고) |

## [HARD] 이 트랙의 규율 — 어기면 판정이 무효가 된다

1. **판정 기록 사후 수정 금지** — `05_gate/*` 전체 + `04_design/evaluation-rubric.md` + `03_problem/problem-ledger.md`. 교정은 설계·SPEC 쪽에서만 한다. (mtime 으로 검증 가능)
2. **`raw/webadmin/**` 무수정 · 라이브 DB 읽기 전용 SELECT 만.** 이 세션 전 과정에서 지켜졌다.
3. **적대검증 규율** = `.claude/rules/moai/core/adversarial-verification-governance.md` (332행, `CONST-V3R6-002~018`). 반증 5요건 · 기본값=각하 · 반박 라운드 · 다수결 금지 · 오판 감사 필수 · 임계 미달 시 진단 순서(**루브릭 → 프롬프트 → 설계**).
4. **검증 출처 구분** — 보충 라운드 산출을 원 라운드 산출처럼 쓰면 사후 위조다(`AC-M0-08`).
5. **"위반 미확정" ≠ "미검증"** — 재지 않은 것을 통과로 쓰지 않는다.

## 함정 3개 (이 세션에서 실제로 걸렸다)

1. **좌표 드리프트** — `design-FINAL.md` 는 804 → 1,046 → 1,123 → **1,203행**으로 자랐다. 판정 기록이 인용한 좌표는 **그 시점 판본 기준**이다. `design-FINAL.md` §0.0 의 "좌표 기준 변경" 블록을 먼저 읽고, **상호 참조는 절 번호로** 하라.
2. **요구사항 ID 정규식 사각지대** — `[UX]-\d{3}` 로 세면 **`E-`/`S-`/`O-` 9건을 놓친다**(실제 64건, 잘못 세면 55건). 그중 `S-005.1`(전제 센서 통과해야 롤아웃)은 루프의 전제 조건 자체다. 반드시 `[UXESO]-` 로 세라.
3. **mermaid `<br/>`** — HTML 아티팩트의 `<pre class="mermaid">` 안에서는 `&lt;br/&gt;` 로 이스케이프해야 줄바꿈이 산다. 날것 `<br/>` 는 DOM 요소로 먹혀 사라지고 **`mermaid.parse()` 는 통과하므로 파서로 안 잡힌다.** 발행 전 jsdom 디코드+파싱 하네스로 검증하라.

## 산출물 지도

```
_workspace/huni-worldmodel/
  01_research/   R1~R7 이론 7편 + RESEARCH-REPORT.md (108KB)
  02_diagnosis/  D1~D8 webadmin 진단 8편
  03_problem/    problem-ledger.md — 문제 26항 · 가설 판정 PARTIALLY_CONFIRMED
  04_design/     evaluation-rubric.md (사전선언 18규칙 v1.0 · 수정 금지)
                 design-A/B/C + design-FINAL.md (1,203행) + score-L1~L3
  05_gate/       gate-report.md (원 라운드 · 정밀도 0.39)
                 coverage-supplement.md (RULE-03·17) · -2.md (RULE-10·18)
                 gate-rehearing.md (재심 · 정밀도 1.00) · g6-clone-feasibility.md
                 _codex/ _codex2/ (codex 판정문 원문)
  06_artifact/   worldmodel-story.html — 발행됨(비공개)
                 https://claude.ai/code/artifact/4ce2fc21-da1a-41f2-a7b0-d7bae1e77b7d

.moai/specs/SPEC-WORLDMODEL-001/   spec 887 · plan 450 · acceptance 731 = 2,068행
.claude/rules/moai/core/adversarial-verification-governance.md   332행 (신설)
.claude/rules/moai/core/zone-registry{,-design-mirror,-ci-protocol}.md  (분할됨)
```

## 이론 축 판정 (이주환 ESTC 3단)

```
① 사람이 세계를 선언   부분   E·C 는 그릇 있음 / S·T 는 없음, T 는 편집 불가(함수 구현)
② 경계 안에서 자율     충족   재심에서 한 번 흔들렸다 R-02 로 복구 — 경위는 SPEC §11.4-a
③ 갭 재서 자율 조율    미충족 측정은 하나 되먹임 없음 · 관측 채널이 원리적으로 얇음
```

**①③ 이 열린 이유는 역량이 아니라 범위 선택의 귀결**이다(`spec.md` §11.7). 닫으려면 라이브에 그릇을 만들어야 하고(`t_ord_*` 신설 · T 편집 화면 · 관측 write), 그것은 **경영 판단**이다.
