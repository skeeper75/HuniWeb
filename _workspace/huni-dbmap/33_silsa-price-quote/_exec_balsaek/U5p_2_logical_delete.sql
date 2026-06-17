-- U5'-2: 형제 9 별색 comp 논리삭제 (use_yn='N' · 단가행 보존 · DELETE 아님)
-- =====================================================================
-- 그룹핑 모델 P-1(424 DELETE 철회) 준수: 물리삭제 0. comp 행·단가행 보존, use_yn='N'만.
-- 엔진 use_yn 필터로 형제 제외 → 동시매칭 위험 0(정본 WHITE_S1만 활성).
-- 순서: U5'-1(배선 제거) 후 실행 → use_yn=N comp 의 잔존 배선 0(dangling 방지).
-- 멱등: use_yn<>'N' 인 행만 UPDATE → 2-pass 시 0건.
UPDATE t_prc_price_components
   SET use_yn = 'N', upd_dt = now()
 WHERE comp_cd IN (
     'COMP_PRINT_SPOT_WHITE_S2',
     'COMP_PRINT_SPOT_CLEAR_S1','COMP_PRINT_SPOT_CLEAR_S2',
     'COMP_PRINT_SPOT_GOLD_S1','COMP_PRINT_SPOT_GOLD_S2',
     'COMP_PRINT_SPOT_PINK_S1','COMP_PRINT_SPOT_PINK_S2',
     'COMP_PRINT_SPOT_SILVER_S1','COMP_PRINT_SPOT_SILVER_S2'
   )
   AND use_yn <> 'N';
