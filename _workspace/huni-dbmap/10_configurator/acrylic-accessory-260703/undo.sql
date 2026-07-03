-- =====================================================================
-- 아크릴 부속 갭 통합 교정 undo.sql  (load.sql COMMIT 시 원상복구)
-- 실행 전 반드시 물리 백업. 논리삭제(del_yn) 원칙 — 물리 DELETE는 이번 신규 mint 행만.
-- =====================================================================
BEGIN;

-- [GB-1 역] 151 바인딩 제거 (load에서 INSERT한 행)
DELETE FROM t_prd_product_price_formulas
 WHERE prd_cd='PRD_000151' AND frm_cd='PRF_CLR_ACRYL' AND apply_bgn_ymd='2026-06-28';

-- [GB-2 역] 재바인딩 원복 (전용공식 → 본체전용)
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_CLR_ACRYL', upd_dt=now() WHERE prd_cd='PRD_000147' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_ACRYL_MAGNET';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_CLR_ACRYL', upd_dt=now() WHERE prd_cd='PRD_000148' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_ACRYL_BADGE';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_CLR_ACRYL', upd_dt=now() WHERE prd_cd='PRD_000149' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_ACRYL_CLIP';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_CLR_ACRYL', upd_dt=now() WHERE prd_cd='PRD_000150' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_ACRYL_SMARTTOK';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_CLR_ACRYL', upd_dt=now() WHERE prd_cd='PRD_000152' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_ACRYL_NAMETAG';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_CLR_ACRYL', upd_dt=now() WHERE prd_cd='PRD_000154' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_ACRYL_HAIRBAND';

-- [GB-2 역] 옵션 9행 제거 (load 신규 mint 행)
DELETE FROM t_prd_product_options WHERE (prd_cd,opt_cd) IN (
  ('PRD_000147','OPV_000465'),
  ('PRD_000148','OPV_000467'),('PRD_000148','OPV_000466'),
  ('PRD_000149','OPV_000468'),
  ('PRD_000150','OPV_000469'),('PRD_000150','OPV_000470'),
  ('PRD_000152','OPV_000471'),('PRD_000152','OPV_000472'),
  ('PRD_000154','OPV-000028'));

-- [GB-2 역] 옵션그룹 6행 제거 (load 신규 mint 행)
DELETE FROM t_prd_product_option_groups WHERE (prd_cd,opt_grp_cd) IN (
  ('PRD_000147','OPT_000074'),('PRD_000148','OPT_000075'),('PRD_000149','OPT_000076'),
  ('PRD_000150','OPT_000077'),('PRD_000152','OPT_000078'),('PRD_000154','OPT-000014'));

-- [GB-3 역] 146 자재 오염 원복 (MAT_000043 재삭제 · MAT_000386 재활성)
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000146' AND mat_cd='MAT_000043' AND usage_cd='USAGE.07';
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000146' AND mat_cd='MAT_000386' AND usage_cd='USAGE.07';

ROLLBACK;  -- 검증 전용. 실 원복 시 COMMIT.
