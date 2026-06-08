#!/usr/bin/env bash
# probe_db_coverage.sh — round-7 입체 커버리지: 축2 적재 상태 실측 (라이브 읽기전용)
#
# family-prd-map.csv (family,prd_cd,prd_nm) 의 각 상품군 prd_cd 집합에 대해,
# 각 t_* 자식 테이블의 실제 행수를 라이브 DB에서 묶음 집계한다. SELECT ONLY.
#
# 출력: db-coverage-raw.csv  (family, entity, prds_in_family, prds_with_rows, total_rows)
# 재현: bash probe_db_coverage.sh   (.env.local 의 RAILWAY_DB_* 필요)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../../../.." && pwd)"  # HuniWeb root (scripts -> 12_coverage -> huni-dbmap -> _workspace -> root)
MAP="$HERE/family-prd-map.csv"
OUT="$HERE/../db-coverage-raw.csv"

set -a; source "$ROOT/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
CONN="host=$RAILWAY_DB_HOST port=$RAILWAY_DB_PORT user=$RAILWAY_DB_USER dbname=$RAILWAY_DB_NAME sslmode=require"

# Build a VALUES list of (family,prd_cd) for an in-DB join (single round-trip per entity batch).
VALS=$(python3 - "$MAP" <<'PY'
import csv,sys
rows=[]
with open(sys.argv[1],encoding='utf-8') as f:
    r=csv.DictReader(f)
    for row in r:
        fam=row['family'].replace("'","''"); pc=row['prd_cd'].replace("'","''")
        rows.append(f"('{fam}','{pc}')")
print(",".join(rows))
PY
)

# Entities that probe directly by prd_cd
DIRECT_TABLES=(
 t_prd_products t_prd_product_categories t_prd_product_sizes t_prd_product_materials
 t_prd_product_print_options t_prd_product_processes t_prd_product_plate_sizes
 t_prd_product_bundle_qtys t_prd_product_page_rules t_prd_product_sets t_prd_product_addons
 t_prd_product_option_groups t_prd_product_options t_prd_product_option_items
 t_prd_product_constraints t_prd_product_price_formulas t_prd_product_discount_tables
)

echo "family,entity,prds_in_family,prds_with_rows,total_rows" > "$OUT"

for T in "${DIRECT_TABLES[@]}"; do
  # t_prd_products counts existence of the product itself
  if [ "$T" = "t_prd_products" ]; then
    SQL="WITH fam(family,prd_cd) AS (VALUES $VALS)
         SELECT f.family, '$T', count(*),
                count(*) FILTER (WHERE p.prd_cd IS NOT NULL),
                count(*) FILTER (WHERE p.prd_cd IS NOT NULL)
         FROM fam f LEFT JOIN t_prd_products p ON p.prd_cd=f.prd_cd
         GROUP BY f.family ORDER BY f.family;"
  else
    SQL="WITH fam(family,prd_cd) AS (VALUES $VALS),
              cnt AS (SELECT prd_cd, count(*) c FROM $T GROUP BY prd_cd)
         SELECT f.family, '$T', count(*),
                count(*) FILTER (WHERE c.c>0),
                COALESCE(sum(c.c),0)
         FROM fam f LEFT JOIN cnt c ON c.prd_cd=f.prd_cd
         GROUP BY f.family ORDER BY f.family;"
  fi
  psql "$CONN" -v ON_ERROR_STOP=1 -At -F',' -c "$SQL" >> "$OUT"
done

# component_prices: reached via price_formulas(prd_cd->frm_cd)->formula_components->component_prices
SQL_CP="WITH fam(family,prd_cd) AS (VALUES $VALS),
  chain AS (
    SELECT pf.prd_cd, count(DISTINCT cp.comp_price_id) c
    FROM t_prd_product_price_formulas pf
    JOIN t_prc_formula_components fc ON fc.frm_cd=pf.frm_cd
    JOIN t_prc_component_prices cp   ON cp.comp_cd=fc.comp_cd
    GROUP BY pf.prd_cd)
  SELECT f.family, 't_prc_component_prices', count(*),
         count(*) FILTER (WHERE ch.c>0), COALESCE(sum(ch.c),0)
  FROM fam f LEFT JOIN chain ch ON ch.prd_cd=f.prd_cd
  GROUP BY f.family ORDER BY f.family;"
psql "$CONN" -v ON_ERROR_STOP=1 -At -F',' -c "$SQL_CP" >> "$OUT"

# templates: global table reached via addons.tmpl_cd OR editor_yn. Measure per-family editor products.
SQL_TPL="WITH fam(family,prd_cd) AS (VALUES $VALS)
  SELECT f.family, 't_prd_templates', count(*),
         count(*) FILTER (WHERE p.editor_yn='Y'),
         count(*) FILTER (WHERE p.editor_yn='Y')
  FROM fam f LEFT JOIN t_prd_products p ON p.prd_cd=f.prd_cd
  GROUP BY f.family ORDER BY f.family;"
psql "$CONN" -v ON_ERROR_STOP=1 -At -F',' -c "$SQL_TPL" >> "$OUT"

echo "wrote $OUT"
wc -l "$OUT"
