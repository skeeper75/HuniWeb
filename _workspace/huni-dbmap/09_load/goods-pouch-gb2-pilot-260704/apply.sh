#!/usr/bin/env bash
# 굿즈파우치 GB-2 파일럿(240). ./apply.sh | ./apply.sh commit
set -euo pipefail
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; BACKUP_DIR="$HERE/backup"
set -a; source "$ENV_FILE"; set +a; export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -X)
MODE="${1:-dryrun}"; mkdir -p "$BACKUP_DIR"
# 물리 백업(사전: 240 자재/사이즈/옵션/공식)
"${PSQL[@]}" -At -F, -c "\copy (SELECT prd_cd,mat_cd,usage_cd,dflt_yn,del_yn FROM t_prd_product_materials WHERE prd_cd='PRD_000240' ORDER BY mat_cd) TO '$BACKUP_DIR/pre_materials.csv' CSV HEADER"
echo "[backup] $BACKUP_DIR/pre_materials.csv"
if [[ "$MODE" == "commit" ]]; then echo "[COMMIT]"; sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply.sql" | "${PSQL[@]}" -f -
else echo "[DRY-RUN]"; "${PSQL[@]}" -f "$HERE/apply.sql"; fi
