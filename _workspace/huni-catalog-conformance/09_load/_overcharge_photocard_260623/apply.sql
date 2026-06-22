-- =====================================================================
-- apply.sql — 포토카드 과대청구(V3) 교정 멱등 적재 — ★FULL (인간 승인 완료)
-- §21 카탈로그 정합 · 2026-06-23 · huni-catalog-conformance/09_load/_overcharge_photocard_260623
--
-- 권위: overcharge-remediation-spec.md V3(권고① 상품별 공식분리) + overcharge-scan-catalog.md OC-07/08.
-- 결함: 024(일반)·025(투명) 둘 다 PRF_PHOTOCARD_FIXED 바인딩 + 판별축 전무
--   → evaluate_price가 일반(6,000)+투명(8,500) 둘 다 매칭 silent 합산 = 14,500 과대.
-- 교정 = 상품별 공식 분리(comp/단가행 기존 재사용·신규 단가행 0·단가값 verbatim 불변):
--   - PRF_PHOTOCARD_NORMAL (신규) ← COMP_PHOTOCARD_SET(6,000)만 배선 ← 024 바인딩
--   - PRF_PHOTOCARD_CLEAR  (신규) ← COMP_PHOTOCARD_CLEAR_SET(8,500)만 배선 ← 025 바인딩
--   - PRF_PHOTOCARD_FIXED  (고아) → use_yn='N' 논리비활성 (★t_prc_price_formulas에 del_yn 컬럼 부재 — use_yn만 존재)
--
-- ★[HARD] 제약:
--   - unit_price 절대 불변 (이 SQL은 t_prc_component_prices를 SET 하지 않는다 — 단가행 미접촉)
--   - 기초코드/공유 마스터(comp·단가행) 직접수정 0 — comp/단가행은 재사용만
--   - 신규 공식은 명세대로 2건만 (임의 추가 0). frm_cd 명명형(채번 충돌 0 실측).
--   - 기본 ROLLBACK (DRY-RUN). 실 COMMIT은 apply.sh --commit + 인간 승인.
--
-- ★멱등성:
--   - t_prc_price_formulas: PK=frm_cd → ON CONFLICT (frm_cd) DO NOTHING (재실행 no-op)
--   - t_prc_formula_components: PK=(frm_cd,comp_cd) → ON CONFLICT DO NOTHING
--   - BIND/FIXED use_yn UPDATE: IS DISTINCT 가드 (수렴·재실행 no-op)
--
-- ★FK 위상: A(FRM 신규 선행) → B(FC 배선·frm_cd→FRM·comp_cd→PC 부모 충족) → C(BIND 재배선·frm_cd→FRM) → D(고아 FIXED).
--   FC.frm_cd → t_prc_price_formulas(fk_prc_formula_comps_frm_cd) · BIND.frm_cd → 동(fk_prd_prc_frm_frm_cd). 부모 선행 필수.
-- =====================================================================

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------
-- 가드 G-0: 단가행 verbatim 기준선 캡처 (이 교정은 단가행 미접촉이나 동시영향 방어)
-- ---------------------------------------------------------------------
CREATE TEMP TABLE _verbatim_before ON COMMIT DROP AS
SELECT comp_cd, count(*) AS rows, sum(unit_price) AS sum_price
FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_CLEAR_SET')
GROUP BY comp_cd;

-- =====================================================================
-- PHASE A — 신규 공식 2개 멱등 INSERT (FK 선행)
--   채번 재실측: frm_cd 명명형 PRF_PHOTOCARD_NORMAL/CLEAR 충돌 0·동명 frm_nm 0 (2026-06-23 실측).
--   reg_dt=now() DEFAULT. upd_dt NULL. 임의 추가 0.
-- =====================================================================

