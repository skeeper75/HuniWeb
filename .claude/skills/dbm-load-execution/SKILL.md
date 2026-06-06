---
name: dbm-load-execution
description: >
  후니프린팅 DB매핑 하네스의 적재 실행본(load-execution, round-5) 방법론. round-4에서 GO 판정된
  적재본(09_load/_assembled*/)을 라이브 t_* DB에 실제 적재할 수 있는 산출물로 완성한다 — ① 멱등
  INSERT … ON CONFLICT UPSERT + 단일 트랜잭션 래핑 + FK 위상정렬 적재 SQL/로더 스크립트, ② 라이브
  스키마에 부족한 신규 엔티티 DDL 제안서(GAP·차단 해소용 CREATE/ALTER, search-before-mint), ③ 롤백
  전용 라이브 DRY-RUN으로 적재 가능성·멱등성 실증(R1~R6 게이트). dbm-load-builder·dbm-ddl-proposer·
  dbm-validator가 공유한다. '적재 스크립트', '적재 SQL', 'SQL 쿼리 작성', '멱등 적재', 'UPSERT',
  'ON CONFLICT', '트랜잭션 래핑', '적재 로더', 'DDL 제안', '신규 엔티티 제안', '스키마 부족분',
  'GAP 엔티티', '라이브 DRY-RUN', '적재 실행본', 'round-5', '적재 실행 게이트', 'R1 R6', '멱등성 검증',
  '적재 스크립트 다시', 'DDL 제안 다시' 작업 시 반드시 이 스킬을 사용. 매핑 규칙 자체 설계는
  dbm-mapping/dbm-price-formula, 적재본 조립(CSV+매니페스트)·G1~G9는 dbm-load-readiness(round-4)가
  담당하므로 그 작업에는 트리거하지 않는다.
license: Apache-2.0
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-06"
  tags: "dbmap, load-execution, idempotent-upsert, ddl-proposal, live-dry-run, round-5, t-star"
---

# dbm-load-execution — Load Execution Track (round-5)

This skill governs the **execution track** of the huni-dbmap harness: turning the round-4 **GO load
bundle** into something you can actually run against live `t_*` — idempotent SQL + a loader, a DDL
proposal for what the schema is missing, and a rollback-only live DRY-RUN that proves it inserts cleanly
and re-runs safely. Authority documents (read in order): `docs/goal-2026-06-06-02.md` (round-5 GOAL,
this track) → `docs/goal-2026-06-06-01.md` (round-4 GOAL, inherited). When they disagree, round-5 wins;
but round-4's G1–G9 stay in force and round-5 adds R1–R6 on top.

Three roles share this skill. Read the section for your role; read the others only to understand the handoff.

- **dbm-load-builder** → §1 Build (idempotent SQL + loader).
- **dbm-ddl-proposer** → §2 Propose (new-entity DDL for GAPs).
- **dbm-validator** → §3 Gate (R1–R6 + live DRY-RUN).

Build (builder/proposer) and gate (validator) are **separate agents on purpose** — R6 requires
independent verification. The builder/proposer must not self-approve; the validator must not silently fix their work.

## Why this track exists

round-4 proved the bundle is *loadable* (right order, FK-satisfiable, no constraint violation in a local
check). round-5 proves it is *executable and re-runnable*: a real transaction that rolls back cleanly,
re-applies with zero changes the second time, and whose schema gaps are closed by an honest, minimal DDL
proposal rather than a force-flatten or a silent drop. Loadable and executable are different failure
surfaces — a bundle can be loadable yet (a) fail to re-run idempotently (PK collision on retry), (b)
half-commit on an error (no transaction wrapping), or (c) silently lose a GAP row because the schema
can't hold it. We separate them so none hides the others.

## Scope guardrails (HARD — from the round-5 GOAL)

