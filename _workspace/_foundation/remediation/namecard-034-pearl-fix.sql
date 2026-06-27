-- ============================================================================
-- namecard-034-pearl-fix.sql — 펄명함(034) 자재 collapse 해소 + 바인딩
-- ----------------------------------------------------------------------------
-- 권위[HARD]: 인쇄상품 가격표 260527 명함포토카드 시트 B04(펄명함 스타드림).
--   가격표 컬럼 헤더가 4종 자재를 2개 동일가 그룹으로 묶음(B25 행):
--     그룹1(단면 9000 / 양면 10000): 다이아240 · 실버240 · 골드240
--     그룹2(단면 10000 / 양면 11000): 로츠쿼츠240
--
-- 결함: COMP_NAMECARD_PEARL_S1/S2 단가행이 가리키는 mat_cd(MAT_127 스타드림 대표·
--   MAT_130 로즈쿼츠)가 상품 034 제공 자재(MAT_240 다이아·128 실버·129 골드·241 로츠쿼츠)와
--   ★코드 불일치 → 4종 전부 no_match = 견적불가(033 STD 보다 심각: 전종 불가).
--   ★단가값(9000/10000·10000/11000)은 권위 B04 verbatim 정합. 결함은 자재 collapse뿐.
--
-- 교정 구조 = (b) 자재별 단가행 전개 (033 namecard-mat-fix 동형).
--   상품 제공 4종 mat_cd 행을 각 그룹가로 전개(8행). use_dims=[mat_cd,min_qty,print_opt_cd] 정합.
--   기존 대표코드 행(MAT_127·130)은 [HARD] 삭제금지 — 미터치(034 미제공이라 dead·무해·
--   _combo_key 에 mat_cd 포함되어 동시매칭 0). 130(로즈쿼츠)↔241(로츠쿼츠) 철자변형 동일자재
--   dedup 은 별도 트랙(§17).
--
-- 바인딩: 자재 collapse 해소 후 PRD_000034 → PRF_NAMECARD_PEARL (설계 보류분 GO).
--   PRF·배선·print_opt 태깅·use_dims 는 namecard-special 에서 이미 적재됨.
--
-- 멱등: comp_price_id=IDENTITY(자동). 034 제공 4종 자연키 DELETE 후 INSERT. 바인딩 멱등 DELETE.
--   재실행 안전(중복 0). search-before-mint: 신규 comp/mat/공식 mint 0(단가행+바인딩만).
-- 비고: 실 COMMIT 전 namecard-034-pearl-dryrun.sql 로 ROLLBACK 검증 후 인간 승인.
-- ============================================================================

BEGIN;

-- 1) 멱등: 034 제공 4 자재(240·128·129·241)의 PEARL 단가행만 재구성. 127·130 미터치.
DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2')
   AND print_opt_cd IN ('POPT_000001','POPT_000002')
   AND min_qty = 100
   AND mat_cd IN ('MAT_000240','MAT_000128','MAT_000129','MAT_000241');

-- 2) 권위 B04 그룹가로 4종 × 단면/양면 전개(8행). 단가 verbatim.
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, mat_cd, print_opt_cd, min_qty, unit_price, note)
VALUES
-- ── PEARL_S1 단면 (POPT_000001) ─────────────── 그룹1=9000(다이아/실버/골드), 그룹2=10000(로츠쿼츠)
('COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000240','POPT_000001',100, 9000.00,'펄명함(스타드림)/단면/다이아240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000128','POPT_000001',100, 9000.00,'펄명함(스타드림)/단면/실버240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000129','POPT_000001',100, 9000.00,'펄명함(스타드림)/단면/골드240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000241','POPT_000001',100,10000.00,'펄명함(스타드림)/단면/로츠쿼츠240 제작수량 100 이상'),
-- ── PEARL_S2 양면 (POPT_000002) ─────────────── 그룹1=10000, 그룹2=11000
('COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000240','POPT_000002',100,10000.00,'펄명함(스타드림)/양면/다이아240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000128','POPT_000002',100,10000.00,'펄명함(스타드림)/양면/실버240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000129','POPT_000002',100,10000.00,'펄명함(스타드림)/양면/골드240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000241','POPT_000002',100,11000.00,'펄명함(스타드림)/양면/로츠쿼츠240 제작수량 100 이상');

