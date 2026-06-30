-- §29 명함 031 프리미엄명함 견적0 교정 (2026-06-30)
-- 권위=가격표 260527 B02(등급 A 4500/5500·B 5000/6500·14용지)·상품마스터=종이"*별도설정"
-- 앙상블210·리브스디자인250=두 권위 무근거→제거(사용자 승인)
BEGIN;
-- ===== 1. PREMIUM 단가행 재구축 (grade-only 4행 → mat_cd+print_opt 28행) =====
DELETE FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_NAMECARD_PREMIUM%' AND mat_cd IS NULL;
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, mat_cd, print_opt_cd, min_qty, unit_price)
SELECT (SELECT MAX(comp_price_id) FROM t_prc_component_prices) + ROW_NUMBER() OVER (),
       v.comp_cd, '2026-06-01', v.mat_cd, v.po, 100, v.price
FROM (VALUES
  -- S1_MGA 단면 등급A 4500 (7)
  ('COMP_NAMECARD_PREMIUM_S1_MGA','MAT_000101','POPT_000001',4500),('COMP_NAMECARD_PREMIUM_S1_MGA','MAT_000102','POPT_000001',4500),
  ('COMP_NAMECARD_PREMIUM_S1_MGA','MAT_000108','POPT_000001',4500),('COMP_NAMECARD_PREMIUM_S1_MGA','MAT_000109','POPT_000001',4500),
  ('COMP_NAMECARD_PREMIUM_S1_MGA','MAT_000113','POPT_000001',4500),('COMP_NAMECARD_PREMIUM_S1_MGA','MAT_000114','POPT_000001',4500),
  ('COMP_NAMECARD_PREMIUM_S1_MGA','MAT_000115','POPT_000001',4500),
  -- S1_MGB 단면 등급B 5000 (7)
  ('COMP_NAMECARD_PREMIUM_S1_MGB','MAT_000116','POPT_000001',5000),('COMP_NAMECARD_PREMIUM_S1_MGB','MAT_000117','POPT_000001',5000),
  ('COMP_NAMECARD_PREMIUM_S1_MGB','MAT_000118','POPT_000001',5000),('COMP_NAMECARD_PREMIUM_S1_MGB','MAT_000123','POPT_000001',5000),
  ('COMP_NAMECARD_PREMIUM_S1_MGB','MAT_000124','POPT_000001',5000),('COMP_NAMECARD_PREMIUM_S1_MGB','MAT_000125','POPT_000001',5000),
  ('COMP_NAMECARD_PREMIUM_S1_MGB','MAT_000126','POPT_000001',5000),
  -- S2_MGA 양면 등급A 5500 (7)
  ('COMP_NAMECARD_PREMIUM_S2_MGA','MAT_000101','POPT_000002',5500),('COMP_NAMECARD_PREMIUM_S2_MGA','MAT_000102','POPT_000002',5500),
  ('COMP_NAMECARD_PREMIUM_S2_MGA','MAT_000108','POPT_000002',5500),('COMP_NAMECARD_PREMIUM_S2_MGA','MAT_000109','POPT_000002',5500),
  ('COMP_NAMECARD_PREMIUM_S2_MGA','MAT_000113','POPT_000002',5500),('COMP_NAMECARD_PREMIUM_S2_MGA','MAT_000114','POPT_000002',5500),
  ('COMP_NAMECARD_PREMIUM_S2_MGA','MAT_000115','POPT_000002',5500),
  -- S2_MGB 양면 등급B 6500 (7)
  ('COMP_NAMECARD_PREMIUM_S2_MGB','MAT_000116','POPT_000002',6500),('COMP_NAMECARD_PREMIUM_S2_MGB','MAT_000117','POPT_000002',6500),
  ('COMP_NAMECARD_PREMIUM_S2_MGB','MAT_000118','POPT_000002',6500),('COMP_NAMECARD_PREMIUM_S2_MGB','MAT_000123','POPT_000002',6500),
  ('COMP_NAMECARD_PREMIUM_S2_MGB','MAT_000124','POPT_000002',6500),('COMP_NAMECARD_PREMIUM_S2_MGB','MAT_000125','POPT_000002',6500),
  ('COMP_NAMECARD_PREMIUM_S2_MGB','MAT_000126','POPT_000002',6500)
) v(comp_cd, mat_cd, po, price)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices cp WHERE cp.comp_cd=v.comp_cd AND cp.mat_cd=v.mat_cd AND cp.print_opt_cd=v.po AND cp.min_qty=100);

