-- acryl-bysiz-157-fix.sql — 아크릴 등록사이즈 가격모델 시범(157) 실제 저장(COMMIT)
BEGIN;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, note)
VALUES ('COMP_ACRYL_3T_BYSIZ','투명아크릴3T 완제품가(등록사이즈)','PRC_COMPONENT_TYPE.06','PRICE_TYPE.01',
        '["siz_cd","min_qty"]','Y','등록사이즈 정확매칭. 단가=아크릴 가격표 면적그리드 도출(ceiling). 자재 투명3mm 단일.');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, note)
VALUES ('PRF_ACRYL_BYSIZ','투명아크릴3T 등록사이즈 공식','Y','투명아크릴 등록사이즈 상품(네임택·키링·코스터·스탠드·판아크릴 등) 공유.');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_ACRYL_BYSIZ','COMP_ACRYL_3T_BYSIZ',1,'Y');
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note)
VALUES ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000148',NULL,1,5900,'아크릴네임택 60x60 — 면적표 60x60'),
       ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000012',NULL,1,7800,'아크릴네임택 55x86 — 면적표 60x90(ceiling)');
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000157' AND frm_cd='PRF_ACRYL_BYSIZ';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000157','PRF_ACRYL_BYSIZ','2026-06-27','아크릴네임택 등록사이즈 가격모델(siz_cd 정확매칭).');
DO $$ DECLARE v6 numeric; v8 numeric; BEGIN
  SELECT unit_price INTO v6 FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_3T_BYSIZ' AND siz_cd='SIZ_000148';
  SELECT unit_price INTO v8 FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_3T_BYSIZ' AND siz_cd='SIZ_000012';
  IF v6<>5900 OR v8<>7800 THEN RAISE EXCEPTION '검증 실패 %/%',v6,v8; END IF;
  RAISE NOTICE '저장 OK: 157 60x60=5900·55x86=7800';
END $$;
COMMIT;
