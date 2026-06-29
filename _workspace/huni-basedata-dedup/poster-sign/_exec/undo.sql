-- T1 transpose 교정 UNDO (역연산·백업 복원)
-- 백업 테이블 bak_t_prc_component_prices_postersign_dedup_20260629_1934 에서 13 comp 행 복원.
-- ★사후 시뮬 불일치/14셀 회귀/제약위반 발견 시 즉시 실행.

BEGIN;

-- 1) 신규 INSERT 4행 제거 (백업엔 없던 신규: banner 900x5000 2 + banner 1200x900 2)
DELETE FROM t_prc_component_prices WHERE comp_price_id IN (40384,40385,40386,40387);

-- 2) swap 교정된 491행 + 무변경 193행 = 13 comp 전 격자행을 백업값으로 원복
--    (siz_width/siz_height/unit_price를 백업 시점값으로 UPDATE)
UPDATE t_prc_component_prices t
SET siz_width = b.siz_width, siz_height = b.siz_height, unit_price = b.unit_price
FROM bak_t_prc_component_prices_postersign_dedup_20260629_1934 b
WHERE t.comp_price_id = b.comp_price_id;

-- 검증: width>1200 행수가 백업(=376)으로 돌아왔나
SELECT 'UNDO width>1200 (=376 복원확인)' AS chk, count(*)
FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_WATERPROOF_PET',
  'COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC',
  'COMP_POSTER_LINEN_FABRIC','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_LEATHER_ARTPRINT',
  'COMP_POSTER_TYVEK_PRINT','COMP_POSTER_MESH_PRINT') AND siz_width>1200;

COMMIT;  -- ★복원 확정. (검증 후 COMMIT, 문제 시 ROLLBACK으로 교체)
