-- ============================================================
-- WIRE 통합 배선 — step 01: 공식↔구성요소 배선 (t_prc_formula_components 데이터 INSERT)
-- 권위 = NAMECARD-WIRE(phase-c §1-3·§3-2)·SILSA-WIRE(silsa-rep §5)·PHOTOCARD-BULK-WIRE(photocard-rep §5).
-- 멱등 = ON CONFLICT (frm_cd, comp_cd) DO NOTHING (라이브 PK 실측: t_prc_formula_components_pkey = frm_cd,comp_cd).
-- comp 전건 라이브 실재 확인됨(2026-06-15). 단가행 무관·신설 0. addtn_yn NOT NULL 아님(YES)이나 명시.
-- 선행: 00_formulas.sql(PREMIUM/COAT/BANNER_NORMAL 공식) — FK fk_prc_formula_comps_frm_cd.
-- ============================================================

-- ── (A) NAMECARD PREMIUM 배선 (031 프리미엄·소재군 A/B x 면 = 4 comp 본체) ──
-- src: phase-c-wire-remediation §1-3 (2)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES
 ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_PREMIUM_S1_MGA',1,'Y'),
 ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_PREMIUM_S1_MGB',2,'Y'),
 ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_PREMIUM_S2_MGA',3,'Y'),
 ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_PREMIUM_S2_MGB',4,'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ── (B) NAMECARD PREMIUM 031 박 add-on 배선 (FOIL 본체+셋업 = 6 comp) ──
-- src: phase-c-wire-remediation §3-2. 명함 박=종이포함 완제품가·add-on 합산(본체+박)·addtn_yn=Y.
-- 박 미선택 시 comp 미매칭→합산 0(정상). 명함 박 면적등급 차원 불요(완제품가 수량 1D 흡수).
-- ⚠ FOIL_SETUP 별도 배선 = WIRE-3b(동판 명함단가 흡수 여부) 의존 — 본 배선은 제안본 §3-2 verbatim,
--    동판 이중계상 우려는 DRY-RUN §골든에서 명시(C4 CONDITIONAL).
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES
 ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_FOIL_S1_STD',11,'Y'),
 ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_FOIL_S1_HOLO',12,'Y'),
 ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_FOIL_S2_STD',13,'Y'),
 ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_FOIL_S2_HOLO',14,'Y'),
 ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_FOIL_SETUP_S1_STD',15,'Y'),
 ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_FOIL_SETUP_S2_STD',16,'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ── (C) NAMECARD COAT 배선 (032 코팅·면별 = 2 comp·소재는 단가행 mat_cd 룩업) ──
-- src: phase-c-wire-remediation §1-3 (2)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES
 ('PRF_NAMECARD_COAT','COMP_NAMECARD_COAT_S1',1,'Y'),
 ('PRF_NAMECARD_COAT','COMP_NAMECARD_COAT_S2',2,'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ── (D) SILSA 대표 BANNER_NORMAL 배선 (현수막 본체 1 comp) ──
-- src: silsa-rep-5layer §5 / poster-sign-decomposition §1. 면적매트릭스 본체·use_dims [siz_cd].
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES
 ('PRF_POSTER_BANNER_NORMAL','COMP_POSTER_BANNER_NORMAL',1,'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ── (E) PHOTOCARD BULK 배선 (순수 배선 — 기존 공식 PRF_PHOTOCARD_FIXED에 BULK 추가) ──
-- src: photocard-rep-5layer §5. SET/CLEAR_SET 이미 배선(disp1/2)·BULK 50구간 미배선 → disp3 추가.
-- 모드 분기(세트 vs 대량)는 엔진 영역(주문방식 입력) — 본 트랙은 배선만. comp/단가 신설 0.
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES
 ('PRF_PHOTOCARD_FIXED','COMP_PHOTOCARD_BULK',3,'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
