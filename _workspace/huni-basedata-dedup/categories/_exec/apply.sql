-- apply.sql — 카테고리축 CAT_000104 표시명 교정 APPLY 본문 (COMMIT 대상)
-- 2026-06-19 / hbd-load-executor
-- ★[HARD] 내장 BEGIN/COMMIT 금지(round-24 비인가 COMMIT 사고 재발방지).
--   이 파일은 멱등 UPDATE 본문만 — 실행은 `psql -1 -f apply.sql`(단일 트랜잭션 래핑).
-- 멱등 가드 WHERE cat_nm='하드커버책자' AND del_yn='N' (이미 '하드커버'면 no-op·재실행 delta 0).

UPDATE t_cat_categories
   SET cat_nm = '하드커버', upd_dt = now()
 WHERE cat_cd = 'CAT_000104'
   AND cat_nm = '하드커버책자'
   AND del_yn = 'N';
-- 예상 delta: 1행 (재실행 시 0).
-- 무변경: upr_cat_cd·cat_lvl·disp_seq·use_yn·del_yn·junction(상품귀속)·가격사슬(pd=N).
-- 잎 CAT_000105('하드커버책자' 상품22) 무접촉. 빈노드 318/319/320 무접촉.
