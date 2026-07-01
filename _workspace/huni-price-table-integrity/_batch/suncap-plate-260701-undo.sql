-- UNDO — 썬캡 3절 판형 등록 취소 (2026-07-01)
-- 물리 삭제(신규 행이라 안전) — 단, 이후 참조 생겼으면 del_yn 논리삭제로 전환할 것.
BEGIN;
DELETE FROM t_siz_sizes WHERE siz_cd='SIZ_000535'
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices WHERE plt_siz_cd='SIZ_000535')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_sizes WHERE siz_cd='SIZ_000535')
  AND NOT EXISTS (SELECT 1 FROM t_siz_pansu WHERE plt_siz_cd='SIZ_000535');
COMMIT;
