#!/usr/bin/env bash
# apply.sh — 상품마스터(t_prd_*/t_proc_/t_siz_) 적재 로더 (round-5, dbm-load-builder)
#
# 라이브 railway DB에 apply.sql(단일 트랜잭션)을 실행한다.
# 기본 = DRY-RUN(ROLLBACK) — 아무것도 영구 적재되지 않는다.
# 실제 COMMIT 은 './apply.sh commit' (인간 승인 플래그)로만. 본 하네스는 commit 을 호출하지 않는다.
#
# 안전:
#  - 자격증명은 .env.local(chmod 600·gitignore)에서만 로드. 비밀번호 echo/로그 금지.
#  - apply.sql 은 BEGIN 으로 열고 COMMIT/ROLLBACK 미포함 — 본 스크립트가 모드에 따라 주입.
#  - ON_ERROR_STOP=1: 임의 문 실패 시 트랜잭션 abort → 전체 롤백(R2 원자성).
#  - 멱등성(R1): INSERT 전건 ON CONFLICT 가드, UPDATE 전건 IS DISTINCT FROM/PK키변경. 2회차 행변경 0.
#
# COMMIT-안전(되돌림): commit 모드에서 runts 를 주면 적재 직후·COMMIT 직전에 같은 트랜잭션 안에서
# capture-inserted-keys.sql 을 실행해 "이번 트랜잭션이 새로 INSERT 한 PK 키"만 inserted_keys_<runts>.csv
# 로 캡처한다(xmin 식별). 이 로그가 있어야 undo.sh 가 신규행만 정확히 DELETE 할 수 있다.
# 적재 SQL(00~90) 자체는 일절 변경하지 않는다(멱등성 보존).
#
# 사용:
#   ./apply.sh                     # DRY-RUN(롤백). 적재 시도 후 무조건 ROLLBACK.
#   ./apply.sh dryrun              # 동일(명시).
#   ./apply.sh commit              # 영구 적재(인간 승인 시에만). 본 하네스 자동 실행 금지.
#   ./apply.sh commit <runts>      # 영구 적재 + 신규키 캡처(언두 대비). 예: ./apply.sh commit 20260606T1530
set -euo pipefail

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

MODE="${1:-dryrun}"
RUNTS="${2:-}"
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # 환경변수로만 전달, echo 금지

run_psql() {
  # apply.sql(BEGIN…) → [commit+runts 시 capture-inserted-keys.sql] → 종결문($1)을 같은 세션에 주입.
  # 캡처는 적재 직후·COMMIT 직전에 같은 트랜잭션 안에서 신규행 PK 를 inserted_keys_<runts>.csv 로 떠둔다.
  local terminator="$1"
  local keys_csv="$HERE/inserted_keys_${RUNTS}.csv"
  {
    cat "$HERE/apply.sql"
    if [ "$terminator" = "COMMIT" ] && [ -n "$RUNTS" ]; then
      # 캡처 COPY ... TO STDOUT 의 출력만 keys_csv 로 라우팅(\o 리터럴 경로). \echo 잡음 미포함.
      echo "\\o $keys_csv"
      cat "$HERE/capture-inserted-keys.sql"
      echo "\\o"
    fi
    echo "$terminator;"
  } | \
    psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" \
         -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -f -
}

cd "$HERE"
case "$MODE" in
  dryrun)
    echo "[DRY-RUN] 상품마스터 적재 — 롤백전용. 아무것도 커밋되지 않음."
    run_psql "ROLLBACK"
    echo "[DRY-RUN] 완료 — ROLLBACK. 영구 변경 0."
    ;;
  commit)
    if [ -n "$RUNTS" ]; then
      echo "[COMMIT MODE] 인간 승인 적재 — 영구 INSERT/UPDATE + 신규키 캡처(runts=$RUNTS, 언두 대비)."
    else
      echo "[COMMIT MODE] 인간 승인 적재 — 영구 INSERT/UPDATE. (runts 미지정 → 신규키 캡처 생략, 언두 시 INSERT 되돌림 제한)"
    fi
    run_psql "COMMIT"
    echo "[COMMIT MODE] 완료 — COMMIT."
    ;;
  *)
    echo "ERROR: 알 수 없는 모드 '$MODE' (dryrun|commit)" >&2
    unset PGPASSWORD
    exit 2
    ;;
esac

unset PGPASSWORD
