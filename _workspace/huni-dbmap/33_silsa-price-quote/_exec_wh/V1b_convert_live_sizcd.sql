-- V1b_convert_live_sizcd.sql — 기존 라이브 siz_cd 매트릭스 단가행 17건 → siz_width/siz_height 전환(in-place·값 불변)
-- 근거: 13 매트릭스 comp의 라이브 siz_cd 행 17건(600x1800·900x900·900x1200·1500x1000)은 GAP 667과 비충돌(검증).
--   V2가 use_dims를 siz_width/height로 전환하면 이 siz_cd 행은 미매칭됨 → 값 손실 방지 위해 좌표(work_width/height) 기준 전환.
-- 좌표 = t_siz_sizes.work_width/work_height(라이브 권위). siz_cd→NULL, siz_width/height 세팅. unit_price 불변.
-- 멱등: siz_cd IS NOT NULL 인 매트릭스 행만 대상 → 2-pass 시 0행.
UPDATE t_prc_component_prices cp
   SET siz_width = s.work_width, siz_height = s.work_height, siz_cd = NULL, upd_dt = now()
  FROM t_siz_sizes s
 WHERE cp.siz_cd = s.siz_cd
   AND cp.siz_cd IS NOT NULL AND cp.siz_width IS NULL
   AND cp.comp_cd IN (
     'COMP_POSTER_ADH_CLEAR_PVC',
     'COMP_POSTER_ADH_WATERPROOF_PVC',
     'COMP_POSTER_ARTFABRIC_GRAPHIC',
     'COMP_POSTER_ARTPAPER_MATTE',
     'COMP_POSTER_ARTPRINT_PHOTO',
     'COMP_POSTER_BANNER_MESH',
     'COMP_POSTER_BANNER_NORMAL',
     'COMP_POSTER_CANVAS_FABRIC',
     'COMP_POSTER_LEATHER_ARTPRINT',
     'COMP_POSTER_LINEN_FABRIC',
     'COMP_POSTER_MESH_PRINT',
     'COMP_POSTER_TYVEK_PRINT',
     'COMP_POSTER_WATERPROOF_PET'
   );
