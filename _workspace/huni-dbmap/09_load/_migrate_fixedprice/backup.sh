#!/usr/bin/env bash
# =====================================================================
# backup.sh — 읽기전용 백업 스냅샷 실행기
#   마이그레이션 전 15상품의 PRF_POSTER_FIXED 바인딩(+선행 partial 단가)을
#   CSV로 떠둔다. undo 복원 권위본. DB 쓰기 없음(\copy out 만).
#   자격증명: .env.local. 비밀번호는 절대 출력하지 않는다.
# =====================================================================
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"

if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: .env.local 없음: $ENV_FILE" >&2; exit 1; fi
# shellcheck disable=SC1090
source "$ENV_FILE"
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # 출력하지 않음

echo "[backup] 읽기전용 스냅샷 → $HERE/backup_prf_poster_bindings.csv"
cd "$HERE"
psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" \
     -X -v ON_ERROR_STOP=1 -f "$HERE/backup.sql"

echo "[backup] 완료:"
echo "  - backup_prf_poster_bindings.csv ($(($(wc -l < backup_prf_poster_bindings.csv)-1)) 행)"
echo "  - backup_partial_component_prices.csv ($(($(wc -l < backup_partial_component_prices.csv)-1)) 행)"
unset PGPASSWORD
