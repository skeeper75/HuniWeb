#!/usr/bin/env bash
# =====================================================================
# apply.sh — 고정가형 정정 마이그레이션 실행기
#   기본 동작: DRY-RUN (migrate.sql 실행 후 ROLLBACK). COMMITTED 프로덕션
#   데이터를 건드리므로 실제 반영은 --commit (인간 승인) 일 때만.
#   자격증명: .env.local. 비밀번호는 절대 출력하지 않는다.
#
#   사용:
#     ./apply.sh            # DRY-RUN (롤백). 영향 카운트만 출력.
#     ./apply.sh --commit   # 실제 COMMIT (인간 승인 — 본 하네스는 절대 자동 실행 금지)
# =====================================================================
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
MODE="dryrun"
[[ "${1:-}" == "--commit" ]] && MODE="commit"

if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: .env.local 없음: $ENV_FILE" >&2; exit 1; fi
# shellcheck disable=SC1090
source "$ENV_FILE"
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # 출력하지 않음

PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -X -v ON_ERROR_STOP=1)

if [[ "$MODE" == "commit" ]]; then
  echo "============================================================"
  echo "[apply] !!! COMMIT 모드 — COMMITTED 프로덕션 데이터를 정정합니다 !!!"
  echo "[apply] 사전 backup.sh 실행을 강력 권장합니다."
  echo "============================================================"
  # migrate.sql 자체가 BEGIN…COMMIT 포함 → 그대로 실행
  "${PSQL[@]}" -f "$HERE/migrate.sql"
  echo "[apply] COMMIT 완료. 뷰어에서 15상품 가격 확인 후 이상 시 undo.sh --commit."
else
  echo "[apply] DRY-RUN — migrate.sql 실행 후 강제 ROLLBACK (DB 무변경)."
  # migrate.sql 의 끝 COMMIT 를 ROLLBACK 으로 무력화: 바깥 트랜잭션 래핑 불가
  # (migrate.sql 내부에 BEGIN/COMMIT 존재). 따라서 임시 변형본을 만들어 COMMIT→ROLLBACK 치환.
  TMP="$(mktemp -t migrate_dryrun.XXXXXX.sql)"
  trap 'rm -f "$TMP"' EXIT
  # 마지막 COMMIT; 만 ROLLBACK; 으로 치환 (멱등: 단일 COMMIT 라인 가정)
  sed 's/^COMMIT;$/ROLLBACK;  -- DRY-RUN: 강제 롤백/' "$HERE/migrate.sql" > "$TMP"
  "${PSQL[@]}" -f "$TMP"
  echo "[apply] DRY-RUN 완료 — ROLLBACK 됨. DB 무변경. 실제 반영은 ./apply.sh --commit (인간 승인)."
fi
unset PGPASSWORD
