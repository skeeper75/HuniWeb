-- L5 기본 마감 = 오버로크 무료 (OPV_000025 dflt_yn=Y)
-- ============================================================================
-- 오버로크(0원)를 기본 선택으로. 라이브 실측 OPV_000025 dflt_yn 이미 'Y'(실측) → 멱등 조건부 UPDATE.
-- 복합/유료 옵션(OPV-000024·OPV_000026·OPV_000424·OPV_000027) 은 dflt_yn='N' 보장.
-- 멱등: 목표값과 다른 행만 UPDATE → 2-pass delta 0.
-- ============================================================================
UPDATE t_prd_product_options
   SET dflt_yn = 'Y', upd_dt = now()
 WHERE prd_cd = 'PRD_000124' AND opt_cd = 'OPV_000025' AND opt_grp_cd = 'OPT_000009'
   AND dflt_yn IS DISTINCT FROM 'Y';

UPDATE t_prd_product_options
   SET dflt_yn = 'N', upd_dt = now()
 WHERE prd_cd = 'PRD_000124' AND opt_grp_cd = 'OPT_000009'
   AND opt_cd IN ('OPV-000024','OPV_000026','OPV_000424','OPV_000027')
   AND dflt_yn IS DISTINCT FROM 'N';
