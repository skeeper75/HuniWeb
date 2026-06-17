-- =====================================================================
-- DDL PROPOSAL: 형상 축 (V-12, 메타모델 #17)
--   (PROPOSAL ONLY — DO NOT APPLY without human approval. RP-Meta ST v5.0)
-- Closes vessel-gap: _workspace/huni-rpmeta/04_vessel/vessel-shape-axis.md
--   unblock: ST 36상품(자유형·사각반칼·원형·타원·라운드·5형상 데코) + 도무송/모양재단 보유 상품
-- =====================================================================
-- search-before-mint 요약 (상세 .md vessel-shape-axis §1):
--   라이브 3-레벨 실측(2026-06-17 직접 SELECT): ① 형상 전용 컬럼 0건(t_* 전 테이블·
--   shape/outline/form_typ/die_cut 검색 = transforms.transform_type 1건 false positive만)
--   ② 형상 전용 테이블 0건 ③ base_code 16그룹에 SHAPE/형상 enum 0건(코드값 도메인조차 없음).
--   t_siz_sizes(18컬럼)는 재단치수(work/cut_width·height)이지 형상 분류 슬롯 아님.
--   KB G-SK-2 "형상이 어느 축에도 없음"을 라이브 3-레벨 확증.
--   ★형상↔칼틀 1:多(CL→CL001~100)·5형상 superset(STDCFBR) → siz 흡수 시 "원형"이 매 칼틀
--   프리셋 행에 중복 인코딩(이행종속·정규화 붕괴) → siz 흡수 불가 = GAP 확정.
--   → 사다리: ① base_code SHAPE 그룹 + ②a t_prd_products.shape_cd(상품 1형상)
--     + ②b t_prd_product_sizes.shape_cd(형상↔칼틀 1:多 게이팅, 기존 junction 재사용·테이블 mint 0).
--   (dbmap round-3 "도무송 형상=siz_cd 신설" 권고를 1:多 증거가 정정 — 충돌 아닌 정밀화·.md §4)

-- ---------------------------------------------------------------------
-- forward (적용)
-- ---------------------------------------------------------------------

-- (1) 코드그룹 1개(SHAPE) — RP shape_info enum(SQ/CL/EL/RC/FR) 모델 흡수(후니 코드로).
--     ※ 코드행 INSERT = 코드행 선적재(후니 승인). reg_dt NOT NULL(DEFAULT now()) → 명시 또는 omit.
--     ※ use_yn = 라이브 DEFAULT 없음 → 항상 명시. del_yn DEFAULT 'N'(명시 안전).
--     라이브 코드그룹 컨벤션(부모 upr_cod_cd=NULL + 자식 <GROUP>.NN·disp_seq) 추종.
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, del_yn, reg_dt) VALUES
  ('SHAPE',    '형상',         NULL,    1, 'Y','N', now()),
  ('SHAPE.01', '사각형',       'SHAPE', 1, 'Y','N', now()),  -- SQ (STCUXXX 사각반칼)
  ('SHAPE.02', '원형',         'SHAPE', 2, 'Y','N', now()),  -- CL (STTHCIC·칼틀 CL001~)
  ('SHAPE.03', '타원형',       'SHAPE', 3, 'Y','N', now()),  -- EL (STTHELP)
  ('SHAPE.04', '사각라운드형', 'SHAPE', 4, 'Y','N', now()),  -- RC (STTHSQU·칼틀 RC001~)
  ('SHAPE.05', '자유형',       'SHAPE', 5, 'Y','N', now());  -- FR (STTHUSR·자유칼선 강제→V-1 ref_param_json {"모양"})

-- (2a) 상품 형상 슬롯(상품분기형·1상품 1형상) — ADD COLUMN NULL(백필 0·무잠금).
--      NULL = 형상축 비적용(1:1 흡수 카테고리 BN/GS/TP/PR·전면 강제 금지).
ALTER TABLE t_prd_products ADD COLUMN shape_cd VARCHAR(50) NULL;

