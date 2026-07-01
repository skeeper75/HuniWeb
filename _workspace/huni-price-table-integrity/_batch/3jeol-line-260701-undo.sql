-- =====================================================================
-- UNDO — 3절 라인 3상품(030/049/112) 적재 전면 취소 — 2026-07-01
-- 신규 행 물리삭제(안전) / 논리삭제분 복원. 실행 순서 무관(독립).
-- =====================================================================
BEGIN;
-- 단가행(신규) 삭제
DELETE FROM t_prc_component_prices WHERE plt_siz_cd='SIZ_000475'
  AND note LIKE '%260701%' OR (plt_siz_cd='SIZ_000475' AND note LIKE '%3절carry260701%');

-- 공식 바인딩 삭제
DELETE FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000030','PRD_000049','PRD_000112')
   AND frm_cd IN ('PRF_DGP_C','PRF_DGP_E','PRF_DGP_F','PRF_DGP_INNER');

-- PROC_000004 바인딩 삭제
DELETE FROM t_prd_product_processes
 WHERE prd_cd IN ('PRD_000030','PRD_000049','PRD_000112') AND proc_cd='PROC_000004';

-- 049 완제품 사이즈 링크 삭제
DELETE FROM t_prd_product_sizes WHERE prd_cd='PRD_000049' AND siz_cd='SIZ_000055';

-- 자재 3절 교정 복원(3절 신규 삭제 + 비-3절 논리삭제 해제)
DELETE FROM t_prd_product_materials WHERE prd_cd='PRD_000030' AND mat_cd='MAT_000110';
DELETE FROM t_prd_product_materials WHERE prd_cd='PRD_000049'
   AND mat_cd IN ('MAT_000083','MAT_000093','MAT_000110','MAT_000111','MAT_000112');
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL
 WHERE prd_cd='PRD_000030' AND mat_cd='MAT_000105';
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL
 WHERE prd_cd='PRD_000049' AND mat_cd IN ('MAT_000078','MAT_000091','MAT_000105','MAT_000107','MAT_000109');
ROLLBACK;
-- COMMIT;
