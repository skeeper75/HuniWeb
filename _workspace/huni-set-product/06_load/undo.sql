-- ============================================================================
-- undo.sql — 엽서북 셋트 보정 COMMIT 역연산 (백업 복원)
-- 백업 스냅샷: bak_t_prd_product_sets_setbuild_20260624_0600 (2행, 보정 전)
--             bak_t_prd_products_setbuild_20260624_0600   (1행, 유형 04)
-- 사용: 사후 결함 발견 시에만 실행. 단일 트랜잭션. 신규행 mint 없었으므로 복원=UPDATE only.
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

-- [1] 부모 유형 복원 (01 -> 백업의 04)
UPDATE t_prd_products t
   SET prd_typ_cd = b.prd_typ_cd,
       upd_dt     = now()
  FROM bak_t_prd_products_setbuild_20260624_0600 b
 WHERE t.prd_cd = b.prd_cd
   AND t.prd_cd = 'PRD_000094';

-- [2] 셋트행 복원 (min/max/incr/disp_seq/note 보정 전 값으로)
--     보정 전: 95·96 모두 min/max/incr=NULL·disp_seq=1·note 원본
UPDATE t_prd_product_sets t
   SET sub_prd_qty = b.sub_prd_qty,
       min_cnt     = b.min_cnt,
       max_cnt     = b.max_cnt,
       cnt_incr    = b.cnt_incr,
       disp_seq    = b.disp_seq,
       note        = b.note,
       del_yn      = b.del_yn,
       upd_dt      = now()
  FROM bak_t_prd_product_sets_setbuild_20260624_0600 b
 WHERE t.prd_cd = b.prd_cd
   AND t.sub_prd_cd = b.sub_prd_cd
   AND t.prd_cd = 'PRD_000094';

-- 복원 검증 (커밋 전 확인용)
SELECT prd_cd, prd_typ_cd FROM t_prd_products WHERE prd_cd='PRD_000094';
SELECT sub_prd_cd, min_cnt, max_cnt, cnt_incr, disp_seq FROM t_prd_product_sets WHERE prd_cd='PRD_000094' ORDER BY sub_prd_cd;

-- 검증 후 의도대로면 COMMIT, 아니면 ROLLBACK (기본 안전: 수동 결정)
-- COMMIT;
ROLLBACK;
\echo '*** undo.sql 기본은 ROLLBACK — 복원 확정 시 위 ROLLBACK을 COMMIT으로 바꿔 재실행 ***'
