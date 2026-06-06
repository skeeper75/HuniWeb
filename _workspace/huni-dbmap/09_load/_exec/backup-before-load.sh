#!/usr/bin/env bash
# backup-before-load.sh — 상품마스터 적재 전 before-image 스냅샷 (round-5, dbm-load-builder)
#
# 실제 COMMIT 을 승인하기 직전에 실행한다. UPDATE-set(90)이 변경할 행의 "현재값"을
# timestamped CSV 로 떠둔다(read-only). 이 백업이 있어야 언두(undo.sh)가 무손실 복원 가능.
#
# 동작: backup-before-load.sql 의 \copy ... TO 만 실행 — DB 변경 0(read-only).
# 출력: _exec/backup_<runts>/  (runts 는 호출자가 인자로 전달 — 스크립트 내 Date.now 금지·재현성).
#
# 안전:
#  - 자격증명은 .env.local(chmod 600·gitignore)에서만 로드. 비밀번호 echo/로그 금지.
#  - \copy TO 만 = INSERT/UPDATE/DELETE 0. 트랜잭션 무관(읽기전용).
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

# 각 스냅샷 쿼리(COPY ... TO STDOUT)를 psql 1회씩 실행하고 stdout 을 해당 CSV 로 리다이렉트.
# psql v18 의 \copy/\o 가 :'var' 경로 보간을 지원하지 않아 셸 리다이렉트로 경로를 처리한다(DB 변경 0).
run_snapshot() {
  local sqlfile="$1" outfile="$2"
  psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" \
       -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -q -f "$HERE/$sqlfile" > "$outfile"
}

echo "[BACKUP] 상품마스터 before-image 스냅샷 → $OUTDIR (read-only)"
run_snapshot "backup_q_products.sql"  "$OUTDIR/before_t_prd_products.csv"
run_snapshot "backup_q_materials.sql" "$OUTDIR/before_t_prd_product_materials_thickness.csv"
run_snapshot "backup_q_coderows.sql"  "$OUTDIR/before_code_row_targets.csv"

unset PGPASSWORD
echo "[BACKUP] 완료 — $OUTDIR 에 before-image CSV 3종. DB 변경 0."
ls -la "$OUTDIR"
