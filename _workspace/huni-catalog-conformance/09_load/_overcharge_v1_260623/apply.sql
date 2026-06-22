-- =====================================================================
-- apply.sql — V1 과대청구(단/양면 print_opt_cd NULL) 교정 멱등 적재
-- §21 카탈로그 정합 · 2026-06-23 · huni-catalog-conformance/09_load/_overcharge_v1_260623
--
-- 권위: overcharge-remediation-spec.md V1 (OC-01/02/03) + shared-range.md(C-1·공유범위 실측).
-- 대상:
--   명함  PRD_000031/032/033 ← 공식 PRF_NAMECARD_FIXED ← COMP_NAMECARD_STD_S1(단면)/S2(양면)
--   엽서북 PRD_000094          ← 공식 PRF_PCB_FIXED       ← COMP_PCB_S1_20P(단면)/S2_20P(양면)
-- 교정 = 판별축(print_opt_cd) 충전 + use_dims 토큰 등재 → pricing.py _row_matches 택일 분리.
--
-- ★C-1 정정(라이브 실측): print_opt_cd FK = t_prt_print_options(NOT t_cod_base_codes).
--   실재 코드 POPT_000001=단면·POPT_000002=양면 (use_yn=Y·del_yn=N). mint/DDL 0.
--   → 본 SQL은 기존 코드 참조만(INSERT 없음). 거버넌스 §12 불요.
--
-- ★[HARD] 제약:
--   - unit_price 절대 불변 (이 SQL은 unit_price를 SET 하지 않는다 — SET 구문 0개)
--   - 기초코드/print_options 마스터 INSERT/UPDATE 0 (참조만)
--   - 기본 ROLLBACK (DRY-RUN). 실 COMMIT은 인간 승인 + apply.sh --commit.
--
-- ★멱등성: 자연키(comp_cd)로 매칭 UPDATE + IS DISTINCT 가드 → 재실행 no-op(수렴).
-- ★FK 위상: print_opt_cd 충전 전 부모(t_prt_print_options POPT_000001/002) 실재 확인됨(가드 G-2).
-- ★단면/양면 양방향 충전(OC-03 codex 신규): S1=단면·S2=양면 둘 다 충전(단면만 X) → 양면 선택도 정상 단일값.
-- =====================================================================

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------
-- 가드 G-0: verbatim 기준선 캡처 (적재 후 동일성 검증용)
-- ---------------------------------------------------------------------
CREATE TEMP TABLE _verbatim_before ON COMMIT DROP AS
SELECT comp_cd, count(*) AS rows, sum(unit_price) AS sum_price
FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_PCB_S1_20P','COMP_PCB_S2_20P')
GROUP BY comp_cd;

-- =====================================================================
-- PHASE A — 단가행 print_opt_cd 충전 (단면=POPT_000001·양면=POPT_000002)
--   각 comp의 전 단가행에 동일 면 코드 충전. unit_price 미변경(verbatim).
--   IS DISTINCT 가드 → 재실행 no-op.
-- =====================================================================

-- A-1. COMP_NAMECARD_STD_S1 (명함 단면) → POPT_000001
UPDATE t_prc_component_prices SET print_opt_cd = 'POPT_000001'
WHERE comp_cd = 'COMP_NAMECARD_STD_S1' AND (print_opt_cd IS DISTINCT FROM 'POPT_000001');

-- A-2. COMP_NAMECARD_STD_S2 (명함 양면) → POPT_000002
UPDATE t_prc_component_prices SET print_opt_cd = 'POPT_000002'
WHERE comp_cd = 'COMP_NAMECARD_STD_S2' AND (print_opt_cd IS DISTINCT FROM 'POPT_000002');

-- A-3. COMP_PCB_S1_20P (엽서북 단면) → POPT_000001
UPDATE t_prc_component_prices SET print_opt_cd = 'POPT_000001'
WHERE comp_cd = 'COMP_PCB_S1_20P' AND (print_opt_cd IS DISTINCT FROM 'POPT_000001');

-- A-4. COMP_PCB_S2_20P (엽서북 양면) → POPT_000002
UPDATE t_prc_component_prices SET print_opt_cd = 'POPT_000002'
WHERE comp_cd = 'COMP_PCB_S2_20P' AND (print_opt_cd IS DISTINCT FROM 'POPT_000002');

