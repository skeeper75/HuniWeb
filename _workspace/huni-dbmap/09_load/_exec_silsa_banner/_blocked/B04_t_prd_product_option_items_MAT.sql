-- =====================================================================
-- step B-04 — t_prd_product_option_items (BLOCKED 자재 seq .03 — 링크/mint 후 활성화)
-- [v2] 자재 seq BUNDLE. 끈/양면테입=링크 후 즉시. 큐방/각목/봉제사=mint+링크 후. PK=(prd_cd,opt_cd,item_seq)
-- 멱등: 재실행 시 0행 변경. 손편집 금지(gen_load_sql.py 생성).
-- reg_dt 명시 생략→DEFAULT now() 발화(round-5 교훈: 명시 NULL 은 DEFAULT 미발화).
-- =====================================================================
-- [HARD] 트리거 .03 → t_prd_product_materials(prd_cd,mat_cd,usage_cd) EXISTS. B03b 선행 필수.
--   끈 MAT_000070·양면테입 MAT_000069 = B03b 링크 후 즉시 적재(DRY-RUN B2·D2 BUNDLE 성립 실증).
--   큐방·각목·봉제사 = mint(B03a)+링크(B03b) 후 ref_key1 실코드 치환 → 활성화. placeholder 행은 주석.
-- [멱등] ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING.
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-YANGMYEONTAPE', 1, 'OPT_REF_DIM.03', 'MAT_000069', 'USAGE.07', 1, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
-- [mint 후 활성화 — ref_key1 placeholder [CONFIRM-MAT 봉제사]]
-- INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
-- VALUES ('PRD_000138', 'OP-GAGONG-BONGMISING', 1, 'OPT_REF_DIM.03', '[CONFIRM-MAT 봉제사]', 'USAGE.07', 1, 'Y', now())
-- ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
-- [mint 후 활성화 — ref_key1 placeholder [CONFIRM-MAT 큐방]]
-- INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
-- VALUES ('PRD_000138', 'OP-CHUGA-QBANG4', 1, 'OPT_REF_DIM.03', '[CONFIRM-MAT 큐방]', 'USAGE.07', 4, 'Y', now())
-- ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-STRING4', 1, 'OPT_REF_DIM.03', 'MAT_000070', 'USAGE.07', 4, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
-- [mint 후 활성화 — ref_key1 placeholder [CONFIRM-MAT 각목900이하]]
-- INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
-- VALUES ('PRD_000138', 'OP-CHUGA-GAKMOK-LE900', 1, 'OPT_REF_DIM.03', '[CONFIRM-MAT 각목900이하]', 'USAGE.07', 1, 'Y', now())
-- ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-GAKMOK-LE900', 2, 'OPT_REF_DIM.03', 'MAT_000070', 'USAGE.07', 4, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
-- [mint 후 활성화 — ref_key1 placeholder [CONFIRM-MAT 각목900초과]]
-- INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
-- VALUES ('PRD_000138', 'OP-CHUGA-GAKMOK-GT900', 1, 'OPT_REF_DIM.03', '[CONFIRM-MAT 각목900초과]', 'USAGE.07', 1, 'Y', now())
-- ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-GAKMOK-GT900', 2, 'OPT_REF_DIM.03', 'MAT_000070', 'USAGE.07', 4, 'Y', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;
