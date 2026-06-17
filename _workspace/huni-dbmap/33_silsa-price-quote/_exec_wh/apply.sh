#!/usr/bin/env bash
# apply.sh — 신안 siz_width/siz_height 로더. 기본 = 롤백전용 DRY-RUN. --commit 시에만 실 COMMIT(인간 승인).
# 비밀값 비노출: .env.local RAILWAY_DB_* 사용, 패스워드 stdout 미출력.
set -euo pipefail
cd "$(dirname "$0")"

# repo root .env.local 탐색
ROOT="$(cd ../../../.. && pwd)"
ENVFILE="$ROOT/.env.local"
[ -f "$ENVFILE" ] || { echo "FATAL: .env.local not found at $ENVFILE"; exit 1; }
set -a; . "$ENVFILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL="psql -h $RAILWAY_DB_HOST -p $RAILWAY_DB_PORT -U $RAILWAY_DB_USER -d $RAILWAY_DB_NAME -v ON_ERROR_STOP=1"

MODE="${1:-dryrun}"

echo "== 백업 SELECT (변경 대상 사전 스냅샷, undo 근거) =="
$PSQL -At -c "\copy (SELECT comp_price_id,comp_cd,siz_cd,siz_width,siz_height,min_qty,unit_price FROM t_prc_component_prices WHERE comp_cd IN ('COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_BANNER_MESH','COMP_POSTER_BANNER_NORMAL','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_LEATHER_ARTPRINT','COMP_POSTER_LINEN_FABRIC','COMP_POSTER_MESH_PRINT','COMP_POSTER_TYVEK_PRINT','COMP_POSTER_WATERPROOF_PET')) TO 'backup_matrix_comp_prices_pre.csv' WITH CSV HEADER"
$PSQL -At -c "\copy (SELECT comp_cd,use_dims FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_POSTER_%') TO 'backup_use_dims_pre.csv' WITH CSV HEADER"
$PSQL -At -c "\copy (SELECT prd_cd,nonspec_yn,nonspec_width_incr,nonspec_height_incr FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000118' AND 'PRD_000139') TO 'backup_nonspec_pre.csv' WITH CSV HEADER"
echo "  → backup_*_pre.csv 저장"

if [ "$MODE" = "--commit" ]; then
  echo "== !! COMMIT 모드 (인간 승인 가정) — ROLLBACK→COMMIT 치환 실행 =="
  sed 's/^ROLLBACK;/COMMIT;/' apply.sql | $PSQL -f -
else
  echo "== DRY-RUN (롤백전용·라이브 무변경) =="
  $PSQL -f apply.sql
fi
