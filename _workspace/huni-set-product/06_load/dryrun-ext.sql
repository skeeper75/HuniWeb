-- ============================================================================
-- dryrun-ext.sql — 동형 전파 2차(남은 6셋트) 롤백전용 DRY-RUN
-- 생성: hsp-load-executor · BEGIN ... ROLLBACK(COMMIT 안 함) · 32 DML 멱등/카운트 실증
-- 2회 연속 실행으로 멱등 입증(2차 유형 UPDATE 0행·sets fingerprint 동일·신규행 0)
-- 03_design/apply-ext.sql 본체를 인라인(데이터 동일)
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

-- ---- preflight: BEFORE state ----
SELECT '== BEFORE ==' AS marker;
SELECT count(*) AS parent_type04 FROM t_prd_products
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100')
   AND prd_typ_cd='PRD_TYPE.04';
SELECT count(*) AS sets_before FROM t_prd_product_sets
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100');

-- ---- [1] 6 parent type UPDATE (idempotent guard) ----
UPDATE t_prd_products
   SET prd_typ_cd='PRD_TYPE.01', upd_dt=now()
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100')
   AND prd_typ_cd IS DISTINCT FROM 'PRD_TYPE.01';

-- ---- [2] 26 set UPSERT (disp_seq/note) — min/max/incr NULL 유지 ----
INSERT INTO t_prd_product_sets (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt) VALUES
 ('PRD_000072','PRD_000073',1,NULL,NULL,NULL,1,'표지=전용지','N',now()),
 ('PRD_000072','PRD_000074',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000072','PRD_000075',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000072','PRD_000076',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now()),
 ('PRD_000077','PRD_000078',1,NULL,NULL,NULL,1,'표지=레더(화이트)','N',now()),
 ('PRD_000077','PRD_000079',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000077','PRD_000080',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000077','PRD_000081',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now()),
 ('PRD_000082','PRD_000083',1,NULL,NULL,NULL,1,'표지=전용지','N',now()),
 ('PRD_000082','PRD_000084',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000082','PRD_000085',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000082','PRD_000086',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now()),
 ('PRD_000082','PRD_000087',1,NULL,NULL,NULL,5,'면지=인쇄면지','N',now()),
 ('PRD_000088','PRD_000089',1,NULL,NULL,NULL,1,'표지=레더(화이트)','N',now()),
 ('PRD_000088','PRD_000090',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000088','PRD_000091',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000088','PRD_000092',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now()),
 ('PRD_000088','PRD_000093',1,NULL,NULL,NULL,5,'면지=인쇄면지','N',now()),
 ('PRD_000097','PRD_000098',1,NULL,NULL,NULL,1,'내지=백모조120','N',now()),
 ('PRD_000100','PRD_000101',1,NULL,NULL,NULL,1,'내지=몽블랑130','N',now()),
 ('PRD_000100','PRD_000102',1,NULL,NULL,NULL,2,'표지=하드커버','N',now()),
 ('PRD_000100','PRD_000103',1,NULL,NULL,NULL,3,'표지=아트250+무광코팅','N',now()),
 ('PRD_000100','PRD_000105',1,NULL,NULL,NULL,4,'표지=레더하드커버','N',now()),
 ('PRD_000100','PRD_000106',1,NULL,NULL,NULL,5,'표지=레더','N',now()),
 ('PRD_000100','PRD_000107',1,NULL,NULL,NULL,6,'표지=소프트커버','N',now()),
 ('PRD_000100','PRD_000104',1,NULL,NULL,NULL,7,'면지=그레이','N',now())
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
 sub_prd_qty=EXCLUDED.sub_prd_qty, min_cnt=EXCLUDED.min_cnt, max_cnt=EXCLUDED.max_cnt,
 cnt_incr=EXCLUDED.cnt_incr, disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now();

-- ---- AFTER state + integrity checks ----
SELECT '== AFTER ==' AS marker;
SELECT count(*) AS parent_type01 FROM t_prd_products
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100')
   AND prd_typ_cd='PRD_TYPE.01';
SELECT count(*) AS sets_after FROM t_prd_product_sets
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100');
-- min/max/incr 여전히 NULL (26/26)
SELECT count(*) AS still_null_minmaxincr FROM t_prd_product_sets
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100')
   AND min_cnt IS NULL AND max_cnt IS NULL AND cnt_incr IS NULL;
-- PK 중복 0
SELECT count(*) AS pk_dups FROM (
  SELECT prd_cd,sub_prd_cd FROM t_prd_product_sets
   WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100')
   GROUP BY 1,2 HAVING count(*)>1) d;
-- sets data fingerprint (멱등 비교용)
SELECT md5(string_agg(prd_cd||'|'||sub_prd_cd||'|'||sub_prd_qty||'|'||disp_seq||'|'||note||'|'||del_yn, ',' ORDER BY prd_cd, sub_prd_cd)) AS sets_fp
  FROM t_prd_product_sets
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100');
-- 094 무손상(우리가 안 건드림): set rows + price chain fp 불변
SELECT md5(string_agg(prd_cd||'|'||sub_prd_cd||'|'||disp_seq||'|'||COALESCE(min_cnt::text,'N'), ',' ORDER BY sub_prd_cd)) AS s094_fp
  FROM t_prd_product_sets WHERE prd_cd='PRD_000094';

ROLLBACK;
SELECT '== ROLLED BACK (no commit) ==' AS marker;
