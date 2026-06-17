#!/usr/bin/env bash
# ============================================================================
# 린넨 마감가공 옵션 등록 로더 (apply.sh)
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
"${PSQL[@]}" -At -F, -c "\copy (SELECT prd_cd,opt_cd,opt_grp_cd,opt_nm,dflt_yn,disp_seq,use_yn FROM t_prd_product_options WHERE prd_cd='PRD_000124' AND opt_grp_cd='OPT_000009') TO '$BACKUP_DIR/pre_options.csv' CSV HEADER"
"${PSQL[@]}" -At -F, -c "\copy (SELECT prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn FROM t_prd_product_option_items WHERE prd_cd='PRD_000124' AND opt_cd IN ('OPV_000025','OPV_000026','OPV_000027','OPV-000024','OPV_000424')) TO '$BACKUP_DIR/pre_option_items.csv' CSV HEADER"
"${PSQL[@]}" -At -F, -c "\copy (SELECT comp_cd,comp_nm,comp_typ_cd,prc_typ_cd,use_dims,use_yn FROM t_prc_price_components WHERE comp_cd='COMP_POSTEROPT_LINEN_FINISH') TO '$BACKUP_DIR/pre_comp.csv' CSV HEADER"
"${PSQL[@]}" -At -F, -c "\copy (SELECT comp_price_id,comp_cd,apply_ymd,opt_cd,proc_cd,unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_POSTEROPT_LINEN_FINISH') TO '$BACKUP_DIR/pre_component_prices.csv' CSV HEADER"
"${PSQL[@]}" -At -F, -c "\copy (SELECT frm_cd,comp_cd,disp_seq,addtn_yn FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_LINEN') TO '$BACKUP_DIR/pre_formula_components.csv' CSV HEADER"
echo "[backup] 5개 CSV 저장 완료"

if [[ "$MODE" == "--commit" ]]; then
  echo "[!!] --commit 모드: ROLLBACK→COMMIT 치환 실행 (인간 최종 승인 전제)"
  sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply.sql" | "${PSQL[@]}" -f -
else
  echo "[dryrun] 롤백전용 DRY-RUN (라이브 무변경)"
  "${PSQL[@]}" -f "$HERE/apply.sql"
fi
