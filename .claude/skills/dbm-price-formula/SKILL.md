---
name: dbm-price-formula
description: >
  후니프린팅 가격 공식 엔진(t_prc_* 4단 구조)에 엑셀 가격 데이터를 매핑하는
  설계·검증 방법론 스킬. round-2 가격 매핑 전용. 스키마 적정성(fit-gap) 검증
  절차, 계산공식집초안의 공식 유형 분류(원자합산형/면적형/구간형/고정형),
  다차원 단가 매트릭스 평면화(수량×옵션축 → component_prices long-format),
  공식→구성요소→단가 전개, 상품↔공식 바인딩, 적재용 CSV 포맷, 경계면
  교차검증을 제공한다. DB 직접 적재는 하지 않는다. '가격 매핑', '가격공식',
  'round-2', 't_prc 매핑', '단가표 매핑', '계산공식 매핑', '가격엔진 fit-gap',
  '공식 구성요소', '디지털인쇄비 매핑', '가격 스키마 적정성', '가격 매핑 검증',
  '가격 매핑 다시', '가격 fit-gap만' 작업 시 반드시 사용.
license: Apache-2.0
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-04"
  tags: "huni-dbmap, price, formula-engine, t_prc, fit-gap, mapping"
  related-skills: "dbm-mapping, dbm-excel-parse, dbm-schema-extract, huni-dbmap-orchestrator"
---

# Price Formula Engine Mapping & Fit-Gap Methodology (round-2)

[HARD] Write all deliverable docs (.md: fit-gap report, mapping-spec, validation-report, proposals) in KOREAN (project documentation language per language.yaml). Keep identifiers, table/column names, code values, CSV headers, and status tokens (PASS/FAIL/GO/NO-GO/BLOCKER/ADEQUATE/GAP) in English.

This skill is shared by `dbm-mapping-designer` (designs the price mapping + emits load CSV) and `dbm-validator` (cross-checks it), and is consumed by `dbm-schema-analyst` for the DDL-extraction step. Round-2 scope is **price**, distinct from round-1 (discount, see `dbm-mapping`). Harness scope is sheet-first: produce a complete, loadable mapping + ready-to-load CSV, but DO NOT write to the live DB. Loading is a later, separately-authorized step.

Round-1 (discount) maps flat bracket rows. Round-2 (price) maps a **formula engine**: the price is *computed* from named components, each priced by a multi-dimensional lookup. The methodology below exists because that structure does not fit the round-1 bracket pattern.

## The price formula engine (DB side, 6 tables)

Roles are per DB comment. **Exact columns are NOT assumed** — round-2 step 1 extracts the DDL (round-1 left `t_prc_*` columns un-extracted; `columns.csv` has no `t_prc_` rows). Never map against a guessed column.

| Table | Role (DB comment) | Engine layer |
|-------|-------------------|--------------|
| `t_prc_price_formulas` | 가격공식 | formula header — one named formula (e.g. "디지털인쇄 원자합산형") |
| `t_prc_price_components` | 가격구성요소 | reusable component catalog (인쇄비/코팅비/용지비/후가공비…) |
| `t_prc_formula_components` | 공식별구성요소 | which components compose a formula + order/role |
| `t_prc_component_prices` | 구성요소 다차원 단가 — 시계열 | the unit-price matrices (수량 × 옵션축들), time-series |
| `t_prd_product_price_formulas` | 상품별가격공식 | product → formula binding |
| `t_prd_product_prices` | 상품단가 — 시계열 | product-level fixed/override price (for "(가격포함)" products) |

Load order follows the FK graph: `price_formulas` + `price_components` (parents) → `formula_components` + `component_prices` → `product_price_formulas`. `product_prices` is independent (product-keyed).

## The Excel side (2 workbooks)

- 상품마스터 **`계산공식집초안`** (1108행): formulas in Korean prose, **typed** at the block head (e.g. `[원자합산형: 프리미엄엽서 / 코팅엽서…]`). Each formula expands into numbered steps `(1)…(n)`, and each step names a **참조시트명** (판걸이수 / 디지털인쇄비 / 코팅 / 출력소재 / 인쇄후가공…). This is the authority for formula → components → price-source wiring.
- 가격표 **19개 단가시트** (디지털인쇄비, 코팅, 출력소재, 인쇄후가공, 커팅타공, …): each is a `t_prc_component_prices` matrix — a 2D table of 수량행 × 옵션열, usually with **banded multi-row headers** (e.g. 디지털인쇄비: row2 band 흑백/칼라/별색 × row3 단면/양면).
- 상품마스터 per-category sheets (디지털인쇄, 스티커, 책자, 실사, 아크릴, 문구(가격포함), 굿즈파우치(가격포함)…): product rows (ID, MES ITEM_CD, 상품명, 사이즈) + which options/formula a product uses. `(가격포함)` sheets carry product-level prices → `t_prd_product_prices`.

