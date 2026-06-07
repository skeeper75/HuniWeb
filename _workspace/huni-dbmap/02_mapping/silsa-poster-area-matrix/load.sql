-- ============================================================================
-- load.sql — 실사(silsa) / 포스터사인 면적매트릭스 가격 적재 실행본 (price-211 Phase-1)
-- 생성: dbm-mapping-designer (dbm-price-formula 스킬) · 2026-06-07
-- ============================================================================
-- [성격] 멱등 INSERT … ON CONFLICT DO NOTHING. 단일 트랜잭션. FK 위상정렬.
--        본 파일은 BEGIN/COMMIT/ROLLBACK 미포함 — apply.sh 가 모드에 따라 주입.
--        (09_load/_exec/apply.sh 패턴: dryrun=ROLLBACK, commit=인간 승인 시에만)
-- [HARD] 실제 COMMIT·DDL적용·코드행등록은 인간 승인. 본 산출은 DRY-RUN 계획/SQL 까지만.
-- [USER RULE] 실사 시트 inline R/S(=SUM(R)*1.1) 단일가는 권위 아님.
--        가격 권위 = 가격표 "포스터사인" 시트의 [가로×세로] 면적매트릭스 셀단가(코팅포함가).
-- [HARD] round-2 면적-좌표 회귀(R²) 오모델링 금지 — 명시 매트릭스 셀 + ceiling(앱 런타임).
--
-- [적재 범위] 본 SQL 은 INSERTABLE 분(siz 선존재)만 적재한다.
--   - t_prc_component_prices INSERTABLE = 17행 (4개 기존 siz: 320/321/323/403).
--     이 17행은 round-2 가 이미 적재한 값과 동일 → ON CONFLICT 로 2회차 0행(멱등 no-op).
--   - 면적매트릭스 본체 670행 = siz 미등록(108 dim) → BLOCKED. 본 SQL 미포함.
--     → t_siz_sizes_BLOCKED.csv(108 siz 선적재 제안) 인간 승인 후 별도 라운드.
--   - 공식(PRF_POSTER_FIXED)·상품바인딩(13 prd_cd) = 라이브 선존재 → 신규 INSERT 불요.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [단계 0] FK 부모 선존재 검증 (read-only, 적재 아님). 위반 시 트랜잭션 abort.
-- ----------------------------------------------------------------------------
-- comp_cd 13종 + 기존 siz 4종이 부모에 있어야 함.
DO $$
DECLARE missing int;
BEGIN
  SELECT count(*) INTO missing FROM (VALUES
    ('COMP_POSTER_ARTPRINT_PHOTO'),('COMP_POSTER_ARTPAPER_MATTE'),('COMP_POSTER_WATERPROOF_PET'),
    ('COMP_POSTER_ADH_WATERPROOF_PVC'),('COMP_POSTER_ADH_CLEAR_PVC'),('COMP_POSTER_ARTFABRIC_GRAPHIC'),
    ('COMP_POSTER_LINEN_FABRIC'),('COMP_POSTER_CANVAS_FABRIC'),('COMP_POSTER_LEATHER_ARTPRINT'),
    ('COMP_POSTER_TYVEK_PRINT'),('COMP_POSTER_MESH_PRINT'),('COMP_POSTER_BANNER_NORMAL'),
    ('COMP_POSTER_BANNER_MESH')
  ) v(comp_cd)
  WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components c WHERE c.comp_cd=v.comp_cd);
  IF missing > 0 THEN RAISE EXCEPTION 'FK parent comp_cd missing: % rows', missing; END IF;

  SELECT count(*) INTO missing FROM (VALUES
    ('SIZ_000320'),('SIZ_000321'),('SIZ_000323'),('SIZ_000403')
  ) v(siz_cd)
  WHERE NOT EXISTS (SELECT 1 FROM t_siz_sizes s WHERE s.siz_cd=v.siz_cd);
  IF missing > 0 THEN RAISE EXCEPTION 'FK parent siz_cd missing: % rows', missing; END IF;
END $$;

