-- acryl-addon-template-propagate-fix.sql — addon 템플릿 교정 6상품 전파 (147 동형·라이브 COMMIT 후보)
-- 검증 레시피(147 마그넷 라이브 GO·FINDING-addon-optcd-model-broken.md): ① 가산형 공식→PRF_CLR_ACRYL(본체만)
--   ② 가산 옵션그룹/옵션/아이템 삭제(OPT_REF_DIM.03 본체 mat_cd covered 해소) ③ 부속=addon 템플릿(flat 단가)+링크.
-- 대상·부속 단가(가격표 B04b verbatim):
--   146 키링: 은색고리1100·금색고리1200·은색구슬줄300·볼체인1000 (고리없음/선택안함=0=미추가). 볼체인 8색=동일1000→단일 템플릿(색=생산메타).
--   148 뱃지: 원형핀600·1구자석1000 / 149 집게: 투명집게700 / 150 스마트톡: 화이트바디2600·투명바디3000
--   152 명찰: 일자핀700·2구자석1700 / 154 머리끈: 블랙머리끈500
-- 채번 TMPL-000015~000026(라이브 MAX TMPL-000014+1). base_prd_cd=각 본상품. flat 단가=evaluate_price(target=tmpl) unit_price×qty.
-- ★잔재(COMP_ACRYL_*/PRF_ACRYL_* 가산·146 KEYRING/BALLCHAIN)=고아·무해(미터치). 146 Step2 자재(MAT_202~209)는 제거(볼체인 아이템 삭제로 불요).
-- 멱등 NOT EXISTS. 단일 트랜잭션. ★실 COMMIT은 인간 승인 후·각 상품 라이브 시뮬레이터 실증.
\set ON_ERROR_STOP on
BEGIN;

-- ============================================================
-- [1] 가산 옵션아이템 삭제 (covered 해소 선결)
-- ============================================================
DELETE FROM t_prd_product_option_items
WHERE (prd_cd,opt_cd) IN (
  ('PRD_000146','OPV-000026'),('PRD_000146','OPV-000027'),
  ('PRD_000146','OPV_000476'),('PRD_000146','OPV_000477'),('PRD_000146','OPV_000478'),
  ('PRD_000146','OPV_000479'),('PRD_000146','OPV_000480'),('PRD_000146','OPV_000481'),
  ('PRD_000146','OPV_000482'),('PRD_000146','OPV_000483'),
  ('PRD_000148','OPV_000466'),('PRD_000148','OPV_000467'),
  ('PRD_000149','OPV_000468'),
  ('PRD_000150','OPV_000469'),('PRD_000150','OPV_000470'),
  ('PRD_000152','OPV_000471'),('PRD_000152','OPV_000472'),
  ('PRD_000154','OPV-000028')
);

-- ============================================================
-- [2] 가산 옵션 삭제
-- ============================================================
DELETE FROM t_prd_product_options
WHERE (prd_cd,opt_cd) IN (
  ('PRD_000146','OPV-000026'),('PRD_000146','OPV-000027'),('PRD_000146','OPV_000473'),('PRD_000146','OPV_000474'),
  ('PRD_000146','OPV_000475'),('PRD_000146','OPV_000476'),('PRD_000146','OPV_000477'),('PRD_000146','OPV_000478'),
  ('PRD_000146','OPV_000479'),('PRD_000146','OPV_000480'),('PRD_000146','OPV_000481'),('PRD_000146','OPV_000482'),('PRD_000146','OPV_000483'),
  ('PRD_000148','OPV_000466'),('PRD_000148','OPV_000467'),
  ('PRD_000149','OPV_000468'),
  ('PRD_000150','OPV_000469'),('PRD_000150','OPV_000470'),
  ('PRD_000152','OPV_000471'),('PRD_000152','OPV_000472'),
  ('PRD_000154','OPV-000028')
);

-- ============================================================
-- [3] 가산 옵션그룹 삭제
-- ============================================================
DELETE FROM t_prd_product_option_groups
WHERE (prd_cd,opt_grp_cd) IN (
  ('PRD_000146','OPT-000012'),('PRD_000146','OPT_000079'),
  ('PRD_000148','OPT_000075'),
  ('PRD_000149','OPT_000076'),
  ('PRD_000150','OPT_000077'),
  ('PRD_000152','OPT_000078'),
  ('PRD_000154','OPT-000013'),('PRD_000154','OPT-000014')
);

-- ============================================================
-- [4] 146 Step2 추가 자재(MAT_202~209) 제거 (볼체인 아이템 삭제로 불요)
-- ============================================================
DELETE FROM t_prd_product_materials
WHERE prd_cd='PRD_000146' AND mat_cd BETWEEN 'MAT_000202' AND 'MAT_000209' AND usage_cd='USAGE.07';

