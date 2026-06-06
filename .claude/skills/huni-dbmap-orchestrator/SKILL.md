---
name: huni-dbmap-orchestrator
description: 후니프린팅 DB 데이터 매핑 하네스 오케스트레이터. Railway railway DB(PostgreSQL 18.4, **44테이블 — t_* 도메인 34 + Django 10, CPQ 컨피규레이터 옵션/템플릿/제약 레이어 라이브 구현 포함**) 구조를 읽기전용으로 시트화하고, 상품마스터·인쇄상품 가격표 엑셀 데이터를 DB 테이블에 매핑(매핑 설계서 + 적재용 CSV)하되 DB 직접 적재는 보류한다. 6인 에이전트 팀(dbm-schema-analyst / dbm-excel-analyst / dbm-mapping-designer / dbm-validator / dbm-load-builder / dbm-ddl-proposer)으로 구조분석·엑셀분석 병렬 → 매핑 설계 → 경계면 교차검증 파이프라인을 수행한다. round-1(완료): 수량구간별 할인(t_dsc_*, 아크릴/굿즈·파우치/문구) — dbm-mapping 스킬. round-2(진행): 가격 공식 엔진(t_prc_* 4단 구조) — dbm-price-formula 스킬, fit-gap 선행 후 점진 파일럿(디지털인쇄/엽서). round-4(적재 준비): 상품마스터·가격표의 검증된 매핑을 t_* 적재본(FK 위상정렬·코드행 선적재 제안·적재 매니페스트)으로 조립하고 G1~G9 완료 게이트 + 트랜잭션 롤백 DRY-RUN으로 적재 가능성을 증명 — dbm-load-readiness 스킬, t_* 화이트리스트 강제, 실제 INSERT는 인간 승인(권위 docs/goal-2026-06-06-01.md). round-5(적재 실행본): round-4 GO 적재본을 멱등 INSERT … ON CONFLICT UPSERT + 단일 트랜잭션 + FK순 적재 SQL/로더로 실행본화하고, GAP/차단을 라이브 t_* 정합 신규 엔티티 DDL 제안서로 닫으며, 롤백전용 라이브 DRY-RUN으로 멱등성·적재가능성을 R1~R6 게이트로 증명 — dbm-load-execution 스킬, DDL 직접적용·COMMIT 금지(인간 승인), 권위 docs/goal-2026-06-06-02.md. 'DB 매핑', 'DB 구조 파악', '테이블 시트화', '엑셀 데이터 매핑', '구간할인 매핑', '수량구간 할인', '가격표 매핑', '상품마스터 매핑', 'Railway DB', '적재 CSV 생성', '매핑 검증', 'DB매핑 하네스 실행', '하네스 재실행', '매핑 업데이트', '특정 테이블만 매핑', '추가 매핑', '가격 매핑', '가격공식 매핑', 'round-2', 't_prc 매핑', '단가표 매핑', '계산공식 매핑', '가격 스키마 적정성', '가격엔진 fit-gap', '가격 fit-gap만', '가격 매핑 다시', 'DB 매핑 검증', '상품 매핑 정합', '적재 검증', '9속성 검증', '엑셀 DB 대조', '매핑 감사', '정합 재검증', '기초데이터 검증', '상품마스터 검증', '사이즈/자재/공정/판형/묶음수/페이지룰/추가상품 검증', '특정 속성만 검증', '검증 다시', 'CPQ 검증', '컨피규레이터 스키마', 'CPQ 정합', '라이브 스키마 재확인', '옵션/템플릿/제약 스키마', '스키마 재문서화', '하네스 강화', '적재 준비', 'round-4', '적재본 빌드', '적재 조립', 'FK 위상정렬', '적재 순서 확정', '코드행 선적재', '적재 매니페스트', 'DRY-RUN', '적재 가능성 검증', 'G1 G9 게이트', '완료 게이트', 't_* 화이트리스트', '적재 게이트 다시', '상품마스터 적재 조립', '가격표 적재 조립', '적재 스크립트', '적재 스크립트 작성', '적재 SQL', 'SQL 쿼리 작성', '멱등 적재', 'UPSERT', 'ON CONFLICT', '트랜잭션 래핑', '적재 로더', '신규 엔티티 제안', 'DDL 제안', '스키마 부족분 제안', 'GAP 엔티티', '라이브 DRY-RUN', 'round-5', '적재 실행본', '적재 실행 게이트', 'R1 R6 게이트', '멱등성 검증', '적재 스크립트 다시', 'DDL 제안 다시' 요청 시 반드시 사용. 단순 질문은 직접 응답.
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
| round-4 | load-readiness (적재본 조립 + G1~G9 게이트 + DRY-RUN) | 상품마스터 `t_prd_*` + 가격 `t_prc_*` (whitelist) | `dbm-load-readiness` | DONE (양 트랙 GO) |
| round-5 | load-execution (멱등 SQL/로더 + 신규 엔티티 DDL 제안 + 라이브 DRY-RUN, R1~R6) | round-4 GO 적재본 `t_prd_*` + `t_prc_*` + `11_ddl_proposals` | `dbm-load-execution` | READY |

