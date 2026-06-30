-- 디지털인쇄 base 공정(PROC_000004) 누락 교정 — DRYRUN (BEGIN…ROLLBACK)
-- 결함: COMP_PRINT_DIGITAL_S1/S2(인쇄비)는 proc_cd=PROC_000004로 키잉되나, 16개 디지털인쇄
--       상품의 t_prd_product_processes에 PROC_000004 미바인딩 → 손님 선택수단 없음 →
--       인쇄비 영구 미청구(저청구 27,000~71,200원/800매). 기준점=016(mand='Y',disp_seq=-1).
-- 가드: 이중과금 방지 — base 인쇄가 흰토너(흰토너 mand 008)인 019/020/040, 이상치 023, 특수 051 제외.
-- 라우팅: §7 dbmap 적재 트랙(인간 승인 후). 라이브 읽기전용 원칙 — 본 파일은 ROLLBACK 검증용.
BEGIN;

INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, del_yn, reg_dt, upd_dt)
SELECT v.prd_cd, 'PROC_000004', 'Y', -1, 'N', now(), now()
FROM (VALUES
  ('PRD_000017'),('PRD_000018'),('PRD_000021'),('PRD_000022'),('PRD_000026'),
  ('PRD_000027'),('PRD_000028'),('PRD_000029'),('PRD_000041'),('PRD_000042'),
  ('PRD_000043'),('PRD_000044'),('PRD_000045'),('PRD_000046'),('PRD_000047'),
  ('PRD_000284')
) AS v(prd_cd)
ON CONFLICT (prd_cd, proc_cd) DO UPDATE
  SET mand_proc_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();

-- 검증: 16개 상품 모두 PROC_000004 mand='Y'/del_yn='N' 보유 확인
SELECT count(*) AS bound_16
FROM t_prd_product_processes
WHERE proc_cd='PROC_000004' AND mand_proc_yn='Y' AND del_yn='N'
  AND prd_cd IN ('PRD_000017','PRD_000018','PRD_000021','PRD_000022','PRD_000026',
                 'PRD_000027','PRD_000028','PRD_000029','PRD_000041','PRD_000042',
                 'PRD_000043','PRD_000044','PRD_000045','PRD_000046','PRD_000047','PRD_000284');

ROLLBACK;
