-- =====================================================================
-- DDL PROPOSAL: 디자인 입력 채널 (V-10, 메타모델 #16)
--   (PROPOSAL ONLY — DO NOT APPLY without human approval. RP-Meta TP v3.0)
-- Closes vessel-gap: _workspace/huni-rpmeta/04_vessel/vessel-design-input-channel.md
--   unblock: TP 23상품 + 전 카테고리 editor_yn=Y 107상품 (디자인 입력 채널 메타)
-- =====================================================================
-- search-before-mint 요약 (상세 .md vessel-design-input-channel §1):
--   라이브 t_prd_products = editor_yn·file_upload_yn 불리언 2개뿐(CHAR(1) CHECK).
--   분포 Y/Y=104·Y/N=3·N/Y=91·N/N=49. 2-불리언(4셀)은 RP item_gbn 3분기·
--   에디터종류(KOI/Edicus/RP)·리소스ID·VDP·ord_cnt 출처 5 의미축을 무손실 못담음
--   (Y/Y 셀에 KOI+PDF와 Edicus가 충돌). base_code 16그룹에 에디터 채널 enum 0건.
--   → 사다리: ① base_code 그룹 + ② 상품 컬럼 4(NULL). 채널은 상품 1:1 → 테이블 mint 거부.
--   (시안 자산은 1:N → 별 테이블 = V-11 ddl-proposal-template-asset.sql)

-- ---------------------------------------------------------------------
-- forward (적용)
-- ---------------------------------------------------------------------

-- (1) 코드그룹 3개 — RP item_gbn/에디터종류/ord_cnt 출처 모델 흡수(후니 코드로).
--     ※ 코드행 INSERT = 코드행 선적재(후니 승인). reg_dt NOT NULL → 명시 또는 DEFAULT.
--     라이브 코드그룹 컨벤션(부모 upr_cod_cd=NULL + 자식 <GROUP>.NN·disp_seq) 추종.
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, del_yn, reg_dt) VALUES
  ('DESIGN_INPUT_CHANNEL',    '디자인입력채널',  NULL,                   1, 'Y','N', now()),
  ('DESIGN_INPUT_CHANNEL.01', '웹에디터',        'DESIGN_INPUT_CHANNEL', 1, 'Y','N', now()),
  ('DESIGN_INPUT_CHANNEL.02', '파일업로드',      'DESIGN_INPUT_CHANNEL', 2, 'Y','N', now()),
  ('DESIGN_INPUT_CHANNEL.03', '에디터+업로드',   'DESIGN_INPUT_CHANNEL', 3, 'Y','N', now()),
  ('EDITOR_KIND',    '에디터종류',  NULL,          1, 'Y','N', now()),
  ('EDITOR_KIND.01', 'KOI',        'EDITOR_KIND', 1, 'Y','N', now()),
  ('EDITOR_KIND.02', 'Edicus',     'EDITOR_KIND', 2, 'Y','N', now()),
  ('EDITOR_KIND.03', 'RedEditor',  'EDITOR_KIND', 3, 'Y','N', now()),
  ('ORD_CNT_SOURCE',    '디자인수산정출처', NULL,             1, 'Y','N', now()),
  ('ORD_CNT_SOURCE.01', '에디터',          'ORD_CNT_SOURCE', 1, 'Y','N', now()),
  ('ORD_CNT_SOURCE.02', '업로드파일',      'ORD_CNT_SOURCE', 2, 'Y','N', now());

-- (2) 상품에 채널 매다는 슬롯 — ADD COLUMN NULL(백필 0·무잠금). editor_yn/file_upload_yn 유지(보강).
ALTER TABLE t_prd_products ADD COLUMN design_input_channel_cd VARCHAR(50) NULL;
ALTER TABLE t_prd_products ADD COLUMN editor_kind_cd          VARCHAR(50) NULL;
ALTER TABLE t_prd_products ADD COLUMN ord_cnt_source_cd       VARCHAR(50) NULL;
ALTER TABLE t_prd_products ADD COLUMN vdp_yn                  CHAR(1)     NULL;

ALTER TABLE t_prd_products ADD CONSTRAINT ck_t_prd_products_vdp_yn
  CHECK (vdp_yn IS NULL OR vdp_yn IN ('Y','N'));
ALTER TABLE t_prd_products ADD CONSTRAINT fk_t_prd_products_dic_cd
  FOREIGN KEY (design_input_channel_cd) REFERENCES t_cod_base_codes (cod_cd);
ALTER TABLE t_prd_products ADD CONSTRAINT fk_t_prd_products_editor_kind_cd
  FOREIGN KEY (editor_kind_cd) REFERENCES t_cod_base_codes (cod_cd);
ALTER TABLE t_prd_products ADD CONSTRAINT fk_t_prd_products_ord_cnt_src_cd
  FOREIGN KEY (ord_cnt_source_cd) REFERENCES t_cod_base_codes (cod_cd);

COMMENT ON COLUMN t_prd_products.design_input_channel_cd IS '디자인입력채널(DESIGN_INPUT_CHANNEL): 웹에디터/파일업로드/병행. editor_yn 세분 보강.';
COMMENT ON COLUMN t_prd_products.editor_kind_cd          IS '에디터종류(EDITOR_KIND): KOI/Edicus/RedEditor. 채널=웹에디터/병행일 때.';
COMMENT ON COLUMN t_prd_products.ord_cnt_source_cd       IS '디자인수(ORD_CNT) 산정 출처(ORD_CNT_SOURCE): 에디터/업로드파일. 수량모델 게이팅.';
COMMENT ON COLUMN t_prd_products.vdp_yn                  IS '가변데이터(VDP) 가능 여부(명함/상장). NULL=미설정.';

-- ---------------------------------------------------------------------
-- rollback (되돌리기) — 백필값 백업 권고
-- ---------------------------------------------------------------------
-- ALTER TABLE t_prd_products DROP CONSTRAINT fk_t_prd_products_ord_cnt_src_cd;
-- ALTER TABLE t_prd_products DROP CONSTRAINT fk_t_prd_products_editor_kind_cd;
-- ALTER TABLE t_prd_products DROP CONSTRAINT fk_t_prd_products_dic_cd;
-- ALTER TABLE t_prd_products DROP CONSTRAINT ck_t_prd_products_vdp_yn;
-- ALTER TABLE t_prd_products DROP COLUMN vdp_yn;
-- ALTER TABLE t_prd_products DROP COLUMN ord_cnt_source_cd;
-- ALTER TABLE t_prd_products DROP COLUMN editor_kind_cd;
-- ALTER TABLE t_prd_products DROP COLUMN design_input_channel_cd;
-- (DESIGN_INPUT_CHANNEL·EDITOR_KIND·ORD_CNT_SOURCE 코드행은 use_yn='N'으로 별도)

-- ---------------------------------------------------------------------
-- 적용 순서:
--   step -1 : 코드그룹/코드행 (1) (code-row 선적재·후니 승인)
--   step  0 : 본 DDL ALTER (2)  ← 인간 승인 후
--   step  1 : 백필 UPDATE (channel/ord_cnt/vdp — dbmap 적재 트랙; 에디터종류=RP 실측 후)
--             정합 규칙: editor_yn='Y' ⇒ design_input_channel_cd ∈ {.01,.03}
-- 기존 행 영향: ADD COLUMN NULL = 275상품·107 editor_yn=Y 무파손·무잠금.
-- FK 영향: 부모 t_cod_base_codes 선존재. 고아 0.
-- ⚠ editor_yn 폐기 여부·VDP 변수 스키마 본문·에디터종류 백필 출처 = open decision(.md §6).
-- =====================================================================
