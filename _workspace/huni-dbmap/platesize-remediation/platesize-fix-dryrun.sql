-- 판형 오매핑 교정 (결정론 생성·gen_fix.py)
-- [HARD] 인간 승인 전 COMMIT 금지. 단가 무관·plate_size siz_cd만 교정.
\set ON_ERROR_STOP on
BEGIN;
-- PRD_000051 썬캡: 판형 SIZ_000195 → SIZ_000499 (미스매치 comp: COMP_CUT_FULL_DIECUT,COMP_PAPER,COMP_PRINT_DIGITAL_S1)
UPDATE t_prd_product_plate_sizes SET siz_cd='SIZ_000499', upd_dt=now() WHERE prd_cd='PRD_000051' AND siz_cd='SIZ_000195' AND del_yn='N';
-- 사후검증:
SELECT prd_cd, siz_cd, dflt_plt_yn FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000051') AND del_yn='N' ORDER BY prd_cd;
ROLLBACK;
