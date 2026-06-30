-- 완칼커팅 COMP_CUT_FULL_DIECUT 단가형→고정금액 교정 — LOAD (COMMIT)
-- 권위: 키스톤 line47 커팅비=[출력매수]×2000[커팅테이블]·단가행 note "고정 금액(수량 곱하지 않음)".
-- 결함: 단가형(.01)+plate-based → unit_price(브래킷총액)×판수 이중적용(023=8,040,000·046=1,350,000).
BEGIN;
UPDATE t_prc_price_components SET prc_typ_cd='PRICE_TYPE.03', upd_dt=now()
 WHERE comp_cd='COMP_CUT_FULL_DIECUT' AND prc_typ_cd='PRICE_TYPE.01';
COMMIT;
