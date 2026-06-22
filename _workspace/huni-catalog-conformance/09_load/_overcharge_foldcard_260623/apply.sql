-- =====================================================================
-- apply.sql — 접지카드 과대청구(V2) 교정 멱등 적재 — ★FULL (인간 승인 완료)
-- §21 카탈로그 정합 · 2026-06-23 · huni-catalog-conformance/09_load/_overcharge_foldcard_260623
--
-- 권위: overcharge-remediation-spec.md V2 + hbg fold-process-registration-spec.md(승인분).
-- 승인된 컨펌(CONF-FOLD-1/2/3):
--   - 4ACC  → PROC_000071(병풍접지) 재사용
--   - 4GATE → 신규 PROC_000106(4단대문접지)
--   - HALF  → 신규 PROC_000107(반접지·★2단접지 PROC_000059와 별개)
--   - disp_seq 19·20
-- 대상: PRD_000027/028/029 바인딩 공식 PRF_DGP_E의 4 FOLD_LEAF comp.
-- 교정 = 판별축(proc_cd) 충전 + use_dims 토큰 등재 → pricing.py P8-1 택일 분리.
--
-- ★[HARD] 제약:
--   - unit_price 절대 불변 (이 SQL은 unit_price를 SET 하지 않는다 — SET 구문 0개)
--   - 기초코드는 명세대로 2건만 INSERT (임의 추가 0)
--   - 기본 ROLLBACK (DRY-RUN). 실 COMMIT은 apply.sh --commit + 인간 승인.
--
-- ★멱등성:
--   - t_proc_processes: PK=proc_cd → ON CONFLICT (proc_cd) DO NOTHING (재실행 no-op)
--   - component_prices/price_components: 자연키(comp_cd)로 매칭 UPDATE + IS DISTINCT 가드 (수렴·재실행 no-op)
--
-- ★FK 위상: Phase A(마스터 106/107 선적재) → Phase B(단가행 proc_cd 충전).
--   component_prices.proc_cd → t_proc_processes(fk_comp_prices_proc). 부모 선행 필수.
-- =====================================================================

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------
-- 가드 G-0: 적재 전 단가행 합(verbatim 기준선) 캡처 → 적재 후 동일성 검증용
-- ---------------------------------------------------------------------
CREATE TEMP TABLE _verbatim_before ON COMMIT DROP AS
SELECT comp_cd, count(*) AS rows, sum(unit_price) AS sum_price
FROM t_prc_component_prices
WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%'
GROUP BY comp_cd;

-- =====================================================================
-- PHASE A — 기초코드 마스터 신규 등록 (FK 선행) [멱등 ON CONFLICT]
--   명세대로 2건만. 부모 PROC_000056(접지) 실재 확인됨(self-FK 충족).
--   채번 재실측: MAX num=105 → 106/107 유효(2026-06-23 재확인). 임의 추가 0.
-- =====================================================================

-- A-1. PROC_000106 — 4단대문접지 (신규)
INSERT INTO t_proc_processes (proc_cd, proc_nm, upr_proc_cd, disp_seq, use_yn, del_yn, note)
VALUES ('PROC_000106', '4단대문접지', 'PROC_000056', 19, 'Y', 'N', NULL)
ON CONFLICT (proc_cd) DO NOTHING;

-- A-2. PROC_000107 — 반접지 (신규·★2단접지 PROC_000059와 별개)
INSERT INTO t_proc_processes (proc_cd, proc_nm, upr_proc_cd, disp_seq, use_yn, del_yn, note)
VALUES ('PROC_000107', '반접지', 'PROC_000056', 20, 'Y', 'N', '1폴드 2패널(2단접지 PROC_000059와 별개)')
ON CONFLICT (proc_cd) DO NOTHING;

-- A-3. (재사용) PROC_000071 병풍접지 = 4ACC. 등록 액션 0 (이미 실재).

-- =====================================================================
-- PHASE B — §21 단가행 proc_cd 충전 + use_dims 토큰 등재 (택일 분리)
--   각 comp 48행 전부 동일 접지방식 → proc_cd 일괄 충전. unit_price 미변경.
--   use_dims에 "proc_cd"(is_proc=True 유발) + "proc_grp:PROC_000056"(clean 메타) 등재.
--   IS DISTINCT 가드 → 재실행 no-op (멱등).
-- =====================================================================

-- B-1. COMP_FOLD_LEAF_3FOLD (3단접지) → PROC_000060 (실재)
UPDATE t_prc_component_prices SET proc_cd = 'PROC_000060'
WHERE comp_cd = 'COMP_FOLD_LEAF_3FOLD' AND (proc_cd IS DISTINCT FROM 'PROC_000060');
UPDATE t_prc_price_components SET use_dims = '["proc_cd","min_qty","proc_grp:PROC_000056"]'::jsonb
WHERE comp_cd = 'COMP_FOLD_LEAF_3FOLD'
  AND use_dims IS DISTINCT FROM '["proc_cd","min_qty","proc_grp:PROC_000056"]'::jsonb;

