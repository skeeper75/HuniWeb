#!/usr/bin/env bash
# undo.sh — 상품마스터 적재를 무손실 되돌리는 언두 로더 (round-5, dbm-load-builder)
#
# 실제 COMMIT 후 "잘못됐다"고 판단되면 이 스크립트로 되돌린다.
#   (A) INSERT 언두 = backup/inserted_keys_<runts>.csv 에 로그된 신규 PK 만 DELETE(선존행 불가침).
#   (B) UPDATE-set 언두 = backup_<runts>/before_*.csv before-image 로 복원.
#
# 기본 = DRY-RUN(ROLLBACK) — 언두 시도 후 무조건 롤백(영구 변경 0). 실제 언두는 '--commit'.
#
# 안전:
#  - 자격증명은 .env.local 에서만 로드. 비밀번호 echo/로그 금지.
#  - undo-after-load.sql 은 BEGIN 만 포함, COMMIT/ROLLBACK 은 본 스크립트가 모드에 따라 주입(단일 트랜잭션).
#  - ON_ERROR_STOP=1: 임의 문 실패 시 전체 롤백.
#
# 사용:
#   ./undo.sh <runts>            # DRY-RUN(롤백). 언두 시도 후 무조건 ROLLBACK.
#   ./undo.sh <runts> dryrun     # 동일(명시).
#   ./undo.sh <runts> commit     # 영구 언두(인간 승인 시에만). 본 하네스 자동 실행 금지.
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "ERROR: runts 인자 필요 (예: ./undo.sh 20260606T1530 [dryrun|commit])" >&2
  exit 2
fi
RUNTS="$1"
MODE="${2:-dryrun}"

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(git -C "$HERE" rev-parse --show-toplevel)"
ENV_FILE="$ROOT/.env.local"
BACKUP="$HERE/backup_${RUNTS}"
KEYS_CSV="$HERE/inserted_keys_${RUNTS}.csv"

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE 없음 (자격증명 필요)" >&2
  exit 1
fi
if [ ! -f "$KEYS_CSV" ]; then
  echo "ERROR: $KEYS_CSV 없음 — apply.sh commit 이 신규키를 캡처하지 않았음(언두 불가)." >&2
  exit 1
fi
if [ ! -d "$BACKUP" ]; then
  echo "ERROR: $BACKUP 없음 — backup-before-load.sh 미실행(before-image 부재, UPDATE 복원 불가)." >&2
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

export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # 환경변수로만 전달, echo 금지

run_undo() {
  # 단일 트랜잭션: BEGIN → 임시테이블(_undo_keys/_bi_products/_bi_materials) 리터럴 경로 적재
  # → undo-after-load.sql(\i) → 종결문. psql v18 \copy 는 :'var' 경로 보간 미지원 → 셸이 리터럴 주입.
  local terminator="$1"
  local bi_products="$BACKUP/before_t_prd_products.csv"
  local bi_materials="$BACKUP/before_t_prd_product_materials_thickness.csv"
  {
    echo "\\set ON_ERROR_STOP on"
    echo "BEGIN;"
    echo "CREATE TEMP TABLE _undo_keys (tbl text, pk_cols text, pk_vals text) ON COMMIT DROP;"
    echo "\\copy _undo_keys FROM '$KEYS_CSV' WITH (FORMAT csv, HEADER true)"
    echo "CREATE TEMP TABLE _bi_products (prd_cd text, qty_unit_typ_cd text, nonspec_yn text, nonspec_width_min numeric, nonspec_width_max numeric, nonspec_height_min numeric, nonspec_height_max numeric) ON COMMIT DROP;"
    echo "\\copy _bi_products FROM '$bi_products' WITH (FORMAT csv, HEADER true)"
    echo "CREATE TEMP TABLE _bi_materials (prd_cd text, mat_cd text, usage_cd text, dep_proc_cd text, dflt_yn text, disp_seq int) ON COMMIT DROP;"
    echo "\\copy _bi_materials FROM '$bi_materials' WITH (FORMAT csv, HEADER true)"
    cat "$HERE/undo-after-load.sql"
    echo "$terminator;"
  } | \
    psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" \
         -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -f -
}

cd "$HERE"
case "$MODE" in
  dryrun)
    echo "[UNDO DRY-RUN] runts=$RUNTS — 롤백전용. 언두 시도 후 무조건 ROLLBACK. 영구 변경 0."
    run_undo "ROLLBACK"
    echo "[UNDO DRY-RUN] 완료 — ROLLBACK. 언두 검증만 수행(실제 복원 안 함)."
    ;;
  commit)
    echo "[UNDO COMMIT] runts=$RUNTS — 영구 언두(인간 승인 시에만). 적재를 되돌린다."
    run_undo "COMMIT"
    echo "[UNDO COMMIT] 완료 — COMMIT. 적재가 before-image 로 복원됨."
    ;;
  *)
    echo "ERROR: 알 수 없는 모드 '$MODE' (dryrun|commit)" >&2
    unset PGPASSWORD
    exit 2
    ;;
esac

unset PGPASSWORD
