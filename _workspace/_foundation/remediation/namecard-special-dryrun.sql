-- =====================================================================
-- namecard-special-dryrun.sql — 롤백전용 DRY-RUN (라이브 미변경)
-- 생성 2026-06-27 · hpe-engine-designer · BEGIN→적용→검증(delta)→ROLLBACK
-- 용도: print_opt 보강(태깅+use_dims)+배선+바인딩을 트랜잭션 안에서 적용한 뒤,
--       ★태깅 전 vs 후 면 매칭 delta(이중합산→정상)·골든 단면/양면·멱등을 실증, ROLLBACK 원복.
--   단가값(unit_price) 불변이 핵심 불변식. 게이트(E1~E7)가 이 산출을 독립 재실측.
-- =====================================================================
BEGIN;

-- ── BEFORE delta: 태깅 전 035 양면 100 주문 시 매칭되는 행(S1+S2 둘 다=과청구 37000) ──
-- _row_matches: 단가행 print_opt_cd가 NULL이면 와일드카드 → 양면 선택(POPT_000002)에도 S1·S2 둘 다 매칭.
\echo '== DELTA-BEFORE: 035 양면 선택 시 매칭 후보(태깅 전 — S1+S2 둘 다=이중합산) =='
SELECT comp_cd, print_opt_cd AS row_opt, unit_price,
       '양면선택 POPT_000002에 매칭됨(NULL 와일드)' AS note
  FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2')
   AND siz_cd='SIZ_000008' AND min_qty=100
   AND (print_opt_cd IS NULL OR print_opt_cd='POPT_000002');  -- 태깅 전엔 NULL이라 둘 다

-- ── ① 태깅 ──
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000001', upd_dt=now()
 WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_MINISHAPE_S1','COMP_NAMECARD_PEARL_S1',
                   'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL')
   AND print_opt_cd IS NULL;
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000002', upd_dt=now()
 WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S2','COMP_NAMECARD_MINISHAPE_S2','COMP_NAMECARD_PEARL_S2',
                   'COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL')
   AND print_opt_cd IS NULL;

-- ── ② use_dims 보강 ──
UPDATE t_prc_price_components SET use_dims=use_dims||'["print_opt_cd"]'::jsonb, upd_dt=now()
 WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2','COMP_NAMECARD_MINISHAPE_S1',
                   'COMP_NAMECARD_MINISHAPE_S2','COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2',
                   'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL',
                   'COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL')
   AND NOT (use_dims ? 'print_opt_cd');

-- ── ③ PRF / ④ 배선 / ⑤ 바인딩 ──
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn) VALUES
  ('PRF_NAMECARD_SHAPE','모양명함 면/수량별 단가(용지포함)','dryrun','Y'),
  ('PRF_NAMECARD_MINISHAPE','미니모양명함 면/수량별 단가(용지포함)','dryrun','Y'),
  ('PRF_NAMECARD_FOIL','오리지널박명함 박종류/수량별 단가 + 동판셋업비','dryrun','Y'),
  ('PRF_NAMECARD_CLEAR','투명명함 수량별 단가(용지포함)','dryrun','Y'),
  ('PRF_NAMECARD_PEARL','펄명함(스타드림) 면/소재/수량별 단가(용지포함)','dryrun','Y')
