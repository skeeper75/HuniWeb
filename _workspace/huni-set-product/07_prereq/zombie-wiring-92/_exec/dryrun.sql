-- dryrun.sql (zombie-wiring-92 _exec) — 롤백전용 라이브 DRY-RUN (BEGIN…ROLLBACK)
-- 확정 4건(REWIRE 2 + REVIVE 2). 제약위반0·충돌가드·멱등(2차 delta0)·좀비 87->83 재집계·FK무결성·중복0·돈불변(단가행0).
-- ROLLBACK이라 라이브 무변경. 한 트랜잭션 내 APPLY 2회로 멱등 실증.

BEGIN;

-- ── PRE 측정 ──
SELECT 'PRE_dead_4'        AS k, count(*) AS v FROM t_mat_materials WHERE mat_cd IN ('MAT_000008','MAT_000261','MAT_000260','MAT_000270') AND del_yn='Y';
SELECT 'PRE_zombie_mats'   AS k, count(DISTINCT t.mat_cd) AS v FROM t_mat_materials t JOIN t_prd_product_materials pm ON pm.mat_cd=t.mat_cd AND pm.del_yn='N' WHERE t.del_yn='Y';
SELECT 'PRE_zombie_wires'  AS k, count(pm.*) AS v FROM t_mat_materials t JOIN t_prd_product_materials pm ON pm.mat_cd=t.mat_cd AND pm.del_yn='N' WHERE t.del_yn='Y';
SELECT 'PRE_wire_260'      AS k, count(*) AS v FROM t_prd_product_materials WHERE mat_cd='MAT_000260' AND del_yn='N';
SELECT 'PRE_wire_270'      AS k, count(*) AS v FROM t_prd_product_materials WHERE mat_cd='MAT_000270' AND del_yn='N';
SELECT 'PRE_wire_250'      AS k, count(*) AS v FROM t_prd_product_materials WHERE mat_cd='MAT_000250' AND del_yn='N';
SELECT 'PRE_wire_343'      AS k, count(*) AS v FROM t_prd_product_materials WHERE mat_cd='MAT_000343' AND del_yn='N';

-- ══════════ APPLY 1차 ══════════
-- REWIRE 260->250 (a 충돌 del_yn=Y / b 비충돌 재지정)
WITH ra AS (UPDATE t_prd_product_materials z SET del_yn='Y', del_dt=now()
   WHERE z.mat_cd='MAT_000260' AND z.del_yn='N'
     AND EXISTS (SELECT 1 FROM t_prd_product_materials c WHERE c.prd_cd=z.prd_cd AND c.usage_cd=z.usage_cd AND c.mat_cd='MAT_000250') RETURNING 1)
SELECT 'APPLY1_260_conflict_softdel' AS k, count(*) AS v FROM ra;
WITH rb AS (UPDATE t_prd_product_materials z SET mat_cd='MAT_000250'
   WHERE z.mat_cd='MAT_000260' AND z.del_yn='N'
     AND NOT EXISTS (SELECT 1 FROM t_prd_product_materials c WHERE c.prd_cd=z.prd_cd AND c.usage_cd=z.usage_cd AND c.mat_cd='MAT_000250') RETURNING 1)
SELECT 'APPLY1_260_rewired' AS k, count(*) AS v FROM rb;
-- REWIRE 270->343
WITH rc AS (UPDATE t_prd_product_materials z SET del_yn='Y', del_dt=now()
   WHERE z.mat_cd='MAT_000270' AND z.del_yn='N'
     AND EXISTS (SELECT 1 FROM t_prd_product_materials c WHERE c.prd_cd=z.prd_cd AND c.usage_cd=z.usage_cd AND c.mat_cd='MAT_000343') RETURNING 1)
SELECT 'APPLY1_270_conflict_softdel' AS k, count(*) AS v FROM rc;
WITH rd AS (UPDATE t_prd_product_materials z SET mat_cd='MAT_000343'
   WHERE z.mat_cd='MAT_000270' AND z.del_yn='N'
     AND NOT EXISTS (SELECT 1 FROM t_prd_product_materials c WHERE c.prd_cd=z.prd_cd AND c.usage_cd=z.usage_cd AND c.mat_cd='MAT_000343') RETURNING 1)
SELECT 'APPLY1_270_rewired' AS k, count(*) AS v FROM rd;
-- REVIVE 008 / 261
WITH re AS (UPDATE t_mat_materials SET del_yn='N', del_dt=NULL WHERE mat_cd='MAT_000008' AND del_yn IS DISTINCT FROM 'N' RETURNING 1)
SELECT 'APPLY1_revive_008' AS k, count(*) AS v FROM re;
WITH rf AS (UPDATE t_mat_materials SET del_yn='N', del_dt=NULL WHERE mat_cd='MAT_000261' AND del_yn IS DISTINCT FROM 'N' RETURNING 1)
SELECT 'APPLY1_revive_261' AS k, count(*) AS v FROM rf;

