-- sticker-stage2-groupB-dryrun.sql
-- §27 마스터 스티커 단계2 — 그룹 B 인간 컨펌 필요 (DRY-RUN·ROLLBACK 전용·★임의단가 금지)
-- 그룹 B는 권위 단가가 "부재"하거나 의미가 "미확정"이라 즉시 교정 불가.
-- 각 결함마다 두 안(가/나)을 SQL로 준비 — 인간 컨펌으로 택1 후 실행. 여기선 안 '가'(바인딩 제거)만 DRY-RUN 검증.
-- 종결자=ROLLBACK (절대 COMMIT 금지).
\set ON_ERROR_STOP on
BEGIN;

-- ============================================================
-- B-1. A6(052/053/054 SIZ_196) · 100x140(062/063 SIZ_058) — 권위 단가 부재
--   안 (가) 바인딩 제거(논리삭제 del_yn=Y) — 가격표(import xlsx)에 사이즈 부재·실판매 아니면 권고
--   안 (나) 확인필요 시그널 — 실판매면 단가 출처 컨펌 후 verbatim INSERT(★현재 임의단가 금지)
--   ↓ 아래는 안 (가) DRY-RUN. 안 (나)는 출처 컨펌 전 SQL 미작성(추측 INSERT 금지).
-- ------------------------------------------------------------
-- 안 (가): 물리삭제 0 · del_yn 논리삭제 ([[dbmap-del-yn-soft-delete-authority]])
UPDATE t_prd_product_sizes SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd IN('PRD_000052','PRD_000053','PRD_000054') AND siz_cd='SIZ_000196' AND del_yn='N';
UPDATE t_prd_product_sizes SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd IN('PRD_000062','PRD_000063') AND siz_cd='SIZ_000058' AND del_yn='N';

-- ============================================================
-- B-2. 067 타투 기본가2000 — 값 존재·의미(base fee/최소가) 미확정
--   라이브 COMP_STK_TATTOO=1행(min3·4000)만. 격자 B05=기본가2000·3장4000.
--   ★의미 미확정(Q-STK-1) → 이번 교정 제외(반영 안 함). 컨펌 후 별도 처리.
--   (DRY-RUN 변경 없음 — 현황 어서션만)
-- ============================================================

-- ============================================================
-- 사후 어서션
-- ============================================================
\echo '== B-1 안(가): A6/100x140 바인딩 논리삭제 후 잔여 active 바인딩 0 =='
SELECT
  (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd IN('PRD_000052','PRD_000053','PRD_000054') AND siz_cd='SIZ_000196' AND del_yn='N') AS a6_active_left,
  (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd IN('PRD_000062','PRD_000063') AND siz_cd='SIZ_000058' AND del_yn='N') AS x100x140_active_left;
  -- 기대: 둘 다 0 (안 가 적용 시)

\echo '== B-1 물리삭제 0 확인 (논리삭제만·행 잔존) =='
SELECT count(*) AS rows_still_present
FROM t_prd_product_sizes WHERE (prd_cd IN('PRD_000052','PRD_000053','PRD_000054') AND siz_cd='SIZ_000196')
   OR (prd_cd IN('PRD_000062','PRD_000063') AND siz_cd='SIZ_000058');  -- 기대: 5 (물리행 보존)

\echo '== B-2 067 타투 현황(미변경·의미 미확정) =='
SELECT comp_cd, siz_cd, mat_cd, min_qty, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_STK_TATTOO';

ROLLBACK;
\echo '== ROLLBACK 완료 — 라이브 미변경 (그룹 B는 인간 컨펌 후 안 택1) =='
