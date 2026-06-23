-- =====================================================================
-- RC-5 실사 아크릴/폼보드 단가 교정 적재본 (§21 catalog-conformance)
-- 대상: t_prc_component_prices (t_prd 상품 구성요소 단가행) — 기초코드 마스터 불변
-- UPDATE 9 + INSERT 1 = 10행. 전부 단가 verbatim(권위 silsa-l1 260610 price col24, VAT 제외 본체단가).
-- 멱등: UPDATE=핀포인트+IS DISTINCT 가드 / INSERT=NOT EXISTS 가드 + IDENTITY 채번.
-- 단일 트랜잭션. 기본 ROLLBACK(DRY-RUN). 실 COMMIT은 dbm-validator R1~R6 통과 + 인간 승인 후.
-- NEVER COMMIT in this file — 적용은 로더 --commit 플래그(인간 게이트)로만.
-- 권위 근거: rc5-acrylic-foamboard-diagnosis.md §4 (별색혼동 PASS·본체 오적재 확정)
-- 라이브 재실측(2026-06-23): comp_price_id·현재값·use_dims·prc_typ·FK·IDENTITY 전건 진단 일치(불일치 0).
-- =====================================================================

\set ON_ERROR_STOP on

BEGIN;

-- ---------------------------------------------------------------------
-- [1] 유광아크릴(PRD_000142) — COMP_POSTER_ACRYLSTK_GLOSS · UPDATE 4행
--     단가만 교정(siz_cd·차원 컬럼 불변). IS DISTINCT 가드로 멱등(현재값=권위값이면 0행).
-- ---------------------------------------------------------------------
UPDATE t_prc_component_prices SET unit_price = 12000, upd_dt = now()
 WHERE comp_price_id = 4792 AND comp_cd = 'COMP_POSTER_ACRYLSTK_GLOSS'
   AND unit_price IS DISTINCT FROM 12000;                              -- 290x90  9000 → 12000

UPDATE t_prc_component_prices SET unit_price = 18000, upd_dt = now()
 WHERE comp_price_id = 4793 AND comp_cd = 'COMP_POSTER_ACRYLSTK_GLOSS'
   AND unit_price IS DISTINCT FROM 18000;                              -- 290x190 14000 → 18000

UPDATE t_prc_component_prices SET unit_price = 28000, upd_dt = now()
 WHERE comp_price_id = 4794 AND comp_cd = 'COMP_POSTER_ACRYLSTK_GLOSS'
   AND unit_price IS DISTINCT FROM 28000;                              -- 390x290 32000 → 28000

UPDATE t_prc_component_prices SET unit_price = 47000, upd_dt = now()
 WHERE comp_price_id = 4795 AND comp_cd = 'COMP_POSTER_ACRYLSTK_GLOSS'
   AND unit_price IS DISTINCT FROM 47000;                              -- 590x390 37000 → 47000

-- ---------------------------------------------------------------------
-- [2] 미러아크릴(PRD_000143) — COMP_POSTER_ACRYLSTK_MIRROR · UPDATE 4행
-- ---------------------------------------------------------------------
UPDATE t_prc_component_prices SET unit_price = 15000, upd_dt = now()
 WHERE comp_price_id = 4796 AND comp_cd = 'COMP_POSTER_ACRYLSTK_MIRROR'
   AND unit_price IS DISTINCT FROM 15000;                              -- 290x90  11000 → 15000

UPDATE t_prc_component_prices SET unit_price = 22000, upd_dt = now()
 WHERE comp_price_id = 4797 AND comp_cd = 'COMP_POSTER_ACRYLSTK_MIRROR'
   AND unit_price IS DISTINCT FROM 22000;                              -- 290x190 18000 → 22000

UPDATE t_prc_component_prices SET unit_price = 36000, upd_dt = now()
 WHERE comp_price_id = 4798 AND comp_cd = 'COMP_POSTER_ACRYLSTK_MIRROR'
   AND unit_price IS DISTINCT FROM 36000;                              -- 390x290 29000 → 36000

UPDATE t_prc_component_prices SET unit_price = 62000, upd_dt = now()
 WHERE comp_price_id = 4799 AND comp_cd = 'COMP_POSTER_ACRYLSTK_MIRROR'
   AND unit_price IS DISTINCT FROM 62000;                              -- 590x390 50000 → 62000

-- ---------------------------------------------------------------------
-- [3] 폼보드(PRD_000129) — COMP_POSTER_FOAMBOARD_WHITE · UPDATE 1 + INSERT 1
--     A3(4780) 7000 → 6000 교정. A2(4781) 12000 = 권위 일치 → 손대지 않음.
-- ---------------------------------------------------------------------
UPDATE t_prc_component_prices SET unit_price = 6000, upd_dt = now()
 WHERE comp_price_id = 4780 AND comp_cd = 'COMP_POSTER_FOAMBOARD_WHITE'
   AND unit_price IS DISTINCT FROM 6000;                               -- A3 7000 → 6000

-- A1(594x841 = SIZ_000294) 신규 INSERT. 기존 4780/4781 행 동형 승계:
--   comp_cd / apply_ymd='2026-06-01'(verbatim 승계 — apply_ymd 분기 시 이중계상 함정 회피) /
--   siz_cd만 채우고 clr/mat/opt/proc/print_opt/plt_siz/dim_vals/coat/bdl/min/width/height = NULL.
-- comp_price_id 미지정 → IDENTITY BY DEFAULT 채번(라이브 seq last=38231·is_called=t·MAX=38231 동기, setval 불요).
-- reg_dt = DEFAULT now(). NOT EXISTS 가드로 멱등(재실행 시 0행).
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, unit_price, note)
SELECT
  'COMP_POSTER_FOAMBOARD_WHITE', '2026-06-01', 'SIZ_000294', 20000,
  '폼보드/화이트보드/A1 (594x841) 완제품가[출력+코팅+가공 포함가]'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd = 'COMP_POSTER_FOAMBOARD_WHITE' AND siz_cd = 'SIZ_000294'
);

-- 기본 ROLLBACK(DRY-RUN). 실 적용은 로더 --commit(인간 승인) 경로에서만 COMMIT.
ROLLBACK;
-- COMMIT;  -- 인간 승인 + dbm-validator R1~R6 GO 후에만 수동 활성화
