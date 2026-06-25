-- ============================================================================
-- 072 하드커버책자 — 셋트 하이브리드 가격 적재본 (멱등·FK 위상정렬)
-- 생성: hsp-set-designer 2026-06-25 · DB 미적재(게이트 GO + 인간 승인 후 load-executor)
-- 모델: 구성원 표지(073)=PRF_HC_COVER · 셋트본체(072)=PRF_HC_BODY(내지+제본) · 면지=무료
-- 단가 verbatim·신규 단가행 0(전 comp/단가행 재사용·S2는 부활 토글).
-- BEGIN/COMMIT 미내장(load-executor가 단일 트랜잭션 래핑).
-- FK 위상: price_components(S2 부활) → price_formulas → formula_components → product_price_formulas
-- ============================================================================

-- ── [0] 선행: COMP_PRINT_DIGITAL_S2 부활 (양면 내지·s2_revive.sql 통합) ──────────
UPDATE t_prc_price_components
   SET del_yn = 'N'
 WHERE comp_cd = 'COMP_PRINT_DIGITAL_S2' AND del_yn = 'Y';

-- ── [1] 가격공식 정의 PRF_HC_COVER / PRF_HC_BODY (멱등·PK=frm_cd) ────────────────
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
VALUES
 ('PRF_HC_COVER',
  '하드커버책자 표지 구성원 공식(표지인쇄+표지코팅+표지용지)',
  '하이브리드 표지 반제품 073 자기공식·표지인쇄S1+무광코팅+아트150용지·hsp 2026-06-25',
  'Y', now()),
 ('PRF_HC_BODY',
  '하드커버책자 셋트본체 공식(내지인쇄+내지용지+제본)',
  '하이브리드 셋트 완제품 072 자기공식·내지인쇄S2(양면)+내지용지+SSABARI제본·CFM-INNER-TOTSHEET 잔존',
  'Y', now())
ON CONFLICT (frm_cd) DO NOTHING;

-- ── [2] formula_components (멱등·PK=(frm_cd,comp_cd)·multiplier 컬럼 없음) ────────
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES
 -- 표지 구성원 공식 (PRF_HC_COVER)
 ('PRF_HC_COVER', 'COMP_PRINT_DIGITAL_S1', 1, 'Y', now()),   -- 표지인쇄(단면)
 ('PRF_HC_COVER', 'COMP_COAT_MATTE',       2, 'Y', now()),   -- 표지코팅(무광 단면)
 ('PRF_HC_COVER', 'COMP_PAPER',            3, 'Y', now()),   -- 표지용지(아트150)
 -- 셋트 본체 공식 (PRF_HC_BODY)
 ('PRF_HC_BODY',  'COMP_PRINT_DIGITAL_S2', 1, 'Y', now()),   -- 내지인쇄(양면·S2 부활)
 ('PRF_HC_BODY',  'COMP_PAPER',            2, 'Y', now()),   -- 내지용지
 ('PRF_HC_BODY',  'COMP_BIND_SSABARI',     3, 'Y', now())    -- 제본(하드커버무선)
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ── [3] 상품-공식 바인딩 (멱등·PK=(prd_cd,apply_bgn_ymd)) ────────────────────────
-- ★바인딩 가드 [HARD]: 아래는 게이트 GO + CFM-INNER-TOTSHEET/CFM-INNER-PLATE/
--   CFM-COVER-SPREAD-SIZ 해소 후에만 주석 해제(미해소 시 내지 페이지곱 과소청구 가드).
-- INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
-- VALUES
--  ('PRD_000073', 'PRF_HC_COVER', '2026-06-01', '표지 구성원 공식 바인딩', now()),
--  ('PRD_000072', 'PRF_HC_BODY',  '2026-06-01', '셋트 본체 공식 바인딩(내지+제본)', now())
-- ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- ============================================================================
-- 멱등 검증(롤백 전):
--   SELECT frm_cd FROM t_prc_price_formulas WHERE frm_cd IN ('PRF_HC_COVER','PRF_HC_BODY');           -- 2
--   SELECT frm_cd, comp_cd, disp_seq FROM t_prc_formula_components
--    WHERE frm_cd IN ('PRF_HC_COVER','PRF_HC_BODY') ORDER BY frm_cd, disp_seq;                          -- 6
--   SELECT comp_cd, del_yn FROM t_prc_price_components WHERE comp_cd='COMP_PRINT_DIGITAL_S2';            -- N
--   SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_DIGITAL_S2';                   -- 212 (불변)
-- 2회 실행 시 INSERT 0(ON CONFLICT)·UPDATE 0(del_yn 이미 N) → delta 0(멱등).
-- ============================================================================
