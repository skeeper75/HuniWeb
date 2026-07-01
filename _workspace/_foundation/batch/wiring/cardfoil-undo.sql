-- ════════════════════════════════════════════════════════════════════════
-- cardfoil-undo.sql  (2026-07-01)  — cardfoil-fix 적용분 되돌림
-- 실 COMMIT 후 회귀 시 사용. 배선 6행 삭제 + 코너 prc_typ 원복(.03→.01).
-- ★ 코너 prc_typ 원복은 형제 과대청구 버그를 되살리므로, 정상 상황에서는 원복하지 말 것
--   (배선 삭제만 하고 .03 은 유지 권장). prc_typ 원복은 전면 롤백 시에만.
-- ════════════════════════════════════════════════════════════════════════
BEGIN;

-- 배선 삭제 (본 트랙이 추가한 것만)
DELETE FROM t_prc_formula_components
 WHERE (frm_cd, comp_cd) IN (
   ('PRF_NAMECARD_PREMIUM',      'COMP_PP_VARTEXT_1EA'),
   ('PRF_NAMECARD_PREMIUM',      'COMP_PP_VARIMG_1EA'),
   ('PRF_NAMECARD_PREMIUM',      'COMP_PP_CORNER_RIGHT'),
   ('PRF_NAMECARD_PREMIUM_FOIL', 'COMP_PP_VARTEXT_1EA'),
   ('PRF_NAMECARD_PREMIUM_FOIL', 'COMP_PP_VARIMG_1EA'),
   ('PRF_NAMECARD_PREMIUM_FOIL', 'COMP_PP_CORNER_RIGHT')
 );

-- prc_typ 원복은 전면 롤백 시에만 주석 해제(형제 과대청구 부활 주의)
-- UPDATE t_prc_price_components SET prc_typ_cd='PRICE_TYPE.01', upd_dt=now()
--  WHERE comp_cd='COMP_PP_CORNER_RIGHT' AND prc_typ_cd='PRICE_TYPE.03';

-- ROLLBACK;  -- 검증용
COMMIT;
