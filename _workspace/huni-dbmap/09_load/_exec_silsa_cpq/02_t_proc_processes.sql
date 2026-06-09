-- =====================================================================
-- step 02 — t_proc_processes (마스터 mint 1: 열재단 PROC_000084)
-- 멱등 가드 = proc_nm. 코드=라이브 MAX(PROC_000083)+1 리터럴. prcs_dtl_opt NULL(flat).
-- reg_dt 생략→DEFAULT now(). DDL 아님. 손편집 금지.
-- =====================================================================
INSERT INTO t_proc_processes (proc_cd, proc_nm, use_yn, note)
SELECT 'PROC_000084', '열재단', 'Y', 'silsa 열재단 옵션 공정. 천 자체 열절단(추가 자재 없는 순수 process). M-1 ① 확정·완칼 PROC_053 차용 폐기. flat(param 없음).'
WHERE NOT EXISTS (SELECT 1 FROM t_proc_processes WHERE proc_nm = '열재단' AND del_yn = 'N');
