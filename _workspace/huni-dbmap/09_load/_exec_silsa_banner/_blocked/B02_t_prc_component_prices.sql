-- =====================================================================
-- step B-02 — t_prc_component_prices (BLOCKED area cells — siz 등록 후)
-- 면적매트릭스 본체 77셀(siz 미등록 의존). B01 siz 등록 후에만 FK 충족·적재 가능. 변형 C 멱등
-- 멱등: 재실행 시 0행 변경. 손편집 금지(gen_load_sql.py 생성).
-- reg_dt 명시 생략→DEFAULT now() 발화(round-5 교훈: 명시 NULL 은 DEFAULT 미발화).
-- =====================================================================
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000554', NULL, NULL, NULL, NULL, NULL, 8000.00, '일반현수막 가로1000mm×세로900mm 완제품가[코팅포함가] (포스터사인 B26 C246, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000554' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000572', NULL, NULL, NULL, NULL, NULL, 8640.00, '일반현수막 가로1200mm×세로900mm 완제품가[코팅포함가] (포스터사인 B26 D246, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000572' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000588', NULL, NULL, NULL, NULL, NULL, 10800.00, '일반현수막 가로1500mm×세로900mm 완제품가[코팅포함가] (포스터사인 B26 E246, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000588' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000603', NULL, NULL, NULL, NULL, NULL, 12960.00, '일반현수막 가로1750mm×세로900mm 완제품가[코팅포함가] (포스터사인 B26 F246, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000603' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000538', NULL, NULL, NULL, NULL, NULL, 8000.00, '일반현수막 가로900mm×세로1000mm 완제품가[코팅포함가] (포스터사인 B26 B247, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000538' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000555', NULL, NULL, NULL, NULL, NULL, 8000.00, '일반현수막 가로1000mm×세로1000mm 완제품가[코팅포함가] (포스터사인 B26 C247, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000555' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000573', NULL, NULL, NULL, NULL, NULL, 9600.00, '일반현수막 가로1200mm×세로1000mm 완제품가[코팅포함가] (포스터사인 B26 D247, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000573' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000604', NULL, NULL, NULL, NULL, NULL, 14400.00, '일반현수막 가로1750mm×세로1000mm 완제품가[코팅포함가] (포스터사인 B26 F247, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000604' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000556', NULL, NULL, NULL, NULL, NULL, 9600.00, '일반현수막 가로1000mm×세로1200mm 완제품가[코팅포함가] (포스터사인 B26 C248, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000556' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000574', NULL, NULL, NULL, NULL, NULL, 11520.00, '일반현수막 가로1200mm×세로1200mm 완제품가[코팅포함가] (포스터사인 B26 D248, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000574' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000589', NULL, NULL, NULL, NULL, NULL, 14400.00, '일반현수막 가로1500mm×세로1200mm 완제품가[코팅포함가] (포스터사인 B26 E248, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000589' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000605', NULL, NULL, NULL, NULL, NULL, 17280.00, '일반현수막 가로1750mm×세로1200mm 완제품가[코팅포함가] (포스터사인 B26 F248, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000605' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000539', NULL, NULL, NULL, NULL, NULL, 10080.00, '일반현수막 가로900mm×세로1400mm 완제품가[코팅포함가] (포스터사인 B26 B249, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000539' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000557', NULL, NULL, NULL, NULL, NULL, 11200.00, '일반현수막 가로1000mm×세로1400mm 완제품가[코팅포함가] (포스터사인 B26 C249, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000557' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000575', NULL, NULL, NULL, NULL, NULL, 13440.00, '일반현수막 가로1200mm×세로1400mm 완제품가[코팅포함가] (포스터사인 B26 D249, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000575' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000590', NULL, NULL, NULL, NULL, NULL, 16800.00, '일반현수막 가로1500mm×세로1400mm 완제품가[코팅포함가] (포스터사인 B26 E249, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000590' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000606', NULL, NULL, NULL, NULL, NULL, 20160.00, '일반현수막 가로1750mm×세로1400mm 완제품가[코팅포함가] (포스터사인 B26 F249, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000606' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000540', NULL, NULL, NULL, NULL, NULL, 11520.00, '일반현수막 가로900mm×세로1600mm 완제품가[코팅포함가] (포스터사인 B26 B250, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000540' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000558', NULL, NULL, NULL, NULL, NULL, 12800.00, '일반현수막 가로1000mm×세로1600mm 완제품가[코팅포함가] (포스터사인 B26 C250, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000558' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000576', NULL, NULL, NULL, NULL, NULL, 15360.00, '일반현수막 가로1200mm×세로1600mm 완제품가[코팅포함가] (포스터사인 B26 D250, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000576' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000591', NULL, NULL, NULL, NULL, NULL, 19200.00, '일반현수막 가로1500mm×세로1600mm 완제품가[코팅포함가] (포스터사인 B26 E250, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000591' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000607', NULL, NULL, NULL, NULL, NULL, 23040.00, '일반현수막 가로1750mm×세로1600mm 완제품가[코팅포함가] (포스터사인 B26 F250, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000607' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000541', NULL, NULL, NULL, NULL, NULL, 12960.00, '일반현수막 가로900mm×세로1800mm 완제품가[코팅포함가] (포스터사인 B26 B251, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000541' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000559', NULL, NULL, NULL, NULL, NULL, 14400.00, '일반현수막 가로1000mm×세로1800mm 완제품가[코팅포함가] (포스터사인 B26 C251, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000559' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000577', NULL, NULL, NULL, NULL, NULL, 17280.00, '일반현수막 가로1200mm×세로1800mm 완제품가[코팅포함가] (포스터사인 B26 D251, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000577' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000592', NULL, NULL, NULL, NULL, NULL, 21600.00, '일반현수막 가로1500mm×세로1800mm 완제품가[코팅포함가] (포스터사인 B26 E251, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000592' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000608', NULL, NULL, NULL, NULL, NULL, 25920.00, '일반현수막 가로1750mm×세로1800mm 완제품가[코팅포함가] (포스터사인 B26 F251, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000608' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000542', NULL, NULL, NULL, NULL, NULL, 14400.00, '일반현수막 가로900mm×세로2000mm 완제품가[코팅포함가] (포스터사인 B26 B252, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000542' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000560', NULL, NULL, NULL, NULL, NULL, 16000.00, '일반현수막 가로1000mm×세로2000mm 완제품가[코팅포함가] (포스터사인 B26 C252, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000560' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000578', NULL, NULL, NULL, NULL, NULL, 19200.00, '일반현수막 가로1200mm×세로2000mm 완제품가[코팅포함가] (포스터사인 B26 D252, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000578' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000593', NULL, NULL, NULL, NULL, NULL, 24000.00, '일반현수막 가로1500mm×세로2000mm 완제품가[코팅포함가] (포스터사인 B26 E252, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000593' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000609', NULL, NULL, NULL, NULL, NULL, 28800.00, '일반현수막 가로1750mm×세로2000mm 완제품가[코팅포함가] (포스터사인 B26 F252, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000609' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000543', NULL, NULL, NULL, NULL, NULL, 15840.00, '일반현수막 가로900mm×세로2200mm 완제품가[코팅포함가] (포스터사인 B26 B253, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000543' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000561', NULL, NULL, NULL, NULL, NULL, 17600.00, '일반현수막 가로1000mm×세로2200mm 완제품가[코팅포함가] (포스터사인 B26 C253, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000561' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000579', NULL, NULL, NULL, NULL, NULL, 21120.00, '일반현수막 가로1200mm×세로2200mm 완제품가[코팅포함가] (포스터사인 B26 D253, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000579' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000594', NULL, NULL, NULL, NULL, NULL, 26400.00, '일반현수막 가로1500mm×세로2200mm 완제품가[코팅포함가] (포스터사인 B26 E253, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000594' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000610', NULL, NULL, NULL, NULL, NULL, 31680.00, '일반현수막 가로1750mm×세로2200mm 완제품가[코팅포함가] (포스터사인 B26 F253, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000610' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000544', NULL, NULL, NULL, NULL, NULL, 17280.00, '일반현수막 가로900mm×세로2400mm 완제품가[코팅포함가] (포스터사인 B26 B254, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000544' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000562', NULL, NULL, NULL, NULL, NULL, 19200.00, '일반현수막 가로1000mm×세로2400mm 완제품가[코팅포함가] (포스터사인 B26 C254, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000562' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000580', NULL, NULL, NULL, NULL, NULL, 23040.00, '일반현수막 가로1200mm×세로2400mm 완제품가[코팅포함가] (포스터사인 B26 D254, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000580' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000595', NULL, NULL, NULL, NULL, NULL, 28800.00, '일반현수막 가로1500mm×세로2400mm 완제품가[코팅포함가] (포스터사인 B26 E254, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000595' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000611', NULL, NULL, NULL, NULL, NULL, 34560.00, '일반현수막 가로1750mm×세로2400mm 완제품가[코팅포함가] (포스터사인 B26 F254, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000611' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000545', NULL, NULL, NULL, NULL, NULL, 18720.00, '일반현수막 가로900mm×세로2600mm 완제품가[코팅포함가] (포스터사인 B26 B255, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000545' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000563', NULL, NULL, NULL, NULL, NULL, 20800.00, '일반현수막 가로1000mm×세로2600mm 완제품가[코팅포함가] (포스터사인 B26 C255, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000563' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000581', NULL, NULL, NULL, NULL, NULL, 24960.00, '일반현수막 가로1200mm×세로2600mm 완제품가[코팅포함가] (포스터사인 B26 D255, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000581' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000596', NULL, NULL, NULL, NULL, NULL, 31200.00, '일반현수막 가로1500mm×세로2600mm 완제품가[코팅포함가] (포스터사인 B26 E255, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000596' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000612', NULL, NULL, NULL, NULL, NULL, 37440.00, '일반현수막 가로1750mm×세로2600mm 완제품가[코팅포함가] (포스터사인 B26 F255, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000612' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000546', NULL, NULL, NULL, NULL, NULL, 20160.00, '일반현수막 가로900mm×세로2800mm 완제품가[코팅포함가] (포스터사인 B26 B256, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000546' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000564', NULL, NULL, NULL, NULL, NULL, 22400.00, '일반현수막 가로1000mm×세로2800mm 완제품가[코팅포함가] (포스터사인 B26 C256, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000564' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000582', NULL, NULL, NULL, NULL, NULL, 26880.00, '일반현수막 가로1200mm×세로2800mm 완제품가[코팅포함가] (포스터사인 B26 D256, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000582' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000597', NULL, NULL, NULL, NULL, NULL, 33600.00, '일반현수막 가로1500mm×세로2800mm 완제품가[코팅포함가] (포스터사인 B26 E256, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000597' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000613', NULL, NULL, NULL, NULL, NULL, 40320.00, '일반현수막 가로1750mm×세로2800mm 완제품가[코팅포함가] (포스터사인 B26 F256, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000613' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000547', NULL, NULL, NULL, NULL, NULL, 21600.00, '일반현수막 가로900mm×세로3000mm 완제품가[코팅포함가] (포스터사인 B26 B257, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000547' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000565', NULL, NULL, NULL, NULL, NULL, 24000.00, '일반현수막 가로1000mm×세로3000mm 완제품가[코팅포함가] (포스터사인 B26 C257, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000565' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000583', NULL, NULL, NULL, NULL, NULL, 28800.00, '일반현수막 가로1200mm×세로3000mm 완제품가[코팅포함가] (포스터사인 B26 D257, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000583' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000598', NULL, NULL, NULL, NULL, NULL, 36000.00, '일반현수막 가로1500mm×세로3000mm 완제품가[코팅포함가] (포스터사인 B26 E257, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000598' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000614', NULL, NULL, NULL, NULL, NULL, 43200.00, '일반현수막 가로1750mm×세로3000mm 완제품가[코팅포함가] (포스터사인 B26 F257, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000614' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000548', NULL, NULL, NULL, NULL, NULL, 25200.00, '일반현수막 가로900mm×세로3500mm 완제품가[코팅포함가] (포스터사인 B26 B258, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000548' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000566', NULL, NULL, NULL, NULL, NULL, 28000.00, '일반현수막 가로1000mm×세로3500mm 완제품가[코팅포함가] (포스터사인 B26 C258, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000566' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000584', NULL, NULL, NULL, NULL, NULL, 33600.00, '일반현수막 가로1200mm×세로3500mm 완제품가[코팅포함가] (포스터사인 B26 D258, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000584' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000599', NULL, NULL, NULL, NULL, NULL, 42000.00, '일반현수막 가로1500mm×세로3500mm 완제품가[코팅포함가] (포스터사인 B26 E258, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000599' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000615', NULL, NULL, NULL, NULL, NULL, 50400.00, '일반현수막 가로1750mm×세로3500mm 완제품가[코팅포함가] (포스터사인 B26 F258, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000615' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000549', NULL, NULL, NULL, NULL, NULL, 28800.00, '일반현수막 가로900mm×세로4000mm 완제품가[코팅포함가] (포스터사인 B26 B259, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000549' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000567', NULL, NULL, NULL, NULL, NULL, 32000.00, '일반현수막 가로1000mm×세로4000mm 완제품가[코팅포함가] (포스터사인 B26 C259, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000567' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000585', NULL, NULL, NULL, NULL, NULL, 38400.00, '일반현수막 가로1200mm×세로4000mm 완제품가[코팅포함가] (포스터사인 B26 D259, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000585' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000600', NULL, NULL, NULL, NULL, NULL, 48000.00, '일반현수막 가로1500mm×세로4000mm 완제품가[코팅포함가] (포스터사인 B26 E259, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000600' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000616', NULL, NULL, NULL, NULL, NULL, 57600.00, '일반현수막 가로1750mm×세로4000mm 완제품가[코팅포함가] (포스터사인 B26 F259, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000616' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000550', NULL, NULL, NULL, NULL, NULL, 32400.00, '일반현수막 가로900mm×세로4500mm 완제품가[코팅포함가] (포스터사인 B26 B260, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000550' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000568', NULL, NULL, NULL, NULL, NULL, 36000.00, '일반현수막 가로1000mm×세로4500mm 완제품가[코팅포함가] (포스터사인 B26 C260, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000568' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000586', NULL, NULL, NULL, NULL, NULL, 43200.00, '일반현수막 가로1200mm×세로4500mm 완제품가[코팅포함가] (포스터사인 B26 D260, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000586' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000601', NULL, NULL, NULL, NULL, NULL, 54000.00, '일반현수막 가로1500mm×세로4500mm 완제품가[코팅포함가] (포스터사인 B26 E260, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000601' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000617', NULL, NULL, NULL, NULL, NULL, 64800.00, '일반현수막 가로1750mm×세로4500mm 완제품가[코팅포함가] (포스터사인 B26 F260, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000617' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000551', NULL, NULL, NULL, NULL, NULL, 36000.00, '일반현수막 가로900mm×세로5000mm 완제품가[코팅포함가] (포스터사인 B26 B261, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000551' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000569', NULL, NULL, NULL, NULL, NULL, 40000.00, '일반현수막 가로1000mm×세로5000mm 완제품가[코팅포함가] (포스터사인 B26 C261, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000569' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000587', NULL, NULL, NULL, NULL, NULL, 48000.00, '일반현수막 가로1200mm×세로5000mm 완제품가[코팅포함가] (포스터사인 B26 D261, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000587' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000602', NULL, NULL, NULL, NULL, NULL, 60000.00, '일반현수막 가로1500mm×세로5000mm 완제품가[코팅포함가] (포스터사인 B26 E261, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000602' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000618', NULL, NULL, NULL, NULL, NULL, 72000.00, '일반현수막 가로1750mm×세로5000mm 완제품가[코팅포함가] (포스터사인 B26 F261, 면적매트릭스, 완제품비.06)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x
  WHERE x.comp_cd='COMP_POSTER_BANNER_NORMAL' AND x.apply_ymd='2026-06-01'
    AND x.siz_cd IS NOT DISTINCT FROM 'SIZ_000618' AND x.clr_cd IS NOT DISTINCT FROM NULL
    AND x.mat_cd IS NOT DISTINCT FROM NULL AND x.coat_side_cnt IS NOT DISTINCT FROM NULL
    AND x.bdl_qty IS NOT DISTINCT FROM NULL AND x.min_qty IS NOT DISTINCT FROM NULL);
