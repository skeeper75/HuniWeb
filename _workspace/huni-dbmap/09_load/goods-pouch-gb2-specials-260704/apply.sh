#!/usr/bin/env bash
set -euo pipefail
ENV="/Users/innojini/Dev/HuniWeb/.env.local"; HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; BK="$HERE/backup"
set -a; source "$ENV"; set +a; export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -X)
MODE="${1:-dryrun}"; mkdir -p "$BK"
CDS="'PRD_000194','PRD_000198','PRD_000217','PRD_000226'"
"${PSQL[@]}" -At -F, -c "\copy (SELECT prd_cd,mat_cd,usage_cd,del_yn FROM t_prd_product_materials WHERE prd_cd IN ($CDS) ORDER BY prd_cd,mat_cd) TO '$BK/pre_materials.csv' CSV HEADER"
"${PSQL[@]}" -At -F, -c "\copy (SELECT prd_cd,frm_cd,apply_bgn_ymd FROM t_prd_product_price_formulas WHERE prd_cd IN ($CDS)) TO '$BK/pre_formulas.csv' CSV HEADER"
echo "[backup] $BK/{pre_materials,pre_formulas}.csv"
if [[ "$MODE" == "commit" ]]; then echo "[COMMIT]"; sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply.sql" | "${PSQL[@]}" -f -
else echo "[DRY-RUN]"; "${PSQL[@]}" -f "$HERE/apply.sql"; fi
