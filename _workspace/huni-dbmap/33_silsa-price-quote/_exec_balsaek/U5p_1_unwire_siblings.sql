-- U5'-1: 형제 별색 comp 배선 제거 (formula_components DELETE)
-- =====================================================================
-- 정본 = COMP_PRINT_SPOT_WHITE_S1(5색 PROC_000008~012 × 2면 POPT_000001/002 × 53 = 530행, 전건 보유).
-- 형제 9 comp = 정본의 부분집합 → 배선 제거(use_yn=N은 U5'-2). 가격 불변(정본 동일 단가 매칭).
--
-- ★스코프 정정(라이브 실측):
--   · 8색 형제(CLEAR/GOLD/PINK/SILVER × S1/S2): PRF_DGP_A 에만 배선(실측) → PRF_DGP_A 에서만 제거.
--   · WHITE_S2(양면 화이트): PRF_DGP_A + 포스터 28공식 = 29공식 배선(실측). 설계 §0.3 "WHITE_S2 흡수" 의도상
--     29공식 전부 제거해야 use_yn=N 후 dangling 배선 0. WHITE_S1 이 29공식 전부에 동반 배선(실측·양면화이트
--     proc008+POPT_000002 커버) → WHITE_S2 제거해도 양면 화이트 경로 보존(가격 불변).
--   · 정본 WHITE_S1 배선(PRF_DGP_A + 포스터 29)은 무변경.
--
-- 멱등: DELETE 대상 행만 매칭 → 2-pass 시 0건.

-- (a) 8색 형제 — PRF_DGP_A 배선만 제거
DELETE FROM t_prc_formula_components
 WHERE frm_cd = 'PRF_DGP_A'
   AND comp_cd IN (
     'COMP_PRINT_SPOT_CLEAR_S1','COMP_PRINT_SPOT_CLEAR_S2',
     'COMP_PRINT_SPOT_GOLD_S1','COMP_PRINT_SPOT_GOLD_S2',
     'COMP_PRINT_SPOT_PINK_S1','COMP_PRINT_SPOT_PINK_S2',
     'COMP_PRINT_SPOT_SILVER_S1','COMP_PRINT_SPOT_SILVER_S2'
   );

-- (b) WHITE_S2 — 배선된 29공식 전부 제거(정본 WHITE_S1 이 동반 배선·양면화이트 보존)
DELETE FROM t_prc_formula_components
 WHERE comp_cd = 'COMP_PRINT_SPOT_WHITE_S2';
