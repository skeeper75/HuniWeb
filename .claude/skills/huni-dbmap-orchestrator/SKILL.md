---
name: huni-dbmap-orchestrator
description: 후니프린팅 DB 데이터 매핑 하네스 오케스트레이터. Railway railway DB(PostgreSQL 18.4, 29테이블) 구조를 읽기전용으로 시트화하고, 상품마스터·인쇄상품 가격표 엑셀 데이터를 DB 테이블에 매핑(매핑 설계서 + 적재용 CSV)하되 DB 직접 적재는 보류한다. 4인 에이전트 팀(dbm-schema-analyst / dbm-excel-analyst / dbm-mapping-designer / dbm-validator)으로 구조분석·엑셀분석 병렬 → 매핑 설계 → 경계면 교차검증 파이프라인을 수행한다. 1차 초점: 수량구간별 할인(아크릴/굿즈·파우치/문구). 'DB 매핑', 'DB 구조 파악', '테이블 시트화', '엑셀 데이터 매핑', '구간할인 매핑', '수량구간 할인', '가격표 매핑', '상품마스터 매핑', 'Railway DB', '적재 CSV 생성', '매핑 검증', 'DB매핑 하네스 실행', '하네스 재실행', '매핑 업데이트', '특정 테이블만 매핑', '추가 매핑' 요청 시 반드시 사용. 단순 질문은 직접 응답.
---

# huni-dbmap Orchestrator

[HARD] All deliverable documents (.md sheets, specs, reports) under `_workspace/huni-dbmap/` MUST be written in KOREAN (project documentation language per language.yaml). Identifiers, table/column names, code values, CSV headers, and SQL stay in English. Instruct every spawned agent accordingly.

Coordinates a 4-agent team to (1) sheet the live Railway DB structure and (2) map후니프린팅 Excel data to DB tables — producing a mapping spec + load-ready CSV, WITHOUT writing to the live DB. Sheet-first; loading is a later, separately-authorized step.

## Goal & scope

- **Sheet the DB**: extract the `railway` DB's 29-table structure to review-grade Markdown + CSV.
- **Map the data**: design Excel→DB column mappings, transforms, and load-order; emit per-table load CSV.
- **Do NOT load** into the live DB (user decision). Validation uses local constraint checks or rollback-only dry-runs.
- **Primary focus (round 1)**: quantity-bracket discounts for 아크릴 / 굿즈·파우치 / 문구 → tables `t_dsc_discount_tables`, `t_dsc_discount_details`, `t_prd_product_discount_tables`. Other tables/sheets are later rounds.

## Team & roles

| Agent | Role | Skill |
|-------|------|-------|
| `dbm-schema-analyst` | DB structure → sheets (read-only psql) | dbm-schema-extract |
| `dbm-excel-analyst` | Excel parse + normalize | dbm-excel-parse |
| `dbm-mapping-designer` | mapping spec + load CSV | dbm-mapping |
| `dbm-validator` | boundary cross-check + loadability | dbm-mapping |

All agents spawn with `model: "opus"`.

## Execution mode: agent team (hybrid)

- **Phase 2 (analysis)**: schema-analyst and excel-analyst run in PARALLEL — independent inputs, no shared writes.
- **Phase 3 (mapping)**: single mapping-designer integrates both — barrier after Phase 2.
- **Phase 4 (validation)**: validator cross-checks, runs incrementally per table.

Use `TeamCreate` + `TaskCreate` for coordination; agents self-coordinate via `SendMessage` and share the `_workspace/huni-dbmap/` file tree. Call `TeamDelete` only after all teammates shut down.

## Phase 0: context check (re-invocation routing)

Before spawning, inspect `_workspace/huni-dbmap/`:
- Artifacts absent → **initial run**, full pipeline.
- Artifacts present + user asks for a partial change (e.g. "re-map only 문구", "fix the rate unit") → **partial re-run**: re-invoke only the affected agent(s); preserve confirmed outputs.
- Artifacts present + user provides new source/scope → **new round**: keep prior round, add the new target tables/sheets.

Always confirm the resolved mode in your status line before proceeding.

## Pipeline

**Phase 1 — Setup**: verify `.env.local` has `RAILWAY_DB_*`; verify the two xlsx exist; resolve the round's target tables. (Read-only DB connection check.)

**Phase 2 — Parallel analysis** (team, parallel):
- schema-analyst → `00_schema/` (structure sheets, columns.csv, code-values.md, category enumeration for scope resolution).
- excel-analyst → `01_excel/` (workbook-structure.md, discount-brackets.csv, extraction-notes.md).

**Phase 3 — Mapping** (mapping-designer): consume both → `02_mapping/mapping-spec.md`, `load/<table>.csv`, `dsc-code-proposals.md`. List all "design decisions needing confirmation."

**Phase 4 — Validation** (validator, incremental): cross-check Excel↔CSV↔spec↔schema → `03_validation/validation-report.md` with GO/NO-GO. On findings, route back to the designer (or schema-analyst) and re-validate.

**Phase 5 — Report & escalate**: synthesize results, surface design decisions to the user via AskUserQuestion (apply dates, rate unit, last-bracket cap, scope granularity). The lead (this orchestrator) is the only one who talks to the user.

## Data passing

- File-based via `_workspace/huni-dbmap/` (00_schema / 01_excel / 02_mapping / 03_validation / _meta).
- Task-based via TaskCreate/TaskUpdate for dependency + progress.
- Message-based via SendMessage for live coordination and findings handoff.

## Error handling

- DB connection fail: retry once, then report the blocker (do not guess ports). NEVER print the password.
- Agent fail: retry once with a tightened prompt; if still failing, proceed without that result and note the gap in the report.
- Conflicting data: never delete — keep both with provenance and flag for user decision.
- Constraint conflict in mapping: stop and document (no silent truncation).

## Security (HARD)

- DB credentials live ONLY in `.env.local` (chmod 600, gitignored). NEVER write them into `_workspace/` (git-tracked) or echo them to stdout.
- This harness performs NO destructive DB writes. Any dry-run must be rollback-only and lead-authorized.

## User-decision gate

Surface these to the user before declaring the round done (via AskUserQuestion):
- Rate unit: `dsc_rate` stored as percent (5.00) or fraction (0.05)?
- `apply_ymd` / `apply_bgn_ymd` effective date value.
- Last bracket cap: real `max_qty` or open-ended (NULL)?
- Apply-scope granularity: category-level vs explicit product list.
- New code values (`dsc_tbl_cd`, `dsc_typ_cd`) naming.

## Test scenarios

- **Normal flow**: "DB 구조 파악하고 구간할인 매핑해줘" → Phase 0 initial → 2 parallel analysts → designer → validator GO → report with decision gate.
- **Partial re-run**: "문구 구간할인 매핑만 다시" → Phase 0 partial → excel-analyst (문구 block) + mapping-designer (문구 table) + validator (문구 only); other tables untouched.
- **Error flow**: DB unreachable → Phase 1 blocker report, ask user to verify host/port; no agents spawned.

## CLAUDE.md pointer

This harness is registered in CLAUDE.md under "하네스: Huni-DBMap". On any matching request, this skill is the entry point.
