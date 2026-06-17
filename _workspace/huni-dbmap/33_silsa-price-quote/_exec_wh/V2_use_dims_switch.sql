-- V2_use_dims_switch.sql — 본체 면적 comp use_dims(siz_cd 포함) → ["siz_width","siz_height"] (13 comp)
-- G-D2 W1~W6 공식분리·후가공 배선 무손상(후가공은 proc_cd/dim_vals 차원·사이즈 무관).
-- ★WATERPROOF_PET은 use_dims=["siz_cd","min_qty"](잉여 min_qty·실제 행에 min_qty 없음=structure.md B03 면적매트릭스).
--   → siz_cd 토큰 포함 행 전건 전환(@> 매칭)으로 13 comp 전부 통일.
-- 멱등: use_dims에 siz_cd 토큰 남은 행만 전환(이미 siz_width/height면 skip) → 2-pass 0행.
UPDATE t_prc_price_components
   SET use_dims = '["siz_width", "siz_height"]'::jsonb, upd_dt = now()
 WHERE comp_cd IN (
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
   )
   AND use_dims @> '["siz_cd"]'::jsonb;  -- siz_cd 토큰 포함 행(WATERPROOF_PET의 잉여 min_qty 포함분도) 전환
