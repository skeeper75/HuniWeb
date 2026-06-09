-- =====================================================================
-- step 04 — t_prd_product_processes (PRD_000138 열재단 링크 1행)
-- 079 타공·080 봉제·081 부착 = 라이브 이미 링크(재적재 안 함). 열재단(PROC_000084·mint)만 신규 링크.
-- 멱등 가드 = (prd_cd, proc_cd) NOT EXISTS. 열재단은 이름→코드 조회. mand_proc_yn='N'(옵션 공정).
-- 트리거 fn_chk_opt_item_ref(.04) 선행조건: 열재단 옵션아이템(07)이 (prd_cd,proc_cd) 존재 요구.
-- reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)
SELECT 'PRD_000138', (SELECT proc_cd FROM t_proc_processes WHERE proc_nm='열재단' AND del_yn='N' ORDER BY proc_cd LIMIT 1), 'N', 10
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_processes
  WHERE prd_cd = 'PRD_000138' AND proc_cd = (SELECT proc_cd FROM t_proc_processes WHERE proc_nm='열재단' AND del_yn='N' ORDER BY proc_cd LIMIT 1));
