-- ════════════════════════════════════════════════════════════════════════
-- cardfoil-fix-dryrun.sql  (2026-07-01)
-- 실무진 추가 옵션(박/코팅/모서리/가변/접지) 가격0 결함 → 고아 컴포넌트 배선
-- 대상: PRD_000024 포토카드 / PRD_000025 투명포토카드 / PRD_000030 지그재그엽서 /
--       PRD_000031 프리미엄명함
-- ★ DRY-RUN 전용: BEGIN … ROLLBACK. 실 COMMIT 금지(인간 승인 후 별도 -fix.sql).
-- ★ 근본원인 = 단가행 없음(X) → 단가행은 전용 컴포넌트에 이미 적재됨. 공식 미배선(고아).
--   명함 교훈 [[namecard-orphan-component-wiring-260630]] 과 동일 패턴.
-- 멱등: formula_components PK=(frm_cd,comp_cd) → ON CONFLICT DO NOTHING.
-- ════════════════════════════════════════════════════════════════════════
BEGIN;

-- ────────────────────────────────────────────────────────────────────────
-- BLOCK A [GO-READY·안전]  프리미엄명함 가변텍스트/가변이미지 배선
--   COMP_PP_VARTEXT_1EA / COMP_PP_VARIMG_1EA = PRICE_TYPE.03(고정·수량무관) → 이중과금 없음.
--   proc_grp:PROC_000085 게이팅·dim_vals={"개수":N}. PRF_DGP_A/D/E 형제에서 검증된 컴포넌트.
--   PRF_NAMECARD_PREMIUM(현 max disp_seq=4) + _FOIL(현 max=7) 양쪽에 배선(박 선택 무관 발현).
-- ────────────────────────────────────────────────────────────────────────
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES
  ('PRF_NAMECARD_PREMIUM',      'COMP_PP_VARTEXT_1EA', 5, 'Y', now()),
  ('PRF_NAMECARD_PREMIUM',      'COMP_PP_VARIMG_1EA',  6, 'Y', now()),
  ('PRF_NAMECARD_PREMIUM_FOIL', 'COMP_PP_VARTEXT_1EA', 8, 'Y', now()),
  ('PRF_NAMECARD_PREMIUM_FOIL', 'COMP_PP_VARIMG_1EA',  9, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ────────────────────────────────────────────────────────────────────────
-- BLOCK B [CONFIRM 필요·공유 컴포넌트 수정]  모서리(직각/둥근) 배선 + prc_typ 교정
--   COMP_PP_CORNER_RIGHT(통합·활성) = 직각 0원 / 둥근 tier총액(2000@100 … 11000@1000).
--   ★현재 prc_typ=PRICE_TYPE.01(단가형) → 엔진이 tier총액 × 주문수량 = 이중과금
--     (실측: 형제 엽서 둥근@100 = 200,000원 = 2000×100. 기대 2000원). 배선 전 반드시 교정.
--   교정 = .01→.03(고정). 단 COMP_PP_CORNER_RIGHT는 PRF_DGP_A/PRF_DGP_D 형제도 공유 →
--   이 교정은 형제 상품의 잠재 과대청구도 동시 해소(순효과 긍정)이나 공유변경이므로 CONFIRM.
UPDATE t_prc_price_components
   SET prc_typ_cd = 'PRICE_TYPE.03', upd_dt = now()
 WHERE comp_cd = 'COMP_PP_CORNER_RIGHT' AND prc_typ_cd = 'PRICE_TYPE.01';

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES
  ('PRF_NAMECARD_PREMIUM',      'COMP_PP_CORNER_RIGHT', 7,  'Y', now()),
  ('PRF_NAMECARD_PREMIUM_FOIL', 'COMP_PP_CORNER_RIGHT', 10, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ────────────────────────────────────────────────────────────────────────
-- 포토카드/투명포토카드 코팅·모서리·종이 = 본 dryrun 제외 [CONFIRM].
--   근거: 세트고정가 모델(PRICE_TYPE.02·siz_cd·20장세트)은 판수 개념 부재.
--   · 코팅 COMP_COAT_*(.01·plt_siz+판수 기반)는 세트모델에 환산 불가 → 세트단위 .03 정액표
--     신설 or 권위 엑셀 코팅단가 확인 필요.
--   · 모서리는 BLOCK B와 동일 .03 교정 후 배선 가능하나, 세트 수량기준(qty=20)과
--     코너 격자 tier(1/100/…) 정합 확인 필요.
--   · 종이(아트지300g/PET)는 세트가격이 mat_cd로 분기 안 됨(opt_grp:OPT_000084='제작방식'
--     이지 종이 아님) → 종이별 가격차 유무 권위 확인 필요(무료선택이면 무배선).
-- 지그재그엽서 접지 = 위양성(NO-OP). COMP_FOLD_CARD_6CR 이미 배선+발현
--   (실측 30,000@100 · 75,000@500). 옵션 6단미싱/6단오시는 fold비 동일(proc 무관·min_qty).
--   단 옵션 ref 라벨 스왑(6단미싱접지→PROC_000073=DB상 '6단오시접지') = 라벨 CONFIRM(비금액).
-- ────────────────────────────────────────────────────────────────────────

-- 검증: 배선 결과 확인(ROLLBACK 전 육안)
SELECT fc.frm_cd, fc.comp_cd, fc.disp_seq, pc.prc_typ_cd
  FROM t_prc_formula_components fc
  JOIN t_prc_price_components pc ON pc.comp_cd = fc.comp_cd
 WHERE fc.frm_cd IN ('PRF_NAMECARD_PREMIUM','PRF_NAMECARD_PREMIUM_FOIL')
 ORDER BY fc.frm_cd, fc.disp_seq;

ROLLBACK;   -- ★ 절대 COMMIT 금지
