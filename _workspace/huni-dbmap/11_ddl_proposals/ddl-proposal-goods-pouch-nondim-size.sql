-- =====================================================================
-- DDL PROPOSAL: goods-pouch 비치수(non-dimensional) size 마스터
--   (PROPOSAL ONLY — DO NOT APPLY without human approval. round-5 §6.6)
-- Closes round-4 GAP: 09_load/_assembled/blocked-and-gaps.md §5 (D-1)
--   rows unblocked: t_prd_product_sizes goods-pouch active 47상품 (≈96 ref 행)
-- =====================================================================
-- search-before-mint 요약 (상세 .md):
--   1) t_siz_sizes 무손실 불가 — 라이브 497행 전수, work/cut 치수가 모두
--      NULL인 "순수 라벨" siz 행 0건. 정사각/원형 이름 행조차 W×H 실치수 보유.
--      → 비치수 라벨(11온스·350ml·M/L/XL·단면/양면·2구)을 siz_cd로 담으려면
--         치수를 발명해야 함 = "비치수→치수 둔갑" (round-4가 거부한 위험).
--   2) t_prd_products.nonspec_*_min/max 불가 — 라이브 사용처(아크릴·현수막)는
--      모두 "연속 W×H 범위"(예 현수막 가로 500~1750). 이산 열거 라벨을
--      min/max 쌍으로 강제하면 형상/용량 의미 소실 + 라벨당 1상품 가정 붕괴.
--   3) CPQ t_prd_product_option_items 불가 — polymorphic 트리거가 ref_key가
--      가리키는 차원 행(siz_cd 등) 선존재를 강제. 라벨에 대응할 차원 행이
--      없으므로 옵션 항목도 라벨을 직접 담지 못함(1)과 동일 벽).
-- → 비치수 라벨 전용 마스터 신설이 최소 무손실 해법(사다리 4단계: 신규 테이블).

-- ---------------------------------------------------------------------
-- forward (적용)
-- ---------------------------------------------------------------------

-- (1) 형상/규격 유형 enum 축 — t_cod_base_codes 코드그룹 (사다리 1단계 재사용)
--     비치수 라벨의 "종류"(형상/용량/사이즈클래스/인쇄면/수량 등)를 분류하는
--     보조 축. 라이브 코드그룹 컨벤션(부모 1 + 자식 N) 그대로 추종.
--     ※ 코드값 행 INSERT는 code-row 선적재(별도, 후니 승인)로 다룸 — 여기선
--        그룹 존재만 가정. 신규 그룹 자체도 코드행이므로 DDL 아님(주석으로만 명시).
-- INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn) VALUES
--   ('NONDIM_SIZE_KIND', '비치수규격유형', NULL, NULL, 'Y'),
--   ('NONDIM_SIZE_KIND.01', '형상',     'NONDIM_SIZE_KIND', 1, 'Y'),  -- 원형/사각/하트/꽃/별
--   ('NONDIM_SIZE_KIND.02', '용량',     'NONDIM_SIZE_KIND', 2, 'Y'),  -- 11온스/350ml/500ml
--   ('NONDIM_SIZE_KIND.03', '사이즈클래스','NONDIM_SIZE_KIND', 3, 'Y'),-- S/M/L/XL
--   ('NONDIM_SIZE_KIND.04', '인쇄면',   'NONDIM_SIZE_KIND', 4, 'Y'),  -- 단면/양면
--   ('NONDIM_SIZE_KIND.05', '구성수',   'NONDIM_SIZE_KIND', 5, 'Y'),  -- 1구/2구/3구/4구
--   ('NONDIM_SIZE_KIND.99', '기타',     'NONDIM_SIZE_KIND', 99,'Y');

