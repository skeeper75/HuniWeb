-- ============================================================================
-- price-pilot-hc072/apply.sql — 하드커버책자(PRD_000072) 가격공식 민팅 (load-ready)
-- 생성: hsp-set-designer · 2026-06-25 라이브 재실측 기반 · DB 미적재(설계 초안)
--   실 COMMIT은 게이트 GO + 인간 승인 후. BEGIN/COMMIT 미내장(load-executor가 트랜잭션 래핑).
--   멱등 · FK 위상정렬 · 단가 verbatim · search-before-mint(신규 단가행 0).
--
-- ★범위: PRF 정의 1행 + formula_components 4배선(READY 비목만).
--   재사용 comp(전부 del_yn='N' 활성):
--     COMP_BIND_SSABARI(제본·PROC_000023 byte동일·HC_MUSEON del_yn=Y 대체)
--     COMP_PRINT_DIGITAL_S1(표지인쇄)·COMP_COAT_MATTE(표지코팅 무광)·COMP_PAPER(표지용지비)
--   → price_components/component_prices INSERT 없음(전 comp·단가행 라이브 실재).
--
-- ★미포함(BLOCKED/N/A·날조 금지):
--   (1)내지인쇄비 = COMP_PRINT_DIGITAL_S2 del_yn='Y'(삭제)·S1 PK점유 → 2번째 활성 인쇄 comp 부재.
--                  dbmap COMP_PRINT_BOOK_INNER mint(S1 단가 복제) 후 seq5 배선. 돈크리티컬(최대 비목).
--   (2)내지 용지비 = 2번째 평가슬롯 필요(내지인쇄와 묶음 BLOCKED).
--   (6)후가공박 = 072 박 공정 미등록(권위+라이브 2중) = N/A.
-- ============================================================================

-- ── FK 위상 1: price_formulas (parent) ─────────────────────────────────────
-- PK=frm_cd · 멱등 ON CONFLICT DO NOTHING (라이브 PRF_HC% 0행 실측·충돌 0)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, note)
VALUES (
  'PRF_HC_MUSEON_SUM',
  '하드커버무선책자 원자합산형(제본+표지인쇄+표지코팅+용지비 ※내지인쇄 BLOCKED·후가공 N/A)',
  'Y',
  'calc-formula seq64·set-authority §1.1·hsp-set-designer 2026-06-25'
)
ON CONFLICT (frm_cd) DO NOTHING;

-- ── FK 위상 2: formula_components (child·comp_cd FK는 라이브 활성 comp 충족) ──
-- PK=(frm_cd, comp_cd) · 멱등 ON CONFLICT DO NOTHING
-- ★READY 4비목만(전부 del_yn='N' 활성). 내지인쇄(BLOCKED)·후가공박(N/A) 미배선.
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES
  ('PRF_HC_MUSEON_SUM', 'COMP_BIND_SSABARI',     1, 'Y'),  -- (5)제본비   READY(활성·PROC_000023 byte동일)
  ('PRF_HC_MUSEON_SUM', 'COMP_PRINT_DIGITAL_S1', 2, 'Y'),  -- (3)표지인쇄 READY(활성)
  ('PRF_HC_MUSEON_SUM', 'COMP_COAT_MATTE',       3, 'Y'),  -- (4)표지코팅 READY(무광·코팅 1회·이중계상 0)
  ('PRF_HC_MUSEON_SUM', 'COMP_PAPER',            4, 'Y')   -- (2)표지용지비 READY(아트150 46.65 순수 절가)
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ── BLOCKED (미포함·날조 금지·dbmap 위임) ──────────────────────────────────
-- (1)내지인쇄: INSERT ... ('PRF_HC_MUSEON_SUM','COMP_PRINT_BOOK_INNER',5,'Y')
--             — COMP_PRINT_BOOK_INNER가 라이브에 mint된 후(dbmap·S1 단가 verbatim 복제) 추가.
--             (S2 del_yn='Y' 삭제이므로 S2 배선 금지.)
-- (2)내지용지비: 내지 평가슬롯 해소 시 추가.
-- (6)후가공박: 072 미적용(N/A).

-- ── 바인딩 (보류·돈크리티컬 가드·내지인쇄 해소 후 주석 해제) ─────────────────
-- ★INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd)
--   VALUES ('PRD_000072', 'PRF_HC_MUSEON_SUM', '2026-06-01')
--   ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;
--   → 6비목 전부 READY(내지인쇄+내지용지비 해소) 후 실행.
--     내지인쇄(책자 최대 비목·총내지매수 곱) BLOCKED 상태 바인딩 = 파국적 과소청구.
--   072 현재 바인딩 0행(실측) → 충돌 0·멱등 가능.

-- ── 멱등성 검증 (DRY-RUN·롤백전용·load-executor R1~R6) ──────────────────────
-- before: PRF_HC% 0 / formula_components(PRF_HC_MUSEON_SUM) 0 / 072 바인딩 0
-- after 1st apply: PRF 1 / fc 4 / 바인딩 0(주석)
-- after 2nd apply: 동일(ON CONFLICT DO NOTHING delta 0)
-- rollback 후 0 복원.