-- (2b) 형상↔칼틀 게이팅 슬롯(1:多·5형상 superset) — 기존 prd×siz junction 행에 형상 분류.
--      각 (prd_cd,siz_cd) 칼틀 프리셋 행이 자기 형상 1값 보유 → "원형 사실" 중복 없이 게이팅.
ALTER TABLE t_prd_product_sizes ADD COLUMN shape_cd VARCHAR(50) NULL;

ALTER TABLE t_prd_products ADD CONSTRAINT fk_t_prd_products_shape_cd
  FOREIGN KEY (shape_cd) REFERENCES t_cod_base_codes (cod_cd);
ALTER TABLE t_prd_product_sizes ADD CONSTRAINT fk_t_prd_product_sizes_shape_cd
  FOREIGN KEY (shape_cd) REFERENCES t_cod_base_codes (cod_cd);

COMMENT ON COLUMN t_prd_products.shape_cd      IS '상품 외곽 형상(SHAPE): SQ/CL/EL/RC/FR. NULL=형상축 비적용(1:1 흡수 카테고리·size 프리셋이 형상 암묵 보유).';
COMMENT ON COLUMN t_prd_product_sizes.shape_cd IS '형상↔칼틀 게이팅(SHAPE·1:多): 그 상품-칼틀 쌍의 형상. CL→CL001~ 각 행 SHAPE.02. 5형상 superset(STDCFBR)=칼틀별 형상. NULL=형상 무관 사이즈.';

-- ---------------------------------------------------------------------
-- rollback (되돌리기) — 백필값 백업 권고(NULL 컬럼이면 손실 0)
-- ---------------------------------------------------------------------
-- ALTER TABLE t_prd_product_sizes DROP CONSTRAINT fk_t_prd_product_sizes_shape_cd;
-- ALTER TABLE t_prd_products      DROP CONSTRAINT fk_t_prd_products_shape_cd;
-- ALTER TABLE t_prd_product_sizes DROP COLUMN shape_cd;
-- ALTER TABLE t_prd_products      DROP COLUMN shape_cd;
-- (SHAPE 코드행은 use_yn='N'으로 별도)

-- ---------------------------------------------------------------------
-- 적용 순서:
--   step -1 : 코드그룹/코드행 SHAPE (1) (code-row 선적재·후니 승인)
--   step  0 : 본 DDL ALTER (2a)(2b) + FK ×2  ← 인간 승인 후
--   step  1 : 백필 UPDATE (ST 형상 — dbmap 적재 트랙)
--             상품분기형(원형 STTHCIC→2a SHAPE.02·사각반칼 STCUXXX→.01·자유형 STTHUSR→.05)=2a
--             5형상 superset(STDCFBR)·칼틀 enum 깊은 상품(CL001~/RC001~)=2b
--             형상=FR → V-1 ref_param_json {"모양"}(완칼 PROC_000053) 연동
--   ★1:1 흡수 카테고리(BN/GS/TP/PR) 백필 0(shape_cd NULL 유지·형상축 전면 강제 금지)
-- 기존 행 영향: ADD COLUMN NULL = t_prd_products 275상품·t_prd_product_sizes 전 행 무파손·무잠금.
-- FK 영향: 부모 SHAPE 코드행 선존재. 고아 0.
-- 정규화: t_siz_sizes 마스터(497행 공유 칼틀)에 형상 안 맴 — 그러면 siz_cd→형상 이행종속이
--          같은 칼틀 다른 형상 상품과 충돌. prd×siz junction에 매야 그 상품-칼틀 쌍 한정 무손실.
-- ⚠ 2a/2b 중복 운영 정합·EL 칼틀 enum·자유칼선 전용 process row 신설 여부 = open decision(.md §6).
-- ⚠ 형상→칼선(FR→완칼 모양)=V-1 ref_param_json·입력모드 게이팅=V-4 RULE_TYPE.04(match) 연동.
-- =====================================================================
