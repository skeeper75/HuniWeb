-- t44 — R5/R1 교정 DRY-RUN (롤백 전용)
--
-- 무엇을 고치나: 무선/PUR책자 표지A4(SIZ_000633)를 Max Page 산출 펼침으로 되돌리고,
--               그 결과 불필요해지는 신설 판형 SIZ_000641(480x320) 사이즈전용 배선을 걷는다.
--               판형은 권위 r63 이 지정한 국4절 316x467(SIZ_000499)로 복귀한다.
--
-- 왜: 운영 엔진(catalog/spine_calc.calc_spine)이 Max Page(300p 양면 · 최대두께 몽블랑130g
--     0.170mm)에서 산출하는 책등은 26mm, 표지 펼침은 446x297 이다(maxpage_spread.json).
--     +블리드 3mm 사방 = 작업 452x303 → 316x467 실영역 306x457 에 판걸이 1 로 **들어간다**.
--     현재 라이브 값 454x297(작업 460x303)은 시트 고정치수이고 책등 여유가 34mm 라
--     8mm 초과로 국4절을 벗어난다 — 그래서 480x320 이 신설됐다.
--
-- 가격영향: 0원. 표지 6개 자재 전건 316x467 단가 = 480x320 단가(price_parity_check.txt).
--           판걸이도 1 = 1. 즉 이 교정은 돈을 바꾸지 않고 **신설 판형만 걷어낸다** —
--           t9 R1(480x320 단가가 316x467 복사본이라 면적 4.09% 미반영)도 함께 사라진다.
--
-- [HARD] 이 파일은 스스로 ROLLBACK 한다. 표지 물리치수 축소는 실무진 확인 사항이다
--        (§대안 B 참조) — COMMIT 은 리드 지시 후에만.

\set ON_ERROR_STOP 1

BEGIN;

\echo '=== BEFORE — 표지A4 사이즈 · 판형 배선 · 판걸이 ==='
SELECT siz_cd, siz_nm, cut_width, cut_height, work_width, work_height, margin_lft
  FROM t_siz_sizes WHERE siz_cd = 'SIZ_000633';

SELECT prd_cd, siz_cd AS plate, item_siz_cd, dflt_plt_yn, del_yn
  FROM t_prd_product_plate_sizes
 WHERE prd_cd IN ('PRD_000290','PRD_000292') AND del_yn = 'N'
 ORDER BY prd_cd, siz_cd;

SELECT 'pansu(316x467, 표지A4)' AS q, fn_calc_pansu('SIZ_000499','SIZ_000633') AS v
UNION ALL SELECT 'pansu(480x320, 표지A4)', fn_calc_pansu('SIZ_000641','SIZ_000633');

-- ① 표지A4 를 Max Page 펼침으로 교정 (재단 446x297 · 작업 452x303 · 여백 3 유지)
--    446 = 완제품 A4 폭 210 × 2 + 책등 26  (spine_calc.calc_spine 산출)
UPDATE t_siz_sizes
   SET cut_width = 446.00, cut_height = 297.00,
       work_width = 452.00, work_height = 303.00,
       upd_dt = now()
 WHERE siz_cd = 'SIZ_000633';

-- ② 480x320 사이즈전용 판형 배선 논리삭제 → 공통 풀(316x467 dflt Y)로 복귀
UPDATE t_prd_product_plate_sizes
   SET del_yn = 'Y', del_dt = now(), upd_dt = now()
 WHERE siz_cd = 'SIZ_000641' AND item_siz_cd = 'SIZ_000633' AND del_yn = 'N';

\echo '=== AFTER — 권위 판형(316x467)에 들어가는지 ==='
SELECT siz_cd, siz_nm, cut_width, cut_height, work_width, work_height, margin_lft
  FROM t_siz_sizes WHERE siz_cd = 'SIZ_000633';

SELECT 'pansu(316x467, 표지A4)' AS q, fn_calc_pansu('SIZ_000499','SIZ_000633') AS v;

\echo '=== AFTER — 판형 자동선택 풀(공통만 남아야 한다) ==='
SELECT prd_cd, siz_cd AS plate, item_siz_cd, dflt_plt_yn
  FROM t_prd_product_plate_sizes
 WHERE prd_cd IN ('PRD_000290','PRD_000292') AND del_yn = 'N'
 ORDER BY prd_cd, siz_cd;

\echo '=== 검증 가드 — 판걸이 1 이상 · 가격 동일 전제 ==='
DO $$
DECLARE n int; n_left int;
BEGIN
  SELECT fn_calc_pansu('SIZ_000499','SIZ_000633') INTO n;
  IF n < 1 THEN RAISE EXCEPTION '교정 실패: 316x467 판걸이 % (기대 >=1)', n; END IF;
  SELECT count(*) INTO n_left FROM t_prd_product_plate_sizes
   WHERE siz_cd='SIZ_000641' AND del_yn='N';
  RAISE NOTICE '교정 후 316x467 판걸이 = % · SIZ_000641 잔여 배선 = %', n, n_left;
END $$;

\echo '=== ROLLBACK — 라이브 무변경 ==='
ROLLBACK;

\echo '=== POST-ROLLBACK — BEFORE 와 동일해야 한다 ==='
SELECT siz_cd, cut_width, cut_height, work_width, work_height,
       fn_calc_pansu('SIZ_000499', siz_cd) AS pansu_316x467
  FROM t_siz_sizes WHERE siz_cd = 'SIZ_000633';
