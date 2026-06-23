-- backup.sql — RC-2 적재 전 라이브 현재값 스냅샷 (롤백용·2026-06-23 실측)
-- 적재 후 문제 시 이 값으로 복원. 단가행 단가는 미변경이므로 use_dims/opt_cd/바인딩만.

-- price_components.use_dims 현재값
UPDATE t_prc_price_components SET use_dims = '["opt_cd", "min_qty", "opt_grp:OPT_000018"]'::jsonb WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4';
UPDATE t_prc_price_components SET use_dims = '[]'::jsonb WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4';
UPDATE t_prc_price_components SET use_dims = '[]'::jsonb WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW';
UPDATE t_prc_price_components SET use_dims = '[]'::jsonb WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE';
UPDATE t_prc_price_components SET use_dims = '[]'::jsonb WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE';

-- component_prices.opt_cd 현재값 (단가 불변)
UPDATE t_prc_component_prices SET opt_cd = NULL WHERE comp_price_id = 4692;
UPDATE t_prc_component_prices SET opt_cd = NULL WHERE comp_price_id = 4694;
UPDATE t_prc_component_prices SET opt_cd = NULL WHERE comp_price_id = 4696;
UPDATE t_prc_component_prices SET opt_cd = NULL WHERE comp_price_id = 4699;
UPDATE t_prc_component_prices SET opt_cd = NULL WHERE comp_price_id = 4701;

-- formula_components 현재 바인딩 (신규행은 적재후 DELETE 필요)
-- 기존: frm=PRF_POSTER_BANNER_N comp=COMP_POSTER_BANNER_NORMAL addtn='Y' seq=1
-- 기존: frm=PRF_POSTER_BANNER_N comp=COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4 addtn=NULL seq=NULL
-- 적재로 신규 추가될 행(롤백 시 삭제): CUTEDGE·DTAPE·BONGSEW·QBANG_4·STRING_4 (PUNCH_4는 기존행 갱신)
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_BANNER_N' AND comp_cd IN ('COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE','COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE','COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW','COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4','COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4');
