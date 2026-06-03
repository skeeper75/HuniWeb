# Huni-Widget 하네스 — 에이전트 팀 모드 실행 지침

다음 세션에서 하네스를 **에이전트 팀(`TeamCreate`)** 으로 실행하기 위한 완전 지침. 2026-06-03 세션(서브 파이프라인 + 부분 팀 교차검증)의 교훈 반영.

---

## 0. 전제 — 이미 설정됨 (확인만, 추가 설정 불필요)

세션 시작 시 자동 로드된다. 한 번 확인:
```bash
grep CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS .claude/settings.json   # "1"
grep -A4 "    team:" .moai/config/sections/workflow.yaml          # enabled:true, default_model:opus
grep "execution_mode" .moai/config/sections/workflow.yaml         # team
```
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` (settings.json env) ✅
- `workflow.team.enabled: true` + `default_model: opus` + role_profiles 7개 opus ✅
- `workflow.execution_mode: team` ✅

## 1. 트리거 — 다음 세션에서 이렇게 말하면 팀 모드

오케스트레이터(`huni-widget-orchestrator`)를 깨우는 표현 + 팀 명시:
- "huni-widget 하네스를 **팀으로** 실행"
- "전체를 **에이전트 팀으로** 진행"
- "[작업]을 **팀 모드로**"
- "**팀으로 재검증**" / "다중 렌즈로"

오케스트레이터가 트리거되며 SKILL.md v1.3.0의 "실행 모드: 팀 vs 서브" 기준을 적용한다.

## 2. 무엇을 팀으로 / 무엇을 서브·직접으로 [핵심 — 전부 팀이 능사가 아님]

이번 세션이 입증: **팀이 빛나는 곳은 다중 렌즈 분석·교차검증.** 단일 검증·순차 보정·캡처·`.claude` 수정은 서브/직접이 맞다(기술 제약).

| 작업 | 모드 | 이유 |
|------|------|------|
| **다중 렌즈 분석** (코드정합 S0 4모듈·S1 D1~D4·교차검증 3렌즈) | **팀** (read-only, background) | 병렬 + 발견공유·상충토론·누락보완·자가 오탐정정 |
| **Phase 2** 동작분석 + 리서치 | **팀** (병렬 2팀원) | 독립 병렬 |
| **설계 합의** (예: 후니 컨버전 어댑터 설계) | **팀** (다관점 합의) | 권위/매핑/검증 렌즈 토론 |
| 단일 독립 재검증 (hw-qa) | **서브** | 회의적 단일 검증이 본질 — 여럿이면 책임 분산 |
| 순차 보정 (같은 04_build 파일) | **서브** (메인 트리) | worktree node_modules/머지 비용 + INV-3 `git diff` 증명은 메인에서 |
| 라이브 캡처 | **서브** (단일) | `:3001` 단일 테스트베드 공유 — 동시 접근 충돌 |
| `.claude` 스킬/에이전트 수정 | **직접/foreground** | untracked → worktree에 안 따라옴 |

> 결론: **분석·교차검증=팀, 단일검증·순차보정·캡처·.claude수정=서브/직접.** 하이브리드가 최적.

## 3. 팀 구성 절차 (TeamCreate 워크플로우)

```
1. TeamCreate(team_name: "huni-...", description)          # 팀+TaskList 생성
2. TaskCreate × N                                          # 작업 단위(Phase/렌즈)
3. Agent(subagent_type:"general-purpose", team_name,       # 팀원 spawn
         name:"...", model:"opus", run_in_background:true)
4. (팀원이 TaskUpdate owner claim → 작업 → SendMessage 자체조율)
5. 리더(MoAI)가 팀원 메시지 종합                            # 자동 전달
6. SendMessage(shutdown_request) × N → approve → TeamDelete # 정리
```

팀원 프롬프트 필수 요소: 팀 config 경로(`~/.claude/teams/{team}/config.json`), `team-protocol.md` 준수, 이름으로 호출, SendMessage로만 소통, 자기 task claim, 발견 공유·토론.

## 4. 제약 [HARD]

- **세션당 한 팀만**. Phase별 다른 조합 필요 시 `TeamDelete` 후 새 `TeamCreate`(이전 산출물은 파일로 저장).
- **background 팀원은 Write 금지**(자동 거부). → read-only 분석만 background. 파일 수정 팀원은 `isolation:worktree`(04_build, git tracked) 또는 foreground.
- **`.claude` 수정은 worktree 불가**(untracked) → 직접/foreground.
- **04_build worktree는 node_modules 미포함** → vitest 돌리려면 npm 재설치 비용. 보정은 메인트리 서브가 효율.
- 팀원은 사용자에게 질문 불가 — AskUserQuestion은 리더(MoAI)만.

## 5. 팀원 역할 매핑

- **분석/검증 렌즈**: `general-purpose`, `mode:plan`(read-only), `run_in_background:true`, `model:opus`. 발견은 SendMessage. (이번 세션 authority/integration/assumption 렌즈 패턴)
- **role_profiles** (workflow.yaml, 전부 opus): researcher/analyst/architect(plan,none) · implementer/tester/designer(acceptEdits,worktree) · reviewer(plan,none).
- **하네스 커스텀 에이전트도 팀원 가능**: `subagent_type:"hw-architect"` 등(단 팀 통신 위해 general-purpose가 안전).

## 6. 실전 예시 — 다음 세션 "후니 컨버전을 팀으로"

하이브리드 구성:
1. **팀(분석·합의)**: `TeamCreate("huni-conversion")` → 3 read-only 렌즈 팀원 background opus
   - `red-authority`: Red 어댑터 계약(`src/adapters/red/`)이 정규화 계약과 어떻게 매핑되나
   - `huni-mapping`: 후니 DB/옵션마스터(`docs/huni/`) ↔ 정규화 계약 필드 대조
   - `lossless-verify`: 무손실 컨버전 조건·리스크(`07_parity/`, huni-db-mapping)
   - → SendMessage 합의 → 리더 종합(createHuniAdapter 설계)
2. **서브(구현)**: 팀 정리 후 단일 builder(메인 트리) → `createHuniAdapter` 구현 + shape 테스트
3. **서브(검증)**: hw-qa 독립 재검증(field 대조·왕복·게이트)

즉 **설계=팀, 구현·검증=서브.**

## 7. 주의 — "전체 팀"의 함정

모든 단계를 팀으로 강제하면 오히려 비효율(단일 검증 책임분산·순차 보정 worktree 비용·캡처 충돌·`.claude` untracked). **오케스트레이터 v1.3.0의 "팀 vs 서브" 기준을 따라 하이브리드**가 최적이다. "팀으로"는 분석·교차검증·설계 합의 단계에 적용하고, 단일 독립검증·순차 보정·캡처는 서브로 둔다.

---
**참조**: 오케스트레이터 SKILL.md v1.3.0(실행 모드 기준·실행지침) · `HANDOFF.md`(다음 할 일) · `07_parity/harness-improvements.md`(개선점) · `.claude/rules/moai/workflow/team-protocol.md`(팀 프로토콜)