- **round-1**: quantity-bracket discounts for 아크릴 / 굿즈·파우치 / 문구. Flat bracket rows. Complete.
- **round-2**: the price is a *formula engine* (`판매가 = Σ components`, each component priced by a multi-dimensional lookup) — not a flat table. Excel authority: 상품마스터 `계산공식집초안` (formula intent, typed by 공식 유형) + 가격표 19 단가시트 (component matrices). **fit-gap FIRST** (is `t_prc_*` adequate? — round-1 did not extract the `t_prc_*` DDL), then **incremental pilot** (디지털인쇄/엽서, 원자합산형) before widening to all 공식 유형. See `dbm-price-formula`.
- **round-3 (audit)**: verify the *already-loaded* `t_prd_*` data against the Excel source, per product × 9 attributes {사이즈·자재·인쇄옵션·공정·공정택일그룹·판형사이즈·묶음수·페이지룰·추가상품}. **프레임: "DB 정규화 규칙=기준"**(엑셀=담을 내용; "엑셀=권위 단순대조"는 false MISSING으로 폐기). **L1↔L2 2계층**: L1 충실추출(전 컬럼·8 정보축·숨김/미출시/내부용 보존, 누락0 기계보증) → L2 정합검증(기대행 대비, 숨김/미출시=비활성). **기초데이터순** (마스터 정합 → 상품별 연결, FK 의존순). Classify MATCH / MISSING / EXTRA / MISMATCH. 검증이지 매핑설계·적재 아님. See `dbm-mapping-audit` + `dbm-excel-parse`(L1).
- **round-4 (load-readiness)**: take the *validated* mappings from round-2/3 and prove they are **loadable** into live `t_*` — distinct from *correct*. `dbm-load-builder` composes the FK-topo-sorted load bundle (`09_load/`: manifest + ordered load CSV + code-row pre-load proposals + blocked/GAP list, **`t_*` whitelist enforced**); `dbm-validator` runs the **G1–G9 completion gate** + rollback-only DRY-RUN and emits GO/NO-GO. Build (builder) and gate (validator) are separate agents — that separation IS gate G9. **No DB writes, no DDL; real INSERT = human approval.** Authority: `docs/goal-2026-06-06-01.md`. See `dbm-load-readiness`.
- **round-5 (load-execution)**: take the *round-4 GO bundle* and make it **executable + re-runnable** — distinct from *loadable*. `dbm-load-builder` turns the bundle into idempotent `INSERT … ON CONFLICT` SQL wrapped in one transaction + a loader (`09_load/_exec*/`); `dbm-ddl-proposer` closes round-4's GAP/BLOCKED items with **minimal `t_*`-consistent new-entity DDL proposals** (`11_ddl_proposals/`, search-before-mint); `dbm-validator` runs the **R1–R6 gate** (멱등성·트랜잭션 원자성·실행가능성·DDL 제안 정합·라이브 DRY-RUN·독립성) on top of carried-forward G1–G9, and emits GO/NO-GO. **No `COMMIT`, no DDL apply; both are human approval.** Authority: `docs/goal-2026-06-06-02.md` (inherits goal-...-01). See `dbm-load-execution`.

## Team & roles

| Agent | Role | Skill (round-1 / round-2) |
|-------|------|---------------------------|
| `dbm-schema-analyst` | DB structure → sheets (read-only psql); round-2 also extracts the missing `t_prc_*` DDL | dbm-schema-extract |
| `dbm-excel-analyst` | Excel parse + normalize (round-2: 계산공식집초안 + 단가시트 matrices) | dbm-excel-parse |
| `dbm-mapping-designer` | mapping spec + load CSV | dbm-mapping / **dbm-price-formula** |
| `dbm-validator` | boundary cross-check + loadability; round-4 G1–G9 gate | dbm-mapping / **dbm-price-formula** / **dbm-load-readiness** |
| `dbm-load-builder` | **round-4**: assemble FK-ordered load bundle + code-row pre-load + manifest (`09_load/`). **round-5**: turn the GO bundle into idempotent `ON CONFLICT` SQL + transaction wrap + loader (`09_load/_exec*/`) | **dbm-load-readiness** / **dbm-load-execution** |
| `dbm-ddl-proposer` | **round-5 only**: close round-4 GAP/BLOCKED with minimal `t_*`-consistent new-entity DDL proposals (`11_ddl_proposals/`, search-before-mint) | **dbm-load-execution** |

