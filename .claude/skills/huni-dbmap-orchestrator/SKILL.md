---
name: huni-dbmap-orchestrator
description: 후니프린팅 DB 데이터 매핑 하네스 오케스트레이터. Railway railway DB(PostgreSQL 18.4, 29테이블) 구조를 읽기전용으로 시트화하고, 상품마스터·인쇄상품 가격표 엑셀 데이터를 DB 테이블에 매핑(매핑 설계서 + 적재용 CSV)하되 DB 직접 적재는 보류한다. 4인 에이전트 팀(dbm-schema-analyst / dbm-excel-analyst / dbm-mapping-designer / dbm-validator)으로 구조분석·엑셀분석 병렬 → 매핑 설계 → 경계면 교차검증 파이프라인을 수행한다. round-1(완료): 수량구간별 할인(t_dsc_*, 아크릴/굿즈·파우치/문구) — dbm-mapping 스킬. round-2(진행): 가격 공식 엔진(t_prc_* 4단 구조) — dbm-price-formula 스킬, fit-gap 선행 후 점진 파일럿(디지털인쇄/엽서). 'DB 매핑', 'DB 구조 파악', '테이블 시트화', '엑셀 데이터 매핑', '구간할인 매핑', '수량구간 할인', '가격표 매핑', '상품마스터 매핑', 'Railway DB', '적재 CSV 생성', '매핑 검증', 'DB매핑 하네스 실행', '하네스 재실행', '매핑 업데이트', '특정 테이블만 매핑', '추가 매핑', '가격 매핑', '가격공식 매핑', 'round-2', 't_prc 매핑', '단가표 매핑', '계산공식 매핑', '가격 스키마 적정성', '가격엔진 fit-gap', '가격 fit-gap만', '가격 매핑 다시', 'DB 매핑 검증', '상품 매핑 정합', '적재 검증', '9속성 검증', '엑셀 DB 대조', '매핑 감사', '정합 재검증', '기초데이터 검증', '상품마스터 검증', '사이즈/자재/공정/판형/묶음수/페이지룰/추가상품 검증', '특정 속성만 검증', '검증 다시' 요청 시 반드시 사용. 단순 질문은 직접 응답.
---

# huni-dbmap Orchestrator

[HARD] All deliverable documents (.md sheets, specs, reports) under `_workspace/huni-dbmap/` MUST be written in KOREAN (project documentation language per language.yaml). Identifiers, table/column names, code values, CSV headers, and SQL stay in English. Instruct every spawned agent accordingly.

Coordinates a 4-agent team to (1) sheet the live Railway DB structure and (2) map후니프린팅 Excel data to DB tables — producing a mapping spec + load-ready CSV, WITHOUT writing to the live DB. Sheet-first; loading is a later, separately-authorized step.

## Goal & scope

- **Sheet the DB**: extract the `railway` DB's 29-table structure to review-grade Markdown + CSV.
- **Map the data**: design Excel→DB column mappings, transforms, and load-order; emit per-table load CSV.
- **Do NOT load** into the live DB (user decision). Validation uses local constraint checks or rollback-only dry-runs.

## Rounds

| Round | Domain | Tables | Skill | Status |
|-------|--------|--------|-------|--------|
| round-1 | quantity-bracket discount | `t_dsc_*`, `t_prd_product_discount_tables` | `dbm-mapping` | DONE (validated GO) |
| round-2 | price formula engine | `t_prc_*` (6 tables), `t_prd_product_price_formulas`, `t_prd_product_prices` | `dbm-price-formula` | IN PROGRESS |
| round-3 | mapping audit (DB↔Excel 정합 검증) | `t_prd_*` 9속성 테이블 + 마스터(`t_siz_/t_mat_/t_proc_/t_cod_`) | `dbm-mapping-audit` | ACTIVE |

- **round-1**: quantity-bracket discounts for 아크릴 / 굿즈·파우치 / 문구. Flat bracket rows. Complete.
- **round-2**: the price is a *formula engine* (`판매가 = Σ components`, each component priced by a multi-dimensional lookup) — not a flat table. Excel authority: 상품마스터 `계산공식집초안` (formula intent, typed by 공식 유형) + 가격표 19 단가시트 (component matrices). **fit-gap FIRST** (is `t_prc_*` adequate? — round-1 did not extract the `t_prc_*` DDL), then **incremental pilot** (디지털인쇄/엽서, 원자합산형) before widening to all 공식 유형. See `dbm-price-formula`.
- **round-3 (audit)**: verify the *already-loaded* `t_prd_*` data against the Excel source, per product × 9 attributes {사이즈·자재·인쇄옵션·공정·공정택일그룹·판형사이즈·묶음수·페이지룰·추가상품}. **프레임: "DB 정규화 규칙=기준"**(엑셀=담을 내용; "엑셀=권위 단순대조"는 false MISSING으로 폐기). **L1↔L2 2계층**: L1 충실추출(전 컬럼·8 정보축·숨김/미출시/내부용 보존, 누락0 기계보증) → L2 정합검증(기대행 대비, 숨김/미출시=비활성). **기초데이터순** (마스터 정합 → 상품별 연결, FK 의존순). Classify MATCH / MISSING / EXTRA / MISMATCH. 검증이지 매핑설계·적재 아님. See `dbm-mapping-audit` + `dbm-excel-parse`(L1).

