#!/usr/bin/env bash
# =====================================================================
# apply.sh — 디지털인쇄 가격엔진 적재 실행기 (round-5, 147행)
#   라운드: 디지털인쇄 원자합산형 가격엔진 GO 적재본 (검증 GO, gate §0)
#
#   기본 동작: DRY-RUN (apply.sql 실행 후 강제 ROLLBACK). DB 무변경.
#   실제 반영은 --commit (인간 승인) 일 때만 — 본 하네스는 자동 COMMIT 금지.
#   자격증명: .env.local (RAILWAY_DB_*). 비밀번호는 절대 출력하지 않는다.
#
#   적용 내용 (단일 트랜잭션, FK 위상정렬 01→05):
#     01 t_prc_price_formulas          6   (신규 mint frm_cd PRF_DGP_A~F)
#     02 t_prc_price_components        1   (신규 mint comp_cd COMP_PAPER)
#     03 t_prc_formula_components     72   (공식↔구성요소 배선)
#     04 t_prc_component_prices       49   (용지비 단가)
#     05 t_prd_product_price_formulas 19   (상품↔공식 바인딩)
#   합계 147행. 신규 siz/mat/DDL 0. 멱등(재실행 행변경 0).
#
#   사용:
#     ./apply.sh            # DRY-RUN (롤백). 적용 시도 후 무조건 ROLLBACK. DB 무변경.
#     ./apply.sh --commit   # 실제 COMMIT (인간 승인). 사전 ./backup.sh 권장.
#
#   HARD: --commit 전 ./backup.sh 로 before-state(신규키 부재 + 영향테이블 현행수) 백업 권장.
#         라이브 DRY-RUN(쓰기 트랜잭션이지만 롤백)은 lead 승인 사항. 멱등성은 ./apply.sh 2회로 실증.
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
  echo "[apply] !!! COMMIT 모드 — 라이브 반영: 디지털인쇄 가격엔진 147행 INSERT !!!"
  echo "[apply]     formulas 6 + components 1 + formula_components 72 + component_prices 49 + bindings 19"
  echo "[apply] 인간 승인 확인 필수. 사전 ./backup.sh 권장."
  echo "============================================================"
  # apply.sql 자체가 BEGIN…COMMIT 포함 → 그대로 실행
  "${PSQL[@]}" -f "$HERE/apply.sql"
  echo "[apply] COMMIT 완료. 디지털인쇄 가격엔진 147행 적재. 이상 시 ./undo.sh --commit."
else
  echo "[apply] DRY-RUN — apply.sql 실행 후 강제 ROLLBACK (DB 무변경)."
  # apply.sql 의 마지막 COMMIT; 을 ROLLBACK; 으로 치환 (단일 COMMIT 라인 가정).
  TMP="$(mktemp -t dgp_dryrun.XXXXXX.sql)"
  trap 'rm -f "$TMP"' EXIT
  sed 's/^COMMIT;$/ROLLBACK;  -- DRY-RUN: 강제 롤백/' "$HERE/apply.sql" > "$TMP"
  # \i 는 CWD 기준 상대경로 → HERE 에서 실행하므로 01~05 정상 로드
  "${PSQL[@]}" -f "$TMP"
  echo "[apply] DRY-RUN 완료 — ROLLBACK 됨. DB 무변경. 실제 반영은 ./apply.sh --commit (인간 승인)."
fi
unset PGPASSWORD
