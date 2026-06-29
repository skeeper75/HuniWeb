-- T1 포스터사인/실사 면적격자 transpose 교정 — 물리 백업 (read-only 시점 스냅샷)
-- 대상 = 13 comp 포스터사인 면적격자 전 행(siz_width 비NULL 격자행 684 + 격자 외 일부 포함 전체 comp 행)
-- 백업 테이블명: bak_t_prc_component_prices_postersign_dedup_<YYYYMMDD_HHMM>
-- ★COMMIT 전 단독 실행. 백업 행수 기록.

-- 백업 테이블 생성 (영향 13 comp 전 행 복제)
CREATE TABLE IF NOT EXISTS bak_t_prc_component_prices_postersign_dedup_20260629_1934 AS
SELECT * FROM t_prc_component_prices
WHERE comp_cd IN (
    'COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_WATERPROOF_PET',
    'COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC',
    'COMP_POSTER_LINEN_FABRIC','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_LEATHER_ARTPRINT',
    'COMP_POSTER_TYVEK_PRINT','COMP_POSTER_MESH_PRINT','COMP_POSTER_BANNER_NORMAL','COMP_POSTER_BANNER_MESH');

-- 백업 행수 확인
SELECT 'BACKUP rows' AS chk, count(*) FROM bak_t_prc_component_prices_postersign_dedup_20260629_1934;
