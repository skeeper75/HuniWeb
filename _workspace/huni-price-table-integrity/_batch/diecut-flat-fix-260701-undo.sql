BEGIN;
UPDATE t_prc_price_components SET prc_typ_cd='PRICE_TYPE.01', upd_dt=now()
 WHERE comp_cd='COMP_CUT_FULL_DIECUT' AND prc_typ_cd='PRICE_TYPE.03';
COMMIT;
