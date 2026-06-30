-- ================================================================
-- booklet-jungcheol-068 APPLY (단일 트랜잭션 래핑·실 COMMIT)
-- 게이트: 05_gate/gate-verdict-booklet-jungcheol-068.md (GO·조건부·2트랙) + 인간 승인 완료("지금 COMMIT 진행").
-- 백업: bak_*_setbuild_20260701_0134 (10테이블 스냅샷) + booklet-jungcheol-068-backup-20260701_0134.sql
-- DRY-RUN 입증: 제약위반0 · 멱등 2회차 delta0 · 복합PK 충돌0 · S8 오염0(비목3) · ROLLBACK 후 baseline 복귀.
-- 의존순서[HARD]: ②공식 PRF_BOOK_COVER(t_prc_*) → ①셋트행 바인딩(t_prd_*) — 적재본이 위상순 조립(5→6~9).
-- 효과: 068 표지 완전 동작화 — 셋트행 0→2(표지288+내지287) · 골든 158,688(표지88,688+제본70,000).
-- 적재본 = booklet-jungcheol-068-full-load.sql (BEGIN/COMMIT 미내장 — 본 apply 가 트랜잭션 래핑).
-- ================================================================
BEGIN;
\i booklet-jungcheol-068-full-load.sql
COMMIT;
