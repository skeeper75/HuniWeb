-- ============================================================================
-- namecard-034-pearl-dryrun.sql — 펄명함(034) 교정 DRY-RUN (BEGIN→검증→ROLLBACK)
--   라이브 미변경. namecard-034-pearl-fix.sql 과 동일 변경을 적용 후 BEFORE/AFTER
--   대조하고 ROLLBACK 한다. 인간 승인 전 실증용.
-- ============================================================================
\echo '===== BEFORE: 034 제공 4자재 단면 매칭행수(0=견적불가) ====='
SELECT m.mat_cd, m.mat_nm,
  (SELECT COUNT(*) FROM t_prc_component_prices cp
    WHERE cp.comp_cd='COMP_NAMECARD_PEARL_S1' AND cp.print_opt_cd='POPT_000001'
      AND cp.min_qty=100 AND cp.mat_cd=m.mat_cd) AS s1_rows
FROM t_mat_materials m WHERE m.mat_cd IN ('MAT_000240','MAT_000128','MAT_000129','MAT_000241')
ORDER BY m.mat_cd;

BEGIN;

DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2')
   AND print_opt_cd IN ('POPT_000001','POPT_000002')
   AND min_qty = 100
   AND mat_cd IN ('MAT_000240','MAT_000128','MAT_000129','MAT_000241');

INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, mat_cd, print_opt_cd, min_qty, unit_price, note)
VALUES
('COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000240','POPT_000001',100, 9000.00,'펄명함(스타드림)/단면/다이아240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000128','POPT_000001',100, 9000.00,'펄명함(스타드림)/단면/실버240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000129','POPT_000001',100, 9000.00,'펄명함(스타드림)/단면/골드240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000241','POPT_000001',100,10000.00,'펄명함(스타드림)/단면/로츠쿼츠240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000240','POPT_000002',100,10000.00,'펄명함(스타드림)/양면/다이아240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000128','POPT_000002',100,10000.00,'펄명함(스타드림)/양면/실버240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000129','POPT_000002',100,10000.00,'펄명함(스타드림)/양면/골드240 제작수량 100 이상'),
('COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000241','POPT_000002',100,11000.00,'펄명함(스타드림)/양면/로츠쿼츠240 제작수량 100 이상');

DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000034' AND frm_cd='PRF_NAMECARD_PEARL';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000034','PRF_NAMECARD_PEARL','2026-06-27',
        'namecard-034: 펄명함 자재 collapse 해소(4종 전개) 후 바인딩. 단면 9000/10000·양면 10000/11000(권위 B04).');

\echo '===== AFTER: 034 4자재 × 단면/양면 단가행 ====='
SELECT comp_cd, mat_cd, print_opt_cd, unit_price
  FROM t_prc_component_prices
 WHERE comp_cd LIKE 'COMP_NAMECARD_PEARL%' AND min_qty=100
   AND mat_cd IN ('MAT_000240','MAT_000128','MAT_000129','MAT_000241')
 ORDER BY comp_cd, mat_cd;

\echo '===== AFTER: 동시매칭 위험 조합(0 기대) ====='
SELECT comp_cd, print_opt_cd, mat_cd, min_qty, COUNT(*) AS rows
  FROM t_prc_component_prices
 WHERE comp_cd LIKE 'COMP_NAMECARD_PEARL%'
 GROUP BY comp_cd, print_opt_cd, mat_cd, min_qty HAVING COUNT(*)>1;

\echo '===== AFTER: 기존 대표코드 127·130 보존 확인(미터치) ====='
SELECT comp_cd, mat_cd, unit_price FROM t_prc_component_prices
 WHERE comp_cd LIKE 'COMP_NAMECARD_PEARL%' AND mat_cd IN ('MAT_000127','MAT_000130')
 ORDER BY comp_cd, mat_cd;

