-- =====================================================================
-- DDL PROPOSAL: 박(foil) 2단 룩업 — 면적→분류등급(A~E/A~I)→가격
--   (PROPOSAL ONLY — DO NOT APPLY without human approval. round-5 §6.6)
-- Closes round-4 GAP: 09_load/_assembled_price/blocked-and-gaps.md §B-1
--   (price-load-validation-final.md §A-3 · schema-fitgap-price.md §4-3)
--   rows unblocked: foil-small/large 박 가공비 component_prices ≈90셀(소형)
--                   + 대형 동형 (현재 0행 산출 → 적재가능 승격)
-- =====================================================================
-- search-before-mint 요약 (상세 .md):
--   원천(06_extract/price-foil-small-l1.csv) 구조 = 진짜 2단:
--     B02 룩업1: 가로(mm) × 세로(mm) → 분류문자(A~E)        [면적→등급 압축]
--     B03 룩업2: 분류(A~E) × 수량구간(200,300,…) → 가격     [등급×수량→가격, 90셀]
--   t_prc_component_prices 6차원(siz/clr/mat/coat/bdl/min)에 **중간키 분류등급
--   슬롯 없음**. 직접 평면화하면:
--     · 옵션A(mat_cd 차용): 자재축에 등급 오용 + 면적→등급 매핑 둘 자리 없음
--     · 옵션B(면적 직접 siz): 셀 폭증(13면적×18수량=234, 원본90의 2.6배)·압축의도 소실
--   → round-2가 억지평면화 거부·에스컬레이션한 정당 GAP. 무손실엔 (1)면적→등급
--      룩업 테이블 + (2)가격그리드의 등급 차원이 둘 다 필요.

-- ---------------------------------------------------------------------
-- forward (적용)
-- ---------------------------------------------------------------------

-- (1) 박 분류등급 코드그룹 — A~E(소형)/A~I(대형). t_cod_base_codes 코드행.
--     ※ 코드행이라 DDL 아님 — code-row 선적재로 다룸. 그룹 존재만 가정.
-- INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn) VALUES
--   ('FOIL_GRADE', '박분류등급', NULL, NULL, 'Y'),
--   ('FOIL_GRADE.A','A','FOIL_GRADE',1,'Y'),
--   ('FOIL_GRADE.B','B','FOIL_GRADE',2,'Y'),
--   ('FOIL_GRADE.C','C','FOIL_GRADE',3,'Y'),
--   ('FOIL_GRADE.D','D','FOIL_GRADE',4,'Y'),
--   ('FOIL_GRADE.E','E','FOIL_GRADE',5,'Y');
--   -- 대형 추가분 F~I: 라이브 등급집합 확정 후 동일 패턴.

-- (2) 면적→분류등급 룩업1 — 박 가공비 면적구간을 등급으로 압축하는 중간 룩업.
--     기존 스키마 어디에도 자리 없던 "룩업1"의 정규 정착지.
--     comp_cd로 박종 그룹(소형/대형 박 가공비)을 구분.
CREATE TABLE IF NOT EXISTS t_prc_foil_area_grades (
  comp_cd       VARCHAR(50)   NOT NULL,                 -- → t_prc_price_components (박 가공비 comp)
  width_from    NUMERIC(10,2) NOT NULL,                 -- 가로 구간 하한(mm)
  width_to      NUMERIC(10,2) NOT NULL,                 -- 가로 구간 상한(mm)
  height_from   NUMERIC(10,2) NOT NULL,                 -- 세로 구간 하한(mm)
  height_to     NUMERIC(10,2) NOT NULL,                 -- 세로 구간 상한(mm)
  grade_cd      VARCHAR(50)   NOT NULL,                 -- → t_cod_base_codes (FOIL_GRADE.*)
  note          VARCHAR(500),
  use_yn        CHAR(1) NOT NULL DEFAULT 'Y',
  reg_dt        TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  upd_dt        TIMESTAMP WITHOUT TIME ZONE,
  CONSTRAINT pk_t_prc_foil_area_grades   PRIMARY KEY (comp_cd, width_from, height_from),
  CONSTRAINT ck_t_prc_foil_area_use_yn   CHECK (use_yn IN ('Y','N')),
  CONSTRAINT ck_t_prc_foil_area_w_range  CHECK (width_to  >= width_from),
  CONSTRAINT ck_t_prc_foil_area_h_range  CHECK (height_to >= height_from),
  CONSTRAINT fk_t_prc_foil_area_comp_cd  FOREIGN KEY (comp_cd)
             REFERENCES t_prc_price_components (comp_cd),
  CONSTRAINT fk_t_prc_foil_area_grade_cd FOREIGN KEY (grade_cd)
             REFERENCES t_cod_base_codes (cod_cd)
);

-- (3) 룩업2 = 등급×수량→가격 = t_prc_component_prices 재사용 + 등급 차원 1개 추가.
--     6차원은 그대로 두고 nullable grade_cd 7번째 키만 추가(사다리 2단계).
--     기존 행 전부 grade_cd=NULL(차원 무관) → 기존 적재본 무영향.
--     박 가격그리드: comp_cd=박종, grade_cd=A~E, min_qty=수량구간 → unit_price.
ALTER TABLE t_prc_component_prices
  ADD COLUMN IF NOT EXISTS grade_cd VARCHAR(50);

ALTER TABLE t_prc_component_prices
  ADD CONSTRAINT fk_prc_comp_prices_grade_cd
      FOREIGN KEY (grade_cd) REFERENCES t_cod_base_codes (cod_cd);
  -- ※ 이미 존재 시 중복 추가 방지: 적용 전 pg_constraint 확인 (멱등 적용은
  --    DO $$ ... IF NOT EXISTS ... $$ 블록으로 감쌀 수 있음 — apply 시점 후니 재량).

-- ---------------------------------------------------------------------
-- rollback (되돌리기)
-- ---------------------------------------------------------------------
-- ALTER TABLE t_prc_component_prices DROP CONSTRAINT IF EXISTS fk_prc_comp_prices_grade_cd;
-- ALTER TABLE t_prc_component_prices DROP COLUMN IF EXISTS grade_cd;
-- DROP TABLE IF EXISTS t_prc_foil_area_grades;
-- (FOIL_GRADE 코드행은 코드행 선적재 롤백으로 별도 제거)

-- ---------------------------------------------------------------------
-- 적용 순서 (round-5 apply_price.sql 대비):
--   step -2 : FOIL_GRADE 코드그룹/코드행 (code-row 선적재)
--   step -1 : 본 DDL (CREATE t_prc_foil_area_grades + ALTER component_prices)
--   step  0 : t_prc_foil_area_grades 룩업1 행 (면적→등급, 13구간)
--   step  N : t_prc_component_prices 박 가격그리드 행 (등급×수량, 90셀 — grade_cd 채움)
-- 기존 행 영향: ADD COLUMN … NULL → 기존 component_prices 무영향(차원 무관).
-- FK 영향: 신규 FK 부모(comp/grade) 선존재. 고아 0.
-- ⚠ 동판비(B01, 가로×세로→단가 2D)는 ADEQUATE — 본 GAP과 별개로 기존 6차원
--    (siz_cd=면적좌표·min_qty)로 즉시 평면화 가능(등급축 불요). 본 제안 범위 밖.
-- =====================================================================
