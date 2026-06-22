---
name: rpm-gap-vessel
description: >
  RedPrinting 옵션 관리 메타모델을 후니 현황(라이브 t_* + huni-dbmap 산출)과 축 단위로 대조해 갭(없는/약한 그릇)을 식별하고,
  그 갭을 담을 후니 스키마 그릇을 설계 제안하는 방법론 스킬(후니 RP-Meta 하네스). 갭 판정(PASS/WEAK/GAP·information_schema 권위·
  vessel-gap vs data-gap 구분)·그릇 설계(search-before-mint·코드행<컬럼<JSONB<테이블 사다리·정규화 무손실·영향분석)·정비 로드맵.
  설계≠적재. 트리거: 갭 분석, 후니 갭, 관리 축 대조, 갭 매트릭스, 그릇 설계, 관리 스키마 설계, 그릇 제안, 기초데이터 그릇,
  갭/그릇 설계 다시. 메타모델 추상화는 rpm-metamodel-design, 실 적재는 huni-dbmap 적재 트랙이 담당.
---

# rpm-gap-vessel — Huni Gap Assessment & Vessel Design

Two linked methods: (A) measure 후니's base-data management against RedPrinting's metamodel and find the
vessel gaps; (B) design the minimal 후니 schema vessels that close them. design ≠ apply.

## Why this method

The user asked for *그릇* — schema vessels that give 후니 the same management expressive power RedPrinting
has. So the unit of work is the management *axis*, and the deliverable is a *vessel* (schema), not loaded
data. A vessel gap (schema can't express the axis) is in scope; a data gap (table exists, empty) is huni-dbmap's.

## Part A — Gap assessment

### A1. Establish 후니 authority
후니 현황 = live `information_schema` (read-only) + `_workspace/huni-dbmap/00_schema/` (schema-overview,
cpq-schema, columns.csv) + accumulated dbmap round findings/memory. Never assume a table/column/code — verify.

### A2. Axis-to-axis verdict
For each metamodel axis (+ discovered axis):
- **PASS** — 후니 holds it with equal power. Cite the t_* table/column/code.
- **WEAK** — vessel exists but under-normalized / axis-confused / polluted. Cite the defect.
- **GAP** — no vessel for this concern. Cite what's missing (high level).
Verify *both sides*: the metamodel entry and the 후니 schema fact. "Seems missing" without a schema check is invalid.

### A3. Reconcile with dbmap (no parallel re-discovery)
Map each axis onto known 후니 defects so the matrix is consistent with huni-dbmap: material pollution
(MAT_TYPE.08~10 holding 색/형상/사이즈/구수), category orphans, CPQ option layer largely unloaded, price-chain
breaks, prc_typ mis-load. Cite the round/memory. Reuse findings; don't re-derive them.

### A4. Vessel-gap vs data-gap
"Table exists but empty" = data gap → list in `_data-gaps-noted.md`, route to huni-dbmap, out of scope here.
"Schema can't express the axis" = vessel gap → the product of this harness.

### A5. Prioritize
Order GAP/WEAK by leverage: how many products/axes it unblocks, how load-bearing (FK depended-on) it is.

## Part B — Vessel design

### B1. search-before-mint (HARD)
Before designing a vessel, prove existing 후니 structure can't hold the axis losslessly — tables, columns,
`t_cod_base_codes` enum groups, JSONB (`constraint_json`/`ref_param_json`), polymorphic `ref_dim_cd`. If it
can, write "no new vessel — use X" and re-classify the axis to PASS. A duplicate mint is the failure to avoid.

### B2. Ladder order, minimal
code row < `ADD COLUMN … NULL` < JSONB key < new table. Mint a table only for a true many-to-many / repeating
group / independent lifecycle. Reach the metamodel's power with the lightest vessel. No over-modeling.

### B3. Convention fit (HARD)
Follow live `t_*` patterns exactly: `t_<dom>_<plural>`, `<dom>_cd` PK `<PREFIX>_NNNNNN`, `t_cod_base_codes`
for enum axes, `use_yn CHAR(1) CHECK`, existing FK/audit style. RedPrinting's *model* informs the vessel;
its *naming/codes* never leak into 후니.

### B4. Normalize + impact + rollback
Lossless (holds exactly the named axis), non-redundant, no new partial/transitive dependency. State impact:
existing rows (NULL-add=none; NOT NULL/constraint=backfill, ship it), FKs (no orphans), apply order, rollback.
Note which 후니 defect it fixes and how WEAK→PASS.

### B5. Delegate precise DDL
When a GAP needs fully-specified CREATE/ALTER SQL, hand to `dbm-ddl-proposer` (owns the live-convention DDL
method) and integrate. You own *which vessel & why*; it owns *exact SQL*.

### B6. Roadmap
Order all vessels by leverage + FK/migration dependency → 후니 base-data management remediation plan.

## Outputs
- Part A: `03_gap/gap-matrix.md`, `03_gap/vessel-needs.md`, `03_gap/_data-gaps-noted.md`
- Part B: `04_vessel/vessel-<axis>.md`, `04_vessel/_vessel-roadmap.md`

## Done when
Every axis has a verified PASS/WEAK/GAP with both-sides evidence and dbmap cross-ref; every GAP/WEAK has a
search-before-mint-proven, normalized, convention-fit vessel design with impact analysis; roadmap ordered.
Nothing applied to live (propose only).