## Team & roles

| Agent | Role | Skill (round-1 / round-2) |
|-------|------|---------------------------|
| `dbm-schema-analyst` | DB structure → sheets (read-only psql); round-2 also extracts the missing `t_prc_*` DDL | dbm-schema-extract |
| `dbm-excel-analyst` | Excel parse + normalize (round-2: 계산공식집초안 + 단가시트 matrices) | dbm-excel-parse |
| `dbm-mapping-designer` | mapping spec + load CSV | dbm-mapping / **dbm-price-formula** |
| `dbm-validator` | boundary cross-check + loadability | dbm-mapping / **dbm-price-formula** |

All agents spawn with `model: "opus"`. Round is resolved in Phase 0; the designer/validator load the round-matching skill (round-2 → `dbm-price-formula`).

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

## Pipeline (round-2 price)

Round-2 reuses the same team but inserts a **fit-gap gate before mapping** (the price model is a formula engine, not flat rows). Designer + validator load `dbm-price-formula` instead of `dbm-mapping`.

**Phase 1 — Setup**: same `.env.local` / xlsx checks; round resolved to round-2 (price).

**Phase 2a — DDL extraction** (schema-analyst, FIRST): extract the full `t_prc_*` (6 tables) + `t_prd_product_price_formulas` / `t_prd_product_prices` DDL → `00_schema/price-engine-ddl.md`, append to `columns.csv`. round-1 left these un-extracted; nothing downstream may proceed on guessed columns.

**Phase 2b — Excel analysis** (excel-analyst, parallel with 2a): parse 상품마스터 `계산공식집초안` (enumerate 공식 유형 + steps + 참조시트) and the 19 가격표 단가시트 (matrix shapes, banded headers) → `01_excel/price-formulas-normalized.md`, `01_excel/price-sheets-structure.md`.

**Phase 3 — Fit-gap GATE** (mapping-designer + validator): per 공식 유형, wire onto the engine and verdict ADEQUATE / ADEQUATE-WITH-PROPOSALS / GAP → `02_mapping/schema-fitgap-price.md`. **Mapping of a type does NOT start until its verdict is ADEQUATE\***. This phase answers the user's "is the schema adequate?" question and is the round-2 entry gate.

**Phase 4 — Pilot mapping** (mapping-designer): the unit of mapping is the 상품마스터 sheet. Pilot the SIMPLEST single-formula-type sheet first — **NOT 디지털인쇄** (it mixes 원자합산형 + 고정가형 in one sheet = most complex). Recommended order: a 고정가형 `(가격포함)` sheet (문구/상품악세사리 → `t_prd_product_prices`) → a single-type computed sheet (캘린더 원자합산형 / 아크릴 면적매트릭스형 → engine) → mixed-type sheets last (디지털인쇄, one type at a time). End-to-end for the chosen sheet → `02_mapping/price-mapping-spec.md`, `load/<table>.csv`, `price-code-proposals.md`. List design decisions needing confirmation.

**Phase 5 — Validation** (validator, incremental): boundary cross-check including the price-specific **recompute check** (sum components per formula for a sample product+qty, compare to a known price) → `03_validation/price-validation-report.md` with GO/NO-GO. Route findings back to the designer.

**Phase 6 — Report & widen decision**: surface the fit-gap verdict + pilot result + price user-decisions; on GO, ask whether to widen to the next 공식 유형 / category.

## Pipeline (round-3 mapping audit — L1 토대 → L2 정합)

**[프레임 교정] "엑셀=권위 단순 집합대조" 폐기 → "DB 정규화 규칙=기준" + L1↔L2 2계층.** 검증 결함의 뿌리는 매핑(L2)이 아니라 엑셀 추출(L1)이다(false MISSING — 포맥스 A1: 속성별 단일컬럼 평면화로 작업사이즈 공백·행숨김 신호 소실). 방법론 = `05_method/`(A 베스트프랙티스·B 정규화규칙사전·C 전수대조설계·D 독립검증·E 무손실추출·F 시트구조·G 추출기준서), L1 토대 = `06_extract/`. Designer/validator load `dbm-mapping-audit`, excel-analyst loads `dbm-excel-parse` L1 섹션.

**Phase 0 — 방법론/토대 확인**: `05_method/`(A~G) + `06_extract/`(L1 토대) 존재 점검. 방법 미설계면 **1단계 방법설계**(A 리서치 + B 규칙사전[기초데이터 마스터 전체가 기준, 표본 오버피팅 금지] + C 전수설계) 선행 → D 독립검증 → 하네스 교정.

**Phase 1 — Setup**: `.env.local` RAILWAY_DB_* + 두 xlsx. **토대 범위 = 상품마스터 13시트 + 가격표 `판걸이수`(사이즈 마진/작업/블리드/전지 권위) + `출력소재(IMPORT)`(`*별도설정` 자재 권위)**. 가격표 나머지 16시트(단가)=round-2 영역. **엔티티 2축: 상품정보 먼저 정립 / 가격정보(단가·연당가·가격)는 axis=price 분리 라벨링해 round-2 이연**(무손실 보존).

