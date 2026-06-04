---
name: dbm-mapping
description: 정규화된 엑셀 데이터를 후니프린팅 railway DB 테이블에 매핑하는 설계·검증 방법론 스킬. 엑셀컬럼↔DB컬럼 매핑 규칙, 변환 로직(수량구간 파싱·할인율 단위변환·코드값 해석·적용범위→cat_cd/prd_cd 전개), 제약 준수 설계(CHECK/NOT NULL/PK/FK), 적재 순서(FK 의존), 적재용 CSV 포맷, 경계면 교차검증·적재가능성 DRY-RUN 표준을 제공한다. DB 직접 적재는 하지 않는다. '매핑 설계', '컬럼 매핑', '변환 규칙', '적재 CSV', '구간할인 매핑', '매핑 검증', '적재 가능성 검증', 'DRY-RUN' 작업 시 반드시 사용.
---

# Excel→DB Mapping & Validation Methodology

[HARD] Write all deliverable docs (.md: mapping-spec, validation-report, proposals) in KOREAN (project documentation language). Keep identifiers, table/column names, code values, CSV headers, and status tokens (PASS/FAIL/GO/NO-GO/BLOCKER) in English.

This skill is shared by `dbm-mapping-designer` (designs the mapping + emits load CSV) and `dbm-validator` (cross-checks it). Harness scope is sheet-first: produce a complete, loadable mapping and ready-to-load CSV, but DO NOT write to the live DB. Loading is a later, separately-authorized step.

## Mapping design principles

1. **Target the verified schema.** Use `00_schema/columns.csv` + `code-values.md` as authority for type, length, nullability, CHECK, FK, PK. Never map against a guessed column.
2. **Explicit, testable transforms.** Each transform = one rule + one worked example. Examples below.
3. **Constraints are design inputs, not afterthoughts.** Design values so rows are insertable on the first try.
4. **Resolve scopes to real keys.** Apply-scope text → concrete `cat_cd`/`prd_cd` sets → link rows.
5. **Load order follows the FK graph.** Parents before children.
6. **No silent invention.** Required columns with no Excel source get a *proposed* value + rationale, flagged for user confirmation.

## The quantity-bracket discount target (3-table pattern)

The discount domain uses a header → detail → product-link pattern:

| Table | Role | Key columns |
|-------|------|-------------|
| `t_dsc_discount_tables` | discount table header | `dsc_tbl_cd` (PK), `dsc_tbl_nm`, `use_yn` |
| `t_dsc_discount_details` | per-bracket rows | PK `(dsc_tbl_cd, apply_ymd, min_qty)`; `max_qty`, `dsc_typ_cd` (FK→codes), `dsc_rate numeric(5,2)`, `dsc_amt numeric(12,2)` |
| `t_prd_product_discount_tables` | product↔table link | PK `(prd_cd, dsc_tbl_cd, apply_bgn_ymd)` |

Key constraints to honor:
- `t_dsc_discount_details` CHECK: `dsc_rate IS NULL OR dsc_amt IS NULL` — supply exactly ONE of rate/amount per row. Bracket discounts use `dsc_rate`, leave `dsc_amt` NULL.
- `use_yn IN ('Y','N')`.
- FKs: `dsc_typ_cd` → `t_cod_base_codes.cod_cd`; link table `prd_cd` → `t_prd_products`, `dsc_tbl_cd` → `t_dsc_discount_tables`.

### Worked transforms (bracket discount)
- Range `"50~99"` → `min_qty=50, max_qty=99`.
- Rate: confirm DB unit from schema. If `dsc_rate` is percent-scaled `numeric(5,2)`: fraction `0.05` → `5.00`. If fraction-scaled: `0.05` → `0.05`. Pick per the schema note; do not assume.
- `dsc_tbl_cd`: propose a stable code, e.g. `DSC_ACR_QTY` / `DSC_POUCH_QTY` / `DSC_STAT_QTY` (acrylic / pouch+eco / stationery). Document the naming convention in `dsc-code-proposals.md`.
- `dsc_tbl_nm`: from the block title ("아크릴상품 수량별 구간할인").
- `apply_ymd` / `apply_bgn_ymd`: no Excel source → propose an effective date with rationale; flag for confirmation.
- Apply scope: "파우치+에코백 전체" → expand to all `prd_cd` whose category ∈ {pouch categories, 에코백 CAT_000011}; "문구" → category CAT_000008; "아크릴" → CAT_000009 (and acrylic sub-categories if in scope — confirm granularity).

## Load CSV format

Write to `_workspace/huni-dbmap/02_mapping/load/<table>.csv`:
- Header row = DB column names, exactly.
- Values already transformed and type-correct (dates as the DB expects, numerics in the DB scale).
- Empty string for NULL (document this convention so the loader maps it to NULL, not '').
- One CSV per target table; filename = table name.

## Validation: boundary cross-comparison

The validator proves agreement across every boundary (it does not just check existence):

1. **Excel cells ↔ discount-brackets.csv** — re-read the original ranges, diff values. Catch dropped/mis-parsed rows.
2. **normalized CSV ↔ mapping-spec** — every row has target + transform.
3. **load CSV ↔ live schema** (the load-bearing check):
   - type/length fit; NOT NULL satisfied; CHECK satisfied (`dsc_rate XOR dsc_amt`, `use_yn` domain); FK existence (lookup each `cat_cd`/`prd_cd`/`*_typ_cd` in parent, read-only); PK uniqueness within the CSV.
4. **load order ↔ FK graph** — parents precede children.

### Loadability DRY-RUN (only if authorized, never commit)
A transaction that loads and rolls back proves insertability without persisting:
```
BEGIN; \copy <table> FROM '...' CSV HEADER; -- (row counts / constraint errors surface here)
ROLLBACK;  -- nothing committed
```
Prefer local constraint checks (computed from columns.csv + read-only FK lookups) which need zero writes. If a DRY-RUN is run, it MUST end in ROLLBACK and MUST be lead-authorized.

## Validation output

Write to `_workspace/huni-dbmap/03_validation/validation-report.md`: per table, PASS/FAIL per boundary, findings with severity (BLOCKER/MAJOR/MINOR) + evidence (file/row/column/constraint) + suggested fix, and a final GO / NO-GO loadability verdict.

## Authority order (for conflict resolution)

Live DB schema > schema sheet > mapping spec. Excel original cells > normalized CSV. The authority side wins; the other side is the bug.
