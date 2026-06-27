-- acryl-166-carabiner-fix.sql — 166 아크릴카라비너 완전 미적재 해소 (R1 · 라이브 COMMIT 후보)
-- 결함(§26 무결성): PRD_000166 바인딩0·공식0·본체단가comp0 = 완전 미적재(견적불가).
-- 모델: 고정가형 by-siz_cd(투명아크릴 3T+3T 접합·형상별 고정단가). 면적격자 아님(불규칙 형상·접합 프리미엄).
--   = 본체 CLEAR3T(면적) 패턴과 달리 siz_cd 정확매칭 단가행. search-before-mint: 면적격자에 자물쇠40x69(5800)셀 없음=신규 그릇 정당.
-- 권위: 가격표 B06(아크릴카라비너 3T+3T 접합) verbatim:
--   자물쇠40x69(SIZ_000366)=5800 · 하트자물쇠43x71(SIZ_000367)=5800 · 하트59x54(SIZ_000368)=6300 · 원형68x70(SIZ_000369)=6900.
-- prc_typ=PRICE_TYPE.02(합가형·총액÷min_qty×qty·본체 CLEAR3T 동형)·comp_typ.01(완제품/인쇄가공비)·min_qty=1.
-- ★수량구간할인 B07(50~99=0.1·100~=0.2)은 전 아크릴 공통 별 트랙(본체 격자도 미적재)=carry-forward(본 R1 범위 밖).
-- ★166 use_yn=N(비활성 상품)=가격그릇과 무관(활성화는 별 결정). 채번: comp_price_id 39098~39101.
-- 멱등: NOT EXISTS 가드. 단일 트랜잭션. ★실 COMMIT은 인간 승인 후. dryrun=ROLLBACK+골든.
\set ON_ERROR_STOP on
BEGIN;

-- [1] 카라비너 본체 comp (고정가형 by-siz_cd · 단일자재 MAT_043라 mat 차원 불요)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT 'COMP_ACRYL_CARABINER','아크릴카라비너 본체(3T+3T접합)','PRC_COMPONENT_TYPE.01','PRICE_TYPE.02',
       jsonb_build_array('siz_cd','min_qty'),'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_CARABINER');

-- [2] 단가행 (siz_cd 정확매칭 · 단가 verbatim · min_qty=1 → 합가형 총액=장당가)
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, min_qty, unit_price)
SELECT v.comp_price_id, 'COMP_ACRYL_CARABINER', '2026-06-28', v.siz_cd, 1, v.unit_price
FROM (VALUES
  (39098::bigint,'SIZ_000366',5800::numeric),  -- 사각자물쇠 40x69
  (39099,        'SIZ_000367',5800),           -- 하트자물쇠 43x71
  (39100,        'SIZ_000368',6300),           -- 하트 59x54
  (39101,        'SIZ_000369',6900)            -- 원형 68x70
) AS v(comp_price_id, siz_cd, unit_price)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices p
  WHERE p.comp_cd='COMP_ACRYL_CARABINER' AND p.siz_cd=v.siz_cd AND p.apply_ymd='2026-06-28'
);

-- [3] 전용공식 (본체 단일 comp)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT 'PRF_ACRYL_CARABINER','아크릴카라비너 공식','형상별 고정가(3T+3T 접합·by-siz_cd)','Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_CARABINER');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_ACRYL_CARABINER','COMP_ACRYL_CARABINER',1,'N'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_CARABINER' AND comp_cd='COMP_ACRYL_CARABINER'
);

-- [4] 상품-공식 바인딩
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000166','PRF_ACRYL_CARABINER','2026-06-28','고정가형 by-siz_cd(완전 미적재 해소·R1)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000166' AND frm_cd='PRF_ACRYL_CARABINER'
);

COMMIT;
