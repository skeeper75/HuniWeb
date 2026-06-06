-- 00_prc_component_type.sql
-- 단계00 코드행 선적재 — PK pk_t_cod_base_codes(cod_cd). 후니 등록 대기 코드값 1행.
-- 생성: gen_load_sql.py (손편집 금지). 멱등: ON CONFLICT 가드.
-- BEGIN/COMMIT 미포함 — apply.sql 가 트랜잭션 래핑.

-- src: 00_prc_component_type.csv:row2 cod_cd=PRC_COMPONENT_TYPE.06
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, note)
VALUES ('PRC_COMPONENT_TYPE.06', '완제품비', 'PRC_COMPONENT_TYPE', 6, 'Y', 'D-D 확정 신설(규칙⑩·AWK-7 해소). 완제품 통가격(비분해) 가격구성요소 유형. FK 부모 선행(t_prc_price_components보다 선적재). PRD_TYPE.01 완제품(상품분류)과 별개 축. 봉투제작 COMP_ENV_MAKING이 사용')
ON CONFLICT (cod_cd) DO NOTHING;
