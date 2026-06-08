-- load.sql — D-WIRE 제본(BIND)/명함(NAMECARD)/포토카드(PHOTOCARD) 가격공식 상품별 재모델 (per-product re-model)
-- 생성: dbm-mapping-designer (dbm-price-formula 스킬) · 2026-06-07
--
-- 라이브 railway DB에 대한 멱등 단일 트랜잭션. BEGIN/COMMIT 미포함 — apply.sh 가 모드별 주입(09_load/_exec 패턴).
-- 기본 = DRY-RUN(ROLLBACK). 실제 COMMIT 은 인간 승인 시에만. 본 하네스는 COMMIT 미호출.
--
-- 범위(poster 재모델과 동형):
--   t_prc_price_formulas        9 신규 (BIND 4 = FRM_TYPE.01 합산형 / NAMECARD 3 + PHOTOCARD 2 = FRM_TYPE.02 단순형)
--   t_prc_formula_components    14 신규 (BIND 4·각 자기 제본 comp 1합산 / NAMECARD 8·단양면x무게 택일 / PHOTOCARD 2·세트 1)
--   t_prd_product_price_formulas 재바인딩 9 DELETE + 9 INSERT
--   공유공식 은퇴 3 (PRF_BIND_SUM·PRF_NAMECARD_FIXED·PRF_PHOTOCARD_FIXED → use_yn='N', 0바인딩 도달)
-- component_prices 미적재(단가 본체 = 라이브 선존재. 전 comp n_prices>0 확인). IDENTITY 시퀀스 무관(surrogate id 미생성).
--
-- [C1 SUPERSEDE] 본 트랙은 `02_mapping/price211-sticker-namecard/` 의 NAMECARD 부분을 대체한다(LD-2).
--   C1 load.sql 명함분(공유 PRF_NAMECARD_FIXED 에 18배선·7바인딩, 라이브 미적재)은 폐기.
--   C1 STICKER 부분(PRF_STK_FIXED/PRF_STK_PACK_FIXED)은 정당-공유로 유지(본 트랙 미관여).
--
-- 멱등성(R1): 전 INSERT 'WHERE NOT EXISTS' 가드. 재바인딩 DELETE 는 멱등(없으면 0행). UPDATE 'IS DISTINCT FROM'. 2-pass 행변경 0.
-- 원자성(R2): ON_ERROR_STOP=1 + 단일 tx → 임의 문 실패 시 전체 롤백.
-- reg_dt(NOT NULL DEFAULT now()): INSERT 컬럼목록에서 omit → DEFAULT 발화(round-5 '명시 NULL=DEFAULT 미발화' 함정 회피).
SET client_min_messages = warning;

-- ============================================================
-- [단계 0] FK 부모 선존재 검증 (read-only assert — 미충족 시 즉시 abort)
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM t_cod_base_codes WHERE cod_cd='FRM_TYPE.01') THEN
    RAISE EXCEPTION 'FK MISSING: FRM_TYPE.01 부재'; END IF;
  IF NOT EXISTS (SELECT 1 FROM t_cod_base_codes WHERE cod_cd='FRM_TYPE.02') THEN
    RAISE EXCEPTION 'FK MISSING: FRM_TYPE.02 부재'; END IF;
  IF (SELECT count(*) FROM t_prd_products
      WHERE prd_cd IN ('PRD_000068','PRD_000069','PRD_000070','PRD_000071',
                       'PRD_000031','PRD_000032','PRD_000033',
                       'PRD_000024','PRD_000025')) <> 9 THEN
    RAISE EXCEPTION 'FK MISSING: 9 대상 상품 일부 부재'; END IF;
  -- comp 부모 선존재 (재배선 대상 14 comp 전건)
  IF (SELECT count(*) FROM t_prc_price_components
      WHERE comp_cd IN ('COMP_BIND_JUNGCHEOL','COMP_BIND_MUSEON','COMP_BIND_PUR','COMP_BIND_TWINRING',
                        'COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2',
                        'COMP_NAMECARD_PREMIUM_S1_MGA','COMP_NAMECARD_PREMIUM_S1_MGB',
                        'COMP_NAMECARD_PREMIUM_S2_MGA','COMP_NAMECARD_PREMIUM_S2_MGB',
                        'COMP_NAMECARD_COAT_S1','COMP_NAMECARD_COAT_S2',
                        'COMP_PHOTOCARD_SET','COMP_PHOTOCARD_CLEAR_SET')) <> 14 THEN
    RAISE EXCEPTION 'FK MISSING: 14 재배선 comp 일부 부재'; END IF;
