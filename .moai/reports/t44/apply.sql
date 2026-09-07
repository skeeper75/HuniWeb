-- t44 R1/R5 실적용 (A안) — 무선/PUR책자 표지A4 를 Max Page 산출값으로 교정하고
--                          불필요한 신설 판형 480x320 배선을 걷는다.
--
-- 승인: 지니 260904 「316x467 에 맞춰」= A안 (lead-peta [8748b7] 경유)
-- 원본: r1_remediation.sql (DRY-RUN) — ROLLBACK 만 COMMIT 으로 바꾸고 가드를 강화했다.
-- 범위: SIZ_000633 치수 + SIZ_000641 사이즈전용 배선 2행. 그 외 무단 변경 없음.
--       ⚠ R6(SIZ_000640 550x375)·하드커버(073·078·SIZ_000634/635)는 건드리지 않는다.
--       ⚠ SIZ_000641 코드 자체는 삭제하지 않는다(논리 배선만 해제 — 기초마스터 삭제금지).
--
-- 근거: 운영 엔진 catalog/spine_calc.calc_spine 이 Max Page(300p 양면 · 몽블랑130g
--       0.170mm · 150장)에서 산출하는 책등 = 26mm, 표지 펼침 = 210×2 + 26 = 446x297.
--       +블리드 3mm 사방 → 작업 452x303 → 316x467 실영역 306x457 에 판걸이 1(5mm 여유).
-- 가격영향: 0원. 표지 6자재 전건 316x467 단가 = 480x320 단가(price_parity_check.txt).
-- 되돌리기: rollback.sql

\set ON_ERROR_STOP 1

BEGIN;

\echo '=== BEFORE ==='
SELECT siz_cd, siz_nm, cut_width, cut_height, work_width, work_height, margin_lft,
       fn_calc_pansu('SIZ_000499', siz_cd) AS pansu_316x467
  FROM t_siz_sizes WHERE siz_cd = 'SIZ_000633';

SELECT prd_cd, siz_cd AS plate, item_siz_cd, dflt_plt_yn
  FROM t_prd_product_plate_sizes
 WHERE prd_cd IN ('PRD_000290','PRD_000292') AND del_yn = 'N'
 ORDER BY prd_cd, siz_cd;

\echo '=== 사전 가드 ==='
DO $$
DECLARE n_siz int; n_ovr int; n_par int;
BEGIN
  -- ① 대상 사이즈가 아직 시트 고정치수여야 한다(중복 적용 방지)
  SELECT count(*) INTO n_siz FROM t_siz_sizes
   WHERE siz_cd='SIZ_000633' AND cut_width=454 AND cut_height=297
     AND work_width=460 AND work_height=303;
  IF n_siz <> 1 THEN
    RAISE EXCEPTION '가드 실패: SIZ_000633 이 기대 상태(454x297/460x303)가 아니다 — 이미 적용됐거나 값이 바뀌었다';
  END IF;
  -- ② 걷어낼 사이즈전용 배선이 정확히 2행이어야 한다
  SELECT count(*) INTO n_ovr FROM t_prd_product_plate_sizes
   WHERE siz_cd='SIZ_000641' AND item_siz_cd='SIZ_000633' AND del_yn='N';
  IF n_ovr <> 2 THEN
    RAISE EXCEPTION '가드 실패: 480x320 사이즈전용 배선 % 행 (기대 2)', n_ovr;
  END IF;
  -- ③ 배선을 걷은 뒤 기댈 공통 판형(316x467 dflt Y)이 두 상품에 다 있어야 한다
  SELECT count(*) INTO n_par FROM t_prd_product_plate_sizes
   WHERE prd_cd IN ('PRD_000290','PRD_000292') AND siz_cd='SIZ_000499'
     AND COALESCE(item_siz_cd,'')='' AND dflt_plt_yn='Y' AND del_yn='N';
  IF n_par <> 2 THEN
    RAISE EXCEPTION '가드 실패: 공통 316x467 기본판형 % 행 (기대 2) — 걷으면 no_plates 가 된다', n_par;
  END IF;
  RAISE NOTICE '사전 가드 통과 — 대상 사이즈 1 · 걷을 배선 2 · 대체 공통판형 2';
END $$;

-- ① 표지A4 를 Max Page 펼침으로 교정 (여백 3mm 유지)
UPDATE t_siz_sizes
   SET cut_width = 446.00, cut_height = 297.00,
       work_width = 452.00, work_height = 303.00,
       upd_dt = now()
 WHERE siz_cd = 'SIZ_000633';

-- ② 480x320 사이즈전용 판형 배선 논리삭제 → 공통 풀(316x467 dflt Y)로 복귀
--    SIZ_000641 코드 자체는 t_siz_sizes 에 그대로 남긴다.
UPDATE t_prd_product_plate_sizes
   SET del_yn = 'Y', del_dt = now(), upd_dt = now()
 WHERE siz_cd = 'SIZ_000641' AND item_siz_cd = 'SIZ_000633' AND del_yn = 'N';

\echo '=== 사후 가드 ==='
DO $$
DECLARE n int; n_left int; n_pool int; n_code int;
BEGIN
  SELECT fn_calc_pansu('SIZ_000499','SIZ_000633') INTO n;
  IF n < 1 THEN RAISE EXCEPTION '사후 가드 실패: 316x467 판걸이 % (기대 >=1)', n; END IF;
  SELECT count(*) INTO n_left FROM t_prd_product_plate_sizes
   WHERE siz_cd='SIZ_000641' AND del_yn='N';
  IF n_left <> 0 THEN RAISE EXCEPTION '사후 가드 실패: SIZ_000641 잔여 배선 %', n_left; END IF;
  SELECT count(*) INTO n_pool FROM t_prd_product_plate_sizes
   WHERE prd_cd IN ('PRD_000290','PRD_000292') AND del_yn='N';
  IF n_pool <> 2 THEN RAISE EXCEPTION '사후 가드 실패: 판형 풀 % 행 (기대 2)', n_pool; END IF;
  -- SIZ_000641 코드 자체는 살아 있어야 한다(삭제 금지 확인)
  SELECT count(*) INTO n_code FROM t_siz_sizes WHERE siz_cd='SIZ_000641';
  IF n_code <> 1 THEN RAISE EXCEPTION '사후 가드 실패: SIZ_000641 코드가 사라졌다'; END IF;
  RAISE NOTICE '사후 가드 통과 — 판걸이 % · 641 잔여배선 0 · 판형풀 2 · 641 코드 보존', n;
END $$;

\echo '=== AFTER ==='
SELECT siz_cd, siz_nm, cut_width, cut_height, work_width, work_height, margin_lft,
       fn_calc_pansu('SIZ_000499', siz_cd) AS pansu_316x467
  FROM t_siz_sizes WHERE siz_cd = 'SIZ_000633';

SELECT prd_cd, siz_cd AS plate, item_siz_cd, dflt_plt_yn
  FROM t_prd_product_plate_sizes
 WHERE prd_cd IN ('PRD_000290','PRD_000292') AND del_yn = 'N'
 ORDER BY prd_cd, siz_cd;

COMMIT;
