-- selreq-fix-dryrun.sql
-- 목적: 실무진이 2026-06-28~07-01 webadmin에서 추가한 옵션그룹 중 sel_typ_cd(선택방식)가
--       비어있어 sim-meta/위젯에서 렌더되지 않는 17건에 sel_typ_cd + min/max_sel_cnt 채움.
-- 판정: 17건 전부 SEL_TYPE.01(택1) — 각 그룹 옵션값이 상호배타(단일선택)이며,
--       라이브 동명 그룹(인쇄18·종이20·코팅10·모서리8·접지2·칼라1·화이트인쇄1)이 전부 .01(search-before-mint).
-- min/max 관례(라이브 지배 패턴 답습):
--   SEL_TYPE.01 + mand_yn='Y' → min=1, max=1  (라이브 95건 지배)
--   SEL_TYPE.01 + mand_yn='N' → min=0, max=1  (라이브 38건 지배; mand_yn=N에 min=1은 라이브 0건=신규패턴이라 회피)
-- ★ DRY-RUN 전용: BEGIN ... ROLLBACK. 실제 COMMIT 금지(인간 승인 후 별도).
-- 범위: sel_typ_cd/min_sel_cnt/max_sel_cnt만. mand_yn·use_yn·del_yn·옵션값 미변경.
--       PRD_000129(폼보드)는 별도 트랙(design-foamboard) 파손 진행 중 — 이 2개 opt_grp의 sel_typ_cd만 채우고 다른 파손 미접촉.

\set ON_ERROR_STOP on
BEGIN;

-- 안전 가드: 대상 17행이 여전히 sel_typ_cd IS NULL 인지 확인(이미 채워진 행은 건드리지 않음)
-- (아래 UPDATE의 WHERE에 sel_typ_cd IS NULL 포함)

-- (A) mand_yn='N' → min=0, max=1 (16건)
UPDATE t_prd_product_option_groups
   SET sel_typ_cd = 'SEL_TYPE.01',
       min_sel_cnt = 0,
       max_sel_cnt = 1,
       upd_dt = now()
 WHERE sel_typ_cd IS NULL
   AND mand_yn = 'N'
   AND (prd_cd, opt_grp_cd) IN (
     ('PRD_000019','OPT-000021'),('PRD_000019','OPT-000022'),('PRD_000019','OPT-000023'),('PRD_000019','OPT-000024'),
     ('PRD_000021','OPT-000018'),('PRD_000021','OPT-000020'),
     ('PRD_000030','OPT-000028'),('PRD_000030','OPT-000029'),('PRD_000030','OPT-000030'),
     ('PRD_000055','OPT-000039'),
     ('PRD_000058','OPT-000035'),('PRD_000058','OPT-000036'),
     ('PRD_000067','OPT-000042'),
     ('PRD_000129','OPT-000044'),('PRD_000129','OPT-000045'),
     ('PRD_000143','OPT-000046')
   );

-- (B) mand_yn='Y' → min=1, max=1 (1건: 아트프린트포스터 소재)
UPDATE t_prd_product_option_groups
   SET sel_typ_cd = 'SEL_TYPE.01',
       min_sel_cnt = 1,
       max_sel_cnt = 1,
       upd_dt = now()
 WHERE sel_typ_cd IS NULL
   AND mand_yn = 'Y'
   AND (prd_cd, opt_grp_cd) IN (
     ('PRD_000118','OPT-000043')
   );

-- 검증: 대상 17건 UPDATE 후 상태 확인 (sel_typ_cd/min/max 모두 채워졌는지, 남은 NULL 0 기대)
SELECT prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn
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

-- 남은 NULL 개수 (0 기대)
SELECT count(*) AS remaining_null_sel_typ
  FROM t_prd_product_option_groups
 WHERE sel_typ_cd IS NULL
   AND (prd_cd, opt_grp_cd) IN (
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

COMMIT;  -- ★ DRY-RUN: 반영하지 않음. COMMIT은 인간 승인 후 selreq-fix-commit로 별도 실행.