END $$;


-- ============================================================
-- [단계 1] 공식 헤더 9 신규. reg_dt=DEFAULT(omit)
--   BIND 4 = FRM_TYPE.01 합산형(제본 합산형 계승) / NAMECARD 3 + PHOTOCARD 2 = FRM_TYPE.02 단순형
-- ============================================================
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_BIND_JUNGCHEOL', '제본 합산형 상품별 [중철책자]', 'FRM_TYPE.01', 'D-WIRE 재모델: PRD_000068 중철책자 전용 공식(PRF_BIND_SUM 분리). 합산항=중철 제본비 단일 comp', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_BIND_JUNGCHEOL');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_BIND_MUSEON', '제본 합산형 상품별 [무선책자]', 'FRM_TYPE.01', 'D-WIRE 재모델: PRD_000069 무선책자 전용 공식(PRF_BIND_SUM 분리). 합산항=무선 제본비 단일 comp', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_BIND_MUSEON');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_BIND_PUR', '제본 합산형 상품별 [PUR책자]', 'FRM_TYPE.01', 'D-WIRE 재모델: PRD_000070 PUR책자 전용 공식(PRF_BIND_SUM 분리). 합산항=PUR 제본비 단일 comp', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_BIND_PUR');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_BIND_TWINRING', '제본 합산형 상품별 [트윈링책자]', 'FRM_TYPE.01', 'D-WIRE 재모델: PRD_000071 트윈링책자 전용 공식(PRF_BIND_SUM 분리). 합산항=트윈링 제본비 단일 comp', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_BIND_TWINRING');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_NAMECARD_STD', '명함 단순형 상품별 [스탠다드명함]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000033 스탠다드명함 전용 공식(PRF_NAMECARD_FIXED 분리·C1 supersede). 단/양면 STD comp', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_STD');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_NAMECARD_PREMIUM', '명함 단순형 상품별 [프리미엄명함]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000031 프리미엄명함 전용 공식(PRF_NAMECARD_FIXED 분리·C1 supersede). 단/양면 x 무게A/B PREMIUM comp', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_PREMIUM');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_NAMECARD_COAT', '명함 단순형 상품별 [코팅명함]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000032 코팅명함 전용 공식(PRF_NAMECARD_FIXED 분리·C1 supersede). 단/양면 COAT comp', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_COAT');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_PHOTOCARD_STD', '포토카드 단순형 상품별 [포토카드]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000024 포토카드 전용 공식(PRF_PHOTOCARD_FIXED 분리). 세트 완제품가 SET comp', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOCARD_STD');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_PHOTOCARD_CLEAR', '포토카드 단순형 상품별 [투명포토카드]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000025 투명포토카드 전용 공식(PRF_PHOTOCARD_FIXED 분리). 세트 완제품가 CLEAR_SET comp', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOCARD_CLEAR');

