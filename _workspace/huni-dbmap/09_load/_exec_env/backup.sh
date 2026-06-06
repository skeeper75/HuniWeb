#!/usr/bin/env bash
# =====================================================================
# backup.sh — 읽기전용 백업 스냅샷 실행기 (undo 권위본)
#   ENV는 INSERT-only 가격 적재 → backup = COMP_ENV_MAKING component_prices 라이브=0 확증(빈 슬롯 입증) +
#   본 적재 comp_price_id(1713~1752) 부재 확증 + 재사용 siz(191~194) 선존재 스냅샷. DB 쓰기 없음(\copy out).
#   자격증명: .env.local. 비밀번호는 절대 출력하지 않는다.
# =====================================================================
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: .env.local 없음: $ENV_FILE" >&2; exit 1; fi
# shellcheck disable=SC1090
source "$ENV_FILE"
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # 출력하지 않음

echo "[backup] 읽기전용 스냅샷 → $HERE/backup_*.csv"
cd "$HERE"
psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" \
     -X -v ON_ERROR_STOP=1 -f "$HERE/backup.sql"

echo "[backup] 완료:"
echo "  - backup_env_component_prices_before.csv  (COMP_ENV_MAKING 적재 전 = 0행 기대, 빈 슬롯 입증)"
echo "  - backup_env_id_collisions.csv            (0행이어야 정상 — comp_price_id 1713~1752 라이브 부재)"
echo "  - backup_env_reuse_siz.csv                (재사용 siz 191~194 선존재 — undo 시 절대 제거 안 함)"
unset PGPASSWORD
