#!/usr/bin/env bash
# apply.sh — RC-2 CONFIRM 확정 3건(린넨마감·타공 데이터·족자) 적재 로더 (기본 DRY-RUN 롤백)
# 사용: ./apply.sh            # DRY-RUN (롤백전용·아무것도 커밋 안 됨)
#       ./apply.sh dryrun     # 동일
#       ./apply.sh commit      # ★인간 승인(dbm-validator R1~R6 GO) 후에만. 실제 적재(COMMIT).
#       ./apply.sh undo        # DRY-RUN 원복(롤백전용)
#       ./apply.sh undo-commit # ★인간 승인 후에만. 실제 원복(COMMIT).
# 비밀번호는 PGPASSWORD로만 전달·stdout/로그 echo 금지. ★각목(GAKMOK)=범위 밖·미접촉.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
set -a; source "$ROOT/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
cd "$(dirname "$0")"
MODE="${1:-dryrun}"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

case "$MODE" in
  commit)
    echo "[COMMIT MODE] 인간 승인 적재 — apply.sql + COMMIT"
    "${PSQL[@]}" -f apply.sql -c "COMMIT;" ;;
  undo)
    echo "[DRY-RUN UNDO] 롤백전용 — 아무것도 커밋되지 않음"
    "${PSQL[@]}" -f undo.sql -c "ROLLBACK;" ;;
  undo-commit)
    echo "[COMMIT UNDO] 인간 승인 원복 — undo.sql + COMMIT"
    "${PSQL[@]}" -f undo.sql -c "COMMIT;" ;;
  *)
    echo "[DRY-RUN] 롤백전용 — 아무것도 커밋되지 않음"
    "${PSQL[@]}" -f apply.sql -c "ROLLBACK;" ;;
esac
unset PGPASSWORD
