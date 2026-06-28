-- 밴드총액 .01 ×수량 과대청구 교정 — 바인딩 12건 한정 COMMIT(인간 승인 후 실행·실DB 변경)
-- FINDING-bandtotal-x-qty-overcharge.md. 단가행 verbatim 불변·prc_typ만 .01→.02.
-- 사용자 승인(2026-06-28): 바인딩 12건만 먼저 COMMIT(현재 과대청구분). 미바인딩 13건은 후속.
\set ON_ERROR_STOP on
BEGIN;
CREATE TEMP TABLE _tgt(comp_cd text) ON COMMIT DROP;
INSERT INTO _tgt VALUES
 ('COMP_NAMECARD_STD_S1'),('COMP_NAMECARD_STD_S2'),
 ('COMP_NAMECARD_PEARL_S1'),('COMP_NAMECARD_PEARL_S2'),
 ('COMP_NAMECARD_SHAPE_S1'),('COMP_NAMECARD_SHAPE_S2'),
 ('COMP_NAMECARD_MINISHAPE_S1'),('COMP_NAMECARD_MINISHAPE_S2'),
 ('COMP_NAMECARD_FOIL_S1_STD'),('COMP_NAMECARD_CLEAR_S1'),
 ('COMP_ENV_MAKING'),('COMP_GANGPAN_PRINT');   -- 바인딩 12(긴급·현재 과대청구)
\echo '--- BEFORE (대상 prc_typ 분포) ---'
SELECT coalesce(prc_typ_cd,'NULL') pt, count(*) FROM t_prc_price_components WHERE comp_cd IN (SELECT comp_cd FROM _tgt) GROUP BY 1;
UPDATE t_prc_price_components SET prc_typ_cd='PRICE_TYPE.02', upd_dt=now()
 WHERE comp_cd IN (SELECT comp_cd FROM _tgt) AND coalesce(prc_typ_cd,'PRICE_TYPE.01')='PRICE_TYPE.01';
\echo '--- AFTER (.02 되어야·12행) ---'
SELECT coalesce(prc_typ_cd,'NULL') pt, count(*) FROM t_prc_price_components WHERE comp_cd IN (SELECT comp_cd FROM _tgt) GROUP BY 1;
\echo '--- COMMIT: 실 적용 ---'
COMMIT;
