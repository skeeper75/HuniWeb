-- [임시 테스트용] 157 아크릴네임택 → PRF_CLR_ACRYL 바인딩(버그 재현 목적). 확인 후 즉시 unbind.
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000157' AND frm_cd='PRF_CLR_ACRYL';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000157','PRF_CLR_ACRYL','2026-06-27','[임시테스트] siz_cd×면적 버그 재현용 — 확인 후 unbind');
COMMIT;
