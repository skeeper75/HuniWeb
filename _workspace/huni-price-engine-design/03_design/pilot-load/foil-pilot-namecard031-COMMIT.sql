-- foil-pilot-namecard031-COMMIT.sql — 인간 승인 실 COMMIT 버전 (2026-06-30)
-- 권위: 사용자 명시 승인(foil pilot + namecard G6 동시 COMMIT). undo=foil-pilot-namecard031-undo.sql.
-- body 와 동일한 NOT EXISTS NULL-safe 멱등 가드(재실행 NO-OP). ON_ERROR_STOP 으로 부분실패 시 전체 롤백.
-- [REAL COMMIT] BEGIN … \i body … COMMIT. dryrun(ROLLBACK)=foil-pilot-namecard031-load.sql 별도 보존.
\set ON_ERROR_STOP on
SET client_min_messages = warning;
BEGIN;

\i foil-pilot-namecard031-body.sql

COMMIT;
