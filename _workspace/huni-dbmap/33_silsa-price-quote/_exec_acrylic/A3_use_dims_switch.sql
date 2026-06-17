-- A3_use_dims_switch.sql — 본체 면적 comp use_dims(siz_cd 포함) → siz_width/siz_height (2 comp·두께 mat_cd 직교)
-- CLEAR3T: [siz_cd,mat_cd,min_qty] → [siz_width,siz_height,mat_cd] (★mat_cd 유지=3T/1.5T 두께분기·min_qty 제거: 전건 1·면적매트릭스 수량축 없음).
-- MIRROR3T: [siz_cd,mat_cd] → [siz_width,siz_height] (단가행 mat_cd 전건 NULL → mat 토큰 무사용·제거).
-- A1/A2가 데이터를 siz_width/height로 먼저 채운 뒤 전환 → 가격 공백 0.
-- 멱등: use_dims @> [siz_cd] 인 행만(이미 전환됐으면 skip) → 2-pass 0행.
UPDATE t_prc_price_components
   SET use_dims = '["siz_width", "siz_height", "mat_cd"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_ACRYL_CLEAR3T' AND use_dims @> '["siz_cd"]'::jsonb;
UPDATE t_prc_price_components
   SET use_dims = '["siz_width", "siz_height"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_ACRYL_MIRROR3T' AND use_dims @> '["siz_cd"]'::jsonb;
