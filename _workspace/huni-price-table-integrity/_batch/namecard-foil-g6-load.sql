-- namecard-foil-g6-load.sql — 명함박(PRD_000037) G6 1셀 오적재 교정
-- 결함: COMP_NAMECARD_FOIL_S1_STD / _S2_STD 1000구간 = 63,000 → 권위(소형 일반박 E등급 1000) = 64,000.
-- 증거: 두 comp 단가 전 행이 가격표 박(소형) B03 일반박 E열(M열)과 verbatim 일치(8/9 셀 정확),
--       1000구간 1셀만 63,000(권위 small-l1.csv M18=64,000). 단순 1자리 전사오류(이 빠진 적재).
-- 단가 verbatim: 64,000은 권위값 그대로 복사(날조 0). 동판비(SETUP 5,000)는 별도 comp라 미터치.
-- 멱등: unit_price=63000인 행만 64000으로 갱신 → 재실행 시 0행 영향(NO-OP).
-- 범위: S1_STD(PRF_NAMECARD_FOIL 바인딩·라이브 견적 영향) + S2_STD(미바인딩이나 동일 결함·일관성).
--       HOLO(특수박 E=92,000)·SETUP(5,000)은 권위 일치 → 미터치.
-- [HARD] 인간 승인 후에만 COMMIT. 현재 COMMIT 주석 — 실행 시 BEGIN…ROLLBACK(dryrun) 또는 승인 후 COMMIT.
BEGIN;

UPDATE t_prc_component_prices
   SET unit_price = 64000, upd_dt = now()
 WHERE comp_cd IN ('COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S2_STD')
   AND min_qty  = 1000
   AND unit_price = 63000;   -- 멱등 가드: 이미 64000이면 0행

-- 사후 확인(승인 실행 시 2행 64000.00 기대):
-- SELECT comp_cd, min_qty, unit_price FROM t_prc_component_prices
--  WHERE comp_cd IN ('COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S2_STD') AND min_qty=1000;

-- COMMIT;   -- ← 인간 승인 후 주석 해제. 미승인 상태에서는 ROLLBACK 으로 끝낼 것.
ROLLBACK;
