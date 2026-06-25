-- ============================================================================
-- undo-ext.sql — 동형 전파 2차(남은 6셋트) COMMIT 역연산(백업 복원)
-- 사용: 사후검증 불일치 시 즉시 복구. 백업 스냅샷에서 원상 복원.
-- 실행 전 :ts 를 실제 백업 접미사로 치환(예: 20260624_0651)
--   psql ... -v ts=20260624_0651 -f undo-ext.sql
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

-- [U1] 6 부모상품 prd_typ_cd 원상 복원(04) — 백업 스냅샷 기준
UPDATE t_prd_products t
   SET prd_typ_cd = b.prd_typ_cd, upd_dt = now()
  FROM bak_t_prd_products_setbuild_ext_:ts b
 WHERE t.prd_cd = b.prd_cd;

-- [U2] 6셋트 26 구성원 행 원상 복원(disp_seq/note/min/max/incr/del_yn)
UPDATE t_prd_product_sets t
   SET sub_prd_qty = b.sub_prd_qty,
       min_cnt     = b.min_cnt,
       max_cnt     = b.max_cnt,
       cnt_incr    = b.cnt_incr,
       disp_seq    = b.disp_seq,
       note        = b.note,
       del_yn      = b.del_yn,
       upd_dt      = now()
  FROM bak_t_prd_product_sets_setbuild_ext_:ts b
 WHERE t.prd_cd = b.prd_cd AND t.sub_prd_cd = b.sub_prd_cd;

-- 복원 검증
SELECT 'parents_restored' AS chk, count(*) FROM t_prd_products
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100')
   AND prd_typ_cd='PRD_TYPE.04'
UNION ALL
SELECT 'sets_disp1_restored', count(*) FROM t_prd_product_sets
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100')
   AND disp_seq=1;

COMMIT;
