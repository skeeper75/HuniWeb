-- =====================================================================
-- 아크릴 부속 갭 통합 교정 load.sql  (GB-1 · GB-2 · GB-3)
-- 근거: design.md · gb5-material-filter-verdict.md · gap-board.md
-- [HARD] 실 COMMIT 금지. 인간 승인 + webadmin 실화면(제외0·PRICE≠0) 후 별도.
--        멱등(존재검사/ON CONFLICT). FK 위상순. 트랜잭션 래핑.
-- 검증 실행 시: BEGIN; \i load.sql ; ROLLBACK;  (COMMIT 아님)
-- 실측 사실: 옵션그룹/옵션 PK 충돌 0 · SEL_TYPE.01 실재 · 부속 단가행 OPV 실재.
-- =====================================================================
BEGIN;

-- ---------------------------------------------------------------------
-- [GB-3]  146 아크릴키링 본체자재 오염 교정 (silent-0 해소) — L1/round-13 성격
--   MAT_000043(3mm, dflt_yn='Y') 재활성 → 기본선택 복귀 / MAT_000386(굿즈중복) 은퇴
-- ---------------------------------------------------------------------
UPDATE t_prd_product_materials
   SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000146' AND mat_cd='MAT_000043' AND usage_cd='USAGE.07';

UPDATE t_prd_product_materials
   SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000146' AND mat_cd='MAT_000386' AND usage_cd='USAGE.07';

-- ---------------------------------------------------------------------
-- [GB-2]  부속 옵션그룹 재생성 (6상품) — opt_grp_cd = 공식 선언값 재사용
--   sel_typ_cd=SEL_TYPE.01(단일), mand_yn='Y'(부속 필수 선택). 멱등.
-- ---------------------------------------------------------------------
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES
  ('PRD_000147','OPT_000074','자석',   'SEL_TYPE.01',1,1,'Y',1,'Y','N',now()),
  ('PRD_000148','OPT_000075','부착핀', 'SEL_TYPE.01',1,1,'Y',1,'Y','N',now()),
  ('PRD_000149','OPT_000076','집게',   'SEL_TYPE.01',1,1,'Y',1,'Y','N',now()),
  ('PRD_000150','OPT_000077','바디',   'SEL_TYPE.01',1,1,'Y',1,'Y','N',now()),
  ('PRD_000152','OPT_000078','부착핀', 'SEL_TYPE.01',1,1,'Y',1,'Y','N',now()),
  ('PRD_000154','OPT-000014','헤어끈', 'SEL_TYPE.01',1,1,'Y',1,'Y','N',now())
ON CONFLICT (prd_cd, opt_grp_cd) DO NOTHING;

-- ---------------------------------------------------------------------
-- [GB-2]  부속 옵션 (9행) — opt_cd = 부속 단가행 component_prices.opt_cd(OPV) 정확일치
--   opt_nm 중 [CONFIRM-B] = 라벨-가격 대응 미확정(배선은 결정적, 표시명만 확인 필요)
-- ---------------------------------------------------------------------
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES
  -- 147 마그넷 (800)
  ('PRD_000147','OPV_000465','OPT_000074','자석부착',                'Y',1,'Y','N',now()),
  -- 148 뱃지 (1000 / 600) [CONFIRM-B]
  ('PRD_000148','OPV_000467','OPT_000075','[CONFIRM]원형핀(1000)',   'Y',1,'Y','N',now()),
  ('PRD_000148','OPV_000466','OPT_000075','[CONFIRM]1구자석(600)',   'N',2,'Y','N',now()),
  -- 149 집게 (700)
  ('PRD_000149','OPV_000468','OPT_000076','투명집게',                'Y',1,'Y','N',now()),
  -- 150 스마트톡 (2600 / 3000) [CONFIRM-B]
  ('PRD_000150','OPV_000469','OPT_000077','[CONFIRM]화이트바디(2600)','Y',1,'Y','N',now()),
  ('PRD_000150','OPV_000470','OPT_000077','[CONFIRM]투명바디(3000)', 'N',2,'Y','N',now()),
  -- 152 명찰 (700 / 1700)
  ('PRD_000152','OPV_000471','OPT_000078','일자핀',                  'Y',1,'Y','N',now()),
  ('PRD_000152','OPV_000472','OPT_000078','2구자석',                 'N',2,'Y','N',now()),
  -- 154 머리끈 (500)
  ('PRD_000154','OPV-000028','OPT-000014','블랙헤어끈',              'Y',1,'Y','N',now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;

-- ---------------------------------------------------------------------
-- [GB-2]  공식 재바인딩 (6상품) — 본체전용 → 부속 전용공식
--   PK=(prd_cd, apply_bgn_ymd) → 기존 2026-06-28 행 frm_cd UPDATE. 전용공식도 본체 포함.
-- ---------------------------------------------------------------------
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_MAGNET',   upd_dt=now() WHERE prd_cd='PRD_000147' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_BADGE',    upd_dt=now() WHERE prd_cd='PRD_000148' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_CLIP',     upd_dt=now() WHERE prd_cd='PRD_000149' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_SMARTTOK', upd_dt=now() WHERE prd_cd='PRD_000150' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_NAMETAG',  upd_dt=now() WHERE prd_cd='PRD_000152' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_HAIRBAND', upd_dt=now() WHERE prd_cd='PRD_000154' AND apply_bgn_ymd='2026-06-28' AND frm_cd='PRF_CLR_ACRYL';

-- ---------------------------------------------------------------------
-- [GB-1]  151 맥세이프 스마트톡 견적불가 해소 — 본체전용 바인딩(부속 무료·권위)
--   151 = 바인딩 0행이므로 INSERT. 본체 자재 MAT_000043·사이즈 격자정합 → PRICE≠0.
-- ---------------------------------------------------------------------
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
VALUES ('PRD_000151','PRF_CLR_ACRYL','2026-06-28','GB-1 견적불가 해소(부속 맥세이프=무료)',now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- =====================================================================
-- [ESCALATE — 이 파일에 미포함]
--   146 부속(고리+볼체인) 배선: [146-D1] 고리 단가행 재키 vs 그룹 재구성,
--   [146-D2] 볼체인 동시과금(단일 opt_cd 슬롯 한계)→addon 이관. 결정 후 별도.
-- =====================================================================
ROLLBACK;  -- [HARD] 검증 전용. COMMIT은 인간 승인 후 수동.
