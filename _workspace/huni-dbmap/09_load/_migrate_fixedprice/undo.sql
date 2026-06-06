-- =====================================================================
-- 고정가형 정정 마이그레이션 역실행 (undo.sql)
-- backup.sql이 생성한 backup_prf_poster_bindings.csv 의 PRF_POSTER_FIXED 바인딩을 복원하고
-- 본 마이그레이션이 추가한 고정가형 엔티티를 제거한다. 단일 트랜잭션.
-- 기본 ROLLBACK(undo.sh DRY-RUN). --commit=인간 승인.
-- 주의: STEP 3 DELETE는 선행 broken-partial 행도 함께 지웠으므로 undo는 73행을 제거하되
--       broken-partial 55행은 복원하지 않는다(그것이 정정의 목적). 필요 시 backup CSV 참조.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;

-- 1) 추가한 고정가형 바인딩 제거
DELETE FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000129', 'PRD_000130', 'PRD_000131', 'PRD_000132', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000140', 'PRD_000141', 'PRD_000142', 'PRD_000143', 'PRD_000144', 'PRD_000145') AND frm_cd IN ('PRF_FOAMBOARD_FIXED', 'PRF_FOMEXBOARD_FIXED', 'PRF_FRAMELESS_WOOD_FIXED', 'PRF_LEATHER_FRAME_FIXED', 'PRF_CANVAS_HANGING_FIXED', 'PRF_LINEN_WOODBONG_FIXED', 'PRF_JOKJA_FIXED', 'PRF_PET_BANNER_FIXED', 'PRF_MESH_BANNER_FIXED', 'PRF_SHEETCUT_MATTE_FIXED', 'PRF_SHEETCUT_HOLO_FIXED', 'PRF_ACRYLSTK_GLOSS_FIXED', 'PRF_ACRYLSTK_MIRROR_FIXED', 'PRF_MINI_STANDBOARD_FIXED', 'PRF_MINI_BANNER_FIXED');

-- 2) 백업된 PRF_POSTER_FIXED 바인딩 재삽입 (15행)
--    \copy 로 backup CSV 로드하거나, 아래 명시 INSERT 사용(백업 시점 값).
\set bkp `cat /Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap/09_load/_migrate_fixedprice/backup_prf_poster_bindings.csv 2>/dev/null | tail -n +2`
-- 명시 복원 (apply_bgn_ymd/note는 백업본 CSV가 권위; 아래는 기본 재바인딩)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000129', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000130', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000131', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000132', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000133', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000134', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000135', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000136', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000137', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000140', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000141', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000142', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000143', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000144', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('PRD_000145', 'PRF_POSTER_FIXED', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- 3) component_prices: 마이그레이션이 INSERT한 73행 제거
DELETE FROM t_prc_component_prices WHERE comp_cd IN ('COMP_FOAMBOARD_BLACK', 'COMP_FOAMBOARD_WHITE', 'COMP_FOMEXBOARD_BLACK', 'COMP_FOMEXBOARD_WHITE', 'COMP_POSTER_ACRYLSTK_GLOSS', 'COMP_POSTER_ACRYLSTK_MIRROR', 'COMP_POSTER_CANVAS_HANGING', 'COMP_POSTER_FRAMELESS_WOOD', 'COMP_POSTER_JOKJA', 'COMP_POSTER_LEATHER_FRAME', 'COMP_POSTER_LINEN_WOODBONG', 'COMP_POSTER_MESH_BANNER', 'COMP_POSTER_MINI_BANNER', 'COMP_POSTER_MINI_STANDBOARD', 'COMP_POSTER_PET_BANNER', 'COMP_POSTER_SHEETCUT_HOLO', 'COMP_POSTER_SHEETCUT_MATTE') AND apply_ymd='2026-06-01';

-- 4) formula_components 와이어링 제거
DELETE FROM t_prc_formula_components WHERE frm_cd IN ('PRF_FOAMBOARD_FIXED', 'PRF_FOMEXBOARD_FIXED', 'PRF_FRAMELESS_WOOD_FIXED', 'PRF_LEATHER_FRAME_FIXED', 'PRF_CANVAS_HANGING_FIXED', 'PRF_LINEN_WOODBONG_FIXED', 'PRF_JOKJA_FIXED', 'PRF_PET_BANNER_FIXED', 'PRF_MESH_BANNER_FIXED', 'PRF_SHEETCUT_MATTE_FIXED', 'PRF_SHEETCUT_HOLO_FIXED', 'PRF_ACRYLSTK_GLOSS_FIXED', 'PRF_ACRYLSTK_MIRROR_FIXED', 'PRF_MINI_STANDBOARD_FIXED', 'PRF_MINI_BANNER_FIXED');

-- 5) 신규 component (4종 FOAM/FOMEX) 제거 — 라이브 기존 13종은 보존
DELETE FROM t_prc_price_components WHERE comp_cd IN ('COMP_FOAMBOARD_WHITE','COMP_FOAMBOARD_BLACK','COMP_FOMEXBOARD_WHITE','COMP_FOMEXBOARD_BLACK');

-- 6) 신규 고정가형 공식 제거
DELETE FROM t_prc_price_formulas WHERE frm_cd IN ('PRF_FOAMBOARD_FIXED', 'PRF_FOMEXBOARD_FIXED', 'PRF_FRAMELESS_WOOD_FIXED', 'PRF_LEATHER_FRAME_FIXED', 'PRF_CANVAS_HANGING_FIXED', 'PRF_LINEN_WOODBONG_FIXED', 'PRF_JOKJA_FIXED', 'PRF_PET_BANNER_FIXED', 'PRF_MESH_BANNER_FIXED', 'PRF_SHEETCUT_MATTE_FIXED', 'PRF_SHEETCUT_HOLO_FIXED', 'PRF_ACRYLSTK_GLOSS_FIXED', 'PRF_ACRYLSTK_MIRROR_FIXED', 'PRF_MINI_STANDBOARD_FIXED', 'PRF_MINI_BANNER_FIXED');

-- 복원 가드: 15상품이 PRF_POSTER_FIXED로 돌아왔는지 확인
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000129', 'PRD_000130', 'PRD_000131', 'PRD_000132', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000140', 'PRD_000141', 'PRD_000142', 'PRD_000143', 'PRD_000144', 'PRD_000145') AND frm_cd='PRF_POSTER_FIXED';
  IF n <> 15 THEN RAISE EXCEPTION 'undo 가드 실패: PRF_POSTER_FIXED 복원 % (기대 15).', n; END IF;
END $$;

COMMIT;
