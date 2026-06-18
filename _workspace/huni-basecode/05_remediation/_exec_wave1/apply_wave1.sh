#!/usr/bin/env bash
# ============================================================================
# apply_wave1.sh — 후니 기초코드 거버넌스 Wave 1 로더 (기본 DRY-RUN 롤백전용)
# ----------------------------------------------------------------------------
# [HARD] 기본 모드 = dryrun(BEGIN…ROLLBACK·아무것도 커밋 안 됨).
#        실 COMMIT은 'commit' 인자 + 인간 승인하에만. 비밀번호 stdout 미노출.
# 사용:
#   ./apply_wave1.sh              # DRY-RUN(롤백전용·기본·영향행수+멱등 보고)
#   ./apply_wave1.sh idempotent   # DRY-RUN 2-pass 멱등 증명(2회차 델타 0)
#   ./apply_wave1.sh backup       # 현재 상태 backup_*.csv 스냅샷(read-only)
#   ./apply_wave1.sh commit       # 실 COMMIT (인간 최종 승인 시에만)
# ============================================================================
set -euo pipefail
cd "$(dirname "$0")"
set -a; source "$(git rev-parse --show-toplevel)/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"   # stdout echo 금지
PSQL="psql -h $RAILWAY_DB_HOST -p $RAILWAY_DB_PORT -U $RAILWAY_DB_USER -d $RAILWAY_DB_NAME -v ON_ERROR_STOP=1 -q"
MODE="${1:-dryrun}"
trap 'unset PGPASSWORD' EXIT

case "$MODE" in
  backup)
    echo "[BACKUP] 현재 상태 read-only 스냅샷 → backup_*.csv"
    $PSQL -f backup_wave1.sql
    echo "[BACKUP] 완료"
    ;;

  dryrun)
    echo "[DRY-RUN] 롤백전용 — 아무것도 커밋되지 않음. 항목별 영향 행수 보고."
    $PSQL <<'SQL'
