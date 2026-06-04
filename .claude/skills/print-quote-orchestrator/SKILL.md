---
name: print-quote-orchestrator
description: >
  후니프린팅 리뉴얼 + **자체 웹빌더(Elementor 류) 구축** 기획·설계·분석 하네스 오케스트레이터.
  As-Is(buysangsang) 빌더 패턴 7축 역공학(widget/layout/template/interaction/form/token/plugin) + huni 실데이터 분석 + 빌더 엔진 도메인 모델 + 견적 도메인(IA/DB/API/가격엔진) + 화면설계·UX + 통합 설계서 + buildability 커버리지 KPI 까지 5인 팀(researcher/business-analyst/architect/designer/pm)으로 병렬 수행.
  '후니프린팅 리뉴얼', '자체 빌더 설계', '웹빌더 도메인 모델', 'As-Is 패턴 역공학', '인쇄 견적 사이트 설계', 'print quote design', '자동견적 기획', '견적 마법사 설계', '설계서 작성', '다시 분석', '설계 업데이트', '특정 영역만 재설계' 요청 시 반드시 사용.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, Agent, AskUserQuestion, TodoWrite
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-05-27"
  tags: "print, quote, huni, design, planning, agent-team"
---

# Print Quote — 기획/설계 오케스트레이터

## Phase 0: 컨텍스트 확인

워크플로우 시작 전 기존 산출물 확인:

```bash
ls _workspace/print-quote/ 2>/dev/null
ls _workspace/print-quote/_baseline/ 2>/dev/null
```

분기 규칙:
- `_workspace/print-quote/00_pm/` **없음** → **초기 실행** (Phase 1부터 전체)
- 존재 + 사용자가 **부분 영역만 재설계** 요청 → **부분 재실행** (해당 에이전트만)
- 존재 + 사용자가 **새 입력/방향 변경** 요청 → 기존을 `_workspace/print-quote/_prev_YYYYMMDD/`로 이동 후 **새 실행**
- 존재 + 사용자가 **피드백 반영** 요청 → **증분 실행** (변경된 의존성 영역만)

`_baseline/`은 항상 유지(이전 dbtest 프로젝트의 7-도메인 SQL + ERD).

---

## Phase 1: 계획 수립 (pq-pm 단독)

**실행 모드:** 서브 에이전트 (단독, 가장 먼저)

pq-pm을 먼저 호출하여 마일스톤·RACI·task graph를 작성. 이후 4명의 작업 길잡이가 됨.

```
Agent(
  subagent_type: "print-quote/pq-pm",
  model: "opus",
  prompt: """
  자동인쇄 견적사이트 기획/설계 프로젝트의 계획을 수립한다.

  컨텍스트:
  - 베이스라인: _workspace/print-quote/_baseline/ (이전 DB 스키마 7종)
  - 입력 자료: docs/huni/ (실데이터), docs/{reversing,wowpress,shopby,figma}/ (참조)
  - 라이브 분석: https://buysangsang.com (계정 사용자가 제공)
  - 팀: pq-researcher, pq-business-analyst, pq-architect, pq-designer (본인 포함 5명)

  생성:
  1. _workspace/print-quote/00_pm/milestones.md  (M1~M5, DoD 포함)
  2. _workspace/print-quote/00_pm/raci.md
  3. _workspace/print-quote/00_pm/task-graph.md  (Mermaid, 병렬화 구간 표시)
  4. _workspace/print-quote/00_pm/status.md  (초기 상태)
  5. _workspace/print-quote/00_pm/decisions.md  (초기 결정 필요 목록)

  반환: 생성된 파일 경로 + 식별된 결정 필요 항목 수 + 권장 다음 단계.
  """
)
```

PM 산출물 확인 후, 식별된 `🟡 DECISION:` 중 사용자 결정이 즉시 필요한 항목은 AskUserQuestion으로 수집.

---

## Phase 2: 병렬 수집 (pq-researcher + pq-business-analyst)

**실행 모드:** 에이전트 팀 (2명 동시 병렬)

두 에이전트의 산출물은 서로 독립적이지만, 끝나면 상호 참조 가능.

```
TeamCreate(
  team_name: "pq-discovery-team",
  members: ["pq-researcher", "pq-business-analyst"]
)

TaskCreate(tasks: [
  {
    id: "D01",
    title: "경쟁사 라이브·문서 분석",
    assignee: "pq-researcher",
    description: "_baseline/01_research_report.md를 시작점으로, buysangsang 라이브 크롤(print-quote-live-crawl 스킬) + wowpress/red/shopby 문서 분석. 산출: 01_research/competitor-*.md, patterns.md, crawl-evidence/",
    dependencies: []
  },
  {
    id: "D02",
    title: "huni 실데이터·정책 분석",
    assignee: "pq-business-analyst",
    description: "docs/huni/ xlsx·pdf 5종 파싱. 산출: 02_business/product-master.md, pricing-rules.md, process-flow.md, order-flow.md, policy-checklist.md, glossary.md, requirements-ears.md",
    dependencies: []
  }
])
```

**팀원 공통 지시:**
- 작업 완료 시 TaskUpdate(completed)
- 중간 발견 사항은 SendMessage로 상대 에이전트와 공유
- 30분(또는 토큰 50% 시점) 마다 pq-pm에 진행 상태 SendMessage
- 완료 후 pq-pm에 종합 완료 통지

Phase 2 완료 후 pq-pm이 `consistency-report.md` 1차 작성.

---

## Phase 3: 병렬 설계 (pq-architect + pq-designer)

**실행 모드:** 에이전트 팀 (2명 동시 병렬, Phase 2 완료 후)

이전 팀 정리 후 새 팀 생성. 두 에이전트는 중간 단계에서 1회 동기화.

