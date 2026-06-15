-- =====================================================================
-- apply.sql  (round-13 정정 트랙 · D-1b · 단일 트랜잭션 래퍼)
-- 권위: phase-b-d1b-remediation.md §2·§3 — 그대로 실행본화.
-- 순서(FK/도메인 선행): step 00 base_code(PRICE_TYPE.03) → step 01 comp prc_typ UPDATE.
--   base_code가 먼저여야 prc_typ_cd='PRICE_TYPE.03'가 도메인상 유효.
--
-- [HARD] 이 파일은 BEGIN으로 열기만 한다. COMMIT/ROLLBACK은 로더(apply_loader.sh)가 주입.
--        기본 = ROLLBACK(DRY-RUN). 실 COMMIT은 --commit(인간 승인) 시에만.
--        파일 자체에 COMMIT 없음 — 사고로도 커밋되지 않게 함.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;
  \echo '[step 00] base_code PRICE_TYPE.03 멱등 선적재'
  \i 00_preload_price_type_03.sql
  \echo '[step 01] 그룹① 13 comp prc_typ .01 -> .03 멱등 UPDATE (단가행 불변)'
  \i 01_update_comp_prctyp.sql
-- 트랜잭션 종료(COMMIT/ROLLBACK)는 로더가 주입. 기본 ROLLBACK.