-- =====================================================================
-- PHASE B — use_dims에 print_opt_cd 토큰 등재 (판별차원 명시·경고 제거)
--   명함 use_dims: ["mat_cd","min_qty"] → ["mat_cd","min_qty","print_opt_cd"]
--   PCB  use_dims: ["siz_cd","min_qty"] → ["siz_cd","min_qty","print_opt_cd"]
--   IS DISTINCT 가드 → 재실행 no-op.
-- =====================================================================

UPDATE t_prc_price_components SET use_dims = '["mat_cd","min_qty","print_opt_cd"]'::jsonb
WHERE comp_cd = 'COMP_NAMECARD_STD_S1'
  AND use_dims IS DISTINCT FROM '["mat_cd","min_qty","print_opt_cd"]'::jsonb;
UPDATE t_prc_price_components SET use_dims = '["mat_cd","min_qty","print_opt_cd"]'::jsonb
WHERE comp_cd = 'COMP_NAMECARD_STD_S2'
  AND use_dims IS DISTINCT FROM '["mat_cd","min_qty","print_opt_cd"]'::jsonb;
UPDATE t_prc_price_components SET use_dims = '["siz_cd","min_qty","print_opt_cd"]'::jsonb
WHERE comp_cd = 'COMP_PCB_S1_20P'
  AND use_dims IS DISTINCT FROM '["siz_cd","min_qty","print_opt_cd"]'::jsonb;
UPDATE t_prc_price_components SET use_dims = '["siz_cd","min_qty","print_opt_cd"]'::jsonb
WHERE comp_cd = 'COMP_PCB_S2_20P'
  AND use_dims IS DISTINCT FROM '["siz_cd","min_qty","print_opt_cd"]'::jsonb;

-- ---------------------------------------------------------------------
-- 가드 G-1: verbatim 게이트 — 적재 전후 단가행 행수·합 동일성
-- ---------------------------------------------------------------------
DO $$
DECLARE v_bad int;
BEGIN
  SELECT count(*) INTO v_bad
  FROM _verbatim_before b
  JOIN (SELECT comp_cd, count(*) rows, sum(unit_price) sum_price
        FROM t_prc_component_prices
        WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_PCB_S1_20P','COMP_PCB_S2_20P')
        GROUP BY comp_cd) a ON a.comp_cd=b.comp_cd
  WHERE a.rows <> b.rows OR a.sum_price IS DISTINCT FROM b.sum_price;
  IF v_bad > 0 THEN
    RAISE EXCEPTION 'VERBATIM GUARD FAILED: % comp(s) changed row count or price sum', v_bad;
  END IF;
  RAISE NOTICE 'VERBATIM GUARD PASSED: 단가행 행수·합 불변 확인 (명함 7300/9300·PCB 505980/526540)';
END $$;

-- ---------------------------------------------------------------------
-- 가드 G-2: FK 충족 — 충전한 print_opt_cd 모두 마스터 실재(고아 0)
-- ---------------------------------------------------------------------
DO $$
DECLARE v_orphan int;
BEGIN
  SELECT count(*) INTO v_orphan
  FROM (SELECT DISTINCT print_opt_cd FROM t_prc_component_prices
        WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_PCB_S1_20P','COMP_PCB_S2_20P')
          AND print_opt_cd IS NOT NULL) cp
  LEFT JOIN t_prt_print_options o ON o.print_opt_cd = cp.print_opt_cd
  WHERE o.print_opt_cd IS NULL OR o.del_yn <> 'N';
  IF v_orphan > 0 THEN
    RAISE EXCEPTION 'FK GUARD FAILED: % orphan/deleted print_opt_cd(s)', v_orphan;
  END IF;
  RAISE NOTICE 'FK GUARD PASSED: print_opt_cd 전부 t_prt_print_options 실재(POPT_000001/002)';
END $$;

-- ---------------------------------------------------------------------
-- 적재 후 상태 리포트
-- ---------------------------------------------------------------------
\echo '--- component_prices print_opt_cd 충전 + verbatim 합 ---'
SELECT comp_cd, COALESCE(print_opt_cd,'<NULL>') AS print_opt_cd, count(*) AS rows, sum(unit_price) AS sum_price
FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_PCB_S1_20P','COMP_PCB_S2_20P')
GROUP BY comp_cd, print_opt_cd ORDER BY comp_cd;

\echo '--- price_components use_dims ---'
SELECT comp_cd, use_dims::text FROM t_prc_price_components
WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_PCB_S1_20P','COMP_PCB_S2_20P')
ORDER BY comp_cd;

-- =====================================================================
-- 기본 ROLLBACK (DRY-RUN). 실 적재는 인간 승인 후 COMMIT 모드.
-- =====================================================================
ROLLBACK;
