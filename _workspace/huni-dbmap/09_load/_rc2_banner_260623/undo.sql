-- undo.sql — RC-2 일반현수막 COMMIT 역연산 (2026-06-23 적재 복원용)
-- 사용: psql … -f undo.sql -c "COMMIT;"  (인간 승인 후에만)
-- backup-20260623_0946.sql 스냅샷과 동일 — 적재 전 라이브 baseline으로 환원.
\set ON_ERROR_STOP on
BEGIN;

-- ① use_dims 환원 (적재 전 현재값: 빈 [] / QBANG=018 오설정)
UPDATE t_prc_price_components SET use_dims = '["opt_cd", "min_qty", "opt_grp:OPT_000018"]'::jsonb, upd_dt = now() WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4';
UPDATE t_prc_price_components SET use_dims = '[]'::jsonb, upd_dt = now() WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4';
UPDATE t_prc_price_components SET use_dims = '[]'::jsonb, upd_dt = now() WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW';
UPDATE t_prc_price_components SET use_dims = '[]'::jsonb, upd_dt = now() WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE';
UPDATE t_prc_price_components SET use_dims = '[]'::jsonb, upd_dt = now() WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE';

-- ② 단가행 opt_cd 환원 (NULL·단가 불변)
UPDATE t_prc_component_prices SET opt_cd = NULL, upd_dt = now() WHERE comp_price_id = 4692;
UPDATE t_prc_component_prices SET opt_cd = NULL, upd_dt = now() WHERE comp_price_id = 4694;
UPDATE t_prc_component_prices SET opt_cd = NULL, upd_dt = now() WHERE comp_price_id = 4696;
UPDATE t_prc_component_prices SET opt_cd = NULL, upd_dt = now() WHERE comp_price_id = 4699;
UPDATE t_prc_component_prices SET opt_cd = NULL, upd_dt = now() WHERE comp_price_id = 4701;

-- ③ 공식 바인딩 환원: 신규 5행 DELETE + PUNCH_4 기존행 addtn_yn/disp_seq NULL 복원
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_BANNER_N' AND comp_cd IN ('COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE','COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE','COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW','COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4','COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4');
UPDATE t_prc_formula_components SET addtn_yn = NULL, disp_seq = NULL, upd_dt = now() WHERE frm_cd='PRF_POSTER_BANNER_N' AND comp_cd='COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4';

-- 기본 ROLLBACK(안전). 실제 복원은 -c "COMMIT;" 인간 승인만.
