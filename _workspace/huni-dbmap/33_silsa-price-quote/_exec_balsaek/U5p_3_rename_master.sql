-- U5'-3: 정본 comp_nm 명명 보정 ("별색인쇄 출력비" → "별색인쇄비")
-- =====================================================================
-- 종류중립(WHITE 흔적 제거)·round-17 가독성. comp_cd(COMP_PRINT_SPOT_WHITE_S1) 유지 → FK 연쇄 회피
--   (배선 29공식·단가행 530 무영향). comp_nm 만 보정.
-- 멱등: 현 comp_nm <> '별색인쇄비' 인 경우만 UPDATE → 2-pass 시 0건.
UPDATE t_prc_price_components
   SET comp_nm = '별색인쇄비', upd_dt = now()
 WHERE comp_cd = 'COMP_PRINT_SPOT_WHITE_S1'
   AND comp_nm <> '별색인쇄비';
