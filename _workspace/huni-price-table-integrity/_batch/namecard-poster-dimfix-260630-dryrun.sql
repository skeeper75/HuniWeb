-- 차원정합 MISSING-HIGH 교정 dryrun — 프리미엄명함·포스터·아크릴 (260630)
-- §26 dim_conformance.py MISSING-HIGH 적발분, 권위(가격표260527·acrylic) 대조 후 교정.
-- 라이브 읽기전용 원칙 — 본 스크립트는 BEGIN…ROLLBACK(미적재). 실 적재는 인간 승인 후 ROLLBACK→COMMIT.
-- 단가행 신규 id = MAX(78967)+1 = 78968~. apply_ymd='2026-06-01'(기존 동일).
-- 명세: namecard-poster-dimfix-260630.md

\set ON_ERROR_STOP on
BEGIN;

-- ── 사전 상태 ───────────────────────────────────────────────
\echo '=== BEFORE: 132 레더 단가행(소형4 누락) ==='
SELECT siz_cd, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_LEATHER_FRAME' ORDER BY siz_cd;
\echo '=== BEFORE: 135 족자 단가행(A1 누락) + product_sizes 293 ==='
SELECT siz_cd, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_JOKJA' ORDER BY siz_cd;
SELECT siz_cd, COALESCE(del_yn,'N') FROM t_prd_product_sizes WHERE prd_cd='PRD_000135' AND siz_cd IN ('SIZ_000293','SIZ_000294');
\echo '=== BEFORE: 163 미니파츠 단가행(0건) ==='
SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_MINIPART_TBD';
\echo '=== BEFORE: 031 고아 option_items(노출중) ==='
SELECT opt_cd, ref_key1, COALESCE(del_yn,'N') FROM t_prd_product_option_items WHERE prd_cd='PRD_000031' AND opt_cd IN ('OPV_000148','OPV_000159');

-- ── #2 PRD_132 레더아트액자: 단가행 4건 INSERT (권위 B15) ──────
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, min_qty, unit_price, note) VALUES
 (78968,'COMP_POSTER_LEATHER_FRAME','2026-06-01','SIZ_000304',1, 9000,'레더아트액자 5x5 수량 1 이상 완제품가[출력+가공 포함가]'),
 (78969,'COMP_POSTER_LEATHER_FRAME','2026-06-01','SIZ_000306',1,10000,'레더아트액자 5x7 수량 1 이상 완제품가[출력+가공 포함가]'),
 (78970,'COMP_POSTER_LEATHER_FRAME','2026-06-01','SIZ_000308',1,11000,'레더아트액자 8x8 수량 1 이상 완제품가[출력+가공 포함가]'),
 (78971,'COMP_POSTER_LEATHER_FRAME','2026-06-01','SIZ_000310',1,13000,'레더아트액자 8x10 수량 1 이상 완제품가[출력+가공 포함가]');

-- ── #4 PRD_163 아크릴미니파츠: 단가행 1건 INSERT (권위 acrylic row103·단일설정) ──
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, min_qty, unit_price, note) VALUES
 (78972,'COMP_ACRYL_MINIPART_TBD','2026-06-01','SIZ_000365',1,10000,'아크릴미니파츠 120x50 수량 1 이상 완제품가[조합형 투명아크릴1.5mm 배면양면 10조각]');

-- ── #3 PRD_135 족자포스터: dedup 재지정(293→294 정본) + A1 단가행 INSERT (권위 B17) ──
UPDATE t_prd_product_sizes SET siz_cd='SIZ_000294', upd_dt=now()
 WHERE prd_cd='PRD_000135' AND siz_cd='SIZ_000293' AND COALESCE(del_yn,'N')<>'Y';
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, min_qty, unit_price, note) VALUES
 (78973,'COMP_POSTER_JOKJA','2026-06-01','SIZ_000294',1,22000,'족자포스터 A1 수량 1 이상 완제품가[출력+코팅+가공(사각족자/원형족자) 포함가]');

-- ── #1 PRD_031 프리미엄명함: 권위무근거 잔여고아 option_items 논리삭제 ──
-- (앙상블210=MAT_099·리브스디자인250=MAT_119 — 자재/단가행은 031 COMMIT서 이미 삭제됨. 옵션 정리만 누락)
UPDATE t_prd_product_option_items SET del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000031' AND opt_cd IN ('OPV_000148','OPV_000159') AND COALESCE(del_yn,'N')<>'Y';

-- ── 사후 검증 ───────────────────────────────────────────────
\echo '=== AFTER: 132 레더 단가행(6사이즈 완비) ==='
SELECT siz_cd, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_LEATHER_FRAME' ORDER BY siz_cd;
\echo '=== AFTER: 135 족자 단가행(A1 추가) + product_sizes(294 정본) ==='
SELECT siz_cd, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_JOKJA' ORDER BY siz_cd;
SELECT siz_cd FROM t_prd_product_sizes WHERE prd_cd='PRD_000135' AND COALESCE(del_yn,'N')<>'Y' ORDER BY siz_cd;
\echo '=== AFTER: 163 미니파츠 단가행(1건) ==='
SELECT siz_cd, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_MINIPART_TBD';
\echo '=== AFTER: 031 고아 option_items(삭제됨) ==='
SELECT opt_cd, ref_key1, COALESCE(del_yn,'N') FROM t_prd_product_option_items WHERE prd_cd='PRD_000031' AND opt_cd IN ('OPV_000148','OPV_000159');

-- DB 미적재 — 검증만. 실 적재는 인간 승인 후 ROLLBACK→COMMIT 전환.
ROLLBACK;
\echo '=== ROLLBACK 완료(미적재). 실 COMMIT은 인간 승인 후. ==='
