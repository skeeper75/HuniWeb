-- dosu-load-draft.sql — 디지털인쇄 흑백 도수 적재 초안 [갈래 A: clr_cd] (DRYRUN · DB 미적재)
-- 산출: hpe-engine-designer 2026-06-29 · 권위 verbatim(디지털인쇄비 시트) · 날조 0
-- ★[HARD] 실 COMMIT 금지 — 인간 승인 후 dbmap(dbm-load-execution) 위임. BEGIN…ROLLBACK 검증 전용.
-- 모델 = 갈래 A(도수=clr_cd · 흑백 CLR_000002 / 칼라 CLR_000005 · proc_cd는 둘 다 PROC_000004).
--
-- ★선결[개발팀 C트랙]: pricing.py:42 NON_QTY_DIMS 튜플에 "clr_cd" 추가(우리 적용 안 함·명세만).
--   미적용 시 엔진이 clr_cd를 매칭 차원으로 안 봄 → 흑백/칼라 분기 안 됨(전 행 와일드카드).
--
-- ★원자성 가드[HARD §6.3]: 칼라 UPDATE(NULL→CLR_000005) + 흑백 INSERT(CLR_000002)를 같은 트랜잭션에.
--   칼라 NULL(와일드카드) 상태에서 흑백 명시값 INSERT만 하면 흑백 선택 시 칼라+흑백 둘 다 매칭 → ERR_AMBIGUOUS.

BEGIN;  -- ★DRYRUN: 끝에서 ROLLBACK. 절대 COMMIT 금지(인간 승인 전).

-- ============================================================
-- 1) COMP use_dims 에 clr_cd 등재 (UPDATE · blast radius 격리 스위치)
--    이 comp만 clr_cd 판별 → 디지털만 도수 분기, 비디지털 comp 무영향.
-- ============================================================
UPDATE t_prc_price_components
   SET use_dims = '["proc_cd", "plt_siz_cd", "print_opt_cd", "min_qty", "clr_cd", "proc_grp:PROC_000001"]',
       upd_dt = now()
 WHERE comp_cd = 'COMP_PRINT_DIGITAL_S1'
   AND use_dims NOT LIKE '%clr_cd%';   -- 멱등(이미 등재 시 skip)

-- ============================================================
-- 2) 기존 칼라 212행 clr_cd 채움 (UPDATE NULL→CLR_000005) — 단가 불변·컬럼만
--    멱등: clr_cd IS NULL 인 칼라 행만.
-- ============================================================
UPDATE t_prc_component_prices
   SET clr_cd = 'CLR_000005', upd_dt = now()
 WHERE comp_cd = 'COMP_PRINT_DIGITAL_S1'
   AND proc_cd = 'PROC_000004'
   AND clr_cd IS NULL;

