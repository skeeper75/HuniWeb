-- 040 화이트인쇄명함 빌드 (2026-06-30, 020 화이트엽서 원자모델 복제)
-- 권위=가격표 B06(화이트/클리어)+출력소재 큐리어스스킨 5색. plate SIZ_000499·사이즈 90x50 기존.
BEGIN;
-- 1. 자재: 굿즈 4종 논리삭제 -> 큐리어스스킨 5색 추가
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now(), upd_dt=now()
  WHERE prd_cd='PRD_000040' AND mat_cd IN ('MAT_000138','MAT_000139','MAT_000140','MAT_000141') AND COALESCE(del_yn,'N')<>'Y';
INSERT INTO t_prd_product_materials (prd_cd,mat_cd,usage_cd,dflt_yn,disp_seq)
SELECT 'PRD_000040',v.mat_cd,'USAGE.07','Y',v.seq
FROM (VALUES ('MAT_000361',1),('MAT_000362',2),('MAT_000363',3),('MAT_000364',4),('MAT_000365',5)) v(mat_cd,seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials pm WHERE pm.prd_cd='PRD_000040' AND pm.mat_cd=v.mat_cd AND COALESCE(pm.del_yn,'N')<>'Y');

-- 2. 공정: 화이트(008 필수)+클리어(009 선택) 추가 (모서리 027/028 보존)
INSERT INTO t_prd_product_processes (prd_cd,proc_cd,mand_proc_yn,disp_seq)
SELECT 'PRD_000040',v.proc_cd,v.mand,v.seq
FROM (VALUES ('PROC_000008','Y',1),('PROC_000009','N',2)) v(proc_cd,mand,seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes pp WHERE pp.prd_cd='PRD_000040' AND pp.proc_cd=v.proc_cd AND COALESCE(pp.del_yn,'N')<>'Y');

-- 3. 공식 바인딩: PRF_DGP_A (020과 동일)
INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note)
SELECT 'PRD_000040','PRF_DGP_A','2026-06-01','§29 040 빌드 260630 - 020 원자모델 복제(화이트인쇄)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas b WHERE b.prd_cd='PRD_000040' AND b.frm_cd='PRF_DGP_A');

\echo '--- 사후: 040 자재(5 큐리어스스킨) ---'
SELECT m.mat_nm,pm.dflt_yn,pm.disp_seq FROM t_prd_product_materials pm JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd WHERE pm.prd_cd='PRD_000040' AND COALESCE(pm.del_yn,'N')<>'Y' ORDER BY pm.disp_seq;
\echo '--- 사후: 040 공정 ---'
SELECT pp.proc_cd,pr.proc_nm,pp.mand_proc_yn FROM t_prd_product_processes pp LEFT JOIN t_proc_processes pr ON pr.proc_cd=pp.proc_cd WHERE pp.prd_cd='PRD_000040' AND COALESCE(pp.del_yn,'N')<>'Y' ORDER BY pp.disp_seq;
\echo '--- 사후: 040 공식 ---'
SELECT frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000040';
ROLLBACK;
\echo '=== ROLLBACK (DRY-RUN) ==='
