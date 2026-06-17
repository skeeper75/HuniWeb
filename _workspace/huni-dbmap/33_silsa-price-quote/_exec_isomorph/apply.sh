#!/usr/bin/env bash
# 실사 동형 결합 로더 — 기본 DRY-RUN(ROLLBACK). 실 COMMIT은 인간 승인(commit)만.
# 비밀번호 미출력. 권위: silsa-isomorph-merge-design.md · load-execution R1~R6.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
set -a; source "$ROOT/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"            # stdout echo 금지
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-dryrun}"                                # dryrun(기본) | dryrun-full | commit
PSQL="psql -h $RAILWAY_DB_HOST -p $RAILWAY_DB_PORT -U $RAILWAY_DB_USER -d $RAILWAY_DB_NAME -v ON_ERROR_STOP=1"

case "$MODE" in
  dryrun-full)
    echo "[DRY-RUN FULL] dryrun.sql — before/after/golden/멱등2pass, BEGIN…ROLLBACK (COMMIT 0)"
    $PSQL -f "$DIR/dryrun.sql"
    ;;
  commit)
    echo "[COMMIT MODE] 인간 승인 적재 — apply.sql + COMMIT"
    $PSQL -1 -f "$DIR/apply.sql" -c "COMMIT;"
    ;;
  *)
    echo "[DRY-RUN] apply.sql 롤백전용 — 아무것도 커밋되지 않음"
    $PSQL -1 -f "$DIR/apply.sql" -c "ROLLBACK;"
    ;;
esac
unset PGPASSWORD
