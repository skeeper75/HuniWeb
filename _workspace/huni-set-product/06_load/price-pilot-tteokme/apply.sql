-- 가격 파일럿 적재본 — 떡메모지(PRD_000097) 셋트 가격공식 바인딩
-- 생성: hsp-set-designer · DB 미적재(게이트 GO + 인간 승인 후 load-executor)
-- BEGIN/COMMIT 미내장 — load-executor가 단일 트랜잭션 래핑.
-- 멱등 키 = 실 PRIMARY KEY (prd_cd, apply_bgn_ymd) [라이브 실측 — frm_cd는 PK 아님].
--   ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING. 롤백전용 DRY-RUN 멱등 delta 0 입증(2026-06-25).
-- ★PK 함의: 한 상품은 같은 적용일에 공식 1개만. 097은 현재 0행이라 충돌 0(안전).
-- search-before-mint: PRF_TTEOKME_FIXED·COMP_TTEOKME·112 단가행·formula_components 전부 라이브 실재.
--   본 INSERT는 상품(PRD_000097)↔공식(PRF_TTEOKME_FIXED) 연결 1행만(신규 mint 0).
-- 선행 FK: PRD_000097 (t_prd_products 실재) · PRF_TTEOKME_FIXED (t_prc_price_formulas 실재).

INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000097', 'PRF_TTEOKME_FIXED', '2026-06-01',
        '떡메모지 셋트 완제품 고정가 공식 바인딩(round-16 단절2 해소)')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- 사후검증(load-executor 실행):
--   SELECT prd_cd, frm_cd, apply_bgn_ymd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000097';
--   기대: 1행 (PRD_000097|PRF_TTEOKME_FIXED|2026-06-01)
