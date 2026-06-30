-- ================================================================
-- 069 무선·070 PUR 완전 동작화 — 실 COMMIT 래핑본 (단일 트랜잭션)
-- 생성: hsp-load-executor 2026-07-01 · 게이트 GO + codex reconcile + 인간 승인("지금 둘 다 COMMIT")
-- 적재본 SQL은 BEGIN/COMMIT 미내장 → 여기서 단일 트랜잭션 래핑(FK 위상순 069→070)
-- DRY-RUN 통과: 제약위반 0·멱등 delta 0·FK 고아 0·baseline 복귀 실증
-- 선행: booklet-museon-pur-069-070-backup.sql (bak_*_setbuild_20260701_0204) 실행 완료
-- ================================================================
\set ON_ERROR_STOP on
BEGIN;

\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/06_load/booklet-museon-069-load.sql
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/06_load/booklet-pur-070-load.sql

COMMIT;
