# 하네스 인벤토리 — 후니 프로젝트 전수 조사

감사일: 2026-06-18 · 읽기 전용 · 근거=디스크 파일 + 각 오케스트레이터 SKILL.md + CLAUDE.md §5~§16

## 0. 전체 규모

| 구분 | 디스크 실재 | 후니 하네스 | 프레임워크(범위 밖) |
|------|------------|------------|---------------------|
| 에이전트 | 90 | 68 | 22 (`moai/`) |
| 스킬 | 118 | 약 67 | 약 51 (`moai-*`·`oh-my-claudecode`류는 본 인벤토리에서 카운트 제외, 디스크엔 `moai*` 50 + 기타) |

> 프레임워크(범위 밖): `.claude/agents/moai/` 22개(builder-*/expert-*/manager-*/evaluator-active/plan-auditor/researcher) + `.claude/skills/moai*`·`oh-my-claudecode` 류. CLAUDE.md §16 "rarely used here" — 후니 하네스 아님. 깊이 보지 않음.

## 1. 후니 하네스 12개 매트릭스

| # | 하네스 | prefix | 에이전트(디스크) | 방법론 스킬(디스크) | 오케스트레이터 | CLAUDE.md | 상태 |
|---|--------|--------|------------------|---------------------|----------------|-----------|------|
| 1 | Print-Quote | pq- | 5 (architect·business-analyst·designer·pm·researcher) | 2 (print-quote-live-crawl + orchestrator) | print-quote-orchestrator ✓ | §5 | 정상 |
| 2 | Huni-Widget | hw- | 7 (architect·builder·design-fidelity·qa·researcher·reverse-engineer·runtime-analyst) | 6 (build·design-fidelity·live-capture·qa·spec + orchestrator) | huni-widget-orchestrator ✓ | §6 | 정상 |
| 3 | Huni-DBMap | dbm- | 20 | 25 | huni-dbmap-orchestrator ✓ | §7 | **드리프트 多**(STALE round-18 · round-24 미배선 · pq-* 유령참조) |
| 4 | Huni-Admin-Manual | ham- | 6 (db-verifier·docs-publisher·live-capturer·manual-qa·manual-writer·source-analyst) | 5 (docs-publish·live-capture·manual-authoring·source-map + orchestrator) | huni-admin-manual-orchestrator ✓ | §8 | 정상 |
| 5 | Print-KB Wiki | pkw- | 4 (recipe-writer·researcher·source-curator·wiki-qa) | 3 (recipe-authoring·wiki-evaluation + orchestrator) | print-kb-wiki-orchestrator ✓ | §9 | 정상(주의 1: wiki-evaluation orch 미언급, agent엔 있음) |
| 6 | Huni-Project-Plan | hpp- | 3 (ia-curator·plan-qa·xlsx-builder) | 1 (orchestrator만) | huni-project-plan-orchestrator ✓ | §10 | 정상(방법론 스킬 없음·경량 하네스 설계대로) |
| 7 | Huni-RP-Meta | rpm- | 7 (deepcheck·gap-analyst·metamodel-architect·reverse-engineer·validator·vessel-designer·visualizer) | 6 (deep-augment·gap-vessel·live-reverse·metamodel-design·validation·visualize + orchestrator) | huni-rpmeta-orchestrator ✓ | §11 | 정상(스킬=agent 본문 로드) |
| 8 | Huni-Basecode | hbg- | 5 (authority-curator·basecode-diagnostician·registration-designer·remediation-planner·validator) | 5 (authority-curation·basecode-diagnosis·governance-evaluation·registration-spec·remediation-planning) + orchestrator | huni-basecode-orchestrator ✓ | §12 | **드리프트**(방법론 스킬 5종 전부 고아=미로드) |
| 9 | Huni-Price-Quote | hpq- | 5 (authority-curator·engine-cartographer·option-constraint-mapper·price-chain-inspector·quote-gate-validator) | 5 (authority-curation·engine-cartography·option-constraint-mapping·price-chain-inspection·quote-gate-validation) + orchestrator | huni-price-quote-orchestrator ✓ | §13 | **드리프트**(방법론 스킬 5종 전부 고아=미로드) |
| 10 | Huni-Price-Engine-Diag | hped- | 3 (binding-validity-designer·code-schema-auditor·mechanism-researcher) | 3 (binding-validity-mapping·code-schema-audit·mechanism-research) + orchestrator | huni-price-engine-diag-orchestrator ✓ | §14 | 정상(주의 1: binding-validity-mapping 고아) |
| 11 | Huni-Quote-Verify | hqv- | 3 (codex-cross-verifier·product-decomposer·quote-verifier) | 3 (codex-cross-verify·product-decompose·quote-verification) + orchestrator | huni-quote-verify-orchestrator ✓ | §15 | 정상(주의 1: quote-verification 고아) |

가격 클러스터(8·9·10·11 + dbm-price-* 6종)는 별도 감사 담당 — 본 인벤토리는 가벼운 카운트만, 깊은 중복분석 제외.

## 2. 오케스트레이터 ↔ 에이전트 배선 요약

- 모든 12개 하네스가 오케스트레이터 스킬 1개씩 보유, 모두 CLAUDE.md에 트리거 섹션 보유 → **하네스 등록 누락 0건**.
- CLAUDE.md 실측: §5~§15 = 하네스 11섹션 + §15 hqv(총 12 하네스) + §16 MoAI. (주: 시스템 컨텍스트에 주입된 CLAUDE.md 사본은 §15까지만이라 stale이었음 — 라이브 파일엔 hqv §15 정상 존재.)
- pq·hw·ham·rpm·hbg·hpq·hped·hqv 오케스트레이터는 자기 에이전트를 이름으로 정확히 호출.
- dbm 오케스트레이터만 사라진 옛 명명(`pq-schema`·`pq-option-*`·`pq-design*`·`PQ-option`)을 본문에 잔류 — drift-board 참조.

## 3. 프레임워크(범위 밖) 한 줄 요약

`.claude/agents/moai/`(22) + `.claude/skills/moai*`·`oh-my-claudecode` 류 = MoAI-ADK 프레임워크. CLAUDE.md §16 gated·"rarely used here". 후니 하네스와 무관·감사 범위 밖.
