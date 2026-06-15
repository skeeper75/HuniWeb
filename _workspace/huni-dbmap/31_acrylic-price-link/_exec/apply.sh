#!/usr/bin/env bash
# apply.sh — 아크릴 가격사슬 적재 로더 (psql). 기본 DRY-RUN(ROLLBACK).
# 권위: dbm-load-execution sql-idempotent-patterns §7. NEVER COMMIT(범위 확정).
#   ./apply.sh           → DRY-RUN (BEGIN…ROLLBACK·기본)
#   ./apply.sh dryrun2   → 멱등성 R1: 같은 트랜잭션 안 apply.sql 2회 후 ROLLBACK
#   ./apply.sh commit    → 차단됨(이 트랙은 COMMIT 금지·인간 별도 승인 필요)
set -euo pipefail
cd "$(dirname "$0")"
set -a; source "$(git rev-parse --show-toplevel)/.env.local"; set +a   # RAILWAY_DB_*
export PGPASSWORD="$RAILWAY_DB_PASSWORD"                                 # stdout echo 금지
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

MODE="${1:-dryrun}"
case "$MODE" in
  dryrun)
    echo "[DRY-RUN] 롤백전용 — 아무것도 커밋되지 않음"
    "${PSQL[@]}" -f apply.sql -c "ROLLBACK;"
    ;;
  dryrun2)
    echo "[DRY-RUN x2] 멱등성 검증 — 2회 적용 후 ROLLBACK"
    "${PSQL[@]}" <<'SQL'
\set ON_ERROR_STOP on
BEGIN;
  \i 01_prc_price_formulas.sql
  \i 02_prc_price_components.sql
  \i 03_prc_formula_components.sql
  \i 04_prd_product_price_formulas.sql
  CREATE TEMP TABLE _snap AS
    SELECT 't_prc_price_formulas' t, count(*) c FROM t_prc_price_formulas
    UNION ALL SELECT 't_prc_price_components', count(*) FROM t_prc_price_components
    UNION ALL SELECT 't_prc_formula_components', count(*) FROM t_prc_formula_components
    UNION ALL SELECT 't_prd_product_price_formulas', count(*) FROM t_prd_product_price_formulas;
  -- 2회차 재적재
  \i 01_prc_price_formulas.sql
  \i 02_prc_price_components.sql
  \i 03_prc_formula_components.sql
  \i 04_prd_product_price_formulas.sql
  SELECT s.t, s.c AS after1,
    CASE s.t
      WHEN 't_prc_price_formulas'        THEN (SELECT count(*) FROM t_prc_price_formulas)
      WHEN 't_prc_price_components'       THEN (SELECT count(*) FROM t_prc_price_components)
      WHEN 't_prc_formula_components'     THEN (SELECT count(*) FROM t_prc_formula_components)
      WHEN 't_prd_product_price_formulas' THEN (SELECT count(*) FROM t_prd_product_price_formulas)
    END AS after2
  FROM _snap s ORDER BY s.t;
ROLLBACK;
SQL
    ;;
  commit)
    echo "[BLOCKED] 이 트랙은 COMMIT 금지(범위 확정·DRY-RUN까지만). 인간 별도 승인 필요." >&2
    exit 1
    ;;
  *)
    echo "usage: ./apply.sh [dryrun|dryrun2]" >&2; exit 1 ;;
esac
unset PGPASSWORD
