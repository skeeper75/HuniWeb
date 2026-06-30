-- ================================================================
-- hardcover-ring-082 baseline 물리 백업 (시점: 20260701_0041 · 라이브 읽기전용 실측)
-- 영향 테이블:
--   t_prd_product_sets(082)       — 현행 5행(표지083 seq1 + 면지084~087 seq2~5·내지 부재)
--   t_prd_product_price_formulas  — 082/286 현행 0행(undo=추가 바인딩 DELETE)
--   t_prd_products(286)           — 현행 부재(undo=286 전체 물리삭제 가능·MAX=PRD_000285)
--   t_prc_price_formulas          — PRF_HC_TWINRING_SET 현행 부재(undo=신설분 물리삭제)
--   t_prc_formula_components      — PRF_HC_TWINRING_SET 비목 현행 부재
--   286 차원 4종(sizes/print_options/materials/plate_sizes) — 부재(286 mint와 함께 생성)
-- 복원: 이 INSERT는 082 셋트 baseline 재현용. undo 후 무결성 확인에 사용.
-- ================================================================

-- [t_prd_product_sets] 082 현행 5행 (COMMIT 전 baseline · reg_dt verbatim)
INSERT INTO t_prd_product_sets (prd_cd,sub_prd_cd,sub_prd_qty,min_cnt,max_cnt,cnt_incr,disp_seq,note,reg_dt,del_yn) VALUES ('PRD_000082','PRD_000083',1,NULL,NULL,NULL,1,'표지=전용지','2026-06-03 12:46:02.974607','N');
INSERT INTO t_prd_product_sets (prd_cd,sub_prd_cd,sub_prd_qty,min_cnt,max_cnt,cnt_incr,disp_seq,note,reg_dt,del_yn) VALUES ('PRD_000082','PRD_000084',1,NULL,NULL,NULL,2,'면지=화이트면지','2026-06-03 12:46:02.974607','N');
INSERT INTO t_prd_product_sets (prd_cd,sub_prd_cd,sub_prd_qty,min_cnt,max_cnt,cnt_incr,disp_seq,note,reg_dt,del_yn) VALUES ('PRD_000082','PRD_000085',1,NULL,NULL,NULL,3,'면지=블랙면지','2026-06-03 12:46:02.974607','N');
INSERT INTO t_prd_product_sets (prd_cd,sub_prd_cd,sub_prd_qty,min_cnt,max_cnt,cnt_incr,disp_seq,note,reg_dt,del_yn) VALUES ('PRD_000082','PRD_000086',1,NULL,NULL,NULL,4,'면지=그레이면지','2026-06-03 12:46:02.974607','N');
INSERT INTO t_prd_product_sets (prd_cd,sub_prd_cd,sub_prd_qty,min_cnt,max_cnt,cnt_incr,disp_seq,note,reg_dt,del_yn) VALUES ('PRD_000082','PRD_000087',1,NULL,NULL,NULL,5,'면지=인쇄면지','2026-06-03 12:46:02.974607','N');

-- [t_prd_product_price_formulas] 082/286 현행 = 0행 (확인됨·복원 시 추가 바인딩 DELETE로 baseline 복귀)
-- [t_prd_products] PRD_000286 = 부재 (확인됨·MAX prd_cd=PRD_000285·undo는 286 전체 물리삭제)
-- [t_prc_price_formulas] PRF_HC_TWINRING_SET = 부재 (확인됨·undo는 신설분 물리삭제)
-- [t_prc_formula_components] PRF_HC_TWINRING_SET 비목 = 부재 (확인됨)
-- [286 차원 4종] = 부재 (286 mint와 함께 생성·undo는 286 전체 물리삭제)