\echo '===== AFTER: 034 바인딩 ====='
SELECT prd_cd, frm_cd, apply_bgn_ymd FROM t_prd_product_price_formulas
 WHERE prd_cd='PRD_000034';

-- 사후검증 DO (fix.sql 과 동일) — 실패 시 EXCEPTION
DO $$
DECLARE
  v_mats text[] := ARRAY['MAT_000240','MAT_000128','MAT_000129','MAT_000241'];
  v_mat text; v_cnt int; v_amb int; v_bind int;
  v_g1_s1 numeric; v_g2_s1 numeric; v_g1_s2 numeric; v_g2_s2 numeric;
BEGIN
  FOREACH v_mat IN ARRAY v_mats LOOP
    SELECT COUNT(*) INTO v_cnt FROM t_prc_component_prices
     WHERE comp_cd='COMP_NAMECARD_PEARL_S1' AND print_opt_cd='POPT_000001' AND min_qty=100 AND mat_cd=v_mat;
    IF v_cnt <> 1 THEN RAISE EXCEPTION '검증 실패: 단면 % 매칭행수=%(기대 1)', v_mat, v_cnt; END IF;
    SELECT COUNT(*) INTO v_cnt FROM t_prc_component_prices
     WHERE comp_cd='COMP_NAMECARD_PEARL_S2' AND print_opt_cd='POPT_000002' AND min_qty=100 AND mat_cd=v_mat;
    IF v_cnt <> 1 THEN RAISE EXCEPTION '검증 실패: 양면 % 매칭행수=%(기대 1)', v_mat, v_cnt; END IF;
  END LOOP;
  SELECT COUNT(*) INTO v_amb FROM (
    SELECT 1 FROM t_prc_component_prices
     WHERE comp_cd IN ('COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2')
     GROUP BY comp_cd, print_opt_cd, mat_cd, min_qty HAVING COUNT(*)>1) t;
  IF v_amb > 0 THEN RAISE EXCEPTION '검증 실패: 동시매칭 위험 %건', v_amb; END IF;
  SELECT unit_price INTO v_g1_s1 FROM t_prc_component_prices WHERE comp_cd='COMP_NAMECARD_PEARL_S1' AND mat_cd='MAT_000240' AND print_opt_cd='POPT_000001' AND min_qty=100;
  SELECT unit_price INTO v_g2_s1 FROM t_prc_component_prices WHERE comp_cd='COMP_NAMECARD_PEARL_S1' AND mat_cd='MAT_000241' AND print_opt_cd='POPT_000001' AND min_qty=100;
  SELECT unit_price INTO v_g1_s2 FROM t_prc_component_prices WHERE comp_cd='COMP_NAMECARD_PEARL_S2' AND mat_cd='MAT_000240' AND print_opt_cd='POPT_000002' AND min_qty=100;
  SELECT unit_price INTO v_g2_s2 FROM t_prc_component_prices WHERE comp_cd='COMP_NAMECARD_PEARL_S2' AND mat_cd='MAT_000241' AND print_opt_cd='POPT_000002' AND min_qty=100;
  IF v_g1_s1<>9000 OR v_g2_s1<>10000 OR v_g1_s2<>10000 OR v_g2_s2<>11000 THEN
    RAISE EXCEPTION '검증 실패: 그룹가 불일치 %/%/%/%', v_g1_s1,v_g2_s1,v_g1_s2,v_g2_s2; END IF;
  SELECT COUNT(*) INTO v_bind FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000034' AND frm_cd='PRF_NAMECARD_PEARL';
  IF v_bind <> 1 THEN RAISE EXCEPTION '검증 실패: 바인딩 %건', v_bind; END IF;
  RAISE NOTICE 'DRY-RUN 검증 OK: 펄 4종 견적가능·동시매칭 0·권위 verbatim·바인딩 1';
END $$;

ROLLBACK;
\echo '===== ROLLBACK 완료 — 라이브 미변경 ====='
