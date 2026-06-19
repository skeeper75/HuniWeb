---
name: huni-rpmeta-orchestrator
description: 후니 RP-Meta 하네스 오케스트레이터. RedPrinting 라이브 사이트(redprinting.co.kr, 479상품/26카테고리)의 주문옵션 구성을 대표 샘플로 역공학하여 "옵션 관리 메타모델"(자재/공정/옵션/템플릿/제약/기초코드/카테고리 + 추가 발굴 축)을 도출하고, 후니 실제 t_* 현황과 갭 분석한 뒤, 후니에 필요한 기초데이터 관리 "그릇"(스키마/관리축)을 설계 제안하고, 각 카테고리를 codex-image로 시각화하고 codex-cli로 분석 외 누락 정보를 심층 발굴하며, **rpm-validator의 M1~M6 게이트 판정·distinct 승격/부결 결론을 codex-cli(gpt-5.5)로 독립 교차검증(2nd opinion)하고 reconcile하는** 8인 에이전트 팀(rpm-reverse-engineer / rpm-metamodel-architect / rpm-gap-analyst / rpm-vessel-designer / rpm-deepcheck / rpm-visualizer / rpm-validator / rpm-codex-validator)을 조율한다. 산출은 카테고리별 폴더(categories/{CAT}/reverse·deepcheck·summary·viz)로 집약하고 메타모델·갭·그릇은 단계별 폴더(02~05)에 횡단 누적한다. 대표샘플→메타모델→확대 순(답습 전수수집 금지), 라이브 읽기전용, DB 미적재(그릇=설계 제안·실 적용 인간 승인). dbm-schema-analyst·dbm-ddl-proposer·dbm-domain-researcher를 필요시 재사용. '레드프린팅 옵션 분석', 'RP 메타모델', '옵션 관리 메타모델', '기초데이터 관리 체계', '자재 공정 옵션 관리 그릇', '관리 메타모델 발굴', 'RedPrinting 벤치마크 메타모델', '후니 기초데이터 그릇 설계', '현수막 옵션 구성 분석', '카테고리 시각화', 'codex 시각화', 'codex 심층보강', '누락 정보 확인', 'codex 게이트 검증', 'codex 교차검증', '판정 2nd opinion', 'distinct 독립 재판정', 'reconcile', 'RP-Meta 하네스 실행/재실행/업데이트/보완', '특정 상품군만 메타모델', '특정 카테고리만 시각화/심층보강' 등 본 도메인 요청 시 사용. 단순 질문은 직접 응답. 위젯 구현 역공학은 huni-widget, 후니 t_* 실 적재/매핑은 huni-dbmap 하네스가 담당한다.
---

# huni-rpmeta-orchestrator — RP-Meta Harness Orchestrator

Coordinate a 7-agent team that reverse-engineers RedPrinting's option-management metamodel, gaps it against
후니's actual base-data schema, designs the 후니 schema **vessels** needed to hold the same expressive power,
**visualizes** each category (codex-image), and **deep-checks** for missed information (codex-cli). Execution
mode: **agent team** with a pipeline flow + incremental generation-verification.

**Goal:** answer "what management metamodels does RedPrinting use, which does 후니 lack, what 그릇 must 후니
build, and what did we miss?" — as designed proposals + visual aids, not loaded data.

