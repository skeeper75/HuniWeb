---
name: huni-rpmeta-orchestrator
description: 후니 RP-Meta 하네스 오케스트레이터. RedPrinting 라이브 사이트(redprinting.co.kr, 479상품/26카테고리)의 주문옵션 구성을 대표 샘플로 역공학하여 "옵션 관리 메타모델"(자재/공정/옵션/템플릿/제약/기초코드/카테고리 + 추가 발굴 축)을 도출하고, 후니 실제 t_* 현황과 갭 분석한 뒤, 후니에 필요한 기초데이터 관리 "그릇"(스키마/관리축)을 설계 제안하는 5인 에이전트 팀(rpm-reverse-engineer / rpm-metamodel-architect / rpm-gap-analyst / rpm-vessel-designer / rpm-validator)을 조율한다. 대표샘플→메타모델→확대 순(답습 전수수집 금지), 라이브 읽기전용, DB 미적재(그릇=설계 제안·실 적용 인간 승인). dbm-schema-analyst·dbm-ddl-proposer·dbm-domain-researcher를 필요시 재사용. '레드프린팅 옵션 분석', 'RP 메타모델', '옵션 관리 메타모델', '기초데이터 관리 체계', '자재 공정 옵션 관리 그릇', '관리 메타모델 발굴', 'RedPrinting 벤치마크 메타모델', '후니 기초데이터 그릇 설계', 'RP-Meta 하네스 실행', '메타모델 하네스 재실행/업데이트/보완', '특정 상품군만 메타모델', '현수막 옵션 구성 분석' 등 본 도메인 요청 시 사용. 단순 질문은 직접 응답. 위젯 구현 역공학은 huni-widget, 후니 t_* 실 적재/매핑은 huni-dbmap 하네스가 담당한다.
---

# huni-rpmeta-orchestrator — RP-Meta Harness Orchestrator

Coordinate a 5-agent team that reverse-engineers RedPrinting's option-management metamodel, gaps it against
후니's actual base-data schema, and designs the 후니 schema **vessels** needed to hold the same expressive
power. Execution mode: **agent team** with a pipeline flow + incremental generation-verification.

**Goal:** answer "what management metamodels does RedPrinting use, which does 후니 lack, and what 그릇 must
후니 build?" — as designed proposals, not loaded data.

**Authority & boundaries [HARD]:**
- Representative sampling, never a 479-product census (답습 전수수집 금지).
- Live access read-only (SELECT/information_schema/page-read); never order/submit/POST; never print credentials.
- DB not modified — vessels are design proposals; real apply is human-approved.
- RedPrinting (the user's own system) is a validated reference; its *model* is absorbed, its *naming/codes* are not.

## Phase 0 — Context check (always first)

Inspect `_workspace/huni-rpmeta/`:
- Absent → **initial run** (full pipeline).
- Present + user gives a partial request ("현수막만 다시", "그릇만 재설계") → **partial re-run** (only the
  affected agent/stage; carry forward valid outputs).
- Present + user gives new scope/sample → **new run** (move existing to `_workspace/huni-rpmeta_prev/`).
Report the detected mode before proceeding.

## Phase 1 — Sample plan

Read `raw/widget_monitor/redprinting_catalog.json` (479/26) + huni-widget reuse inventory. Build a
per-category representative sample list (1–3 each, structural diversity), user-named categories first
(현수막/BN). Confirm scope with the lead. This is the only place the census-vs-sample line is drawn.

## Phase 2 — Reverse-engineer (rpm-reverse-engineer)

Extract atomic option records with base-data tags from reuse assets + targeted live capture → `01_reverse/`.
**Incremental gate:** rpm-validator runs **M1** on each category extract as it lands.

## Phase 3 — Metamodel (rpm-metamodel-architect)

Abstract axes, relationships, constraint/cascade patterns; hunt discovered axes beyond the seven buckets →
`02_metamodel/`. Ground meaning in dbm-domain KB (reuse `dbm-domain-researcher` if domain gaps appear).
**Gate:** rpm-validator runs **M2 + M3**.

## Phase 4 — Gap analysis (rpm-gap-analyst)

Compare metamodel vs 후니 live schema + dbmap `00_schema/` → PASS/WEAK/GAP matrix, reconciled with known
dbmap defects → `03_gap/`. Reuse `dbm-schema-analyst` if a fresh schema extract is needed.
**Gate:** rpm-validator runs **M4**.

## Phase 5 — Vessel design (rpm-vessel-designer)

Design minimal convention-fit vessels for GAP/WEAK axes (search-before-mint) + remediation roadmap →
`04_vessel/`. Delegate precise CREATE/ALTER to `dbm-ddl-proposer` when needed.
**Gate:** rpm-validator runs **M5 + M6**.

## Phase 6 — Consolidate

rpm-validator emits `05_validation/mgate-verdict.md`. Orchestrator synthesizes a final report:
discovered metamodels, gap matrix summary, prioritized vessel roadmap, open decisions for the user.

## Execution mode & data flow

- **Mode:** agent team. `TeamCreate` the five rpm-* agents; `TaskCreate` per phase with dependencies; agents
  self-coordinate via `SendMessage`. The pipeline is staged but verification is incremental (don't wait for
  the end to gate). Reused dbm-* agents are spawned as needed via Agent within the relevant phase.
- **Data passing:** file-based (`_workspace/huni-rpmeta/<NN_stage>/`) for artifacts + task-based for status +
  message-based for cross-agent questions (ambiguous fragments, schema concretization requests).
- **Naming:** `_workspace/huni-rpmeta/{01_reverse,02_metamodel,03_gap,04_vessel,05_validation}/`.
- **Generation ≠ verification:** rpm-validator never validates its own work and no generator self-approves.

## Error handling

- An agent fails: retry once with a tightened prompt; on second failure proceed without it and record the
  gap in the final report (never silently drop a stage).
- Live unreachable: fall back to reuse assets / dbmap snapshot; mark affected outputs CONDITIONAL.
- Conflicting evidence (e.g. RedPrinting axis vs 후니 defect reading): surface both with sources; never delete one.
- A validator NO-GO: route `_defects.md` to the owning agent, revise, re-gate that stage only.

## Reused agents (not re-created)

- `dbm-schema-analyst` — fresh 후니 live schema extract for Phase 4.
- `dbm-ddl-proposer` — precise CREATE/ALTER DDL for Phase 5 vessels.
- `dbm-domain-researcher` — print-domain meaning for Phase 3 axes.

## Test scenarios

- **Normal:** "레드프린팅 현수막 옵션 분석해서 후니 관리 메타모델 만들자" → Phase 0 initial → sample (BN first +
  breadth) → reverse(M1) → metamodel(M2/M3) → gap(M4) → vessel(M5/M6) → consolidated report with vessel roadmap.
- **Partial re-run:** "그릇 설계만 다시" with existing `_workspace/huni-rpmeta/` → Phase 0 detects partial →
  rerun rpm-vessel-designer on changed gaps + rpm-validator M5/M6 only; carry forward 01~03.
- **Error:** live RedPrinting unreachable → reverse-engineer falls back to huni-widget assets, extracts marked
  CONDITIONAL, M1 gates CONDITIONAL, pipeline continues with the noted limitation.
