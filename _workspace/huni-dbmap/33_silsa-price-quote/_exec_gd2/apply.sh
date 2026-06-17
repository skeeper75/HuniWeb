#!/usr/bin/env bash
# apply.sh — G-D2 후가공 배선 로더. 기본 = 롤백전용 DRY-RUN. --commit 시에만 실 COMMIT(인간 승인).
# 비밀값 비노출(.env.local RAILWAY_DB_* 사용·stdout 미출력).
set -euo pipefail

# repo root 탐색 (.env.local 위치)
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/../../../.. && pwd)"
ENVFILE="$ROOT/.env.local"
[ -f "$ENVFILE" ] || { echo "FATAL: .env.local not found at $ENVFILE"; exit 1; }
set -a; . "$ENVFILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"

PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)
cd "$(dirname "${BASH_SOURCE[0]}")"

MODE="${1:-dryrun}"   # dryrun(기본) | --commit

# --- 백업 SELECT (멱등·비파괴 대상이라 hard-delete 없음, W3 바인딩 교체분만 백업) ---
echo "== 백업: G-D2 변경 영향 사전 스냅샷 =="
"${PSQL[@]}" -c "\copy (SELECT prd_cd,frm_cd,apply_bgn_ymd FROM t_prd_product_price_formulas WHERE prd_cd BETWEEN 'PRD_000118' AND 'PRD_000145') TO 'backup_bindings_pre.csv' CSV HEADER" || true
"${PSQL[@]}" -c "\copy (SELECT comp_cd,prc_typ_cd,use_yn,use_dims FROM t_prc_price_components WHERE comp_cd IN ('COMP_PP_PERF_1L','COMP_PP_PERF_2L','COMP_PP_PERF_3L')) TO 'backup_perf_comp_pre.csv' CSV HEADER" || true
"${PSQL[@]}" -c "\copy (SELECT comp_price_id,comp_cd,opt_cd,proc_cd,dim_vals,min_qty,unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_PP_PERF_1L') TO 'backup_perf_prices_pre.csv' CSV HEADER" || true

if [ "$MODE" = "--commit" ]; then
  echo "== !! COMMIT 모드 (인간 승인 가정) — apply.sql 의 ROLLBACK 을 COMMIT 으로 치환 =="
  sed 's/^ROLLBACK;/COMMIT;/' apply.sql | "${PSQL[@]}" -f -
else
  echo "== DRY-RUN (롤백전용·라이브 무변경) =="
  "${PSQL[@]}" -f apply.sql
fi
echo "== done ($MODE) =="
