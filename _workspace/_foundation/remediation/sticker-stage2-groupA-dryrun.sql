-- sticker-stage2-groupA-dryrun.sql
-- §27 마스터 스티커 단계2 — 무결성 결함 교정 적재 (그룹 A SAFE 돈크리티컬·DRY-RUN·ROLLBACK 전용)
-- 권위: sticker-authority-grid.csv(verbatim) + engine-design-sticker.md §4-1/§4-2c + sticker-integrity-verdict.md
-- 단가 INSERT는 전부 라이브 기존 단가행에서 SELECT 복제(verbatim·날조 0·대칭전개 0).
-- 종결자=ROLLBACK (절대 COMMIT 금지 · [[dryrun-vs-fix-script-commit-lesson]]).
-- 실측 기준선: comp_price_id MAX=39112 · seq=public.t_prc_component_prices_comp_price_id_seq · apply_ymd 통일='2026-06-01'
\set ON_ERROR_STOP on
BEGIN;

-- IDENTITY(BY DEFAULT) 시퀀스 정렬 선행 — INSERT가 comp_price_id를 채번에 맡김(명시 id 미지정·seq 사용)
SELECT setval('public.t_prc_component_prices_comp_price_id_seq',
              (SELECT max(comp_price_id) FROM t_prc_component_prices), true);

-- ============================================================
-- A-1. 052 A4 저청구 + 4소재 no_match 동시해소 — 사이즈 재바인딩 (UPDATE 1행)
--   근거: SIZ_172=낱장키(완칼 4000) · SIZ_520=반칼 A4(5소재 36단 완비·5000) · verdict I4/I5
--   효과: A4 저청구 -1000 해소 + 4소재(084/155/156/242) no_match 해소(520에 5소재 완비)
-- ============================================================
UPDATE t_prd_product_sizes
   SET siz_cd='SIZ_000520', upd_dt=now()
 WHERE prd_cd='PRD_000052' AND siz_cd='SIZ_000172' AND del_yn='N'
   AND NOT EXISTS (SELECT 1 FROM t_prd_product_sizes WHERE prd_cd='PRD_000052' AND siz_cd='SIZ_000520' AND del_yn='N');

-- ============================================================
-- A-2. 053/054 A4(172) 반칼 정합 — 사이즈 재바인딩(→520) + 520×mat162/163 단가행 INSERT
--   ★052와 분리(§4-2b): SIZ_520엔 mat162/163 단가행 부재 → 재바인딩만으론 no_match 잔존 → 단가행 적재 필요.
--   단가 출처: B01 A4_2판 grp3(투명/홀로) qty1=6000…100000=4600 (authority-grid · price-sticker-price-l1.csv:G5~)
--   verbatim 복제: 라이브 SIZ_520×mat153(반칼A4 밴드 구조)에서 min_qty/apply_ymd 골격 + B01 A4 grp3 단가
-- ------------------------------------------------------------
-- 053/054 A4 사이즈 재바인딩 172→520
UPDATE t_prd_product_sizes
   SET siz_cd='SIZ_000520', upd_dt=now()
 WHERE prd_cd IN('PRD_000053','PRD_000054') AND siz_cd='SIZ_000172' AND del_yn='N'
   AND NOT EXISTS (SELECT 1 FROM t_prd_product_sizes s2 WHERE s2.prd_cd=t_prd_product_sizes.prd_cd AND s2.siz_cd='SIZ_000520' AND s2.del_yn='N');

