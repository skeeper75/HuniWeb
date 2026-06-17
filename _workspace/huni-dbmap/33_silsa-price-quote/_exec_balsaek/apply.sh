#!/usr/bin/env bash
# ============================================================================
# 별색 dedup (U5') 로더 (apply.sh)
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
echo "[backup] -> $BACKUP_DIR"
# 형제 9 + 정본 comp_nm/use_yn (U5'-2·U5'-3 undo)
"${PSQL[@]}" -At -F$'\t' -c "\copy (SELECT comp_cd, comp_nm, use_yn FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_PRINT_SPOT_%') TO '$BACKUP_DIR/pre_components.tsv'"
# 별색 배선 전건 (U5'-1 undo: 제거된 배선 재INSERT 근거)
"${PSQL[@]}" -At -F$'\t' -c "\copy (SELECT frm_cd, comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components WHERE comp_cd LIKE 'COMP_PRINT_SPOT_%') TO '$BACKUP_DIR/pre_formula_components.tsv'"
echo "[backup] 2개 TSV 저장 완료 (components·formula_components)"

if [[ "$MODE" == "--commit" ]]; then
  echo "[!!] --commit 모드: ROLLBACK→COMMIT 치환 실행 (인간 최종 승인 전제)"
  sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply.sql" | "${PSQL[@]}" -f -
else
  echo "[dryrun] 롤백전용 DRY-RUN (라이브 무변경)"
  "${PSQL[@]}" -f "$HERE/apply.sql"
fi
