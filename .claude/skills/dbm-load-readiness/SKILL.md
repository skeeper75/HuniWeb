---
name: dbm-load-readiness
description: >
  후니프린팅 DB매핑 하네스의 적재 준비(load-readiness·round-4) 트랙 방법론 — 검증된 매핑을 라이브 t_*
  적재본으로 조립(FK 위상정렬·코드행 선적재·적재 매니페스트)하고 실제 INSERT 없이 적재 가능성을 G1~G9
  게이트+롤백 DRY-RUN으로 증명. 트리거: 적재 준비, 적재본 빌드, FK 위상정렬, 코드행 선적재, 적재 매니페스트,
  DRY-RUN, G1 G9 게이트, round-4, 적재 게이트 다시. 매핑 설계는 dbm-mapping/dbm-price-formula, 정합 audit은
  dbm-mapping-audit 담당.
license: Apache-2.0
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-06"
  tags: "dbmap, load-readiness, fk-order, dry-run, gate, t-star"
---

# dbm-load-readiness — Load Readiness Track (round-4)

This skill governs the **final track** of the huni-dbmap harness: turning validated mappings into a
load-ready bundle and **proving it is insertable without inserting**. Authority document:
`docs/goal-2026-06-06-01.md` (the goal). When the goal and this skill disagree, the goal wins.

Two roles share this skill. Read the section for your role; read the other only to understand the handoff.

- **dbm-load-builder** → §1 Build (compose the bundle).
- **dbm-validator** → §2 Gate (prove G1–G9 + DRY-RUN).

The generation (build) and verification (gate) passes are **separate agents on purpose** — G9 requires
independent verification. The builder must not self-approve; the validator must not silently fix the builder's work.

## Why this track exists

The earlier rounds proved the mappings are *correct* (round-2 price, round-3 audit). This track proves
they are *loadable*: in the right order, against live constraints, with every FK satisfiable. Correctness
and loadability are different failure surfaces — a mapping can be value-correct yet fail to load because a
parent row or a code value isn't there yet, or because the load order violates an FK. We separate them so
neither hides the other.

## Scope guardrails (HARD — from the goal)

- **Targets are `t_*` only.** Never emit a load row for a Django/non-`t_` table. (Gate G1.)
- **No destructive DB writes.** Read-only `SELECT` + rollback-only DRY-RUN (`BEGIN … ROLLBACK`) only.
  Never `COMMIT`. Real `INSERT` is out of scope (human approval).
- **No DDL.** Schema gaps are bridged by *proposing* code-row INSERTs, never by altering the schema.
- **No guessing / no dodge / no silent fallback.** Live existence is authority; search live before
  treating any code as a placeholder; show missing data, never back-fill it quietly.
- **Credentials only from `.env.local`.** Never echo `RAILWAY_DB_*` to stdout or write into `_workspace/`.

## §1 Build — compose the load bundle (dbm-load-builder)

Goal: produce `09_load/load-manifest.md` + ordered `load/<NN>_<table>.csv` + `code-row-preload.md` +
`blocked-and-gaps.md`. The bundle must be executable as "run these files in this order."

Steps:
1. **Gather validated inputs.** Only build from tables with a GO verdict in `03_validation/*-final.md`.
   Pull mapped rows from `02_mapping/load*/`, provenance from `06_extract/*-l1.csv`.
2. **Enforce the `t_*` whitelist.** Confirm every target table is in the whitelist (see
   `references/fk-load-order.md`). Anything outside → stop, flag, route back.
3. **Build the FK load order.** Topologically sort target tables by live FK edges (parents first).
   Method + the live FK query are in `references/fk-load-order.md`. Emit each step with the FK edge
   that fixes its position.
4. **Propose code-row pre-loads.** For any missing FK-target code value, propose a `t_cod_base_codes`
   INSERT (naming + rationale), placed at step 00. No DDL. See `references/fk-load-order.md` §code-preload.
5. **Partition rows.** insertable / blocked-pending-registration / GAP. Only insertable rows go into
   `load/<NN>_<table>.csv`; the rest go to `blocked-and-gaps.md` with unblock conditions.
6. **Write the manifest.** Use the manifest template in `references/fk-load-order.md` §manifest.
   Hand the bundle to the validator — do not self-approve.

Keep composition reproducible (prefer a script over hand-edits) and record per-row provenance so the
validator can trace every output row back to its source.

## §2 Gate — prove loadability (dbm-validator)

Goal: produce `03_validation/load-readiness-gate.md` with an explicit PASS/FAIL per gate G1–G9 and a
final GO / NO-GO. Adversarial stance: assume the bundle is defective until each gate proves otherwise.

The nine gates (full criteria + evidence format in `references/g-gates.md`):

| Gate | Proves |
|------|--------|
| G1 | Every target table is in the `t_*` whitelist; non-`t_` load rows = 0. |
| G2 | Lossless extraction: Excel→L1 round-trip 100%; no dropped block, no invention, no dodge. |
| G3 | Mapping integrity: 1:1 Excel↔`t_*` column traceability; natural-key dup 0; no under-load; no silent fallback. |
| G4 | Schema fit: every value satisfies type/length/NOT NULL/CHECK; `comp_cd` length overflow 0. |
| G5 | FK integrity + order: every FK target exists live or is in code pre-load; manifest order is a valid topo-sort. |
| G6 | DRY-RUN passes: `BEGIN … ROLLBACK` load attempt yields 0 constraint violations; violations reported if any. |
| G7 | Blocked/escalation explicit: blocked + GAP rows listed with reason + unblock condition; nothing silently dropped. |
| G8 | Reproducibility: extract→transform→build runs from scripts; no hand-only artifact. |
| G9 | Independent verification: build (builder) and gate (validator) are separate agents; gate found ≥1 real defect historically. |

The DRY-RUN procedure (rollback-only transaction, the `\copy` pattern, assertion queries) is in
`references/dry-run.md`. Run it only with lead authorization; default to local constraint checks
(against `columns.csv` + live FK lookups) which need no writes at all. **NEVER COMMIT.**

A single FAIL means the bundle is not ready: route findings to the builder (load order / rows) or the
designer (mapping) and re-gate only the changed steps. Cite file, row, column, and the exact violated
constraint for every finding. Retract a finding honestly if you misread.

## Human-decision gates (stop and escalate to the lead)

- Real `INSERT` execution (beyond this track — present the GO bundle, ask approval).
- Code-row pre-load proposals (후니 must register the code live).
- GAP items that cannot be losslessly expressed in `t_*` (e.g. 박 2-step lookup) — escalate, do not force-flatten.

## References (load on demand)

- `references/g-gates.md` — G1–G9 full criteria, evidence templates, the gate verdict format.
- `references/fk-load-order.md` — `t_*` whitelist, FK topo-sort method + live query, code-row pre-load, manifest template.
- `references/dry-run.md` — rollback-only DRY-RUN psql procedure, assertion patterns, safety rules.

## Test scenarios

- **Full track**: "적재 준비 진행" / "round-4" → builder composes `09_load/` bundle → validator runs G1–G9 +
  DRY-RUN → `load-readiness-gate.md` GO/NO-GO → lead escalates code-preload + GAP to user.
- **Gate-only re-run**: "적재 게이트 다시" → validator re-runs G1–G9 on the existing bundle, no rebuild.
- **Partial rebuild**: "가격표 적재 조립만 다시" → builder rebuilds only price `t_prc_*` steps; validator re-gates those.
- **Error flow**: a mapping targets a non-`t_` table → builder stops at G1 (whitelist), flags it, no bundle emitted.