-- 520 × mat162(투명) 36단 INSERT — B01 A4 grp3 단가 verbatim (qty1=6000 … 100000=4600)
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note)
SELECT 'COMP_STK_PRINT','2026-06-01','SIZ_000520','MAT_000162', v.min_qty, v.unit_price, 'B01 col2(A4반칼) 투명·stage2 verbatim'
FROM (VALUES
  (1,6000),(2,6000),(3,6000),(4,6000),(5,6000),(6,6000),(8,6000),(10,6000),
  (15,5800),(20,5800),(25,5700),(30,5700),(38,5700),(40,5700),(50,5700),(60,5700),(70,5700),(75,5700),
  (80,5600),(90,5600),(100,5600),(120,5600),(125,5600),(140,5500),(150,5500),(160,5500),(175,5500),
  (180,5400),(200,5400),(250,5200),(300,5000),(350,4800),(400,4700),(450,4600),(500,4600),(100000,4600)
) AS v(min_qty, unit_price)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices p
                  WHERE p.comp_cd='COMP_STK_PRINT' AND p.siz_cd='SIZ_000520' AND p.mat_cd='MAT_000162' AND p.min_qty=v.min_qty);

-- 520 × mat163(홀로) 36단 INSERT — B01 A4 grp3 단가 동일(투명/홀로 동일가·authority grp3)
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note)
SELECT 'COMP_STK_PRINT','2026-06-01','SIZ_000520','MAT_000163', v.min_qty, v.unit_price, 'B01 col2(A4반칼) 홀로그램·stage2 verbatim'
FROM (VALUES
  (1,6000),(2,6000),(3,6000),(4,6000),(5,6000),(6,6000),(8,6000),(10,6000),
  (15,5800),(20,5800),(25,5700),(30,5700),(38,5700),(40,5700),(50,5700),(60,5700),(70,5700),(75,5700),
  (80,5600),(90,5600),(100,5600),(120,5600),(125,5600),(140,5500),(150,5500),(160,5500),(175,5500),
  (180,5400),(200,5400),(250,5200),(300,5000),(350,4800),(400,4700),(450,4600),(500,4600),(100000,4600)
) AS v(min_qty, unit_price)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices p
                  WHERE p.comp_cd='COMP_STK_PRINT' AND p.siz_cd='SIZ_000520' AND p.mat_cd='MAT_000163' AND p.min_qty=v.min_qty);

-- ============================================================
-- A-3. 053/054 A5(170) 정합 — SIZ_170×mat162/163 36단 INSERT (경로 b·058~061 형제 패턴 정합)
--   ★경로 a(059 추가 바인딩) 대신 경로 b 채택: 058~061·052가 A5=SIZ_170(148x210) 운영
--     059(124x186)는 062/063만 사용 → 053/054에 059 추가하면 손님에 신규 A5 노출(패턴 불일치).
--   단가 verbatim: SIZ_059/060 mat162·163 = B01 A5격자 grp3 (qty1=7000 … 100000=5000) — 라이브 059에서 SELECT 복제.
-- ------------------------------------------------------------
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note)
SELECT 'COMP_STK_PRINT','2026-06-01','SIZ_000170', s.mat_cd, s.min_qty, s.unit_price,
       'B01 A5(124x186) ' || CASE s.mat_cd WHEN 'MAT_000162' THEN '투명' ELSE '홀로그램' END || '·stage2 059 verbatim 복제'
FROM t_prc_component_prices s
WHERE s.comp_cd='COMP_STK_PRINT' AND s.siz_cd='SIZ_000059' AND s.mat_cd IN('MAT_000162','MAT_000163')
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices p
                  WHERE p.comp_cd='COMP_STK_PRINT' AND p.siz_cd='SIZ_000170' AND p.mat_cd=s.mat_cd AND p.min_qty=s.min_qty);

