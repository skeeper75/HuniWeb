-- 굿즈 addon 배선 — 볼체인 8색 → 말랑키링(221)·말랑포카홀더(223) (2026-07-04)
-- 템플릿 TMPL-056~063 이미 존재·1000원. 링크만. 멱등. dryrun=ROLLBACK.
\set ON_ERROR_STOP on
BEGIN;
INSERT INTO t_prd_product_addons (prd_cd,tmpl_cd,disp_seq,reg_dt) VALUES ('PRD_000221','TMPL-000056',1,now()),('PRD_000221','TMPL-000057',2,now()),('PRD_000221','TMPL-000058',3,now()),('PRD_000221','TMPL-000059',4,now()),('PRD_000221','TMPL-000060',5,now()),('PRD_000221','TMPL-000061',6,now()),('PRD_000221','TMPL-000062',7,now()),('PRD_000221','TMPL-000063',8,now()) ON CONFLICT (prd_cd,tmpl_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq;
INSERT INTO t_prd_product_addons (prd_cd,tmpl_cd,disp_seq,reg_dt) VALUES ('PRD_000223','TMPL-000056',1,now()),('PRD_000223','TMPL-000057',2,now()),('PRD_000223','TMPL-000058',3,now()),('PRD_000223','TMPL-000059',4,now()),('PRD_000223','TMPL-000060',5,now()),('PRD_000223','TMPL-000061',6,now()),('PRD_000223','TMPL-000062',7,now()),('PRD_000223','TMPL-000063',8,now()) ON CONFLICT (prd_cd,tmpl_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq;
\echo '=== POST: addon 배선 요약 ==='
SELECT prd_cd, count(*) addons FROM t_prd_product_addons WHERE prd_cd IN ('PRD_000221','PRD_000223') GROUP BY prd_cd ORDER BY prd_cd;
ROLLBACK;
