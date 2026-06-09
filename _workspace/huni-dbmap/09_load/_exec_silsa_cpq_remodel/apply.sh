#!/usr/bin/env bash
# silsa CPQ 각목 재모델 로더 — 기본 DRY-RUN(롤백). commit 인자 = 인간 승인 적용.
#   ./apply.sh         # DRY-RUN (BEGIN…apply…ROLLBACK)
#   ./apply.sh commit  # [인간 승인] 실제 COMMIT
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
set -a; source "$ROOT/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
MODE="${1:-dryrun}"
HERE="$(cd "$(dirname "$0")" && pwd)"; cd "$HERE"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 --no-psqlrc)
if [ "$MODE" = "commit" ]; then
  echo "[COMMIT MODE] 각목 재모델 실제 적용"
  "${PSQL[@]}" -f apply.sql -c "COMMIT;"
else
  echo "[DRY-RUN] 롤백전용 — 아무것도 커밋되지 않음"
  "${PSQL[@]}" -f apply.sql -c "ROLLBACK;"
fi
unset PGPASSWORD
