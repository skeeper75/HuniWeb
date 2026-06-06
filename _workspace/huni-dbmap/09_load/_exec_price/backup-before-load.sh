#!/usr/bin/env bash
# backup-before-load.sh — 가격(t_prc_*) 적재 전 스냅샷 (round-5, dbm-load-builder)
#
# 실제 COMMIT 직전에 실행. 가격 5 테이블이 EMPTY 임(행수=0)을 timestamped CSV 로 기록한다
# (되돌림 안전 근거: 적재 후 적재행=신규행 전부 → DELETE-all 등가). 코드행 선존여부도 떠둔다.
# 동작: \copy ... TO 만 — DB 변경 0(read-only).
# 출력: _exec_price/backup_<runts>/  (runts 는 호출자 인자 — 스크립트 내 Date.now 금지·재현성).
#
# 사용:
#   ./backup-before-load.sh <runts>     # 예: ./backup-before-load.sh 20260606T1530
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "ERROR: runts 인자 필요 (예: ./backup-before-load.sh 20260606T1530)" >&2
  exit 2
fi
RUNTS="$1"

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(git -C "$HERE" rev-parse --show-toplevel)"
ENV_FILE="$ROOT/.env.local"

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE 없음 (자격증명 필요)" >&2
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

: "${RAILWAY_DB_HOST:?RAILWAY_DB_HOST 미설정}"
: "${RAILWAY_DB_PORT:?RAILWAY_DB_PORT 미설정}"
: "${RAILWAY_DB_USER:?RAILWAY_DB_USER 미설정}"
: "${RAILWAY_DB_NAME:?RAILWAY_DB_NAME 미설정}"
: "${RAILWAY_DB_PASSWORD:?RAILWAY_DB_PASSWORD 미설정}"

OUTDIR="$HERE/backup_${RUNTS}"
mkdir -p "$OUTDIR"
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # 환경변수로만 전달, echo 금지

echo "[BACKUP] 가격 t_prc_* 적재 전 스냅샷 → $OUTDIR (read-only)"
# backup-before-load.sql = COPY ... TO STDOUT 1건 → psql stdout 을 파일로 리다이렉트(DB 변경 0).
psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" \
     -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -q \
     -f "$HERE/backup-before-load.sql" > "$OUTDIR/before_prc_counts.csv"

unset PGPASSWORD
echo "[BACKUP] 완료 — $OUTDIR/before_prc_counts.csv. DB 변경 0."
cat "$OUTDIR/before_prc_counts.csv"
