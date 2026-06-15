#!/usr/bin/env bash
# round-22 v2 ⑥ 카테고리 고아 페어 정리 — UNDO(복원) 스크립트
# 경로 X(라이브 직접) COMMIT을 되돌린다. 백업 CSV에서 고아 페어 111건 복원 + 고아 노드 use_yn='Y' 복원.
# 사용: bash _workspace/huni-dbmap/32_axis-staged-load/_exec_category/undo.sh
set -euo pipefail
cd /Users/innojini/Dev/HuniWeb
set -a; source .env.local; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
DIR=_workspace/huni-dbmap/32_axis-staged-load/_exec_category
psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -X -v ON_ERROR_STOP=1 <<SQL
BEGIN;
-- 1) 삭제된 고아 부카테고리 페어 111건 복원 (멱등: 이미 있으면 skip)
CREATE TEMP TABLE _restore_pairs (prd_cd text, cat_cd text, main_cat_yn text, disp_seq int, note text, reg_dt timestamptz, upd_dt timestamptz);
\copy _restore_pairs FROM '$DIR/backup_orphan_pairs.csv' CSV HEADER
INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, note, reg_dt, upd_dt)
SELECT s.prd_cd, s.cat_cd, s.main_cat_yn, s.disp_seq, s.note, s.reg_dt, s.upd_dt
FROM _restore_pairs s
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_categories t WHERE t.prd_cd=s.prd_cd AND t.cat_cd=s.cat_cd);
-- 2) 고아 노드 use_yn='Y' 복원 (원래 전부 Y)
UPDATE t_cat_categories SET use_yn='Y', upd_dt=now()
WHERE upr_cat_cd IS NULL AND cat_lvl>=2;
SELECT 'restored_pairs' AS lbl, count(*) FROM t_prd_product_categories r JOIN t_cat_categories c ON r.cat_cd=c.cat_cd WHERE c.upr_cat_cd IS NULL AND c.cat_lvl>=2;
COMMIT;
SQL
echo "UNDO 완료 — 고아 페어/노드 복원됨"
