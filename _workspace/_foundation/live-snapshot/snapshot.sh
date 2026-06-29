#!/usr/bin/env bash
# 라이브 Railway DB 표준 스냅샷 — 전 t_* 테이블을 CSV로 export.
# 목적: codex·배치·진단 에이전트가 "같은 라이브 실데이터"를 파일로 읽게(라이브 직접 접속 불가 도구 우회).
# 사용: bash _workspace/_foundation/live-snapshot/snapshot.sh
#  실행 시 Bash 도구는 dangerouslyDisableSandbox=true 필요(외부 DB 네트워크).
# 읽기전용(SELECT/COPY만)·비밀값 비노출(PGPASSWORD env·CSV에 자격증명 없음).
set -euo pipefail
ROOT="/Users/innojini/Dev/HuniWeb"
cd "$ROOT"
set -a; source .env.local 2>/dev/null; set +a
: "${RAILWAY_DB_HOST:?RAILWAY_DB_* 미설정}"
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME")

TS=$(date +%Y%m%d_%H%M)
BASE="_workspace/_foundation/live-snapshot"
OUT="$BASE/snap_$TS"
mkdir -p "$OUT"

# 전 t_* 테이블 (public 스키마)
tables=()
while IFS= read -r _t; do [ -n "$_t" ] && tables+=("$_t"); done < <("${PSQL[@]}" -tAc \
  "SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_name LIKE 't\_%' ORDER BY table_name")

echo "table,rows" > "$OUT/_manifest.csv"
for t in "${tables[@]}"; do
  "${PSQL[@]}" -c "\copy (SELECT * FROM \"$t\") TO '$OUT/$t.csv' WITH CSV HEADER" >/dev/null
  n=$("${PSQL[@]}" -tAc "SELECT count(*) FROM \"$t\"")
  echo "$t,$n" >> "$OUT/_manifest.csv"
done

# latest 심볼릭 링크 (codex·배치가 항상 최신 스냅샷 참조)
ln -sfn "snap_$TS" "$BASE/latest"
echo "SNAPSHOT OK: $OUT (${#tables[@]} tables) · latest -> snap_$TS"
echo "manifest: $OUT/_manifest.csv"
