-- silsa PRICED-0 교정: 단가행 siz_cd 중복본 → 정본 재키잉 (DRY-RUN · ROLLBACK)
-- 2026-06-29. score_batch PRICED-0 적발 → 근본원인=상품 옵션 siz_cd(정본) vs 단가행 siz_cd(중복본) 불일치.
--   엔진 _row_matches(pricing.py:94)는 단가행 siz_cd(NON_QTY_DIMS)를 매칭 조건으로 사용.
--   silsa 본체 comp 단가행은 siz_cd 외 NON_QTY(plt/opt/mat/print_opt/proc/w/h)가 전부 NULL(와일드카드)
--   → siz_cd 만이 유일한 매칭 키 → 중복본 코드를 정본으로 재키잉하면 옵션과 일치 → 매칭 성공.
-- [HARD] 실 COMMIT 금지(인간 승인). 기초코드 마스터(t_siz_sizes) 미터치 — 단가행 FK 재키잉만.
--        t_prc_component_prices 에 del_yn 없음 — 물리 UPDATE(값 불변·키만 정본화).
--
-- 정본↔중복본 매핑(cut_width/cut_height 물리 사이즈 동일 확정):
--   SIZ_000315(A3) → SIZ_000174(A3 297x420)
--   SIZ_000317(A2) → SIZ_000197(A2 420x594)
--   SIZ_000258(A4) → SIZ_000172(A4 210x297)
--   SIZ_000426(A5) → SIZ_000170(A5 148x210)
--   SIZ_000294(A1) → SIZ_000293(A1 594x841)
--
-- 스코프: silsa PRICED-0 본체 comp 9종 한정(전부 1상품 전용·다른 상품군 영향 0 검증 완료).
-- 충돌: comp별 (정본 siz_cd, min_qty) 행이 이미 있는 경우 0건(전수 점검 완료) → 단순 UPDATE 안전.

BEGIN;

-- ── 0. 교정 전 상태 스냅샷 (재키잉 대상 35행) ──────────────────────────
\echo '=== BEFORE: 재키잉 대상 단가행 (중복본 siz_cd) ==='
SELECT comp_cd, siz_cd, count(*) AS n_rows
  FROM t_prc_component_prices
 WHERE comp_cd IN (
        'COMP_POSTER_FOAMBOARD_WHITE','COMP_POSTER_FOMEXBOARD_WHITE3MM',
        'COMP_POSTER_FRAMELESS_WOOD','COMP_POSTER_LEATHER_FRAME',
        'COMP_POSTER_CANVAS_HANGING','COMP_POSTER_JOKJA',
        'COMP_POSTER_SHEETCUT_MATTE','COMP_POSTER_SHEETCUT_HOLO',
        'COMP_POSTER_MINI_STANDBOARD')
   AND siz_cd IN ('SIZ_000315','SIZ_000317','SIZ_000258','SIZ_000426','SIZ_000294')
 GROUP BY comp_cd, siz_cd
 ORDER BY comp_cd, siz_cd;

-- ── 0b. 충돌 사전 가드: 재키잉 시 (comp, 정본 siz_cd, min_qty) 가 이미 존재하면 중단 ──
\echo '=== 충돌 점검(아래 0건이어야 안전) ==='
WITH m(dup, canon) AS (VALUES
  ('SIZ_000315','SIZ_000174'),('SIZ_000317','SIZ_000197'),
  ('SIZ_000258','SIZ_000172'),('SIZ_000426','SIZ_000170'),
  ('SIZ_000294','SIZ_000293'))