```
TeamDelete(team_name: "pq-discovery-team")

TeamCreate(
  team_name: "pq-design-team",
  members: ["pq-architect", "pq-designer"]
)

TaskCreate(tasks: [
  {
    id: "S01",
    title: "IA·DB·API·가격엔진 설계",
    assignee: "pq-architect",
    description: "_baseline/07_integrated_schema.sql + 02_business/* + 01_research/patterns.md 기반. 산출: 03_architecture/{ia,erd,schema.sql,api-spec,pricing-engine,admin-model,tech-stack}.md",
    dependencies: []
  },
  {
    id: "S02",
    title: "사이트맵·화면설계·UX 플로우",
    assignee: "pq-designer",
    description: "03_architecture/ia.md(생성 즉시)와 api-spec.md(중간 산출)를 받아 진행. 산출: 04_design/{sitemap,ux-flow,screen-spec,interaction-spec,design-system-notes,accessibility}.md + wireframes/*",
    dependencies: []
  }
])
```

**동기화 규칙:**
- pq-architect가 `ia.md` 작성 즉시 → SendMessage(pq-designer, "ia ready")
- pq-architect가 `api-spec.md` 초안 완료 → SendMessage(pq-designer, "api draft ready")
- pq-designer가 API 갭 발견 → SendMessage(pq-architect, "missing endpoint X for screen Y")

---

## Phase 4: 통합·교차검증 (pq-pm 단독)

**실행 모드:** 서브 에이전트 (단독)

```
TeamDelete(team_name: "pq-design-team")

Agent(
  subagent_type: "print-quote/pq-pm",
  model: "opus",
  prompt: """
  4명의 산출물이 모두 완료되었다. 교차검증 + 통합 설계서 작성.

  입력: _workspace/print-quote/{01_research,02_business,03_architecture,04_design}/ 전체

  작업:
  1. consistency-report.md 작성 (5축 검증)
     - 상품 모델 일관성 (business ↔ architecture ↔ design)
     - 가격 산식 일관성 (business ↔ architecture)
     - 상태 머신 일관성 (business ↔ architecture ↔ design)
     - 화면↔API 매핑 누락
     - EARS 요구사항 추적성 (REQ-XXX가 설계/화면에 모두 반영되었나)
  2. 99_integrated/design-spec.md 작성 (전 산출물 종합, 출처 인용)
  3. 99_integrated/executive-summary.md (1~2페이지)
  4. 99_integrated/handoff-to-build.md (SPEC 분할 권고, 우선순위, 위험)
  5. 00_pm/status.md 최종 갱신
  6. decisions.md에 미해결 결정 + 잠정 결정 정리

  반환: 통합 설계서 경로 + 미해결 항목 + 권장 다음 액션.
  """
)
```

---

## Phase 5: 사용자 보고 + 피드백 수집

오케스트레이터(MoAI)가 사용자에게 직접 보고:

1. 산출물 디렉토리 트리 출력 (`tree _workspace/print-quote/` 또는 `find`)
2. `99_integrated/executive-summary.md` 본문 표시
3. 미해결 결정 항목 → AskUserQuestion으로 결정 수집
4. 개선·재실행 의사 확인:
   - "특정 영역만 다시" → 해당 에이전트만 재호출 (Phase 0 컨텍스트 확인의 부분 재실행 경로)
   - "전체 통합 갱신" → pq-pm Phase 4 재실행
5. CLAUDE.md 변경 이력에 이번 실행 기록 (날짜·변경 내용·사유)

---

## 데이터 전달 프로토콜

| 흐름 | 방식 |
|------|------|
| 팀원 → 팀원 | SendMessage (조율·진행 공유) |
| 팀원 → 산출물 | 파일 기반 (`_workspace/print-quote/0N_*/`) |
| 산출물 → 다음 팀원 | 다음 에이전트가 Read |
| 사용자 결정 | 오케스트레이터의 AskUserQuestion → pq-pm |
| 팀원 완료 통지 | TaskUpdate(completed) |

---

## 에러 핸들링

| 상황 | 대응 |
|------|------|
| buysangsang 로그인 실패 | print-quote-live-crawl의 fallback(수동 캡처 요청) |
| huni xlsx 파싱 실패 | python pandas 재시도 → openpyxl 시도 → 사용자에게 CSV 변환 요청 |
| 베이스라인 SQL과 신규 모델 충돌 | pq-architect가 마이그레이션 표로 정리, pq-pm decisions.md에 기록 |
| 팀원 응답 없음 (5분) | 재시작 1회 → 실패 시 단독 모드로 전환 후 pq-pm 보고 |
| AskUserQuestion 결정 지연 | 대안 병기로 진행, decisions.md에 "잠정" 표기 |

---

## 테스트 시나리오

**정상 흐름:** "후니프린팅 자동견적 사이트 설계해줘"
→ Phase 0 (초기) → Phase 1 PM 계획 → Phase 2 병렬 수집 → Phase 3 병렬 설계 → Phase 4 통합 → Phase 5 보고. 산출: ~30개 파일.

**부분 재실행:** "화면 설계만 다시 해줘"
→ Phase 0 (부분 재실행 감지) → pq-designer만 호출 → pq-pm consistency-report 갱신 → 보고.

**증분 실행:** "가격 정책이 바뀌었어. 가격 부분만 업데이트"
→ Phase 0 (증분 감지) → pq-business-analyst의 pricing-rules.md 재작성 → pq-architect의 pricing-engine.md 갱신 → pq-pm consistency 갱신.

**에러 흐름:** 라이브 크롤 실패
→ pq-researcher가 문서·이전 _baseline 기반으로 진행, 누락 영역을 patterns.md에 명시, pq-pm decisions.md에 위험 등록.