All agents spawn with `model: "opus"`. Round is resolved in Phase 0; the designer/validator load the round-matching skill (round-2 → `dbm-price-formula`, round-4 → `dbm-load-readiness`, round-5 → `dbm-load-execution`). `dbm-load-builder` runs in round-4 and round-5; `dbm-ddl-proposer` is spawned only in round-5.

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

## Pipeline (round-4 load-readiness — 적재본 조립 → G1~G9 게이트)

**[프레임] 앞선 라운드는 매핑이 *맞는지*(round-2 가격·round-3 audit)를 증명했다. round-4는 그 검증된 매핑이 *적재 가능한지*를 증명한다 — 순서·라이브 제약·FK 충족은 정확성과 다른 실패면이다.** 권위 = `docs/goal-2026-06-06-01.md`(완료 기준 G1~G9·t_* 화이트리스트·무적재 원칙). 생성(builder)과 게이트(validator)는 **별도 에이전트** — 이 분리가 게이트 G9다. `dbm-load-builder`와 `dbm-validator`는 `dbm-load-readiness` 스킬을 로드한다.

**Phase 0 — 입력 확인**: round-2/3 산출물에 GO 판정(`03_validation/*-final.md`)이 있는 테이블만 적재 대상. 검증 GO 없는 매핑은 round-4 진입 불가(먼저 해당 라운드 완료).

**Phase 1 — Setup**: `.env.local` RAILWAY_DB_* 읽기전용 연결 확인. 적재 대상 = 상품마스터 `t_prd_*` + 가격 `t_prc_*`(`dbm-load-readiness` `references/fk-load-order.md` 화이트리스트). round-4로 해소.

**Phase 2 — 적재본 조립** (load-builder): 검증된 매핑(`02_mapping/load*`)을 입력으로 ① t_* 화이트리스트 강제 → ② 라이브 FK 위상정렬로 적재 순서 확정 → ③ 누락 FK-타깃 코드값 = `t_cod_base_codes` 선적재 *제안*(DDL 무변경, step 00) → ④ 행 분류(즉시적재 / 차단-후니등록대기 / GAP) → `09_load/`(`load-manifest.md` + 순서접두 `load/<NN>_<table>.csv` + `code-row-preload.md` + `blocked-and-gaps.md`). 자기승인 금지 — validator에 인계.

**Phase 3 — G1~G9 게이트 + DRY-RUN** (validator, 적대적): `dbm-load-readiness` §2 + `references/g-gates.md`로 G1~G9 각각 증거기반 PASS/FAIL. G6 = 롤백전용 DRY-RUN(`references/dry-run.md`, lead 승인 시; 기본은 로컬 제약검사). 전부 PASS여야 GO. builder가 만든 번들을 validator가 검증(G9 독립성) — 조용히 고치지 말고 finding을 builder(순서/행)·designer(매핑)로 라우팅, 변경분만 재게이트. → `03_validation/load-readiness-gate.md`(GO/NO-GO + 게이트별 결과 + 즉시적재/차단/GAP 집계). **NEVER COMMIT.**

**Phase 4 — 보고 + 승인 게이트** (lead): GO 번들 + 코드행 선적재 제안 + GAP을 사용자에 에스컬레이션. 실제 INSERT 실행 승인은 본 트랙 종착점 너머(인간 승인). NO-GO면 실패 게이트·라우팅 보고 후 해당 단계 재조립·재게이트.

## Pipeline (round-5 load-execution — 멱등 실행본 + DDL 제안 → R1~R6 게이트)

**[프레임] round-4는 적재본이 *적재 가능*함을 증명했다. round-5는 그 GO 적재본이 *실행 가능·재실행 안전*하고, round-4가 GAP/차단으로 남긴 부분이 *정직하게 닫힘*을 증명한다 — 적재가능성과 실행가능성·멱등성은 다른 실패면이다.** 권위 = `docs/goal-2026-06-06-02.md`(R1~R6 + G1~G9 carry-forward, DDL 제안 격상·COMMIT 금지). 생성(builder/proposer)과 게이트(validator)는 **별도 에이전트** = R6. 세 에이전트는 `dbm-load-execution` 스킬을 로드한다.