-- ============================================================
-- [단계 2] 공식↔구성요소 배선 14. comp FK 선존재 가드.
--   BIND(합산형): 각 상품 공식이 자기 단일 제본 comp 를 합산(addtn_yn='Y'). 라이브에 책자용 인쇄/용지/코팅 comp 부재 →
--                 책자 가격사슬은 제본비 단일항 합산이 라이브 권위(엔진 모델). 합산항 1개라도 FRM_TYPE.01 합산형 정합.
--   NAMECARD(단순형): 단/양면(S1/S2) + 프리미엄 무게A/B(MGA/MGB) = 동일상품 내 택일 변형 → addtn_yn='N'(비합산 택일).
--   PHOTOCARD(단순형): 세트 완제품가 단일 comp → addtn_yn='Y'(단일항).
-- ============================================================
-- BIND 합산형 (각 1합산)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_BIND_JUNGCHEOL', 'COMP_BIND_JUNGCHEOL', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_BIND_JUNGCHEOL')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_BIND_JUNGCHEOL' AND comp_cd='COMP_BIND_JUNGCHEOL');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_BIND_MUSEON', 'COMP_BIND_MUSEON', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_BIND_MUSEON')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_BIND_MUSEON' AND comp_cd='COMP_BIND_MUSEON');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_BIND_PUR', 'COMP_BIND_PUR', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_BIND_PUR')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_BIND_PUR' AND comp_cd='COMP_BIND_PUR');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_BIND_TWINRING', 'COMP_BIND_TWINRING', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_BIND_TWINRING')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_BIND_TWINRING' AND comp_cd='COMP_BIND_TWINRING');
-- NAMECARD 단순형 (단/양면·무게 택일 N)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_NAMECARD_STD', 'COMP_NAMECARD_STD_S1', 1, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_NAMECARD_STD_S1')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_STD' AND comp_cd='COMP_NAMECARD_STD_S1');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_NAMECARD_STD', 'COMP_NAMECARD_STD_S2', 2, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_NAMECARD_STD_S2')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_STD' AND comp_cd='COMP_NAMECARD_STD_S2');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_NAMECARD_PREMIUM', 'COMP_NAMECARD_PREMIUM_S1_MGA', 1, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_NAMECARD_PREMIUM_S1_MGA')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_PREMIUM' AND comp_cd='COMP_NAMECARD_PREMIUM_S1_MGA');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_NAMECARD_PREMIUM', 'COMP_NAMECARD_PREMIUM_S1_MGB', 2, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_NAMECARD_PREMIUM_S1_MGB')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_PREMIUM' AND comp_cd='COMP_NAMECARD_PREMIUM_S1_MGB');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_NAMECARD_PREMIUM', 'COMP_NAMECARD_PREMIUM_S2_MGA', 3, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_NAMECARD_PREMIUM_S2_MGA')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_PREMIUM' AND comp_cd='COMP_NAMECARD_PREMIUM_S2_MGA');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_NAMECARD_PREMIUM', 'COMP_NAMECARD_PREMIUM_S2_MGB', 4, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_NAMECARD_PREMIUM_S2_MGB')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_PREMIUM' AND comp_cd='COMP_NAMECARD_PREMIUM_S2_MGB');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_NAMECARD_COAT', 'COMP_NAMECARD_COAT_S1', 1, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_NAMECARD_COAT_S1')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_COAT' AND comp_cd='COMP_NAMECARD_COAT_S1');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_NAMECARD_COAT', 'COMP_NAMECARD_COAT_S2', 2, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_NAMECARD_COAT_S2')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_COAT' AND comp_cd='COMP_NAMECARD_COAT_S2');
-- PHOTOCARD 단순형 (세트 단일항 Y)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_PHOTOCARD_STD', 'COMP_PHOTOCARD_SET', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_PHOTOCARD_SET')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_PHOTOCARD_STD' AND comp_cd='COMP_PHOTOCARD_SET');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_PHOTOCARD_CLEAR', 'COMP_PHOTOCARD_CLEAR_SET', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_PHOTOCARD_CLEAR_SET')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_PHOTOCARD_CLEAR' AND comp_cd='COMP_PHOTOCARD_CLEAR_SET');

-- ============================================================
-- [단계 3] 상품 재바인딩 — DELETE (prd, 공유공식) 9 + INSERT (prd, PRF_<X>) 9
--   FK 안전: 단계1 공식 헤더 선존재 후 INSERT. DELETE 는 멱등(없으면 0행). DELETE-old↔INSERT-new PK 독립(frm_cd 상이).
-- ============================================================
-- BIND 재바인딩
DELETE FROM t_prd_product_price_formulas WHERE frm_cd='PRF_BIND_SUM' AND prd_cd IN ('PRD_000068','PRD_000069','PRD_000070','PRD_000071');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000068', 'PRF_BIND_JUNGCHEOL', '2026-06-01', 'D-WIRE 재바인딩: PRF_BIND_SUM->PRF_BIND_JUNGCHEOL (중철책자)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_BIND_JUNGCHEOL')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000068' AND frm_cd='PRF_BIND_JUNGCHEOL');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000069', 'PRF_BIND_MUSEON', '2026-06-01', 'D-WIRE 재바인딩: PRF_BIND_SUM->PRF_BIND_MUSEON (무선책자)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_BIND_MUSEON')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000069' AND frm_cd='PRF_BIND_MUSEON');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000070', 'PRF_BIND_PUR', '2026-06-01', 'D-WIRE 재바인딩: PRF_BIND_SUM->PRF_BIND_PUR (PUR책자)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_BIND_PUR')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000070' AND frm_cd='PRF_BIND_PUR');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000071', 'PRF_BIND_TWINRING', '2026-06-01', 'D-WIRE 재바인딩: PRF_BIND_SUM->PRF_BIND_TWINRING (트윈링책자)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_BIND_TWINRING')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000071' AND frm_cd='PRF_BIND_TWINRING');
-- NAMECARD 재바인딩 (C1 supersede — 공유 PRF_NAMECARD_FIXED 에서 상품별로 이전)
DELETE FROM t_prd_product_price_formulas WHERE frm_cd='PRF_NAMECARD_FIXED' AND prd_cd IN ('PRD_000031','PRD_000032','PRD_000033');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000033', 'PRF_NAMECARD_STD', '2026-06-01', 'D-WIRE 재바인딩: PRF_NAMECARD_FIXED->PRF_NAMECARD_STD (스탠다드명함)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_STD')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000033' AND frm_cd='PRF_NAMECARD_STD');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000031', 'PRF_NAMECARD_PREMIUM', '2026-06-01', 'D-WIRE 재바인딩: PRF_NAMECARD_FIXED->PRF_NAMECARD_PREMIUM (프리미엄명함)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_PREMIUM')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000031' AND frm_cd='PRF_NAMECARD_PREMIUM');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000032', 'PRF_NAMECARD_COAT', '2026-06-01', 'D-WIRE 재바인딩: PRF_NAMECARD_FIXED->PRF_NAMECARD_COAT (코팅명함)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_COAT')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000032' AND frm_cd='PRF_NAMECARD_COAT');
-- PHOTOCARD 재바인딩 (공유 모호 → 상품별 명확화)
DELETE FROM t_prd_product_price_formulas WHERE frm_cd='PRF_PHOTOCARD_FIXED' AND prd_cd IN ('PRD_000024','PRD_000025');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000024', 'PRF_PHOTOCARD_STD', '2026-06-01', 'D-WIRE 재바인딩: PRF_PHOTOCARD_FIXED->PRF_PHOTOCARD_STD (포토카드)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOCARD_STD')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000024' AND frm_cd='PRF_PHOTOCARD_STD');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000025', 'PRF_PHOTOCARD_CLEAR', '2026-06-01', 'D-WIRE 재바인딩: PRF_PHOTOCARD_FIXED->PRF_PHOTOCARD_CLEAR (투명포토카드)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_PHOTOCARD_CLEAR')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000025' AND frm_cd='PRF_PHOTOCARD_CLEAR');

