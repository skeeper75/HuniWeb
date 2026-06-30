-- 040 화이트인쇄명함 자재 정정 (2026-06-30)
-- 근거 4중: ① 인쇄 도메인(흰토너는 흰종이에 안보임=화이트용지 무효)
--           ② 경쟁사 레드프린팅 BCSPWHT(용지6종 전부 유색·흰색0)
--           ③ 라이브 020 화이트엽서(이미 화이트 제외 4색)
--           ④ 상품명 "화이트인쇄"명함
-- 교정: 040의 큐리어스스킨 화이트(MAT_000361) 논리삭제 → 4색(레드/다크블루/바이올렛/블랙)
-- ★클리어 과금은 통합 COMP_PRINT_SPOT_WHITE_S1로 이미 정상 작동(실증: 화이트+클리어=19000×2 합산)
--   → 공식/공정/클리어는 손대지 않음(추가 시 이중과금 위험).
BEGIN;
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now(), upd_dt=now()
  WHERE prd_cd='PRD_000040' AND mat_cd='MAT_000361' AND COALESCE(del_yn,'N')<>'Y';

\echo '--- 사후: 040 자재 (4색) ---'
SELECT m.mat_nm, pm.dflt_yn, pm.disp_seq
  FROM t_prd_product_materials pm JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
  WHERE pm.prd_cd='PRD_000040' AND COALESCE(pm.del_yn,'N')<>'Y' ORDER BY pm.disp_seq;
COMMIT;
\echo '=== COMMIT 완료 ==='
