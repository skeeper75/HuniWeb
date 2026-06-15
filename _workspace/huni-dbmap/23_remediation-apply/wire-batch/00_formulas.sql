-- ============================================================
-- WIRE 통합 배선 — step 00: 공식분리 신규 PRF_* (t_prc_price_formulas 데이터 INSERT)
-- 권위 = NAMECARD-WIRE(phase-c-wire-remediation §1)·SILSA-WIRE(silsa-rep-5layer §5 / poster-sign §1).
-- 멱등 = ON CONFLICT (frm_cd) DO NOTHING (라이브 PK 실측: pk_t_prc_price_formulas = frm_cd).
-- 신규 컬럼·테이블 0(DDL 아님·기존 테이블 데이터 INSERT). 단가행 무관.
-- reg_dt = DEFAULT now() (NOT NULL·omit하면 default 발화). use_yn NOT NULL = 'Y'.
-- ============================================================

-- (NAMECARD) 명함 공식분리 — 고정가형 PREMIUM/COAT (033은 기존 FIXED 유지)
-- use_yn = character(1) NOT NULL·default 없음 → 명시 'Y'.
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES
 ('PRF_NAMECARD_PREMIUM','프리미엄명함 단가(고정가형·소재군x면 룩업)','명함 프리미엄 단가(용지포함). 수량x(소재군등급xS1/S2) 표 단품가 조회. 031 박 add-on 포함. [WIRE NAMECARD ⓑ 공식분리]','Y'),
 ('PRF_NAMECARD_COAT','코팅명함 단가(고정가형·소재x면 룩업)','명함 코팅 단가(용지포함). 수량x(소재xS1/S2) 표 단품가 조회. [WIRE NAMECARD ⓑ 공식분리]','Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- (SILSA 대표) 일반현수막 면적매트릭스형 공식분리 — BANNER_NORMAL 1소재
-- 단일 PRF_POSTER_FIXED에 인화지 1 comp만 배선된 결함 → 대표 현수막 자기 소재 공식 분리.
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES
 ('PRF_POSTER_BANNER_NORMAL','일반현수막 면적매트릭스가([가로][세로] 룩업)','포스터사인 일반현수막 완제품가. [가로][세로] 면적단가 x 주문수량. off-grid=한 단계 큰 크기 ceiling(엔진 런타임). [WIRE SILSA 대표 공식분리]','Y')
ON CONFLICT (frm_cd) DO NOTHING;
