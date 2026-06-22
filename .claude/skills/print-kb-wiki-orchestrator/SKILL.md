---
name: print-kb-wiki-orchestrator
description: >
  후니프린팅 Print-KB LLM 위키(Karpathy 모델) 하네스 오케스트레이터 — 전 하네스 산출물을 원천으로
  상품군(11시트) 단위 레시피 페이지+횡단 축 페이지를 _workspace/print-kb/wiki/에 집필(4인 pkw-* 파이프라인·W1~W8 게이트).
  페이지 뼈대=라이브 DB 스키마·stale/v03 인용 금지. 트리거: LLM 위키, karpathy 위키, 레시피 위키, 상품 레시피 페이지,
  위키 구축/집필/확장, print-kb, 위키 검증/lint, 큐레이션 다시, 위키 재실행/업데이트/보완. 위키 내용 단순 조회는 wiki/index.md 직접.
---

# Print-KB Wiki Orchestrator

목표: 미래의 LLM 세션(또는 운영자)이 **위키만 읽고 인쇄상품을 빠르게 조립**(상품 정의→DB 등록→가격→위젯 노출)할 수 있는 레시피 지식층을 만든다. 위키 위치 = `_workspace/print-kb/wiki/` (기존 Karpathy 스키마 계승 — `wiki/README.md`가 컨벤션 권위). 레시피 단위 = 상품군 11시트. 뼈대 = 라이브 DB 스키마.

**실행 모드: 하이브리드** — Phase 1 병렬 수집(서브 에이전트, 읽기 중심) → Phase 2 스키마 비준(메인+사용자) → Phase 3 family 파이프라인(서브, 집필→QA 점진) → Phase 4 횡단 lint(서브). 팀 통신이 필요한 합의 단계가 없어 서브 에이전트 조합이 오버헤드 최소(파일 기반 전달). 모든 Agent 호출 `model: "opus"`.

## Phase 0 — 컨텍스트 확인 (실행 모드 판별)

1. `wiki/_curation/`·`wiki/recipes/`·`wiki/_qa/` 존재 검사.
2. 분기:
   - 모두 없음 → **초기 실행** (Phase 1부터).
   - 산출 존재 + 부분 요청("스티커만", "검증만", "큐레이션 다시") → **부분 재실행** (해당 Phase/에이전트만, 기존 산출 보존).
   - 산출 존재 + 새 round 산출 반영 요청 → **델타 갱신** (curator 델타 → 영향 family만 writer→QA).
3. 사용자 결정 필요 항목(스키마 변경·연구 권고 채택)은 AskUserQuestion — 서브 에이전트는 절대 사용자에게 질문하지 않는다(blocker로 회수).

## Phase 1 — 큐레이션 ∥ 리서치 (병렬, 서브)

단일 메시지에 두 Agent 동시 스폰:
- `pkw-source-curator`: 전 원천 인벤토리 + tier/freshness 등급 + 11 family/6 axis 큐레이션 팩 → `wiki/_curation/`.
- `pkw-researcher`: 방법론(Karpathy·온톨로지·llms.txt·RAG 문서설계·커뮤니티) 권고 + base 검증 → `wiki/_research/`.

게이트 1: 팩 커버리지(11+6 전부 존재·GAP 정직 표기)·권고에 출처/URL 검증 여부 확인.

## Phase 2 — 스키마 비준 (메인)

researcher 권고(R-IDs) 중 스키마 변경급을 AskUserQuestion으로 사용자 비준(권장안 첫 옵션). 채택분을 `pkw-recipe-authoring` 스킬 또는 `wiki/README.md`에 반영(스킬 갱신은 하네스 유지보수로 기록). 기각분은 `_research/`에 기각 사유 기록.

## Phase 3 — Family 파이프라인 (서브, 점진 QA)

family별 순차(또는 독립 family 2~3개 병렬):
1. `pkw-recipe-writer`: 큐레이션 팩 기반 축 페이지 보강 + `recipes/<family>.md` 집필.
2. **완성 직후** `pkw-wiki-qa`: W1~W8 게이트 → GO/COND/NO-GO.
3. NO-GO/COND → writer 재호출(finding만 보정) → QA 재측정. 3회 NO-GO 시 중단하고 사용자 escalate.
4. family GO 시 진행 보드 갱신 후 다음 family.

순서 권장: 도메인 확정이 깊은 family 먼저 (digital-print → sticker → booklet → photobook → calendar(+design-calendar) → acrylic → silsa → goods-pouch → product-accessory → stationery).

## Phase 4 — 횡단 마감 (서브)

전 family GO 후: `pkw-wiki-qa` scope=전체 — 전역 링크 그래프·고아·index/log·CQ 총커버리지·축 페이지 일관성. 통과 시 `log.md` 마일스톤 기록 + 커밋(.env.local IGNORED 확인, git_commit_messages: ko).

## 데이터 전달 (파일 기반)

| 산출 | 경로 | 생산자→소비자 |
|---|---|---|
| 큐레이션 팩 | `wiki/_curation/*.md` | curator → writer·qa |
| 연구 권고/검증 | `wiki/_research/*.md` | researcher → 메인(비준)→writer |
| 위키 본문 | `wiki/{recipes,huni}/*.md` + index/log | writer → qa·최종 |
| 게이트 verdict | `wiki/_qa/*.md` | qa → 메인·writer |

스폰 프롬프트에는 정확한 입력 경로·scope·반환 포맷(에이전트 정의의 "To the orchestrator")을 명시한다. "완료"만 반환받지 않는다.

## 에러 핸들링

- 에이전트 실패: 1회 재시도 → 재실패 시 해당 family/axis를 누락 명시하고 진행(침묵 생략 금지).
- 원천 상충: 삭제 금지, 출처 병기 + 🔴 컨펌 큐로 수집해 Phase 경계에서 일괄 AskUserQuestion.
- 라이브 DB 접속 불가: W3·실측 의존 작업만 보류 표기, 나머지 진행.
- 큐레이션 팩 부재 family 집필 요청: writer가 blocker 반환 → curator 선행 스폰.

## 완료 기준

- 11 family 레시피 + 6 축 페이지 전부 W-gate GO
- index.md 전 페이지 등재·고아 0·STALE/v03 인용 0
- CQ 커버리지 목표 충족(기본 family 관련 80%+)
- W8: 임의 family 1개 dry walk-through 통과(페이지만으로 등록 절차 완결)

## 테스트 시나리오

**정상**: "digital-print 레시피 작성" → Phase 0(팩 존재 확인)→3(writer→qa GO)→보드 갱신. 산출: recipes/digital-print.md + _qa/digital-print-gate.md(GO).

**에러**: writer가 가격 사슬 출처(file:§) 확인 실패 → 블록 미작성+GAP 보고 → qa W1 통과(날조 0)·W8 해당 단계 FAIL → COND-GO → curator에 가격 소스 재큐레이션 → writer 보정 → GO.

## 후속 작업

"위키 업데이트"(새 round 반영)=델타 갱신 모드. "특정 상품군만"=부분 재실행. "위키 검증만"=Phase 4 단독. 하네스 자체 수정(에이전트/스킬/게이트 변경)은 `/harness:harness`로 회송.
