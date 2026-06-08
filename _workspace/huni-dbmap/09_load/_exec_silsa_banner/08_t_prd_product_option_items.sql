-- =====================================================================
-- step 08 — t_prd_product_option_items
-- [v2] INSERTABLE 9 = 공정 seq(.04) 타공3·081계열5·봉제1. 자재 seq(.03)·열재단(.04)은 BLOCKED → _blocked/
-- 멱등: 재실행 시 0행 변경. 손편집 금지(gen_load_sql.py 생성).
-- reg_dt 명시 생략→DEFAULT now() 발화(round-5 교훈: 명시 NULL 은 DEFAULT 미발화).
-- =====================================================================
-- [HARD] 트리거 trg_t_prd_product_option_items_chk_ref 가 ref_dim_cd 별 차원행 EXISTS 행단위 검사.
--   [v2 자재+공정 BUNDLE] 9행 = 공정 seq(.04) — 타공079×3(bare-hole item_seq=1)·부착081×4·봉제080×1.
--   PROC_000079/080/081 PRD_000138 링크 라이브 선존재 → 통과(DRY-RUN A·D1).
--   BLOCKED 9행(자재 seq .03 8 + 열재단 .04 1)은 본 SQL 미포함 → _blocked/ + blocked-and-gaps.md.
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-TAGONG4', 1, 'OPT_REF_DIM.04', 'PROC_000079', NULL, 1, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-TAGONG6', 1, 'OPT_REF_DIM.04', 'PROC_000079', NULL, 1, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-TAGONG8', 1, 'OPT_REF_DIM.04', 'PROC_000079', NULL, 1, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-YANGMYEONTAPE', 2, 'OPT_REF_DIM.04', 'PROC_000081', NULL, 1, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-BONGMISING', 2, 'OPT_REF_DIM.04', 'PROC_000080', NULL, 1, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-QBANG4', 2, 'OPT_REF_DIM.04', 'PROC_000081', NULL, 4, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-STRING4', 2, 'OPT_REF_DIM.04', 'PROC_000081', NULL, 4, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-GAKMOK-LE900', 3, 'OPT_REF_DIM.04', 'PROC_000081', NULL, 4, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-GAKMOK-GT900', 3, 'OPT_REF_DIM.04', 'PROC_000081', NULL, 4, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
