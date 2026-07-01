-- selreq-undo.sql
-- 목적: selreq-fix가 COMMIT된 뒤 되돌리기 — 17건을 원래 상태(sel_typ_cd/min/max = NULL)로 복원.
-- 백업 스냅샷: selreq-backup-260701.csv (17건 전부 sel_typ_cd/min_sel_cnt/max_sel_cnt 공백=NULL)
-- ★ 이 스크립트 자체도 안전을 위해 BEGIN...(검증)...ROLLBACK 형태. 실제 복원 시 마지막 ROLLBACK을 COMMIT으로 교체.

\set ON_ERROR_STOP on
BEGIN;

UPDATE t_prd_product_option_groups
   SET sel_typ_cd = NULL,
       min_sel_cnt = NULL,
       max_sel_cnt = NULL,
       upd_dt = now()
 WHERE (prd_cd, opt_grp_cd) IN (
   ('PRD_000019','OPT-000021'),('PRD_000019','OPT-000022'),('PRD_000019','OPT-000023'),('PRD_000019','OPT-000024'),
   ('PRD_000021','OPT-000018'),('PRD_000021','OPT-000020'),
   ('PRD_000030','OPT-000028'),('PRD_000030','OPT-000029'),('PRD_000030','OPT-000030'),
   ('PRD_000055','OPT-000039'),
   ('PRD_000058','OPT-000035'),('PRD_000058','OPT-000036'),
   ('PRD_000067','OPT-000042'),
   ('PRD_000118','OPT-000043'),
   ('PRD_000129','OPT-000044'),('PRD_000129','OPT-000045'),
   ('PRD_000143','OPT-000046')
 );

SELECT prd_cd, opt_grp_cd, sel_typ_cd, min_sel_cnt, max_sel_cnt
  FROM t_prd_product_option_groups
 WHERE (prd_cd, opt_grp_cd) IN (
   ('PRD_000019','OPT-000021'),('PRD_000019','OPT-000022'),('PRD_000019','OPT-000023'),('PRD_000019','OPT-000024'),
   ('PRD_000021','OPT-000018'),('PRD_000021','OPT-000020'),
   ('PRD_000030','OPT-000028'),('PRD_000030','OPT-000029'),('PRD_000030','OPT-000030'),
   ('PRD_000055','OPT-000039'),
   ('PRD_000058','OPT-000035'),('PRD_000058','OPT-000036'),
   ('PRD_000067','OPT-000042'),
   ('PRD_000118','OPT-000043'),
   ('PRD_000129','OPT-000044'),('PRD_000129','OPT-000045'),
   ('PRD_000143','OPT-000046')
 )
 ORDER BY prd_cd, opt_grp_cd;

ROLLBACK;  -- 실제 복원 시 COMMIT으로 교체.