-- ══════════ APPLY 2차 (멱등 — 전부 delta 0 기대) ══════════
WITH g1 AS (UPDATE t_prd_product_materials z SET mat_cd='MAT_000250'
   WHERE z.mat_cd='MAT_000260' AND z.del_yn='N'
     AND NOT EXISTS (SELECT 1 FROM t_prd_product_materials c WHERE c.prd_cd=z.prd_cd AND c.usage_cd=z.usage_cd AND c.mat_cd='MAT_000250') RETURNING 1),
     g2 AS (UPDATE t_prd_product_materials z SET mat_cd='MAT_000343'
   WHERE z.mat_cd='MAT_000270' AND z.del_yn='N'
     AND NOT EXISTS (SELECT 1 FROM t_prd_product_materials c WHERE c.prd_cd=z.prd_cd AND c.usage_cd=z.usage_cd AND c.mat_cd='MAT_000343') RETURNING 1),
     g3 AS (UPDATE t_mat_materials SET del_yn='N', del_dt=NULL WHERE mat_cd IN ('MAT_000008','MAT_000261') AND del_yn IS DISTINCT FROM 'N' RETURNING 1)
SELECT 'APPLY2_idempotent_delta' AS k, (SELECT count(*) FROM g1)+(SELECT count(*) FROM g2)+(SELECT count(*) FROM g3) AS v;

-- ── POST 측정 ──
SELECT 'POST_dead_4_revived'  AS k, count(*) AS v FROM t_mat_materials WHERE mat_cd IN ('MAT_000008','MAT_000261') AND del_yn='N';
SELECT 'POST_zombie_mats'     AS k, count(DISTINCT t.mat_cd) AS v FROM t_mat_materials t JOIN t_prd_product_materials pm ON pm.mat_cd=t.mat_cd AND pm.del_yn='N' WHERE t.del_yn='Y';
SELECT 'POST_zombie_wires'    AS k, count(pm.*) AS v FROM t_mat_materials t JOIN t_prd_product_materials pm ON pm.mat_cd=t.mat_cd AND pm.del_yn='N' WHERE t.del_yn='Y';
SELECT 'POST_wire_260_left'   AS k, count(*) AS v FROM t_prd_product_materials WHERE mat_cd='MAT_000260' AND del_yn='N';
SELECT 'POST_wire_270_left'   AS k, count(*) AS v FROM t_prd_product_materials WHERE mat_cd='MAT_000270' AND del_yn='N';
SELECT 'POST_wire_250'        AS k, count(*) AS v FROM t_prd_product_materials WHERE mat_cd='MAT_000250' AND del_yn='N';
SELECT 'POST_wire_343'        AS k, count(*) AS v FROM t_prd_product_materials WHERE mat_cd='MAT_000343' AND del_yn='N';

-- ── 무결성: REWIRE 후 PK 중복 0 (정본 mat_cd 기준 동일 prd+usage 2행 이상) ──
SELECT 'POST_pk_dup_250' AS k, count(*) AS v FROM (SELECT prd_cd, usage_cd FROM t_prd_product_materials WHERE mat_cd='MAT_000250' AND del_yn='N' GROUP BY 1,2 HAVING count(*)>1) d;
SELECT 'POST_pk_dup_343' AS k, count(*) AS v FROM (SELECT prd_cd, usage_cd FROM t_prd_product_materials WHERE mat_cd='MAT_000343' AND del_yn='N' GROUP BY 1,2 HAVING count(*)>1) d;

-- ── FK 무결성: 활성 배선의 mat_cd가 t_mat_materials에 존재(고아 0) ──
SELECT 'POST_fk_orphan_wire' AS k, count(*) AS v FROM t_prd_product_materials pm
 LEFT JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
 WHERE pm.mat_cd IN ('MAT_000250','MAT_000343') AND pm.del_yn='N' AND m.mat_cd IS NULL;

-- ── 돈 무손상: 4건+정본 직접 단가행 0 ──
SELECT 'money_priced_rows' AS k, count(*) AS v FROM t_prc_component_prices
 WHERE mat_cd IN ('MAT_000008','MAT_000261','MAT_000260','MAT_000270','MAT_000250','MAT_000343');

ROLLBACK;

-- ── ROLLBACK 후 무변경 확인(별도 실행) ──
SELECT 'AFTER_ROLLBACK_dead_4' AS k, count(*) AS v FROM t_mat_materials WHERE mat_cd IN ('MAT_000008','MAT_000261','MAT_000260','MAT_000270') AND del_yn='Y';
SELECT 'AFTER_ROLLBACK_zombie_mats' AS k, count(DISTINCT t.mat_cd) AS v FROM t_mat_materials t JOIN t_prd_product_materials pm ON pm.mat_cd=t.mat_cd AND pm.del_yn='N' WHERE t.del_yn='Y';
-- 기대: PRE_dead_4=4, PRE_zombie_mats=87, PRE_zombie_wires=175, PRE_wire_260=7, PRE_wire_270=1,
--       APPLY1_260_conflict_softdel=0, APPLY1_260_rewired=7, APPLY1_270_conflict_softdel=0, APPLY1_270_rewired=1,
--       APPLY1_revive_008=1, APPLY1_revive_261=1, APPLY2_idempotent_delta=0,
--       POST_dead_4_revived=2, POST_zombie_mats=83, POST_wire_260_left=0, POST_wire_270_left=0,
--       POST_wire_250=PRE_wire_250+7, POST_wire_343=PRE_wire_343+1, POST_pk_dup_250=0, POST_pk_dup_343=0,
--       POST_fk_orphan_wire=0, money_priced_rows=0, AFTER_ROLLBACK_dead_4=4, AFTER_ROLLBACK_zombie_mats=87.