## Step 0 — Schema fit-gap (run FIRST, answers "is the schema adequate?")

The user's primary question is whether `t_prc_*` can hold this price model. Prove it before mapping:

1. **Extract the engine DDL** (dbm-schema-analyst, read-only): full columns/types/PK/FK/CHECK for all 6 tables → `00_schema/price-engine-ddl.md` + append to `columns.csv`. This closes the round-1 gap.
2. **Enumerate 공식 유형 PER SHEET** (the unit of work is the 상품마스터 sheet, and ONE sheet can hold MULTIPLE types). `계산공식집초안` block heads confirm three types:
   - **원자합산형** (atomic sum): `판매가 = Σ components`, each component priced by a 참조 단가시트 → full engine (formula + formula_components + price_components + component_prices). (엽서/전단/리플렛/책자/캘린더…)
   - **고정가형** (fixed price): price taken directly, not computed — from a `(가격포함)` sheet or a single price table → `t_prd_product_prices` (or a trivial 1-component formula). The MAJORITY of blocks. (명함/스티커/봉투/문구/굿즈·파우치/상품액세서리…)
   - **면적매트릭스형** (area matrix): `판매가 = f(area)` via a 2D matrix → a formula with an area/size dimension + `component_prices` keyed on size. (실사/현수막/아크릴)
   Build a **sheet × formula-type matrix**. A single sheet (esp. 디지털인쇄) may span 원자합산형 + 고정가형 together — that mix is what makes it complex, so map one type at a time within such a sheet.
3. **Map each type onto the engine** and record what fits vs. what does not:
   - Can a formula be expressed as Σ(components)? (원자합산형 → yes by construction)
   - Can every price matrix's dimension set be held by `component_prices`? (count axes per sheet; the engine must key on all of them)
   - Conditional steps ("*3절 별색인쇄 상품은 없음", size-dependent 판걸이수) — can `formula_components` express the condition, or is it lost?
4. **Verdict per type**: `ADEQUATE` / `ADEQUATE-WITH-PROPOSALS` (engine holds it via a documented modeling choice) / `GAP` (engine cannot represent it). The schema is read-only/effectively frozen, so a `GAP` becomes either a modeling workaround (preferred) or an escalation to the user — never a silent drop.

Write `02_mapping/schema-fitgap-price.md`: per 공식 유형, the engine wiring, fit verdict, and any gap with severity + proposed resolution. This file is the round-2 entry gate — mapping does not start on a type until its verdict is `ADEQUATE*`.

## Step 1 — Pilot mapping (per-sheet, simplest single-type FIRST)

The unit of mapping is the 상품마스터 sheet. Pilot the SIMPLEST single-formula-type sheet first to validate one engine path end-to-end before touching mixed-type sheets.

[HARD] **디지털인쇄 is NOT the pilot.** It is the most complex sheet — it mixes 원자합산형 (엽서/전단) with 고정가형 (명함/봉투/포토카드) in one sheet. Defer it until both a fixed-price path and a formula path are proven on simpler sheets.

Recommended pilot order:
1. A 고정가형 `(가격포함)` sheet (e.g. 문구 / 상품악세사리) → exercises `t_prd_product_prices` (fixed price, no engine) — simplest possible, validates the product↔price path.
2. A single-type computed sheet — 캘린더 (원자합산형) or 아크릴 (면적매트릭스형) → exercises the formula engine on ONE type.
3. Then mixed-type sheets, 디지털인쇄 last, one formula type at a time within the sheet.

For a 원자합산형 sheet the engine wiring is:
1. **Formula** → one `t_prc_price_formulas` row. Propose a stable `*_cd` (e.g. `PRF_CAL_ATOMIC`); document naming in `price-code-proposals.md`.
2. **Components** → one `t_prc_price_components` row per distinct named cost (인쇄비/별색인쇄비/코팅비/용지비/후가공비). Reusable across formulas — reuse a code if the same cost reappears later.
3. **Formula wiring** → `t_prc_formula_components` rows linking the formula to each component, preserving step order and any operator/condition the DDL supports.
4. **Component prices** → flatten each 참조 단가시트 into `t_prc_component_prices` rows (see matrix flattening below).
5. **Product binding** → `t_prd_product_price_formulas` rows binding each product (by `MES ITEM_CD` / 상품명) to the formula.
6. Emit one load CSV per touched table under `02_mapping/load/` (filename = table name).

