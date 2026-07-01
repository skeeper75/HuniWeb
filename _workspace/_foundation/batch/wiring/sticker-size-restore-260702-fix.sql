-- 스티커 4상품 사이즈 재키잉 파손 복원 + 아트스티커/쿨코팅 자재단가 클론 (§27 배선 · 260702)
-- 병인: 실무진이 오늘 사이즈코드를 중복코드(258/426/315/198)로 재키잉 → 원래 정규코드(520/170/172/174/197)
--       를 del_yn='Y'로 끔 → 중복코드엔 단가 0 → 전 자재 견적0. (폼보드와 동일 패턴)
-- 해법: ① 사이즈 del_yn 복원(정규 Y→N·중복 N→Y) ② 아트스티커611/유포쿨코팅593 grp1 단가 클론(from 153)
--       ③ A6(057)=100x148(518) 단가 클론(사장님 결정)
-- 원칙: 삭제 없음·전부 복원/추가·날조0(권위단가 verbatim)·멱등(NOT EXISTS)·마커 note.
-- ★COMMIT판 (인간 승인 완료 260702). undo=sticker-size-restore-260702-undo.sql

\set ON_ERROR_STOP on
BEGIN;

-- ===== 0. 사전 상태 스냅샷 =====
\echo '=== BEFORE: 4상품 활성사이즈별 견적가능 자재수 ==='
SELECT ps.prd_cd, ps.siz_cd, s.siz_nm,
  (SELECT count(DISTINCT pm.mat_cd) FROM t_prd_product_materials pm
     JOIN t_prc_component_prices cp ON cp.comp_cd='COMP_STK_PRINT' AND cp.mat_cd=pm.mat_cd AND cp.siz_cd=ps.siz_cd
   WHERE pm.prd_cd=ps.prd_cd AND pm.del_yn='N') AS priceable_mats
FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
WHERE ps.prd_cd IN ('PRD_000052','PRD_000053','PRD_000058','PRD_000055') AND ps.del_yn='N'
ORDER BY ps.prd_cd, s.siz_nm;

-- ===== 1. 사이즈 복원 (del_yn 플립) =====
-- 1a. 정규코드 복원 (Y→N)
UPDATE t_prd_product_sizes SET del_yn='N', del_dt=NULL, dflt_yn='N'
 WHERE (prd_cd,siz_cd) IN (
   ('PRD_000052','SIZ_000520'),('PRD_000052','SIZ_000170'),
   ('PRD_000053','SIZ_000520'),('PRD_000053','SIZ_000170'),
   ('PRD_000058','SIZ_000520'),('PRD_000058','SIZ_000170'),
   ('PRD_000055','SIZ_000172'),('PRD_000055','SIZ_000174'),('PRD_000055','SIZ_000197')
 ) AND del_yn='Y';

-- 1b. 중복코드 논리삭제 (N→Y)
UPDATE t_prd_product_sizes SET del_yn='Y', del_dt=now()
 WHERE (prd_cd,siz_cd) IN (
   ('PRD_000052','SIZ_000258'),('PRD_000052','SIZ_000426'),
   ('PRD_000053','SIZ_000258'),('PRD_000053','SIZ_000426'),
   ('PRD_000058','SIZ_000258'),('PRD_000058','SIZ_000426'),
   ('PRD_000055','SIZ_000258'),('PRD_000055','SIZ_000315'),('PRD_000055','SIZ_000198')
 ) AND del_yn='N';

-- 1c. 기본사이즈 1개씩 지정(반칼=A5·낱장=A4)
UPDATE t_prd_product_sizes SET dflt_yn='Y'
 WHERE (prd_cd,siz_cd) IN (
   ('PRD_000052','SIZ_000170'),('PRD_000053','SIZ_000170'),
   ('PRD_000058','SIZ_000170'),('PRD_000055','SIZ_000172')
 );
-- (052/053의 A6=057은 계속 활성 유지·아래 2c에서 가격부여)

-- ===== 2. 자재단가 클론 (grp1 기본단가 from MAT_153·verbatim) =====
-- 2a. 아트스티커 90g(MAT_611) ← 유포(MAT_153) 전 그리드(504행·grp1 basic)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height)
SELECT comp_cd, apply_ymd, siz_cd, clr_cd, 'MAT_000611', coat_side_cnt, bdl_qty, min_qty, unit_price,
       'STK-RESTORE-260702 art-clone-from-153', proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height
  FROM t_prc_component_prices src
 WHERE src.comp_cd='COMP_STK_PRINT' AND src.mat_cd='MAT_000153'
   AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices d
                    WHERE d.comp_cd=src.comp_cd AND d.mat_cd='MAT_000611' AND d.siz_cd=src.siz_cd
                      AND d.min_qty=src.min_qty AND coalesce(d.apply_ymd,'')=coalesce(src.apply_ymd,''));

