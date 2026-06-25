-- ============================================================================
-- dryrun.sql — 엽서북 셋트 보정 롤백전용 DRY-RUN (멱등·제약위반·delta 실증)
-- 생성: hsp-load-executor · BEGIN ... ROLLBACK (절대 COMMIT 안 함)
-- 한 트랜잭션 안에서 1차 적용(delta 측정) → 2차 적용(멱등 delta 0 측정) → ROLLBACK
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

\echo '--- [1차 적용] ---'

-- DML#1: 부모 유형 04 -> 01 (IS DISTINCT FROM 멱등 가드)
WITH u AS (
  UPDATE t_prd_products
     SET prd_typ_cd = 'PRD_TYPE.01', upd_dt = now()
   WHERE prd_cd = 'PRD_000094' AND prd_typ_cd IS DISTINCT FROM 'PRD_TYPE.01'
  RETURNING 1)
SELECT '1차 DML#1 UPDATE t_prd_products' AS step, count(*) AS rows FROM u;

-- DML#2: 내지(95) UPSERT
WITH s AS (
  INSERT INTO t_prd_product_sets
      (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt)
  VALUES
      ('PRD_000094', 'PRD_000095', 1, 20, 30, 10, 1, '내지=몽블랑240·페이지20~30/+10', 'N', now())
  ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
      sub_prd_qty = EXCLUDED.sub_prd_qty, min_cnt = EXCLUDED.min_cnt, max_cnt = EXCLUDED.max_cnt,
      cnt_incr = EXCLUDED.cnt_incr, disp_seq = EXCLUDED.disp_seq, note = EXCLUDED.note,
      del_yn = 'N', upd_dt = now()
  RETURNING 1)
SELECT '1차 DML#2 UPSERT (94,95)' AS step, count(*) AS rows FROM s;

-- DML#3: 표지(96) UPSERT (disp_seq 1->2)
WITH s AS (
  INSERT INTO t_prd_product_sets
      (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt)
  VALUES
      ('PRD_000094', 'PRD_000096', 1, NULL, NULL, NULL, 2, '표지=스노우300·1권고정', 'N', now())
  ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
      sub_prd_qty = EXCLUDED.sub_prd_qty, min_cnt = EXCLUDED.min_cnt, max_cnt = EXCLUDED.max_cnt,
      cnt_incr = EXCLUDED.cnt_incr, disp_seq = EXCLUDED.disp_seq, note = EXCLUDED.note,
      del_yn = 'N', upd_dt = now()
  RETURNING 1)
SELECT '1차 DML#3 UPSERT (94,96)' AS step, count(*) AS rows FROM s;

\echo '--- [1차 적용 후 데이터 fingerprint] ---'
SELECT '1차 fingerprint' AS lbl,
       md5(string_agg(prd_cd||'|'||sub_prd_cd||'|'||sub_prd_qty||'|'||coalesce(min_cnt::text,'_')||'|'||
            coalesce(max_cnt::text,'_')||'|'||coalesce(cnt_incr::text,'_')||'|'||coalesce(disp_seq::text,'_')||'|'||
            coalesce(note,'_')||'|'||del_yn, ',' ORDER BY sub_prd_cd)) AS fp
FROM t_prd_product_sets WHERE prd_cd='PRD_000094';
SELECT '1차 94유형' AS lbl, prd_typ_cd FROM t_prd_products WHERE prd_cd='PRD_000094';

\echo '--- [2차 적용 — 멱등성: delta 0 이어야 함] ---'

WITH u AS (
  UPDATE t_prd_products
     SET prd_typ_cd = 'PRD_TYPE.01', upd_dt = now()
   WHERE prd_cd = 'PRD_000094' AND prd_typ_cd IS DISTINCT FROM 'PRD_TYPE.01'
  RETURNING 1)
SELECT '2차 DML#1 UPDATE (멱등→0 기대)' AS step, count(*) AS rows FROM u;

-- 2차 UPSERT는 ON CONFLICT DO UPDATE라 행수는 2(분기 진입)이나 데이터값 변화 0이어야 함 → fingerprint로 검증
WITH s AS (
  INSERT INTO t_prd_product_sets
      (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt)
  VALUES ('PRD_000094', 'PRD_000095', 1, 20, 30, 10, 1, '내지=몽블랑240·페이지20~30/+10', 'N', now())
  ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
      sub_prd_qty = EXCLUDED.sub_prd_qty, min_cnt = EXCLUDED.min_cnt, max_cnt = EXCLUDED.max_cnt,
      cnt_incr = EXCLUDED.cnt_incr, disp_seq = EXCLUDED.disp_seq, note = EXCLUDED.note,
      del_yn = 'N', upd_dt = now()
  RETURNING 1)
SELECT '2차 DML#2 UPSERT (94,95)' AS step, count(*) AS rows FROM s;

WITH s AS (
  INSERT INTO t_prd_product_sets
      (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt)
  VALUES ('PRD_000094', 'PRD_000096', 1, NULL, NULL, NULL, 2, '표지=스노우300·1권고정', 'N', now())
  ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
      sub_prd_qty = EXCLUDED.sub_prd_qty, min_cnt = EXCLUDED.min_cnt, max_cnt = EXCLUDED.max_cnt,
      cnt_incr = EXCLUDED.cnt_incr, disp_seq = EXCLUDED.disp_seq, note = EXCLUDED.note,
      del_yn = 'N', upd_dt = now()
  RETURNING 1)
SELECT '2차 DML#3 UPSERT (94,96)' AS step, count(*) AS rows FROM s;

\echo '--- [2차 fingerprint — 1차와 동일해야 멱등] ---'
SELECT '2차 fingerprint' AS lbl,
       md5(string_agg(prd_cd||'|'||sub_prd_cd||'|'||sub_prd_qty||'|'||coalesce(min_cnt::text,'_')||'|'||
            coalesce(max_cnt::text,'_')||'|'||coalesce(cnt_incr::text,'_')||'|'||coalesce(disp_seq::text,'_')||'|'||
            coalesce(note,'_')||'|'||del_yn, ',' ORDER BY sub_prd_cd)) AS fp
FROM t_prd_product_sets WHERE prd_cd='PRD_000094';

\echo '--- [적용 후 최종 셋트행 상태] ---'
SELECT prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn
FROM t_prd_product_sets WHERE prd_cd='PRD_000094' ORDER BY disp_seq, sub_prd_cd;

\echo '--- [고아 FK·복합PK 중복 점검] ---'
SELECT 'FK 고아(sub 미실재)' AS chk, count(*) AS cnt FROM t_prd_product_sets s
 WHERE s.prd_cd='PRD_000094' AND NOT EXISTS (SELECT 1 FROM t_prd_products p WHERE p.prd_cd=s.sub_prd_cd);
SELECT '복합PK 중복' AS chk, count(*)-count(DISTINCT (prd_cd,sub_prd_cd)) AS dup
 FROM t_prd_product_sets WHERE prd_cd='PRD_000094';

ROLLBACK;
\echo '=== ROLLBACK 완료 (라이브 무변경) ==='
