-- ============================================================================
-- namecard-034-pearl-undo.sql — 펄명함(034) 교정 역연산
--   추가한 4종 단가행(240·128·129·241 × 단면/양면 = 8행) + 바인딩 1행 제거.
--   기존 대표코드 127·130 행은 애초에 미터치했으므로 복원 불요.
--   ※ apply_ymd 2026-06-01 의 8행은 fix 가 추가한 것(원래는 127·130만 존재).
-- ============================================================================
BEGIN;

DELETE FROM t_prd_product_price_formulas
 WHERE prd_cd='PRD_000034' AND frm_cd='PRF_NAMECARD_PEARL';

DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2')
   AND print_opt_cd IN ('POPT_000001','POPT_000002')
   AND min_qty = 100
   AND mat_cd IN ('MAT_000240','MAT_000128','MAT_000129','MAT_000241');

-- 검증: 원상태(대표코드 127·130 의 4행만 잔존)
DO $$
DECLARE v_new int; v_orig int;
BEGIN
  SELECT COUNT(*) INTO v_new FROM t_prc_component_prices
   WHERE comp_cd LIKE 'COMP_NAMECARD_PEARL%'
     AND mat_cd IN ('MAT_000240','MAT_000128','MAT_000129','MAT_000241');
  SELECT COUNT(*) INTO v_orig FROM t_prc_component_prices
   WHERE comp_cd LIKE 'COMP_NAMECARD_PEARL%' AND mat_cd IN ('MAT_000127','MAT_000130');
  IF v_new <> 0 THEN RAISE EXCEPTION 'undo 실패: 신규 자재행 %건 잔존', v_new; END IF;
  IF v_orig <> 4 THEN RAISE EXCEPTION 'undo 경고: 대표코드 행 %건(기대 4)', v_orig; END IF;
  RAISE NOTICE 'undo OK: 신규 8행+바인딩 제거·대표코드 127/130 4행 보존';
END $$;

COMMIT;
