#!/usr/bin/env bash
# =====================================================================
# apply.sh — 안전 GO분 로더 (BLOCKED 차원 선적재 + 더미 정리)
#   기본 = DRY-RUN(롤백전용). 실제 COMMIT 은 commit 인자로만(인간 승인).
#   .env.local 에서 RAILWAY_DB_* 로드. 비밀번호 stdout/_workspace 기록 금지.
# 사용법: ./apply.sh [dryrun|commit]
# =====================================================================
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
set -a; source "$ROOT/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
MODE="${1:-dryrun}"
HERE="$(cd "$(dirname "$0")" && pwd)"; cd "$HERE"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 --no-psqlrc)
if [ "$MODE" = "commit" ]; then
  echo "[COMMIT MODE] 인간 승인 적재 — apply.sql 끝에 COMMIT 주입"
  "${PSQL[@]}" -f apply.sql -c "COMMIT;"
else
  echo "[DRY-RUN] 롤백전용 — 아무것도 커밋되지 않음"
  "${PSQL[@]}" -f apply.sql -c "ROLLBACK;"
fi
unset PGPASSWORD
