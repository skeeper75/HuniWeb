#!/usr/bin/env bash
# =====================================================================
# apply.sh — 면적매트릭스 좌표 siz 등록 + 면적 component_prices 마이그레이션 실행기
#   기본 동작: DRY-RUN (migrate.sql 실행 후 ROLLBACK). DB 무변경.
#   실제 반영은 --commit (인간 승인) 일 때만 — 본 하네스는 자동 COMMIT 금지.
#   자격증명: .env.local. 비밀번호는 절대 출력하지 않는다.
#
#   사용:
#     ./apply.sh            # DRY-RUN (롤백). 211 siz + 907 prices INSERT 시도 후 무조건 ROLLBACK.
#     ./apply.sh --commit   # 실제 COMMIT (인간 승인 — 후니 master-data 211 siz 등록 결정 포함)
#
#   HARD: 211 신규 siz 등록은 후니 master-data 등록 결정 대상. --commit 전 backup.sh 권장.
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

cd "$HERE"
if [[ "$MODE" == "commit" ]]; then
  echo "============================================================"
  echo "[apply] !!! COMMIT 모드 — 라이브에 211 신규 siz + 907 면적 단가를 반영합니다 !!!"
  echo "[apply] 후니 master-data 등록 결정(211 siz) 승인 확인 필수. 사전 backup.sh 권장."
  echo "============================================================"
  # migrate.sql 자체가 BEGIN…COMMIT 포함 → 그대로 실행
  "${PSQL[@]}" -f "$HERE/migrate.sql"
  echo "[apply] COMMIT 완료. 면적 13+아크릴 가격 룩업 확인 후 이상 시 undo.sh --commit."
else
  echo "[apply] DRY-RUN — migrate.sql 실행 후 강제 ROLLBACK (DB 무변경)."
  # migrate.sql 의 끝 COMMIT; 만 ROLLBACK; 으로 치환 (멱등: 단일 COMMIT 라인 가정).
  TMP="$(mktemp -t migrate_area_dryrun.XXXXXX.sql)"
  trap 'rm -f "$TMP"' EXIT
  sed 's/^COMMIT;$/ROLLBACK;  -- DRY-RUN: 강제 롤백/' "$HERE/migrate.sql" > "$TMP"
  # \i 는 CWD 기준 상대경로 → HERE 에서 실행하므로 01/02 정상 로드
  "${PSQL[@]}" -f "$TMP"
  echo "[apply] DRY-RUN 완료 — ROLLBACK 됨. DB 무변경. 실제 반영은 ./apply.sh --commit (인간 승인)."
fi
unset PGPASSWORD
