-- undo.sql — RC-2 추가물형 적재 원복 (역위상순서·멱등)
-- 적재본을 라이브에 COMMIT한 뒤 되돌릴 때만 사용. 원복도 인간 승인.
-- 역순: 공식 바인딩 삭제 → 단가행 원복(opt_cd NULL·siz_cd 복귀) → use_dims 원복 → 옵션 삭제.
-- 주의: 단가 verbatim은 적재 중 불변이므로 원복 대상 아님.
\set ON_ERROR_STOP on
BEGIN;

-- 04 역: 공식 바인딩 삭제 (이번 적재가 INSERT한 4행만)
DELETE FROM t_prc_formula_components
 WHERE (frm_cd, comp_cd) IN (
   ('PRF_POSTER_BANNER_M',        'COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4'),
   ('PRF_POSTER_BANNER_M',        'COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4'),
   ('PRF_POSTER_CANVAS_HANGING',  'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER'),
   ('PRF_POSTER_LINEN_WOODBONG',  'COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG')
 );

-- 03 역ⓑ: RC-4 siz_cd 재배선 원복 (172/174/197 → 258/315/317)
UPDATE t_prc_component_prices SET siz_cd='SIZ_000258', upd_dt=now()
 WHERE comp_price_id=4598 AND comp_cd='COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER' AND siz_cd IS DISTINCT FROM 'SIZ_000258' AND siz_cd IN ('SIZ_000172','SIZ_000258');
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315', upd_dt=now()
 WHERE comp_price_id=4599 AND comp_cd='COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER' AND siz_cd IS DISTINCT FROM 'SIZ_000315' AND siz_cd IN ('SIZ_000174','SIZ_000315');
UPDATE t_prc_component_prices SET siz_cd='SIZ_000317', upd_dt=now()
 WHERE comp_price_id=4600 AND comp_cd='COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER' AND siz_cd IS DISTINCT FROM 'SIZ_000317' AND siz_cd IN ('SIZ_000197','SIZ_000317');

-- 03 역ⓐ: opt_cd 충전 원복 (NULL 복귀 — always-add 결함 상태로 회귀)
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now() WHERE comp_price_id=4751 AND opt_cd='OPV_000425';
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now() WHERE comp_price_id=4753 AND opt_cd='OPV_000426';
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now() WHERE comp_price_id=4598 AND opt_cd='OPV_000429';
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now() WHERE comp_price_id=4599 AND opt_cd='OPV_000429';
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now() WHERE comp_price_id=4600 AND opt_cd='OPV_000429';
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now() WHERE comp_price_id=4604 AND opt_cd='OPV_000430';
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now() WHERE comp_price_id=4605 AND opt_cd='OPV_000430';
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now() WHERE comp_price_id=4606 AND opt_cd='OPV_000430';

-- 02 역: use_dims 원복 (메쉬 []·캔버스/린넨 ["siz_cd"])
UPDATE t_prc_price_components SET use_dims='[]'::jsonb, upd_dt=now()
 WHERE comp_cd='COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4' AND use_dims IS DISTINCT FROM '[]'::jsonb;
UPDATE t_prc_price_components SET use_dims='[]'::jsonb, upd_dt=now()
 WHERE comp_cd='COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4' AND use_dims IS DISTINCT FROM '[]'::jsonb;
UPDATE t_prc_price_components SET use_dims='["siz_cd"]'::jsonb, upd_dt=now()
 WHERE comp_cd='COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER' AND use_dims IS DISTINCT FROM '["siz_cd"]'::jsonb;
UPDATE t_prc_price_components SET use_dims='["siz_cd"]'::jsonb, upd_dt=now()
 WHERE comp_cd='COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG' AND use_dims IS DISTINCT FROM '["siz_cd"]'::jsonb;

-- 01 역: 신규 옵션 삭제 (이번 적재가 INSERT한 4행만)
DELETE FROM t_prd_product_options
 WHERE (prd_cd, opt_cd) IN (
   ('PRD_000139','OPV_000425'),
   ('PRD_000139','OPV_000426'),
   ('PRD_000133','OPV_000429'),
   ('PRD_000134','OPV_000430')
 );

-- 기본 ROLLBACK(undo.sh/apply.sh 패턴 주입). 실제 원복은 commit 인자 + 인간 승인만.
