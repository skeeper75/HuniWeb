-- ============================================================
-- 01  물리 백업 (COMMIT 직전 실행 · 영향 3테이블 전 관련행 스냅샷)
--   ★COMMIT 실행 직전 동일 세션/직전에 반드시 먼저 실행. undo(04)가 이 백업을 참조.
--   백업은 물리 테이블(CREATE TABLE AS). 재실행 시 DROP 후 재생성(멱등).
-- 대상: t_prc_price_components(멤버26) · t_prc_component_prices(멤버26 단가행) · t_prc_formula_components(12 PRF 전 배선)
-- ============================================================

-- 멤버 26종(22 명함 + 4 PCB) 카탈로그 백업 (undo=use_yn/del_yn/note 복원용)
DROP TABLE IF EXISTS z_bak_mcmerge_price_components;
CREATE TABLE z_bak_mcmerge_price_components AS
SELECT * FROM t_prc_price_components
WHERE comp_cd IN (
 'COMP_NAMECARD_PREMIUM_S1_MGA','COMP_NAMECARD_PREMIUM_S1_MGB','COMP_NAMECARD_PREMIUM_S2_MGA','COMP_NAMECARD_PREMIUM_S2_MGB',
 'COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S1_HOLO','COMP_NAMECARD_FOIL_S2_STD','COMP_NAMECARD_FOIL_S2_HOLO',
 'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL','COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL',
 'COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_NAMECARD_COAT_S1','COMP_NAMECARD_COAT_S2',
 'COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2','COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2',
 'COMP_NAMECARD_MINISHAPE_S1','COMP_NAMECARD_MINISHAPE_S2',
 'COMP_PCB_S1_20P','COMP_PCB_S1_30P','COMP_PCB_S2_20P','COMP_PCB_S2_30P');

-- 멤버 26종 단가행 백업 (undo=comp_cd 재지정 복원용·PK=comp_price_id)
DROP TABLE IF EXISTS z_bak_mcmerge_component_prices;
CREATE TABLE z_bak_mcmerge_component_prices AS
SELECT * FROM t_prc_component_prices
WHERE comp_cd IN (
 'COMP_NAMECARD_PREMIUM_S1_MGA','COMP_NAMECARD_PREMIUM_S1_MGB','COMP_NAMECARD_PREMIUM_S2_MGA','COMP_NAMECARD_PREMIUM_S2_MGB',
 'COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S1_HOLO','COMP_NAMECARD_FOIL_S2_STD','COMP_NAMECARD_FOIL_S2_HOLO',
 'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL','COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL',
 'COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_NAMECARD_COAT_S1','COMP_NAMECARD_COAT_S2',
 'COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2','COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2',
 'COMP_NAMECARD_MINISHAPE_S1','COMP_NAMECARD_MINISHAPE_S2',
 'COMP_PCB_S1_20P','COMP_PCB_S1_30P','COMP_PCB_S2_20P','COMP_PCB_S2_30P');

-- 12 PRF 전 배선 백업 (undo=disp_seq·멤버배선 복원용)
DROP TABLE IF EXISTS z_bak_mcmerge_formula_components;
CREATE TABLE z_bak_mcmerge_formula_components AS
SELECT * FROM t_prc_formula_components
WHERE frm_cd IN ('PRF_PCB_FIXED','PRF_NAMECARD_PREMIUM','PRF_NAMECARD_PREMIUM_FOIL','PRF_NAMECARD_FOIL',
 'PRF_NAMECARD_WHITE','PRF_NAMECARD_FIXED','PRF_NAMECARD_FIXED_FOIL','PRF_NAMECARD_COAT',
 'PRF_NAMECARD_PEARL','PRF_NAMECARD_PEARL_FOIL','PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE');

-- 백업 검증 (라이브 실측 2026-07-04 기대값):
--   price_components=26 · component_prices=913(명함94 + PCB819[468+117*3]) · formula_components=48
SELECT 'BAK price_components 행수(26기대)' lbl, COUNT(*) FROM z_bak_mcmerge_price_components;
SELECT 'BAK component_prices 행수(913기대)' lbl, COUNT(*) FROM z_bak_mcmerge_component_prices;
SELECT 'BAK formula_components 행수(48기대)' lbl, COUNT(*) FROM z_bak_mcmerge_formula_components;
-- ↑ CREATE TABLE AS 는 트랜잭션 밖에서 즉시 영속(백업이므로 정상). COMMIT SQL 은 별도 파일에서 실행.
