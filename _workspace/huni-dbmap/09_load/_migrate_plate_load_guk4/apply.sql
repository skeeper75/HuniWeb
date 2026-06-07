-- =====================================================================
-- apply.sql — 국4절 plate 적재 단일 트랜잭션 래퍼 (FK 위상순: plate DELETE/INSERT → siz soft-delete)
--   [R2] 전체가 하나의 BEGIN…COMMIT. 임의 문 실패 시 ON_ERROR_STOP → 전체 롤백(부분적재 없음).
--   기본 실행은 apply.sh 가 끝 COMMIT 을 ROLLBACK 으로 치환(DRY-RUN). --commit 일 때만 실제 COMMIT.
--   순서 강제: 1) plate DELETE/INSERT  2) siz soft-delete (plate→siz RESTRICT 때문에 plate 교정 선행).
--   신규 siz / DDL 없음(316x467=SIZ_000499 재사용). 가격(component_prices) 미터치.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;
  \i 01_plate_correction_guk4.sql
  \i 02_worksize_orphan_cleanup.sql
COMMIT;
