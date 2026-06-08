-- =====================================================================
-- step 05 — t_prd_product_price_formulas
-- PRD_000138 ↔ PRF_BANNER_NORMAL 바인딩. 기존 PRF_POSTER_FIXED 바인딩과 PK 다름(공존). ON CONFLICT DO NOTHING
-- 멱등: 재실행 시 0행 변경. 손편집 금지(gen_load_sql.py 생성).
-- reg_dt 명시 생략→DEFAULT now() 발화(round-5 교훈: 명시 NULL 은 DEFAULT 미발화).
-- =====================================================================
-- [D-WIRE 주의] 라이브 PRD_000138 은 현재 PRF_POSTER_FIXED 에 바인딩(sparse).
--   본 행은 PRF_BANNER_NORMAL 신규 바인딩 추가 → 적재 후 2 공식 공존.
--   기존 PRF_POSTER_FIXED 바인딩 정리(파괴적 DELETE/use_yn)는 본 트랙 밖·인간 승인(검증 권고).
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
VALUES ('PRD_000138', 'PRF_BANNER_NORMAL', '2026-06-01', '일반현수막 전용 합산형 공식 바인딩 (D-WIRE: 공유 PRF_POSTER_FIXED sparse 폐기). 적재 전 라이브 PRD_000138↔PRF_POSTER_FIXED 기존 바인딩 정리 필요(검증 권고)', now())
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
