-- D1: 미싱 레거시 dangling 배선 제거 (formula_components DELETE)
-- =====================================================================
-- 결함(G-D2 W5 잔재): COMP_PP_PERF_2L·_3L (use_yn='N' 비활성) 가 PRF_DGP_A·PRF_DGP_D 에 배선 잔존(4건).
--   W5(미싱 차원전환·정본 PERF_1L 통합·2L/3L use_yn=N) 때 레거시 배선 제거 누락 → 비활성 comp 가 배선됨.
--
-- ★가격 불변 입증(라이브 실측):
--   · 정본 COMP_PP_PERF_1L(use_yn='Y') = 줄수 1/2/3 × 10구간 = 30 단가행(W5 가 2/3줄 dim_vals 로 흡수).
--   · PERF_1L 이 PRF_DGP_A(disp19)·PRF_DGP_D(disp10) 둘 다 배선됨(실측) → 2L/3L 배선 제거해도
--     미싱 1/2/3줄 가격 경로 정본 PERF_1L 로 전건 보존(dangling 제거가 가격 손실 0).
--   · PERF_2L/3L 단가행(10+10) = use_yn=N comp 에 보존(이 SQL 은 배선만 제거·단가행 무변경).
--
-- 멱등: use_yn='N' 인 PERF_2L/3L 배선만 DELETE → 2-pass 시 0건.
-- 별색 dedup U5'-1 과 동류(비활성 comp 의 dangling 배선 정리).
DELETE FROM t_prc_formula_components fc
 WHERE fc.comp_cd IN ('COMP_PP_PERF_2L','COMP_PP_PERF_3L')
   AND EXISTS (
     SELECT 1 FROM t_prc_price_components pc
      WHERE pc.comp_cd = fc.comp_cd AND pc.use_yn = 'N'
   );
