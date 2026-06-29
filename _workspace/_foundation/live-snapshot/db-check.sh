#!/usr/bin/env bash
# 라이브 Railway DB 연결 검증 (값 비노출·읽기전용)
# 사용: bash _workspace/_foundation/live-snapshot/db-check.sh
#  실행 시 Bash 도구는 dangerouslyDisableSandbox=true 필요(외부 DB 네트워크).
set -euo pipefail
ROOT="/Users/innojini/Dev/HuniWeb"
cd "$ROOT"
set -a; source .env.local 2>/dev/null; set +a
: "${RAILWAY_DB_HOST:?RAILWAY_DB_* 미설정}"
out=$(PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
        -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc \
        "SELECT current_database()||' | t_*='||(SELECT count(*) FROM information_schema.tables WHERE table_schema='public' AND table_name LIKE 't\_%')||' | prc_comp='||(SELECT count(*) FROM t_prc_price_components)" \
        2>/dev/null) \
  && echo "CONN OK: $out" \
  || { echo "CONN FAIL (네트워크/sandbox/자격증명 — 값 비노출)"; exit 1; }
