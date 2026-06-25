-- apply.sql (zombie-wiring-92 _exec) — 확정 4건 라이브 COMMIT 래핑본
-- REWIRE 2 (t_prd_product_materials.mat_cd 정본 재지정) + REVIVE 2 (t_mat_materials.del_yn 'Y'->'N')
-- 멱등[HARD]: REVIVE=WHERE del_yn IS DISTINCT FROM 'N'; REWIRE=좀비 mat_cd 잔존 행만 처리(2차 실행 시 0행).
-- 비파괴: UPDATE만(물리 DELETE 0·DDL 0·mint 0). PK=(prd_cd,mat_cd,usage_cd).
-- ★복합PK 충돌 가드[HARD]: 정본이 동일 (prd_cd,usage_cd)에 이미 배선된 경우(중복 발생) ->
--   좀비 링크를 정본으로 바꾸지 않고 좀비 링크 del_yn='Y' 처리(중복 회피). 실측 충돌 0건이나 방어적 내장.
-- 단일 트랜잭션(BEGIN…COMMIT) — 부분커밋 경로 없음. 트리거 trg_*_upd_dt가 upd_dt 갱신.
-- ★실행 전 backup.sql 선행 필수(undo 가역). 자격증명 .env.local.

BEGIN;

-- ───────────────────────────────────────────────────────────
-- REWIRE 1: MAT_000260 (아트250+무광코팅, del_yn=Y) -> 정본 MAT_000250
-- ───────────────────────────────────────────────────────────
-- (a) 충돌 행: 정본 250이 동일 (prd_cd,USAGE.02)에 이미 배선 -> 좀비 링크 del_yn='Y'(중복 회피)
UPDATE t_prd_product_materials z
   SET del_yn='Y', del_dt=now()
 WHERE z.mat_cd='MAT_000260' AND z.del_yn='N'
   AND EXISTS (SELECT 1 FROM t_prd_product_materials c
               WHERE c.prd_cd=z.prd_cd AND c.usage_cd=z.usage_cd AND c.mat_cd='MAT_000250');
-- (b) 비충돌 행: 좀비 mat_cd를 정본으로 재지정
UPDATE t_prd_product_materials z
   SET mat_cd='MAT_000250'
 WHERE z.mat_cd='MAT_000260' AND z.del_yn='N'
   AND NOT EXISTS (SELECT 1 FROM t_prd_product_materials c
                   WHERE c.prd_cd=z.prd_cd AND c.usage_cd=z.usage_cd AND c.mat_cd='MAT_000250');

-- ───────────────────────────────────────────────────────────
-- REWIRE 2: MAT_000270 (워터북보틀 500ml, del_yn=Y) -> 정본 MAT_000343
-- ───────────────────────────────────────────────────────────
-- (a) 충돌 행: 좀비 링크 del_yn='Y'(중복 회피)
UPDATE t_prd_product_materials z
   SET del_yn='Y', del_dt=now()
 WHERE z.mat_cd='MAT_000270' AND z.del_yn='N'
   AND EXISTS (SELECT 1 FROM t_prd_product_materials c
               WHERE c.prd_cd=z.prd_cd AND c.usage_cd=z.usage_cd AND c.mat_cd='MAT_000343');
-- (b) 비충돌 행: 정본 재지정
UPDATE t_prd_product_materials z
   SET mat_cd='MAT_000343'
 WHERE z.mat_cd='MAT_000270' AND z.del_yn='N'
   AND NOT EXISTS (SELECT 1 FROM t_prd_product_materials c
                   WHERE c.prd_cd=z.prd_cd AND c.usage_cd=z.usage_cd AND c.mat_cd='MAT_000343');

-- ───────────────────────────────────────────────────────────
-- REVIVE 1: MAT_000008 (레더, 23wire) del_yn 'Y'->'N'
-- ───────────────────────────────────────────────────────────
UPDATE t_mat_materials SET del_yn='N', del_dt=NULL
 WHERE mat_cd='MAT_000008' AND del_yn IS DISTINCT FROM 'N';

-- ───────────────────────────────────────────────────────────
-- REVIVE 2: MAT_000261 (무지내지, 4wire) del_yn 'Y'->'N'
-- ───────────────────────────────────────────────────────────
UPDATE t_mat_materials SET del_yn='N', del_dt=NULL
 WHERE mat_cd='MAT_000261' AND del_yn IS DISTINCT FROM 'N';

COMMIT;
