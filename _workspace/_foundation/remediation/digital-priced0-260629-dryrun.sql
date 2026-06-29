-- digital-priced0-260629-dryrun.sql
-- ============================================================================
-- digital PRICED-0 교정 DRY-RUN (BEGIN/ROLLBACK · 라이브 미반영 검증 전용)
-- 진단: _foundation/remediation/FINDING-digital-priced0-260629.md
-- 권위: 인쇄상품가격표260527 · 상품마스터260610 · 형제 상품 패리티
-- [HARD] 이 파일은 ROLLBACK 으로 끝난다 — 실 적재는 별도 *-fix.sql + 인간 승인.
-- 교정 4건(데이터): #1 bundle_qtys / #3·#5 SIZ_000124 / #4 SIZ_000133 / #6 SIZ_000119
-- 제외: #2 썬캡051 = 권위 부재 BLOCKED(교정 불가). 023 은 데이터결함이라 포함(C트랙 아님).
-- ============================================================================

BEGIN;

-- ── 사전 상태 (교정 전) ─────────────────────────────────────────────────────
\echo '=== BEFORE: 025 bundle_qtys (기대: 0행) ==='
SELECT prd_cd, bdl_qty FROM t_prd_product_bundle_qtys WHERE prd_cd = 'PRD_000025';

\echo '=== BEFORE: 누락 work 치수 3개 사이즈 (기대: work NULL) ==='
SELECT siz_cd, siz_nm, cut_width, cut_height, work_width, work_height
  FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000124','SIZ_000133','SIZ_000119') ORDER BY siz_cd;

\echo '=== BEFORE: fn_calc_pansu (기대: NULL/0 → 가격 불가) ==='
SELECT 'SIZ_000119' AS item, fn_calc_pansu('SIZ_000499','SIZ_000119') AS pansu
UNION ALL SELECT 'SIZ_000124', fn_calc_pansu('SIZ_000499','SIZ_000124')
UNION ALL SELECT 'SIZ_000133', fn_calc_pansu('SIZ_000499','SIZ_000133');

-- ── 교정 #1: 투명포토카드025 bundle_qtys 1행 (형제 024 verbatim 패리티) ──────────
-- 단가행(COMP_PHOTOCARD_CLEAR_SET · bdl_qty=20 · 8,500)은 이미 존재. 묶음수 선택지만 누락.
INSERT INTO t_prd_product_bundle_qtys
       (prd_cd,        bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, del_yn, reg_dt)
SELECT 'PRD_000025',  20,      'QTY_UNIT.06',   'Y',     1,        'N',    now()
 WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_bundle_qtys
                    WHERE prd_cd='PRD_000025' AND bdl_qty=20);

-- ── 교정 #3·#5·#4·#6: 사이즈 work 치수 충전 (cut+2mm·margin 1/1/1/1·형제 패리티) ──
-- [HARD] 공유 마스터 코드 — DELETE/이름변경 금지. NULL 컬럼만 보정 충전.
-- NULL 일 때만 충전(이미 값 있으면 미터치 — 멱등·기존값 보존).
UPDATE t_siz_sizes
   SET work_width  = 152, work_height = 102,
       margin_top  = COALESCE(margin_top,1), margin_bot = COALESCE(margin_bot,1),
       margin_lft  = COALESCE(margin_lft,1), margin_rgt = COALESCE(margin_rgt,1),
       upd_dt = now()
 WHERE siz_cd = 'SIZ_000124' AND (work_width IS NULL OR work_height IS NULL);   -- 150x100 (027·029·094)

UPDATE t_siz_sizes
   SET work_width  = 88,  work_height = 54,
       margin_top  = COALESCE(margin_top,1), margin_bot = COALESCE(margin_bot,1),
       margin_lft  = COALESCE(margin_lft,1), margin_rgt = COALESCE(margin_rgt,1),
       upd_dt = now()
 WHERE siz_cd = 'SIZ_000133' AND (work_width IS NULL OR work_height IS NULL);   -- 86x52 (028·031·032·033)

UPDATE t_siz_sizes
   SET work_width  = 92,  work_height = 92,
       margin_top  = COALESCE(margin_top,1), margin_bot = COALESCE(margin_bot,1),
       margin_lft  = COALESCE(margin_lft,1), margin_rgt = COALESCE(margin_rgt,1),
       upd_dt = now()
 WHERE siz_cd = 'SIZ_000119' AND (work_width IS NULL OR work_height IS NULL);   -- 90x90 (023·097)

-- ── 사후 검증 (교정 후) ─────────────────────────────────────────────────────
\echo '=== AFTER: 025 bundle_qtys (기대: 1행 bdl_qty=20) ==='
SELECT prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000025';

\echo '=== AFTER: work 치수 충전 확인 ==='
SELECT siz_cd, siz_nm, cut_width, cut_height, work_width, work_height,
       margin_top, margin_bot, margin_lft, margin_rgt
  FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000124','SIZ_000133','SIZ_000119') ORDER BY siz_cd;

\echo '=== AFTER: fn_calc_pansu (기대: 양수 → 가격 가능) ==='
SELECT 'SIZ_000119(90x90)'  AS item, fn_calc_pansu('SIZ_000499','SIZ_000119') AS pansu   -- 기대 12
UNION ALL SELECT 'SIZ_000124(150x100)', fn_calc_pansu('SIZ_000499','SIZ_000124')          -- 기대 9
UNION ALL SELECT 'SIZ_000133(86x52)',   fn_calc_pansu('SIZ_000499','SIZ_000133');         -- 기대 24

-- [HARD] 검증 전용 — 되돌린다. 실 적재는 인간 승인 후 *-fix.sql(COMMIT).
ROLLBACK;