**Phase 2 — L1 충실추출 (토대 정립, excel-analyst)**: `extract_l1.py --sheet`로 15시트 L1 추출(8 정보축, dbm-excel-parse L1 섹션). 의미코드맵(행숨김=비활성·그레이배경=품절/준비중·그레이글자/숨김열=내부용·노랑=신규·★=제약) 라벨. `verify_l1.py` 9게이트(non-empty 100%·round-trip 0, 미통과=L2 차단). `*별도설정`↔IMPORT ● 매핑. → `06_extract/`(`<slug>-l1.csv`+meta·`product-info-foundation.md` 정합검증 대상·`price-info-deferred.md` 이연·`seoljeong-import-map.md`).

**Phase 3 — DB 적재값 추출 + 마스터 정합** (schema-analyst read-only → validator FIRST): 9속성 테이블(`t_prd_product_sizes/materials/print_options/processes/process_excl_groups/plate_sizes/bundle_qtys/page_rules/addons`)+마스터 → `00_schema/ref-<table>.csv`(stale면 라이브 재추출). 마스터(사이즈/자재/공정/코드)↔엑셀 코드체계 정합 → `04_audit/00_master-parity.md`. Gate: 상품 연결 검증은 마스터 정합 후.

**Phase 4 — L2 속성별 정합** (validator, incremental): `product-info-foundation.md`를 입력으로, 속성별 DB↔**기대행(B규칙 정규화 변환)** 대조 → MATCH/MISSING/EXTRA/MISMATCH. **[HARD] 숨김/미출시=비활성 분류(MISSING 아님)**. 기초데이터순 staged(사용자 선택). EXTRA 삭제 단정 금지(플래그+출처). → `04_audit/<attr>-parity.md`+`<attr>-mismatches.csv`.

**Phase 5 — 종합 + 보고** (validator → lead): `04_audit/audit-summary.md` 대시보드(속성별 4분류) + 이슈. Lead가 사용자에 정정 우선순위. → BLOCK 해소 → 가격정보(round-2) → 전수.

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

round-1 (discount):
- Rate unit: `dsc_rate` stored as percent (5.00) or fraction (0.05)?
- `apply_ymd` / `apply_bgn_ymd` effective date value.
- Last bracket cap: real `max_qty` or open-ended (NULL)?
- Apply-scope granularity: category-level vs explicit product list.
- New code values (`dsc_tbl_cd`, `dsc_typ_cd`) naming.

round-2 (price):
- Fit-gap resolution for any `GAP`/`ADEQUATE-WITH-PROPOSALS` 공식 유형 (modeling workaround vs escalate).
- New code naming (`*_cd` for formulas / components, e.g. `PRF_DGP_ATOMIC`).
- Quantity-axis semantics: store 출력매수 vs 주문수량 in `component_prices`; where the 판걸이수 conversion lives (formula step vs baked-in).
- Effective-date value for time-series `component_prices` / `product_prices`.
- Widen-or-stop after the pilot: which 공식 유형 / category next.

## Test scenarios

- **Normal flow (round-1)**: "DB 구조 파악하고 구간할인 매핑해줘" → Phase 0 initial → 2 parallel analysts → designer → validator GO → report with decision gate.
- **Partial re-run**: "문구 구간할인 매핑만 다시" → Phase 0 partial → excel-analyst (문구 block) + mapping-designer (문구 table) + validator (문구 only); other tables untouched.
- **Round-2 flow (price)**: "가격 매핑해줘" / "round-2 진행" → round-2 pipeline → 2a DDL extraction + 2b excel analysis (parallel) → Phase 3 fit-gap GATE → pilot 디지털인쇄/엽서 mapping → validator recompute check GO → report fit-gap verdict + widen decision.
- **Fit-gap only**: "가격 스키마 적정성만 확인" / "가격 fit-gap만" → run Phases 1–3 (DDL + excel + fit-gap), stop before pilot mapping; deliver `schema-fitgap-price.md` only.
- **Round-3 flow (audit)**: "DB 매핑 검증" / "정합 재검증" → Phase 0 방법론/토대 확인 → (미설계면 1단계 방법설계 A~G) → Phase 2 L1 충실추출(15시트, 9게이트 PASS) → Phase 3 마스터 정합 → Phase 4 L2 속성별 정합(숨김/미출시=비활성) → Phase 5 대시보드 + 정정 우선순위.
- **Round-3 L1 only**: "엑셀 충실추출만" / "전 상품 토대만" → Phase 1–2 (L1 추출 + 9게이트 검증), stop before L2; deliver `06_extract/product-info-foundation.md` only.
- **Error flow**: DB unreachable → Phase 1 blocker report, ask user to verify host/port; no agents spawned.

## CLAUDE.md pointer

This harness is registered in CLAUDE.md under "하네스: Huni-DBMap". On any matching request, this skill is the entry point.
