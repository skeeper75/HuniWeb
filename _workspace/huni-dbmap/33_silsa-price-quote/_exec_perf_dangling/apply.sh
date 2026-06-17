#!/usr/bin/env bash
# ============================================================================
# 미싱 dangling 배선 정리 로더 (apply.sh)
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
# 제거 대상 PERF 배선 전건 (D1 undo: 제거된 배선 재INSERT 근거)
"${PSQL[@]}" -At -F$'\t' -c "\copy (SELECT frm_cd, comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components WHERE comp_cd IN ('COMP_PP_PERF_1L','COMP_PP_PERF_2L','COMP_PP_PERF_3L')) TO '$BACKUP_DIR/pre_perf_formula_components.tsv'"
echo "[backup] 1개 TSV 저장 완료 (perf formula_components)"

if [[ "$MODE" == "--commit" ]]; then
  echo "[!!] --commit 모드: ROLLBACK→COMMIT 치환 실행 (인간 최종 승인 전제)"
  sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply.sql" | "${PSQL[@]}" -f -
else
  echo "[dryrun] 롤백전용 DRY-RUN (라이브 무변경)"
  "${PSQL[@]}" -f "$HERE/apply.sql"
fi
