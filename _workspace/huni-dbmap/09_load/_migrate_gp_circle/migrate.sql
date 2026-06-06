-- =====================================================================
-- GP 합판도무송 원형 직경 마이그레이션 (migrate.sql)
-- 생성: gen_migrate_sql.py (입력 CSV verbatim, 손편집 금지)
-- 단일 트랜잭션. 로더(apply.sh)가 ROLLBACK 주입(기본 DRY-RUN), --commit=인간 승인.
-- 3단계: 01 siz 등록(10) → 02 GP 가격(100) → 03 066 size link(11). FK 위상순(siz 먼저).
-- 35mm(SIZ_000422)는 committed _exec_price GO 번들에 이미 적재 — 본 트랙 무간섭.
-- =====================================================================
\set ON_ERROR_STOP on
\timing on
BEGIN;

-- 가드 0: search-before-mint 불변식 — 신규 SIZ_000501~510 적재 전 라이브 부재(0)여야 정상.
--         >0 이면 이미 존재 → ON CONFLICT DO NOTHING 이 멱등 처리(중단 아님, NOTICE 만).
DO $$
DECLARE pre int;
BEGIN
  SELECT count(*) INTO pre FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000501', 'SIZ_000502', 'SIZ_000503', 'SIZ_000504', 'SIZ_000505', 'SIZ_000506', 'SIZ_000507', 'SIZ_000508', 'SIZ_000509', 'SIZ_000510');
  IF pre = 0 THEN
    RAISE NOTICE '[guard0] 신규 원형 siz(501~510) 라이브 부재(0) — search-before-mint 정상.';
  ELSE
    RAISE NOTICE '[guard0] 신규 원형 siz 중 % 종이 이미 존재 — ON CONFLICT DO NOTHING 멱등 처리.', pre;
  END IF;
END $$;

\i 01_siz_register.sql
\i 02_component_prices.sql
\i 03_product_sizes.sql

-- 적재 후 어서션 (롤백 전 검증용 — DRY-RUN/검증에서 사용)
-- 1) FK 고아(siz): 본 적재 100 GP 가격행의 siz_cd 전건 t_siz_sizes 존재 (0=PASS).
DO $$
DECLARE orphan int;
BEGIN
  SELECT count(*) INTO orphan FROM t_prc_component_prices cp
   LEFT JOIN t_siz_sizes s ON s.siz_cd = cp.siz_cd
   WHERE cp.comp_price_id IN (2956, 2957, 2958, 2959, 2960, 2961, 2962, 2963, 2964, 2965, 2968, 2969, 2970, 2971, 2972, 2973, 2974, 2975, 2976, 2977, 2978, 2979, 2980, 2981, 2982, 2983, 2984, 2985, 2986, 2987, 2990, 2991, 2992, 2993, 2994, 2995, 2996, 2997, 2998, 2999, 3000, 3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3012, 3013, 3014, 3015, 3016, 3017, 3018, 3019, 3020, 3021, 3022, 3023, 3024, 3025, 3026, 3027, 3028, 3029, 3030, 3031, 3034, 3035, 3036, 3037, 3038, 3039, 3040, 3041, 3042, 3043, 3044, 3045, 3046, 3047, 3048, 3049, 3050, 3051, 3052, 3053, 3056, 3057, 3058, 3059, 3060, 3061, 3062, 3063, 3064, 3065) AND s.siz_cd IS NULL;
  RAISE NOTICE '[assert] GP 가격 100행 FK 고아(siz 미해소, 0=PASS): %', orphan;
  IF orphan <> 0 THEN
    RAISE EXCEPTION 'GP 가격행 FK 고아 % 건 — siz 미등록. 중단.', orphan;
  END IF;
END $$;

-- 2) FK(comp_cd): COMP_GANGPAN_PRINT 가 t_prc_price_components 에 존재해야 (35mm 행이 이미 참조).
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM t_prc_price_components WHERE comp_cd = 'COMP_GANGPAN_PRINT';
  RAISE NOTICE '[assert] comp_cd COMP_GANGPAN_PRINT 라이브 존재(1=PASS): %', n;
  IF n = 0 THEN
    RAISE EXCEPTION 'comp_cd COMP_GANGPAN_PRINT 부재 — FK fk_prc_comp_prices_comp_cd 위반. 중단.';
  END IF;
END $$;

-- 3) FK(product_sizes): 066 size link 11행 siz_cd 전건 t_siz_sizes 존재 + PRD_000066 실재.
DO $$
DECLARE link_orphan int; prd_n int;
BEGIN
  SELECT count(*) INTO link_orphan FROM (
    SELECT unnest(ARRAY['SIZ_000501', 'SIZ_000502', 'SIZ_000503', 'SIZ_000504', 'SIZ_000505', 'SIZ_000422', 'SIZ_000506', 'SIZ_000507', 'SIZ_000508', 'SIZ_000509', 'SIZ_000510']) AS siz_cd) v
   LEFT JOIN t_siz_sizes s ON s.siz_cd = v.siz_cd WHERE s.siz_cd IS NULL;
  SELECT count(*) INTO prd_n FROM t_prd_products WHERE prd_cd = 'PRD_000066';
  RAISE NOTICE '[assert] 066 size link siz FK 고아(0=PASS): % / PRD_000066 존재(1=PASS): %', link_orphan, prd_n;
  IF link_orphan <> 0 THEN
    RAISE EXCEPTION '066 size link FK 고아 % 건. 중단.', link_orphan;
  END IF;
  IF prd_n = 0 THEN
    RAISE EXCEPTION 'PRD_000066 부재 — FK fk_prd_product_sizes_prd_cd 위반. 중단.';
  END IF;
END $$;

COMMIT;
