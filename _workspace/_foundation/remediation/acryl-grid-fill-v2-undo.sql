-- acryl-grid-fill-v2-undo.sql — 156셀 역연산(마커)
BEGIN;
DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_ACRYL_CLEAR3T','COMP_ACRYL_MIRROR3T','COMP_ACRYL_COROTTO')
   AND note LIKE '%[260627적재보완v2]%';
COMMIT;
