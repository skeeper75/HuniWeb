-- =====================================================================
-- step 06 — t_prd_product_options (책자 4상품)
-- [HARD] opt_cd = 동적 채번(삽입 시점 MAX(OPV_*)+1, 리터럴 0) → enum/mat_usage 충돌 0·재발급 0.
-- 멱등 가드 = (prd_cd, opt_nm, opt_grp resolve) NOT EXISTS. opt_grp_cd=이름 resolve(05 선행).
-- enum=고정 옵션 배열 순회 DO 블록, mat_usage=라이브 자재행 순회 DO 블록.
-- =====================================================================
-- PRD_000068 사이즈 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('A5(148x210mm)','Y'),('A4(210x297mm)','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000068', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 1, 'Y', '사이즈');
    END IF;
  END LOOP;
END $$;
-- PRD_000068 내지종이 (mat_usage USAGE.01, 라이브 자재행 전개, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int; v_i int := 0;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='내지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000068' AND pm.usage_cd='USAGE.01' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      v_i := v_i + 1;
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000068', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.mat_nm, CASE WHEN v_i=1 THEN 'Y' ELSE 'N' END, 2, 'Y', '내지종이 (자재 USAGE.01)');
    END IF;
  END LOOP;
END $$;
-- PRD_000068 내지인쇄 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('양면','Y'),('단면','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000068', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 3, 'Y', '내지인쇄');
    END IF;
  END LOOP;
END $$;
-- PRD_000068 표지종이 (mat_usage USAGE.02, 라이브 자재행 전개, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int; v_i int := 0;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000068' AND pm.usage_cd='USAGE.02' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      v_i := v_i + 1;
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000068', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.mat_nm, CASE WHEN v_i=1 THEN 'Y' ELSE 'N' END, 4, 'Y', '표지종이 (자재 USAGE.02)');
    END IF;
  END LOOP;
END $$;
-- PRD_000068 표지인쇄 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('양면','Y'),('단면','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000068', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 5, 'Y', '표지인쇄');
    END IF;
  END LOOP;
END $$;
-- PRD_000068 표지코팅 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('유광','Y'),('무광','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000068', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 6, 'Y', '표지코팅');
    END IF;
  END LOOP;
END $$;
-- PRD_000068 제본 (enum 1 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000068' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('중철제본','Y')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000068' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000068', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 9, 'Y', '제본');
    END IF;
  END LOOP;
END $$;
-- PRD_000069 사이즈 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('A5(148x210mm)','Y'),('A4(210x297mm)','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000069', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 1, 'Y', '사이즈');
    END IF;
  END LOOP;
END $$;
-- PRD_000069 내지종이 (mat_usage USAGE.01, 라이브 자재행 전개, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int; v_i int := 0;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='내지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000069' AND pm.usage_cd='USAGE.01' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      v_i := v_i + 1;
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000069', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.mat_nm, CASE WHEN v_i=1 THEN 'Y' ELSE 'N' END, 2, 'Y', '내지종이 (자재 USAGE.01)');
    END IF;
  END LOOP;
END $$;
-- PRD_000069 내지인쇄 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('양면','Y'),('단면','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000069', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 3, 'Y', '내지인쇄');
    END IF;
  END LOOP;
END $$;
-- PRD_000069 표지종이 (mat_usage USAGE.02, 라이브 자재행 전개, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int; v_i int := 0;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000069' AND pm.usage_cd='USAGE.02' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      v_i := v_i + 1;
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000069', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.mat_nm, CASE WHEN v_i=1 THEN 'Y' ELSE 'N' END, 4, 'Y', '표지종이 (자재 USAGE.02)');
    END IF;
  END LOOP;
END $$;
-- PRD_000069 표지인쇄 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('양면','Y'),('단면','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000069', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 5, 'Y', '표지인쇄');
    END IF;
  END LOOP;
END $$;
-- PRD_000069 표지코팅 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('유광','Y'),('무광','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000069', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 6, 'Y', '표지코팅');
    END IF;
  END LOOP;
END $$;
-- PRD_000069 박/형압 (enum 10 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='박/형압' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('홀로그램','N'),('금유광','N'),('은유광','N'),('먹유광','N'),('동박','N'),('적박','N'),('청박','N'),('트윙클','N'),('형압(양각)','N'),('형압(음각)','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000069', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 8, 'Y', '박/형압');
    END IF;
  END LOOP;
END $$;
-- PRD_000069 제본 (enum 1 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000069' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('무선제본','Y')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000069' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000069', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 9, 'Y', '제본');
    END IF;
  END LOOP;
END $$;
-- PRD_000071 사이즈 (enum 4 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('A5(148x210mm)','Y'),('A4(210x297mm)','N'),('A5(210x148mm)','N'),('A4(297x210mm)','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000071', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 1, 'Y', '사이즈');
    END IF;
  END LOOP;
END $$;
-- PRD_000071 내지종이 (mat_usage USAGE.01, 라이브 자재행 전개, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int; v_i int := 0;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='내지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000071' AND pm.usage_cd='USAGE.01' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      v_i := v_i + 1;
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000071', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.mat_nm, CASE WHEN v_i=1 THEN 'Y' ELSE 'N' END, 2, 'Y', '내지종이 (자재 USAGE.01)');
    END IF;
  END LOOP;
END $$;
-- PRD_000071 내지인쇄 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('단면','Y'),('양면','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000071', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 3, 'Y', '내지인쇄');
    END IF;
  END LOOP;
END $$;
-- PRD_000071 표지종이 (mat_usage USAGE.02, 라이브 자재행 전개, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int; v_i int := 0;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000071' AND pm.usage_cd='USAGE.02' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      v_i := v_i + 1;
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000071', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.mat_nm, CASE WHEN v_i=1 THEN 'Y' ELSE 'N' END, 4, 'Y', '표지종이 (자재 USAGE.02)');
    END IF;
  END LOOP;
END $$;
-- PRD_000071 표지인쇄 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('단면','Y'),('양면','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000071', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 5, 'Y', '표지인쇄');
    END IF;
  END LOOP;
END $$;
-- PRD_000071 표지코팅 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('유광','Y'),('무광','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000071', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 6, 'Y', '표지코팅');
    END IF;
  END LOOP;
END $$;
-- PRD_000071 투명커버 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='투명커버' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('유광투명커버','Y'),('무광투명커버','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000071', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 7, 'Y', '투명커버');
    END IF;
  END LOOP;
END $$;
-- PRD_000071 제본 (enum 1 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('트윈링제본','Y')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000071', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 9, 'Y', '제본');
    END IF;
  END LOOP;
END $$;
-- PRD_000071 링컬러 (enum 3 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000071' AND opt_grp_nm='링컬러' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('화이트링','Y'),('블랙링','N'),('메탈링','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000071' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000071', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 10, 'Y', '링컬러');
    END IF;
  END LOOP;
END $$;
-- PRD_000094 사이즈 (enum 3 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='사이즈' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('100x150','Y'),('135x135','N'),('150x100','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000094', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 1, 'Y', '사이즈');
    END IF;
  END LOOP;
END $$;
-- PRD_000094 내지종이 (mat_usage USAGE.01, 라이브 자재행 전개, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int; v_i int := 0;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='내지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000094' AND pm.usage_cd='USAGE.01' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      v_i := v_i + 1;
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000094', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.mat_nm, CASE WHEN v_i=1 THEN 'Y' ELSE 'N' END, 2, 'Y', '내지종이 (자재 USAGE.01)');
    END IF;
  END LOOP;
END $$;
-- PRD_000094 내지인쇄 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='내지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('단면','Y'),('양면','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000094', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 3, 'Y', '내지인쇄');
    END IF;
  END LOOP;
END $$;
-- PRD_000094 표지종이 (mat_usage USAGE.02, 라이브 자재행 전개, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int; v_i int := 0;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='표지종이' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
           WHERE pm.prd_cd='PRD_000094' AND pm.usage_cd='USAGE.02' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      v_i := v_i + 1;
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000094', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.mat_nm, CASE WHEN v_i=1 THEN 'Y' ELSE 'N' END, 4, 'Y', '표지종이 (자재 USAGE.02)');
    END IF;
  END LOOP;
END $$;
-- PRD_000094 표지인쇄 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='표지인쇄' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('단면','Y'),('양면','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000094', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 5, 'Y', '표지인쇄');
    END IF;
  END LOOP;
END $$;
-- PRD_000094 표지코팅 (enum 1 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='표지코팅' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('무광','Y')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000094', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 6, 'Y', '표지코팅');
    END IF;
  END LOOP;
END $$;
-- PRD_000094 제본 (enum 1 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='제본' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('떡제본','Y')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000094', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 9, 'Y', '제본');
    END IF;
  END LOOP;
END $$;
-- PRD_000094 셋트구성 (enum 2 옵션, opt_cd 동적)
DO $$
DECLARE r RECORD; v_grp varchar; v_max int;
BEGIN
  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_nm='셋트구성' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;
  FOR r IN SELECT * FROM (VALUES ('엽서북-내지','Y'),('엽서북-표지','N')) AS t(opt_nm, dflt_yn) LOOP
    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN
      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;
      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)
      VALUES ('PRD_000094', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, 11, 'Y', '셋트구성');
    END IF;
  END LOOP;
END $$;
