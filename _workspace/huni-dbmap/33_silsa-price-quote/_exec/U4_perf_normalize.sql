-- U4_perf_normalize.sql — C-4 미싱 통합 + prc_typ 정정
--
-- ★설계 정정(라이브 실측 2026-06-17): 설계는 "PERF_1L=줄수1만(10행) → 2L/3L 단가행 20행 이설"로 가정했으나
--   라이브 실측은 PERF_1L = 30행(opt_cd OPV-000007/8/9 = 1줄/2줄/3줄 각 10) + dim_vals=NULL.
--   즉 정본(1L)에 줄수 1/2/3이 opt_cd 형태로 이미 전건 존재 → 이설(migrate) 불요.
--   조치 = ① prc_typ .02→.01 ② 기존 30행 opt_cd→dim_vals.줄수 재정규화(값 동일·축 표현만 변경)
--          ③ 레거시 2L/3L use_yn=N + 배선 정본 교체(C-1/2/3 동형).
--   OPV→줄수 매핑(라이브 t_prd_product_options): OPV-000007=1줄·OPV-000008=2줄·OPV-000009=3줄.
-- 멱등: prc_typ 조건부 UPDATE · dim_vals UPDATE는 opt_cd 기준 멱등(opt_cd 비운 뒤 재실행 시 매칭 0).

-- (1) prc_typ 통일 .02 → .01 (형제 2L/3L·오시·가변 단가형과 정합)
UPDATE t_prc_price_components
   SET prc_typ_cd = 'PRICE_TYPE.01', upd_dt = now()
 WHERE comp_cd = 'COMP_PP_PERF_1L'
   AND prc_typ_cd = 'PRICE_TYPE.02';

-- (2) PERF_1L 단가행 30개: opt_cd(OPV) → dim_vals.줄수 재정규화 (값 불변·축 표현만)
--     멱등: opt_cd가 이미 비워진 행은 WHERE에서 제외 → 2pass delta 0.
UPDATE t_prc_component_prices
   SET dim_vals = jsonb_build_object('줄수',
         CASE opt_cd WHEN 'OPV-000007' THEN 1 WHEN 'OPV-000008' THEN 2 WHEN 'OPV-000009' THEN 3 END),
       opt_cd = NULL,
       upd_dt = now()
 WHERE comp_cd = 'COMP_PP_PERF_1L'
   AND opt_cd IN ('OPV-000007','OPV-000008','OPV-000009');

-- (3) 레거시 2L/3L 논리삭제 (정본 1L이 줄수 2/3을 dim_vals로 보유 → 의미손실 0)
UPDATE t_prc_price_components
   SET use_yn = 'N', upd_dt = now()
 WHERE comp_cd IN ('COMP_PP_PERF_2L','COMP_PP_PERF_3L')
   AND use_yn <> 'N';

-- (4) 배선 교체: 레거시 PERF 2L/3L 배선 → 정본 PERF_1L 보강 후 레거시 제거 (C-3 동형)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT DISTINCT fc.frm_cd, 'COMP_PP_PERF_1L', fc.disp_seq, fc.addtn_yn, now()
  FROM t_prc_formula_components fc
 WHERE fc.comp_cd IN ('COMP_PP_PERF_2L','COMP_PP_PERF_3L')
   AND NOT EXISTS (
     SELECT 1 FROM t_prc_formula_components x
      WHERE x.frm_cd = fc.frm_cd AND x.comp_cd = 'COMP_PP_PERF_1L'
   );

DELETE FROM t_prc_formula_components
 WHERE comp_cd IN ('COMP_PP_PERF_2L','COMP_PP_PERF_3L');

-- 주의: 레거시 2L/3L 단가행(component_prices 20행)은 use_yn=N comp에 매달린 채 보존(이력).
--   하드삭제 미수행(비파괴). 엔진은 use_yn=Y 정본만 조회 → 중복 비결정 0.