SELECT a.comp_cd, a.siz_cd AS dup_siz, m.canon AS canon_siz,
       a.min_qty, '★충돌: 정본행 이미 존재' AS warn
  FROM t_prc_component_prices a
  JOIN m ON a.siz_cd = m.dup
  JOIN t_prc_component_prices b
       ON b.comp_cd = a.comp_cd AND b.siz_cd = m.canon
      AND COALESCE(b.min_qty,-1) = COALESCE(a.min_qty,-1)
 WHERE a.comp_cd IN (
        'COMP_POSTER_FOAMBOARD_WHITE','COMP_POSTER_FOMEXBOARD_WHITE3MM',
        'COMP_POSTER_FRAMELESS_WOOD','COMP_POSTER_LEATHER_FRAME',
        'COMP_POSTER_CANVAS_HANGING','COMP_POSTER_JOKJA',
        'COMP_POSTER_SHEETCUT_MATTE','COMP_POSTER_SHEETCUT_HOLO',
        'COMP_POSTER_MINI_STANDBOARD');

-- ── 1. 재키잉 UPDATE (멱등: WHERE siz_cd=중복본 AND comp_cd IN silsa 본체) ──
-- 각 매핑별 1문. 값(unit_price·min_qty·bdl_qty 등) 불변 — siz_cd 만 정본화.
UPDATE t_prc_component_prices SET siz_cd='SIZ_000174', upd_dt=now()
 WHERE siz_cd='SIZ_000315' AND comp_cd IN (
        'COMP_POSTER_FOAMBOARD_WHITE','COMP_POSTER_FOMEXBOARD_WHITE3MM',
        'COMP_POSTER_FRAMELESS_WOOD','COMP_POSTER_LEATHER_FRAME',
        'COMP_POSTER_CANVAS_HANGING','COMP_POSTER_JOKJA',
        'COMP_POSTER_SHEETCUT_MATTE','COMP_POSTER_SHEETCUT_HOLO',
        'COMP_POSTER_MINI_STANDBOARD');

UPDATE t_prc_component_prices SET siz_cd='SIZ_000197', upd_dt=now()
 WHERE siz_cd='SIZ_000317' AND comp_cd IN (
        'COMP_POSTER_FOAMBOARD_WHITE','COMP_POSTER_FOMEXBOARD_WHITE3MM',
        'COMP_POSTER_FRAMELESS_WOOD','COMP_POSTER_LEATHER_FRAME',
        'COMP_POSTER_CANVAS_HANGING','COMP_POSTER_JOKJA',
        'COMP_POSTER_SHEETCUT_MATTE','COMP_POSTER_SHEETCUT_HOLO',
        'COMP_POSTER_MINI_STANDBOARD');

UPDATE t_prc_component_prices SET siz_cd='SIZ_000172', upd_dt=now()
 WHERE siz_cd='SIZ_000258' AND comp_cd IN (
        'COMP_POSTER_FOAMBOARD_WHITE','COMP_POSTER_FOMEXBOARD_WHITE3MM',
        'COMP_POSTER_FRAMELESS_WOOD','COMP_POSTER_LEATHER_FRAME',
        'COMP_POSTER_CANVAS_HANGING','COMP_POSTER_JOKJA',
        'COMP_POSTER_SHEETCUT_MATTE','COMP_POSTER_SHEETCUT_HOLO',
        'COMP_POSTER_MINI_STANDBOARD');

UPDATE t_prc_component_prices SET siz_cd='SIZ_000170', upd_dt=now()
 WHERE siz_cd='SIZ_000426' AND comp_cd IN (
        'COMP_POSTER_FOAMBOARD_WHITE','COMP_POSTER_FOMEXBOARD_WHITE3MM',
        'COMP_POSTER_FRAMELESS_WOOD','COMP_POSTER_LEATHER_FRAME',
        'COMP_POSTER_CANVAS_HANGING','COMP_POSTER_JOKJA',
        'COMP_POSTER_SHEETCUT_MATTE','COMP_POSTER_SHEETCUT_HOLO',
        'COMP_POSTER_MINI_STANDBOARD');

