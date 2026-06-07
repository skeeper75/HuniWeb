#!/usr/bin/env bash
# =====================================================================
# undo.sh — 디지털인쇄 가격엔진 적재 역연산 실행기 (멱등 INSERT 되돌리기)
#   적재한 신규 키(PRF_DGP_*·COMP_PAPER·그 자식행·19 바인딩)만 정밀 DELETE.
#   기존 라이브 행 무변경. FK 의존 역순(자식→부모) 단일 트랜잭션.
#
#   기본 동작: DRY-RUN (undo.sql 실행 후 강제 ROLLBACK). DB 무변경.
#   실제 반영은 --commit (인간 승인) 일 때만.
#   자격증명 .env.local. 비밀번호 미출력.
#
#   사용:
#     ./undo.sh            # DRY-RUN (롤백). 삭제 시도 후 무조건 ROLLBACK.
#     ./undo.sh --commit   # 실제 DELETE COMMIT (인간 승인). 적재 후 롤백이 필요할 때만.
# =====================================================================
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
MODE="dryrun"
[[ "${1:-}" == "--commit" ]] && MODE="commit"

if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: .env.local 없음: $ENV_FILE" >&2; exit 1; fi
# shellcheck disable=SC1090
set -a; source "$ENV_FILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # stdout 에 절대 출력하지 않음

PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -X -v ON_ERROR_STOP=1)

cd "$HERE"
if [[ "$MODE" == "commit" ]]; then
  echo "[undo] !!! COMMIT 모드 — 적재한 디지털인쇄 가격엔진 147행 DELETE (신규키 한정) !!!"
  "${PSQL[@]}" -f "$HERE/undo.sql"
  echo "[undo] COMMIT 완료. PRF_DGP_*·COMP_PAPER·자식·바인딩 제거됨."
else
  echo "[undo] DRY-RUN — undo.sql 실행 후 강제 ROLLBACK (DB 무변경)."
  TMP="$(mktemp -t dgp_undo_dryrun.XXXXXX.sql)"
  trap 'rm -f "$TMP"' EXIT
  sed 's/^COMMIT;$/ROLLBACK;  -- DRY-RUN: 강제 롤백/' "$HERE/undo.sql" > "$TMP"
  "${PSQL[@]}" -f "$TMP"
  echo "[undo] DRY-RUN 완료 — ROLLBACK 됨. DB 무변경."
fi
unset PGPASSWORD
