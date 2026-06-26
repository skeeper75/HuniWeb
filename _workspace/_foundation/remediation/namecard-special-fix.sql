-- =====================================================================
-- namecard-special-fix.sql — 명함특수 전용 가격공식: print_opt 보강 + S1/S2 배선
-- 생성 2026-06-27 · hpe-engine-designer(§18) · DB 미적재(게이트 GO + 인간 승인 후 적용)
-- ★사용자 결정 = print_opt 보강(데이터) 후 전체 배선(단면/양면 정상). "S1 단독"안 폐기.
-- 권위[HARD]: 인쇄상품 가격표 260527 「명함포토카드」 B04~B09. 단가값은 라이브 verbatim.
--
-- 변경 = ① print_opt_cd 태깅 UPDATE(NULL→코드, 단가값 불변) ② use_dims 보강 UPDATE
--        ③ PRF 신설 ④ formula_components S1+S2 배선 ⑤ product_price_formulas 바인딩.
--   ★unit_price·comp 정의·자재마스터·삭제 = 0 변경. print_opt_cd 차원 컬럼만 채움.
--   ★이중합산 0: 태깅 후 단가행 print_opt_cd가 면 선택과 정확매칭 → S1/S2 한쪽만 합산(STD 패턴).
-- 멱등: 태깅=print_opt_cd IS NULL 가드 / use_dims=jsonb `?` 미포함 시만 / PRF·배선=ON CONFLICT
--       / 바인딩=NOT EXISTS. 재실행 0 변경.
-- 안전: 단일 트랜잭션. 실 COMMIT은 인간 승인 후. 검증=namecard-special-dryrun.sql.
--
-- 적재 범위:
--   GO        = 035 모양·036 미니모양(보강 후)·037 박(보강 불요)·039 투명(보강 불요).
--   자재 선결 = 034 펄 — 태깅·use_dims·PRF·배선은 작성, 바인딩만 보류(자재 collapse 후).
--   보류      = 040 화이트 — 면 태깅만 선반영. PRF/배선/바인딩 미포함(코팅+자재 3중 선결).
--   위임      = 자재 collapse(펄·화이트)=dbmap namecard-mat-fix · HOLO/양면박/코팅=CPQ dbmap.
-- =====================================================================
BEGIN;

\echo '== BEFORE: 명함특수 6 바인딩 현황(기대 0행) =='
SELECT prd_cd, frm_cd, apply_bgn_ymd
  FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000034','PRD_000035','PRD_000036','PRD_000037','PRD_000039','PRD_000040')
 ORDER BY prd_cd;

-- ─────────────────────────────────────────────────────────────────────
-- ① print_opt_cd 태깅 (단가행 차원 보강) — _S1*→POPT_000001(단면)·_S2*→POPT_000002(양면).
--    멱등: print_opt_cd IS NULL 일 때만. unit_price·기타 컬럼 불변. 12행(035/036 4·펄 4·화이트 4).
-- ─────────────────────────────────────────────────────────────────────
-- 단면(S1) 태깅 → POPT_000001
UPDATE t_prc_component_prices
   SET print_opt_cd = 'POPT_000001', upd_dt = now()
 WHERE comp_cd IN (
         'COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_MINISHAPE_S1',
         'COMP_NAMECARD_PEARL_S1',
         'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL')
   AND print_opt_cd IS NULL;

-- 양면(S2) 태깅 → POPT_000002
UPDATE t_prc_component_prices
   SET print_opt_cd = 'POPT_000002', upd_dt = now()
 WHERE comp_cd IN (
         'COMP_NAMECARD_SHAPE_S2','COMP_NAMECARD_MINISHAPE_S2',
         'COMP_NAMECARD_PEARL_S2',
         'COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL')
   AND print_opt_cd IS NULL;

\echo '== (1) 태깅 결과(기대: S1*->001 / S2*->002, 단가 불변) =='
SELECT comp_cd, print_opt_cd, count(*) AS rows, sum(unit_price) AS price_sum
  FROM t_prc_component_prices
 WHERE comp_cd LIKE 'COMP_NAMECARD_SHAPE_%' OR comp_cd LIKE 'COMP_NAMECARD_MINISHAPE_%'
    OR comp_cd LIKE 'COMP_NAMECARD_PEARL_%' OR comp_cd LIKE 'COMP_NAMECARD_WHITE_%'
 GROUP BY comp_cd, print_opt_cd ORDER BY comp_cd;

-- ─────────────────────────────────────────────────────────────────────
-- ② use_dims 보강 — 보강 comp의 use_dims(jsonb)에 "print_opt_cd" 추가.
--    멱등: jsonb `?` (이미 포함 시 skip). 10 comp(035/036 4·펄 2·화이트 4).
-- ─────────────────────────────────────────────────────────────────────
UPDATE t_prc_price_components
   SET use_dims = use_dims || '["print_opt_cd"]'::jsonb, upd_dt = now()
 WHERE comp_cd IN (
         'COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2',
         'COMP_NAMECARD_MINISHAPE_S1','COMP_NAMECARD_MINISHAPE_S2',
         'COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2',
         'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL',
         'COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL')
   AND NOT (use_dims ? 'print_opt_cd');

\echo '== (2) use_dims 보강 결과(기대: +print_opt_cd) =='
SELECT comp_cd, use_dims FROM t_prc_price_components
 WHERE comp_cd LIKE 'COMP_NAMECARD_SHAPE_%' OR comp_cd LIKE 'COMP_NAMECARD_MINISHAPE_%'
    OR comp_cd LIKE 'COMP_NAMECARD_PEARL_%' OR comp_cd LIKE 'COMP_NAMECARD_WHITE_%'
 ORDER BY comp_cd;