-- ============================================================
-- A-4. 055/056/057 자재 오바인딩 + 사이즈 누락 (UPDATE 자재 + INSERT 사이즈)
--   근거: 단가축 실측=낱장 유포 단가행=mat153·낱장 투명=mat162·대형 유포=mat153(SIZ_199).
--         상품자재 154(유포지)/243(투명커버)는 COMP_STK_PRINT 단가행 0행 → 손님 선택 자재가 가격축 코드와 불일치=no_match.
--   ★verdict 정정: MAT154 del_yn=N(논리삭제 아님). 재바인딩 근거=단가행 0행(154/243엔 단가 없음)·형제 정본 패턴(052/058~061=153).
--   B4(515)/B3(514) 단가셀은 라이브 실재(mat153/162 각 6행·verbatim) → 사이즈 바인딩 추가만(단가행 INSERT 불요).
-- ------------------------------------------------------------
-- 자재 재바인딩: 복합PK(prd_cd,mat_cd,usage_cd) → UPDATE mat_cd(155→충돌 가드)
UPDATE t_prd_product_materials SET mat_cd='MAT_000153', upd_dt=now()
 WHERE prd_cd='PRD_000055' AND mat_cd='MAT_000154' AND usage_cd='USAGE.07' AND del_yn='N'
   AND NOT EXISTS (SELECT 1 FROM t_prd_product_materials WHERE prd_cd='PRD_000055' AND mat_cd='MAT_000153' AND usage_cd='USAGE.07');
UPDATE t_prd_product_materials SET mat_cd='MAT_000162', upd_dt=now()
 WHERE prd_cd='PRD_000056' AND mat_cd='MAT_000243' AND usage_cd='USAGE.07' AND del_yn='N'
   AND NOT EXISTS (SELECT 1 FROM t_prd_product_materials WHERE prd_cd='PRD_000056' AND mat_cd='MAT_000162' AND usage_cd='USAGE.07');
UPDATE t_prd_product_materials SET mat_cd='MAT_000153', upd_dt=now()
 WHERE prd_cd='PRD_000057' AND mat_cd='MAT_000154' AND usage_cd='USAGE.07' AND del_yn='N'
   AND NOT EXISTS (SELECT 1 FROM t_prd_product_materials WHERE prd_cd='PRD_000057' AND mat_cd='MAT_000153' AND usage_cd='USAGE.07');

-- 사이즈 바인딩 추가: 055/056 B4(515)/B3(514) — 격자 B02/B03=5사이즈(A4/B4/A3/B3/A2)·라이브 3사이즈만
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, del_yn)
SELECT v.prd_cd, v.siz_cd, 'N', v.disp_seq, 'N'
FROM (VALUES
  ('PRD_000055','SIZ_000515',2),('PRD_000055','SIZ_000514',3),
  ('PRD_000056','SIZ_000515',2),('PRD_000056','SIZ_000514',3)
) AS v(prd_cd, siz_cd, disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes s WHERE s.prd_cd=v.prd_cd AND s.siz_cd=v.siz_cd);

-- ============================================================
-- A-5. 066 합판도무송 4소재 no_match — grpA(084)→155/156 · grpB(153)→170/171 동일가 복제 INSERT
--   근거: GANGPAN_B01~B03 grpA={비코팅084/무광155/유광156} 동일가 · grpB={유포153/투명데드롱170/은데드롱171} 동일가
--         라이브 COMP_GANGPAN_PRINT mat={084,153}만(각 37형상×5단=185행) → 4소재 복제(verbatim 동일가)
--         066 오퍼 6소재 실측 확인(153/084/155/156/170/171) → 6소재 전부 단가 매칭화
-- ------------------------------------------------------------
-- grpA: 084 → 155(무광), 156(유광) 복제
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', s.apply_ymd, s.siz_cd, t.mat_cd, s.min_qty, s.unit_price,
       COALESCE(s.note,'') || ' [stage2 grpA 084 verbatim 복제→' || t.mat_cd || ']'
FROM t_prc_component_prices s
CROSS JOIN (VALUES ('MAT_000155'),('MAT_000156')) AS t(mat_cd)
WHERE s.comp_cd='COMP_GANGPAN_PRINT' AND s.mat_cd='MAT_000084'
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices p
                  WHERE p.comp_cd='COMP_GANGPAN_PRINT' AND p.siz_cd=s.siz_cd AND p.mat_cd=t.mat_cd AND p.min_qty=s.min_qty);

