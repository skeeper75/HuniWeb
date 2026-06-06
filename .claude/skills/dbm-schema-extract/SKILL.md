---
name: dbm-schema-extract
description: Railway PostgreSQL 후니프린팅 railway DB의 구조를 읽기전용으로 추출해 검토용 시트(Markdown + CSV)로 만드는 방법론 스킬. psql 안전 읽기전용 쿼리 툴킷, 44테이블(t_* 도메인 34 + Django 10; CPQ 옵션/템플릿/제약 레이어 포함) 접두사 도메인 분류, 컬럼/타입/제약/FK/CHECK/인덱스/트리거/코드값 추출 패턴, 구조 시트 포맷 표준을 제공한다. 'DB 구조 추출', '스키마 시트 작성', 'DDL 추출', '제약/FK 정리', '코드값 조회', 'information_schema 조회' 작업 시 반드시 사용.
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

## Domain grouping (44 tables — t_* domain 34 + Django 10)

Group tables in the overview by prefix so reviewers see the domain map at a glance (Django/auth 10 tables는 도메인 무관 — t_* 34만 대상):

| Prefix | Domain | Notes |
|--------|--------|-------|
| `t_cat_` | Categories | master reference |
| `t_cod_` | Base codes | enum/code dictionary — FK target for `*_typ_cd`, `grade_cd`. CPQ 신규 그룹: `OPT_REF_DIM`(7)/`SEL_TYPE`(2)/`RULE_TYPE`(3) |
| `t_clr_` | Color counts | master |
| `t_mat_` | Materials | master |
| `t_siz_` | Sizes | master |
| `t_proc_` | Processes | master |
| `t_prd_` | Products + 차원 + **CPQ** | 차원(materials/sizes/print_options/processes/sets/bundle_qtys/page_rules/plate_sizes/categories) + **CPQ 레이어(2026-06-06 라이브 구현): `option_groups`/`options`/`option_items`[polymorphic `ref_dim_cd`→OPT_REF_DIM + 트리거 `fn_chk_opt_item_ref`], `templates`/`template_selections`, `product_constraints`[`logic` jsonb]**. `addons.addon_prd_cd→tmpl_cd`. `products.constraint_json` jsonb 캐시. **`t_prd_product_process_excl_groups` 제거**(option_groups 흡수) |
| `t_prc_` | Pricing | formulas/components/prices (가격 매핑 산출, 미적재) |
| `t_dsc_` | Discounts | discount tables/details/grade rates |
| `t_cus_` | Customers | |

> **[2026-06-06 라이브 델타]** 이전 29 → 현재 t_* 34. CPQ 구현으로 t_prd_ CPQ 레이어 6신규 + categories, `excl_groups` 제거, **전 마스터·차원·CPQ 테이블에 `del_yn`/`del_dt` 소프트삭제 + `trg_*_upd_dt` 트리거 추가**. 추출 시 CPQ polymorphic 트리거 본문(`pg_get_functiondef`)·`del_yn` 필터·신규 코드그룹을 함께 시트화. **상세·정합 판정 = `_workspace/huni-dbmap/00_schema/cpq-schema.md`**.

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