-- ============================================================
-- [5] 바인딩 가산형 공식 → PRF_CLR_ACRYL (본체 면적격자만)
-- ============================================================
DELETE FROM t_prd_product_price_formulas
WHERE (prd_cd,frm_cd) IN (
  ('PRD_000146','PRF_ACRYL_KEYRING'),('PRD_000148','PRF_ACRYL_BADGE'),('PRD_000149','PRF_ACRYL_CLIP'),
  ('PRD_000150','PRF_ACRYL_SMARTTOK'),('PRD_000152','PRF_ACRYL_NAMETAG'),('PRD_000154','PRF_ACRYL_HAIRBAND')
);
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT v.prd_cd,'PRF_CLR_ACRYL','2026-06-28','본체 면적격자(부속은 addon 템플릿)'
FROM (VALUES ('PRD_000146'),('PRD_000148'),('PRD_000149'),('PRD_000150'),('PRD_000152'),('PRD_000154')) AS v(prd_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas pf WHERE pf.prd_cd=v.prd_cd AND pf.frm_cd='PRF_CLR_ACRYL');

-- ============================================================
-- [6] addon 템플릿 (base_prd_cd=본상품·tmpl_nm·dflt_qty1·use_yn Y)
-- ============================================================
INSERT INTO t_prd_templates (tmpl_cd, base_prd_cd, tmpl_nm, dflt_qty, use_yn, del_yn, reg_dt, note)
SELECT v.tmpl_cd, v.base_prd_cd, v.tmpl_nm, 1, 'Y','N', now(), 'addon(가격표 B04b)'
FROM (VALUES
  ('TMPL-000015','PRD_000146','은색고리'),('TMPL-000016','PRD_000146','금색고리'),
  ('TMPL-000017','PRD_000146','은색구슬줄'),('TMPL-000018','PRD_000146','볼체인'),
  ('TMPL-000019','PRD_000148','원형핀'),('TMPL-000020','PRD_000148','1구자석'),
  ('TMPL-000021','PRD_000149','투명집게'),
  ('TMPL-000022','PRD_000150','화이트바디'),('TMPL-000023','PRD_000150','투명바디'),
  ('TMPL-000024','PRD_000152','일자핀'),('TMPL-000025','PRD_000152','2구자석'),
  ('TMPL-000026','PRD_000154','블랙머리끈')
) AS v(tmpl_cd, base_prd_cd, tmpl_nm)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_templates t WHERE t.tmpl_cd=v.tmpl_cd);

-- ============================================================
-- [7] addon 템플릿 단가 (flat·B04b verbatim)
-- ============================================================
INSERT INTO t_prd_template_prices (tmpl_cd, apply_ymd, unit_price, reg_dt)
SELECT v.tmpl_cd,'2026-06-28', v.unit_price, now()
FROM (VALUES
  ('TMPL-000015',1100::numeric),('TMPL-000016',1200),('TMPL-000017',300),('TMPL-000018',1000),
  ('TMPL-000019',600),('TMPL-000020',1000),
  ('TMPL-000021',700),
  ('TMPL-000022',2600),('TMPL-000023',3000),
  ('TMPL-000024',700),('TMPL-000025',1700),
  ('TMPL-000026',500)
) AS v(tmpl_cd, unit_price)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_template_prices tp WHERE tp.tmpl_cd=v.tmpl_cd AND tp.apply_ymd='2026-06-28');

-- ============================================================
-- [8] addon 링크 (상품↔템플릿)
-- ============================================================
INSERT INTO t_prd_product_addons (prd_cd, tmpl_cd, disp_seq, reg_dt)
SELECT v.prd_cd, v.tmpl_cd, v.disp_seq, now()
FROM (VALUES
  ('PRD_000146','TMPL-000015',1),('PRD_000146','TMPL-000016',2),('PRD_000146','TMPL-000017',3),('PRD_000146','TMPL-000018',4),
  ('PRD_000148','TMPL-000019',1),('PRD_000148','TMPL-000020',2),
  ('PRD_000149','TMPL-000021',1),
  ('PRD_000150','TMPL-000022',1),('PRD_000150','TMPL-000023',2),
  ('PRD_000152','TMPL-000024',1),('PRD_000152','TMPL-000025',2),
  ('PRD_000154','TMPL-000026',1)
) AS v(prd_cd, tmpl_cd, disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_addons pa WHERE pa.prd_cd=v.prd_cd AND pa.tmpl_cd=v.tmpl_cd);

COMMIT;
