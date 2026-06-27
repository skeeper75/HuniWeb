-- acryl-grid-fill-undo.sql — 보완 적재 141셀 역연산(마커 기준)
BEGIN;
DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_ACRYL_CLEAR3T','COMP_ACRYL_MIRROR3T')
   AND note LIKE '%[260627적재보완]%';
COMMIT;
