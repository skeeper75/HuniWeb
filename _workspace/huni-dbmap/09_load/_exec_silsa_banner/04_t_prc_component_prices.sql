-- =====================================================================
-- step 04 — t_prc_component_prices
-- INSERTABLE 13(면적 siz선존재 3 + 옵션 flat 10). 자연키 UNIQUE=NULLS DISTINCT → 변형 C(WHERE NOT EXISTS)+setval
-- 멱등: 재실행 시 0행 변경. 손편집 금지(gen_load_sql.py 생성).
-- reg_dt 명시 생략→DEFAULT now() 발화(round-5 교훈: 명시 NULL 은 DEFAULT 미발화).
-- =====================================================================
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000323', NULL, NULL, NULL, NULL, NULL, 8000.00, '일반현수막 가로900mm×세로900mm 완제품가[코팅포함가] (포스터사인 B26 B246, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000323' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000403', NULL, NULL, NULL, NULL, NULL, 12000.00, '일반현수막 가로1500mm×세로1000mm 완제품가[코팅포함가] (포스터사인 B26 E247, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000403' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000320', NULL, NULL, NULL, NULL, NULL, 8640.00, '일반현수막 가로900mm×세로1200mm 완제품가[코팅포함가] (포스터사인 B26 B248, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000320' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_BANNER_FIN_HEATCUT', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 3000.00, '열재단 추가가격 flat (B26 K246)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_BANNER_FIN_HEATCUT' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM NULL AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_BANNER_FIN_EYELET4', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 3000.00, '타공(4개) 추가가격 flat (B26 K247)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_BANNER_FIN_EYELET4' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM NULL AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_BANNER_FIN_EYELET6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 4000.00, '타공(6개) 추가가격 flat (B26 K248)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_BANNER_FIN_EYELET6' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM NULL AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_BANNER_FIN_EYELET8', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 5000.00, '타공(8개) 추가가격 flat (B26 K249)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_BANNER_FIN_EYELET8' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM NULL AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_BANNER_FIN_DTAPE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 3000.00, '양면테입 추가가격 flat (B26 K250)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_BANNER_FIN_DTAPE' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM NULL AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_BANNER_FIN_SEW', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 4000.00, '봉미싱 추가가격 flat (B26 K251)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_BANNER_FIN_SEW' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM NULL AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_BANNER_ADD_QBANG4', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 3000.00, '큐방(4개) 추가가격 flat (B26 N247)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_BANNER_ADD_QBANG4' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM NULL AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_BANNER_ADD_STRING4', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 4000.00, '끈(4개) 추가가격 flat (B26 N248)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_BANNER_ADD_STRING4' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM NULL AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_BANNER_ADD_LUMBER_LE900', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 4000.00, '각목(세로변 900mm이하)+끈 추가가격 flat (B26 N249·U-3 세로변 기준)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_BANNER_ADD_LUMBER_LE900' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM NULL AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_BANNER_ADD_LUMBER_GT900', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 8000.00, '각목(세로변 900mm초과)+끈 추가가격 flat (B26 N250·U-3 세로변 기준)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_BANNER_ADD_LUMBER_GT900' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM NULL AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);

-- IDENTITY 시퀀스 재동기화(메모리 lesson: comp_price_id IDENTITY stale 가드).
-- 본 트랙은 comp_price_id 를 명시하지 않으므로 IDENTITY 자동 발번 — stale 충돌 없음.
-- 적재 후 MAX 와 시퀀스 동기화(다음 발번 안전, 멱등).
SELECT setval(pg_get_serial_sequence('t_prc_component_prices','comp_price_id'),
              GREATEST((SELECT COALESCE(MAX(comp_price_id),1) FROM t_prc_component_prices),1), true);
