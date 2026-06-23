#!/usr/bin/env bash
# apply.sh — RC-2 각목(GAKMOK) 적재 로더 (기본 DRY-RUN 롤백전용)
# 사용:
#   ./apply.sh             # DRY-RUN (apply.sql 실행 후 즉시 ROLLBACK — 아무것도 커밋 안 됨)
#   ./apply.sh dryrun      # 동일
#   ./apply.sh commit      # ★dbm-validator R1~R6 GO + 인간 승인 후에만. 실제 적재(COMMIT).
#   ./apply.sh undo        # DRY-RUN 원복(롤백전용)
#   ./apply.sh undo-commit # ★인간 승인 후에만. 실제 원복(COMMIT).
# 비밀번호는 PGPASSWORD로만 전달·stdout/로그 echo 금지.
# apply.sql/undo.sql은 자체 BEGIN…COMMIT을 포함하므로 DRY-RUN은 단일 세션 트랜잭션 래핑으로 강제 롤백.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
set -a; source "$ROOT/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
cd "$(dirname "$0")"
MODE="${1:-dryrun}"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -P pager=off)

# DRY-RUN: 파일 내부 BEGIN/COMMIT을 무력화하기 위해 외곽 트랜잭션으로 감싸고 ROLLBACK.
dryrun_wrap() {  # $1 = sql file
  local sql; sql="$(sed -E 's/^[[:space:]]*(BEGIN|COMMIT)[[:space:]]*;.*$/-- &/I' "$1")"
  printf 'BEGIN;\n%s\nROLLBACK;\n' "$sql" | "${PSQL[@]}" -f -
}

case "$MODE" in
  commit)
    echo "[COMMIT MODE] 인간 승인 적재 — apply.sql (자체 BEGIN…COMMIT)"
    "${PSQL[@]}" -f apply.sql ;;
  undo)
    echo "[DRY-RUN UNDO] 롤백전용 — 아무것도 커밋되지 않음"
    dryrun_wrap undo.sql ;;
  undo-commit)
    echo "[COMMIT UNDO] 인간 승인 원복 — undo.sql (자체 BEGIN…COMMIT)"
    "${PSQL[@]}" -f undo.sql ;;
  *)
    echo "[DRY-RUN] 롤백전용 — apply.sql 실행 후 강제 ROLLBACK (아무것도 커밋되지 않음)"
    dryrun_wrap apply.sql ;;
esac
unset PGPASSWORD
