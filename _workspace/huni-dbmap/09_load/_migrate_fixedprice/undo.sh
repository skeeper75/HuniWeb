#!/usr/bin/env bash
# =====================================================================
# undo.sh — 고정가형 정정 마이그레이션 역실행기
#   기본 동작: DRY-RUN (undo.sql 실행 후 ROLLBACK).
#   실제 되돌림은 --commit (인간 승인) 일 때만.
#   전제: backup.sh 가 backup_prf_poster_bindings.csv 를 생성해 둠.
#   자격증명: .env.local. 비밀번호 출력 금지.
#
#   사용:
#     ./undo.sh            # DRY-RUN (롤백)
#     ./undo.sh --commit   # 실제 되돌림 (인간 승인)
# =====================================================================
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
MODE="dryrun"
[[ "${1:-}" == "--commit" ]] && MODE="commit"

if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: .env.local 없음: $ENV_FILE" >&2; exit 1; fi
# shellcheck disable=SC1090
source "$ENV_FILE"
export PGPASSWORD="$RAILWAY_DB_PASSWORD"

PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -X -v ON_ERROR_STOP=1)
cd "$HERE"

if [[ "$MODE" == "commit" ]]; then
  echo "[undo] !!! COMMIT 모드 — 고정가형 정정을 되돌립니다 (PRF_POSTER_FIXED 복원) !!!"
  "${PSQL[@]}" -f "$HERE/undo.sql"
  echo "[undo] 되돌림 완료."
else
  echo "[undo] DRY-RUN — undo.sql 실행 후 강제 ROLLBACK (DB 무변경)."
  TMP="$(mktemp -t undo_dryrun.XXXXXX.sql)"
  trap 'rm -f "$TMP"' EXIT
  sed 's/^COMMIT;$/ROLLBACK;  -- DRY-RUN: 강제 롤백/' "$HERE/undo.sql" > "$TMP"
  "${PSQL[@]}" -f "$TMP"
  echo "[undo] DRY-RUN 완료 — ROLLBACK 됨. DB 무변경."
fi
unset PGPASSWORD
