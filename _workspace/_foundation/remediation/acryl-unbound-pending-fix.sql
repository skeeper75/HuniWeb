-- acryl-unbound-pending-fix.sql — 미바인딩 7종 "단가/구성 확인필요" 시그널 바인딩 (코드0·DB only·라이브 COMMIT 후보)
-- 배경: 7종 가격공식 0(견적불가). 권위 단가 부재/구성 미설정(미세격자15mm·투명8mm·사이즈0 등)이라 임의단가 금지(돈크리티컬).
--   미니파츠 동형: 단가행 없는 공유 구성요소 + 상품별 공식(메시지) 바인딩 → 시뮬레이터가 "확인필요" 노출. 실무진 해소.
-- 해소: 권위 확정 후 ① 정상 가격공식 바인딩 교체(예 area+사이즈라벨, by-siz) 또는 ② 단가행 추가.
-- ★실 COMMIT은 인간 승인 후·라이브 시뮬레이터 실증.
\set ON_ERROR_STOP on
BEGIN;

-- [1] 공유 "확인필요" 구성요소 (단가행 없음·use_dims 최소 → 항상 데이터없음 플래그)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT 'COMP_ACRYL_PENDING_TBD','단가/구성 확인필요 (실무진)','PRC_COMPONENT_TYPE.01','PRICE_TYPE.02', jsonb_build_array('min_qty'),'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_PENDING_TBD');

-- [2] 상품별 공식 (frm_nm=구체 갭 메시지·시뮬레이터 공식명 노출)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT v.frm_cd, v.frm_nm, '미바인딩 해소 시그널 — 권위 확정 후 정상 공식/단가 교체', 'Y'
FROM (VALUES
  ('PRF_ACRYL_ZIBITZ_TBD',   '아크릴지비츠 (★본체 미세격자15mm·가공 슈츠참 단가 확인필요)'),
  ('PRF_ACRYL_PHCOROTTO_TBD', '포카코롯토 (★투명8mm 55x86 단가 확인필요)'),
  ('PRF_ACRYL_3DCOROTTO_TBD', '아크릴입체코롯토 (★사이즈/자재/단가 미설정)'),
  ('PRF_ACRYL_3DBLOCK_TBD',   '아크릴입체블럭 (★단가 확인필요)'),
  ('PRF_ACRYL_SHAKER_TBD',    '아크릴쉐이커 (★자재/단가 확인필요)'),
  ('PRF_ACRYL_ZIBITZ2_TBD',   '지비츠★ (★사이즈/자재/단가 미설정)'),
  ('PRF_ACRYL_SHCOROTTO_TBD', '아크릴쉐이커코롯토 (★구성/단가 미설정)')
) AS v(frm_cd, frm_nm)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd=v.frm_cd);

-- [3] formula_components (전부 공유 PENDING comp)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT v.frm_cd, 'COMP_ACRYL_PENDING_TBD', 1, 'N'
FROM (VALUES ('PRF_ACRYL_ZIBITZ_TBD'),('PRF_ACRYL_PHCOROTTO_TBD'),('PRF_ACRYL_3DCOROTTO_TBD'),
             ('PRF_ACRYL_3DBLOCK_TBD'),('PRF_ACRYL_SHAKER_TBD'),('PRF_ACRYL_ZIBITZ2_TBD'),('PRF_ACRYL_SHCOROTTO_TBD')) AS v(frm_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd=v.frm_cd AND fc.comp_cd='COMP_ACRYL_PENDING_TBD');

-- [4] 바인딩
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT v.prd_cd, v.frm_cd, '2026-06-28', '미바인딩 해소 시그널(실무진 확인 필요)'
FROM (VALUES
  ('PRD_000156','PRF_ACRYL_ZIBITZ_TBD'),('PRD_000165','PRF_ACRYL_PHCOROTTO_TBD'),
  ('PRD_000168','PRF_ACRYL_3DCOROTTO_TBD'),('PRD_000169','PRF_ACRYL_3DBLOCK_TBD'),
  ('PRD_000170','PRF_ACRYL_SHAKER_TBD'),('PRD_000171','PRF_ACRYL_ZIBITZ2_TBD'),
  ('PRD_000226','PRF_ACRYL_SHCOROTTO_TBD')
) AS v(prd_cd, frm_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas pf WHERE pf.prd_cd=v.prd_cd AND pf.frm_cd=v.frm_cd);

COMMIT;