-- ============================================================
-- 3) 흑백 단가행 212행 INSERT (권위 verbatim · clr_cd=CLR_000002 · proc_cd=PROC_000004)
--    멱등키 = (comp_cd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, apply_ymd)
-- ============================================================
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 1, 3000,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=1 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 1, 4000,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 1장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=1 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 2, 2000,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 2장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=2 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 2, 2900,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 2장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=2 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 3, 1600,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 3장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=3 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 3, 2500,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 3장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=3 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 4, 1400,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 4장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=4 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 4, 2200,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 4장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=4 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 5, 1200,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 5장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=5 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 5, 2000,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 5장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=5 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 6, 900,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 6장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=6 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 6, 1900,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 6장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=6 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 7, 800,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 7장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=7 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 7, 1700,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 7장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=7 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 8, 700,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 8장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=8 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 8, 1500,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 8장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=8 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 9, 600,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 9장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=9 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 9, 1300,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 9장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=9 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 10, 500,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 10장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=10 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 10, 1200,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 10장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=10 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 15, 450,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 15장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=15 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 15, 900,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 15장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=15 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 20, 400,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 20장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=20 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 20, 800,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 20장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=20 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 25, 350,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 25장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=25 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 25, 700,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 25장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=25 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 30, 300,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 30장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=30 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 30, 600,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 30장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=30 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 35, 280,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 35장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=35 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 35, 560,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 35장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=35 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 40, 250,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 40장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=40 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 40, 500,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 40장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=40 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 45, 250,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 45장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=45 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 45, 500,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 45장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=45 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 50, 250,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 50장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=50 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 50, 500,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 50장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=50 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 60, 200,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 60장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=60 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 60, 400,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 60장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=60 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 70, 200,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 70장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=70 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 70, 400,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 70장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=70 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 80, 200,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 80장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=80 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 80, 400,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 80장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=80 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 90, 200,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 90장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=90 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 90, 400,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 90장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=90 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 100, 200,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 100장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=100 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 100, 400,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 100장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=100 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 150, 140,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 150장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=150 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 150, 280,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 150장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=150 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 200, 130,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 200장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=200 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 200, 260,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 200장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=200 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 250, 120,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 250장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=250 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 250, 240,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 250장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=250 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 300, 110,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 300장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=300 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 300, 220,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 300장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=300 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 350, 100,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 350장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=350 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 350, 200,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 350장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=350 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 400, 90,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 400장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=400 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 400, 180,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 400장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=400 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 450, 80,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 450장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=450 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 450, 160,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 450장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=450 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 500, 70,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 500, 140,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 600, 70,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 600장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=600 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 600, 140,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 600장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=600 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 700, 70,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 700장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=700 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 700, 140,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 700장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=700 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 800, 70,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 800장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=800 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 800, 140,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 800장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=800 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 900, 70,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 900장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=900 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 900, 140,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 900장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=900 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 1000, 70,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=1000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 1000, 140,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 1000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=1000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 1200, 70,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1200장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=1200 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 1200, 140,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 1200장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=1200 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 1400, 65,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1400장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=1400 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 1400, 130,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 1400장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=1400 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 1600, 65,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1600장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=1600 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 1600, 130,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 1600장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=1600 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 1800, 60,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1800장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=1800 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 1800, 120,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 1800장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=1800 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 2000, 60,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 2000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=2000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 2000, 120,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 2000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=2000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 2500, 55,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 2500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=2500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 2500, 110,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 2500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=2500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 3000, 55,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 3000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=3000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 3000, 110,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 3000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=3000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 3500, 50,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 3500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=3500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 3500, 100,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 3500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=3500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 4000, 50,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 4000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=4000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 4000, 100,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 4000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=4000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 4500, 45,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 4500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=4500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 4500, 90,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 4500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=4500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 5000, 45,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 5000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=5000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 5000, 90,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 5000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=5000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 6000, 40,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 6000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=6000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 6000, 80,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 6000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=6000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 7000, 40,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 7000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=7000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 7000, 80,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 7000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=7000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 8000, 40,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 8000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=8000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 8000, 80,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 8000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=8000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 9000, 40,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 9000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=9000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 9000, 80,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 9000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=9000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 10000, 40,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 10000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=10000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 10000, 80,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 10000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=10000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000001', 'CLR_000002', 1000000, 40,
       '디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1000000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=1000000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000499', 'POPT_000002', 'CLR_000002', 1000000, 80,
       '디지털인쇄 출력비(국4절)/흑백(1도)/양면 출력매수 1000000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=1000000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 1, 3500,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=1 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 1, 5000,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 1장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=1 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 2, 2500,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 2장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=2 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 2, 2900,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 2장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=2 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 3, 2000,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 3장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=3 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 3, 2500,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 3장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=3 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 4, 1800,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 4장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=4 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 4, 2200,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 4장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=4 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 5, 1200,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 5장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=5 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 5, 2000,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 5장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=5 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 6, 900,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 6장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=6 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 6, 1900,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 6장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=6 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 7, 800,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 7장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=7 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 7, 1700,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 7장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=7 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 8, 700,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 8장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=8 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 8, 1500,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 8장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=8 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 9, 600,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 9장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=9 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 9, 1300,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 9장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=9 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 10, 500,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 10장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=10 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 10, 1200,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 10장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=10 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 15, 610,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 15장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=15 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 15, 1200,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 15장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=15 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 20, 540,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 20장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=20 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 20, 1080,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 20장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=20 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 25, 470,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 25장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=25 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 25, 950,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 25장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=25 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 30, 410,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 30장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=30 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 30, 810,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 30장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=30 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 35, 380,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 35장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=35 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 35, 760,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 35장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=35 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 40, 340,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 40장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=40 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 40, 680,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 40장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=40 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 45, 340,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 45장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=45 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 45, 680,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 45장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=45 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 50, 340,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 50장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=50 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 50, 680,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 50장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=50 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 60, 270,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 60장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=60 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 60, 540,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 60장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=60 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 70, 270,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 70장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=70 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 70, 540,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 70장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=70 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 80, 270,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 80장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=80 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 80, 540,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 80장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=80 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 90, 270,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 90장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=90 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 90, 540,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 90장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=90 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 100, 270,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 100장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=100 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 100, 540,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 100장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=100 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 150, 190,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 150장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=150 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 150, 380,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 150장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=150 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 200, 180,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 200장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=200 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 200, 350,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 200장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=200 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 250, 160,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 250장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=250 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 250, 330,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 250장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=250 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 300, 150,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 300장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=300 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 300, 300,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 300장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=300 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 350, 140,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 350장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=350 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 350, 270,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 350장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=350 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 400, 120,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 400장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=400 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 400, 250,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 400장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=400 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 450, 110,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 450장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=450 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 450, 220,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 450장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=450 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 500, 95,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 500, 190,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 600, 95,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 600장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=600 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 600, 190,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 600장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=600 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 700, 95,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 700장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=700 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 700, 190,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 700장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=700 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 800, 95,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 800장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=800 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 800, 190,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 800장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=800 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 900, 95,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 900장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=900 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 900, 190,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 900장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=900 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 1000, 95,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=1000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 1000, 190,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 1000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=1000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 1200, 95,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1200장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=1200 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 1200, 190,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 1200장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=1200 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 1400, 88,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1400장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=1400 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 1400, 180,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 1400장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=1400 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 1600, 88,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1600장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=1600 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 1600, 180,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 1600장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=1600 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 1800, 81,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1800장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=1800 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 1800, 160,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 1800장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=1800 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 2000, 81,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 2000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=2000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 2000, 160,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 2000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=2000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 2500, 75,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 2500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=2500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 2500, 150,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 2500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=2500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 3000, 75,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 3000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=3000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 3000, 150,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 3000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=3000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 3500, 68,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 3500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=3500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 3500, 135,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 3500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=3500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 4000, 68,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 4000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=4000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 4000, 135,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 4000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=4000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 4500, 61,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 4500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=4500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 4500, 122,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 4500장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=4500 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 5000, 61,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 5000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=5000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 5000, 122,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 5000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=5000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 6000, 54,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 6000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=6000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 6000, 108,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 6000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=6000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 7000, 54,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 7000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=7000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 7000, 108,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 7000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=7000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 8000, 54,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 8000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=8000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 8000, 108,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 8000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=8000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 9000, 54,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 9000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=9000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 9000, 108,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 9000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=9000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 10000, 54,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 10000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=10000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 10000, 108,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 10000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=10000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000001', 'CLR_000002', 1000000, 54,
       '디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1000000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001' AND min_qty=1000000 AND apply_ymd='2026-06-01');
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, clr_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_PRINT_DIGITAL_S1', '2026-06-01', 'PROC_000004', 'SIZ_000077', 'POPT_000002', 'CLR_000002', 1000000, 108,
       '디지털인쇄 출력비(3절)/흑백(1도)/양면 출력매수 1000000장 이상', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002'
    AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000002' AND min_qty=1000000 AND apply_ymd='2026-06-01');

