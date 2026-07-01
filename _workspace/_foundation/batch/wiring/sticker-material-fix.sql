-- =============================================================================
-- sticker-material-fix-dryrun.sql  (DRY-RUN 전용 — BEGIN...ROLLBACK · 실 COMMIT 금지)
-- 스티커 5상품(PRD_000052/053/055/058/067) 실무진 신규 자재 → 단가행 신설(가격0 해소)
-- §27 배선 서브트랙 · 설계: design-sticker-material-260701.md
--
-- ★근본원인: 실무진이 product_materials 를 신규 mat_cd 로 마이그레이션(구 canonical
--   MAT_000153/155/156/162/242/167 을 del_yn='Y' 논리삭제, 신규 MAT_000584+ 를 활성).
--   시뮬레이터는 mat_cd 드롭다운을 t_prd_product_materials(del_yn≠Y)에서 뽑음
--   (price_views.py:1385-1392) → 손님이 활성 신규 mat 선택 → COMP_STK_PRINT 에 그 mat 의
--   단가행 0 → _row_matches 실패 → 견적 0.  실측: 052 유포(584) A5 qty100 = price 0.
--
-- ★해법(Option B·재사용우선): 신규 mat_cd 에 canonical 동일자재 단가행을 verbatim 클론
--   (component/공식은 재사용, 단가값 재사용, mat_cd 키만 신규 = 실무진 마이그레이션 정합).
--   가격표 260527 은 generic 명(유포스티커…)을 쓰고 그 권위단가는 이미 canonical 코드에
--   verbatim 적재됨(prior round 검증) → canonical→신규 클론 = 권위단가 전파(날조 0).
--
-- ★disjoint(공유공식 PRF_STK_FIXED 4상품): 신규행은 mat_cd 로만 매칭 → 신규 mat 선택시만
--   매칭. 052·058 은 584 공유(동일가·정상), 053=371/372, 067=594 각자 배타. 타 스티커상품
--   (canonical 코드 사용)은 신규 mat_cd 미선택 → 무영향. 이중청구 0.
--
-- ★제외(CONFIRM·추측 적재 금지): MAT_000611 아트스티커(가격원천 전무)·MAT_000593 유포+쿨코팅
--   (canonical 165 무가격·코팅프리미엄 모호). 커팅 proc(반칼/완칼)=사이즈 내재 비가격 → 무조치.
-- undo = sticker-material-undo.sql   백업 = sticker-material-backup-260701.csv
-- =============================================================================
BEGIN;

-- ── COMP_STK_PRINT 클론 (단가형 PRICE_TYPE.01·단가값 verbatim·mat_cd 만 swap) ──
-- 멱등: 대상 mat_cd 가 이미 존재하면 INSERT 0 (NOT EXISTS 가드). pre-state = 0행.

-- 052/058: 유포스티커 80g (MAT_000584) ← 유포스티커 (MAT_000153, 504행)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt, proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height)
SELECT comp_cd, apply_ymd, siz_cd, clr_cd, 'MAT_000584', coat_side_cnt, bdl_qty, min_qty, unit_price,
       coalesce(note,'')||' [mint260701 src=MAT_000153]', now(), proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height
FROM t_prc_component_prices
WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000153'
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000584');

-- 052/058: 무광코팅스티커 (MAT_000585) ← 무광코팅스티커 (MAT_000155, 468행)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt, proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height)
SELECT comp_cd, apply_ymd, siz_cd, clr_cd, 'MAT_000585', coat_side_cnt, bdl_qty, min_qty, unit_price,
       coalesce(note,'')||' [mint260701 src=MAT_000155]', now(), proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height
FROM t_prc_component_prices
WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000155'
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000585');

-- 052/058: 유광코팅스티커 (MAT_000586) ← 유광코팅스티커 (MAT_000156, 468행)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt, proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height)
SELECT comp_cd, apply_ymd, siz_cd, clr_cd, 'MAT_000586', coat_side_cnt, bdl_qty, min_qty, unit_price,
       coalesce(note,'')||' [mint260701 src=MAT_000156]', now(), proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height
FROM t_prc_component_prices
WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000156'
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000586');

-- 052/058: 미색스티커 모조80g (MAT_000609) ← 미색스티커 (MAT_000242, 468행)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt, proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height)
SELECT comp_cd, apply_ymd, siz_cd, clr_cd, 'MAT_000609', coat_side_cnt, bdl_qty, min_qty, unit_price,
       coalesce(note,'')||' [mint260701 src=MAT_000242]', now(), proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height
