-- 제본비 comp 3종(중철/무선/PUR) del_yn=Y→N 복원 (정합 교정).
-- 근거: 4 기본 책자(068 중철/069 무선/070 PUR/071 트윈링) 중 트윈링(COMP_BIND_TWINRING)은 del=N으로 정상 노출·작동.
--   중철/무선/PUR은 동일 역할(각자 전용 공식이 자기 제본비 1개만 가산·오염 없음·06-29 remediation으로 0원→정상 확인)인데
--   하드커버/캘린더 폐기 일괄 del_yn=Y에 휩쓸린 재편 잔재 → 트윈링과 동일하게 노출 복원.
-- 단가행·바인딩 불변. 엔진은 del_yn 미필터(어드민 가격뷰어 표시만 복원). 사용자 승인: "분리 유지 + del_yn=N 복원".
BEGIN;
UPDATE t_prc_price_components SET del_yn='N', upd_dt=now()
 WHERE comp_cd IN ('COMP_BIND_JUNGCHEOL','COMP_BIND_MUSEON','COMP_BIND_PUR') AND del_yn='Y';
COMMIT;
