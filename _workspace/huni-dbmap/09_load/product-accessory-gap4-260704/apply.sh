#!/usr/bin/env bash
# 상품악세사리 GAP-4 (24 신규 템플릿+가격). ./apply.sh | ./apply.sh commit
set -euo pipefail
ENV_FILE="/Users/innojini/Dev/HuniWeb/.env.local"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; BACKUP_DIR="$HERE/backup"
set -a; source "$ENV_FILE"; set +a; export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL=(psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1 -X)
MODE="${1:-dryrun}"; mkdir -p "$BACKUP_DIR"
"${PSQL[@]}" -At -F, -c "\copy (SELECT tmpl_cd,base_prd_cd,tmpl_nm,use_yn,del_yn FROM t_prd_templates WHERE base_prd_cd IN ('PRD_000001','PRD_000002','PRD_000010','PRD_000011','PRD_000014') ORDER BY tmpl_cd) TO '$BACKUP_DIR/pre_templates.csv' CSV HEADER"
echo "[backup] $BACKUP_DIR/pre_templates.csv"
if [[ "$MODE" == "commit" ]]; then echo "[COMMIT]"; sed 's/^ROLLBACK;/COMMIT;/' "$HERE/apply.sql" | "${PSQL[@]}" -f -
else echo "[DRY-RUN]"; "${PSQL[@]}" -f "$HERE/apply.sql"; fi
