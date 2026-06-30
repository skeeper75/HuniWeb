-- 019 투명엽서·023 모양엽서 디지털인쇄(CMYK) base 공정 PROC_000004 추가 — LOAD (COMMIT)
-- 권위: 019=예전사이트 단면칼라4도+화이트(75,500·흰토너008과 공존=별개패스) / 023=계산공식집 키스톤 인쇄비+용지비+커팅비.
-- 016 미러(mand='Y',disp_seq=-1). 260701 16건 교정의 누락분(이중과금 가드로 보류했다가 권위로 확정).
BEGIN;
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, del_yn, reg_dt, upd_dt)
SELECT v.prd_cd, 'PROC_000004', 'Y', -1, 'N', now(), now()
FROM (VALUES ('PRD_000019'),('PRD_000023')) AS v(prd_cd)
ON CONFLICT (prd_cd, proc_cd) DO UPDATE
  SET mand_proc_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();
COMMIT;
