#!/usr/bin/env bash
# ============================================================================
# 신안 + G-D2 통합 실행본 로더 (apply.sh)
#   기본: 롤백전용 DRY-RUN (BEGIN…ROLLBACK, 라이브 무변경)
#   --commit: 인간 최종 승인 후에만 ROLLBACK→COMMIT 치환 실행
# 비밀값 비노출: .env.local 의 RAILWAY_DB_* 만 사용, 출력에 비밀번호 노출 금지.
# ============================================================================
set -euo pipefail

ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HERE/backup_$(date +%Y%m%d_%H%M%S)"

if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: $ENV_FILE 없음"; exit 1; fi
set -a; source "$ENV_FILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

MODE="${1:-dryrun}"   # dryrun(기본) | --commit

# ---- 백업 SELECT (undo 근거·읽기전용, 어느 모드든 먼저 떠 둠) ----
mkdir -p "$BACKUP_DIR"
echo "[backup] → $BACKUP_DIR"
# MINOR-1 보강: W5 가 바꾸는 prc_typ_cd·use_yn 포함(역복원 가능). use_dims 와 함께 한 CSV.
"${PSQL[@]}" -At -F, -c "\copy (SELECT comp_cd, use_dims, prc_typ_cd, use_yn FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_POSTER_%' OR comp_cd LIKE 'COMP_PP_%') TO '$BACKUP_DIR/pre_use_dims.csv' CSV HEADER"
"${PSQL[@]}" -At -F, -c "\copy (SELECT comp_price_id, comp_cd, siz_cd, siz_width, siz_height, opt_cd, proc_cd, dim_vals, unit_price FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_POSTER_%' OR comp_cd LIKE 'COMP_PP_PERF%') TO '$BACKUP_DIR/pre_component_prices.csv' CSV HEADER"
"${PSQL[@]}" -At -F, -c "\copy (SELECT frm_cd, comp_cd, disp_seq FROM t_prc_formula_components WHERE frm_cd LIKE 'PRF_POSTER%' OR frm_cd LIKE 'PRF_DGP%') TO '$BACKUP_DIR/pre_formula_components.csv' CSV HEADER"
"${PSQL[@]}" -At -F, -c "\copy (SELECT prd_cd, frm_cd, apply_bgn_ymd FROM t_prd_product_price_formulas WHERE prd_cd BETWEEN 'PRD_000118' AND 'PRD_000145') TO '$BACKUP_DIR/pre_product_price_formulas.csv' CSV HEADER"
"${PSQL[@]}" -At -F, -c "\copy (SELECT prd_cd, nonspec_width_incr, nonspec_height_incr FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000118' AND 'PRD_000145') TO '$BACKUP_DIR/pre_nonspec.csv' CSV HEADER"
echo "[backup] 5개 CSV 저장 완료"

if [[ "$MODE" == "--commit" ]]; then
  echo "[!!] --commit 모드: ROLLBACK→COMMIT 치환 실행 (인간 최종 승인 전제)"
  sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply.sql" | "${PSQL[@]}" -f -
else
  echo "[dryrun] 롤백전용 DRY-RUN (라이브 무변경)"
  "${PSQL[@]}" -f "$HERE/apply.sql"
fi
