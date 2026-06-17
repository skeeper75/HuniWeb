-- ============================================================================
-- 별색 dedup (U5') 통합 apply — 형제 색 comp 정본(WHITE_S1) 흡수
--   그룹핑 모델: 배선 제거 + use_yn=N(논리삭제·단가행 보존) + 정본 명명 보정.
-- [HARD] 기본 ROLLBACK(DRY-RUN). 실 COMMIT 은 apply.sh --commit + 인간 최종 승인.
-- 순서: U5'-1(배선 제거) → U5'-2(use_yn=N·dangling 방지) → U5'-3(명명·독립).
-- 단가행 재적재 0(정본에 5색×2면 전건 실재·형제는 부분집합). 가격 불변.
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

\echo '--- U5p-1: 형제 배선 제거 (8색=PRF_DGP_A·WHITE_S2=29공식) ---'
\i U5p_1_unwire_siblings.sql

\echo '--- U5p-2: 형제 9 comp use_yn=N (단가행 보존) ---'
\i U5p_2_logical_delete.sql

\echo '--- U5p-3: 정본 WHITE_S1 comp_nm -> 별색인쇄비 ---'
\i U5p_3_rename_master.sql

-- 기본 ROLLBACK. apply.sh --commit 이 이 줄을 COMMIT 으로 치환.
ROLLBACK;
\echo '===== ROLLBACK 완료 (COMMIT 0 — 라이브 무변경) ====='
