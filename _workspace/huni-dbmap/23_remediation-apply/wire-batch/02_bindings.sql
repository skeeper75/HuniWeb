-- ============================================================
-- WIRE 통합 배선 — step 02: 상품↔공식 바인딩 교체 (t_prd_product_price_formulas)
-- 권위 = NAMECARD-WIRE(phase-c §1-3 (3))·SILSA-WIRE(silsa-rep §5·poster-sign §8).
-- 라이브 PK 실측 = (prd_cd, apply_bgn_ymd). frm_cd는 PK 아님 → UPDATE로 공식 교체(행 추가 아님).
-- FK fk_prd_prc_frm_frm_cd = ON UPDATE CASCADE (신규 공식이 00에서 선존재해야 FK 유효).
-- 멱등 = WHERE frm_cd=<구공식> 가드 → 2회차 매칭 0행(이미 신공식이면 no-op).
-- 033은 기존 PRF_NAMECARD_FIXED 유지(UPDATE 대상 아님).
-- ============================================================

-- (NAMECARD) 031 → PREMIUM, 032 → COAT (구공식 FIXED인 행만)
UPDATE t_prd_product_price_formulas
   SET frm_cd='PRF_NAMECARD_PREMIUM', upd_dt=now()
 WHERE prd_cd='PRD_000031' AND frm_cd='PRF_NAMECARD_FIXED';

UPDATE t_prd_product_price_formulas
   SET frm_cd='PRF_NAMECARD_COAT', upd_dt=now()
 WHERE prd_cd='PRD_000032' AND frm_cd='PRF_NAMECARD_FIXED';

-- (SILSA 대표) 138 일반현수막 → BANNER_NORMAL (구공식 POSTER_FIXED인 행만)
-- ⚠ 전파: 나머지 27상품은 본 트랙 범위밖(별트랙·동형 자동전파). 대표 138만 교체.
UPDATE t_prd_product_price_formulas
   SET frm_cd='PRF_POSTER_BANNER_NORMAL', upd_dt=now()
 WHERE prd_cd='PRD_000138' AND frm_cd='PRF_POSTER_FIXED';

-- (PHOTOCARD) 바인딩 교체 불요 — 024/025는 PRF_PHOTOCARD_FIXED 유지(BULK 배선만 추가·step01 E).
