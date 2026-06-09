-- =====================================================================
-- silsa CPQ 각목 재모델 — 방향(가로/세로) 옵션 + 각목 자재 1개 통합 + R-GAKMOK 폐기
--   사용자 확정 2026-06-09 (Option A). 이미 COMMIT된 silsa CPQ 데이터의 surgical 조정.
--   원리: 각목 길이=주문 시 현수막 변(세로/가로) 치수에서 도출 → 높이-매칭 제약(R-GAKMOK) 불요.
--         900이하/초과 = 길이별 가격구간 → 가격엔진 length-tier 룩업(본 트랜잭션 범위 밖).
--   멱등: 전 UPDATE 조건 가드(이미 반영 시 0행). 재실행 delta 0.
--   reg_dt 불변·upd_dt now()(테이블 fn_upd_dt 트리거도 갱신). NEVER COMMIT by default(로더 주입).
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;

-- 1) 옵션항목: OPV_000016(가로) 각목 ref MAT_000339 → MAT_000338 통합.
--    트리거 fn_chk_opt_item_ref(.03)=(prd_cd,MAT_000338,USAGE.07) EXISTS 충족(MAT_000338 링크 del_yn=N) → 통과.
--    (소프트삭제보다 먼저 repoint = 트리거 안전.)
UPDATE t_prd_product_option_items
  SET ref_key1 = 'MAT_000338', upd_dt = now()
  WHERE prd_cd='PRD_000138' AND opt_cd='OPV_000016' AND item_seq=1
    AND ref_dim_cd='OPT_REF_DIM.03' AND ref_key1='MAT_000339';

-- 2) 자재 MAT_000338 rename: '각목(900이하)' → '각목'(길이 비종속·방향에서 도출).
UPDATE t_mat_materials
  SET mat_nm='각목', upd_dt=now()
  WHERE mat_cd='MAT_000338' AND mat_nm <> '각목';

-- 3) 옵션 라벨 방향 기준 재명명.
UPDATE t_prd_product_options
  SET opt_nm='각목(세로)+끈(4개) 추가', upd_dt=now()
  WHERE prd_cd='PRD_000138' AND opt_cd='OPV_000015' AND opt_nm <> '각목(세로)+끈(4개) 추가';
UPDATE t_prd_product_options
  SET opt_nm='각목(가로)+끈(4개) 추가', upd_dt=now()
  WHERE prd_cd='PRD_000138' AND opt_cd='OPV_000016' AND opt_nm <> '각목(가로)+끈(4개) 추가';

-- 4) 통합으로 불요해진 MAT_000339(각목900초과) 링크 + 자재 soft-delete (repoint 후 = 참조 끊김 없음).
UPDATE t_prd_product_materials
  SET del_yn='Y', del_dt=now(), upd_dt=now()
  WHERE prd_cd='PRD_000138' AND mat_cd='MAT_000339' AND del_yn='N';
UPDATE t_mat_materials
  SET del_yn='Y', del_dt=now(), upd_dt=now()
  WHERE mat_cd='MAT_000339' AND del_yn='N';

-- R-GAKMOK constraint(RULE_001): 라이브 미적재(0행)였으므로 DB 조치 없음 → 방향 모델로 폐기 확정(문서).
SELECT 'remodel done — gakmok orientation model, R-GAKMOK abandoned (length-tier→price engine)' AS done;
