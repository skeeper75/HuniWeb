#!/usr/bin/env bash
# =====================================================================
# backup.sh — 디지털인쇄 가격엔진 적재 before-state 백업 (read-only)
#   --commit 전 안전망: 신규 키 부재 확인 + 영향 5테이블 현행 행수를
#   타임스탬프 파일로 덤프해 적재 후 검증(+147)·롤백 판단 자료로 보존.
#   DB 무변경(SELECT만). 비밀번호 미출력. 자격증명 .env.local.
#
#   사용: ./backup.sh   →  backup_state_<ts>.txt 생성
# =====================================================================
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: .env.local 없음: $ENV_FILE" >&2; exit 1; fi
# shellcheck disable=SC1090
set -a; source "$ENV_FILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # stdout 에 절대 출력하지 않음
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -X -v ON_ERROR_STOP=1)

TS="$(date +%Y%m%d_%H%M%S)"
OUT="$HERE/backup_state_${TS}.txt"

cd "$HERE"
{
  echo "-- before-state backup ${TS} (디지털인쇄 가격엔진 적재). read-only SELECT 덤프."
  "${PSQL[@]}" -f "$HERE/backup.sql"
} > "$OUT" 2>&1
unset PGPASSWORD
echo "[backup] before-state 덤프: $OUT"