UPDATE t_prc_price_components SET use_dims='["mat_cd", "print_opt_cd", "min_qty"]', upd_dt=now()
  WHERE comp_cd LIKE 'COMP_NAMECARD_PREMIUM%';

-- ===== 2. 공식 신설 =====
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
  SELECT 'PRF_NAMECARD_PREMIUM','프리미엄명함 면/소재(등급)/수량별 단가(용지포함)','§29 배선교정 260630','Y'
  WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_PREMIUM');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
  SELECT 'PRF_NAMECARD_PREMIUM_FOIL','프리미엄명함 면/소재(등급)/수량별 단가(용지포함)+박','§29 배선교정 260630','Y'
  WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_PREMIUM_FOIL');

-- ===== 3. formula_components 배선 =====
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
  SELECT 'PRF_NAMECARD_PREMIUM', v.comp_cd, v.seq, 'Y'
  FROM (VALUES ('COMP_NAMECARD_PREMIUM_S1_MGA',1),('COMP_NAMECARD_PREMIUM_S1_MGB',2),('COMP_NAMECARD_PREMIUM_S2_MGA',3),('COMP_NAMECARD_PREMIUM_S2_MGB',4)) v(comp_cd,seq)
  WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd='PRF_NAMECARD_PREMIUM' AND fc.comp_cd=v.comp_cd);
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
  SELECT 'PRF_NAMECARD_PREMIUM_FOIL', v.comp_cd, v.seq, 'Y'
  FROM (VALUES ('COMP_NAMECARD_PREMIUM_S1_MGA',1),('COMP_NAMECARD_PREMIUM_S1_MGB',2),('COMP_NAMECARD_PREMIUM_S2_MGA',3),('COMP_NAMECARD_PREMIUM_S2_MGB',4),
               ('COMP_FOIL_SETUP_SMALL',5),('COMP_FOIL_PROC_SMALL_STD',6),('COMP_FOIL_PROC_SMALL_SPECIAL',7)) v(comp_cd,seq)
  WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd='PRF_NAMECARD_PREMIUM_FOIL' AND fc.comp_cd=v.comp_cd);

-- ===== 4. 031 rebind (FIXED→PREMIUM·FIXED_FOIL→PREMIUM_FOIL, apply_bgn_ymd 보존) =====
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000031' AND frm_cd IN ('PRF_NAMECARD_FIXED','PRF_NAMECARD_FIXED_FOIL');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
  SELECT * FROM (VALUES
    ('PRD_000031','PRF_NAMECARD_PREMIUM','2026-06-01','§29 배선교정 260630 — 프리미엄 등급가(견적0 해소)'),
    ('PRD_000031','PRF_NAMECARD_PREMIUM_FOIL','2026-07-01','§29 배선교정 260630 — 프리미엄 박분기')
  ) v(prd_cd,frm_cd,d,n)
  WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas b WHERE b.prd_cd=v.prd_cd AND b.frm_cd=v.frm_cd);

-- ===== 5. 권위무근거 2용지 논리삭제 + 기본자재 이전 =====
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now(), dflt_yn='N', upd_dt=now() WHERE prd_cd='PRD_000031' AND mat_cd='MAT_000099';
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now(), upd_dt=now() WHERE prd_cd='PRD_000031' AND mat_cd='MAT_000119';
UPDATE t_prd_product_materials SET dflt_yn='Y', upd_dt=now() WHERE prd_cd='PRD_000031' AND mat_cd='MAT_000101' AND COALESCE(del_yn,'N')<>'Y';

\echo '--- 사후: PREMIUM 단가행 수(28 기대) ---'
SELECT comp_cd,count(*) FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_NAMECARD_PREMIUM%' GROUP BY comp_cd ORDER BY comp_cd;
\echo '--- 사후: 031 바인딩 ---'
SELECT frm_cd,apply_bgn_ymd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000031' ORDER BY apply_bgn_ymd;
\echo '--- 사후: 031 활성자재(del_yn<>Y) 수(14 기대)+기본 ---'
SELECT count(*) total, sum(CASE WHEN dflt_yn='Y' THEN 1 ELSE 0 END) dflt FROM t_prd_product_materials WHERE prd_cd='PRD_000031' AND COALESCE(del_yn,'N')<>'Y';
\echo '--- 무회귀: 032 코팅·033 스탠다드 바인딩 ---'
SELECT prd_cd,frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000032','PRD_000033') ORDER BY prd_cd;
ROLLBACK;
\echo '=== ROLLBACK (DRY-RUN) ==='