BEGIN;
  CREATE TEMP TABLE _affected (item text, n int);
  -- R1
  WITH u AS (UPDATE t_siz_sizes SET siz_nm='165x115mm(10장)', upd_dt=now()
             WHERE siz_cd IN ('SIZ_000104','SIZ_000105') AND del_yn='N'
               AND siz_nm IS DISTINCT FROM '165x115mm(10장)' RETURNING 1)
  INSERT INTO _affected SELECT 'R1_siz_정규화', count(*) FROM u;
  -- R2
  WITH u AS (UPDATE t_cat_categories SET del_yn='Y', del_dt=now(), upd_dt=now()
             WHERE cat_cd IN ('CAT_000294','CAT_000293','CAT_000295','CAT_000296','CAT_000298','CAT_000299','CAT_000300','CAT_000301','CAT_000303','CAT_000305','CAT_000306')
               AND del_yn='N' RETURNING 1)
  INSERT INTO _affected SELECT 'R2_cat_소프트삭제', count(*) FROM u;
  -- R3
  WITH u AS (UPDATE t_cat_categories SET upr_cat_cd='CAT_000134', upd_dt=now()
             WHERE cat_cd='CAT_000302' AND del_yn='N' AND upr_cat_cd IS DISTINCT FROM 'CAT_000134' RETURNING 1)
  INSERT INTO _affected SELECT 'R3_cat_재연결_302', count(*) FROM u;
  WITH u AS (UPDATE t_cat_categories SET upr_cat_cd='CAT_000198', upd_dt=now()
             WHERE cat_cd='CAT_000304' AND del_yn='N' AND upr_cat_cd IS DISTINCT FROM 'CAT_000198' RETURNING 1)
  INSERT INTO _affected SELECT 'R3_cat_재연결_304', count(*) FROM u;
  -- R4
  WITH u AS (UPDATE t_proc_processes SET del_yn='Y', del_dt=now(), upd_dt=now()
             WHERE proc_cd='PROC_000025' AND del_yn='N' RETURNING 1)
  INSERT INTO _affected SELECT 'R4_proc_소프트삭제', count(*) FROM u;
  -- R5
  WITH u AS (UPDATE t_mat_materials SET mat_typ_cd='MAT_TYPE.07', upd_dt=now()
             WHERE mat_cd IN ('MAT_000210','MAT_000212','MAT_000213','MAT_000215','MAT_000216','MAT_000217','MAT_000219','MAT_000220','MAT_000221','MAT_000222','MAT_000224','MAT_000226','MAT_000227','MAT_000228','MAT_000230','MAT_000231')
               AND mat_typ_cd='MAT_TYPE.10' AND del_yn='N' RETURNING 1)
  INSERT INTO _affected SELECT 'R5_mat_typ교정', count(*) FROM u;
  -- R6 봉투
  WITH u AS (UPDATE t_mat_materials SET del_yn='Y', del_dt=now(), upd_dt=now()
             WHERE mat_cd IN ('MAT_000197','MAT_000198','MAT_000199','MAT_000200','MAT_000201')
               AND mat_typ_cd='MAT_TYPE.10' AND del_yn='N' RETURNING 1)
  INSERT INTO _affected SELECT 'R6_봉투_정리', count(*) FROM u;
  -- R6 헤더(잔여 N만)
  WITH u AS (UPDATE t_mat_materials SET del_yn='Y', del_dt=now(), upd_dt=now()
             WHERE mat_cd IN ('MAT_000211','MAT_000218','MAT_000223','MAT_000225','MAT_000229','MAT_000233')
               AND mat_typ_cd='MAT_TYPE.10' AND del_yn='N' RETURNING 1)
  INSERT INTO _affected SELECT 'R6_헤더_정리(잔여N)', count(*) FROM u;

  \echo '--- 항목별 영향 행수 (1-pass) ---'
  SELECT item, n FROM _affected ORDER BY item;

  \echo '--- 제약위반 어서션 (전부 0이어야 PASS) ---'
  -- R3 재연결 부모 FK 고아 (upr_cat_cd 가 실재하는지)
  SELECT 'FK_orphan_R3' AS chk, count(*) AS violations
    FROM t_cat_categories c WHERE c.cat_cd IN ('CAT_000302','CAT_000304')
     AND c.upr_cat_cd IS NOT NULL
     AND NOT EXISTS (SELECT 1 FROM t_cat_categories p WHERE p.cat_cd=c.upr_cat_cd);
  -- R5 FK: mat_typ_cd .07 base_code 실재
  SELECT 'FK_mattyp07' AS chk, count(*) AS violations
    FROM t_mat_materials m WHERE m.mat_typ_cd='MAT_TYPE.07'
     AND NOT EXISTS (SELECT 1 FROM t_cod_base_codes b WHERE b.cod_cd='MAT_TYPE.07');
  -- 소프트삭제 대상 중 상품 링크 잔존(R2 cat·R6 mat) — 0이어야 안전
  SELECT 'R2_cat_link' AS chk, count(*) AS violations
    FROM t_prd_product_categories WHERE cat_cd IN ('CAT_000294','CAT_000293','CAT_000295','CAT_000296','CAT_000298','CAT_000299','CAT_000300','CAT_000301','CAT_000303','CAT_000305','CAT_000306');
  SELECT 'R6_env_bomlink' AS chk, count(*) AS violations
    FROM t_prd_product_materials WHERE mat_cd IN ('MAT_000197','MAT_000198','MAT_000199','MAT_000200','MAT_000201');
ROLLBACK;
\echo '[DRY-RUN] ROLLBACK 완료 — 커밋 0'
SQL
    ;;

  idempotent)
    echo "[IDEMPOTENT] DRY-RUN 2-pass 멱등 증명 — 2회차 영향 행수 0이어야 PASS"
    $PSQL <<'SQL'
