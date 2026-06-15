#!/usr/bin/env bash
# apply_loader.sh — 전 상품군 가격테이블 note 교정 로더.
# 기본 = DRY-RUN(롤백전용·아무것도 커밋 안 함). commit 은 인간 승인 시에만.
# [HARD] 비밀번호 stdout/로그 미출력. note 컬럼만 변경(가격행 불변). 멱등.
#
# 사용:
#   ./apply_loader.sh            # DRY-RUN (BEGIN; ...; ROLLBACK) — 기본
#   ./apply_loader.sh dryrun     # 동일
#   ./apply_loader.sh commit     # 실제 적재 (BEGIN; ...; COMMIT) — 독립 게이트 GO + 인간 승인 후에만
set -euo pipefail

REPO="$(git rev-parse --show-toplevel)"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -a; source "$REPO/.env.local"; set +a       # RAILWAY_DB_* 로드
export PGPASSWORD="$RAILWAY_DB_PASSWORD"          # stdout 에 절대 echo 금지

MODE="${1:-dryrun}"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -P pager=off)

cd "$DIR"
if [ "$MODE" = "commit" ]; then
  echo "[COMMIT MODE] 인간 승인 적재 — note 컬럼만 변경, 가격행 불변"
  { cat apply.sql; echo "COMMIT;"; } | "${PSQL[@]}" -f -
else
  echo "[DRY-RUN] 롤백전용 — 아무것도 커밋되지 않음"
  { cat apply.sql; echo "ROLLBACK;"; } | "${PSQL[@]}" -f -
fi

unset PGPASSWORD
