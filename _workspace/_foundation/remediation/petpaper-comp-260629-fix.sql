-- ─────────────────────────────────────────────────────────────────────
-- 투명엽서019 PET 용지비 미적재 교정 — FIX (COMMIT·인간 승인 후에만 실행)
-- 권위: 인쇄상품 가격표 260527 "투명 PET 260g" 가격(국4절)=1,100 (verbatim)
-- DRY-RUN 선검증 완료(petpaper-comp-260629-dryrun.sql · INSERT 0 1 · ROLLBACK).
-- 검증 오라클: huniprinting.com 투명엽서(pcode=71) 100x150·투명PET·단면칼라4도+화이트
--             qty120 → 공급가 75,500원. COMMIT 후 시뮬레이터 골든 재계산으로 일치 확인.
-- [HARD] 이 파일은 인간 승인 후에만 psql -f 로 실행. undo = 아래 mat_cd/comp_cd 행 삭제.
-- ─────────────────────────────────────────────────────────────────────
BEGIN;

INSERT INTO t_prc_component_prices
       (comp_price_id, comp_cd, plt_siz_cd, mat_cd, min_qty, unit_price, apply_ymd)
SELECT (SELECT COALESCE(MAX(comp_price_id), 0) + 1 FROM t_prc_component_prices),
       'COMP_PAPER', 'SIZ_000499', 'MAT_000178', 1, 1100, '2026-06-01'
WHERE NOT EXISTS (
    SELECT 1 FROM t_prc_component_prices
    WHERE comp_cd = 'COMP_PAPER' AND mat_cd = 'MAT_000178'
      AND plt_siz_cd = 'SIZ_000499' AND min_qty = 1);

SELECT comp_cd, plt_siz_cd, mat_cd, min_qty, unit_price
  FROM t_prc_component_prices
 WHERE comp_cd = 'COMP_PAPER' AND mat_cd = 'MAT_000178';

COMMIT;

-- UNDO (필요 시):
-- DELETE FROM t_prc_component_prices
--  WHERE comp_cd='COMP_PAPER' AND mat_cd='MAT_000178' AND plt_siz_cd='SIZ_000499' AND min_qty=1;