ON CONFLICT (frm_cd) DO NOTHING;

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) VALUES
  ('PRF_NAMECARD_SHAPE','COMP_NAMECARD_SHAPE_S1',1,'Y'),
  ('PRF_NAMECARD_SHAPE','COMP_NAMECARD_SHAPE_S2',2,'Y'),
  ('PRF_NAMECARD_MINISHAPE','COMP_NAMECARD_MINISHAPE_S1',1,'Y'),
  ('PRF_NAMECARD_MINISHAPE','COMP_NAMECARD_MINISHAPE_S2',2,'Y'),
  ('PRF_NAMECARD_FOIL','COMP_NAMECARD_FOIL_S1_STD',1,'Y'),
  ('PRF_NAMECARD_FOIL','COMP_NAMECARD_FOIL_SETUP_S1_STD',2,'Y'),
  ('PRF_NAMECARD_CLEAR','COMP_NAMECARD_CLEAR_S1',1,'Y'),
  ('PRF_NAMECARD_PEARL','COMP_NAMECARD_PEARL_S1',1,'Y'),
  ('PRF_NAMECARD_PEARL','COMP_NAMECARD_PEARL_S2',2,'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT v.prd_cd, v.frm_cd, '2026-06-27', 'dryrun'
FROM (VALUES ('PRD_000035','PRF_NAMECARD_SHAPE'),('PRD_000036','PRF_NAMECARD_MINISHAPE'),
             ('PRD_000037','PRF_NAMECARD_FOIL'),('PRD_000039','PRF_NAMECARD_CLEAR')
) AS v(prd_cd, frm_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas f
                  WHERE f.prd_cd=v.prd_cd AND f.apply_bgn_ymd='2026-06-27');

-- ── 검증 V1: 적재 건수 ──
\echo '== V1: 바인딩(기대 4) · 배선(기대 9) =='
SELECT 'binding' AS k, count(*) AS n FROM t_prd_product_price_formulas
  WHERE prd_cd IN ('PRD_000035','PRD_000036','PRD_000037','PRD_000039') AND apply_bgn_ymd='2026-06-27'
UNION ALL SELECT 'wiring', count(*) FROM t_prc_formula_components
  WHERE frm_cd IN ('PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE','PRF_NAMECARD_FOIL','PRF_NAMECARD_CLEAR','PRF_NAMECARD_PEARL');

-- ── 검증 V2 (★핵심): DELTA-AFTER — 035 양면 100 주문 시 매칭 행(태깅 후 S2만=19000) ──
\echo '== V2 DELTA-AFTER: 035 양면(POPT_000002) 매칭 행(기대 S2 1행=19000·과청구 해소) =='
SELECT comp_cd, print_opt_cd AS row_opt, unit_price
  FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2')
   AND siz_cd='SIZ_000008' AND min_qty=100
   AND (print_opt_cd IS NULL OR print_opt_cd='POPT_000002');  -- 태깅 후 S1=001 제외 → S2만
\echo '== V2 DELTA-AFTER: 035 단면(POPT_000001) 매칭 행(기대 S1 1행=18000) =='
SELECT comp_cd, print_opt_cd AS row_opt, unit_price
  FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2')
   AND siz_cd='SIZ_000008' AND min_qty=100
   AND (print_opt_cd IS NULL OR print_opt_cd='POPT_000001');  -- 태깅 후 S2=002 제외 → S1만

-- ── 검증 V3: 골든 단가 단면/양면 둘 다(verbatim) ──
\echo '== V3: 골든 단가 — 단면/양면 둘 다 =='
SELECT 'G1 모양 단면' AS golden, unit_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_NAMECARD_SHAPE_S1' AND siz_cd='SIZ_000008' AND min_qty=100
UNION ALL SELECT 'G1b 모양 양면', unit_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_NAMECARD_SHAPE_S2' AND siz_cd='SIZ_000008' AND min_qty=100
UNION ALL SELECT 'G3 미니 단면', unit_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_NAMECARD_MINISHAPE_S1' AND siz_cd='SIZ_000011' AND min_qty=100
UNION ALL SELECT 'G3b 미니 양면', unit_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_NAMECARD_MINISHAPE_S2' AND siz_cd='SIZ_000011' AND min_qty=100
UNION ALL SELECT 'G4 투명', unit_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_NAMECARD_CLEAR_S1' AND min_qty=100
UNION ALL SELECT 'G5a 박 일반200', unit_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_NAMECARD_FOIL_S1_STD' AND min_qty=200
UNION ALL SELECT 'G5b 동판셋업', unit_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_NAMECARD_FOIL_SETUP_S1_STD';
-- 기대: G1=18000 G1b=19000 G3=16000 G3b=17000 G4=13500 G5a=19200 G5b=5000
-- 박 단면200 final = 19200+5000=24200

-- ── 검증 V4: 단가값 불변(태깅이 unit_price 미변경) — comp별 합 ──
\echo '== V4: 단가값 불변(print_opt 태깅이 unit_price를 건드리지 않음) =='
SELECT comp_cd, count(*) AS rows, sum(unit_price) AS price_sum
  FROM t_prc_component_prices
 WHERE comp_cd LIKE 'COMP_NAMECARD_SHAPE_%' OR comp_cd LIKE 'COMP_NAMECARD_MINISHAPE_%'
    OR comp_cd LIKE 'COMP_NAMECARD_PEARL_%' OR comp_cd='COMP_NAMECARD_CLEAR_S1'
 GROUP BY comp_cd ORDER BY comp_cd;
-- 기대 합: SHAPE_S1=18000 S2=19000 / MINISHAPE_S1=16000 S2=17000 / PEARL_S1=19000 S2=21000 / CLEAR=13500

-- ── 검증 V5: use_dims 보강(+print_opt_cd) ──
\echo '== V5: use_dims에 print_opt_cd 포함 확인 =='
SELECT comp_cd, use_dims FROM t_prc_price_components
 WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2','COMP_NAMECARD_PEARL_S1')
 ORDER BY comp_cd;

-- ── 검증 V6: 멱등 재실행 0행 ──
\echo '== V6: 멱등 — 태깅·PRF 재적용 시 0 변경 =='
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000001'
 WHERE comp_cd='COMP_NAMECARD_SHAPE_S1' AND print_opt_cd IS NULL;  -- 기대 0 rows
INSERT INTO t_prc_price_formulas (frm_cd,frm_nm,note,use_yn)
 VALUES ('PRF_NAMECARD_SHAPE','dup','dup','Y') ON CONFLICT (frm_cd) DO NOTHING;  -- 기대 0
\echo '(위 UPDATE/INSERT 0 rows = 멱등 OK)'

-- ── 검증 V7: 펄/화이트 자재 collapse 적발(바인딩 보류 사유) ──
\echo '== V7: 펄/화이트 등록자재 ↔ 단가행 mat_cd 불일치(바인딩 보류·dbmap 위임) =='
SELECT 'PEARL 등록' AS k, string_agg(mat_cd,',' ORDER BY mat_cd) AS mats
  FROM t_prd_product_materials WHERE prd_cd='PRD_000034' AND del_yn='N'
UNION ALL SELECT 'PEARL 단가행', string_agg(DISTINCT mat_cd,',') FROM t_prc_component_prices
  WHERE comp_cd='COMP_NAMECARD_PEARL_S1'
UNION ALL SELECT 'WHITE 등록', string_agg(mat_cd,',' ORDER BY mat_cd)
  FROM t_prd_product_materials WHERE prd_cd='PRD_000040' AND del_yn='N'
UNION ALL SELECT 'WHITE 단가행', string_agg(DISTINCT mat_cd,',') FROM t_prc_component_prices
  WHERE comp_cd='COMP_NAMECARD_WHITE_S1W_NOCL';

ROLLBACK;
\echo '== ROLLBACK 완료 — 라이브 변경 0 =='
