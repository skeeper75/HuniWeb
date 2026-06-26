-- ============================================================================
-- [제안·미실행] 072 내지 승격 — 역적용(undo) · 인간 승인 후만
-- 역순: ③ sets 삭제 → 재배열 원복 → ② dims 삭제 → ① products 삭제
-- 전제: backup.sql 의 bak_inner_promo_072_sets 가 재배열 전 disp_seq 보존
-- 멱등: 각 DELETE/UPDATE 가 대상 부재 시 0행
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

-- ③ 내지 sets 행 삭제
DELETE FROM t_prd_product_sets
 WHERE prd_cd='PRD_000072' AND sub_prd_cd='PRD_000284';

-- ③' disp_seq 원복 (bak 기준·재배열 되돌림)
UPDATE t_prd_product_sets s
   SET disp_seq = b.disp_seq, upd_dt = now()
  FROM bak_inner_promo_072_sets b
 WHERE s.prd_cd='PRD_000072' AND s.sub_prd_cd=b.sub_prd_cd
   AND s.sub_prd_cd IN ('PRD_000073','PRD_000074','PRD_000075','PRD_000076')
   AND s.disp_seq <> b.disp_seq;

-- ② dims 삭제 (PRD_000284)
DELETE FROM t_prd_product_plate_sizes  WHERE prd_cd='PRD_000284';
DELETE FROM t_prd_product_materials    WHERE prd_cd='PRD_000284';
DELETE FROM t_prd_product_page_rules   WHERE prd_cd='PRD_000284';
DELETE FROM t_prd_product_print_options WHERE prd_cd='PRD_000284';
DELETE FROM t_prd_product_sizes        WHERE prd_cd='PRD_000284';

-- ① products 삭제 (자식 dims/sets 전부 제거 후)
DELETE FROM t_prd_products WHERE prd_cd='PRD_000284';

-- 검증: 잔재 0
DO $$ DECLARE n int; BEGIN
  SELECT (SELECT count(*) FROM t_prd_products WHERE prd_cd='PRD_000284')
       + (SELECT count(*) FROM t_prd_product_sets WHERE sub_prd_cd='PRD_000284') INTO n;
  IF n <> 0 THEN RAISE EXCEPTION 'FAIL undo: 284 잔재 %', n; END IF;
END $$;

-- ROLLBACK;  -- 검증 시
-- COMMIT;    -- 인간 승인 후 실제 undo
ROLLBACK;
