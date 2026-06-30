-- ================================================================
-- 069 무선·070 PUR 완전 동작화 — UNDO (역연산·백업 복원)
-- 생성: hsp-load-executor 2026-07-01 · apply.sql COMMIT 취소용
-- 원리: 289~292는 신규 mint(백업 시점 0행)였으므로 물리 DELETE로 완전 제거.
--        069/070 셋트행도 baseline 0행이었으므로 셋트행 물리 DELETE.
--        069/070 부모 제본 바인딩·완제품행은 apply가 멱등 NO-OP였으므로(delta 0) 백업과 동일 → 복원 불요.
--        ★단, 안전상 부모공식 바인딩은 백업 테이블에서 명시 복원(멱등).
-- ★주의: 289~292·069/070 셋트행은 적재 전 0행이었으므로 DELETE가 무손상 역연산.
--         (논리삭제 대상이 아니라 신규 적재분이므로 물리 DELETE가 올바른 undo — del_yn 복원 아님)
-- 실행: psql ... -f booklet-museon-pur-069-070-undo.sql
-- ================================================================
\set ON_ERROR_STOP on
BEGIN;

-- 1) 셋트행 제거 (069/070 — baseline 0행이었음)
DELETE FROM t_prd_product_sets WHERE prd_cd IN ('PRD_000069','PRD_000070');

-- 2) 반제품 289~292 자식행 제거 (FK 역위상순)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');
DELETE FROM t_prd_product_processes      WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');
DELETE FROM t_prd_product_plate_sizes    WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');
DELETE FROM t_prd_product_materials      WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');
DELETE FROM t_prd_product_print_options  WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');
DELETE FROM t_prd_product_sizes          WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');

-- 3) 반제품 mint 제거
DELETE FROM t_prd_products WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');

-- 4) 069/070 부모 제본 바인딩 복원 (apply는 NO-OP였으나 안전상 백업에서 명시 복원)
--    apply가 note만 멱등 갱신했을 수 있으므로 백업 시점 행으로 되돌림.
UPDATE t_prd_product_price_formulas tgt
SET note = bak.note, upd_dt = now()
FROM bak_t_prd_product_price_formulas_setbuild_20260701_0204 bak
WHERE tgt.prd_cd = bak.prd_cd AND tgt.apply_bgn_ymd = bak.apply_bgn_ymd
  AND tgt.prd_cd IN ('PRD_000069','PRD_000070')
  AND tgt.note IS DISTINCT FROM bak.note;

COMMIT;

-- 검증: 289~292·069/070 셋트행 0행 복귀
SELECT 'products_289_292' k, count(*) v FROM t_prd_products WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292')
UNION ALL SELECT 'sets_069', count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000069'
UNION ALL SELECT 'sets_070', count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000070';
