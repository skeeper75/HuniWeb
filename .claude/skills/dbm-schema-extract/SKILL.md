---
name: dbm-schema-extract
description: Railway PostgreSQL 후니프린팅 railway DB의 구조를 읽기전용으로 추출해 검토용 시트(Markdown + CSV)로 만드는 방법론 스킬. psql 안전 읽기전용 쿼리 툴킷, 29테이블 접두사 도메인 분류, 컬럼/타입/제약/FK/CHECK/인덱스/코드값 추출 패턴, 구조 시트 포맷 표준을 제공한다. 'DB 구조 추출', '스키마 시트 작성', 'DDL 추출', '제약/FK 정리', '코드값 조회', 'information_schema 조회' 작업 시 반드시 사용.
---

# DB Schema Extraction Methodology

[HARD] Write all deliverable docs/sheets (.md) in KOREAN (project documentation language). Keep identifiers, table/column names, code values, CSV headers, and SQL in English.

This skill equips an agent to extract the live structure of the `railway` PostgreSQL database and render it as review-grade sheets. The DB is the authority — sheets must reflect what the DB *actually* declares, including constraints that silently block loads later.

## Why this matters

A mapping is only as correct as the schema it targets. A missed CHECK constraint, an unnoticed FK cascade, or an enum value that doesn't exist in `t_cod_base_codes` becomes a load failure or data-integrity bug downstream. Extracting constraints *as first-class facts* (not just column names) is the point of this skill.

## Safety: read-only always

This harness is sheet-first; the schema agent NEVER mutates the DB. Run only `SELECT`, `\d`, `information_schema.*`, and `pg_catalog.*` queries. Never INSERT/UPDATE/DELETE/DDL. Never print or persist the password.

### Connection pattern

```bash
set -a; source .env.local; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
q() { psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "$1"; }
```

Define `q` as a shell function (not a variable) — zsh treats a variable holding the full command as a single command name and fails.

## Domain grouping (29 tables by prefix)

Group tables in the overview by prefix so reviewers see the domain map at a glance:

| Prefix | Domain | Notes |
|--------|--------|-------|
| `t_cat_` | Categories | master reference |
| `t_cod_` | Base codes | enum/code dictionary — FK target for `*_typ_cd`, `grade_cd` |
| `t_clr_` | Color counts | master |
| `t_mat_` | Materials | master |
| `t_siz_` | Sizes | master |
| `t_proc_` | Processes | master |
| `t_prd_` | Products + relations | products and their materials/sizes/options/processes/sets/bundles/discount links |
| `t_prc_` | Pricing | formulas/components/prices (currently empty) |
| `t_dsc_` | Discounts | discount tables/details/grade rates (currently empty) |
| `t_cus_` | Customers | (currently empty) |

## Extraction queries

### Table inventory + row counts
```bash
q "SELECT relname, n_live_tup FROM pg_stat_user_tables ORDER BY relname;"
```

### Columns (flat, for columns.csv)
```bash
q "SELECT table_name||','||column_name||','||ordinal_position||','||data_type||','||
   COALESCE(character_maximum_length::text,'')||','||COALESCE(numeric_precision::text,'')||','||
   COALESCE(numeric_scale::text,'')||','||is_nullable||','||COALESCE(replace(column_default,',',';'),'')
   FROM information_schema.columns WHERE table_schema='public' ORDER BY table_name, ordinal_position;"
```

### Constraints — PK / FK / CHECK
Use `\d <table>` for human reading, and `information_schema` / `pg_catalog` for machine extraction:
- PK & unique: `information_schema.table_constraints` + `key_column_usage`
- FK with actions: join `pg_constraint` (contype='f') → get `confupdtype`/`confdeltype` for ON UPDATE/DELETE
- CHECK: `pg_constraint` contype='c', `pg_get_constraintdef(oid)` gives the readable expression

```bash
q "SELECT conrelid::regclass||' | '||conname||' | '||pg_get_constraintdef(oid)
   FROM pg_constraint WHERE connamespace='public'::regnamespace AND contype IN ('c','f','p')
   ORDER BY conrelid::regclass::text, contype;"
```

### Code values (critical for mapping enums)
```bash
q "SELECT cod_cd||' | '||cod_nm FROM t_cod_base_codes ORDER BY cod_cd;"
# If t_cod has a grouping/category column, group by it so mapping can pick the right enum subset.
```

### Category resolution (for discount apply-scope)
```bash
q "SELECT cat_cd||' | '||cat_nm FROM t_cat_categories WHERE cat_nm ~ '아크릴|굿즈|파우치|문구|에코백' ORDER BY cat_cd;"
```

## Sheet format standard

Write to `_workspace/huni-dbmap/00_schema/`:

- **schema-overview.md** — domain-grouped table list with row counts and one-line purpose.
- **tables-detail.md** — per table: a columns table (`column | type | null | default | key`), then PK / FKs (with cascade actions) / CHECK constraints / indexes as bullet lists.
- **columns.csv** — header: `table,column,ordinal,type,max_len,num_precision,num_scale,nullable,default`. Machine-readable for the mapping designer.
- **code-values.md** — `t_cod_base_codes` enumerated, grouped by category; call out discount-type and bundle-unit codes explicitly.

## Quality bar

- Every non-empty table has full column + constraint documentation.
- Empty tables (the load targets) are documented too — they are why this harness exists.
- Discrepancies between table-name intent and actual schema are flagged inline.
- No password ever appears in any output file (sheets are git-tracked).