-- grpB: 153 → 170(투명데드롱), 171(은데드롱) 복제
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', s.apply_ymd, s.siz_cd, t.mat_cd, s.min_qty, s.unit_price,
       COALESCE(s.note,'') || ' [stage2 grpB 153 verbatim 복제→' || t.mat_cd || ']'
FROM t_prc_component_prices s
CROSS JOIN (VALUES ('MAT_000170'),('MAT_000171')) AS t(mat_cd)
WHERE s.comp_cd='COMP_GANGPAN_PRINT' AND s.mat_cd='MAT_000153'
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices p
                  WHERE p.comp_cd='COMP_GANGPAN_PRINT' AND p.siz_cd=s.siz_cd AND p.mat_cd=t.mat_cd AND p.min_qty=s.min_qty);

-- ============================================================
-- 사후 어서션 (격자 완전화 · 저청구 해소 · no_match 0)
-- ============================================================
\echo '== A-1: 052 A4 저청구 해소 (172→520·5000) =='
SELECT 'PRD_000052' AS prd, count(*) FILTER(WHERE siz_cd='SIZ_000520') AS bound_520,
       count(*) FILTER(WHERE siz_cd='SIZ_000172') AS bound_172_left,
       CASE WHEN count(*) FILTER(WHERE siz_cd='SIZ_000520')=1 AND count(*) FILTER(WHERE siz_cd='SIZ_000172')=0
            THEN 'PASS' ELSE 'FAIL' END AS verdict
FROM t_prd_product_sizes WHERE prd_cd='PRD_000052' AND del_yn='N';

\echo '== A-1: 052 A4 5소재 매칭화 (520×5소재 단가행 실재) =='
SELECT count(DISTINCT cp.mat_cd) AS matched_mats,
       CASE WHEN count(DISTINCT cp.mat_cd)=5 THEN 'PASS(5소재)' ELSE 'FAIL' END AS verdict
FROM t_prd_product_materials pm
JOIN t_prc_component_prices cp ON cp.comp_cd='COMP_STK_PRINT' AND cp.siz_cd='SIZ_000520' AND cp.mat_cd=pm.mat_cd AND cp.min_qty=1
WHERE pm.prd_cd='PRD_000052' AND pm.del_yn='N';

\echo '== A-2: 053/054 A4(520) 투명/홀로 단가행 36단 INSERT 확인 =='
SELECT mat_cd, count(*) AS bands, min(unit_price) FILTER(WHERE min_qty=1) AS q1
FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND siz_cd='SIZ_000520' AND mat_cd IN('MAT_000162','MAT_000163')
GROUP BY mat_cd ORDER BY mat_cd;  -- 기대: 각 36단·q1=6000

\echo '== A-3: 053/054 A5(170) 투명/홀로 36단 INSERT 확인 =='
SELECT mat_cd, count(*) AS bands, min(unit_price) FILTER(WHERE min_qty=1) AS q1
FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND siz_cd='SIZ_000170' AND mat_cd IN('MAT_000162','MAT_000163')
GROUP BY mat_cd ORDER BY mat_cd;  -- 기대: 각 36단·q1=7000

\echo '== A-2/A-3 종합: 053/054 전 바인딩사이즈 no_match 0 (170/520 × 162/163 매칭) =='
WITH bind AS (
  SELECT s.prd_cd, s.siz_cd, m.mat_cd FROM t_prd_product_sizes s
  JOIN t_prd_product_materials m ON m.prd_cd=s.prd_cd AND m.del_yn='N'
  WHERE s.prd_cd IN('PRD_000053','PRD_000054') AND s.del_yn='N' AND s.siz_cd<>'SIZ_000196'  -- A6=그룹B
)
SELECT b.prd_cd, count(*) AS bind_cells,
       count(*) FILTER(WHERE cp.comp_price_id IS NULL) AS no_match_cells,
       CASE WHEN count(*) FILTER(WHERE cp.comp_price_id IS NULL)=0 THEN 'PASS(no_match 0)' ELSE 'FAIL' END AS verdict
