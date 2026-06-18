#!/usr/bin/env bash
# ============================================================================
# apply_wave2.sh — Wave 2 로더 (READ-ONLY 진단 전용 · 축이동 실행본 없음)
# ----------------------------------------------------------------------------
# [HARD] Wave 2(R8/R9/R7)는 라이브 실측 결과 "라이브 직접 축이동 부적격"으로
#        전건 escalate(_deferred.md). 따라서 본 로더에는 commit 모드가 없다 —
#        실행할 안전한 축이동 SQL이 존재하지 않기 때문. diagnose 모드만 제공.
#        (Wave 1 apply_wave1.sh 구조 재사용하되, 안전 실행본 0이라 commit 제거.)
# [HARD] SELECT만 수행·쓰기 0·BEGIN..ROLLBACK 래핑(방어)·비밀번호 stdout 미노출.
# 사용:
#   ./apply_wave2.sh             # diagnose(라이브 읽기전용 — Wave 2 escalate 근거 재현)
# ============================================================================
set -euo pipefail
cd "$(dirname "$0")"
set -a; source "$(git rev-parse --show-toplevel)/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # stdout echo 금지
psql() { command psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -q "$@"; }
trap 'unset PGPASSWORD' EXIT
MODE="${1:-diagnose}"

case "$MODE" in
  diagnose)
    echo "[DIAGNOSE] Wave 2 안전 판정 근거 재현 (READ-ONLY SELECT). 쓰기 0."
    # 방어적 BEGIN..ROLLBACK — diagnose_wave2.sql은 SELECT 전용이나 트랜잭션으로 감싸 안전 보장.
    psql <<SQL
BEGIN;
\i diagnose_wave2.sql
ROLLBACK;
SQL
    echo "[DIAGNOSE] 완료 — 결론: Wave 2 안전 실행본 0 (전건 escalate). 상세 _deferred.md"
    ;;
  commit)
    echo "[STOP] Wave 2에는 commit 가능한 안전 축이동 실행본이 없습니다."
    echo "       전건 escalate(목적지 행 전무·무손실 소스 부재) → 경로 Y(개발자 v03 재적재)."
    echo "       근거: _deferred.md · 백로그: _backlog-pathY.md"
    exit 1
    ;;
  *)
    echo "usage: $0 [diagnose]"; exit 1 ;;
esac
