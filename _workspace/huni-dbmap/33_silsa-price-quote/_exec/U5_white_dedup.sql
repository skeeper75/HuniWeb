-- U5_white_dedup.sql — 별색 WHITE_S1 잘못 확장된 단가행 정리 (hard-delete + 백업/undo 동반)
--
-- ★설계 정정(라이브 실측 2026-06-17): 설계 "530→53(키별 1행)"은 WRONG.
--   실측: WHITE_S1 530행 = 53 min_qty밴드 × (print_opt_cd 2 × proc_cd 5).
--     · print_opt_cd: POPT_000001(3,000원)·POPT_000002(6,000원) = 단/양면 단가 분기 → 실 가격축, 보존 필수.
--     · proc_cd: PROC_000008~012(화이트/클리어/핑크/금색/은색) = WHITE에 부적합한 잉여 교차곱(WHITE=PROC_000008만 정당).
--   ∴ 설계의 "53 유지"는 POPT_000002(6,000원) 단가티어를 파괴 → 돈-크리티컬 오류.
--   정답 = 화이트 자기 공정 PROC_000008만 유지(잉여 4색 proc DELETE) → 106행 유지(53밴드×2 print_opt) · 424 DELETE.
--   형제 정합: GOLD_S1=PROC_000011·PINK=010·SILVER=012·CLEAR=009 각 자기색 1 proc(라이브 실측). WHITE만 5색 오염.
--   값 무손실 입증(실측): 동일 (print_opt,min_qty)에서 5 proc의 unit_price 동일 → 비-화이트 proc 삭제는 값 손실 0.
--
-- 멱등: 삭제 대상(proc_cd<>PROC_000008)이 1pass 후 0행 → 2pass delta 0.
-- HARD: hard-delete이므로 백업 SELECT(undo용)를 먼저 떠야 함. apply.sql이 DRY-RUN(ROLLBACK)으로 검증.

-- (백업은 apply.sh가 별도 SELECT로 _exec/backup_U5_white.csv 저장 — undo SQL 생성. 여기선 삭제만.)
DELETE FROM t_prc_component_prices
 WHERE comp_cd = 'COMP_PRINT_SPOT_WHITE_S1'
   AND proc_cd <> 'PROC_000008';
