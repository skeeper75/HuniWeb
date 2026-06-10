#!/usr/bin/env bash
# =====================================================================
# round-10 델타 DRY-RUN 로더 (롤백 기본). NEVER COMMIT.
# 자격증명은 .env.local 의 RAILWAY_DB_* 에서만 로드 — stdout/SQL 비노출.
# =====================================================================
# 사용:
#   ./apply.sh            # 롤백전용 DRY-RUN (기본·안전)
#   ./apply.sh --commit   # [차단] 인간 승인 게이트. 이 스크립트는 COMMIT을 막는다.
#
# [현황] 본 버전쌍 자동 적용 델타 0건(전부 ESCALATE/GAP). DRY-RUN은 트랜잭션
#   왕복·멱등성(delta 0) 형식 증명용. 실제 변경 적용 없음.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${HERE}/../../../../../.env.local"   # repo 루트 .env.local

if [[ "${1:-}" == "--commit" ]]; then
  echo "[BLOCKED] --commit 은 인간 승인 게이트입니다. 본 트랙은 COMMIT 금지." >&2
  exit 2
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "[ERR] .env.local 미발견: $ENV_FILE" >&2; exit 1
fi
set -a; . "$ENV_FILE"; set +a

# 읽기전용 DRY-RUN: 00_apply.sql 은 자체 ROLLBACK 으로 끝남.
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql \
  -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" \
  -v ON_ERROR_STOP=on -f "${HERE}/00_apply.sql"

echo "[OK] DRY-RUN 완료 (ROLLBACK). 적용 델타 0건 = 멱등 자명. COMMIT 미수행."
