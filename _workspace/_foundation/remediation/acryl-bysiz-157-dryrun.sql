-- ============================================================================
-- acryl-bysiz-157-dryrun.sql — 아크릴 등록사이즈 가격모델 시범(157) DRY-RUN
--   ★표준 순서: 권위 분석→설계→구축→검증. 등록사이즈(siz_cd) 정확매칭 모델.
--   권위=아크릴 가격표 면적그리드(상품마스터 "*가격표참고")에서 등록사이즈별 도출(ceiling).
--   미니모양명함(COMP_NAMECARD_MINISHAPE) 동형. 라이브 미변경(ROLLBACK).
-- ----------------------------------------------------------------------------
-- 신규 구성요소 COMP_ACRYL_3T_BYSIZ: 완제품비(.06)·단가형(.01)·use_dims=[siz_cd,min_qty].
--   자재 무관(전 6개 3mm 단일)→ 행 mat_cd=NULL(와일드카드)·사이즈가 유일 가격축.
-- 신규 공식 PRF_ACRYL_BYSIZ: 위 구성요소 1배선.
-- 157 단가행: 60x60(SIZ_148)=5900 · 55x86(SIZ_012)=7800 (면적표 도출 verbatim).
-- 157 바인딩.
-- search-before-mint: 기존 면적 구성요소(siz_width/height)는 자유치수 전용이라 등록사이즈
--   상품엔 부적합(치수 미환원→최소가 버그) → 신규 siz_cd 구성요소 필요(입증됨).
-- ============================================================================
BEGIN;

-- 1) 구성요소
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, note)
VALUES ('COMP_ACRYL_3T_BYSIZ','투명아크릴3T 완제품가(등록사이즈)','PRC_COMPONENT_TYPE.06','PRICE_TYPE.01',
        '["siz_cd","min_qty"]','Y','등록사이즈 정확매칭. 단가=아크릴 가격표 면적그리드 도출(ceiling). 자재 투명3mm 단일.');

-- 2) 공식
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, note)
VALUES ('PRF_ACRYL_BYSIZ','투명아크릴3T 등록사이즈 공식','Y','투명아크릴 등록사이즈 상품(네임택·키링·코스터·스탠드·판아크릴 등) 공유.');

-- 3) 배선
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_ACRYL_BYSIZ','COMP_ACRYL_3T_BYSIZ',1,'Y');

-- 4) 157 단가행(사이즈별·면적표 도출 verbatim)
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note)
VALUES ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000148',NULL,1,5900,'아크릴네임택 60x60 — 면적표 60x60'),
       ('COMP_ACRYL_3T_BYSIZ','2026-06-27','SIZ_000012',NULL,1,7800,'아크릴네임택 55x86 — 면적표 60x90(ceiling)');

-- 5) 157 바인딩
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000157' AND frm_cd='PRF_ACRYL_BYSIZ';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000157','PRF_ACRYL_BYSIZ','2026-06-27','아크릴네임택 등록사이즈 가격모델(siz_cd 정확매칭).');

\echo '===== AFTER: 157 사이즈별 단가행(시뮬레이터에 뜰 것) ====='
SELECT s.siz_nm, cp.unit_price
FROM t_prc_component_prices cp JOIN t_siz_sizes s ON s.siz_cd=cp.siz_cd
WHERE cp.comp_cd='COMP_ACRYL_3T_BYSIZ' ORDER BY cp.unit_price;

DO $$
DECLARE v_r int; v6 numeric; v8 numeric;
BEGIN
  SELECT count(*) INTO v_r FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_3T_BYSIZ';
  IF v_r<>2 THEN RAISE EXCEPTION '검증 실패: 단가행 %개(기대 2)',v_r; END IF;
  SELECT unit_price INTO v6 FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_3T_BYSIZ' AND siz_cd='SIZ_000148';
  SELECT unit_price INTO v8 FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_3T_BYSIZ' AND siz_cd='SIZ_000012';
  IF v6<>5900 OR v8<>7800 THEN RAISE EXCEPTION '검증 실패: 60x60=%/55x86=%(기대 5900/7800)',v6,v8; END IF;
  RAISE NOTICE 'DRY-RUN OK: 157 등록사이즈 60x60=5900·55x86=7800·시뮬레이터 드롭다운 노출 예정';
END $$;

ROLLBACK;
\echo '===== ROLLBACK 완료 — 라이브 미변경 ====='