-- ============================================================
-- [단계 4] 공유공식 은퇴 (0상품 도달 후 비활성). 멱등(IS DISTINCT FROM).
--   삭제(DELETE)는 잔존 formula_components 배선(JUNGCHEOL/STD/SET·CLEAR_SET) FK RESTRICT → 본 트랙 미수행(인간승인 별건).
-- ============================================================
UPDATE t_prc_price_formulas SET use_yn='N', upd_dt=now()
WHERE frm_cd IN ('PRF_BIND_SUM','PRF_NAMECARD_FIXED','PRF_PHOTOCARD_FIXED') AND use_yn IS DISTINCT FROM 'N';

-- ============================================================
-- [검증] 적재 후 사슬 무결성 (같은 tx 내 — ROLLBACK 시 무영향)
-- ============================================================
DO $$
DECLARE v_unwired int; v_shared_bind int;
BEGIN
  -- 9상품 전부 새 공식에 바인딩 + 그 공식에 자기 comp 배선됐는가
  SELECT count(*) INTO v_unwired
  FROM t_prd_product_price_formulas b
  WHERE b.prd_cd IN ('PRD_000068','PRD_000069','PRD_000070','PRD_000071',
                     'PRD_000031','PRD_000032','PRD_000033','PRD_000024','PRD_000025')
    AND b.frm_cd IN ('PRF_BIND_JUNGCHEOL','PRF_BIND_MUSEON','PRF_BIND_PUR','PRF_BIND_TWINRING',
                     'PRF_NAMECARD_STD','PRF_NAMECARD_PREMIUM','PRF_NAMECARD_COAT',
                     'PRF_PHOTOCARD_STD','PRF_PHOTOCARD_CLEAR')
    AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd=b.frm_cd);
  IF v_unwired <> 0 THEN RAISE EXCEPTION 'CHAIN BROKEN: % 상품 공식 미배선', v_unwired; END IF;
  -- 공유공식 잔존 바인딩 0
  SELECT count(*) INTO v_shared_bind FROM t_prd_product_price_formulas
   WHERE frm_cd IN ('PRF_BIND_SUM','PRF_NAMECARD_FIXED','PRF_PHOTOCARD_FIXED');
  IF v_shared_bind <> 0 THEN RAISE EXCEPTION '공유공식 잔존 바인딩 %', v_shared_bind; END IF;
  RAISE NOTICE 'D-WIRE BIND/NAMECARD/PHOTOCARD 사슬 검증 PASS: 9상품 재바인딩+배선 완료, 공유공식 3 = 0바인딩';
END $$;
