#!/usr/bin/env bash
# undo.sh — ENV 40행 역적재 (DELETE 1713~1752). 기본 DRY-RUN, --commit=인간 승인.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
MODE="dryrun"; [[ "${1:-}" == "--commit" ]] && MODE="commit"
# shellcheck disable=SC1090
source "$ENV_FILE"; export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -X -v ON_ERROR_STOP=1)
cd "$HERE"
if [[ "$MODE" == "commit" ]]; then "${PSQL[@]}" -f "$HERE/undo.sql"; echo "[undo] COMMIT — ENV 40행 제거.";
else TMP="$(mktemp -t env_undo.XXXXXX.sql)"; trap 'rm -f "$TMP"' EXIT
  sed 's/^COMMIT;$/ROLLBACK;/' "$HERE/undo.sql" > "$TMP"; "${PSQL[@]}" -f "$TMP"; echo "[undo] DRY-RUN — ROLLBACK."; fi
unset PGPASSWORD
