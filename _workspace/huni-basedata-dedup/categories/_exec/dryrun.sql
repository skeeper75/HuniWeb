-- dryrun.sql — 카테고리축 CAT_000104 표시명 교정 롤백전용 DRY-RUN (BEGIN ... ROLLBACK)
-- 2026-06-19 / hbd-load-executor
-- 변경을 트랜잭션 내에서 실행 → 영향 행수·사후검증 SELECT 확인 → ROLLBACK(무손상).
-- 멱등 입증은 동일 트랜잭션 내 2회 UPDATE로 가드 확인(2회차 delta=0).

BEGIN;

-- (1차) CAT_000104 컨테이너 표시명 교정 (멱등 가드 WHERE cat_nm='하드커버책자' AND del_yn='N')
WITH u1 AS (
  UPDATE t_cat_categories
     SET cat_nm = '하드커버', upd_dt = now()
   WHERE cat_cd = 'CAT_000104'
     AND cat_nm = '하드커버책자'
     AND del_yn = 'N'
  RETURNING 1)
SELECT 'PASS1 UPD t_cat_categories cat_nm' AS step, COUNT(*) AS delta FROM u1;
--   기대 delta: 1

-- (2차 동일 트랜잭션 내 재실행) 멱등 가드 입증 — 이미 '하드커버'이므로 0행
WITH u2 AS (
  UPDATE t_cat_categories
     SET cat_nm = '하드커버', upd_dt = now()
   WHERE cat_cd = 'CAT_000104'
     AND cat_nm = '하드커버책자'
     AND del_yn = 'N'
  RETURNING 1)
SELECT 'PASS2 UPD (idempotent guard)' AS step, COUNT(*) AS delta FROM u2;
--   기대 delta: 0 (멱등)

-- 사후검증 (트랜잭션 내 상태)
\echo '--- V1 104 cat_nm=하드커버 / 105 무변경 ---'
SELECT cat_cd, cat_nm, upr_cat_cd, cat_lvl, disp_seq, use_yn, del_yn
FROM t_cat_categories WHERE cat_cd IN ('CAT_000104','CAT_000105') ORDER BY cat_cd;
--   기대: 104='하드커버'(부모006·L2 무변경) ; 105='하드커버책자'(부모104·L3 무변경)

\echo '--- V3 책자 서브트리 활성 동명충돌 2->0 ---'
SELECT cat_nm, count(*) FROM t_cat_categories
WHERE del_yn='N' AND upr_cat_cd IN ('CAT_000006','CAT_000104')
GROUP BY cat_nm HAVING count(*)>1;
--   기대: 0행 (104 교정 후 '하드커버책자' 단일)

\echo '--- V4 junction 무변경 (104=0, 105=22) ---'
SELECT cat_cd, count(*) FROM t_prd_product_categories
WHERE cat_cd IN ('CAT_000104','CAT_000105') GROUP BY cat_cd ORDER BY cat_cd;
--   기대: 104=0(컨테이너), 105=22(잎·무변경) — UPDATE는 cat_nm만 건드리므로 불변

\echo '--- V-guard 빈노드 318/319/320 무접촉 확인 ---'
SELECT cat_cd, cat_nm, del_yn FROM t_cat_categories
WHERE cat_cd IN ('CAT_000318','CAT_000319','CAT_000320') ORDER BY cat_cd;
--   기대: 3노드 전부 본 트랜잭션 무변경(del_yn 원상태 유지)

ROLLBACK;
