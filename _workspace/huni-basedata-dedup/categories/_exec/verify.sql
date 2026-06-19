-- verify.sql — 카테고리축 CAT_000104 표시명 교정 사후검증 (COMMIT 후 라이브 재실측)
-- 2026-06-19 / hbd-load-executor / V1~V5 게이트

\echo '=== V1: CAT_000104 cat_nm=하드커버 (교정 확정) ==='
SELECT cat_cd, cat_nm, upr_cat_cd, cat_lvl, disp_seq, use_yn, del_yn, upd_dt
FROM t_cat_categories WHERE cat_cd='CAT_000104';
--   기대: cat_nm='하드커버', 부모006·L2·del_yn=N 무변경

\echo '=== V2: 자식 CAT_000105 cat_nm=하드커버책자 무변경 (잎 보존) ==='
SELECT cat_cd, cat_nm, upr_cat_cd, cat_lvl, use_yn, del_yn
FROM t_cat_categories WHERE cat_cd='CAT_000105';
--   기대: cat_nm='하드커버책자', 부모104·L3 무변경

\echo '=== V3: 책자 서브트리 활성 동명충돌 2->0 ==='
SELECT cat_nm, count(*) FROM t_cat_categories
WHERE del_yn='N' AND upr_cat_cd IN ('CAT_000006','CAT_000104')
GROUP BY cat_nm HAVING count(*)>1;
--   기대: 0행

\echo '=== V4: junction 상품귀속 무변경 (104=0, 105=22) ==='
SELECT cat_cd, count(*) FROM t_prd_product_categories
WHERE cat_cd IN ('CAT_000104','CAT_000105') GROUP BY cat_cd ORDER BY cat_cd;
--   기대: 104=0, 105=22

\echo '=== V5: 멱등 — apply.sql 재실행 시 delta=0 (별도 BEGIN..ROLLBACK 입증) ==='
BEGIN;
WITH u AS (
  UPDATE t_cat_categories SET cat_nm='하드커버', upd_dt=now()
   WHERE cat_cd='CAT_000104' AND cat_nm='하드커버책자' AND del_yn='N'
  RETURNING 1)
SELECT 'V5 re-apply delta' AS step, COUNT(*) AS delta FROM u;
--   기대 delta: 0 (이미 '하드커버')
ROLLBACK;

\echo '=== V-guard: 빈노드 318/319/320 무접촉 확인 ==='
SELECT cat_cd, cat_nm, del_yn FROM t_cat_categories
WHERE cat_cd IN ('CAT_000318','CAT_000319','CAT_000320') ORDER BY cat_cd;
--   기대: 3노드 전부 본 트랙 무변경(del_yn 원상태)
