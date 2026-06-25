-- =====================================================================
-- w2-undo.sql — W2 옵션화 COMMIT 범위(머그컵 제외) 역연산(되돌리기)
-- =====================================================================
-- 목적: w2-apply.sql 로 적재한 9 group / 29 option / 29 option_item 를
--       신규 채번 PK 기준으로 정확히 삭제(역 위상순서: items→options→groups).
--       + 백업 복원 병행(w2-backup.sql 의 bak_*_w2opt_<ts> 가 있을 때).
-- 안전: 단일 트랜잭션. ★실행 전 백업 테이블명(:ts)을 확인하고 복원 블록 활성화.
--       본 파일은 빌드 산출물 — 실 DELETE 는 메인이 인간 승인 후 수행.
-- 범위 정확성: 신규 채번 surrogate PK 범위로만 삭제(기존 무관 행 불간섭).
--   opt_grp_cd OPT_000064~OPT_000072 / opt_cd OPV_000434~OPV_000462.
--   ★머그컵·기타 상품의 기존 옵션은 채번 범위 밖이라 절대 미삭제.
-- =====================================================================

\set ON_ERROR_STOP on

BEGIN;

-- ---- 삭제 전 행수 확인(기대 grp=9 opt=29 item=29) ----
\echo '== [undo-pre] 삭제 대상 행수 =='
SELECT 'items' lvl, count(*) FROM t_prd_product_option_items
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462'
UNION ALL
SELECT 'options', count(*) FROM t_prd_product_options
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462'
UNION ALL
SELECT 'groups', count(*) FROM t_prd_product_option_groups
  WHERE opt_grp_cd BETWEEN 'OPT_000064' AND 'OPT_000072';

-- ---- 1) option_items 삭제(역 위상 최하위 먼저) ----
DELETE FROM t_prd_product_option_items
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462'
    AND ref_dim_cd = 'OPT_REF_DIM.03';

-- ---- 2) options 삭제 ----
DELETE FROM t_prd_product_options
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462';

-- ---- 3) groups 삭제 ----
DELETE FROM t_prd_product_option_groups
  WHERE opt_grp_cd BETWEEN 'OPT_000064' AND 'OPT_000072';

-- ---- 삭제 후 확인(기대 0/0/0) ----
\echo '== [undo-post] 잔여 행수(기대 0/0/0) =='
SELECT 'items' lvl, count(*) FROM t_prd_product_option_items
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462'
UNION ALL
SELECT 'options', count(*) FROM t_prd_product_options
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462'
UNION ALL
SELECT 'groups', count(*) FROM t_prd_product_option_groups
  WHERE opt_grp_cd BETWEEN 'OPT_000064' AND 'OPT_000072';

-- =====================================================================
-- [선택] 백업 복원 병행 — w2-backup.sql 의 백업 테이블이 있을 때만.
-- 현 실측상 9상품 기존 옵션=0행이므로 복원할 행이 없는 것이 정상.
-- 백업이 비어있지 않은 시나리오(이전 부분 적재 보존)에서만 아래를 활성화하고
-- :ts 를 실제 백업 타임스탬프로 치환해 실행.
-- ---------------------------------------------------------------------
-- \set ts '<백업타임스탬프>'   -- 예: 20260625153000
-- INSERT INTO t_prd_product_option_groups SELECT * FROM bak_opt_groups_w2opt_:ts
--   ON CONFLICT (prd_cd, opt_grp_cd) DO NOTHING;
-- INSERT INTO t_prd_product_options      SELECT * FROM bak_options_w2opt_:ts
--   ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
-- INSERT INTO t_prd_product_option_items SELECT * FROM bak_opt_items_w2opt_:ts
--   ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
-- =====================================================================

\echo '== undo 완료. 실제 적용 시 COMMIT, 시험만이면 ROLLBACK 으로 종료 =='
-- ★기본은 검증용 ROLLBACK. 실 되돌리기 시에만 아래를 COMMIT 으로 교체.
ROLLBACK;
-- COMMIT;
