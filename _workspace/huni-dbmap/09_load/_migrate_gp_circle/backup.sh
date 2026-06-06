#!/usr/bin/env bash
# =====================================================================
# backup.sh — 읽기전용 백업 스냅샷 실행기 (undo 권위본)
#   t_siz_sizes 는 INSERT-only 마이그레이션 → backup = 신규 발급 siz_cd(501~510) 부재 확증 +
#   영향 comp_cd(COMP_GANGPAN_PRINT) 의 기존 GP component_prices 스냅샷(적재 전 상태, committed 35mm 포함) +
#   PRD_000066 기존 size link 스냅샷. DB 쓰기 없음(\copy out).
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
echo "  - backup_new_siz_range.csv              (신규 발급 siz_cd 범위 = undo 권위)"
echo "  - backup_existing_collisions.csv         (0행이어야 정상 — 신규 siz_cd 라이브 부재 확증)"
echo "  - backup_gp_component_prices_before.csv   (영향 comp_cd 적재 전 GP 단가, committed 35mm 포함)"
echo "  - backup_066_product_sizes_before.csv     (PRD_000066 적재 전 size link)"
unset PGPASSWORD
