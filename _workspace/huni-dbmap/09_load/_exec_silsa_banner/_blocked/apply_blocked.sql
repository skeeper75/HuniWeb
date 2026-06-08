-- =====================================================================
-- _blocked/apply_blocked.sql — siz 77 등록 + 77 area-cell 활성화 (인간 승인 후)
--   [HARD] 기본 apply.sql 경로 밖. siz 등록(master-data)=인간 승인 후에만 실행.
--   단일 트랜잭션·멱등. siz 선행(B01) → area-cell(B02).
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;
  \echo '>> [blocked] B01 t_siz_sizes register (77)'
  \i B01_t_siz_sizes.sql
  \echo '>> [blocked] B02 t_prc_component_prices area cells (77)'
  \i B02_t_prc_component_prices.sql
-- 기본 ROLLBACK. 실제 적재는 인간 승인 --commit.