-- (2) 비치수 규격 마스터 — 형상/용량/사이즈클래스 등 라벨 자체를 보관.
--     t_siz_sizes와 분리하는 이유: t_siz_sizes는 "재단/작업 치수"가 본의이고
--     impos(터잡기)·여백 컬럼을 가진 치수 마스터. 비치수 라벨은 그 의미축이
--     다르므로 동일 테이블에 섞으면 치수 컬럼이 의미 없이 NULL(둔갑 위험).
CREATE TABLE IF NOT EXISTS t_siz_nonspec_sizes (
  nsiz_cd        VARCHAR(50)  NOT NULL,                 -- PK, NSIZ_NNNNNN
  nsiz_nm        VARCHAR(100) NOT NULL,                 -- 라벨 원문(예: '11온스','원형 90mm','단면')
  kind_cd        VARCHAR(50),                           -- → t_cod_base_codes(NONDIM_SIZE_KIND.*)
  approx_width   NUMERIC(10,2),                         -- 참고치수(있을 때만; '원형 90mm'의 90). NULL=치수無
  approx_height  NUMERIC(10,2),                         -- 참고치수(있을 때만). 가격/생산 권위 아님(라벨이 권위)
  capacity_val   NUMERIC(10,2),                         -- 용량값(11/350/500 등). NULL=용량無
  capacity_unit  VARCHAR(20),                           -- 용량단위('oz','ml'). NULL=용량無
  note           VARCHAR(500),
  use_yn         CHAR(1) NOT NULL DEFAULT 'Y',
  del_yn         CHAR(1) NOT NULL DEFAULT 'N',
  del_dt         TIMESTAMP WITHOUT TIME ZONE,
  reg_dt         TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  upd_dt         TIMESTAMP WITHOUT TIME ZONE,
  CONSTRAINT pk_t_siz_nonspec_sizes      PRIMARY KEY (nsiz_cd),
  CONSTRAINT ck_t_siz_nonspec_use_yn     CHECK (use_yn IN ('Y','N')),
  CONSTRAINT ck_t_siz_nonspec_del_yn     CHECK (del_yn IN ('Y','N')),
  CONSTRAINT fk_t_siz_nonspec_kind_cd    FOREIGN KEY (kind_cd)
             REFERENCES t_cod_base_codes (cod_cd)
);

-- (3) 상품↔비치수규격 연결 — 기존 t_prd_product_sizes와 동형(상품별 N개 라벨).
--     t_prd_product_sizes(siz_cd→t_siz_sizes)와 평행하는 비치수 전용 연결.
CREATE TABLE IF NOT EXISTS t_prd_product_nonspec_sizes (
  prd_cd     VARCHAR(50) NOT NULL,                      -- → t_prd_products
  nsiz_cd    VARCHAR(50) NOT NULL,                      -- → t_siz_nonspec_sizes
  dflt_yn    CHAR(1) NOT NULL DEFAULT 'N',
  disp_seq   INTEGER,
  reg_dt     TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  upd_dt     TIMESTAMP WITHOUT TIME ZONE,
  del_yn     CHAR(1) NOT NULL DEFAULT 'N',
  del_dt     TIMESTAMP WITHOUT TIME ZONE,
  CONSTRAINT pk_t_prd_product_nonspec_sizes PRIMARY KEY (prd_cd, nsiz_cd),
  CONSTRAINT ck_t_prd_prd_nonspec_dflt_yn   CHECK (dflt_yn IN ('Y','N')),
  CONSTRAINT ck_t_prd_prd_nonspec_del_yn    CHECK (del_yn  IN ('Y','N')),
  CONSTRAINT fk_t_prd_prd_nonspec_prd_cd    FOREIGN KEY (prd_cd)
             REFERENCES t_prd_products (prd_cd),
  CONSTRAINT fk_t_prd_prd_nonspec_nsiz_cd   FOREIGN KEY (nsiz_cd)
             REFERENCES t_siz_nonspec_sizes (nsiz_cd)
);

-- ---------------------------------------------------------------------
-- rollback (되돌리기)
-- ---------------------------------------------------------------------
-- DROP TABLE IF EXISTS t_prd_product_nonspec_sizes;
-- DROP TABLE IF EXISTS t_siz_nonspec_sizes;
-- (NONDIM_SIZE_KIND 코드행은 코드행 선적재 롤백으로 별도 제거)

-- ---------------------------------------------------------------------
-- 적용 순서 (round-5 apply.sql 대비):
--   step -2 : NONDIM_SIZE_KIND 코드그룹/코드행 (code-row 선적재)
--   step -1 : 본 DDL (CREATE TABLE x2)   ← 후니 인간 승인 후 적용
--   step  0 : t_siz_nonspec_sizes 데이터 행 (라벨 마스터, 후니 라벨 확정 후)
--   step  1 : t_prd_product_nonspec_sizes 연결 행 (47상품)
-- 기존 행 영향: 신규 테이블 — 기존 t_siz_sizes / t_prd_product_sizes 무영향.
-- FK 영향: 부모(t_prd_products·t_cod_base_codes·t_siz_nonspec_sizes) 선존재. 고아 0.
-- ⚠ 데이터(라벨→nsiz_cd 매핑) 자체는 후니 결정 필요(원천 라벨이 권위, 발명 금지).
-- =====================================================================