**Authority & boundaries [HARD]:**
- Representative sampling, never a 479-product census (답습 전수수집 금지).
- Live access read-only (SELECT/information_schema/page-read); never order/submit/POST; never print credentials.
- DB not modified — vessels are design proposals; real apply is human-approved.
- RedPrinting (the user's own system) is a validated reference; its *model* is absorbed, its *naming/codes* are not.
- codex (OpenAI) output is an unverified hypothesis — verified against 후니 live / 권위 엑셀 before it counts.

## Output structure (hybrid: per-category folder + cross-cutting stages)

```
_workspace/huni-rpmeta/
├── _index.md                       # cross-cutting coverage (category→products→axes→source) + progress board
├── categories/<CAT>/               # everything ABOUT one category, in one place
│   ├── reverse.md                  # reverse-engineer: atomic option extracts + `## Ambiguous fragments`
│   ├── deepcheck.md                # rpm-deepcheck: codex-cli triaged candidates (unverified)
│   ├── summary.md                  # per-category roll-up: viz embeds + deepcheck pointer + analysis links
│   └── viz/*.png                   # rpm-visualizer: option-tree / axis-map / gap-heatmap / bom
├── 02_metamodel/                   # CROSS-CUTTING (all categories accumulate): dictionary, discovered-axes, erd
├── 03_gap/                         # CROSS-CUTTING: gap-matrix, vessel-needs, data-gaps
├── 04_vessel/                      # CROSS-CUTTING: vessel-<axis>, roadmap
└── 05_validation/                  # CROSS-CUTTING: mgate-verdict, defects
```
Why hybrid: metamodel/gap/vessel are *cross-category accumulations* (the model grows as categories are added),
so they stay staged. Reverse/viz/deepcheck/summary are *per-category artifacts*, so they live in the category folder.

## Phase 0 — Context check (always first)

Inspect `_workspace/huni-rpmeta/`:
- Absent → **initial run** (full pipeline).
- Present + partial request ("현수막만 다시", "그릇만 재설계", "GS만 시각화", "ST 심층보강만") → **partial
  re-run** (only the affected agent/stage/category; carry forward valid outputs).
- Present + new scope/sample → **new run** (move existing to `_workspace/huni-rpmeta_prev/`).
Report the detected mode before proceeding. Note: BN·GS are already complete (legacy `01_reverse/` extracts
were migrated to `categories/BN|GS/reverse.md`).

## Phase 1 — Sample plan

Read `raw/widget_monitor/redprinting_catalog.json` (479/26) + huni-widget reuse inventory. Build a
per-category representative sample list (1–3 each, structural diversity), user-named categories first. Confirm
scope with the lead. This is the only place the census-vs-sample line is drawn.

## Phase 2 — Reverse-engineer (rpm-reverse-engineer)

Per category: atomic option records + base-data tags → `categories/<CAT>/reverse.md` (+ append row to `_index.md`).
**Incremental gate:** rpm-validator runs **M1** on each category extract as it lands.

## Phase 3 — Metamodel (rpm-metamodel-architect)

Abstract axes, relationships, constraint/cascade patterns; hunt discovered axes beyond the seven buckets →
`02_metamodel/` (cross-cutting, extend not overwrite). Ground meaning in dbm-domain KB (reuse `dbm-domain-researcher`).
**Gate:** rpm-validator runs **M2 + M3**.

## Phase 4 — Gap analysis (rpm-gap-analyst)

Compare metamodel vs 후니 live schema + dbmap `00_schema/` → PASS/WEAK/GAP, reconciled with dbmap defects →
`03_gap/`. Reuse `dbm-schema-analyst` for a fresh schema extract.
**Gate:** rpm-validator runs **M4**.

## Phase 4.5 — Deep-check (rpm-deepcheck)  ← codex-cli

Per category: feed reverse+metamodel+gap to codex-cli (read-only `codex exec`), mine for missed options/
materials/processes/axes/constraints/domain-facts → `categories/<CAT>/deepcheck.md` (triaged `unverified`
candidates). Route candidates back to metamodel-architect/gap-analyst/reverse-engineer for verification —
**any candidate that survives verification re-enters Phase 3/4** (so deep-check actually improves the model,
not just a parked list). codex output never adopted unverified (hallucination boundary).
**Gate:** rpm-validator confirms no unverified candidate was silently adopted.

## Phase 5 — Vessel design (rpm-vessel-designer)

Minimal convention-fit vessels for GAP/WEAK axes (search-before-mint) + roadmap → `04_vessel/`. Delegate
precise CREATE/ALTER to `dbm-ddl-proposer`.
**Gate:** rpm-validator runs **M5 + M6**.

## Phase 5.5 — Visualize (rpm-visualizer)  ← codex-image, mermaid fallback

Per category (analysis now stable): render option-tree / axis-map / gap-heatmap / bom diagrams. rpm-visualizer
first runs `rpm-visualize/scripts/codex-preflight.sh` (gpt-5.5-first model probe). On `AVAILABLE model=<m>` →
codex-image PNG (`-m <m>`, N≤5 parallel) → `categories/<CAT>/viz/*.png`; gpt-image2 for dense/high-res. On
`DEADLOCK`/`AUTH_STALE`/`UNAVAILABLE` → **mermaid `.mmd` fallback** (text = analysis exactly, zero
hallucination) so visualization **always completes** — a codex outage never blocks Phase 5.5. Embed PNG or
mermaid block in `categories/<CAT>/summary.md`. Diagrams depict the analysis exactly (no unsourced structure).

## Phase 6.5 — codex cross-validation (rpm-codex-validator)  ← codex-cli, 2nd opinion on the verdict

After rpm-validator emits a category's `mgate-verdict-<CAT>.md`, rpm-codex-validator independently re-checks
the **verdict** (distinct 승격/부결 + M1~M6 GO/NO-GO) with codex (gpt-5.5). It feeds codex the *evidence only*
(reverse + discovered-axes context + gap rows) — **never rpm-validator's verdict** (independence: a leaked
verdict makes codex echo it). codex renders its own NEW-AXIS/ABSORBED call + soundness flags; rpm-codex-validator
reconciles codex ↔ rpm-validator → `05_validation/codex-reconcile-<CAT>.md`. **Agreement** = high-confidence
confirm; **divergence** = investigation signal routed to rpm-validator (live re-measure) — the gate stays
CONDITIONAL until resolved. This is distinct from Phase 4.5 deepcheck: deepcheck mines "what we missed"
(generative); Phase 6.5 verifies "is our conclusion correct" (verification of the verdict). codex output is an
`unverified` hypothesis (hallucination boundary) — it never auto-flips our verdict; live wins on conflict.
**Gate prerequisite:** runs **after** rpm-validator's M-gate for that category (verdict must exist to reconcile).
**Runs foreground** (invokes `codex exec` via Bash; never background — background auto-denies). On codex
unavailable (preflight `DEADLOCK`/`AUTH_STALE`/`UNAVAILABLE`) → records **"codex 미가용·Claude 단독"** and the
rpm-validator verdict stands (fallback, **not** pending — never a fake codex agreement).

## Phase 6 — Consolidate

Each category's `summary.md` rolls up its reverse + viz + deepcheck + codex cross-validation + analysis links.
rpm-validator emits `05_validation/mgate-verdict.md`; rpm-codex-validator emits `05_validation/codex-reconcile-<CAT>.md`.
Orchestrator synthesizes the final report + updates `_index.md` progress board: discovered metamodels, gap
summary, vessel roadmap, surviving deep-check candidates, **codex reconcile result (agreement/divergence)**,
open decisions.

## Execution mode & data flow

- **Mode:** agent team (hybrid). `TeamCreate` the rpm-* agents; `TaskCreate` per phase with dependencies; agents
  self-coordinate via `SendMessage`. Pipeline is staged but verification is incremental. **rpm-visualizer,
  rpm-deepcheck, and rpm-codex-validator run foreground** (they invoke `codex exec` via Bash; never background —
  background auto-denies). Reused dbm-* agents spawned via Agent within the relevant phase.
- **Data passing:** file-based (per-category folder + cross-cutting stages) + task-based status + message-based
  cross-agent questions (ambiguous fragments, deep-check candidates, schema concretization).
- **Generation ≠ verification:** rpm-validator never validates its own work; no generator self-approves; codex
  candidates are verified by the owning rpm-* agent, not adopted by rpm-deepcheck itself. rpm-codex-validator is
  a *second verification lane* on rpm-validator's verdict — independent (codex never sees our verdict), and its
  codex verdict is itself an `unverified` hypothesis that never auto-flips ours (live wins).
- **codex prerequisite + model fallback:** `codex login` (ChatGPT OAuth) is needed for Phase 4.5/5.5, but a
  codex deadlock is often a *model* problem, not a token one (gpt-5-codex/gpt-5 are 400 on a ChatGPT account;
  gpt-5.5 works) — `scripts/codex-preflight.sh` probes supported models and distinguishes the two. If codex is
  truly unavailable: **Phase 5.5 still completes via mermaid** (visualization has a text fallback); **Phase 4.5
  marks `deepcheck pending`** (deep-check has no fallback — its value is the external opinion itself).

## Error handling

- An agent fails: retry once with a tightened prompt; on second failure proceed without it and record the gap
  in the final report (never silently drop a stage).
- Live unreachable: fall back to reuse assets / dbmap snapshot; mark affected outputs CONDITIONAL.
- codex unavailable (preflight `DEADLOCK`/`AUTH_STALE`/`UNAVAILABLE`): **Phase 5.5 falls back to mermaid `.mmd`** (still completes); **Phase 4.5 marks `deepcheck pending`** (no fallback); **Phase 6.5 records "codex 미가용·Claude 단독"** and the rpm-validator verdict stands as-is (fallback, **not** pending — never a fake codex agreement). `DEADLOCK` = all model candidates failed (add a newer model to the preflight); `AUTH_STALE` = ask user to re-run `codex login`. Never fabricate candidates, images, or codex verdicts.
- Conflicting evidence (RP axis vs 후니 defect; codex claim vs live finding): surface both with sources; live wins; never delete one.
- A validator NO-GO: route `_defects.md` to the owning agent, revise, re-gate that stage only.

## Reused agents (not re-created)

- `dbm-schema-analyst` — fresh 후니 live schema extract for Phase 4.
- `dbm-ddl-proposer` — precise CREATE/ALTER DDL for Phase 5 vessels.
- `dbm-domain-researcher` — print-domain meaning for Phase 3 axes.

## Test scenarios

- **Normal:** "레드프린팅 스티커 옵션 분석 + 시각화 + 누락 확인" → Phase 0 partial-add → sample (ST) → reverse(M1)
  → metamodel(M2/M3) → gap(M4) → deepcheck(codex-cli, candidates→verify) → vessel(M5/M6) → visualize(codex-image)
  → consolidated summary with viz embeds.
- **Partial re-run (viz only):** "GS만 시각화 다시" → Phase 0 detects partial → rpm-visualizer on categories/GS
  using existing analysis; no re-analysis. Validator confirms diagrams match source.
- **Partial re-run (deepcheck only):** "BN 심층보강만" → rpm-deepcheck on categories/BN; surviving candidates
  routed to metamodel/gap for verification.
- **codex cross-validation (Phase 6.5):** "FS codex 검증" → after rpm-validator's M-gate, rpm-codex-validator
  feeds FS evidence (not our verdict) to codex → codex NEW-AXIS/ABSORBED call → reconcile vs rpm-validator →
  `05_validation/codex-reconcile-FS.md`. Agreement → high-confidence confirm; divergence → route to rpm-validator
  for live re-measure (gate CONDITIONAL until resolved).
- **Error (codex off):** preflight returns non-AVAILABLE → **Phase 5.5 completes via mermaid `.mmd`** (viz not
  blocked), **Phase 4.5 marks `deepcheck pending`** (no fallback), analysis pipeline (reverse→vessel) completes
  normally. On `AUTH_STALE` ask the user to re-run `codex login` to restore PNG + deep-check.
- **Error (codex model deadlock):** preflight `DEADLOCK` (e.g. default model gpt-5-codex unsupported) → script
  finds a working model (gpt-5.5) and returns `AVAILABLE` → both phases run normally with `-m <m>`; only a true
  all-candidates-failed `DEADLOCK` triggers the mermaid/pending fallback above.
