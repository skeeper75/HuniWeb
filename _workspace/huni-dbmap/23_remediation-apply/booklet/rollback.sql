-- =====================================================================
-- 책자(booklet) 라이브 정정 롤백 (rollback.sql) · round-13 / 2026-06-14
-- apply.sql 즉시적용분(BK-CAT 재연결·BK-4·BK-1·BK-2)을 적용 전 원문으로 복원. 인간 실행용.
-- 레더/디지털 패턴 계승.
-- 원문 상태:
--   068~071 → CAT_000006 책자(L1) main='Y' 단일 / 077·082·088 → CAT_000105 하드커버책자 main='Y'
--   097 → CAT_000124 노트 main='Y' + CAT_000129 떡메모지 main='Y'
--   097 백색모조120 USAGE.07 del_yn='N' / 078 몽블랑130g USAGE.01/.02 del_yn='N'
-- =====================================================================

BEGIN;

-- 1. BK-CAT — 정정으로 추가한 전용 잎노드 연결 제거(적용 전엔 없던 행 → DELETE 복원)
DELETE FROM t_prd_product_categories
 WHERE (prd_cd,cat_cd) IN (
   ('PRD_000068','CAT_000100'),
   ('PRD_000069','CAT_000101'),
   ('PRD_000070','CAT_000102'),
   ('PRD_000071','CAT_000103'),
   ('PRD_000077','CAT_000106'),
   ('PRD_000082','CAT_000107'),
   ('PRD_000088','CAT_000131')
 );

-- 2. BK-CAT — 강등한 윗칸 연결 main 복원(N → 원래 Y), note 원복
UPDATE t_prd_product_categories
   SET main_cat_yn='Y', upd_dt=now(), note=NULL
 WHERE prd_cd IN ('PRD_000068','PRD_000069','PRD_000070','PRD_000071')
   AND cat_cd='CAT_000006';
UPDATE t_prd_product_categories
   SET main_cat_yn='Y', upd_dt=now(), note=NULL
 WHERE prd_cd IN ('PRD_000077','PRD_000082','PRD_000088')
   AND cat_cd='CAT_000105';

-- 3. BK-4 — 097 노트 연결 main 복원
UPDATE t_prd_product_categories
   SET main_cat_yn='Y', upd_dt=now(), note=NULL
 WHERE prd_cd='PRD_000097'
   AND cat_cd='CAT_000124';

-- 4. BK-1 — 097 백색모조120 공통행 논리삭제 복원
UPDATE t_prd_product_materials
   SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000097'
   AND mat_cd='MAT_000073'
   AND usage_cd='USAGE.07';

-- 5. BK-2 — 078 몽블랑130g 논리삭제 복원
UPDATE t_prd_product_materials
   SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000078'
   AND mat_cd='MAT_000105'
   AND usage_cd IN ('USAGE.01','USAGE.02');

COMMIT;
