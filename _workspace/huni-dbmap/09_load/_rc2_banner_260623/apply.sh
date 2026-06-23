#!/usr/bin/env bash
# apply.sh — RC-2 일반현수막 옵션 바인딩 로더 (기본 DRY-RUN 롤백)
# 사용: ./apply.sh            # DRY-RUN (롤백전용·아무것도 커밋 안 됨)
#       ./apply.sh dryrun     # 동일
#       ./apply.sh commit     # ★인간 승인 후에만. 실제 적재(COMMIT).
# 비밀번호는 PGPASSWORD로만 전달·stdout/로그 echo 금지.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
set -a; source "$ROOT/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
cd "$(dirname "$0")"
MODE="${1:-dryrun}"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

if [ "$MODE" = "commit" ]; then
  echo "[COMMIT MODE] 인간 승인 적재 — apply.sql + COMMIT"
  "${PSQL[@]}" -f apply.sql -c "COMMIT;"
else
  echo "[DRY-RUN] 롤백전용 — 아무것도 커밋되지 않음"
  "${PSQL[@]}" -f apply.sql -c "ROLLBACK;"
fi
unset PGPASSWORD
