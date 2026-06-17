-- B2_korotto_comp.sql — 코롯토 구성요소 신설 (search-before-mint: 라이브 COMP_ACRYL_COROTTO 부재 확인)
-- prc_typ .01 단가형(개당 면적단가·min_qty 무관·CLEAR3T .02 min_qty 함정 회피)·use_dims [siz_width,siz_height] WH 동형.
-- 멱등: comp_cd PK NOT EXISTS 가드.
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn, reg_dt)
SELECT 'COMP_ACRYL_COROTTO', '아크릴코롯토 인쇄가공비', 'PRC_COMPONENT_TYPE.01', 'PRICE_TYPE.01',
       '["siz_width", "siz_height"]'::jsonb, 'Y', 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_COROTTO');
