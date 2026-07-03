#!/usr/bin/env bash
# 103 굿즈/파우치/봉투 전수 재프라이싱 — 라이브 t_prd_product_prices + t_prd_product_price_formulas 결정론 1회 SELECT
# 07-04 최신 라이브(스냅샷 재신뢰 금지). 읽기전용 SELECT만. 값 손전사 금지(스크립트 전사).
# 출력: prd_cd | unit_price | prices_rows | formula_rows | frm_cds | reg_dt | 분류
# 분류: FIXED-LOOKUP(가격O·공식X) / FORMULA(공식O) / NEITHER(둘 다 X)
set -euo pipefail
ROOT="/Users/innojini/Dev/HuniWeb"
cd "$ROOT"
set -a; source .env.local 2>/dev/null; set +a
: "${RAILWAY_DB_HOST:?RAILWAY_DB_* 미설정}"

OUT="_workspace/huni-ontology-kb/05_verification/scripts/reprice_goods_260704.csv"

# 103 굿즈 prd_cd (001/002/005/011/015/050 + 183~279 + 283 · 181 정철노트=문구 제외)
PRDS="PRD_000001,PRD_000002,PRD_000005,PRD_000011,PRD_000015,PRD_000050,PRD_000283"
for n in $(seq 183 279); do
  PRDS="$PRDS,PRD_$(printf '%06d' "$n")"
done

SQL="
WITH scope AS (
  SELECT unnest(string_to_array('${PRDS}', ',')) AS prd_cd
),
px AS (
  SELECT prd_cd,
         max(unit_price) FILTER (WHERE unit_price IS NOT NULL) AS unit_price,
         count(*) AS prices_rows,
         max(reg_dt::date) AS max_reg_dt
  FROM t_prd_product_prices
  WHERE prd_cd IN (SELECT prd_cd FROM scope)
  GROUP BY prd_cd
),
fm AS (
  SELECT prd_cd,
         count(*) AS formula_rows,
         string_agg(DISTINCT frm_cd, '/') AS frm_cds
  FROM t_prd_product_price_formulas
  WHERE prd_cd IN (SELECT prd_cd FROM scope)
  GROUP BY prd_cd
),
prd AS (
  SELECT prd_cd, prd_typ_cd, use_yn, del_yn FROM t_prd_products
  WHERE prd_cd IN (SELECT prd_cd FROM scope)
)
SELECT s.prd_cd,
       COALESCE(px.unit_price::text,'') AS unit_price,
       COALESCE(px.prices_rows,0) AS prices_rows,
       COALESCE(fm.formula_rows,0) AS formula_rows,
       COALESCE(fm.frm_cds,'') AS frm_cds,
       COALESCE(px.max_reg_dt::text,'') AS reg_dt,
       COALESCE(prd.prd_typ_cd,'') AS prd_typ,
       COALESCE(prd.use_yn,'') AS use_yn,
       COALESCE(prd.del_yn,'') AS del_yn,
       CASE
         WHEN COALESCE(fm.formula_rows,0) > 0 THEN 'FORMULA'
         WHEN COALESCE(px.prices_rows,0) > 0 AND px.unit_price IS NOT NULL THEN 'FIXED-LOOKUP'
         ELSE 'NEITHER'
       END AS classify
FROM scope s
LEFT JOIN px ON px.prd_cd = s.prd_cd
LEFT JOIN fm ON fm.prd_cd = s.prd_cd
LEFT JOIN prd ON prd.prd_cd = s.prd_cd
ORDER BY s.prd_cd;
"

echo "prd_cd,unit_price,prices_rows,formula_rows,frm_cds,reg_dt,prd_typ,use_yn,del_yn,classify" > "$OUT"
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tA -F',' -c "$SQL" >> "$OUT"

echo "=== 분류 집계 ==="
awk -F',' 'NR>1{c[$10]++} END{for(k in c) print k": "c[k]}' "$OUT"
echo "=== 총 ==="
awk -F',' 'NR>1{n++} END{print "rows: "n}' "$OUT"
echo "OUT: $OUT"