-- A-1. PRF_PHOTOCARD_NORMAL — 일반포토카드 전용 (신규)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES ('PRF_PHOTOCARD_NORMAL', '일반포토카드 세트 고정가',
        '포토카드(024) 전용 — V3 공식분리(PRF_PHOTOCARD_FIXED silent 합산 교정·260623)', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- A-2. PRF_PHOTOCARD_CLEAR — 투명포토카드 전용 (신규)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES ('PRF_PHOTOCARD_CLEAR', '투명포토카드 세트 고정가',
        '투명포토카드(025) 전용 — V3 공식분리(PRF_PHOTOCARD_FIXED silent 합산 교정·260623)', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- =====================================================================
-- PHASE B — formula_components 배선 (각 공식에 자기 comp 1개만·기존 comp 재사용)
--   NORMAL ← SET(6,000)만 · CLEAR ← CLEAR_SET(8,500)만. comp/단가행 신규 0.
-- =====================================================================

-- B-1. PRF_PHOTOCARD_NORMAL ← COMP_PHOTOCARD_SET (일반세트만)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_PHOTOCARD_NORMAL', 'COMP_PHOTOCARD_SET', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- B-2. PRF_PHOTOCARD_CLEAR ← COMP_PHOTOCARD_CLEAR_SET (투명세트만)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_PHOTOCARD_CLEAR', 'COMP_PHOTOCARD_CLEAR_SET', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- =====================================================================
-- PHASE C — 상품-공식 바인딩 재배선 (frm_cd만 UPDATE·PK prd_cd+apply_bgn_ymd 불변)
--   ★apply_bgn_ymd 분기 함정 회피: 신규 행 INSERT 아님 → 기존 행 frm_cd 교체(이중계상 0).
--   024·025 각각 정확히 1행(2026-06-01) 실측 확인. IS DISTINCT 가드(멱등).
-- =====================================================================

-- C-1. 024 → PRF_PHOTOCARD_NORMAL
UPDATE t_prd_product_price_formulas
SET frm_cd = 'PRF_PHOTOCARD_NORMAL'
WHERE prd_cd = 'PRD_000024' AND apply_bgn_ymd = '2026-06-01'
  AND frm_cd IS DISTINCT FROM 'PRF_PHOTOCARD_NORMAL';

-- C-2. 025 → PRF_PHOTOCARD_CLEAR
UPDATE t_prd_product_price_formulas
SET frm_cd = 'PRF_PHOTOCARD_CLEAR'
WHERE prd_cd = 'PRD_000025' AND apply_bgn_ymd = '2026-06-01'
  AND frm_cd IS DISTINCT FROM 'PRF_PHOTOCARD_CLEAR';

-- =====================================================================
-- PHASE D — 고아 공식 PRF_PHOTOCARD_FIXED 논리비활성 (use_yn='N')
--   024/025 재배선 후 바인딩 0 → 고아. ★del_yn 컬럼 부재(t_prc_price_formulas) → use_yn='N'으로 비활성.
--   FC 배선(SET/CLEAR_SET)은 보존(undo 가역·comp 재사용 무영향). IS DISTINCT 가드(멱등).
-- =====================================================================
UPDATE t_prc_price_formulas
SET use_yn = 'N', upd_dt = now()
WHERE frm_cd = 'PRF_PHOTOCARD_FIXED' AND use_yn IS DISTINCT FROM 'N';

-- ---------------------------------------------------------------------
-- 가드 G-1: verbatim 게이트 — 단가행 행수·합 불변(이 교정은 단가행 미접촉)
-- ---------------------------------------------------------------------
DO $$
DECLARE v_bad int;
BEGIN
  SELECT count(*) INTO v_bad
  FROM _verbatim_before b
  JOIN (SELECT comp_cd, count(*) rows, sum(unit_price) sum_price
        FROM t_prc_component_prices
        WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_CLEAR_SET')
        GROUP BY comp_cd) a ON a.comp_cd=b.comp_cd
  WHERE a.rows <> b.rows OR a.sum_price IS DISTINCT FROM b.sum_price;
  IF v_bad > 0 THEN
    RAISE EXCEPTION 'VERBATIM GUARD FAILED: % comp(s) changed row count or price sum', v_bad;
  END IF;
  RAISE NOTICE 'VERBATIM GUARD PASSED: 단가행 행수·합 불변(SET=6000·CLEAR_SET=8500)';
END $$;

-- ---------------------------------------------------------------------
-- 가드 G-2: FK 충족 — 신규 FC.comp_cd·BIND.frm_cd 고아 0
-- ---------------------------------------------------------------------
DO $$
DECLARE v_orphan int;
BEGIN
  -- 신규 2 공식이 정확히 자기 comp 1개씩만 배선(과배선 0)
  SELECT count(*) INTO v_orphan FROM (
    SELECT frm_cd, count(*) c FROM t_prc_formula_components
    WHERE frm_cd IN ('PRF_PHOTOCARD_NORMAL','PRF_PHOTOCARD_CLEAR')
    GROUP BY frm_cd HAVING count(*) <> 1
  ) x;
  IF v_orphan > 0 THEN
    RAISE EXCEPTION 'WIRE GUARD FAILED: 신규 공식이 comp 1개 아님 (NORMAL/CLEAR)';
  END IF;
  -- 024/025 바인딩이 신규 공식 가리킴
  SELECT count(*) INTO v_orphan FROM t_prd_product_price_formulas
  WHERE prd_cd IN ('PRD_000024','PRD_000025')
    AND frm_cd NOT IN ('PRF_PHOTOCARD_NORMAL','PRF_PHOTOCARD_CLEAR');
  IF v_orphan > 0 THEN
    RAISE EXCEPTION 'BIND GUARD FAILED: 024/025 바인딩 재배선 미완 (% 건)', v_orphan;
  END IF;
  RAISE NOTICE 'FK/WIRE/BIND GUARD PASSED: 신규공식 각 comp1·024→NORMAL·025→CLEAR';
END $$;

-- ---------------------------------------------------------------------
-- 적재 후 상태 리포트 (가시화)
-- ---------------------------------------------------------------------
\echo '--- t_prc_price_formulas 포토카드 3종(신규2+고아FIXED use_yn=N) ---'
SELECT frm_cd, frm_nm, use_yn FROM t_prc_price_formulas
WHERE frm_cd LIKE 'PRF_PHOTOCARD%' ORDER BY frm_cd;

\echo '--- formula_components 배선(NORMAL=SET·CLEAR=CLEAR_SET·FIXED 보존) ---'
SELECT frm_cd, comp_cd, disp_seq FROM t_prc_formula_components
WHERE frm_cd LIKE 'PRF_PHOTOCARD%' ORDER BY frm_cd, comp_cd;

\echo '--- 024/025 바인딩(재배선 후) ---'
SELECT prd_cd, frm_cd, apply_bgn_ymd FROM t_prd_product_price_formulas
WHERE prd_cd IN ('PRD_000024','PRD_000025') ORDER BY prd_cd;

\echo '--- 단가행 verbatim 합(불변) ---'
SELECT comp_cd, count(*) rows, sum(unit_price) sum_price FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_CLEAR_SET') GROUP BY comp_cd ORDER BY comp_cd;

-- =====================================================================
-- 기본 ROLLBACK (DRY-RUN). 실 적재는 apply.sh --commit (인간 승인).
-- =====================================================================
ROLLBACK;
