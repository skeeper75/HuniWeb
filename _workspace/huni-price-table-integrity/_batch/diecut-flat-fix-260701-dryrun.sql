-- 완칼커팅 COMP_CUT_FULL_DIECUT 과대청구 교정 — DRYRUN (BEGIN…ROLLBACK)
-- 결함: prc_typ=단가형(.01) + plate-based(use_dims=[plt_siz_cd,min_qty]) → unit_price(=출력매수 브래킷
--       총액) × 판수 이중적용 → 023 q800=8,040,000(=120,000×67판)·046=1,350,000(=50,000×27판) 과대청구.
-- 권위: 계산공식집 키스톤 line47 "커팅비=[출력매수]×2000원[커팅테이블]" + 단가행 note "작업 1건 고정
--       금액(수량을 곱하지 않음)" → 고정금액(.03)이 정답. 브래킷(출력매수 N 이상) 총액을 그대로 청구.
-- 영향: PRF_DGP_B(023 모양엽서·046 라벨택)·PRF_DGP_F(051 썬캡·현재 pansu0 무영향). 타 component 무관.
BEGIN;
UPDATE t_prc_price_components
   SET prc_typ_cd='PRICE_TYPE.03', upd_dt=now()
 WHERE comp_cd='COMP_CUT_FULL_DIECUT' AND prc_typ_cd='PRICE_TYPE.01';
SELECT comp_cd, prc_typ_cd FROM t_prc_price_components WHERE comp_cd='COMP_CUT_FULL_DIECUT';
ROLLBACK;