**Phase 0 — 입력 확인**: round-4 GO 적재본(`09_load/_assembled*/`) + 게이트 판정서(`03_validation/load-readiness-gate*.md`)가 GO인지 확인. round-4 GO 없는 트랙은 round-5 진입 불가(먼저 round-4 완료).

**Phase 1 — Setup**: `.env.local` RAILWAY_DB_* 읽기전용 연결 확인. 입력 = round-4 GO 적재본(재매핑 금지) + `blocked-and-gaps.md`(GAP 목록).

**Phase 2 — 실행본 빌드 + DDL 제안** (team, **병렬** — 독립 입력):
- **load-builder** → GO 적재본을 ① 멱등 `INSERT … ON CONFLICT`(충돌키=라이브 PK/UNIQUE에서 읽기) → ② 단일 트랜잭션 래핑(`apply.sql`, `ON_ERROR_STOP`) → ③ FK순 + 코드행 선적재 step 00 → ④ 적재 로더(기본 롤백, `--commit`=인간 승인) → `09_load/_exec/`·`_exec_price/`. 재현 생성기·provenance.
- **ddl-proposer** → round-4 `blocked-and-gaps.md`의 GAP/BLOCKED를 입력으로 ① search-before-mint(기존 t_* 무손실 표현 불가 입증) → ② 최소 신규 엔티티(사다리: 코드행<컬럼<JSONB<테이블) 라이브 컨벤션 정합 설계 → ③ 영향분석(기존 행·FK·적용순서·백필·롤백) → `11_ddl_proposals/`(`.sql`+`.md`+summary). DDL 직접 적용 금지.

**Phase 3 — R1~R6 게이트 + 라이브 DRY-RUN** (validator, 적대적): `dbm-load-execution` §3 + `references/live-dry-run.md`로 **G1~G9 carry-forward 재확인 + R1~R6** 각 증거기반 PASS/FAIL. 기본은 로컬 선검사(SQL 파싱·`ON CONFLICT` 존재·충돌키 정합·트랜잭션 구조). **R1/R5 라이브 DRY-RUN(롤백전용)은 lead 승인 시 1회** — 멱등성 2회 적용 + 제약위반 0 실증. builder/proposer 산출을 validator가 검증(R6 독립성) — 조용히 고치지 말고 finding을 builder(SQL/순서)·proposer(DDL)·designer(매핑)로 라우팅, 변경분만 재게이트. → `03_validation/load-execution-gate.md` GO/NO-GO. **NEVER COMMIT.**

**Phase 4 — 보고 + 승인 게이트** (lead): GO 실행본(`_exec*/`) + DDL 제안(`11_ddl_proposals/`) + 인간 승인 큐(① 라이브 DRY-RUN 실행 ② 실제 `COMMIT` 적재 ③ 신규 DDL 적용 ④ 코드행 등록)를 사용자에 에스컬레이션. 실제 적재·DDL 적용은 본 트랙 종착점 너머(인간 승인). NO-GO면 실패 게이트·라우팅 보고 후 재빌드·재게이트.

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

round-4 (load-readiness):
- Code-row pre-load proposals: 후니가 라이브에 등록할 `t_cod_base_codes` 코드값(예: `PRC_COMPONENT_TYPE.06`) 승인.
- GAP 모델링: t_*로 무손실 표현 불가 항목(예: 박 2단 룩업) — 에스컬레이션 처리 방향.
- Real INSERT 실행 승인: GO 번들 제시 후 실제 적재를 진행할지(본 하네스 종착점 너머).

round-5 (load-execution):
- 라이브 DRY-RUN 실행 승인: 롤백전용이라도 쓰기 트랜잭션 — R1/R5 실증을 위해 라이브에서 1회 돌릴지.
- 신규 엔티티 DDL 적용 승인: `11_ddl_proposals/`의 CREATE/ALTER를 후니가 라이브에 적용할지(제안≠적용). GAP별 채택/보류.
- 실제 `COMMIT`(영구 적재) 승인: G1~G9 + R1~R6 PASS 실행본 제시 후 실제 적재를 진행할지(본 하네스 종착점 너머).
- `DO UPDATE` 대상 확정: round-4 update-set 컬럼(qty_unit·nonspec 등)을 멱등 갱신할지, 변경분만 적용할지.

## Test scenarios

