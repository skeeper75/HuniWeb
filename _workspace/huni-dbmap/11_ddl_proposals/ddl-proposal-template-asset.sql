-- =====================================================================
-- DDL PROPOSAL: 디자인 시안 자산 (V-11, TemplateAsset · 메타모델 #4↔#16 분리)
--   (PROPOSAL ONLY — DO NOT APPLY without human approval. RP-Meta TP v3.0)
-- Closes vessel-gap: _workspace/huni-rpmeta/04_vessel/vessel-template-asset.md
--   unblock: TP 디자인 시안 보유 상품 + use_template_download 게이팅(V-10 종속)
-- =====================================================================
-- search-before-mint 요약 (상세 .md vessel-template-asset §1):
--   라이브 t_prd_templates(12행) = 완제SKU(봉투 OTC·base_prd_cd·dflt_qty·template_prices 개당가).
--   TP "템플릿"(koi_template_resource_id·가격0·SDK getTemplateList) = 에디터 디자인 시안.
--   ★같은 단어 다른 의미 — t_prd_templates 흡수 금지(가격0 시안을 주문SKU로 오모델 = 이중의미 오염,
--   dictionary #4 [HARD]·dbmap-schema-design-intent-first 동형 위험).
--   시안은 상품 1:N·독립 lifecycle·가격0 → 컬럼/jsonb 환원 불가 → 신규 테이블 mint 정당.
--   (V-10 채널은 1:1이라 컬럼에서 멈춤; 본 시안 자산만 테이블 = 본 하네스 유일 mint)

-- ---------------------------------------------------------------------
-- forward (적용)
-- ---------------------------------------------------------------------

-- (1) 디자인 시안 자산 마스터 — 완제SKU와 물리 분리(오염 차단). 가격 컬럼 없음(가격0).
CREATE TABLE IF NOT EXISTS t_prd_template_assets (
  tmpl_asset_cd        VARCHAR(50)  NOT NULL,            -- PK, TASSET_NNNNNN
  tmpl_asset_nm        VARCHAR(200) NOT NULL,            -- 시안 이름
  editor_kind_cd       VARCHAR(50),                      -- → t_cod_base_codes(EDITOR_KIND.*) V-10 공유
  template_resource_id VARCHAR(200),                     -- 에디터 리소스 포인터(RP koi_template_resource_id)
  asset_options_json   JSONB,                            -- 시안 옵션(RP koiOption[]). 가변 → jsonb
  vdp_yn               CHAR(1) NOT NULL DEFAULT 'N',     -- 이 시안 VDP 변수 슬롯 보유(명함/상장)
  note                 VARCHAR(500),
  use_yn               CHAR(1) NOT NULL DEFAULT 'Y',
  del_yn               CHAR(1) NOT NULL DEFAULT 'N',
  del_dt               TIMESTAMP WITHOUT TIME ZONE,
  reg_dt               TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  upd_dt               TIMESTAMP WITHOUT TIME ZONE,
  CONSTRAINT pk_t_prd_template_assets       PRIMARY KEY (tmpl_asset_cd),
  CONSTRAINT ck_t_prd_tmpl_asset_use_yn     CHECK (use_yn IN ('Y','N')),
  CONSTRAINT ck_t_prd_tmpl_asset_del_yn     CHECK (del_yn IN ('Y','N')),
  CONSTRAINT ck_t_prd_tmpl_asset_vdp_yn     CHECK (vdp_yn IN ('Y','N')),
  CONSTRAINT fk_t_prd_tmpl_asset_editor_cd  FOREIGN KEY (editor_kind_cd)
             REFERENCES t_cod_base_codes (cod_cd)
);

-- (2) 상품↔시안 연결 (1:N) — t_prd_templates.base_prd_cd 완제SKU 링크와 평행·의미 분리.
CREATE TABLE IF NOT EXISTS t_prd_product_template_assets (
  prd_cd         VARCHAR(50) NOT NULL,                   -- → t_prd_products
  tmpl_asset_cd  VARCHAR(50) NOT NULL,                   -- → t_prd_template_assets
  dflt_yn        CHAR(1) NOT NULL DEFAULT 'N',           -- 기본 노출 시안
  disp_seq       INTEGER,                                -- 갤러리 노출순
  reg_dt         TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  upd_dt         TIMESTAMP WITHOUT TIME ZONE,
  del_yn         CHAR(1) NOT NULL DEFAULT 'N',
  del_dt         TIMESTAMP WITHOUT TIME ZONE,
  CONSTRAINT pk_t_prd_product_template_assets  PRIMARY KEY (prd_cd, tmpl_asset_cd),
  CONSTRAINT ck_t_prd_prd_tasset_dflt_yn       CHECK (dflt_yn IN ('Y','N')),
  CONSTRAINT ck_t_prd_prd_tasset_del_yn        CHECK (del_yn  IN ('Y','N')),
  CONSTRAINT fk_t_prd_prd_tasset_prd_cd        FOREIGN KEY (prd_cd)
             REFERENCES t_prd_products (prd_cd),
  CONSTRAINT fk_t_prd_prd_tasset_asset_cd      FOREIGN KEY (tmpl_asset_cd)
             REFERENCES t_prd_template_assets (tmpl_asset_cd)
);

-- ---------------------------------------------------------------------
-- rollback (되돌리기)
-- ---------------------------------------------------------------------
-- DROP TABLE IF EXISTS t_prd_product_template_assets;
-- DROP TABLE IF EXISTS t_prd_template_assets;

-- ---------------------------------------------------------------------
-- 적용 순서:
--   step -1 : EDITOR_KIND 코드행 (V-10 ddl-proposal-design-input-channel.sql (1)) ← 선행(FK)
--   step  0 : 본 DDL (CREATE TABLE x2)   ← 인간 승인 후
--   step  1 : t_prd_template_assets 시안 마스터 행 (후니 에디터 카탈로그 확정 후·발명 금지)
--   step  2 : t_prd_product_template_assets 연결 행 (TP 시안 보유 상품)
-- 기존 행 영향: 신규 테이블 — t_prd_templates(12행 봉투SKU)·template_prices·products 무영향.
--             ★완제SKU 순수성 보존(이중의미 오염 차단 = 본 vessel 핵심 목적).
-- FK 영향: 부모(t_prd_products·t_cod_base_codes·t_prd_template_assets) 선존재. 고아 0.
--          EDITOR_KIND 코드행(V-10) 선행 필수.
-- ⚠ 시안 데이터·VDP 변수 본문 = open decision(.md §6, 후니 카탈로그 권위·발명 금지).
-- =====================================================================
