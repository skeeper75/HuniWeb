-- ============================================================
-- 가격테이블 무결성 교정 적재본 (생성측 산출물 · 결정론 배치)
-- [HARD] 인간 승인 전 COMMIT 금지. 게이트(골든 시뮬)+codex 스냅샷 교차 후 dbmap COMMIT.
-- 권위=인쇄상품 가격표 260527(절대). 단가 verbatim. 라이브 읽기전용·스냅샷 기준.
-- 생성: build_load.py (결정론·재실행 가능)
-- ============================================================

-- 코팅 유광(COMP_COAT_GLOSSY) verbatim sparse fill (92행) — comp 존재·단가행 0
-- DRY-RUN: BEGIN…ROLLBACK
BEGIN;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1, 2000, '코팅(국4절)/유광코팅/단면 출력매수 1장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 2, 1500, '코팅(국4절)/유광코팅/단면 출력매수 2장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 5, 1200, '코팅(국4절)/유광코팅/단면 출력매수 5장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 10, 1000, '코팅(국4절)/유광코팅/단면 출력매수 10장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 20, 800, '코팅(국4절)/유광코팅/단면 출력매수 20장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 30, 800, '코팅(국4절)/유광코팅/단면 출력매수 30장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 40, 700, '코팅(국4절)/유광코팅/단면 출력매수 40장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 50, 700, '코팅(국4절)/유광코팅/단면 출력매수 50장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 70, 600, '코팅(국4절)/유광코팅/단면 출력매수 70장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 100, 500, '코팅(국4절)/유광코팅/단면 출력매수 100장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 150, 400, '코팅(국4절)/유광코팅/단면 출력매수 150장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 200, 300, '코팅(국4절)/유광코팅/단면 출력매수 200장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 250, 300, '코팅(국4절)/유광코팅/단면 출력매수 250장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 300, 250, '코팅(국4절)/유광코팅/단면 출력매수 300장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 400, 200, '코팅(국4절)/유광코팅/단면 출력매수 400장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 500, 180, '코팅(국4절)/유광코팅/단면 출력매수 500장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 700, 160, '코팅(국4절)/유광코팅/단면 출력매수 700장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 900, 140, '코팅(국4절)/유광코팅/단면 출력매수 900장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1000, 130, '코팅(국4절)/유광코팅/단면 출력매수 1000장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1500, 120, '코팅(국4절)/유광코팅/단면 출력매수 1500장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 2500, 110, '코팅(국4절)/유광코팅/단면 출력매수 2500장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 5000, 100, '코팅(국4절)/유광코팅/단면 출력매수 5000장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1000000, 100, '코팅(국4절)/유광코팅/단면 출력매수 1000000장 이상', 'PROC_000014', 1, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1, 4000, '코팅(국4절)/유광코팅/양면 출력매수 1장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 2, 3000, '코팅(국4절)/유광코팅/양면 출력매수 2장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 5, 2400, '코팅(국4절)/유광코팅/양면 출력매수 5장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 10, 2000, '코팅(국4절)/유광코팅/양면 출력매수 10장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 20, 1600, '코팅(국4절)/유광코팅/양면 출력매수 20장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 30, 1600, '코팅(국4절)/유광코팅/양면 출력매수 30장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 40, 1400, '코팅(국4절)/유광코팅/양면 출력매수 40장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 50, 1400, '코팅(국4절)/유광코팅/양면 출력매수 50장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 70, 1200, '코팅(국4절)/유광코팅/양면 출력매수 70장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 100, 1000, '코팅(국4절)/유광코팅/양면 출력매수 100장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 150, 800, '코팅(국4절)/유광코팅/양면 출력매수 150장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 200, 600, '코팅(국4절)/유광코팅/양면 출력매수 200장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 250, 600, '코팅(국4절)/유광코팅/양면 출력매수 250장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 300, 500, '코팅(국4절)/유광코팅/양면 출력매수 300장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 400, 400, '코팅(국4절)/유광코팅/양면 출력매수 400장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 500, 360, '코팅(국4절)/유광코팅/양면 출력매수 500장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 700, 320, '코팅(국4절)/유광코팅/양면 출력매수 700장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 900, 280, '코팅(국4절)/유광코팅/양면 출력매수 900장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1000, 260, '코팅(국4절)/유광코팅/양면 출력매수 1000장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1500, 240, '코팅(국4절)/유광코팅/양면 출력매수 1500장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 2500, 220, '코팅(국4절)/유광코팅/양면 출력매수 2500장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 5000, 200, '코팅(국4절)/유광코팅/양면 출력매수 5000장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1000000, 200, '코팅(국4절)/유광코팅/양면 출력매수 1000000장 이상', 'PROC_000014', 2, 'SIZ_000499', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1, 3000, '코팅(3절)/유광코팅/단면 출력매수 1장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 2, 2500, '코팅(3절)/유광코팅/단면 출력매수 2장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 5, 2000, '코팅(3절)/유광코팅/단면 출력매수 5장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 10, 1500, '코팅(3절)/유광코팅/단면 출력매수 10장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 20, 1200, '코팅(3절)/유광코팅/단면 출력매수 20장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 30, 1200, '코팅(3절)/유광코팅/단면 출력매수 30장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 40, 1050, '코팅(3절)/유광코팅/단면 출력매수 40장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 50, 1050, '코팅(3절)/유광코팅/단면 출력매수 50장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 70, 900, '코팅(3절)/유광코팅/단면 출력매수 70장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 100, 750, '코팅(3절)/유광코팅/단면 출력매수 100장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 150, 600, '코팅(3절)/유광코팅/단면 출력매수 150장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 200, 450, '코팅(3절)/유광코팅/단면 출력매수 200장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 250, 450, '코팅(3절)/유광코팅/단면 출력매수 250장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 300, 380, '코팅(3절)/유광코팅/단면 출력매수 300장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 400, 300, '코팅(3절)/유광코팅/단면 출력매수 400장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 500, 270, '코팅(3절)/유광코팅/단면 출력매수 500장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 700, 240, '코팅(3절)/유광코팅/단면 출력매수 700장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 900, 210, '코팅(3절)/유광코팅/단면 출력매수 900장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1000, 200, '코팅(3절)/유광코팅/단면 출력매수 1000장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1500, 180, '코팅(3절)/유광코팅/단면 출력매수 1500장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 2500, 170, '코팅(3절)/유광코팅/단면 출력매수 2500장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 5000, 150, '코팅(3절)/유광코팅/단면 출력매수 5000장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1000000, 150, '코팅(3절)/유광코팅/단면 출력매수 1000000장 이상', 'PROC_000014', 1, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1, 6000, '코팅(3절)/유광코팅/양면 출력매수 1장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 2, 5000, '코팅(3절)/유광코팅/양면 출력매수 2장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 5, 4000, '코팅(3절)/유광코팅/양면 출력매수 5장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 10, 3000, '코팅(3절)/유광코팅/양면 출력매수 10장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 20, 2400, '코팅(3절)/유광코팅/양면 출력매수 20장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 30, 2400, '코팅(3절)/유광코팅/양면 출력매수 30장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 40, 2100, '코팅(3절)/유광코팅/양면 출력매수 40장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 50, 2100, '코팅(3절)/유광코팅/양면 출력매수 50장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 70, 1800, '코팅(3절)/유광코팅/양면 출력매수 70장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 100, 1500, '코팅(3절)/유광코팅/양면 출력매수 100장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 150, 1200, '코팅(3절)/유광코팅/양면 출력매수 150장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 200, 900, '코팅(3절)/유광코팅/양면 출력매수 200장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 250, 900, '코팅(3절)/유광코팅/양면 출력매수 250장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 300, 760, '코팅(3절)/유광코팅/양면 출력매수 300장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 400, 600, '코팅(3절)/유광코팅/양면 출력매수 400장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 500, 540, '코팅(3절)/유광코팅/양면 출력매수 500장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 700, 480, '코팅(3절)/유광코팅/양면 출력매수 700장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 900, 420, '코팅(3절)/유광코팅/양면 출력매수 900장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1000, 400, '코팅(3절)/유광코팅/양면 출력매수 1000장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1500, 360, '코팅(3절)/유광코팅/양면 출력매수 1500장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 2500, 340, '코팅(3절)/유광코팅/양면 출력매수 2500장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 5000, 300, '코팅(3절)/유광코팅/양면 출력매수 5000장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) VALUES ('COMP_COAT_GLOSSY', '2026-06-01', 1000000, 300, '코팅(3절)/유광코팅/양면 출력매수 1000000장 이상', 'PROC_000014', 2, 'SIZ_000077', now())
  ON CONFLICT DO NOTHING;  -- 멱등
ROLLBACK;  -- 항상 롤백
