-- 상품↔공식 바인딩 (투명14 + 코롯토3 + 카라비너1 · 미러 BLOCKED)
-- 생성: gen_load_sql.py (손편집 금지·재현성 R3). NEVER COMMIT.

-- src: data_bindings.csv PRD_000146(아크릴키링)→PRF_CLR_ACRYL (라이브 실재)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000146', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000147(아크릴마그넷)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000147', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000148(아크릴뱃지)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000148', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000149(아크릴집게)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000149', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000150(아크릴스마트톡)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000150', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000152(아크릴명찰)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000152', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000154(아크릴 머리끈)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000154', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000155(아크릴볼펜)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000155', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000157(아크릴네임택)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000157', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000158(아크릴 포카키링)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000158', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000160(아크릴자유형스탠드)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000160', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000161(판아크릴)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000161', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000162(아크릴포카스탠드)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000162', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000163(아크릴미니파츠)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000163', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000170(아크릴쉐이커★)→PRF_CLR_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000170', 'PRF_CLR_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000168(아크릴입체코롯토)→PRF_COROTTO_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000168', 'PRF_COROTTO_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000164(아크릴코롯토)→PRF_COROTTO_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000164', 'PRF_COROTTO_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000226(아크릴쉐이커코롯토)→PRF_COROTTO_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000226', 'PRF_COROTTO_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- src: data_bindings.csv PRD_000166(아크릴카라비너)→PRF_CARABINER_ACRYL
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ('PRD_000166', 'PRF_CARABINER_ACRYL', '2026-06-15')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

