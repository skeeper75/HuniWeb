-- 05_t_prd_product_price_formulas.sql  — 상품↔공식 바인딩 19행 (049 제외 = D-5 BLOCKED)
-- 멱등: PK (prd_cd, frm_cd) → ON CONFLICT (prd_cd, frm_cd) DO NOTHING
-- FK: prd_cd→t_prd_products(19 선존재), frm_cd→01(PRF_DGP_*). apply_bgn_ymd 메모. reg_dt omit.

-- src: t_prd_product_price_formulas_DGP.csv:2  key=PRD_000016|PRF_DGP_A
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000016', 'PRF_DGP_A', '2026-06-01', '프리미엄엽서 → PRF_DGP_A')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:3  key=PRD_000017|PRF_DGP_A
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000017', 'PRF_DGP_A', '2026-06-01', '코팅엽서 → PRF_DGP_A')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:4  key=PRD_000018|PRF_DGP_A
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000018', 'PRF_DGP_A', '2026-06-01', '스탠다드엽서 → PRF_DGP_A')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:5  key=PRD_000020|PRF_DGP_A
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000020', 'PRF_DGP_A', '2026-06-01', '화이트인쇄엽서 → PRF_DGP_A')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:6  key=PRD_000021|PRF_DGP_A
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000021', 'PRF_DGP_A', '2026-06-01', '핑크별색엽서 → PRF_DGP_A (use_yn=N 미출시)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:7  key=PRD_000022|PRF_DGP_A
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000022', 'PRF_DGP_A', '2026-06-01', '금은별색엽서 → PRF_DGP_A (use_yn=N 미출시)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:8  key=PRD_000023|PRF_DGP_B
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000023', 'PRF_DGP_B', '2026-06-01', '모양엽서 → PRF_DGP_B (use_yn=N 미출시)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:9  key=PRD_000026|PRF_DGP_A
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000026', 'PRF_DGP_A', '2026-06-01', '종이슬로건 → PRF_DGP_A')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:10  key=PRD_000027|PRF_DGP_E
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000027', 'PRF_DGP_E', '2026-06-01', '2단접지카드 → PRF_DGP_E')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:11  key=PRD_000028|PRF_DGP_E
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000028', 'PRF_DGP_E', '2026-06-01', '미니접지카드 → PRF_DGP_E (use_yn=N 미출시)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:12  key=PRD_000029|PRF_DGP_E
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000029', 'PRF_DGP_E', '2026-06-01', '3단접지카드 → PRF_DGP_E')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:13  key=PRD_000041|PRF_DGP_A
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000041', 'PRF_DGP_A', '2026-06-01', '스탠다드 쿠폰/상품권 → PRF_DGP_A')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:14  key=PRD_000042|PRF_DGP_A
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000042', 'PRF_DGP_A', '2026-06-01', '프리미엄 쿠폰/상품권 → PRF_DGP_A')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:15  key=PRD_000043|PRF_DGP_C
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000043', 'PRF_DGP_C', '2026-06-01', '인쇄배경지(OPP봉투타입) → PRF_DGP_C')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:16  key=PRD_000044|PRF_DGP_C
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000044', 'PRF_DGP_C', '2026-06-01', '인쇄배경지(투명케이스타입) → PRF_DGP_C')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:17  key=PRD_000045|PRF_DGP_C
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000045', 'PRF_DGP_C', '2026-06-01', '인쇄헤더택 → PRF_DGP_C')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:18  key=PRD_000046|PRF_DGP_B
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000046', 'PRF_DGP_B', '2026-06-01', '라벨/택 → PRF_DGP_B')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:19  key=PRD_000047|PRF_DGP_D
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000047', 'PRF_DGP_D', '2026-06-01', '소량전단지 → PRF_DGP_D')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- src: t_prd_product_price_formulas_DGP.csv:20  key=PRD_000051|PRF_DGP_F
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000051', 'PRF_DGP_F', '2026-06-01', '썬캡 → PRF_DGP_F (use_yn=N 미출시)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
