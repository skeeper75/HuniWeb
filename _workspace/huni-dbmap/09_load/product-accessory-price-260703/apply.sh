#!/usr/bin/env bash
# 상품악세사리 Phase 1 가격 적재 실행기.
# 사용법:  ./apply.sh          → DRY-RUN(백업 + ROLLBACK, 라이브 무변경)
#          ./apply.sh commit   → 인간 승인 후 실제 COMMIT
# 비밀값 비노출: .env.local 의 RAILWAY_DB_* 만 사용. 비밀번호 출력 금지.
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

# 물리 백업(사전 상태: 악세사리 34 템플릿의 현재 template_prices — 기대 0행)
"${PSQL[@]}" -At -F, -c "\copy (SELECT tp.tmpl_cd,tp.apply_ymd,tp.unit_price,tp.note FROM t_prd_template_prices tp JOIN t_prd_templates t ON t.tmpl_cd=tp.tmpl_cd WHERE t.base_prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015' ORDER BY tp.tmpl_cd,tp.apply_ymd) TO '$BACKUP_DIR/pre_template_prices.csv' CSV HEADER"
echo "[backup] $BACKUP_DIR/pre_template_prices.csv"

if [[ "$MODE" == "commit" ]]; then
  echo "[COMMIT] 실제 라이브 반영 — ROLLBACK→COMMIT 치환 실행"
  sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply.sql" | "${PSQL[@]}" -f -
else
  echo "[DRY-RUN] ROLLBACK 유지 — 라이브 무변경"
  "${PSQL[@]}" -f "$HERE/apply.sql"
fi
