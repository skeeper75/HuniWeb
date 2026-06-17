-- L4 공식 배선 (PRF_POSTER_LINEN ← COMP_POSTEROPT_LINEN_FINISH·disp_seq=10·addtn_yn=Y)
-- ============================================================================
-- 린넨 공식에 마감가공 add-on comp 배선. 기존 disp_seq 1~9 점유(본체·오시·귀돌이2·가변2·별색2·미싱) → 10 신규.
-- 엔진(G-D2 패턴): 사용자 마감옵션 선택(opt_cd) → COMP_POSTEROPT_LINEN_FINISH 매칭 단가 가산.
--   미선택/오버로크(0원)=가산 0. addtn_yn 은 엔진 무참조(메타). 동시매칭 0(opt_cd 단일 매칭).
-- 멱등: (frm_cd,comp_cd) NOT EXISTS 가드.
-- ============================================================================
INSERT INTO t_prc_formula_components
  (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT v.frm_cd, v.comp_cd, v.disp_seq, 'Y', now()
FROM (VALUES
  ('PRF_POSTER_LINEN','COMP_POSTEROPT_LINEN_FINISH',10)
) AS v(frm_cd, comp_cd, disp_seq)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components fc
   WHERE fc.frm_cd = v.frm_cd AND fc.comp_cd = v.comp_cd
);