-- B-2. COMP_FOLD_LEAF_4ACC (4단병풍접지) → PROC_000071 (재사용)
UPDATE t_prc_component_prices SET proc_cd = 'PROC_000071'
WHERE comp_cd = 'COMP_FOLD_LEAF_4ACC' AND (proc_cd IS DISTINCT FROM 'PROC_000071');
UPDATE t_prc_price_components SET use_dims = '["proc_cd","min_qty","proc_grp:PROC_000056"]'::jsonb
WHERE comp_cd = 'COMP_FOLD_LEAF_4ACC'
  AND use_dims IS DISTINCT FROM '["proc_cd","min_qty","proc_grp:PROC_000056"]'::jsonb;

-- B-3. COMP_FOLD_LEAF_4GATE (4단대문접지) → PROC_000106 (신규)
UPDATE t_prc_component_prices SET proc_cd = 'PROC_000106'
WHERE comp_cd = 'COMP_FOLD_LEAF_4GATE' AND (proc_cd IS DISTINCT FROM 'PROC_000106');
UPDATE t_prc_price_components SET use_dims = '["proc_cd","min_qty","proc_grp:PROC_000056"]'::jsonb
WHERE comp_cd = 'COMP_FOLD_LEAF_4GATE'
  AND use_dims IS DISTINCT FROM '["proc_cd","min_qty","proc_grp:PROC_000056"]'::jsonb;

-- B-4. COMP_FOLD_LEAF_HALF (반접지) → PROC_000107 (신규)
UPDATE t_prc_component_prices SET proc_cd = 'PROC_000107'
WHERE comp_cd = 'COMP_FOLD_LEAF_HALF' AND (proc_cd IS DISTINCT FROM 'PROC_000107');
UPDATE t_prc_price_components SET use_dims = '["proc_cd","min_qty","proc_grp:PROC_000056"]'::jsonb
WHERE comp_cd = 'COMP_FOLD_LEAF_HALF'
  AND use_dims IS DISTINCT FROM '["proc_cd","min_qty","proc_grp:PROC_000056"]'::jsonb;

-- ---------------------------------------------------------------------
-- 가드 G-1: verbatim 게이트 — 적재 전후 단가행 행수·합 동일성 검증
-- ---------------------------------------------------------------------
DO $$
DECLARE v_bad int;
BEGIN
  SELECT count(*) INTO v_bad
  FROM _verbatim_before b
  JOIN (SELECT comp_cd, count(*) rows, sum(unit_price) sum_price
        FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%'
        GROUP BY comp_cd) a ON a.comp_cd=b.comp_cd
  WHERE a.rows <> b.rows OR a.sum_price IS DISTINCT FROM b.sum_price;
  IF v_bad > 0 THEN
    RAISE EXCEPTION 'VERBATIM GUARD FAILED: % comp(s) changed row count or price sum', v_bad;
  END IF;
  RAISE NOTICE 'VERBATIM GUARD PASSED: 단가행 행수·합 불변 확인';
END $$;

-- ---------------------------------------------------------------------
-- 가드 G-2: FK 충족 검증 — 4 comp proc_cd 모두 마스터에 실재해야 함 (고아 0)
-- ---------------------------------------------------------------------
DO $$
DECLARE v_orphan int;
BEGIN
  SELECT count(*) INTO v_orphan
  FROM (SELECT DISTINCT proc_cd FROM t_prc_component_prices
        WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%' AND proc_cd IS NOT NULL) cp
  LEFT JOIN t_proc_processes p ON p.proc_cd = cp.proc_cd
  WHERE p.proc_cd IS NULL;
  IF v_orphan > 0 THEN
    RAISE EXCEPTION 'FK GUARD FAILED: % orphan proc_cd(s) in component_prices', v_orphan;
  END IF;
  RAISE NOTICE 'FK GUARD PASSED: 4 comp proc_cd 전부 마스터 실재';
END $$;

-- ---------------------------------------------------------------------
-- 적재 후 상태 리포트 (가시화)
-- ---------------------------------------------------------------------
\echo '--- t_proc_processes 신규/재사용 4종 ---'
SELECT proc_cd, proc_nm, upr_proc_cd, disp_seq, use_yn, del_yn
FROM t_proc_processes WHERE proc_cd IN ('PROC_000060','PROC_000071','PROC_000106','PROC_000107')
ORDER BY proc_cd;

\echo '--- component_prices proc_cd 충전 + verbatim 합 ---'
SELECT comp_cd, COALESCE(proc_cd,'<NULL>') AS proc_cd, count(*) AS rows, sum(unit_price) AS sum_price
FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%'
GROUP BY comp_cd, proc_cd ORDER BY comp_cd;

\echo '--- price_components use_dims ---'
SELECT comp_cd, use_dims::text FROM t_prc_price_components
WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%' ORDER BY comp_cd;

-- =====================================================================
-- 기본 ROLLBACK (DRY-RUN). 실 적재는 apply.sh --commit (인간 승인).
-- =====================================================================
ROLLBACK;
