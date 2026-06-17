#!/usr/bin/env bash
# ============================================================================
# 064 소량자유형 가격 적재 로더 (apply.sh)
#   기본: 롤백전용 DRY-RUN (BEGIN…ROLLBACK·라이브 무변경)
#   --commit: 인간 최종 승인 후에만 ROLLBACK→COMMIT 치환 실행
# 비밀값 비노출: .env.local 의 RAILWAY_DB_* 만 사용. 비밀번호 출력 금지.
# ============================================================================
set -euo pipefail

ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HERE/backup_$(date +%Y%m%d_%H%M%S)"

[[ -f "$ENV_FILE" ]] || { echo "ERROR: $ENV_FILE 없음"; exit 1; }
set -a; source "$ENV_FILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

MODE="${1:-dryrun}"

# ---- 백업 SELECT (undo 근거·읽기전용·어느 모드든 먼저) ----
mkdir -p "$BACKUP_DIR"
echo "[backup] → $BACKUP_DIR"
"${PSQL[@]}" -At -F, -c "\copy (SELECT comp_price_id,comp_cd,apply_ymd,siz_cd,mat_cd,min_qty,unit_price,note FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND siz_cd IN ('SIZ_000036','SIZ_000043','SIZ_000061','SIZ_000062','SIZ_000063','SIZ_000064','SIZ_000065') ORDER BY siz_cd,mat_cd,min_qty) TO '$BACKUP_DIR/pre_component_prices.csv' CSV HEADER"
"${PSQL[@]}" -At -F, -c "\copy (SELECT prd_cd,frm_cd,apply_bgn_ymd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000064') TO '$BACKUP_DIR/pre_binding.csv' CSV HEADER"
echo "[backup] 2개 CSV 저장 완료 (undo 근거)"

cd "$HERE"  # \i 가 sql 파일 상대경로를 cwd 기준 해석하므로 번들 디렉터리로 진입
if [[ "$MODE" == "--commit" ]]; then
  echo "[!!] --commit 모드: ROLLBACK→COMMIT 치환 실행 (인간 최종 승인 전제)"
  sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply.sql" | "${PSQL[@]}" -f -
else
  echo "[dryrun] 롤백전용 DRY-RUN (라이브 무변경)"
  "${PSQL[@]}" -f "$HERE/apply.sql"
fi
