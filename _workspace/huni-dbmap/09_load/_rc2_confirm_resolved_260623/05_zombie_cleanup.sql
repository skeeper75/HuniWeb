-- 05_zombie_cleanup.sql — 좀비 단가행 comp use_yn=N 확정 (멱등·IS DISTINCT FROM 가드)
-- 대상: t_prc_price_components (일반현수막 PUNCH_6/8 — del_yn 이미 Y·use_dims=[])
-- always-add 좀비 차단: 빈 use_dims 좀비 comp를 use_yn=N으로 비활성(엔진 평가 제외).
-- src: live 4695(PUNCH_6) / 4697(PUNCH_8) — del_yn=Y·use_dims=[]

UPDATE t_prc_price_components
   SET use_yn = 'N', upd_dt = now()
 WHERE comp_cd IN ('COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_6',
                   'COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_8')
   AND del_yn = 'Y'                        -- 좀비(논리삭제)만 대상 — 활성 comp 보호
   AND use_yn IS DISTINCT FROM 'N';