For a 고정가형 sheet: read the included price per product → `t_prd_product_prices` rows (no formula/component rows). For a 면적매트릭스형 sheet: the matrix is the `component_prices` (keyed on size/area) and the formula multiplies area — model area as a `component_prices` dimension, not a separate table.

## Multi-dimensional matrix flattening (the core transform)

A banded 2D price sheet → long-format `component_prices` rows. This is round-2's analog of round-1 bracket parsing.

- Read the **banded header** fully: outer band (e.g. 흑백/칼라/별색-화이트/별색-클리어/별색-핑크) × inner band (단면/양면). Each leaf column = one combination of option-axis values.
- Each body cell → one output row keyed by: component + every option-axis value (도수, 단/양면, 규격 e.g. 국4절) + 수량 (the row's 수량(국4절) value) → `unit_price` = the cell.
- Preserve the **quantity axis semantics**: the row label is a print-sheet count (출력매수), not order quantity — `계산공식집초안` step (1) converts 주문수량→출력매수 via 판걸이수. Keep that conversion as a formula step, not baked into the price row.
- Merged cells / blank carry-down (상품마스터 product sheets repeat 상품명 only on the first size row) → forward-fill before flattening; never read a blank as a real value.
- One worked row (디지털인쇄비): band 칼라(CMYK)/양면, 수량 1 → cell 6000 ⇒ `(component=인쇄비, color=CMYK, side=양면, std=국4절, qty=1, unit_price=6000)`.

## Load CSV format

Write to `02_mapping/load/<table>.csv` (same convention as round-1):
- Header row = DB column names, exactly (from the extracted DDL).
- Values transformed and type-correct; dates as the DB expects; numerics in DB scale.
- Empty string = NULL (document the convention so the loader maps it to NULL, not '').
- One CSV per target table; filename = table name.

## Validation: boundary cross-comparison

The validator proves agreement across every boundary (not mere existence):

1. **Excel cells ↔ flattened CSV** — re-read original matrix cells (including every banded leaf column) and diff against `component_prices` rows. Catch dropped axes, mis-read merged headers, off-by-one quantity rows.
2. **공식집초안 ↔ formula_components** — every numbered step has a component row; every 참조시트 has a `component_prices` source. No orphan step, no orphan component.
3. **load CSV ↔ live schema** (load-bearing): type/length fit; NOT NULL; CHECK; FK existence (each component/formula/product/code value in parent, read-only); PK uniqueness within CSV.
4. **load order ↔ FK graph** — parents precede children.
5. **recompute check** (price-specific): for ≥1 sample product+quantity, sum the components per the formula and compare to any known/expected price (e.g. a `(가격포함)` sheet value or a captured RedPrinting price). A formula that doesn't reproduce a known price is a `MAJOR` finding.

### Loadability DRY-RUN (only if authorized, never commit)
Prefer local constraint checks (computed from the DDL + read-only FK lookups, zero writes). If a DRY-RUN runs, it MUST be `BEGIN; \copy …; ROLLBACK;` and lead-authorized.

## Validation output

Write `03_validation/price-validation-report.md`: per table, PASS/FAIL per boundary, findings with severity (BLOCKER/MAJOR/MINOR) + evidence (file/sheet/cell/constraint) + suggested fix, and a final GO / NO-GO loadability verdict. Keep round-1 and round-2 reports separate.

## Authority order (conflict resolution)

Live DB schema (extracted DDL) > schema sheet > mapping spec. `계산공식집초안` (formula intent) > per-category product sheet > guess. Excel original cells > flattened CSV. The authority side wins; the other side is the bug.

## Re-invocation

- Prior round-2 artifacts present + user asks for a partial change ("디지털인쇄비 단가만 다시", "별색 축 빠졌다") → re-flatten/re-map only that component or sheet; preserve confirmed outputs.
- New 공식 유형 requested (e.g. "실사 면적형 매핑") → run Step 0 fit-gap for that type first, then Step 1-style mapping for its pilot product.
- "가격 fit-gap만" → run Step 0 only; stop before mapping CSV.
