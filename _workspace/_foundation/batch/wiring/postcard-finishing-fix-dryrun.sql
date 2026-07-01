-- ============================================================================
-- postcard-finishing-fix-dryrun.sql  (2026-07-01)
-- 프리미엄엽서(PRD_000016)·스탠다드엽서(PRD_000018) 오시/미싱 후가공 옵션
-- staff-edit-scan B_unpriced_option_refs 적발 건에 대한 정합 심의.
--
-- ★결론: 거짓결함(FALSE POSITIVE). 데이터 교정 불요 = NO-OP.
--   단가행은 자식 proc(090/086)에 완전 적재됨(설계상 옳은 위치). 공식 배선 완료.
--   스캐너는 옵션 ref_key1=부모 proc(029/030)로 단가행을 조회해 "없음"으로 오탐.
--   엔진은 뷰어가 부모029→자식090 해소 + 줄수 detail을 붙여 정상 매칭.
--   [메모리 확증] CLASS-1 재키(090→029)는 이전에 시도→오시비 여전0→UNDO됨(오방향).
--
-- 따라서 이 스크립트는 UPDATE를 수행하지 않는다.
-- BEGIN...ROLLBACK 안에서 "단가행/배선이 실재함"을 SELECT 어서션으로 실증만 한다.
-- (권위 근거: 계산공식집초안 '접지비=[제작수량]X[오시가격테이블참조]·인쇄후가공>오시',
--            price-formula-collection-decode-260629.md L46 PRF_DGP_A 후가공비=오시·미싱)
-- ============================================================================

BEGIN;

-- [ASSERT 1] proc 계층: 부모029/030(메뉴·줄수 입력정의 보유) ← 자식090/086(단가행)
--   기대: 4행. 029/030 upr='' + prcs_dtl_opt에 줄수 input, 090/086 upr=029/030
SELECT 'ASSERT1_proc_hierarchy' AS check, proc_cd, proc_nm, upr_proc_cd,
       (prcs_dtl_opt IS NOT NULL) AS has_detail_input
  FROM t_proc_processes
 WHERE proc_cd IN ('PROC_000029','PROC_000030','PROC_000086','PROC_000090')
 ORDER BY proc_cd;

-- [ASSERT 2] 단가행 실재: 자식 proc 090/086·줄수 1/2/3·각 10 수량밴드 = 30행/comp
--   기대: COMP_PP_CREASE_1L/PROC_000090 = 30, COMP_PP_PERF_1L/PROC_000086 = 30
SELECT 'ASSERT2_price_rows_exist' AS check, comp_cd, proc_cd,
       count(*) AS n_rows,
       count(DISTINCT dim_vals) AS n_julsu,
       min(unit_price) AS min_prc, max(unit_price) AS max_prc
  FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_PP_CREASE_1L','COMP_PP_PERF_1L')
   AND proc_cd IN ('PROC_000090','PROC_000086')
 GROUP BY comp_cd, proc_cd
 ORDER BY comp_cd;

-- [ASSERT 3] 배선 실재: PRF_DGP_A formula_components에 오시/미싱 comp = addtn_yn=Y
--   기대: 2행 (COMP_PP_CREASE_1L disp_seq=4, COMP_PP_PERF_1L disp_seq=5)
SELECT 'ASSERT3_formula_wired' AS check, frm_cd, comp_cd, disp_seq, addtn_yn
  FROM t_prc_formula_components
 WHERE frm_cd='PRF_DGP_A'
   AND comp_cd IN ('COMP_PP_CREASE_1L','COMP_PP_PERF_1L')
 ORDER BY disp_seq;

-- [ASSERT 4] 상품 공정 바인딩: 016/018 모두 부모029/030 바인딩(041/042와 동형)
--   기대: 각 상품 029·030 2행씩
SELECT 'ASSERT4_product_proc_binding' AS check, prd_cd, proc_cd, mand_proc_yn
  FROM t_prd_product_processes
 WHERE prd_cd IN ('PRD_000016','PRD_000018')
   AND proc_cd IN ('PROC_000029','PROC_000030')
 ORDER BY prd_cd, proc_cd;

-- [ASSERT 5] use_dims의 proc_grp:* 토큰은 ":" 포함이라 엔진 매칭에서 제외(pricing.py:675)
--   → 매칭축 = proc_cd(자식) + min_qty + dim_vals(줄수). 부모 proc는 뷰어가 자식으로 해소.
SELECT 'ASSERT5_use_dims' AS check, comp_cd, prc_typ_cd, use_dims
  FROM t_prc_price_components
 WHERE comp_cd IN ('COMP_PP_CREASE_1L','COMP_PP_PERF_1L');

-- ★ 교정 UPDATE 없음. 데이터는 이미 정확·완전.
ROLLBACK;

-- ============================================================================
-- 시뮬레이터(HuniSim) 실측 기대치 (인간 검증용):
--   상품 PRD_000016 또는 PRD_000018, 오시 선택(뷰어가 자식 PROC_000090 해소)+줄수=1, 수량=100:
--     → 오시비 = 10,000원 (COMP_PP_CREASE_1L / {"줄수":1} / min_qty=100 band).
--   줄수=2, 수량=100 → 12,000원.  줄수=3, 수량=100 → 14,000원.
--   미싱 동일 시리즈(COMP_PP_PERF_1L / PROC_000086): 줄수1/수량100 → 10,000원.
--   ★후가공비가 >0 으로 합산되면 정상(스캐너 오탐 확증). 0이면 뷰어의 부모→자식 해소 경로 점검.
-- ============================================================================
