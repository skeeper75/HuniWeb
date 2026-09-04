-- t43 DRY-RUN — apply.sql 의 UPDATE 를 단일 트랜잭션으로 걸고 되돌린다
-- ============================================================================
-- [HARD] 이 파일은 스스로 ROLLBACK 한다. COMMIT 문구는 없다.
-- 확인 항목: ① UPDATE 1 ② A4 판수 1 → 2 ③ 나머지 사이즈 무손상 ④ 중복행 미발생
-- ============================================================================

BEGIN;

\echo '=== [BEFORE] PRD_000286 살아있는 사이즈 · 판수 ==='
SELECT ps.disp_seq, ps.siz_cd, s.siz_nm, s.work_width, s.work_height,
       ps.dflt_yn, fn_calc_pansu('SIZ_000499', ps.siz_cd) AS pansu
  FROM t_prd_product_sizes ps
  JOIN t_siz_sizes s ON s.siz_cd = ps.siz_cd
 WHERE ps.prd_cd = 'PRD_000286' AND ps.del_yn = 'N'
 ORDER BY ps.disp_seq;

\echo '=== [BEFORE] 판형 자동선택 대상 행 (권위 316x467 · 사방 5mm) ==='
SELECT pl.siz_cd, pl.dflt_plt_yn, pl.del_yn,
       s.work_width, s.work_height, s.cut_width, s.cut_height,
       s.margin_top, s.margin_bot, s.margin_lft, s.margin_rgt, s.impos_yn
  FROM t_prd_product_plate_sizes pl
  JOIN t_siz_sizes s ON s.siz_cd = pl.siz_cd
 WHERE pl.prd_cd = 'PRD_000286';


-- ─────────────────────────────────────────────────────────────────────────
-- apply.sql 본문과 동일한 단 하나의 문장
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_prd_product_sizes
   SET siz_cd = 'SIZ_000252',
       upd_dt = now()
 WHERE prd_cd = 'PRD_000286'
   AND siz_cd = 'SIZ_000172'
   AND del_yn = 'N';


\echo '=== [AFTER] PRD_000286 살아있는 사이즈 · 판수 — A4 가 2판이어야 한다 ==='
SELECT ps.disp_seq, ps.siz_cd, s.siz_nm, s.work_width, s.work_height,
       ps.dflt_yn, fn_calc_pansu('SIZ_000499', ps.siz_cd) AS pansu
  FROM t_prd_product_sizes ps
  JOIN t_siz_sizes s ON s.siz_cd = ps.siz_cd
 WHERE ps.prd_cd = 'PRD_000286' AND ps.del_yn = 'N'
 ORDER BY ps.disp_seq;

\echo '=== [AFTER] 권위 대조 — A5 4판 · A4 2판 (판걸이수 r56·r58) ==='
SELECT v.nm, v.expect, fn_calc_pansu('SIZ_000499', v.siz_cd) AS actual,
       CASE WHEN v.expect = fn_calc_pansu('SIZ_000499', v.siz_cd)
            THEN 'OK' ELSE 'MISMATCH' END AS verdict
  FROM (VALUES ('A5 r56 (SIZ_000250 형제공통)', 4, 'SIZ_000250'),
               ('A5 r56 (SIZ_000007 현행)',     4, 'SIZ_000007'),
               ('A4 r58 (SIZ_000252 교정후)',   2, 'SIZ_000252'),
               ('A4 r58 (SIZ_000172 교정전)',   2, 'SIZ_000172')
       ) AS v(nm, expect, siz_cd);
-- ⚠ 마지막 줄 SIZ_000172 는 MISMATCH 가 정상이다 — 그게 이번에 떼어내는 코드다.

\echo '=== [AFTER] 사이즈 3건 유지 · 중복 0 ==='
SELECT count(*) AS live_sizes,
       count(DISTINCT siz_cd) AS distinct_sizes
  FROM t_prd_product_sizes
 WHERE prd_cd = 'PRD_000286' AND del_yn = 'N';

\echo '=== [AFTER] SIZ_000172 를 아직 쓰는 다른 상품 (레더아트액자는 남아야 한다) ==='
SELECT prd_cd, del_yn FROM t_prd_product_sizes
 WHERE siz_cd = 'SIZ_000172' AND del_yn = 'N' ORDER BY prd_cd;

ROLLBACK;

\echo '=== ROLLBACK 완료 — 라이브는 그대로다 ==='
