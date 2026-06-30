-- ================================================================
-- hardcover-ring-082 DRY-RUN (롤백전용·라이브 쓰기 0)
-- 멱등(2회차 delta 0)·제약위반 0·예상 27행 INSERT·복합PK 충돌 0·S8 오염 0 실증용.
-- 실행: psql ... -f hardcover-ring-082-dryrun.sql
-- ★ COMMIT 미내장 — ROLLBACK 으로 끝나므로 라이브에 쓰지 않는다.
-- 결과(2026-07-01 0041 실증): 1차 27행 INSERT·2차 전부 INSERT 0 0·082 sets 6행·disp_seq 1~6·
--   286 .02·차원 siz3/popt2/mat9/plate1·S8 pollution 0·ROLLBACK 후 baseline(sets5·286부재·PRF부재) 복귀.
-- ================================================================
BEGIN;
\i hardcover-ring-082-load.sql
\i hardcover-ring-082-load.sql
SELECT prd_cd,sub_prd_cd,min_cnt,max_cnt,cnt_incr,disp_seq FROM t_prd_product_sets WHERE prd_cd='PRD_000082' AND del_yn='N' ORDER BY disp_seq;
SELECT count(*) AS s8_pollution FROM t_prc_formula_components WHERE frm_cd='PRF_HC_TWINRING_SET' AND comp_cd IN ('COMP_HC_MUSEON_COVERBIND','COMP_BIND_TWINRING','COMP_BIND_MUSEON','COMP_BIND_PUR','COMP_BIND_JUNGCHEOL');
ROLLBACK;
