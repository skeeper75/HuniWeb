#!/usr/bin/env bash
# =====================================================================
# undo.sh — GP 합판도무송 원형 마이그레이션 역실행기
#   추가한 100 GP 단가 + 11 066 size link(신규 siz분만) + 등록한 10 siz 를 제거한다.
#   기본 동작: DRY-RUN (undo.sql 실행 후 ROLLBACK). 실제 제거는 --commit (인간 승인).
#   35mm(SIZ_000422)는 committed 분이라 절대 건드리지 않는다(undo.sql IN 절에서 제외).
#   자격증명: .env.local. 비밀번호는 절대 출력하지 않는다.
#
#   사용:
#     ./undo.sh            # DRY-RUN (롤백). 제거 카운트만 확인.
#     ./undo.sh --commit   # 실제 제거 (인간 승인). apply.sh --commit 직후 롤백용.
# =====================================================================
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
MODE="dryrun"
[[ "${1:-}" == "--commit" ]] && MODE="commit"

if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: .env.local 없음: $ENV_FILE" >&2; exit 1; fi
# shellcheck disable=SC1090
source "$ENV_FILE"
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # 출력하지 않음

PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -X -v ON_ERROR_STOP=1)

cd "$HERE"
if [[ "$MODE" == "commit" ]]; then
  echo "[undo] !!! COMMIT 모드 — 10 siz + 100 GP 단가 + 11 size link(신규분) 를 라이브에서 제거합니다 !!!"
  echo "[undo] 35mm(SIZ_000422)는 committed 분이라 보존(제거 안 함)."
  "${PSQL[@]}" -f "$HERE/undo.sql"
  echo "[undo] COMMIT 완료 — 마이그레이션 되돌림."
else
  echo "[undo] DRY-RUN — undo.sql 실행 후 강제 ROLLBACK (DB 무변경)."
  TMP="$(mktemp -t undo_gpcircle_dryrun.XXXXXX.sql)"
  trap 'rm -f "$TMP"' EXIT
  sed 's/^COMMIT;$/ROLLBACK;  -- DRY-RUN: 강제 롤백/' "$HERE/undo.sql" > "$TMP"
  "${PSQL[@]}" -f "$TMP"
  echo "[undo] DRY-RUN 완료 — ROLLBACK 됨. DB 무변경."
fi
unset PGPASSWORD
