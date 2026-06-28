-- 밴드총액 .01 ×수량 과대청구 교정 DRYRUN (ROLLBACK 종결·실DB 변경 0)
-- FINDING-bandtotal-x-qty-overcharge.md. 단가행 verbatim 불변·prc_typ만 .01→.02.
\set ON_ERROR_STOP on
BEGIN;
-- 대상: 명함 완제품가 + 봉투 + 합판 (밴드총액·min_qty>1·.01)
CREATE TEMP TABLE _tgt(comp_cd text) ON COMMIT DROP;
INSERT INTO _tgt VALUES
 ('COMP_NAMECARD_STD_S1'),('COMP_NAMECARD_STD_S2'),
 ('COMP_NAMECARD_PEARL_S1'),('COMP_NAMECARD_PEARL_S2'),
 ('COMP_NAMECARD_SHAPE_S1'),('COMP_NAMECARD_SHAPE_S2'),
 ('COMP_NAMECARD_MINISHAPE_S1'),('COMP_NAMECARD_MINISHAPE_S2'),
 ('COMP_NAMECARD_FOIL_S1_STD'),('COMP_NAMECARD_CLEAR_S1'),
 ('COMP_ENV_MAKING'),('COMP_GANGPAN_PRINT'),                       -- ↑ 바인딩 12(긴급)
 ('COMP_NAMECARD_FOIL_S2_STD'),('COMP_NAMECARD_FOIL_S1_HOLO'),('COMP_NAMECARD_FOIL_S2_HOLO'),
 ('COMP_NAMECARD_COAT_S1'),('COMP_NAMECARD_COAT_S2'),
 ('COMP_NAMECARD_PREMIUM_S1_MGA'),('COMP_NAMECARD_PREMIUM_S1_MGB'),
 ('COMP_NAMECARD_PREMIUM_S2_MGA'),('COMP_NAMECARD_PREMIUM_S2_MGB'),
 ('COMP_NAMECARD_WHITE_S1W_CL'),('COMP_NAMECARD_WHITE_S1W_NOCL'),
 ('COMP_NAMECARD_WHITE_S2W_CL'),('COMP_NAMECARD_WHITE_S2W_NOCL');  -- ↑ 미바인딩 12(잠재·예방)
\echo '--- BEFORE (대상 prc_typ 분포) ---'
SELECT coalesce(prc_typ_cd,'NULL') pt, count(*) FROM t_prc_price_components WHERE comp_cd IN (SELECT comp_cd FROM _tgt) GROUP BY 1;
UPDATE t_prc_price_components SET prc_typ_cd='PRICE_TYPE.02', upd_dt=now()
 WHERE comp_cd IN (SELECT comp_cd FROM _tgt) AND coalesce(prc_typ_cd,'PRICE_TYPE.01')='PRICE_TYPE.01';
\echo '--- AFTER (.02 되어야) ---'
SELECT coalesce(prc_typ_cd,'NULL') pt, count(*) FROM t_prc_price_components WHERE comp_cd IN (SELECT comp_cd FROM _tgt) GROUP BY 1;
\echo '--- DRYRUN: ROLLBACK (실변경 0) ---'
ROLLBACK;
