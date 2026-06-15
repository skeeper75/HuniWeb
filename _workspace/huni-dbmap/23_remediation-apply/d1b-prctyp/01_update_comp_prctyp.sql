-- =====================================================================
-- 01_update_comp_prctyp.sql  (round-13 정정 트랙 · D-1b · step 01)
-- 권위: phase-b-d1b-remediation.md §3-2 (IN절 = 13 comp 정확히) — 재설계 0.
-- 무엇: 그룹① 후가공 .04 comp 13종의 prc_typ_cd 메타를 '.01' → '.03'(구간고정총액형)으로 정정.
--
-- [돈-크리티컬 보증]
--   * t_prc_price_components.prc_typ_cd 메타 1컬럼만 변경 + upd_dt=now().
--   * t_prc_component_prices.unit_price(단가행) 절대 미변경 — 값은 가격표 전건 일치(round-16 216/216).
--     이 파일은 component_prices를 단 한 행도 건드리지 않는다.
--   * 보정 하드코딩 0 — 값 주입 없음.
--
-- [라이브 실측 재확인 2026-06-15 — phase-b §3-1 표 재현, stale 방지]
--   comp_cd               | 현 prc_typ    | comp_typ              | 단가행 | 단조성
--   COMP_PP_CREASE_1L     | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 10     | 누진 5000→105000
--   COMP_PP_CREASE_2L     | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 10     | 누진(동형)
--   COMP_PP_CREASE_3L     | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 10     | 누진(동형)
--   COMP_PP_PERF_1L       | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 10     | 누진 5000→105000  ← 상품권 핵심
--   COMP_PP_PERF_2L       | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 10     | 누진
--   COMP_PP_PERF_3L       | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 10     | 누진
--   COMP_PP_VARTEXT_1EA   | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 23     | 누진
--   COMP_PP_VARTEXT_2EA   | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 23     | 누진
--   COMP_PP_VARTEXT_3EA   | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 23     | 누진
--   COMP_PP_VARIMG_1EA    | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 23     | 누진
--   COMP_PP_VARIMG_2EA    | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 23     | 누진
--   COMP_PP_VARIMG_3EA    | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 23     | 누진
--   COMP_PP_CORNER_ROUND  | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.04 | 9      | 누진 2000→51000
--   [제외] COMP_PP_CORNER_RIGHT  | 9행 전구간 0.00 → 가격 기여 0(정정 무의미)
--   [제외] COMP_CUT_PERF_1H6     | 23행 전구간 0.00(Phase A·0원 placeholder) → 제외
--   * 13 comp 중 현재 .03인 행 = 0(실측) → 1회차 13행 UPDATE 예상.
--
-- 멱등: AND prc_typ_cd <> 'PRICE_TYPE.03' 가드 → 재실행 시 0행(delta 0).
-- 전제: step 00 base_code PRICE_TYPE.03 선적재 완료 + 엔진 .03 규칙 동시 배포(webadmin Phase11).
-- =====================================================================

UPDATE t_prc_price_components
SET prc_typ_cd = 'PRICE_TYPE.03',
    upd_dt     = now()
WHERE comp_cd IN (
  'COMP_PP_CREASE_1L','COMP_PP_CREASE_2L','COMP_PP_CREASE_3L',
  'COMP_PP_PERF_1L','COMP_PP_PERF_2L','COMP_PP_PERF_3L',
  'COMP_PP_VARTEXT_1EA','COMP_PP_VARTEXT_2EA','COMP_PP_VARTEXT_3EA',
  'COMP_PP_VARIMG_1EA','COMP_PP_VARIMG_2EA','COMP_PP_VARIMG_3EA',
  'COMP_PP_CORNER_ROUND'      -- 둥근모서리(누진 총액형 · 진성 정정 대상)
)
AND prc_typ_cd <> 'PRICE_TYPE.03';   -- 멱등 가드(재실행 delta 0)
-- 제외 확정(IN절 미포함): COMP_PP_CORNER_RIGHT(직각·0원) · COMP_CUT_PERF_1H6(타공 placeholder·0원)
-- 그룹② .06/.05(박·완칼)은 CONFIRM:D1b-06 해소 + Phase C 박 배선 후 별도(본 파일 미발행).
