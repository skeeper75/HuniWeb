-- UNDO: 박 prcs_dtl_opt / use_dims proc_grp 교정 되돌리기 (foil-procdtlopt-260706-load.sql)
-- 원상: prcs_dtl_opt 단일 "크기" · SMALL_STD 외 5개 proc_grp 제거(SMALL_STD는 원래 보유였으므로 불변).
BEGIN;

UPDATE t_proc_processes SET prcs_dtl_opt = '{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}'::jsonb
WHERE proc_cd IN ('PROC_000033','PROC_000050');

UPDATE t_prc_price_components SET use_dims = use_dims - 'proc_grp:PROC_000033'
WHERE comp_cd IN ('COMP_FOIL_PROC_LARGE_STD','COMP_FOIL_PROC_LARGE_SPECIAL',
                  'COMP_FOIL_PROC_SMALL_SPECIAL','COMP_FOIL_SETUP_LARGE','COMP_FOIL_SETUP_SMALL');

SELECT proc_cd, prcs_dtl_opt::text FROM t_proc_processes WHERE proc_cd IN ('PROC_000033','PROC_000050') ORDER BY proc_cd;
COMMIT;
