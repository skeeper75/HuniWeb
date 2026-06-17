#!/usr/bin/env bash
# undo.sh — 아크릴 동형 전환(A1~A3+AW) 실 COMMIT 원복 로더. 기본 = 롤백전용 검증. --commit 시에만 실 원복(인간 승인).
# 백업 권위: backup_comp_prices_pre.csv(121) · backup_use_dims_pre.csv(2) · backup_wiring_pre.csv(1).
# 비밀값 비노출: .env.local RAILWAY_DB_* 사용, 패스워드 stdout 미출력.
set -euo pipefail
cd "$(dirname "$0")"

ROOT="$(cd ../../../.. && pwd)"
ENVFILE="$ROOT/.env.local"
[ -f "$ENVFILE" ] || { echo "FATAL: .env.local not found at $ENVFILE"; exit 1; }
set -a; . "$ENVFILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

# 백업 존재 가드 (undo 권위)
for f in backup_comp_prices_pre.csv backup_use_dims_pre.csv backup_wiring_pre.csv; do
  [ -f "$f" ] || { echo "FATAL: backup missing: $f (apply.sh dryrun 으로 먼저 생성)"; exit 1; }
done

MODE="${1:-dryrun}"
if [ "$MODE" = "--commit" ]; then
  echo "== !! UNDO COMMIT 모드 (인간 승인 가정) — ROLLBACK→COMMIT 치환 실행 =="
  sed 's/^ROLLBACK;/COMMIT;/' undo.sql | "${PSQL[@]}" -f -
else
  echo "== UNDO DRY-RUN (롤백전용·라이브 무변경·원복 가능성 검증) =="
  "${PSQL[@]}" -f undo.sql
fi
