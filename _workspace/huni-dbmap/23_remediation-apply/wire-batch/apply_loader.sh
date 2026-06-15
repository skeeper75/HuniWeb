#!/usr/bin/env bash
# ============================================================
# WIRE 통합 배선 실행본 — 로더 (기본 DRY-RUN·롤백전용)
# 사용: ./apply_loader.sh            → DRY-RUN (BEGIN…ROLLBACK·라이브 무변경)
#       ./apply_loader.sh --commit   → 실 COMMIT (인간 승인 + 엔진 .03/배선 규칙 동시배포 선결)
# [HARD] 비밀번호 stdout/로그/_workspace 미기록. .env.local RAILWAY_DB_*만.
# [HARD] 돈-크리티컬. COMMIT은 dbm-validator R1~R6 GO + 엔진 동시배포 + 인간 승인 후에만.
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"

ROOT="$(git rev-parse --show-toplevel)"
set -a; source "$ROOT/.env.local"; set +a    # RAILWAY_DB_* 로드
export PGPASSWORD="$RAILWAY_DB_PASSWORD"      # echo 금지

MODE="${1:-dryrun}"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

if [ "$MODE" = "--commit" ]; then
  echo "[COMMIT MODE] 인간 승인 배선 적재 — apply.sql 끝에 COMMIT"
  echo "[경고] 엔진 .03/배선 해석 규칙(webadmin Phase11) 동시배포 확인했는가? (배선 단독 적용=미정의 동작 위험)"
  "${PSQL[@]}" -f apply.sql -c "COMMIT;"
else
  echo "[DRY-RUN] 롤백전용 — 아무것도 커밋되지 않음"
  "${PSQL[@]}" -f apply.sql -c "ROLLBACK;"
fi

unset PGPASSWORD