-- 2b. 유포+무광쿨코팅(MAT_593) ← 유포(MAT_153) 전 그리드(사장님: 유포 그리드 재사용·코팅 무프리미엄)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height)
SELECT comp_cd, apply_ymd, siz_cd, clr_cd, 'MAT_000593', coat_side_cnt, bdl_qty, min_qty, unit_price,
       'STK-RESTORE-260702 coolcoat-clone-from-153', proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height
  FROM t_prc_component_prices src
 WHERE src.comp_cd='COMP_STK_PRINT' AND src.mat_cd='MAT_000153'
   AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices d
                    WHERE d.comp_cd=src.comp_cd AND d.mat_cd='MAT_000593' AND d.siz_cd=src.siz_cd
                      AND d.min_qty=src.min_qty AND coalesce(d.apply_ymd,'')=coalesce(src.apply_ymd,''));

-- 2c. A6(SIZ_057=105x148) = 100x148(SIZ_518·8판) 단가 클론(사장님 결정) — 052/053 자재별
--     052 자재: 584/585/586/609/611  ·  053 자재: 371/372  (각 자재의 518행을 057로 복사)
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height)
SELECT comp_cd, apply_ymd, 'SIZ_000057', clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price,
       'STK-RESTORE-260702 a6-from-100x148', proc_cd, opt_cd, dim_vals, print_opt_cd, plt_siz_cd, siz_width, siz_height
  FROM t_prc_component_prices src
 WHERE src.comp_cd='COMP_STK_PRINT' AND src.siz_cd='SIZ_000518'
   AND src.mat_cd IN ('MAT_000584','MAT_000585','MAT_000586','MAT_000609','MAT_000611','MAT_000371','MAT_000372')
   AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices d
                    WHERE d.comp_cd=src.comp_cd AND d.mat_cd=src.mat_cd AND d.siz_cd='SIZ_000057'
                      AND d.min_qty=src.min_qty AND coalesce(d.apply_ymd,'')=coalesce(src.apply_ymd,''));

-- ===== 3. 검증 =====
\echo '=== AFTER: 4상품 활성사이즈별 견적가능 자재수 (전부 >0 이어야) ==='
SELECT ps.prd_cd, ps.siz_cd, s.siz_nm, ps.dflt_yn,
  (SELECT count(DISTINCT pm.mat_cd) FROM t_prd_product_materials pm
     JOIN t_prc_component_prices cp ON cp.comp_cd='COMP_STK_PRINT' AND cp.mat_cd=pm.mat_cd AND cp.siz_cd=ps.siz_cd
   WHERE pm.prd_cd=ps.prd_cd AND pm.del_yn='N') AS priceable_mats
FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
WHERE ps.prd_cd IN ('PRD_000052','PRD_000053','PRD_000058','PRD_000055') AND ps.del_yn='N'
ORDER BY ps.prd_cd, s.siz_nm;

\echo '=== 클론 자재 골든 단가 (아트611·쿨코팅593·A6) qty1/qty100 ==='
SELECT mat_cd, siz_cd, min_qty, unit_price, note FROM t_prc_component_prices
WHERE note LIKE 'STK-RESTORE-260702%' AND min_qty IN (1,100)
  AND ( (mat_cd='MAT_000611' AND siz_cd IN ('SIZ_000520','SIZ_000170','SIZ_000057'))
     OR (mat_cd='MAT_000593' AND siz_cd IN ('SIZ_000172','SIZ_000174','SIZ_000197'))
     OR (mat_cd IN ('MAT_000584','MAT_000371') AND siz_cd='SIZ_000057') )
ORDER BY mat_cd, siz_cd, min_qty;

\echo '=== 신규 INSERT 행수(마커별) ==='
SELECT note, count(*) FROM t_prc_component_prices WHERE note LIKE 'STK-RESTORE-260702%' GROUP BY note;

\echo '=== 중복코드 잔존 활성(0 이어야) ==='
SELECT prd_cd, siz_cd, del_yn FROM t_prd_product_sizes
WHERE prd_cd IN ('PRD_000052','PRD_000053','PRD_000058','PRD_000055')
  AND siz_cd IN ('SIZ_000258','SIZ_000426','SIZ_000315','SIZ_000198') AND del_yn='N';

COMMIT;
\echo '=== COMMIT 완료 ==='
