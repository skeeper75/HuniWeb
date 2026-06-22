#!/usr/bin/env bash
# apply.sh — 019 바인딩 로더 (기본 ROLLBACK DRY-RUN · --commit 는 인간 승인 게이트)
# [HARD] 기본은 롤백전용 DRY-RUN. 실 COMMIT 은 사용자 최종 승인 후 `./apply.sh --commit` 만.
# 비밀값 비노출: PGPASSWORD 환경변수로만 전달·stdout 미출력.
set -euo pipefail

ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
HERE="$(cd "$(dirname "$0")" && pwd)"
set -a; source "$ROOT/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"

MODE="rollback"
[[ "${1:-}" == "--commit" ]] && MODE="commit"

TERMINATOR="ROLLBACK;"
[[ "$MODE" == "commit" ]] && TERMINATOR="COMMIT;"

echo "[apply.sh] mode=$MODE (rollback=DRY-RUN, commit=REAL LOAD·human-approved only)"

psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" \
     -v ON_ERROR_STOP=1 -q -P pager=off <<SQL
BEGIN;
\i $HERE/apply.sql
\echo '-- verify: 019 output plate corrected (SIZ_000499) + formula bound (PRF_DGP_A) --'
SELECT siz_cd, output_paper_typ_cd FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000019' AND output_paper_typ_cd='OUTPUT_PAPER_TYPE.01';
SELECT prd_cd, frm_cd, apply_bgn_ymd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000019';
$TERMINATOR
SQL

unset PGPASSWORD
echo "[apply.sh] done (mode=$MODE)"