BEGIN;
  CREATE TEMP TABLE _pass (pass int, item text, n int);
  -- ===== PASS 1 =====
  WITH u AS (UPDATE t_siz_sizes SET siz_nm='165x115mm(10장)', upd_dt=now() WHERE siz_cd IN ('SIZ_000104','SIZ_000105') AND del_yn='N' AND siz_nm IS DISTINCT FROM '165x115mm(10장)' RETURNING 1) INSERT INTO _pass SELECT 1,'R1',count(*) FROM u;
  WITH u AS (UPDATE t_cat_categories SET del_yn='Y', del_dt=now(), upd_dt=now() WHERE cat_cd IN ('CAT_000294','CAT_000293','CAT_000295','CAT_000296','CAT_000298','CAT_000299','CAT_000300','CAT_000301','CAT_000303','CAT_000305','CAT_000306') AND del_yn='N' RETURNING 1) INSERT INTO _pass SELECT 1,'R2',count(*) FROM u;
  WITH u AS (UPDATE t_cat_categories SET upr_cat_cd='CAT_000134', upd_dt=now() WHERE cat_cd='CAT_000302' AND del_yn='N' AND upr_cat_cd IS DISTINCT FROM 'CAT_000134' RETURNING 1) INSERT INTO _pass SELECT 1,'R3a',count(*) FROM u;
  WITH u AS (UPDATE t_cat_categories SET upr_cat_cd='CAT_000198', upd_dt=now() WHERE cat_cd='CAT_000304' AND del_yn='N' AND upr_cat_cd IS DISTINCT FROM 'CAT_000198' RETURNING 1) INSERT INTO _pass SELECT 1,'R3b',count(*) FROM u;
  WITH u AS (UPDATE t_proc_processes SET del_yn='Y', del_dt=now(), upd_dt=now() WHERE proc_cd='PROC_000025' AND del_yn='N' RETURNING 1) INSERT INTO _pass SELECT 1,'R4',count(*) FROM u;
  WITH u AS (UPDATE t_mat_materials SET mat_typ_cd='MAT_TYPE.07', upd_dt=now() WHERE mat_cd IN ('MAT_000210','MAT_000212','MAT_000213','MAT_000215','MAT_000216','MAT_000217','MAT_000219','MAT_000220','MAT_000221','MAT_000222','MAT_000224','MAT_000226','MAT_000227','MAT_000228','MAT_000230','MAT_000231') AND mat_typ_cd='MAT_TYPE.10' AND del_yn='N' RETURNING 1) INSERT INTO _pass SELECT 1,'R5',count(*) FROM u;
  WITH u AS (UPDATE t_mat_materials SET del_yn='Y', del_dt=now(), upd_dt=now() WHERE mat_cd IN ('MAT_000197','MAT_000198','MAT_000199','MAT_000200','MAT_000201') AND mat_typ_cd='MAT_TYPE.10' AND del_yn='N' RETURNING 1) INSERT INTO _pass SELECT 1,'R6env',count(*) FROM u;
  WITH u AS (UPDATE t_mat_materials SET del_yn='Y', del_dt=now(), upd_dt=now() WHERE mat_cd IN ('MAT_000211','MAT_000218','MAT_000223','MAT_000225','MAT_000229','MAT_000233') AND mat_typ_cd='MAT_TYPE.10' AND del_yn='N' RETURNING 1) INSERT INTO _pass SELECT 1,'R6hdr',count(*) FROM u;
  -- ===== PASS 2 (동일 재실행·전건 0이어야 멱등) =====
  WITH u AS (UPDATE t_siz_sizes SET siz_nm='165x115mm(10장)', upd_dt=now() WHERE siz_cd IN ('SIZ_000104','SIZ_000105') AND del_yn='N' AND siz_nm IS DISTINCT FROM '165x115mm(10장)' RETURNING 1) INSERT INTO _pass SELECT 2,'R1',count(*) FROM u;
  WITH u AS (UPDATE t_cat_categories SET del_yn='Y', del_dt=now(), upd_dt=now() WHERE cat_cd IN ('CAT_000294','CAT_000293','CAT_000295','CAT_000296','CAT_000298','CAT_000299','CAT_000300','CAT_000301','CAT_000303','CAT_000305','CAT_000306') AND del_yn='N' RETURNING 1) INSERT INTO _pass SELECT 2,'R2',count(*) FROM u;
  WITH u AS (UPDATE t_cat_categories SET upr_cat_cd='CAT_000134', upd_dt=now() WHERE cat_cd='CAT_000302' AND del_yn='N' AND upr_cat_cd IS DISTINCT FROM 'CAT_000134' RETURNING 1) INSERT INTO _pass SELECT 2,'R3a',count(*) FROM u;
  WITH u AS (UPDATE t_cat_categories SET upr_cat_cd='CAT_000198', upd_dt=now() WHERE cat_cd='CAT_000304' AND del_yn='N' AND upr_cat_cd IS DISTINCT FROM 'CAT_000198' RETURNING 1) INSERT INTO _pass SELECT 2,'R3b',count(*) FROM u;
  WITH u AS (UPDATE t_proc_processes SET del_yn='Y', del_dt=now(), upd_dt=now() WHERE proc_cd='PROC_000025' AND del_yn='N' RETURNING 1) INSERT INTO _pass SELECT 2,'R4',count(*) FROM u;
  WITH u AS (UPDATE t_mat_materials SET mat_typ_cd='MAT_TYPE.07', upd_dt=now() WHERE mat_cd IN ('MAT_000210','MAT_000212','MAT_000213','MAT_000215','MAT_000216','MAT_000217','MAT_000219','MAT_000220','MAT_000221','MAT_000222','MAT_000224','MAT_000226','MAT_000227','MAT_000228','MAT_000230','MAT_000231') AND mat_typ_cd='MAT_TYPE.10' AND del_yn='N' RETURNING 1) INSERT INTO _pass SELECT 2,'R5',count(*) FROM u;
  WITH u AS (UPDATE t_mat_materials SET del_yn='Y', del_dt=now(), upd_dt=now() WHERE mat_cd IN ('MAT_000197','MAT_000198','MAT_000199','MAT_000200','MAT_000201') AND mat_typ_cd='MAT_TYPE.10' AND del_yn='N' RETURNING 1) INSERT INTO _pass SELECT 2,'R6env',count(*) FROM u;
  WITH u AS (UPDATE t_mat_materials SET del_yn='Y', del_dt=now(), upd_dt=now() WHERE mat_cd IN ('MAT_000211','MAT_000218','MAT_000223','MAT_000225','MAT_000229','MAT_000233') AND mat_typ_cd='MAT_TYPE.10' AND del_yn='N' RETURNING 1) INSERT INTO _pass SELECT 2,'R6hdr',count(*) FROM u;

  \echo '--- pass별 영향 행수 (pass1=교정·pass2=0이어야 멱등) ---'
  SELECT item, max(n) FILTER (WHERE pass=1) AS pass1, max(n) FILTER (WHERE pass=2) AS pass2 FROM _pass GROUP BY item ORDER BY item;
  \echo '--- 멱등 판정: pass2 합계 ---'
  SELECT sum(n) AS pass2_total_must_be_0 FROM _pass WHERE pass=2;
ROLLBACK;
\echo '[IDEMPOTENT] ROLLBACK 완료 — 커밋 0'
SQL
    ;;

  commit)
    echo "[COMMIT MODE] 인간 최종 승인 적재. (DRY-RUN GO 확인 후에만 실행)"
    $PSQL <<SQL
BEGIN;
\i apply_wave1.sql
COMMIT;
SQL
    echo "[COMMIT] 완료"
    ;;

  *)
    echo "usage: $0 [dryrun|idempotent|backup|commit]"; exit 1
    ;;
esac