-- ─────────────────────────────────────────────────────────────────────
-- ③ 전용 PRF 신설(5) — SHAPE·MINISHAPE·FOIL·CLEAR·PEARL. 화이트는 보류(미포함).
--    frm_nm = 실무진 용어(코드 비노출). 멱등: frm_cd 충돌 시 무시.
-- ─────────────────────────────────────────────────────────────────────
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES
  ('PRF_NAMECARD_SHAPE',     '모양명함 면/수량별 단가(용지포함)',
     '가격표260527 B07. SHAPE_S1(단면)+S2(양면) print_opt 태깅 배선. siz_cd 정확매칭.', 'Y'),
  ('PRF_NAMECARD_MINISHAPE', '미니모양명함 면/수량별 단가(용지포함)',
     '가격표260527 B08. MINISHAPE_S1+S2 print_opt 태깅 배선. siz_cd 정확매칭.', 'Y'),
  ('PRF_NAMECARD_FOIL',      '오리지널박명함 박종류/수량별 단가 + 동판셋업비',
     '가격표260527 B09. 일반박 본체(FOIL_S1_STD)+동판셋업(5000). 면 동일가. HOLO/양면=CPQ 선결.', 'Y'),
  ('PRF_NAMECARD_CLEAR',     '투명명함 수량별 단가(용지포함)',
     '가격표260527 B05. CLEAR_S1 단독(단면만 존재). 자재 무관 동일가.', 'Y'),
  ('PRF_NAMECARD_PEARL',     '펄명함(스타드림) 면/소재/수량별 단가(용지포함)',
     '가격표260527 B04. PEARL_S1+S2 print_opt 태깅 배선. 자재 collapse(§6) 해소 후 바인딩.', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- ─────────────────────────────────────────────────────────────────────
-- ④ 배선 9행 — S1+S2 둘 다(이중합산은 print_opt 태깅이 차단). FOIL만 본체+셋업.
--    PK=(frm_cd,comp_cd). 멱등: 충돌 무시.
-- ─────────────────────────────────────────────────────────────────────
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES
  ('PRF_NAMECARD_SHAPE',     'COMP_NAMECARD_SHAPE_S1',          1, 'Y'),
  ('PRF_NAMECARD_SHAPE',     'COMP_NAMECARD_SHAPE_S2',          2, 'Y'),
  ('PRF_NAMECARD_MINISHAPE', 'COMP_NAMECARD_MINISHAPE_S1',      1, 'Y'),
  ('PRF_NAMECARD_MINISHAPE', 'COMP_NAMECARD_MINISHAPE_S2',      2, 'Y'),
  ('PRF_NAMECARD_FOIL',      'COMP_NAMECARD_FOIL_S1_STD',       1, 'Y'),
  ('PRF_NAMECARD_FOIL',      'COMP_NAMECARD_FOIL_SETUP_S1_STD', 2, 'Y'),
  ('PRF_NAMECARD_CLEAR',     'COMP_NAMECARD_CLEAR_S1',          1, 'Y'),
  ('PRF_NAMECARD_PEARL',     'COMP_NAMECARD_PEARL_S1',          1, 'Y'),
  ('PRF_NAMECARD_PEARL',     'COMP_NAMECARD_PEARL_S2',          2, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ─────────────────────────────────────────────────────────────────────
-- ⑤ 바인딩 4(GO만) — 035·036·037·039. apply_bgn_ymd=2026-06-27.
--    ★034 펄·040 화이트 = 자재 collapse 선결로 바인딩 보류(미포함).
--    PK=(prd_cd,apply_bgn_ymd). 멱등: NOT EXISTS.
-- ─────────────────────────────────────────────────────────────────────
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT v.prd_cd, v.frm_cd, '2026-06-27', v.note
FROM (VALUES
  ('PRD_000035','PRF_NAMECARD_SHAPE',     'namecard-special: 모양명함 S1+S2 print_opt 태깅 배선. siz=SIZ_000008. 단면18000/양면19000.'),
  ('PRD_000036','PRF_NAMECARD_MINISHAPE', 'namecard-special: 미니모양 S1+S2 태깅 배선. siz=SIZ_000011. 단면16000/양면17000.'),
  ('PRD_000037','PRF_NAMECARD_FOIL',      'namecard-special: 일반박 본체+동판셋업. 면 동일가·자재무관. HOLO/양면=CPQ 선결.'),
  ('PRD_000039','PRF_NAMECARD_CLEAR',     'namecard-special: 투명명함 CLEAR_S1. 단면만·자재무관. 13500.')
) AS v(prd_cd, frm_cd, note)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_price_formulas f
  WHERE f.prd_cd = v.prd_cd AND f.apply_bgn_ymd = '2026-06-27'
);

\echo '== AFTER: 바인딩(기대 4: 035·036·037·039 — 펄/화이트 보류) =='
SELECT prd_cd, frm_cd, apply_bgn_ymd
  FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000034','PRD_000035','PRD_000036','PRD_000037','PRD_000039','PRD_000040')
   AND apply_bgn_ymd='2026-06-27'
 ORDER BY prd_cd;

\echo '== AFTER: 신규 PRF 배선(기대 9행: SHAPE2·MINISHAPE2·FOIL2·CLEAR1·PEARL2) =='
SELECT frm_cd, comp_cd, disp_seq, addtn_yn
  FROM t_prc_formula_components
 WHERE frm_cd IN ('PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE','PRF_NAMECARD_FOIL',
                  'PRF_NAMECARD_CLEAR','PRF_NAMECARD_PEARL')
 ORDER BY frm_cd, disp_seq;

COMMIT;