-- ----------------------------------------------------------------------------
-- [단계 1] IDENTITY 시퀀스 stale 가드 (메모리 dbmap-digitalprint-atomic-formula-unbuilt)
--   comp_price_id = bigint IDENTITY. 명시 ID 미사용(auto). 적재 전 시퀀스를 MAX 로 재동기화.
-- ----------------------------------------------------------------------------
SELECT setval(
  pg_get_serial_sequence('t_prc_component_prices','comp_price_id'),
  (SELECT COALESCE(MAX(comp_price_id),0) FROM t_prc_component_prices),
  true
);

-- ----------------------------------------------------------------------------
-- [단계 2] t_prc_component_prices INSERTABLE 17행 (멱등)
--   8컬럼 자연키 = (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty).
--   clr/mat = NULL(면적매트릭스는 도수·자재 무관), coat_side_cnt/bdl_qty/min_qty = NULL(C-9).
--   unit_price = 코팅포함가(가격표 포스터사인 셀단가). comp_price_id = IDENTITY auto.
--   ON CONFLICT(8 자연키) DO NOTHING → 멱등. round-2 동일행 존재 시 0행 INSERT.
-- ----------------------------------------------------------------------------
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
VALUES
  ('COMP_POSTER_ARTPRINT_PHOTO',    '2026-06-01','SIZ_000321',NULL,NULL,NULL,NULL,NULL, 21600.00, '아트프린트포스터 600x1800 완제품가[코팅포함가] (포스터사인 B01)', now()),
  ('COMP_POSTER_ARTPAPER_MATTE',    '2026-06-01','SIZ_000320',NULL,NULL,NULL,NULL,NULL, 21600.00, '아트페이퍼포스터 900x1200 완제품가[코팅포함가] (포스터사인 B02)', now()),
  ('COMP_POSTER_ARTPAPER_MATTE',    '2026-06-01','SIZ_000321',NULL,NULL,NULL,NULL,NULL, 21600.00, '아트페이퍼포스터 600x1800 완제품가[코팅포함가] (포스터사인 B02)', now()),
  ('COMP_POSTER_WATERPROOF_PET',    '2026-06-01','SIZ_000321',NULL,NULL,NULL,NULL,NULL, 21600.00, '방수포스터 600x1800 완제품가[코팅포함가] (포스터사인 B03)', now()),
  ('COMP_POSTER_ADH_WATERPROOF_PVC','2026-06-01','SIZ_000321',NULL,NULL,NULL,NULL,NULL, 21600.00, '접착방수포스터 600x1800 완제품가[코팅포함가] (포스터사인 B04)', now()),
  ('COMP_POSTER_ADH_CLEAR_PVC',     '2026-06-01','SIZ_000321',NULL,NULL,NULL,NULL,NULL, 59400.00, '접착투명포스터 600x1800 완제품가[코팅포함가] (포스터사인 B05)', now()),
  ('COMP_POSTER_ARTFABRIC_GRAPHIC', '2026-06-01','SIZ_000321',NULL,NULL,NULL,NULL,NULL, 21600.00, '아트패브릭포스터 600x1800 완제품가[코팅포함가] (포스터사인 B06)', now()),
  ('COMP_POSTER_LINEN_FABRIC',      '2026-06-01','SIZ_000321',NULL,NULL,NULL,NULL,NULL, 32400.00, '린넨패브릭포스터 600x1800 완제품가[코팅포함가] (포스터사인 B07)', now()),
  ('COMP_POSTER_CANVAS_FABRIC',     '2026-06-01','SIZ_000321',NULL,NULL,NULL,NULL,NULL, 37800.00, '캔버스패브릭포스터 600x1800 완제품가[코팅포함가] (포스터사인 B08)', now()),
  ('COMP_POSTER_LEATHER_ARTPRINT',  '2026-06-01','SIZ_000321',NULL,NULL,NULL,NULL,NULL, 37800.00, '레더아트프린트 600x1800 완제품가[코팅포함가] (포스터사인 B09)', now()),
  ('COMP_POSTER_TYVEK_PRINT',       '2026-06-01','SIZ_000321',NULL,NULL,NULL,NULL,NULL, 37800.00, '타이벡프린트 600x1800 완제품가[코팅포함가] (포스터사인 B10)', now()),
  ('COMP_POSTER_MESH_PRINT',        '2026-06-01','SIZ_000321',NULL,NULL,NULL,NULL,NULL, 37800.00, '메쉬프린트 600x1800 완제품가[코팅포함가] (포스터사인 B11)', now()),
  ('COMP_POSTER_BANNER_NORMAL',     '2026-06-01','SIZ_000323',NULL,NULL,NULL,NULL,NULL,  8000.00, '일반현수막 900x900 완제품가[코팅포함가] (포스터사인 B26)', now()),
  ('COMP_POSTER_BANNER_NORMAL',     '2026-06-01','SIZ_000403',NULL,NULL,NULL,NULL,NULL, 12000.00, '일반현수막 1500x1000 완제품가[코팅포함가] (포스터사인 B26)', now()),
  ('COMP_POSTER_BANNER_NORMAL',     '2026-06-01','SIZ_000320',NULL,NULL,NULL,NULL,NULL,  8640.00, '일반현수막 900x1200 완제품가[코팅포함가] (포스터사인 B26)', now()),
  ('COMP_POSTER_BANNER_MESH',       '2026-06-01','SIZ_000323',NULL,NULL,NULL,NULL,NULL, 20000.00, '메쉬현수막 900x900 완제품가[코팅포함가] (포스터사인 B27)', now()),
  ('COMP_POSTER_BANNER_MESH',       '2026-06-01','SIZ_000320',NULL,NULL,NULL,NULL,NULL, 21600.00, '메쉬현수막 900x1200 완제품가[코팅포함가] (포스터사인 B27)', now())
