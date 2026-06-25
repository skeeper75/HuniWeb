-- zr1-dryrun.sql (zombie-wiring-92 _exec) — rev2 REVIVE 9건 롤백전용 라이브 DRY-RUN (BEGIN…ROLLBACK)
-- 제약위반0·멱등(2차 delta0)·좀비 83->74 재집계·옵션 ref 무결성(삭제자재 참조 11->0)·돈불변(단가행0).
-- ROLLBACK이라 라이브 무변경. 한 트랜잭션 내 APPLY 2회로 멱등 실증.

BEGIN;

-- ── PRE 측정 ──
SELECT 'PRE_dead_9'        AS k, count(*) AS v FROM t_mat_materials WHERE mat_cd IN ('MAT_000069','MAT_000070','MAT_000337','MAT_000338','MAT_000340','MAT_000244','MAT_000245','MAT_000154','MAT_000262') AND del_yn='Y';
SELECT 'PRE_zombie_mats'   AS k, count(DISTINCT t.mat_cd) AS v FROM t_mat_materials t JOIN t_prd_product_materials pm ON pm.mat_cd=t.mat_cd AND pm.del_yn='N' WHERE t.del_yn='Y';
SELECT 'PRE_zombie_wires'  AS k, count(pm.*) AS v FROM t_mat_materials t JOIN t_prd_product_materials pm ON pm.mat_cd=t.mat_cd AND pm.del_yn='N' WHERE t.del_yn='Y';
-- 옵션 참조 무결성: 활성 option_items가 삭제(del_yn='Y') 자재를 ref_key1로 참조하는 건수(9건 중)
SELECT 'PRE_broken_opt_ref' AS k, count(*) AS v FROM t_prd_product_option_items oi
  JOIN t_mat_materials m ON m.mat_cd=oi.ref_key1 AND m.del_yn='Y'
 WHERE oi.ref_dim_cd='OPT_REF_DIM.03' AND oi.del_yn='N'
   AND oi.ref_key1 IN ('MAT_000069','MAT_000070','MAT_000337','MAT_000338','MAT_000340','MAT_000244','MAT_000245','MAT_000154','MAT_000262');

-- ══════════ APPLY 1차 ══════════
WITH a AS (UPDATE t_mat_materials SET del_yn='N', del_dt=NULL
   WHERE mat_cd IN ('MAT_000069','MAT_000070','MAT_000337','MAT_000338','MAT_000340','MAT_000244','MAT_000245','MAT_000154','MAT_000262')
     AND del_yn IS DISTINCT FROM 'N' RETURNING 1)
SELECT 'APPLY1_revived' AS k, count(*) AS v FROM a;

-- ══════════ APPLY 2차 (멱등 — delta 0 기대) ══════════
WITH b AS (UPDATE t_mat_materials SET del_yn='N', del_dt=NULL
   WHERE mat_cd IN ('MAT_000069','MAT_000070','MAT_000337','MAT_000338','MAT_000340','MAT_000244','MAT_000245','MAT_000154','MAT_000262')
     AND del_yn IS DISTINCT FROM 'N' RETURNING 1)
SELECT 'APPLY2_idempotent_delta' AS k, count(*) AS v FROM b;

-- ── POST 측정 ──
SELECT 'POST_active_9'      AS k, count(*) AS v FROM t_mat_materials WHERE mat_cd IN ('MAT_000069','MAT_000070','MAT_000337','MAT_000338','MAT_000340','MAT_000244','MAT_000245','MAT_000154','MAT_000262') AND del_yn='N';
SELECT 'POST_zombie_mats'   AS k, count(DISTINCT t.mat_cd) AS v FROM t_mat_materials t JOIN t_prd_product_materials pm ON pm.mat_cd=t.mat_cd AND pm.del_yn='N' WHERE t.del_yn='Y';
SELECT 'POST_zombie_wires'  AS k, count(pm.*) AS v FROM t_mat_materials t JOIN t_prd_product_materials pm ON pm.mat_cd=t.mat_cd AND pm.del_yn='N' WHERE t.del_yn='Y';
-- 옵션 참조 무결성: 부활 후 삭제자재 참조 0 기대
SELECT 'POST_broken_opt_ref' AS k, count(*) AS v FROM t_prd_product_option_items oi
  JOIN t_mat_materials m ON m.mat_cd=oi.ref_key1 AND m.del_yn='Y'
 WHERE oi.ref_dim_cd='OPT_REF_DIM.03' AND oi.del_yn='N'
   AND oi.ref_key1 IN ('MAT_000069','MAT_000070','MAT_000337','MAT_000338','MAT_000340','MAT_000244','MAT_000245','MAT_000154','MAT_000262');

-- ── 돈 무손상: 9건 직접 단가행 0 ──
SELECT 'money_priced_rows' AS k, count(*) AS v FROM t_prc_component_prices
 WHERE mat_cd IN ('MAT_000069','MAT_000070','MAT_000337','MAT_000338','MAT_000340','MAT_000244','MAT_000245','MAT_000154','MAT_000262');

ROLLBACK;

-- ── ROLLBACK 후 무변경 확인(별도 실행) ──
SELECT 'AFTER_ROLLBACK_dead_9' AS k, count(*) AS v FROM t_mat_materials WHERE mat_cd IN ('MAT_000069','MAT_000070','MAT_000337','MAT_000338','MAT_000340','MAT_000244','MAT_000245','MAT_000154','MAT_000262') AND del_yn='Y';
SELECT 'AFTER_ROLLBACK_zombie_mats' AS k, count(DISTINCT t.mat_cd) AS v FROM t_mat_materials t JOIN t_prd_product_materials pm ON pm.mat_cd=t.mat_cd AND pm.del_yn='N' WHERE t.del_yn='Y';
-- 기대: PRE_dead_9=9, PRE_zombie_mats=83, PRE_zombie_wires=140, PRE_broken_opt_ref=11,
--       APPLY1_revived=9, APPLY2_idempotent_delta=0,
--       POST_active_9=9, POST_zombie_mats=74, POST_broken_opt_ref=0, money_priced_rows=0,
--       AFTER_ROLLBACK_dead_9=9, AFTER_ROLLBACK_zombie_mats=83.