FROM t_prc_component_prices
WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000242'
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000609');

-- 053: 투명스티커(백색후지) (MAT_000371) ← 투명스티커 (MAT_000162, 246행)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt, proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height)
SELECT comp_cd, apply_ymd, siz_cd, clr_cd, 'MAT_000371', coat_side_cnt, bdl_qty, min_qty, unit_price,
       coalesce(note,'')||' [mint260701 src=MAT_000162]', now(), proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height
FROM t_prc_component_prices
WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000162'
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000371');

-- 053: 투명스티커(투명후지) (MAT_000372) ← 투명스티커 (MAT_000162, 246행)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt, proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height)
SELECT comp_cd, apply_ymd, siz_cd, clr_cd, 'MAT_000372', coat_side_cnt, bdl_qty, min_qty, unit_price,
       coalesce(note,'')||' [mint260701 src=MAT_000162]', now(), proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height
FROM t_prc_component_prices
WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000162'
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000372');

-- ── COMP_STK_TATTOO 클론 (합가형 PRICE_TYPE.02) ──
-- 067: 타투스티커 (MAT_000594) ← 타투 (MAT_000167, 333행)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt, proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height)
SELECT comp_cd, apply_ymd, siz_cd, clr_cd, 'MAT_000594', coat_side_cnt, bdl_qty, min_qty, unit_price,
       coalesce(note,'')||' [mint260701 src=MAT_000167]', now(), proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height
FROM t_prc_component_prices
WHERE comp_cd='COMP_STK_TATTOO' AND mat_cd='MAT_000167'
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices WHERE comp_cd='COMP_STK_TATTOO' AND mat_cd='MAT_000594');

-- ============================ 검증 ============================
\echo '--- 검증1: 신설 행수 (기대 584=504 585=468 586=468 609=468 371=246 372=246 594=333) ---'
SELECT mat_cd, count(*) FROM t_prc_component_prices
 WHERE mat_cd IN ('MAT_000584','MAT_000585','MAT_000586','MAT_000609','MAT_000371','MAT_000372','MAT_000594')
 GROUP BY mat_cd ORDER BY mat_cd;

\echo '--- 검증2: 골든 단가 verbatim (584@A5=canonical153 동일 · 5200@100) ---'
SELECT mat_cd, siz_cd, min_qty, unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_STK_PRINT' AND siz_cd='SIZ_000170' AND min_qty IN (1,100)
   AND mat_cd IN ('MAT_000584','MAT_000585','MAT_000609') ORDER BY mat_cd, min_qty;

\echo '--- 검증2b: 클론=원본 정합(584 vs 153 차이행 기대 0) ---'
SELECT count(*) AS diff_rows FROM (
  SELECT siz_cd,min_qty,unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000153'
  EXCEPT
  SELECT siz_cd,min_qty,unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000584'
) d;

\echo '--- 검증3: 타투 골든 (594@060 min3=6000 min6=10000) ---'
SELECT mat_cd, siz_cd, min_qty, unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_STK_TATTOO' AND mat_cd='MAT_000594' AND min_qty IN (3,6) ORDER BY min_qty;

\echo '--- 검증4: disjoint — 신규 mat_cd 는 COMP_STK_PRINT/TATTOO 외 컴포넌트에 없음(기대 위 컴포넌트만) ---'
SELECT comp_cd, count(*) FROM t_prc_component_prices
 WHERE mat_cd IN ('MAT_000584','MAT_000585','MAT_000586','MAT_000609','MAT_000371','MAT_000372','MAT_000594')
 GROUP BY comp_cd ORDER BY comp_cd;

\echo '--- 검증5: CONFIRM 제외분 미적재 확인(기대 611/593 = 0행) ---'
SELECT count(*) AS confirm_rows FROM t_prc_component_prices WHERE mat_cd IN ('MAT_000611','MAT_000593');

COMMIT;
-- =============================================================================
-- 멱등성: 재실행 시 각 INSERT 는 NOT EXISTS 가드로 0행(대상 mat_cd 존재하면 skip).
-- ★COMMIT 없음 — 실 적재는 인간 승인 후 별도 sticker-material-fix.sql(§7 트랙)
--   + webadmin 가격시뮬레이터 실화면 확인 필수(제외0·PRICE≠0) [HARD].
-- =============================================================================
