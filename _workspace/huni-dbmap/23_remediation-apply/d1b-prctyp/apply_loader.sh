#!/usr/bin/env bash
# =====================================================================
# apply_loader.sh  (round-13 정정 트랙 · D-1b 로더)
# 권위: dbm-load-execution/references/sql-idempotent-patterns.md §7.
# 기본 = DRY-RUN(롤백전용). 실 COMMIT은 --commit(인간 승인) 시에만.
#
# 사용:
#   ./apply_loader.sh            # DRY-RUN(기본) — BEGIN...ROLLBACK, 아무것도 커밋 안 됨
#   ./apply_loader.sh dryrun     # 동일
#   ./apply_loader.sh --commit   # [인간 승인 전용] 실제 적재 — D-1b prc_typ 정정 영구 반영
#
# [HARD] 비밀번호(RAILWAY_DB_PASSWORD) stdout/로그 출력 금지.
# [HARD] --commit는 엔진 .03 규칙(webadmin Phase11)과 반드시 동시 배포 — manifest.md 경고 참조.
# =====================================================================
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
HERE="$(cd "$(dirname "$0")" && pwd)"
set -a; source "$ROOT/.env.local"; set +a   # RAILWAY_DB_* 로드(값 echo 금지)
export PGPASSWORD="$RAILWAY_DB_PASSWORD"     # 환경변수로만 전달

MODE="${1:-dryrun}"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

cd "$HERE"   # \i 상대경로(00_*.sql, 01_*.sql) 해석 기준

cleanup() { unset PGPASSWORD; }
trap cleanup EXIT

case "$MODE" in
  --commit)
    echo "[COMMIT MODE] 인간 승인 적재 — apply.sql 적용 후 COMMIT"
    echo "  ⚠ 동시 배포 필수: 엔진 .03 규칙(webadmin Phase11) 없으면 미정의 동작. manifest.md §동시배포 확인."
    "${PSQL[@]}" -f apply.sql -c "COMMIT;"
    ;;
  dryrun|*)
    echo "[DRY-RUN] 롤백전용 — 아무것도 커밋되지 않음"
    "${PSQL[@]}" -f apply.sql -c "ROLLBACK;"
    ;;
esac
