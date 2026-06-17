#!/usr/bin/env bash
# apply.sh — 아크릴 마무리(A5 보정 + 코롯토) 로더. 기본 = 롤백전용 DRY-RUN. --commit 시에만 실 COMMIT(인간 승인).
# 비밀값 비노출: .env.local RAILWAY_DB_* 사용, 패스워드 stdout 미출력.
set -euo pipefail
cd "$(dirname "$0")"

ROOT="$(cd ../../../.. && pwd)"
ENVFILE="$ROOT/.env.local"
[ -f "$ENVFILE" ] || { echo "FATAL: .env.local not found at $ENVFILE"; exit 1; }
set -a; . "$ENVFILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1)

MODE="${1:-dryrun}"

echo "== 백업 SELECT (변경 대상 사전 스냅샷·undo 근거) =="
# A5 대상: .02 + siz_width NOT NULL + min_qty NULL (보정 전 스냅샷)
"${PSQL[@]}" -At -c "\copy (SELECT cp.comp_price_id,cp.comp_cd,cp.siz_width,cp.siz_height,cp.mat_cd,cp.min_qty,cp.unit_price FROM t_prc_component_prices cp JOIN t_prc_price_components pc ON pc.comp_cd=cp.comp_cd WHERE pc.prc_typ_cd='PRICE_TYPE.02' AND cp.siz_width IS NOT NULL AND cp.min_qty IS NULL) TO 'backup_a5_minqty_pre.csv' WITH CSV HEADER"
# 코롯토 신설 전 존재 스냅샷(원복 시 신규 식별)
"${PSQL[@]}" -At -c "\copy (SELECT comp_cd FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_COROTTO') TO 'backup_korotto_comp_pre.csv' WITH CSV HEADER"
"${PSQL[@]}" -At -c "\copy (SELECT frm_cd FROM t_prc_price_formulas WHERE frm_cd='PRF_COROTTO_ACRYL') TO 'backup_korotto_formula_pre.csv' WITH CSV HEADER"
echo "  → backup_*_pre.csv 저장"

if [ "$MODE" = "--commit" ]; then
  echo "== !! COMMIT 모드 (인간 승인 가정) — ROLLBACK→COMMIT 치환 실행 =="
  sed 's/^ROLLBACK;/COMMIT;/' apply.sql | "${PSQL[@]}" -f -
else
  echo "== DRY-RUN (롤백전용·라이브 무변경) =="
  "${PSQL[@]}" -f apply.sql
fi
