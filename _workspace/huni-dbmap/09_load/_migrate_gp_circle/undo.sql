-- =====================================================================
-- GP 원형 마이그레이션 역실행 (undo.sql)
--   추가한 100 GP 가격 + 11 066 size link + 등록 10 siz 를 제거한다. 단일 트랜잭션.
--   기본 ROLLBACK(undo.sh DRY-RUN). --commit=인간 승인.
--   제거순 = 적재 역순(자식 먼저): prices → size link → siz. FK 안전.
--   35mm(SIZ_000422)는 committed 분이라 절대 건드리지 않음(siz 501~510 한정).
--
--   [수정 2026-06-07] comp_price_id 명시 폐지(auto-IDENTITY 전환)에 따라 가격 DELETE 를
--   자연키(comp_cd=COMP_GANGPAN_PRINT + siz 501~510)로 전환. id 를 모르므로 PK IN 불가.
--   35mm(SIZ_000422)는 siz IN 절에서 제외되므로 committed 분 보존 — 안전.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;

-- 1) GP 원형 가격 100행 제거 — 자연키(comp_cd + 신규 siz 501~510)로 정밀.
--    35mm(SIZ_000422)는 IN 절에서 빠지므로 committed 분 무간섭.
DELETE FROM t_prc_component_prices
 WHERE comp_cd = 'COMP_GANGPAN_PRINT' AND siz_cd IN ('SIZ_000501', 'SIZ_000502', 'SIZ_000503', 'SIZ_000504', 'SIZ_000505', 'SIZ_000506', 'SIZ_000507', 'SIZ_000508', 'SIZ_000509', 'SIZ_000510');

-- 2) 066 size link 중 신규 siz(501~510)분만 제거 — 35mm(SIZ_000422) link 는 보존(재사용 권위).
DELETE FROM t_prd_product_sizes WHERE prd_cd = 'PRD_000066' AND siz_cd IN ('SIZ_000501', 'SIZ_000502', 'SIZ_000503', 'SIZ_000504', 'SIZ_000505', 'SIZ_000506', 'SIZ_000507', 'SIZ_000508', 'SIZ_000509', 'SIZ_000510');

-- 3) 등록한 10 원형 siz 제거 (참조 prices/link 제거 후라 FK 안전).
DELETE FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000501', 'SIZ_000502', 'SIZ_000503', 'SIZ_000504', 'SIZ_000505', 'SIZ_000506', 'SIZ_000507', 'SIZ_000508', 'SIZ_000509', 'SIZ_000510');

COMMIT;
