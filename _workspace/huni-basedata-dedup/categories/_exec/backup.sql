-- backup.sql — 카테고리축 표시명 교정 1건 물리 백업 (undo 안전망)
-- 2026-06-19 / hbd-load-executor
-- 영향 행만 고정명 백업 테이블로 복제. Date.now() 금지 — 고정 접미사 _round_pilot.
-- 멱등: 백업 테이블 존재 시 재실행하지 않도록 IF NOT EXISTS 가드.
-- 영향 노드 = CAT_000104(교정 대상) + CAT_000105(대조·무접촉 잎, 충돌 그룹 동반 백업).

CREATE TABLE IF NOT EXISTS bak_cat_dedup_round_pilot AS
  SELECT * FROM t_cat_categories
   WHERE cat_cd IN ('CAT_000104','CAT_000105');

-- 백업 행수 확인 (기대: 2 — 104 교정대상 + 105 동반 대조)
SELECT 'bak_cat_dedup_round_pilot' AS bak, COUNT(*) AS rows
  FROM bak_cat_dedup_round_pilot;
