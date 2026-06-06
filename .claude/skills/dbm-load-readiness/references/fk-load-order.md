# FK Load Order — `t_*` whitelist, topological sort, code pre-load, manifest

Table of contents:
1. `t_*` target whitelist (the only tables you may emit)
2. FK topological sort — method + live query
3. Code-row pre-load (step 00)
4. Load manifest template

---

## 1. `t_*` target whitelist

Emit load rows for these tables ONLY. Anything outside (Django `auth_*`, `django_*`, any non-`t_`) is
forbidden — stop and flag. (Gate G1.)

**Product master (`t_prd_*`)**
`t_prd_products` (PK `prd_cd`) · `t_prd_product_categories` · `t_prd_product_sizes` ·
`t_prd_product_plate_sizes` · `t_prd_product_materials` · `t_prd_product_processes` ·
`t_prd_product_print_options` · `t_prd_product_sets` · `t_prd_product_bundle_qtys` ·
`t_prd_product_page_rules` · `t_prd_product_addons`

**CPQ (`t_prd_*`)**
`t_prd_product_option_groups` · `t_prd_product_options` · `t_prd_product_option_items` ·
`t_prd_templates` · `t_prd_template_selections` · `t_prd_product_constraints`

**Price (`t_prc_*` + product-price link)**
`t_prc_component_prices` · `t_prc_price_components` · `t_prc_price_formulas` ·
`t_prc_formula_components` · `t_prd_product_price_formulas` · `t_prd_product_prices`

**Master reference (FK targets — read; code rows pre-load only when missing)**
`t_cod_base_codes` · `t_cat_categories` · `t_clr_color_counts` · `t_mat_materials` ·
`t_siz_sizes` · `t_proc_processes`

Out of this track (do not emit): `t_dsc_*` (discount = round-1 separate track), `t_cus_*` (customer).

## 2. FK topological sort — method + live query

Load order must be a topological sort of the live FK graph: a table's FK parents load before it.

**Get the live FK edges (read-only):**
```bash
set -a; source .env.local; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -At -F'|' -c "
SELECT tc.table_name AS child, ccu.table_name AS parent, tc.constraint_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu ON tc.constraint_name = ccu.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name LIKE 't\_%'
ORDER BY child;"
```
(Never print `$PGPASSWORD`. The `00_schema/price-engine-fk-refs.md` sheet is a cached view — verify
against live when in doubt; the cache can be stale.)

**Canonical order (parents → children):**
1. **Step 00 — code rows** (`t_cod_base_codes` pre-load proposals; everything `*_typ_cd` depends on these).
2. **Master tables** — `t_cat_categories`, `t_clr_color_counts`, `t_mat_materials`, `t_siz_sizes`,
   `t_proc_processes` (only rows that are genuinely new; most are already live = read-only references).
3. **`t_prd_products`** — the product master; nearly every `t_prd_*` child FKs to `prd_cd`.
4. **Product relations** — `t_prd_product_categories`, `_sizes`, `_plate_sizes`, `_materials`,
   `_processes`, `_print_options`, `_sets`, `_bundle_qtys`, `_page_rules`.
5. **CPQ** — `t_prd_product_option_groups` → `t_prd_product_options` → `t_prd_product_option_items`;
   `t_prd_templates` → `t_prd_template_selections`; `t_prd_product_constraints`; `t_prd_product_addons`
   (FKs to `tmpl_cd`, so after `t_prd_templates`).
6. **Price** — `t_prc_price_formulas` → `t_prc_price_components` → `t_prc_formula_components`;
   `t_prc_component_prices`; `t_prd_product_price_formulas`, `t_prd_product_prices` (after `t_prd_products`).

Resolve the exact intra-group order from the live FK query — the list above is the expected shape, not a
substitute for the query. An unresolved parent or a cycle is a **blocker**: report the offending edge,
do not reorder around it silently.

## 3. Code-row pre-load (step 00)

When a load row needs a FK-target code value that is not live (e.g. `PRC_COMPONENT_TYPE.06` when only
`.05` exists), propose — never alter DDL:

- A `t_cod_base_codes` INSERT row: parent group, child code, name, sort, following the existing naming
  convention of its sibling codes (read the live siblings first; do not invent a scheme).
- Rationale: which load rows depend on it and why it is absent live.
- Place it in `load/00_<codegroup>.csv` and as step 00 in the manifest (FKs depend on it).

These are **proposals awaiting 후니 registration** — escalate to the lead. Do not assume they are live.

## 4. Load manifest template

Write to `_workspace/huni-dbmap/09_load/load-manifest.md` (Korean prose, English identifiers):

```
# 적재 매니페스트 — round-4 (실행=인간 승인 대상, 본 하네스는 산출까지)

## 적재 순서 (FK 위상정렬)
| 단계 | 대상 t_* 테이블 | 소스 CSV | 적재 행수 | 이 위치를 강제하는 FK 엣지 |
|------|----------------|----------|----------|---------------------------|
| 00 | t_cod_base_codes | load/00_xxx.csv | N | (코드 선적재 — 하위 *_typ_cd FK) |
| 01 | t_prd_products | load/01_products.csv | N | (parent of all t_prd_*) |
| ... | ... | ... | ... | ... |

## 적재 분류 집계
- 즉시 적재가능: N행 (단계별 내역)
- 차단(후니 등록 대기): M행 → blocked-and-gaps.md
- GAP(무손실 표현 불가): K건 → blocked-and-gaps.md
- 코드행 선적재 제안: X건 → code-row-preload.md

## 검증 인계
- 입력: 본 매니페스트 + load/*.csv + code-row-preload.md
- 게이트: dbm-validator가 G1~G9 + DRY-RUN (03_validation/load-readiness-gate.md)
```

The manifest is the single source of "what loads, in what order, and what is held back." Keep
(insertable + blocked + GAP) reconciled to the total mapped rows — no row disappears silently (G7).
