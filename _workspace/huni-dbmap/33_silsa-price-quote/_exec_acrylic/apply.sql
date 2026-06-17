-- apply.sql — 아크릴 가로/세로 구간 동형 전환 실행본. 단일 트랜잭션·FK 위상순·롤백전용 DRY-RUN.
-- [HARD] 기본 ROLLBACK(아래). 실 COMMIT은 인간 승인 후 apply.sh --commit 으로만.
-- 순서: A1(라이브 121 siz_cd→siz_width/height 전환) → A2(GAP 96 INSERT) → A3(use_dims 전환) → AW(배선 보정).
--   A1/A2 가 A3(모델 전환) 전에 데이터를 채워 가격 공백 0. comp_cd/frm_cd 부모 라이브 선존재(실측).
-- 단가행 = siz_nm WxH 파싱(A1)·가격표 verbatim(A2). 값 불변/날조 0. 좌표 siz 채번 0. work_width/height 미사용.
-- ★BLOCKED(acrylic-blocked.BLOCKED.sql)은 \i 하지 않음 — Q-ACR-7/9·코롯토/카라비너·A4 nonspec(추측 금지).
\set ON_ERROR_STOP on
BEGIN;

\echo '=== A1: 라이브 아크릴 매트릭스 121행 siz_cd → siz_width/siz_height 전환(siz_nm 파싱·값 불변) ==='
\i A1_convert_sizcd_to_wh.sql

\echo '=== A2: GAP 미적재 좌표 96 verbatim INSERT (siz_width/siz_height·mat 분기·채번 0) ==='
\i A2_gap_unitprices.sql

\echo '=== A3: 본체 2 comp use_dims [siz_cd] → [siz_width,siz_height(,mat_cd)] (두께 직교) ==='
\i A3_use_dims_switch.sql

\echo '=== AW: PRF_CLR_ACRYL→CLEAR3T 배선 disp_seq=1·addtn_yn=N 보정 ==='
\i AW_wiring_fix.sql

-- 기본 = 롤백전용 DRY-RUN. (실 COMMIT 은 apply.sh --commit 이 ROLLBACK→COMMIT 치환)
ROLLBACK;
