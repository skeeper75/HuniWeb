-- t36 apply — 스티커 판형환산 가격구성요소 use_dims 배선
-- 작성 2026-09-04 · run 레인 · 입력 = .moai/reports/price-defects-260904/FINDINGS.md 결함1
--
-- ★★ 이 파일은 COMMIT 되지 않았다. verdict.md 판정 = COMMIT 보류.
--    선행조건(스티커 상품 판형 등록을 국4절 SIZ_000499 로 복구)이 충족된 뒤에만 실행할 것.
--    지금 실행하면 A6·100x140 이 권위(8판)와 다른 9판으로 환산된다(verdict.md §3).
--
-- 범위: t_prc_price_components.use_dims 만. 단가행(t_prc_component_prices) 무변경.
--       단가행 plt_siz_cd 는 전건 NULL = 와일드카드라 손댈 필요가 없다(전건 실측 확인).
--
-- ────────────────────────────────────────────────────────────────────────
-- 대상 축소 근거 — 카드가 지목한 5건 중 실제 적격은 1건뿐이다.
-- 권위 `후니프린팅_인쇄상품_가격표_260903.xlsx` 「스티커」 시트 헤더 실독 결과:
--
--   STK_KISSCUT_PRINT    r1 「반칼 자유형/규격 스티커 (국4절)」 · r5 「소재 / 수량(국4절)」
--                        r4 판걸이수 명시(A5(4판)·A4(2판)·A3(1판)·90*190(6판)·A6(8판))
--                        → 판형환산 대상 ✅
--   STK_CUT_PRINT        r47 「국4절에 인쇄하는 것이 아니기 때문에 판걸이수 상관없음」
--                        r50 「옵션/ 제작수량」(국4절 아님) → 대상 아님 ❌
--   STK_CUT_CLEAR_PRINT  r60 동일 문구 · r63 「옵션/ 제작수량」 → 대상 아님 ❌
--   STK_CUT_LARGE_PRINT  r73 동일 문구 · r76 「옵션/ 제작수량」 → 대상 아님 ❌
--   COMP_STK_PRINT       반칼·완칼 혼재 그릇(25사이즈 5,064행). 완칼 사이즈(A3·A2·400x600)는
--                        판수 0, 치수 미입력(B3·B4·100x148·90x110)은 판수 NULL.
--                        추가 시 그 12사이즈가 「판수 환산 불가」로 막힌다 → 대상 아님 ❌
--                        (그릇 분리는 t36 범위 밖 — 단가행 이동이 필요하다)
--
-- 따라서 아래 UPDATE 는 STK_KISSCUT_PRINT 한 건만 건드린다.
-- ────────────────────────────────────────────────────────────────────────

BEGIN;

-- 적용 전 상태 확인(멱등 가드) — 이미 plt_siz_cd 가 있으면 0행 갱신된다.
UPDATE t_prc_price_components
   SET use_dims = '["siz_cd", "mat_cd", "plt_siz_cd", "min_qty"]'::jsonb,
       upd_dt   = now()
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND use_dims = '["siz_cd", "mat_cd", "min_qty"]'::jsonb;

-- 검산: 1행이어야 한다(이미 적용된 상태면 0행 = 멱등).
SELECT comp_cd, use_dims
  FROM t_prc_price_components
 WHERE comp_cd = 'STK_KISSCUT_PRINT';

COMMIT;
