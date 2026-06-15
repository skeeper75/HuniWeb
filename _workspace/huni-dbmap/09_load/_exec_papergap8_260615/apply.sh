#!/usr/bin/env bash
# =====================================================================
# apply.sh — 디지털 국4절 종이비 GAP 7행 로더
#   기본 = DRY-RUN(롤백전용). 실제 COMMIT 은 commit 인자로만(인간 승인).
#   .env.local 에서 RAILWAY_DB_* 로드. 비밀번호 stdout/_workspace 기록 금지.
# 사용법:
#   ./apply.sh            DRY-RUN 1-pass (BEGIN…ROLLBACK, 신규 7행·검증)
#   ./apply.sh idempotent DRY-RUN 2-pass (한 트랜잭션 내 01 재실행 → delta 0 멱등 실증, ROLLBACK)
#   ./apply.sh commit     실 COMMIT (인간 승인 — backup.sql 선행 필수)
# =====================================================================
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
set -a; source "$ROOT/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
MODE="${1:-dryrun}"
HERE="$(cd "$(dirname "$0")" && pwd)"; cd "$HERE"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 --no-psqlrc)

case "$MODE" in
  commit)
    echo "[COMMIT MODE] 인간 승인 적재 — apply.sql 끝에 COMMIT 주입"
    echo "  ※ backup.sql(스냅샷) 선행 실행 여부를 반드시 확인하라."
    "${PSQL[@]}" -f apply.sql -c "COMMIT;"
    ;;
  idempotent)
    echo "[DRY-RUN 2-pass 멱등] BEGIN → 01 적재 → 01 재실행(2nd pass delta 0) → ROLLBACK"
    "${PSQL[@]}" \
      -c "BEGIN;" \
      -c "\echo == PASS 1 ==" \
      -f 01_comp_paper_gap.sql \
      -c "SELECT 'after pass1' lbl, count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER';" \
      -c "\echo == PASS 2 (재실행 — 추가 0 기대) ==" \
      -f 01_comp_paper_gap.sql \
      -c "SELECT 'after pass2 (pass1과 동일=멱등OK)' lbl, count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER';" \
      -c "ROLLBACK;"
    ;;
  *)
    echo "[DRY-RUN 1-pass] 롤백전용 — 아무것도 커밋되지 않음"
    "${PSQL[@]}" -f apply.sql -c "ROLLBACK;"
    ;;
esac
unset PGPASSWORD
