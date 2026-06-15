#!/usr/bin/env bash
# =====================================================================
# apply_batch.sh — 동형 클래스 배치 적재 로더 (dbm-batch-load)
#   기본 = DRY-RUN(BEGIN…ROLLBACK·멱등 2-pass). COMMIT 은 commit 인자로만.
#   백업은 위험 변경 시만(--backup). 일상 멱등 UPSERT 는 git baseline CSV 로 충분.
#   .env.local 의 RAILWAY_DB_* 사용. 비밀번호 stdout/_workspace 기록 금지.
#
# 사용법:
#   ./apply_batch.sh <batch_dir>                DRY-RUN 1-pass (BEGIN…ROLLBACK, 신규 N·검증)
#   ./apply_batch.sh <batch_dir> idempotent     DRY-RUN 2-pass (재실행 delta 0 멱등 실증)
#   ./apply_batch.sh <batch_dir> baseline       git-tracked 읽기전용 baseline CSV 덤프(경량 안전망)
#   ./apply_batch.sh <batch_dir> commit         실 COMMIT (집계 GO + 인간 승인 후)
#   ./apply_batch.sh <batch_dir> commit --backup  위험 변경 시: DB 내부 백업 후 COMMIT
#
# batch_dir 규약: batch_<class>.sql(멱등 UPSERT) · verify.sql(집계) · tables.txt(영향 테이블) 존재
# =====================================================================
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
set -a; source "$ROOT/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 --no-psqlrc)

BATCH_DIR="${1:?batch_dir 필요}"; MODE="${2:-dryrun}"; OPT="${3:-}"
cd "$BATCH_DIR"
SQL="$(ls batch_*.sql | head -1)"
VERIFY="verify.sql"

case "$MODE" in
  baseline)
    # 경량 안전망: 영향 테이블 읽기전용 CSV 덤프(git 추적). 백업 아님 — 되돌림 참조용.
    while read -r tbl; do
      [ -z "$tbl" ] && continue
      "${PSQL[@]}" -c "\copy (SELECT * FROM $tbl) TO 'baseline_${tbl}.csv' CSV HEADER"
      echo "[baseline] $tbl → baseline_${tbl}.csv"
    done < tables.txt
    ;;
  dryrun)
    echo "[DRY-RUN 1-pass] BEGIN → $SQL → 집계 → ROLLBACK"
    "${PSQL[@]}" -c "BEGIN;" -f "$SQL" -f "$VERIFY" -c "ROLLBACK;"
    ;;
  idempotent)
    echo "[DRY-RUN 2-pass 멱등] BEGIN → $SQL → $SQL(재실행 delta 0) → ROLLBACK"
    "${PSQL[@]}" -c "BEGIN;" \
      -c "\echo == PASS 1 ==" -f "$SQL" \
      -c "\echo == PASS 2 (delta 0 기대) ==" -f "$SQL" \
      -f "$VERIFY" -c "ROLLBACK;"
    ;;
  commit)
    if [ "$OPT" = "--backup" ]; then
      # 위험 변경 시만: DB 내부 스냅샷. 일상 UPSERT 는 호출하지 말 것.
      TS=$(git rev-parse --short HEAD)
      while read -r tbl; do
        [ -z "$tbl" ] && continue
        "${PSQL[@]}" -c "CREATE TABLE bak_${tbl}_${TS} AS SELECT * FROM $tbl;"
        echo "[BACKUP] bak_${tbl}_${TS}"
      done < tables.txt
    fi
    echo "[COMMIT] 집계 GO + 인간 승인 적재 — $SQL → COMMIT → 재검증"
    "${PSQL[@]}" -c "BEGIN;" -f "$SQL" -c "COMMIT;" -f "$VERIFY"
    ;;
  *) echo "unknown mode: $MODE" >&2; exit 1 ;;
esac
