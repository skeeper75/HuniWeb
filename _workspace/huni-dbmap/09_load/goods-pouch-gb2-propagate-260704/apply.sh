#!/usr/bin/env bash
# 굿즈 GB-2 전파 clean 28. ./apply.sh(dryrun) | ./apply.sh commit
set -euo pipefail
ENV="/Users/innojini/Dev/HuniWeb/.env.local"; HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; BK="$HERE/backup"
set -a; source "$ENV"; set +a; export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -X)
MODE="${1:-dryrun}"; mkdir -p "$BK"
CDS="'PRD_000186','PRD_000187','PRD_000195','PRD_000200','PRD_000201','PRD_000202','PRD_000203','PRD_000215','PRD_000216','PRD_000220','PRD_000229','PRD_000230','PRD_000231','PRD_000232','PRD_000233','PRD_000238','PRD_000239','PRD_000243','PRD_000244','PRD_000245','PRD_000246','PRD_000247','PRD_000249','PRD_000252','PRD_000254','PRD_000273','PRD_000274','PRD_000280'"
"${PSQL[@]}" -At -F, -c "\copy (SELECT prd_cd,mat_cd,usage_cd,del_yn FROM t_prd_product_materials WHERE prd_cd IN ($CDS) ORDER BY prd_cd,mat_cd) TO '$BK/pre_materials.csv' CSV HEADER"
"${PSQL[@]}" -At -F, -c "\copy (SELECT prd_cd,siz_cd,dflt_yn,del_yn FROM t_prd_product_sizes WHERE prd_cd IN ($CDS) ORDER BY prd_cd,siz_cd) TO '$BK/pre_sizes.csv' CSV HEADER"
echo "[backup] $BK/{pre_materials,pre_sizes}.csv"
if [[ "$MODE" == "commit" ]]; then echo "[COMMIT]"; sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply.sql" | "${PSQL[@]}" -f -
else echo "[DRY-RUN]"; "${PSQL[@]}" -f "$HERE/apply.sql"; fi
