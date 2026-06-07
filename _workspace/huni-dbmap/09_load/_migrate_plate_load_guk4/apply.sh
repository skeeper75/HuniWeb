#!/usr/bin/env bash
# =====================================================================
# apply.sh — 국4절(316x467) 32상품 plate 적재 실행기
#   라운드: 국4절 316x467 32상품 plate 적재 (사용자 확정 2026-06-07)
#
#   기본 동작: DRY-RUN (apply.sql 실행 후 강제 ROLLBACK). DB 무변경.
#   실제 반영은 --commit (인간 승인) 일 때만 — 본 하네스는 자동 COMMIT 금지.
#   자격증명: .env.local (RAILWAY_DB_*). 비밀번호는 절대 출력하지 않는다.
#
#   적용 내용 (단일 트랜잭션):
#     01 plate 교정: 31상품 작업사이즈 plate DELETE 101 → SIZ_000499 INSERT 31
#                    (PRD_000016 SIZ_000499 1행 KEEP — DELETE 대상 외)
#     02 작업사이즈 ORPHAN 53 soft-delete (NOT EXISTS 3중 가드)
#   신규 siz 0 (316x467=SIZ_000499 재사용). 가격(component_prices) 미터치.
#
#   사용:
#     ./apply.sh            # DRY-RUN (롤백). 적용 시도 후 무조건 ROLLBACK. DB 무변경.
#     ./apply.sh --commit   # 실제 COMMIT (인간 승인). 사전 ./backup.sh 권장.
#
#   HARD: --commit 전 backup.sh 로 before-state(102 plate 행 + 53 siz del_yn) 백업 권장.
#         라이브 DRY-RUN(쓰기 트랜잭션이지만 롤백)은 lead 승인 사항.
# =====================================================================
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
MODE="dryrun"
[[ "${1:-}" == "--commit" ]] && MODE="commit"

if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: .env.local 없음: $ENV_FILE" >&2; exit 1; fi
# shellcheck disable=SC1090
set -a; source "$ENV_FILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # stdout 에 절대 출력하지 않음

PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -X -v ON_ERROR_STOP=1)

cd "$HERE"
if [[ "$MODE" == "commit" ]]; then
  echo "============================================================"
  echo "[apply] !!! COMMIT 모드 — 라이브 반영: plate DELETE 101/INSERT 31 + siz soft-delete 53 !!!"
  echo "[apply] 인간 승인 확인 필수. 사전 ./backup.sh 권장."
  echo "============================================================"
  # apply.sql 자체가 BEGIN…COMMIT 포함 → 그대로 실행
  "${PSQL[@]}" -f "$HERE/apply.sql"
  echo "[apply] COMMIT 완료. plate 102→32(KEEP1+신규31)·작업사이즈 53 soft-delete. 이상 시 ./undo.sh --commit."
else
  echo "[apply] DRY-RUN — apply.sql 실행 후 강제 ROLLBACK (DB 무변경)."
  # apply.sql 의 마지막 COMMIT; 을 ROLLBACK; 으로 치환 (단일 COMMIT 라인 가정).
  TMP="$(mktemp -t plate_guk4_dryrun.XXXXXX.sql)"
  trap 'rm -f "$TMP"' EXIT
  sed 's/^COMMIT;$/ROLLBACK;  -- DRY-RUN: 강제 롤백/' "$HERE/apply.sql" > "$TMP"
  # \i 는 CWD 기준 상대경로 → HERE 에서 실행하므로 01/02 정상 로드
  "${PSQL[@]}" -f "$TMP"
  echo "[apply] DRY-RUN 완료 — ROLLBACK 됨. DB 무변경. 실제 반영은 ./apply.sh --commit (인간 승인)."
fi
unset PGPASSWORD
