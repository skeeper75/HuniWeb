-- undo.sql — 카테고리축 CAT_000104 표시명 교정 역연산 (백업 복원)
-- 2026-06-19 / hbd-load-executor
-- COMMIT된 교정을 원복: CAT_000104 cat_nm '하드커버' → '하드커버책자' (백업 시점값).
-- ★[HARD] 내장 BEGIN/COMMIT 금지 — 실행은 `psql -1 -f undo.sql`.
-- 멱등 가드 WHERE cat_nm='하드커버' (이미 복원 시 no-op).

-- 방법1(권장): 백업 테이블에서 원본 cat_nm 복원 (백업 시점 정확값 보장)
UPDATE t_cat_categories t
   SET cat_nm = b.cat_nm, upd_dt = now()
  FROM bak_cat_dedup_round_pilot b
 WHERE t.cat_cd = 'CAT_000104'
   AND b.cat_cd = 'CAT_000104'
   AND t.cat_nm = '하드커버'
   AND t.del_yn = 'N';
-- 예상 delta: 1행 (백업 cat_nm='하드커버책자'로 원복). 재실행 시 0.

-- 검증
SELECT cat_cd, cat_nm FROM t_cat_categories WHERE cat_cd='CAT_000104';
--   기대: cat_nm='하드커버책자' (원복)
