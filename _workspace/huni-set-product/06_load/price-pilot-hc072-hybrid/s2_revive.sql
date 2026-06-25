-- ============================================================================
-- 072 하드커버책자 하이브리드 — COMP_PRINT_DIGITAL_S2 부활 (양면 내지 단가 복원)
-- 생성: hsp-set-designer 2026-06-25 · DB 미적재(인간 승인 후 dbmap 트랙)
-- 근거: inner-print-comp-arbitration §4 (S2=양면·단가 verbatim·부작용0·참조 활성공식0)
-- 부활 = comp 헤더 del_yn 토글만. 단가행(component_prices 212행) INSERT/수정 0건.
-- BEGIN/COMMIT 미내장(load-executor가 트랜잭션 래핑).
-- ============================================================================

-- 멱등: del_yn='Y' 조건부 UPDATE → 2회 실행해도 1회만 적용.
UPDATE t_prc_price_components
   SET del_yn = 'N'
 WHERE comp_cd = 'COMP_PRINT_DIGITAL_S2'
   AND del_yn = 'Y';

-- 검증(롤백전 확인): del_yn='N'·단가행 212 불변 기대.
-- SELECT comp_cd, del_yn FROM t_prc_price_components WHERE comp_cd='COMP_PRINT_DIGITAL_S2';
-- SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_DIGITAL_S2';  -- 212