- **Normal flow (round-1)**: "DB 구조 파악하고 구간할인 매핑해줘" → Phase 0 initial → 2 parallel analysts → designer → validator GO → report with decision gate.
- **Partial re-run**: "문구 구간할인 매핑만 다시" → Phase 0 partial → excel-analyst (문구 block) + mapping-designer (문구 table) + validator (문구 only); other tables untouched.
- **Round-2 flow (price)**: "가격 매핑해줘" / "round-2 진행" → round-2 pipeline → 2a DDL extraction + 2b excel analysis (parallel) → Phase 3 fit-gap GATE → pilot 디지털인쇄/엽서 mapping → validator recompute check GO → report fit-gap verdict + widen decision.
- **Fit-gap only**: "가격 스키마 적정성만 확인" / "가격 fit-gap만" → run Phases 1–3 (DDL + excel + fit-gap), stop before pilot mapping; deliver `schema-fitgap-price.md` only.
- **Round-3 flow (audit)**: "DB 매핑 검증" / "정합 재검증" → Phase 0 방법론/토대 확인 → (미설계면 1단계 방법설계 A~G) → Phase 2 L1 충실추출(15시트, 9게이트 PASS) → Phase 3 마스터 정합 → Phase 4 L2 속성별 정합(숨김/미출시=비활성) → Phase 5 대시보드 + 정정 우선순위.
- **Round-3 L1 only**: "엑셀 충실추출만" / "전 상품 토대만" → Phase 1–2 (L1 추출 + 9게이트 검증), stop before L2; deliver `06_extract/product-info-foundation.md` only.
- **Round-4 flow (load-readiness)**: "적재 준비 진행" / "round-4" / "상품마스터 적재 조립" → Phase 0 GO 입력 확인 → load-builder가 `09_load/` 번들 조립(t_* 화이트리스트·FK 위상정렬·코드행 선적재·차단/GAP 분리) → validator G1~G9 + DRY-RUN → `load-readiness-gate.md` GO/NO-GO → lead가 코드행 선적재·GAP·실제 INSERT 승인을 사용자에 에스컬레이션.
- **Round-4 gate-only**: "적재 게이트 다시" / "G1 G9 게이트 다시" → 기존 `09_load/` 번들 재조립 없이 validator만 G1~G9 재실행.
- **Round-4 partial rebuild**: "가격표 적재 조립만 다시" → load-builder가 `t_prc_*` 단계만 재조립, validator가 해당 단계만 재게이트; 나머지 적재 단계 보존.
- **Round-4 whitelist error**: 매핑이 비-`t_`(Django) 테이블을 가리킴 → load-builder가 G1(화이트리스트)에서 정지·플래그, 번들 미산출.
- **Round-5 flow (load-execution)**: "적재 스크립트 작성" / "round-5" / "적재 SQL 만들어줘" → Phase 0 round-4 GO 확인 → Phase 2 병렬(load-builder 멱등 SQL+로더 `_exec*/` · ddl-proposer GAP DDL 제안 `11_ddl_proposals/`) → Phase 3 validator G1~G9 carry-forward + R1~R6 + (lead 승인 시)라이브 DRY-RUN → `load-execution-gate.md` GO/NO-GO → lead가 라이브 DRY-RUN·COMMIT·DDL 적용·코드행 승인을 사용자에 에스컬레이션.
- **Round-5 SQL-only**: "멱등 적재 SQL만" → load-builder가 `_exec*/` SQL+로더만, validator R1~R3 로컬 검사; DDL 제안·라이브 DRY-RUN 생략.
- **Round-5 DDL-proposal-only**: "신규 엔티티 제안만" / "스키마 부족분 제안" → ddl-proposer가 `11_ddl_proposals/`만, validator R4(search-before-mint·정규화·충돌); 적재 SQL 무변경.
- **Round-5 gate-only**: "적재 실행 게이트 다시" / "R1 R6 다시" → validator가 기존 `_exec*/` + `11_ddl_proposals/`에 R1~R6 재실행, 재빌드 없음.
- **Round-5 live DRY-RUN**: "라이브 DRY-RUN 해줘" → lead 승인 후에만 validator가 `BEGIN…ROLLBACK` 2회(R1 멱등성/R5 제약위반), 위반 보고, NEVER COMMIT.
- **Round-5 idempotency error**: 어떤 INSERT에 `ON CONFLICT` 누락 → validator R1 FAIL, load-builder로 라우팅; DDL 제안이 기존 테이블 중복 → R4 FAIL(search-before-mint), ddl-proposer로 라우팅.
- **Error flow**: DB unreachable → Phase 1 blocker report, ask user to verify host/port; no agents spawned.

## CLAUDE.md pointer

This harness is registered in CLAUDE.md under "하네스: Huni-DBMap". On any matching request, this skill is the entry point.
