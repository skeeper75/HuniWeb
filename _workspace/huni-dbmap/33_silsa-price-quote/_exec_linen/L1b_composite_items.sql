-- L1' 복합 옵션 item 등록 (option_items·OPT_REF_DIM.04→PROC_000080 봉제)
-- ============================================================================
-- 두 복합 옵션(오버로크+리본끈 OPV-000024 · 말아박기+면끈 OPV_000424)에 item 추가.
-- ref = OPT_REF_DIM.04(공정)→PROC_000080(봉제). 기존 OPV_000025/26/27 item 과 동형.
-- ★트리거 fn_chk_opt_item_ref 정합: PRD_000124 는 t_prd_product_processes 에 PROC_000080 보유(실측 확인) → 통과.
-- 멱등: (prd_cd,opt_cd,item_seq) PK NOT EXISTS 가드.
-- ============================================================================
INSERT INTO t_prd_product_option_items
  (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn, reg_dt)
SELECT v.prd_cd, v.opt_cd, v.item_seq, v.ref_dim_cd, v.ref_key1, NULL, 1, 'Y', 'N', now()
FROM (VALUES
  ('PRD_000124','OPV-000024',1,'OPT_REF_DIM.04','PROC_000080'),
  ('PRD_000124','OPV_000424',1,'OPT_REF_DIM.04','PROC_000080')
) AS v(prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_items i
   WHERE i.prd_cd = v.prd_cd AND i.opt_cd = v.opt_cd AND i.item_seq = v.item_seq
);