-- ============================================================
-- 4) 상품 도수 옵션그룹/아이템 (예시 1상품 — 프리미엄엽서 PRD_000016)
--    실제는 흑백 판매 상품마다 반복(§5.4 ~15상품·실무진 컨펌 C-4 후 범위 확정).
--    ★ option_items.ref_dim_cd=clr_cd 주입 연결 라이브 작동 시뮬레이터 선결(C-3).
--    ★ dflt=칼라(CLR_000005) — 미선택 견적불가 가드(R-A3).
-- ============================================================
-- (스켈레톤 — opt_grp_cd/opt_cd 채번은 dbmap 적재 시 MAX+1. 구조만.)
-- INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note, reg_dt, del_yn)
--   VALUES ('PRD_000016', '<NEW_OPT_GRP>', '도수', 'SEL_TYPE.01', 1, 1, 'Y', 0, 'Y', '인쇄도수 택1(흑백/칼라). ref clr_cd.', now(), 'N');
-- INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, use_yn, reg_dt, del_yn)
--   VALUES ('PRD_000016', '<NEW_OPT>', 1, 'clr_cd', 'CLR_000005', 'Y', now(), 'N'),  -- 칼라(dflt)
--          ('PRD_000016', '<NEW_OPT>', 2, 'clr_cd', 'CLR_000002', 'Y', now(), 'N');  -- 흑백

-- ============================================================
-- 검증 쿼리 (ROLLBACK 전 확인)
-- ============================================================
-- use_dims 에 clr_cd 등재 확인:
SELECT use_dims FROM t_prc_price_components WHERE comp_cd='COMP_PRINT_DIGITAL_S1';
-- 칼라 행 clr_cd 채움(=212·CLR_000005 기대):
SELECT count(*) AS color_filled FROM t_prc_component_prices
 WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000005';
-- 흑백 행(=212·CLR_000002 기대):
SELECT count(*) AS bw_rows FROM t_prc_component_prices
 WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND proc_cd='PROC_000004' AND clr_cd='CLR_000002';
-- NULL clr_cd 디지털 행 남았나(=0 기대·전부 채워짐):
SELECT count(*) AS null_left FROM t_prc_component_prices
 WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND clr_cd IS NULL;
-- 골든 셀(국4절 단면 흑백 qty1=3000 기대):
SELECT unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND clr_cd='CLR_000002'
   AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=1;
-- 골든 셀(국4절 단면 칼라 qty1=4000 기대):
SELECT unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND clr_cd='CLR_000005'
   AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000001' AND min_qty=1;

ROLLBACK;  -- ★DRYRUN 종료 — 절대 COMMIT 금지(인간 승인 전 dbmap 위임).
