-- leather-hardcover-077 baseline 물리 백업 (시점: 20260701_0005·라이브 읽기전용 dump)
-- 영향 테이블: t_prd_product_sets(077) · t_prd_product_price_formulas(077,285) · t_prd_products(285) · 285 차원 4종
-- 복원: 이 INSERT는 baseline 상태 재현용. undo 후 무결성 확인에 사용.

-- [t_prd_product_sets] 077 현행 4행 (COMMIT 전 baseline)
INSERT INTO t_prd_product_sets (prd_cd,sub_prd_cd,sub_prd_qty,min_cnt,max_cnt,cnt_incr,disp_seq,note,reg_dt,del_yn) VALUES ('PRD_000077','PRD_000078',1,NULL,NULL,NULL,1,'표지=레더(화이트)','2026-06-03 12:46:02.974607','N');
INSERT INTO t_prd_product_sets (prd_cd,sub_prd_cd,sub_prd_qty,min_cnt,max_cnt,cnt_incr,disp_seq,note,reg_dt,del_yn) VALUES ('PRD_000077','PRD_000079',1,NULL,NULL,NULL,2,'면지=화이트면지','2026-06-03 12:46:02.974607','N');
INSERT INTO t_prd_product_sets (prd_cd,sub_prd_cd,sub_prd_qty,min_cnt,max_cnt,cnt_incr,disp_seq,note,reg_dt,del_yn) VALUES ('PRD_000077','PRD_000080',1,NULL,NULL,NULL,3,'면지=블랙면지','2026-06-03 12:46:02.974607','N');
INSERT INTO t_prd_product_sets (prd_cd,sub_prd_cd,sub_prd_qty,min_cnt,max_cnt,cnt_incr,disp_seq,note,reg_dt,del_yn) VALUES ('PRD_000077','PRD_000081',1,NULL,NULL,NULL,4,'면지=그레이면지','2026-06-03 12:46:02.974607','N');

-- [t_prd_product_price_formulas] 077/285 현행 (baseline: 0행 — 복원 시 추가 바인딩 DELETE)
-- (위 0행이면 baseline은 바인딩 없음 = undo는 추가분 전부 제거)

-- [t_prd_products] 285 (baseline: 부재 — undo는 285 전체 물리삭제 가능)
-- (출력 없으면 285 부재 = baseline 정상)