- **Targets are `t_*` only.** Both load rows AND DDL proposals stay inside the `t_*` domain. Never touch Django/non-`t_`. (Inherits G1.)
- **No `COMMIT`.** Read-only `SELECT` + rollback-only DRY-RUN (`BEGIN … ROLLBACK`) only. Real INSERT/COMMIT is out of scope (human approval). **NEVER COMMIT.**
- **No DDL application.** New entities are *proposed* (CREATE/ALTER + rationale + apply-order), never applied. Live `CREATE`/`ALTER` is out of scope (human approval).
- **Idempotency is mandatory.** Every generated `INSERT` carries an `ON CONFLICT` guard with an explicit natural-key/PK target. No bare INSERT.
- **Transaction atomicity is mandatory.** The load is one transaction — all or nothing. No partial-commit path.
- **search-before-mint.** Before proposing any DDL or code row, prove the existing live structure cannot losslessly hold the data. (round-4's `SIZ_000506` duplicate-mint is the cautionary tale.)
- **No guessing / no dodge / no silent fallback.** Live existence is authority; show missing data, never back-fill it quietly.
- **Credentials only from `.env.local`.** Never echo `RAILWAY_DB_*` to stdout or write into `_workspace/`.

## §1 Build — idempotent load SQL + loader (dbm-load-builder)

Goal: from the round-4 GO bundle, produce executable, re-runnable load artifacts under
`09_load/_exec/` (상품마스터) and `09_load/_exec_price/` (가격). Full patterns in
`references/sql-idempotent-patterns.md`.

Steps:
1. **Take the GO bundle as the only input.** Read `09_load/_assembled*/load/<NN>_<table>.csv` +
   `load-manifest.md`. Do NOT re-map — round-4 mappings are authority (GOAL §7.2). If a CSV is missing
   or its gate is not GO, stop and report; do not rebuild the mapping.
2. **Read the live constraints for each target table.** Pull the real PK / unique constraints from the
   live schema (read-only) so you know the exact `ON CONFLICT (cols)` target. Never guess the conflict key.
3. **Generate idempotent INSERTs.** For each table, emit `INSERT INTO t_… (cols) VALUES … ON CONFLICT
   (<natural key>) DO NOTHING` (or `DO UPDATE SET …` only where an update is the intended semantics and
   the columns are explicit). One `.sql` per load step, ordered-prefixed (`<NN>_<table>.sql`).
4. **Wrap the whole load in one transaction.** Emit a top-level `apply.sql` that runs, in FK topo order:
   step 00 code-row pre-load → (optional) referenced new-entity DDL apply markers → step NN table loads,
   all inside `BEGIN; … COMMIT;`. Default the runnable to rollback (DRY-RUN); `--commit` is a human-gated flag.
5. **Emit a loader.** `apply.sh` (psql) or `load.py` (psycopg) that sources `.env.local`, connects
   read/rollback by default, and only commits behind an explicit approval flag. Never print the password.
6. **Keep it reproducible + provenance-traced.** Generate via a script over the CSVs (no hand-edited SQL).
   Record which CSV row each VALUES tuple came from. Hand the bundle to the validator — do not self-approve.

Where the round-4 bundle has a **code-row pre-load** (`code-row-preload.md`), turn it into `00_*.sql`
idempotent INSERTs placed first. Where a row depends on a **proposed new entity** (from the proposer),
reference the DDL apply step by name in `apply.sql` ordering — but the DDL itself stays a proposal.

## §2 Propose — new-entity DDL for GAPs (dbm-ddl-proposer)

Goal: for each round-4 GAP/BLOCKED item that cannot be losslessly held by existing `t_*`, produce a
**minimal, convention-consistent DDL proposal** under `11_ddl_proposals/`. Full method in
`references/ddl-proposal-method.md`. You propose; you never apply.

Steps:
1. **Take the GAP list as input.** Read round-4 `blocked-and-gaps.md` (both tracks). Candidate GAPs:
   박 2-step lookup (면적→분류→가격 중간키), goods-pouch 비치수 size (47 products), sticker 형상 enum
   axis, 책등(spine) param slot, addon template absence — and any other escalated GAP.
2. **search-before-mint (HARD).** For each GAP, first prove existing live `t_*` (tables, columns, code
   groups, JSONB slots like `constraint_json`/`ref_param_json`) cannot hold it losslessly. Document the
   search. If an existing structure works, route it back as "no DDL needed — use X" — do NOT mint.
3. **Design the minimal new entity** consistent with live `t_*` conventions (naming `t_<dom>_<plural>`,
   `<dom>_cd` PK, code-group pattern, FK style, audit columns). Prefer a new column / code-group / JSONB
   key over a new table when it suffices; prefer one new table over several. No over-modeling.
4. **Write the proposal** = `ddl-proposal-<gap>.sql` (CREATE/ALTER, idempotent `IF NOT EXISTS` where
   sensible) + `ddl-proposal-<gap>.md` (the GAP it closes, why existing structure fails, the design,
   apply order vs the load, impact on existing rows/FKs/backfill, and how round-4 blocked rows become
   loadable after apply). Normalize correctly — no redundancy, no partial-dependency.
5. **Hand to the validator** for R4 (proposal fit) and to the lead for human apply-approval. Surface every
   proposal explicitly; never assume it will be applied.

## §3 Gate — prove executability (dbm-validator)

Goal: produce `03_validation/load-execution-gate.md` with **G1–G9 carry-forward + R1–R6** explicit
PASS/FAIL and a final GO / NO-GO. Adversarial stance: assume the SQL won't run and the DDL is wrong until
each gate proves otherwise. Full criteria in `references/live-dry-run.md` (R1/R2/R5) and the gate format below.

The six round-5 gates (G1–G9 are carried forward from round-4 `load-readiness-gate*.md`, re-confirmed not re-derived):

| Gate | Proves | How |
|------|--------|-----|
| **R1** | Idempotency | Apply the load twice in a rollback transaction (or twice within one); 2nd pass changes 0 rows. `ON CONFLICT` present + correct conflict key on every INSERT. |
| **R2** | Transaction atomicity | The load is one `BEGIN…COMMIT`; an injected mid-load failure rolls the whole thing back (no half-load). No partial-commit path in the scripts. |
| **R3** | Executability (syntax/run) | Every `.sql` parses and runs in psql (0 syntax errors); the loader connects via `.env.local` and performs the load. No non-runnable hand-SQL. |
| **R4** | DDL proposal fit | Each proposal matches live `t_*` conventions, collides/duplicates 0, violates normalization 0, states apply-order + impact, and passes search-before-mint. |
| **R5** | Live DRY-RUN | `BEGIN … (load) … ROLLBACK` on live yields 0 constraint violations (type/length/NOT NULL/CHECK/FK/PK). Closes round-4's deferred G6. |
| **R6** | Independent verification | Build/propose (builder/proposer) and gate (validator) are separate agents; gate found ≥1 real defect. |

Default to **local checks** (SQL parse, `ON CONFLICT` presence, transaction-wrap structure, conflict-key
vs live PK) which need no writes. Run the **live DRY-RUN (R1/R5) only with lead authorization**
(`references/live-dry-run.md`); it is a write transaction even though it rolls back. **NEVER COMMIT.**

A single FAIL is NO-GO: cite file, line, table, column, and the exact violated rule; route to the builder
(SQL/order), proposer (DDL), or designer (mapping); re-gate only the changed parts. Retract a finding
honestly if you misread.

## Gate verdict format (`03_validation/load-execution-gate.md`)

```
## round-5 게이트 종합 — <track> | 판정: GO / NO-GO
### G1~G9 carry-forward (round-4 권위 재확인)
| Gate | round-4 판정 | round-5 재확인 | 근거 |
### R1~R6
| Gate | PASS/FAIL | 근거(파일·라인·표·쿼리) | 라우팅(FAIL 시) |
### 멱등성 증명(R1) — DRY-RUN 2회 결과
### 라이브 DRY-RUN(R5) — 제약위반 목록(0이면 명시)
### DDL 제안 정합(R4) — 제안별 search-before-mint·정규화·충돌·영향
### 차단/에스컬레이션 — 인간 승인 대기 항목
```

## Human-decision gates (stop and escalate to the lead)

- **Live DRY-RUN execution** (rollback-only but a write transaction) — lead authorizes once.
- **Real COMMIT** (permanent load) — beyond this track; present GO bundle (G1–G9 + R1–R6 PASS), ask approval.
- **New-entity DDL apply** — proposal reviewed, 후니 applies live; propose ≠ apply.
- **Code-row pre-load apply** — 후니 registers the missing code value live.

## References (load on demand)

- `references/sql-idempotent-patterns.md` — `INSERT … ON CONFLICT` UPSERT, transaction wrapping, FK-ordered `apply.sql`, the loader (psql/Python) with `.env.local`, provenance.
- `references/ddl-proposal-method.md` — GAP→entity design, live `t_*` conventions, search-before-mint, normalization, impact analysis, proposal templates.
- `references/live-dry-run.md` — rollback-only live DRY-RUN procedure, idempotency double-apply (R1), constraint-violation capture (R5), safety rules.

## Test scenarios

- **Full track**: "적재 스크립트 작성" / "round-5" → builder emits `_exec*/` idempotent SQL + loader; proposer emits `11_ddl_proposals/` for GAPs; validator runs G1–G9 carry-forward + R1–R6 + live DRY-RUN → `load-execution-gate.md` GO/NO-GO → lead escalates DRY-RUN/COMMIT/DDL-apply approvals.
- **SQL-only**: "멱등 적재 SQL만" → builder emits `_exec*/` SQL + loader, validator runs R1–R3 local checks, no DDL proposal, no live DRY-RUN.
- **DDL-proposal-only**: "신규 엔티티 제안만" / "스키마 부족분 제안" → proposer emits `11_ddl_proposals/` from the GAP list, validator runs R4, no load SQL changes.
- **Gate-only re-run**: "적재 실행 게이트 다시" / "R1 R6 다시" → validator re-runs R1–R6 on existing `_exec*/`, no rebuild.
- **Live DRY-RUN**: "라이브 DRY-RUN 해줘" → only after lead authorization; validator runs `BEGIN…ROLLBACK` twice for R1/R5, reports violations, NEVER commits.
- **Error flow**: an INSERT lacks `ON CONFLICT` → validator fails R1, routes to builder; a DDL proposal duplicates an existing table → validator fails R4 (search-before-mint), routes to proposer.
