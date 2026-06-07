#!/usr/bin/env bash
# =====================================================================
# backup.sh — 국4절 plate 적재 before-state 백업 (read-only)
#   --commit 전 안전망: 32상품 plate 102행 + 53 ORPHAN siz del_yn 상태를
#   타임스탬프 SQL 로 덤프해 롤백(undo) 자료로 보존. DB 무변경(SELECT만).
#   비밀번호 미출력. 자격증명 .env.local.
#
#   사용: ./backup.sh   →  backup_state_<ts>.sql 생성
# =====================================================================
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
if [[ ! -f "$ENV_FILE" ]]; then echo "ERROR: .env.local 없음: $ENV_FILE" >&2; exit 1; fi
set -a; source "$ENV_FILE"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -X -v ON_ERROR_STOP=1 -At)

TS="$(date +%Y%m%d_%H%M%S)"
OUT="$HERE/backup_state_${TS}.sql"
GUK4="'PRD_000016','PRD_000017','PRD_000018','PRD_000020','PRD_000021','PRD_000022','PRD_000023','PRD_000024','PRD_000026','PRD_000027','PRD_000028','PRD_000029','PRD_000031','PRD_000032','PRD_000033','PRD_000034','PRD_000035','PRD_000036','PRD_000038','PRD_000040','PRD_000041','PRD_000042','PRD_000043','PRD_000044','PRD_000045','PRD_000046','PRD_000047','PRD_000048','PRD_000108','PRD_000109','PRD_000110','PRD_000111'"

{
  echo "-- before-state backup ${TS} (국4절 plate 적재). read-only 덤프. 롤백용 재INSERT/UPDATE 문."
  echo "-- 1) 32상품 plate 행 재INSERT (롤백 시 사용)"
  "${PSQL[@]}" -c "SELECT 'INSERT INTO t_prd_product_plate_sizes (prd_cd,siz_cd,dflt_plt_yn,output_paper_typ_cd,del_yn) VALUES ('''||prd_cd||''','''||siz_cd||''','''||dflt_plt_yn||''','||COALESCE(''''||output_paper_typ_cd||'''','NULL')||','''||del_yn||''') ON CONFLICT (prd_cd,siz_cd) DO NOTHING;' FROM t_prd_product_plate_sizes WHERE prd_cd IN (${GUK4}) ORDER BY prd_cd,siz_cd;"
  echo "-- 2) 53 ORPHAN siz del_yn 복원 (롤백 시 del_yn='N')"
  echo "UPDATE t_siz_sizes SET del_yn='N', del_dt=NULL WHERE siz_cd IN ('SIZ_000023','SIZ_000024','SIZ_000112','SIZ_000116','SIZ_000117','SIZ_000121','SIZ_000122','SIZ_000123','SIZ_000125','SIZ_000128','SIZ_000130','SIZ_000131','SIZ_000134','SIZ_000136','SIZ_000138','SIZ_000140','SIZ_000141','SIZ_000145','SIZ_000146','SIZ_000149','SIZ_000150','SIZ_000151','SIZ_000152','SIZ_000153','SIZ_000154','SIZ_000155','SIZ_000156','SIZ_000158','SIZ_000159','SIZ_000160','SIZ_000161','SIZ_000162','SIZ_000163','SIZ_000164','SIZ_000165','SIZ_000166','SIZ_000167','SIZ_000168','SIZ_000169','SIZ_000177','SIZ_000178','SIZ_000182','SIZ_000184','SIZ_000282','SIZ_000283','SIZ_000284','SIZ_000285','SIZ_000286','SIZ_000287','SIZ_000288','SIZ_000289','SIZ_000290','SIZ_000291');"
} > "$OUT"
unset PGPASSWORD
echo "[backup] before-state 덤프: $OUT"
