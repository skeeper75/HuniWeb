-- W5_perf_dim_convert.sql — 미싱(PERF) 차원축 전환 opt_cd → proc_cd+dim_vals.줄수 (grouping C-4 / B-1 해소)
-- =========================================================================================
-- ★문제: COMP_PP_PERF_1L 만 opt_cd/opt_grp 모델(use_dims=["opt_cd","min_qty","opt_grp:OPT-000005"]·prc_typ=.02)
--   다른 후가공(오시/귀돌이/가변)은 proc_cd/proc_grp 모델(.01) → 모델 불일치로 동일 공식 배선 시 정합 깨짐.
-- ★해소(이설·값동일·신규 0): 오시 동형으로 통일
--   ① comp use_dims: ["opt_cd","min_qty","opt_grp:OPT-000005"] → ["proc_cd","min_qty","proc_grp:PROC_000030"]
--   ② comp prc_typ_cd: PRICE_TYPE.02 → .01 (단가형 통일)
--   ③ 단가행: opt_cd(OPV-000007/8/9) → proc_cd=PROC_000086(미싱 leaf·proc_grp 부모=PROC_000030) + dim_vals.줄수(1/2/3)
--      (오시 패턴 입증: proc_grp=부모 PROC_000029·component_prices proc_cd=leaf PROC_000090)
--      OPV-000007=1줄·000008=2줄·000009=3줄 (라이브 t_prd_product_options 실측)
--   ④ 레거시 PERF_2L/3L use_yn=N (값이 PERF_1L OPV-000008/009와 byte-identical·라이브 실측 확인)
-- 멱등: 각 UPDATE WHERE에 "전환 전 상태"만 매칭 → 2pass delta 0.
-- =========================================================================================

-- ① use_dims 전환 (opt_cd → proc_cd 모델)
UPDATE t_prc_price_components
   SET use_dims = '["proc_cd", "min_qty", "proc_grp:PROC_000030"]'::jsonb,
       upd_dt = now()
 WHERE comp_cd = 'COMP_PP_PERF_1L'
   AND use_dims = '["opt_cd", "min_qty", "opt_grp:OPT-000005"]'::jsonb;

-- ② prc_typ .02 → .01
UPDATE t_prc_price_components
   SET prc_typ_cd = 'PRICE_TYPE.01',
       upd_dt = now()
 WHERE comp_cd = 'COMP_PP_PERF_1L'
   AND prc_typ_cd = 'PRICE_TYPE.02';

-- ③ 단가행 차원 이설: opt_cd(OPV) → proc_cd=PROC_000086 + dim_vals.줄수 (값 불변·축만 전환)
UPDATE t_prc_component_prices
   SET proc_cd = 'PROC_000086',
       dim_vals = jsonb_build_object('줄수',
                    CASE opt_cd WHEN 'OPV-000007' THEN 1
                                WHEN 'OPV-000008' THEN 2
                                WHEN 'OPV-000009' THEN 3 END),
       opt_cd = NULL,
       upd_dt = now()
 WHERE comp_cd = 'COMP_PP_PERF_1L'
   AND opt_cd IN ('OPV-000007','OPV-000008','OPV-000009');

-- ④ 레거시 2L/3L use_yn=N (PERF_1L OPV-000008/009로 흡수·값 동일·의미손실 0)
UPDATE t_prc_price_components
   SET use_yn = 'N', upd_dt = now()
 WHERE comp_cd IN ('COMP_PP_PERF_2L','COMP_PP_PERF_3L')
   AND use_yn <> 'N';