ON CONFLICT (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty) DO NOTHING;

-- ----------------------------------------------------------------------------
-- [단계 3] 멱등성 자가 점검 (정보용) — INSERTABLE 17행이 라이브에 모두 존재하는지.
-- ----------------------------------------------------------------------------
\echo '--- INSERTABLE 17 자연키 라이브 존재 카운트(=17 기대, 멱등 입증) ---'
SELECT count(*) AS present_of_17
FROM t_prc_component_prices cp
WHERE cp.apply_ymd='2026-06-01'
  AND cp.clr_cd IS NULL AND cp.mat_cd IS NULL AND cp.coat_side_cnt IS NULL
  AND cp.bdl_qty IS NULL AND cp.min_qty IS NULL
  AND (cp.comp_cd, cp.siz_cd) IN (
    ('COMP_POSTER_ARTPRINT_PHOTO','SIZ_000321'),('COMP_POSTER_ARTPAPER_MATTE','SIZ_000320'),
    ('COMP_POSTER_ARTPAPER_MATTE','SIZ_000321'),('COMP_POSTER_WATERPROOF_PET','SIZ_000321'),
    ('COMP_POSTER_ADH_WATERPROOF_PVC','SIZ_000321'),('COMP_POSTER_ADH_CLEAR_PVC','SIZ_000321'),
    ('COMP_POSTER_ARTFABRIC_GRAPHIC','SIZ_000321'),('COMP_POSTER_LINEN_FABRIC','SIZ_000321'),
    ('COMP_POSTER_CANVAS_FABRIC','SIZ_000321'),('COMP_POSTER_LEATHER_ARTPRINT','SIZ_000321'),
    ('COMP_POSTER_TYVEK_PRINT','SIZ_000321'),('COMP_POSTER_MESH_PRINT','SIZ_000321'),
    ('COMP_POSTER_BANNER_NORMAL','SIZ_000323'),('COMP_POSTER_BANNER_NORMAL','SIZ_000403'),
    ('COMP_POSTER_BANNER_NORMAL','SIZ_000320'),('COMP_POSTER_BANNER_MESH','SIZ_000323'),
    ('COMP_POSTER_BANNER_MESH','SIZ_000320'));

-- ============================================================================
-- [BLOCKED — 본 SQL 미포함, 인간 승인 후 별도 라운드]
--   (a) t_siz_sizes 108행 신규 등록 (load/t_siz_sizes_BLOCKED.csv, SIZ_000511~000618 제안)
--   (b) (a) 적재 후 → t_prc_component_prices 670행 (load/t_prc_component_prices_BLOCKED.csv)
--       동일 멱등 패턴(ON CONFLICT 8 자연키). siz_cd 만 제안코드→확정코드로 치환.
--   ※ 670행이 면적매트릭스의 실데이터 본체. 17 INSERTABLE 은 기존 siz 한정 부분집합(no-op).
-- ============================================================================
