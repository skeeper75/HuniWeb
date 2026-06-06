#!/usr/bin/env bash
# =====================================================================
# apply.sh — 봉투제작(ENV) component_prices 40행 적재 실행기
#   기본 동작: DRY-RUN (migrate.sql 실행 후 강제 ROLLBACK). DB 무변경.
#   실제 반영은 --commit (인간 승인) 일 때만 — 본 하네스는 자동 COMMIT 금지.
#   자격증명: .env.local. 비밀번호는 절대 출력하지 않는다.
#
#   사용:
#     ./apply.sh            # DRY-RUN (롤백). 40 ENV 가격행 시도 후 무조건 ROLLBACK.
#     ./apply.sh --commit   # 실제 COMMIT (인간 승인). siz 등록·바인딩·코드행 없음 → 가격행만 반영.
#
#   HARD: ENV는 siz 신규등록 0·바인딩 INSERT 0·코드행 0 (전부 라이브 선존재) — 가장 단순 GO 트랙.
#         --commit 전 backup.sh(또는 backup.sql) 권장(COMP_ENV_MAKING 라이브=0 확증 = undo 권위).
# =====================================================================
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
MODE="dryrun"; [[ "${1:-}" == "--commit" ]] && MODE="commit"
if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: .env.local 없음: $ENV_FILE" >&2; exit 1; fi
# shellcheck disable=SC1090
source "$ENV_FILE"
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # 출력하지 않음
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -X -v ON_ERROR_STOP=1)
cd "$HERE"
if [[ "$MODE" == "commit" ]]; then
  echo "[apply] !!! COMMIT — ENV 봉투 40 단가를 라이브 반영 (siz/바인딩/코드행 없음) !!!"
  # migrate.sql 자체가 BEGIN…COMMIT 포함 → 그대로 실행
  "${PSQL[@]}" -f "$HERE/migrate.sql"
  echo "[apply] COMMIT 완료. 봉투제작 가격 룩업 확인 후 이상 시 ./undo.sh --commit."
else
  echo "[apply] DRY-RUN — migrate.sql 실행 후 강제 ROLLBACK (DB 무변경)."
  TMP="$(mktemp -t env_dryrun.XXXXXX.sql)"; trap 'rm -f "$TMP"' EXIT
  # migrate.sql 끝 COMMIT; 만 ROLLBACK; 으로 치환 (단일 COMMIT 라인 가정). \i 는 CWD(HERE) 상대.
  sed 's/^COMMIT;$/ROLLBACK;  -- DRY-RUN: 강제 롤백/' "$HERE/migrate.sql" > "$TMP"
  "${PSQL[@]}" -f "$TMP"
  echo "[apply] DRY-RUN 완료 — ROLLBACK 됨. DB 무변경. 실제 반영은 ./apply.sh --commit (인간 승인)."
fi
unset PGPASSWORD