UPDATE t_prc_component_prices SET siz_cd='SIZ_000293', upd_dt=now()
 WHERE siz_cd='SIZ_000294' AND comp_cd IN (
        'COMP_POSTER_FOAMBOARD_WHITE','COMP_POSTER_FOMEXBOARD_WHITE3MM',
        'COMP_POSTER_FRAMELESS_WOOD','COMP_POSTER_LEATHER_FRAME',
        'COMP_POSTER_CANVAS_HANGING','COMP_POSTER_JOKJA',
        'COMP_POSTER_SHEETCUT_MATTE','COMP_POSTER_SHEETCUT_HOLO',
        'COMP_POSTER_MINI_STANDBOARD');

-- ── 2. 검증 쿼리: 재키잉 후 각 silsa 상품의 옵션 siz_cd 가 단가행 siz_cd 에 포함되는가 ──
-- 본체 comp 기준. 옵션 siz_cd ⊆ (재키잉 후) 단가행 siz_cd 면 매칭 성공.
\echo '=== AFTER: 상품별 옵션 siz_cd vs 단가행 siz_cd 커버리지 ==='
WITH pc(prd_cd, comp_cd, prd_nm) AS (VALUES
  ('PRD_000129','COMP_POSTER_FOAMBOARD_WHITE','폼보드'),
  ('PRD_000130','COMP_POSTER_FOMEXBOARD_WHITE3MM','포맥스'),
  ('PRD_000131','COMP_POSTER_FRAMELESS_WOOD','프레임리스'),
  ('PRD_000132','COMP_POSTER_LEATHER_FRAME','레더'),
  ('PRD_000133','COMP_POSTER_CANVAS_HANGING','캔버스행잉'),
  ('PRD_000135','COMP_POSTER_JOKJA','족자'),
  ('PRD_000140','COMP_POSTER_SHEETCUT_MATTE','무광시트'),
  ('PRD_000141','COMP_POSTER_SHEETCUT_HOLO','홀로그램'),
  ('PRD_000144','COMP_POSTER_MINI_STANDBOARD','미니보드'))
SELECT pc.prd_nm,
       ps.siz_cd AS opt_siz,
       CASE WHEN EXISTS (
            SELECT 1 FROM t_prc_component_prices cp
             WHERE cp.comp_cd = pc.comp_cd AND cp.siz_cd = ps.siz_cd)
            THEN 'OK(매칭됨)' ELSE '★단가행 없음(잔여결함)' END AS status
  FROM pc
  JOIN t_prd_product_sizes ps
       ON ps.prd_cd = pc.prd_cd AND ps.del_yn='N'
 ORDER BY pc.prd_nm, ps.siz_cd;

-- 캔버스행잉133 본체 comp 는 use_dims=[siz_width,siz_height,min_qty] 이지만 단가행은
-- siz_cd 만 값 보유(w/h NULL=catch-all) → siz_cd 가 실매칭 키. 재키잉으로 동일하게 해소됨(위 표).

\echo '=== ROLLBACK (DRY-RUN — 실 적용은 인간 승인 후 별도 FIX 스크립트) ==='
ROLLBACK;

-- ──────────────────────────────────────────────────────────────────────
-- 잔여 결함(재키잉으로 해소 불가 — 단가행 자체 부재. 조사 신호·자동교정 금지):
--   · 레더132: 옵션 SIZ_000304(5x5)·306(5x7)·308(8x8)·310(8x10) 4개 단가행 부재
--             (단가행은 A4·A3만). → 권위 가격표에서 소형 4사이즈 단가 확인 후 INSERT 별도.
--   · 족자135: 옵션 SIZ_000293(A1) 단가행 부재(중복본 294도 없음·정본도 없음).
--             → 권위 가격표에서 A1 단가 확인 후 INSERT 별도.
-- 위 2건은 재키잉(이 스크립트) 적용 후에도 해당 사이즈만 PRICED-0 지속(다른 사이즈는 해소).
-- ──────────────────────────────────────────────────────────────────────
