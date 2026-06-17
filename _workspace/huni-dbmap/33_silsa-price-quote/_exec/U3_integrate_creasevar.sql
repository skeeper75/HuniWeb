-- U3_integrate_creasevar.sql — C-1/2/3 통합 (오시·가변텍스트·가변이미지)
-- 정본(1L/1EA)에 dim_vals.줄수/개수 1/2/3 전건 기적재(라이브 실측) → 레거시 use_yn=N + 배선 comp_cd 교체.
-- 단가행 재적재 0(정본에 이미 존재). 멱등: use_yn='N' 재실행 무해 · 배선 교체 NOT EXISTS 가드.
--
-- 라이브 실측 근거(2026-06-17):
--   COMP_PP_CREASE_1L dim_vals {줄수:1}×10 / {줄수:2}×10 / {줄수:3}×10 = 30행 (정본 완비)
--   COMP_PP_VARTEXT_1EA 69행 = 개수 1/2/3 / COMP_PP_VARIMG_1EA 69행 동형
--   레거시 2L/3L·2EA/3EA = 동일값 중복 → 의미손실 0

-- (1) 레거시 comp 논리삭제 (use_yn=N). 정본은 유지.
UPDATE t_prc_price_components
   SET use_yn = 'N', upd_dt = now()
 WHERE comp_cd IN (
   'COMP_PP_CREASE_2L','COMP_PP_CREASE_3L',
   'COMP_PP_VARTEXT_2EA','COMP_PP_VARTEXT_3EA',
   'COMP_PP_VARIMG_2EA','COMP_PP_VARIMG_3EA'
 )
   AND use_yn <> 'N';

-- (2) 배선 교체: 레거시 comp가 공식(PRF_DGP_A/D 등)에 배선돼 있으면 정본 comp로 재지정.
--     멱등: 정본 배선이 이미 있으면 INSERT 스킵, 그 후 레거시 배선 DELETE.
--     2-pass: 1pass 후 레거시 배선 0행 → 2pass delta 0.

-- 2a) 정본 comp 배선 보강 (레거시가 배선된 (frm_cd) 각각에 정본 1행 보장)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT DISTINCT fc.frm_cd, m.canon, fc.disp_seq, fc.addtn_yn, now()
  FROM t_prc_formula_components fc
  JOIN (VALUES
    ('COMP_PP_CREASE_2L','COMP_PP_CREASE_1L'),
    ('COMP_PP_CREASE_3L','COMP_PP_CREASE_1L'),
    ('COMP_PP_VARTEXT_2EA','COMP_PP_VARTEXT_1EA'),
    ('COMP_PP_VARTEXT_3EA','COMP_PP_VARTEXT_1EA'),
    ('COMP_PP_VARIMG_2EA','COMP_PP_VARIMG_1EA'),
    ('COMP_PP_VARIMG_3EA','COMP_PP_VARIMG_1EA')
  ) AS m(legacy, canon) ON fc.comp_cd = m.legacy
 WHERE NOT EXISTS (
   SELECT 1 FROM t_prc_formula_components x
    WHERE x.frm_cd = fc.frm_cd AND x.comp_cd = m.canon
 );

-- 2b) 레거시 배선 제거
DELETE FROM t_prc_formula_components
 WHERE comp_cd IN (
   'COMP_PP_CREASE_2L','COMP_PP_CREASE_3L',
   'COMP_PP_VARTEXT_2EA','COMP_PP_VARTEXT_3EA',
   'COMP_PP_VARIMG_2EA','COMP_PP_VARIMG_3EA'
 );
