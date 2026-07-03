#!/usr/bin/env bash
# 굿즈파우치 Phase 1(33 단일가) 가격 적재 실행기.
#  ./apply.sh          → DRY-RUN(백업 + ROLLBACK)
#  ./apply.sh commit   → 인간 승인 후 실제 COMMIT
set -euo pipefail
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HERE/backup"
[[ -f "$ENV_FILE" ]] || { echo "ERROR: $ENV_FILE 없음"; exit 1; }
set -a; source "$ENV_FILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -X)
MODE="${1:-dryrun}"
mkdir -p "$BACKUP_DIR"
# 물리 백업(사전: 대상 prd_cd 의 현재 product_prices — 기대 0행)
"${PSQL[@]}" -At -F, -c "\copy (SELECT prd_cd,apply_ymd,unit_price,note FROM t_prd_product_prices WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000280' ORDER BY prd_cd,apply_ymd) TO '$BACKUP_DIR/pre_product_prices.csv' CSV HEADER"
echo "[backup] $BACKUP_DIR/pre_product_prices.csv"
if [[ "$MODE" == "commit" ]]; then
  echo "[COMMIT] 실제 라이브 반영 — ROLLBACK→COMMIT 치환"
  sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply.sql" | "${PSQL[@]}" -f -
else
  echo "[DRY-RUN] ROLLBACK 유지"
  "${PSQL[@]}" -f "$HERE/apply.sql"
fi
