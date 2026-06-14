#!/usr/bin/env bash
# =====================================================================
# apply.sh — 스티커 Tier A 4상품(PRD_000052·053·055·066) CPQ 옵션레이어 로더 (psql)
#   기본 = DRY-RUN(롤백전용). 실제 COMMIT 은 인간 승인 commit 인자로만. NEVER COMMIT by default.
#   .env.local 에서 RAILWAY_DB_* 로드. 비밀번호 stdout/_workspace 기록 절대 금지.
#
# 사용법:
#   ./apply.sh            # DRY-RUN (BEGIN…apply…ROLLBACK) — 기본, 아무것도 커밋 안 함
#   ./apply.sh dryrun     # 동일(명시)
#   ./apply.sh commit     # [인간 승인] 실제 COMMIT — 영구 적재
# =====================================================================
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
set -a
source "$ROOT/.env.local"          # RAILWAY_DB_HOST/PORT/USER/NAME/PASSWORD 로드
set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # stdout 에 절대 echo 금지

MODE="${1:-dryrun}"
HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 --no-psqlrc)

if [ "$MODE" = "commit" ]; then
  echo "[COMMIT MODE] 인간 승인 적재 — apply.sql 끝에 COMMIT 주입"
  "${PSQL[@]}" -f apply.sql -c "COMMIT;"
else
  echo "[DRY-RUN] 롤백전용 — 아무것도 커밋되지 않음 (BEGIN…apply…ROLLBACK)"
  "${PSQL[@]}" -f apply.sql -c "ROLLBACK;"
fi

unset PGPASSWORD