FROM bind b
LEFT JOIN t_prc_component_prices cp ON cp.comp_cd='COMP_STK_PRINT' AND cp.siz_cd=b.siz_cd AND cp.mat_cd=b.mat_cd AND cp.min_qty=1
GROUP BY b.prd_cd ORDER BY b.prd_cd;

\echo '== A-4: 055/056/057 자재 재바인딩(153/162/153) + 단가행 매칭 =='
SELECT pm.prd_cd, pm.mat_cd,
       (SELECT count(*) FROM t_prc_component_prices cp
        JOIN t_prd_product_sizes ps ON ps.prd_cd=pm.prd_cd AND ps.del_yn='N'
        WHERE cp.comp_cd='COMP_STK_PRINT' AND cp.mat_cd=pm.mat_cd AND cp.siz_cd=ps.siz_cd AND cp.min_qty=1) AS matched_size_cells
FROM t_prd_product_materials pm WHERE pm.prd_cd IN('PRD_000055','PRD_000056','PRD_000057') AND pm.del_yn='N' ORDER BY pm.prd_cd;

\echo '== A-4: 055/056 사이즈 5개 바인딩 (A4/B4/A3/B3/A2) =='
SELECT prd_cd, count(*) AS sizes,
       CASE WHEN count(*)=5 THEN 'PASS(5사이즈)' ELSE 'FAIL' END AS verdict
FROM t_prd_product_sizes WHERE prd_cd IN('PRD_000055','PRD_000056') AND del_yn='N'
  AND siz_cd IN('SIZ_000172','SIZ_000174','SIZ_000197','SIZ_000514','SIZ_000515') GROUP BY prd_cd ORDER BY prd_cd;

\echo '== A-5: 066 합판 6소재 전부 단가행 실재 (no_match 0) =='
SELECT mat_cd, count(DISTINCT siz_cd) AS shapes
FROM t_prc_component_prices WHERE comp_cd='COMP_GANGPAN_PRINT' AND mat_cd IN('MAT_000084','MAT_000153','MAT_000155','MAT_000156','MAT_000170','MAT_000171')
GROUP BY mat_cd ORDER BY mat_cd;  -- 기대: 6소재 각 37형상

\echo '== 066 오퍼 6소재 × 단가행 no_match 0 종합 =='
SELECT count(*) AS offer_mats, count(*) FILTER(WHERE gp.mat_cd IS NULL) AS no_price_mats,
       CASE WHEN count(*) FILTER(WHERE gp.mat_cd IS NULL)=0 THEN 'PASS(6소재 매칭)' ELSE 'FAIL' END AS verdict
FROM t_prd_product_materials pm
LEFT JOIN (SELECT DISTINCT mat_cd FROM t_prc_component_prices WHERE comp_cd='COMP_GANGPAN_PRINT') gp ON gp.mat_cd=pm.mat_cd
WHERE pm.prd_cd='PRD_000066' AND pm.del_yn='N';

\echo '== 신규 단가행 채번 카운트 (052재바인딩=0행·053/054 A4 72·A5 72·066 4소재×37×5단) =='
SELECT
 (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND siz_cd='SIZ_000520' AND mat_cd IN('MAT_000162','MAT_000163')) AS a4_520_new,
 (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND siz_cd='SIZ_000170' AND mat_cd IN('MAT_000162','MAT_000163')) AS a5_170_new,
 (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_GANGPAN_PRINT' AND mat_cd IN('MAT_000155','MAT_000156','MAT_000170','MAT_000171')) AS gangpan_new;

ROLLBACK;
\echo '== ROLLBACK 완료 — 라이브 미변경 (실 COMMIT은 인간 승인 후 -fix.sql) =='
