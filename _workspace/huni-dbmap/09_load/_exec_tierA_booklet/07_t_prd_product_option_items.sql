-- =====================================================================
-- step 07 — t_prd_product_option_items (책자 4상품, 포인터)
-- 멱등 가드 = (prd_cd, opt_cd resolve, item_seq) NOT EXISTS. opt_cd=opt_nm resolve(재실행 안전).
-- 트리거 fn_chk_opt_item_ref: .01 siz_cd · .03 mat_cd+usage_cd · .04 proc_cd · .06 opt_id::int · .07 sub_prd_cd.
-- ref_key1 NOT NULL. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000068', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='A5(148x210mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000170', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000068' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='A5(148x210mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000068', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='A4(210x297mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000172', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000068' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='A4(210x297mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
-- PRD_000068 내지종이 items (mat_usage USAGE.01): 자재 option별 .03 mat_cd+usage item
DO $$
DECLARE r RECORD; v_grp varchar; v_opt varchar;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='내지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000068' AND pm.usage_cd='USAGE.01' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    SELECT opt_cd INTO v_opt FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N' ORDER BY opt_cd LIMIT 1;
    IF v_opt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000068' AND opt_cd=v_opt AND item_seq=1) THEN
      INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
      VALUES ('PRD_000068', v_opt, 1, 'OPT_REF_DIM.03', r.mat_cd, 'USAGE.01', 1, 'Y');
    END IF;
  END LOOP;
END $$;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000068', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '1', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000068' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000068', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '2', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000068' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
-- PRD_000068 표지종이 items (mat_usage USAGE.02): 자재 option별 .03 mat_cd+usage item
DO $$
DECLARE r RECORD; v_grp varchar; v_opt varchar;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000068' AND pm.usage_cd='USAGE.02' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    SELECT opt_cd INTO v_opt FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N' ORDER BY opt_cd LIMIT 1;
    IF v_opt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000068' AND opt_cd=v_opt AND item_seq=1) THEN
      INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
      VALUES ('PRD_000068', v_opt, 1, 'OPT_REF_DIM.03', r.mat_cd, 'USAGE.02', 1, 'Y');
    END IF;
  END LOOP;
END $$;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000068', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '1', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000068' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000068', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '2', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000068' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000068', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000014', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000068' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000068', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='무광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000015', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000068' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='무광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000068', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='중철제본' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000018', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000068' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm='중철제본' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='A5(148x210mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000170', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='A5(148x210mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='A4(210x297mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000172', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='A4(210x297mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
-- PRD_000069 내지종이 items (mat_usage USAGE.01): 자재 option별 .03 mat_cd+usage item
DO $$
DECLARE r RECORD; v_grp varchar; v_opt varchar;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='내지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000069' AND pm.usage_cd='USAGE.01' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    SELECT opt_cd INTO v_opt FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N' ORDER BY opt_cd LIMIT 1;
    IF v_opt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000069' AND opt_cd=v_opt AND item_seq=1) THEN
      INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
      VALUES ('PRD_000069', v_opt, 1, 'OPT_REF_DIM.03', r.mat_cd, 'USAGE.01', 1, 'Y');
    END IF;
  END LOOP;
END $$;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '1', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '2', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
-- PRD_000069 표지종이 items (mat_usage USAGE.02): 자재 option별 .03 mat_cd+usage item
DO $$
DECLARE r RECORD; v_grp varchar; v_opt varchar;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000069' AND pm.usage_cd='USAGE.02' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    SELECT opt_cd INTO v_opt FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N' ORDER BY opt_cd LIMIT 1;
    IF v_opt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000069' AND opt_cd=v_opt AND item_seq=1) THEN
      INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
      VALUES ('PRD_000069', v_opt, 1, 'OPT_REF_DIM.03', r.mat_cd, 'USAGE.02', 1, 'Y');
    END IF;
  END LOOP;
END $$;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '1', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '2', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000014', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='무광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000015', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='무광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='홀로그램' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000037', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='홀로그램' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='금유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000038', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='금유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='은유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000039', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='은유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='먹유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000040', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='먹유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='동박' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000041', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='동박' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='적박' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000042', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='적박' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='청박' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000043', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='청박' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='트윙클' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000044', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='트윙클' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='형압(양각)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000051', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='형압(양각)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='형압(음각)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000052', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='형압(음각)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000069', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='무선제본' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000019', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000069' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm='무선제본' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='A5(148x210mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000170', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='A5(148x210mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='A4(210x297mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000172', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='A4(210x297mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='A5(210x148mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000253', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='A5(210x148mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='A4(297x210mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000255', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='A4(297x210mm)' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
-- PRD_000071 내지종이 items (mat_usage USAGE.01): 자재 option별 .03 mat_cd+usage item
DO $$
DECLARE r RECORD; v_grp varchar; v_opt varchar;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='내지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000071' AND pm.usage_cd='USAGE.01' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    SELECT opt_cd INTO v_opt FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N' ORDER BY opt_cd LIMIT 1;
    IF v_opt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000071' AND opt_cd=v_opt AND item_seq=1) THEN
      INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
      VALUES ('PRD_000071', v_opt, 1, 'OPT_REF_DIM.03', r.mat_cd, 'USAGE.01', 1, 'Y');
    END IF;
  END LOOP;
END $$;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '1', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '2', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
-- PRD_000071 표지종이 items (mat_usage USAGE.02): 자재 option별 .03 mat_cd+usage item
DO $$
DECLARE r RECORD; v_grp varchar; v_opt varchar;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000071' AND pm.usage_cd='USAGE.02' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    SELECT opt_cd INTO v_opt FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N' ORDER BY opt_cd LIMIT 1;
    IF v_opt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000071' AND opt_cd=v_opt AND item_seq=1) THEN
      INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
      VALUES ('PRD_000071', v_opt, 1, 'OPT_REF_DIM.03', r.mat_cd, 'USAGE.02', 1, 'Y');
    END IF;
  END LOOP;
END $$;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '1', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '2', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000014', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='유광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='무광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000015', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='무광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='유광투명커버' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='투명커버' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.03', 'MAT_000244', 'USAGE.05', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='유광투명커버' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='투명커버' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='무광투명커버' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='투명커버' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.03', 'MAT_000245', 'USAGE.05', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='무광투명커버' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='투명커버' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='트윈링제본' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000021', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='트윈링제본' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='화이트링' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='링컬러' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.03', 'MAT_000013', 'USAGE.07', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='화이트링' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='링컬러' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='블랙링' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='링컬러' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.03', 'MAT_000014', 'USAGE.07', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='블랙링' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='링컬러' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000071', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='메탈링' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='링컬러' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.03', 'MAT_000015', 'USAGE.07', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000071' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm='메탈링' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='링컬러' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000094', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='100x150' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000003', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='100x150' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000094', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='135x135' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000004', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='135x135' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000094', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='150x100' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000124', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='150x100' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
-- PRD_000094 내지종이 items (mat_usage USAGE.01): 자재 option별 .03 mat_cd+usage item
DO $$
DECLARE r RECORD; v_grp varchar; v_opt varchar;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='내지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000094' AND pm.usage_cd='USAGE.01' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    SELECT opt_cd INTO v_opt FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N' ORDER BY opt_cd LIMIT 1;
    IF v_opt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000094' AND opt_cd=v_opt AND item_seq=1) THEN
      INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
      VALUES ('PRD_000094', v_opt, 1, 'OPT_REF_DIM.03', r.mat_cd, 'USAGE.01', 1, 'Y');
    END IF;
  END LOOP;
END $$;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000094', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '1', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000094', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '2', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
-- PRD_000094 표지종이 items (mat_usage USAGE.02): 자재 option별 .03 mat_cd+usage item
DO $$
DECLARE r RECORD; v_grp varchar; v_opt varchar;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='표지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000094' AND pm.usage_cd='USAGE.02' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    SELECT opt_cd INTO v_opt FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N' ORDER BY opt_cd LIMIT 1;
    IF v_opt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000094' AND opt_cd=v_opt AND item_seq=1) THEN
      INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
      VALUES ('PRD_000094', v_opt, 1, 'OPT_REF_DIM.03', r.mat_cd, 'USAGE.02', 1, 'Y');
    END IF;
  END LOOP;
END $$;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000094', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '1', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='단면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000094', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.06', '2', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='양면' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000094', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='무광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000015', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='무광' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000094', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='떡제본' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.04', 'PROC_000022', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='떡제본' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000094', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='엽서북-내지' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='셋트구성' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.07', 'PRD_000095', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='엽서북-내지' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='셋트구성' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000094', (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='엽서북-표지' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='셋트구성' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1), 1, 'OPT_REF_DIM.07', 'PRD_000096', NULL, 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm='엽서북-표지' AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='셋트구성' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
