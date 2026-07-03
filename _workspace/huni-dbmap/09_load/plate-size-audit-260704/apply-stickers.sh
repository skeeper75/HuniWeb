#!/usr/bin/env bash
set -euo pipefail
ENV="/Users/innojini/Dev/HuniWeb/.env.local"; HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -a; source "$ENV"; set +a; export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -X)
if [[ "${1:-dryrun}" == "commit" ]]; then echo "[COMMIT]"; sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply-stickers-etc.sql" | "${PSQL[@]}" -f -
else echo "[DRY-RUN]"; "${PSQL[@]}" -f "$HERE/apply-stickers-etc.sql"; fi
