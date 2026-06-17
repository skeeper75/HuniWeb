#!/usr/bin/env bash
# ============================================================================
# apply.sh — 네이밍 표준화 적재 로더 (round-34)
# ----------------------------------------------------------------------------
# 기본    : ROLLBACK DRY-RUN (라이브 무변경). 실 COMMIT 은 --commit + 인간 승인.
# 안전    : 비밀값(PGPASSWORD) stdout 미출력. .env.local 절대경로 source.
# 사용:
#   ./apply.sh dryrun     # 기본 — dryrun.sql 실행 (BEGIN…ROLLBACK·검증 출력)
#   ./apply.sh apply      # apply.sql 을 BEGIN…ROLLBACK 으로 감싸 실증(여전히 무변경)
#   ./apply.sh --commit   # apply.sql 을 실제 COMMIT (인간 승인 후에만!)
#   ./apply.sh backup     # backup_undo.sql 백업 SELECT (원복 아님)
#   ./apply.sh undo --commit  # _naming_undo.sql 원복 COMMIT (인간 승인 후)
# ============================================================================
set -euo pipefail

ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: .env.local 없음: $ENV_FILE" >&2; exit 1; fi
set -a; source "$ENV_FILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # 환경변수로만 전달 — echo/명령행 노출 금지

PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

# 생성기 재실행으로 SQL 재현(손편집 방지)
python3 gen_naming_sql.py >/dev/null 2>&1 || { echo "ERROR: gen 실패" >&2; exit 1; }

MODE="${1:-dryrun}"

case "$MODE" in
  dryrun)
    echo ">> DRY-RUN (dryrun.sql · BEGIN…ROLLBACK · 라이브 무변경)"
    "${PSQL[@]}" -f dryrun.sql
    ;;
  apply)
    echo ">> APPLY-DRYRUN (apply.sql 을 ROLLBACK 으로 감쌈 · 무변경 실증)"
    { cat apply.sql; echo "ROLLBACK;"; } | "${PSQL[@]}" -f -
    echo ">> ROLLBACK 완료 — 라이브 무변경"
    ;;
  --commit|commit)
    echo ">> !!! REAL COMMIT — 인간 승인 확인됨으로 간주. apply.sql + COMMIT 실행"
    { cat apply.sql; echo "COMMIT;"; } | "${PSQL[@]}" -f -
    echo ">> COMMIT 완료"
    ;;
  backup)
    echo ">> BACKUP SELECT (원복 아님). 결과를 backup_<날짜>.txt 로 리다이렉트 권장."
    "${PSQL[@]}" -v run_undo=0 -f backup_undo.sql
    ;;
  undo)
    if [[ "${2:-}" == "--commit" ]]; then
      echo ">> !!! UNDO COMMIT — pre-state 원복 실행"
      "${PSQL[@]}" -v run_undo=1 -f backup_undo.sql
    else
      echo ">> UNDO 미실행 — 실제 원복은 ./apply.sh undo --commit"
      "${PSQL[@]}" -v run_undo=0 -f backup_undo.sql
    fi
    ;;
  *)
    echo "usage: ./apply.sh [dryrun|apply|--commit|backup|undo [--commit]]" >&2
    exit 2
    ;;
esac
