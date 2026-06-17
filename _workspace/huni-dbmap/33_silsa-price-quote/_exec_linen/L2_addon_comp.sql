-- L2 마감가공 add-on 구성요소 신규 (COMP_POSTEROPT_LINEN_FINISH)
-- ============================================================================
-- 1 add-on comp·use_dims=["opt_cd"](option_item 과 1:1·복합 자연 표현·proc 5신규 회피).
-- comp_typ_cd=PRC_COMPONENT_TYPE.06(완제품/add-on 통가·sibling COMP_POSTEROPT_* 동일).
-- prc_typ_cd=PRICE_TYPE.01(단가형). search-before-mint: 라이브 부재 확인 → 신규 1.
-- 멱등: comp_cd PK NOT EXISTS 가드.
-- ============================================================================
INSERT INTO t_prc_price_components
  (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, note, use_yn, del_yn, reg_dt)
SELECT v.comp_cd, v.comp_nm, 'PRC_COMPONENT_TYPE.06', 'PRICE_TYPE.01',
       '["opt_cd"]'::jsonb, v.note, 'Y', 'N', now()
FROM (VALUES
  ('COMP_POSTEROPT_LINEN_FINISH','린넨 마감가공비','린넨패브릭포스터 마감가공(오버로크/말아박기/봉미싱·복합) 옵션 단가·opt_cd 매칭')
) AS v(comp_cd, comp_nm, note)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_price_components c WHERE c.comp_cd = v.comp_cd
);
