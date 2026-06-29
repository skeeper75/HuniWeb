-- ============================================================
-- 출력소재(IMPORT) 용지 절가 → COMP_PAPER 단가행 적재본 (생성측 산출물)
-- [HARD] 인간 승인 전 COMMIT 금지. 게이트 + 검토 후 dbmap COMMIT.
-- 권위 = 인쇄상품 가격표 출력소재(IMPORT) 시트 (절대). 가격(국4절/3절) 절가 verbatim.
-- 멱등 = NULL-safe NOT EXISTS 가드 (기적재 60행 미터치).
-- search-before-mint = 전 용지 기존 mat_cd 매칭(mint 0). 라이브 읽기전용 스냅샷 기준.
-- 생성: paper_import_match.py + paper_import_sql.py (결정론·재실행 가능)
-- 컬럼 = 라이브 COMP_PAPER 60행 패턴 미러 (comp_cd,apply_ymd,mat_cd,min_qty,unit_price,note,plt_siz_cd,reg_dt)
-- ============================================================

BEGIN;

-- ① 신규 mat_cd: 없음 (search-before-mint 전건 기존 자재 매칭)

-- ② COMP_PAPER 국4절(SIZ_000499) 절가 verbatim INSERT
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000144', 1, 1100, '용지비 투명 PET 260g 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000144' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000145', 1, 1300, '용지비 투명 PET 350g 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000145' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000147', 1, 1100, '용지비 반투명 PET 260g 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000147' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000148', 1, 1300, '용지비 반투명 PET 350g 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000148' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000071', 1, 136, '용지비 백색모조지 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000071' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000153', 1, 219, '용지비 유포스티커 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000153' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000084', 1, 152, '용지비 비코팅스티커 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000084' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000155', 1, 217, '용지비 무광코팅스티커 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000155' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000156', 1, 217, '용지비 유광코팅스티커 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000156' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000158', 1, 167, '용지비 미색매트지 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000158' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000160', 1, 175, '용지비 리무벌아트지 90g 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000160' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000161', 1, 175, '용지비 수분리스티커 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000161' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000162', 1, 1300, '용지비 투명스티커 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000162' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000163', 1, 936, '용지비 홀로그램스티커 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000163' AND plt_siz_cd = 'SIZ_000499'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000164', 1, 312, '용지비 크라프트 스티커 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000499', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000164' AND plt_siz_cd = 'SIZ_000499'
);

-- ③ COMP_PAPER 3절(SIZ_000077) 절가 verbatim INSERT
--    ★confirm-3절: 라이브 3절 단가행 선례 0 — 전용 '(3절)' 자재 + plt_siz_cd=SIZ_000077(300x625) 추론.
--    사람이 plt_siz_cd / 자재 선택 확인 후 COMMIT.
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000083', 1, 89.54, '용지비 아트지 150g (3절) 3절(300x625) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000077', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000083' AND plt_siz_cd = 'SIZ_000077'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000093', 1, 149.22, '용지비 스노우지 250g (3절) 3절(300x625) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000077', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000093' AND plt_siz_cd = 'SIZ_000077'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000110', 1, 147.84, '용지비 몽블랑 130g (3절) 3절(300x625) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000077', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000110' AND plt_siz_cd = 'SIZ_000077'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000111', 1, 216.08, '용지비 몽블랑 190g (3절) 3절(300x625) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000077', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000111' AND plt_siz_cd = 'SIZ_000077'
);

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)
SELECT 'COMP_PAPER', '2026-06-01', 'MAT_000112', 1, 272.9466667, '용지비 몽블랑 240g (3절) 3절(300x625) 절가 — 실제 청구는 출력매수만큼 자동 계산', 'SIZ_000077', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_PAPER' AND apply_ymd = '2026-06-01'
    AND mat_cd = 'MAT_000112' AND plt_siz_cd = 'SIZ_000077'
);

-- 적재 대상: 국4절 15행 + 3절 5행 = 20행 (verbatim·멱등)

ROLLBACK;  -- DRY-RUN: 적재 가능성·멱등 실증, DB 미반영.