-- 3) 바인딩: 034 → PRF_NAMECARD_PEARL (자재 해소 후 GO). 멱등.
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000034' AND frm_cd='PRF_NAMECARD_PEARL';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000034','PRF_NAMECARD_PEARL','2026-06-27',
        'namecard-034: 펄명함 자재 collapse 해소(4종 전개) 후 바인딩. 단면 9000/10000·양면 10000/11000(권위 B04).');

-- 4) 사후검증(트랜잭션 내) — 4종 견적가능·동시매칭 0·권위가 일치·바인딩 1.
DO $$
DECLARE
  v_mats text[] := ARRAY['MAT_000240','MAT_000128','MAT_000129','MAT_000241'];
  v_mat text; v_cnt int; v_amb int; v_bind int;
  v_g1_s1 numeric; v_g2_s1 numeric; v_g1_s2 numeric; v_g2_s2 numeric;
BEGIN
  -- 견적가능: 단면·양면 각 4종 정확히 1행
  FOREACH v_mat IN ARRAY v_mats LOOP
    SELECT COUNT(*) INTO v_cnt FROM t_prc_component_prices
     WHERE comp_cd='COMP_NAMECARD_PEARL_S1' AND print_opt_cd='POPT_000001' AND min_qty=100 AND mat_cd=v_mat;
    IF v_cnt <> 1 THEN RAISE EXCEPTION '검증 실패: 단면 % 매칭행수=%(기대 1)', v_mat, v_cnt; END IF;
    SELECT COUNT(*) INTO v_cnt FROM t_prc_component_prices
     WHERE comp_cd='COMP_NAMECARD_PEARL_S2' AND print_opt_cd='POPT_000002' AND min_qty=100 AND mat_cd=v_mat;
    IF v_cnt <> 1 THEN RAISE EXCEPTION '검증 실패: 양면 % 매칭행수=%(기대 1)', v_mat, v_cnt; END IF;
  END LOOP;
  -- 동시매칭 가드: (comp,print_opt,mat,min_qty) 조합당 행 >1 = ERR_AMBIGUOUS 위험
  SELECT COUNT(*) INTO v_amb FROM (
    SELECT 1 FROM t_prc_component_prices
     WHERE comp_cd IN ('COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2')
     GROUP BY comp_cd, print_opt_cd, mat_cd, min_qty HAVING COUNT(*)>1) t;
  IF v_amb > 0 THEN RAISE EXCEPTION '검증 실패: 동시매칭 위험 조합 %건', v_amb; END IF;
  -- 권위 verbatim: 그룹1(다이아240)·그룹2(로츠쿼츠241)
  SELECT unit_price INTO v_g1_s1 FROM t_prc_component_prices
   WHERE comp_cd='COMP_NAMECARD_PEARL_S1' AND mat_cd='MAT_000240' AND print_opt_cd='POPT_000001' AND min_qty=100;
  SELECT unit_price INTO v_g2_s1 FROM t_prc_component_prices
   WHERE comp_cd='COMP_NAMECARD_PEARL_S1' AND mat_cd='MAT_000241' AND print_opt_cd='POPT_000001' AND min_qty=100;
  SELECT unit_price INTO v_g1_s2 FROM t_prc_component_prices
   WHERE comp_cd='COMP_NAMECARD_PEARL_S2' AND mat_cd='MAT_000240' AND print_opt_cd='POPT_000002' AND min_qty=100;
  SELECT unit_price INTO v_g2_s2 FROM t_prc_component_prices
   WHERE comp_cd='COMP_NAMECARD_PEARL_S2' AND mat_cd='MAT_000241' AND print_opt_cd='POPT_000002' AND min_qty=100;
  IF v_g1_s1<>9000 OR v_g2_s1<>10000 OR v_g1_s2<>10000 OR v_g2_s2<>11000 THEN
    RAISE EXCEPTION '검증 실패: 그룹가 단면 9000/%·10000/% 양면 10000/%·11000/% 불일치', v_g1_s1,v_g2_s1,v_g1_s2,v_g2_s2;
  END IF;
  -- 바인딩 존재
  SELECT COUNT(*) INTO v_bind FROM t_prd_product_price_formulas
   WHERE prd_cd='PRD_000034' AND frm_cd='PRF_NAMECARD_PEARL';
  IF v_bind <> 1 THEN RAISE EXCEPTION '검증 실패: 034 바인딩 %건(기대 1)', v_bind; END IF;
  RAISE NOTICE '교정 검증 OK: 펄 4종 단면/양면 견적가능·동시매칭 0·그룹1 9000/10000·그룹2 10000/11000·바인딩 1';
END $$;

COMMIT;
