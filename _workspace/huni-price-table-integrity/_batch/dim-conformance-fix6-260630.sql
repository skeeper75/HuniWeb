-- 차원정합 MISSING/UNDECLARED-HIGH 교정 6건 (2026-06-30)
-- §26 dim_conformance.py 적발 → 3 진단가 권위대조 → dryrun 검증 완료분.
-- 전부 견적불가/저청구(돈 새는 방향) 해소. id 78968~ (현 MAX 78967).
-- 실행: BEGIN…(ROLLBACK 검증)→COMMIT. undo=각 역연산.
\set ON_ERROR_STOP on
BEGIN;

-- #1 PRD_132 레더아트액자: 권위 포스터사인 B15 소형4 단가행 누락 → INSERT 4
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, min_qty, unit_price, note) VALUES
 (78968,'COMP_POSTER_LEATHER_FRAME','2026-06-01','SIZ_000304',1, 9000,'레더아트액자 5x5 수량 1 이상 완제품가[출력+가공 포함가]'),
 (78969,'COMP_POSTER_LEATHER_FRAME','2026-06-01','SIZ_000306',1,10000,'레더아트액자 5x7 수량 1 이상 완제품가[출력+가공 포함가]'),
 (78970,'COMP_POSTER_LEATHER_FRAME','2026-06-01','SIZ_000308',1,11000,'레더아트액자 8x8 수량 1 이상 완제품가[출력+가공 포함가]'),
 (78971,'COMP_POSTER_LEATHER_FRAME','2026-06-01','SIZ_000310',1,13000,'레더아트액자 8x10 수량 1 이상 완제품가[출력+가공 포함가]');

-- #2 PRD_163 아크릴미니파츠: 권위 acrylic row103 단일설정 고정가 → INSERT 1
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, min_qty, unit_price, note) VALUES
 (78972,'COMP_ACRYL_MINIPART_TBD','2026-06-01','SIZ_000365',1,10000,'아크릴미니파츠 120x50 수량 1 이상 완제품가[조합형 투명아크릴1.5mm 배면양면 10조각]');

-- #3 PRD_135 족자: dedup 재지정(293 삭제본→294 정본) + 권위 B17 A1 단가행 INSERT
UPDATE t_prd_product_sizes SET siz_cd='SIZ_000294', upd_dt=now()
 WHERE prd_cd='PRD_000135' AND siz_cd='SIZ_000293' AND COALESCE(del_yn,'N')<>'Y';
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, min_qty, unit_price, note) VALUES
 (78973,'COMP_POSTER_JOKJA','2026-06-01','SIZ_000294',1,22000,'족자포스터 A1 수량 1 이상 완제품가[출력+코팅+가공 포함가]');

-- #4 PRD_031 프리미엄명함: 권위무근거 자재(MAT_099/119) 잔여 고아 option_items 논리삭제
UPDATE t_prd_product_option_items SET del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000031' AND opt_cd IN ('OPV_000148','OPV_000159') AND COALESCE(del_yn,'N')<>'Y';

-- #5 PRD_032 코팅명함: print_opt_cd 미선언 → 단면/양면 드롭다운 미노출(견적0). use_dims 배선 추가
UPDATE t_prc_price_components SET use_dims='["mat_cd","min_qty","print_opt_cd"]'::jsonb, upd_dt=now()
 WHERE comp_cd IN ('COMP_NAMECARD_COAT_S1','COMP_NAMECARD_COAT_S2');

-- #6 PRD_124 린넨: 단가행 상수 proc_cd(PROC_000080)가 매칭 깸 → 마감비 silent 드롭(저청구). proc_cd→NULL
UPDATE t_prc_component_prices SET proc_cd=NULL, upd_dt=now()
 WHERE comp_cd='COMP_POSTEROPT_LINEN_FINISH' AND proc_cd IS NOT NULL;

-- ── 사후 검증 ──
\echo '=== 132 레더(6사이즈) ==='
SELECT siz_cd, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_LEATHER_FRAME' ORDER BY siz_cd;
\echo '=== 135 족자(A1 294) + 163 미니파츠 ==='
SELECT comp_cd, siz_cd, unit_price FROM t_prc_component_prices WHERE comp_cd IN ('COMP_POSTER_JOKJA','COMP_ACRYL_MINIPART_TBD') ORDER BY comp_cd, siz_cd;
\echo '=== 032 use_dims (print_opt_cd 포함) ==='
SELECT comp_cd, use_dims FROM t_prc_price_components WHERE comp_cd IN ('COMP_NAMECARD_COAT_S1','COMP_NAMECARD_COAT_S2');
\echo '=== 124 린넨 proc_cd(NULL) ==='
SELECT proc_cd, count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_POSTEROPT_LINEN_FINISH' GROUP BY proc_cd;
\echo '=== 031 고아옵션(삭제) ==='
SELECT opt_cd, COALESCE(del_yn,'N') FROM t_prd_product_option_items WHERE prd_cd='PRD_000031' AND opt_cd IN ('OPV_000148','OPV_000159');

ROLLBACK;
\echo '=== ROLLBACK (DRY-RUN) ==='
