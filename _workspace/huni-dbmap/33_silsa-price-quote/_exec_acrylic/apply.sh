#!/usr/bin/env bash
# apply.sh — 아크릴 siz_width/siz_height 동형 전환 로더. 기본 = 롤백전용 DRY-RUN. --commit 시에만 실 COMMIT(인간 승인).
# 비밀값 비노출: .env.local RAILWAY_DB_* 사용, 패스워드 stdout 미출력.
set -euo pipefail
cd "$(dirname "$0")"

# repo root .env.local 탐색 (_workspace/huni-dbmap/33_silsa-price-quote/_exec_acrylic → 4단계 상위)
ROOT="$(cd ../../../.. && pwd)"
ENVFILE="$ROOT/.env.local"
[ -f "$ENVFILE" ] || { echo "FATAL: .env.local not found at $ENVFILE"; exit 1; }
set -a; . "$ENVFILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

MODE="${1:-dryrun}"

echo "== 백업 SELECT (변경 대상 사전 스냅샷·undo 근거) =="
"${PSQL[@]}" -At -c "\copy (SELECT comp_price_id,comp_cd,siz_cd,siz_width,siz_height,mat_cd,min_qty,unit_price FROM t_prc_component_prices WHERE comp_cd IN ('COMP_ACRYL_CLEAR3T','COMP_ACRYL_MIRROR3T')) TO 'backup_comp_prices_pre.csv' WITH CSV HEADER"
"${PSQL[@]}" -At -c "\copy (SELECT comp_cd,use_dims FROM t_prc_price_components WHERE comp_cd IN ('COMP_ACRYL_CLEAR3T','COMP_ACRYL_MIRROR3T')) TO 'backup_use_dims_pre.csv' WITH CSV HEADER"
"${PSQL[@]}" -At -c "\copy (SELECT frm_cd,comp_cd,disp_seq,addtn_yn FROM t_prc_formula_components WHERE frm_cd='PRF_CLR_ACRYL') TO 'backup_wiring_pre.csv' WITH CSV HEADER"
echo "  → backup_*_pre.csv 저장"

if [ "$MODE" = "--commit" ]; then
  echo "== !! COMMIT 모드 (인간 승인 가정) — ROLLBACK→COMMIT 치환 실행 =="
  sed 's/^ROLLBACK;/COMMIT;/' apply.sql | "${PSQL[@]}" -f -
else
  echo "== DRY-RUN (롤백전용·라이브 무변경) =="
  "${PSQL[@]}" -f apply.sql
fi
