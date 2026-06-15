-- apply.sql — 016 note 교정 단일 트랜잭션 래퍼
-- 기본 = DRY-RUN: 로더(apply_loader.sh)가 끝에 ROLLBACK 주입. --commit 시에만 COMMIT.
-- [HARD] note 컬럼만 변경. 중간 COMMIT 없음(원자성).
\set ON_ERROR_STOP on
BEGIN;
  \i 01_update_notes.sql
-- COMMIT/ROLLBACK 미포함 — 로더가 주입(기본 ROLLBACK).
