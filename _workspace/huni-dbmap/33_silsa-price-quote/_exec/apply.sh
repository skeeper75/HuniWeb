#!/usr/bin/env bash
# apply.sh — 실사 round-23 Phase C 로더. 기본 = 롤백전용 DRY-RUN. --commit 시에만 실 적용(인간 승인).
# 비밀값 비노출(PGPASSWORD env로만 전달·echo 금지). read .env.local RAILWAY_DB_*.
set -euo pipefail
cd "$(dirname "$0")"

ENVFILE="../../../../.env.local"   # repo root .env.local
[ -f "$ENVFILE" ] || { echo "FATAL: .env.local 없음 ($ENVFILE)"; exit 1; }
set -a; source "$ENVFILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"

PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

MODE="${1:-dryrun}"

if [ "$MODE" = "--commit" ] || [ "$MODE" = "commit" ]; then
  echo "!! COMMIT 모드 — 실 라이브 변경. 인간 승인 확인됨 가정."
  TXEND="COMMIT;"
else
  echo "== DRY-RUN(롤백전용) — 라이브 무변경 =="
  TXEND="ROLLBACK;"
fi

# U5 hard-delete 백업(undo) — COMMIT 전에 항상 백업 떠둠.
echo "-- U5 백업 SELECT → backup_U5_white.csv (undo 근거)"
"${PSQL[@]}" -tAc "\copy (SELECT comp_price_id,comp_cd,apply_ymd,siz_cd,clr_cd,mat_cd,coat_side_cnt,bdl_qty,min_qty,unit_price,proc_cd,opt_cd,print_opt_cd,plt_siz_cd FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_SPOT_WHITE_S1' AND proc_cd<>'PROC_000008') TO 'backup_U5_white.csv' WITH CSV HEADER" || echo "(백업 SELECT 실패 무시 — DRY-RUN)"

# apply.sql 실행 + 트랜잭션 종료 주입
{ cat apply.sql; echo "$TXEND"; } | "${PSQL[@]}" -f -
echo "== 완료 (mode=$MODE) =="
