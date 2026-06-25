-- ============================================================================
-- price-pilot-hc072/apply.sql — 하드커버책자(PRD_000072) 가격 민팅 (READY 비목만)
-- 생성: hsp-set-designer · DB 미적재(설계 초안) · 실 COMMIT은 게이트 GO + 인간 승인 후
-- BEGIN/COMMIT 미내장(load-executor가 트랜잭션 래핑) · 멱등 · FK 위상정렬
--
-- ★범위: PRF 정의 + formula_components(READY 3비목 + PARTIAL 1비목).
--   재사용 comp(COMP_BIND_HC_MUSEON·COMP_PRINT_DIGITAL_S1/S2·COMP_COAT_MATTE) =
--   라이브 실재 → price_components/component_prices INSERT 없음(search-before-mint).
-- ★미포함(BLOCKED·날조 금지): (2)용지비 COMP_PAPER 배선·단가 / (6)후가공박 comp·단가 /
--   PARTIAL 유광 코팅 단가 / 바인딩(t_prd_product_price_formulas) — 용지비 해소 후.
-- ============================================================================

-- ── FK 위상 1: price_formulas (parent) ─────────────────────────────────────
-- PK=frm_cd · 멱등 ON CONFLICT DO NOTHING (라이브 PRF_HC% 0행 실측·충돌 0)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, note)
VALUES (
  'PRF_HC_MUSEON_SUM',
  '하드커버무선책자 원자합산형(내지인쇄+표지인쇄+표지코팅+제본+용지+후가공)',
  'Y',
  '6비목 Σ·calc-formula L48·set-authority §1.1·hsp-set-designer 2026-06-25'
)
ON CONFLICT (frm_cd) DO NOTHING;

-- ── FK 위상 2: formula_components (child·comp_cd는 라이브 실재 FK 충족) ──────
-- PK=(frm_cd, comp_cd) · 멱등 ON CONFLICT DO NOTHING
-- ★READY 3비목 + PARTIAL 1비목(무광)만. BLOCKED 2비목(용지비·후가공박) 미배선.
-- ★표지인쇄=S1 / 내지인쇄=S2 별 comp (PK 충돌·동시매칭 가드·CFM-HC-PRINT)

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES
  ('PRF_HC_MUSEON_SUM', 'COMP_BIND_HC_MUSEON',   1, 'Y'),  -- (5)제본비   READY
  ('PRF_HC_MUSEON_SUM', 'COMP_PRINT_DIGITAL_S1', 2, 'Y'),  -- (3)표지인쇄 READY
  ('PRF_HC_MUSEON_SUM', 'COMP_COAT_MATTE',       3, 'Y'),  -- (4)표지코팅 PARTIAL(무광)
  ('PRF_HC_MUSEON_SUM', 'COMP_PRINT_DIGITAL_S2', 4, 'Y')   -- (1)내지인쇄 READY
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ── BLOCKED (미포함·날조 금지) ─────────────────────────────────────────────
-- (2)용지비 : COMP_PAPER 배선 보류 — 072 자재 4종(MAT_000246/001/002/003) 단가행 0행.
--             dbmap 가격표 종이비 재추출 후 component_prices 추가 + 본 배선 INSERT.
-- (6)후가공박: COMP_FOIL_LARGE_PLATE/PROC_STD/PROC_SPC 미민팅 — §18+dbmap(foil-large 194행).
-- (4)유광코팅: COMP_COAT_GLOSSY 단가행 0행(R7 드리프트) — 유광 선택 경로 BLOCKED.

-- ── 바인딩 (보류·돈크리티컬 가드) ──────────────────────────────────────────
-- ★INSERT INTO t_prd_product_price_formulas (PRD_000072, PRF_HC_MUSEON_SUM, '2026-06-01')
--   는 6비목 전부 READY 후 실행. 용지비 BLOCKED 상태 바인딩 = 용지 누락 과소청구.
--   PK=(prd_cd, apply_bgn_ymd) · 072 현재 0행 · ON CONFLICT DO NOTHING.

-- ── 멱등성 검증 (DRY-RUN·롤백전용) ─────────────────────────────────────────
-- before: PRF_HC% 0 / formula_components(PRF_HC_MUSEON_SUM) 0
-- after 1st apply: PRF 1 / fc 4
-- after 2nd apply: 동일(ON CONFLICT DO NOTHING delta 0)
-- rollback 후 0 복원. (load-executor R1~R6 게이트에서 실증)
