-- acryl-163-minipart-pending-fix.sql — 163 미니파츠 단가 미정 시그널 적재 (코드 수정 0·DB only·라이브 COMMIT 후보)
-- 배경: 미니파츠 120x50 단가가 권위(상품마스터 가격칸 빈칸·가격표 미니파츠 블록 없음·1.5T 격자 100까지 120 격자밖)에 부재.
--   → 임의 단가 금지(돈크리티컬). 대신 "단가 미정·실무진 확인필요" 시그널을 DB로 적재해 가격시뮬레이터가 표시하게 함.
-- 동작: 단가행 없는 구성요소(comp_nm=메시지) → 시뮬레이터가 "제외·데이터 없음"으로 그 메시지를 노출.
-- 실무진 확정 후 = 단가행 1줄만 추가(INSERT t_prc_component_prices siz_cd=SIZ_000365·unit_price=확정가) → 즉시 작동. 구조/코드 변경 0.
-- 멱등 NOT EXISTS. ★실 COMMIT은 인간 승인 후·라이브 시뮬레이터 실증.
\set ON_ERROR_STOP on
BEGIN;

-- [1] 단가 미정 구성요소 (단가행 없음 = 시뮬레이터 "데이터 없음" 시그널 · comp_nm=메시지)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn)
SELECT 'COMP_ACRYL_MINIPART_TBD',
       '미니파츠 단가 미정 · 실무진 확인필요 (120x50 가격표 격자밖)',
       'PRC_COMPONENT_TYPE.01','PRICE_TYPE.02', jsonb_build_array('siz_cd','min_qty'),'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_MINIPART_TBD');

-- [2] 전용공식 (frm_nm·note에 사유 명시 — 시뮬레이터 공식명 노출)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT 'PRF_ACRYL_MINIPART','아크릴미니파츠 공식 (★단가 확인필요)',
       '120x50이 가격표 투명1.5T 격자(20~100) 밖·상품마스터 가격칸 빈칸 → 실무진 단가 확정 후 COMP_ACRYL_MINIPART_TBD 단가행(siz_cd=SIZ_000365) 추가하면 작동','Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_ACRYL_MINIPART');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_ACRYL_MINIPART','COMP_ACRYL_MINIPART_TBD',1,'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_MINIPART' AND comp_cd='COMP_ACRYL_MINIPART_TBD');

-- [3] 163 바인딩 (견적 시도 시 시뮬레이터가 단가미정 메시지 노출)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000163','PRF_ACRYL_MINIPART','2026-06-28','단가 미정 시그널(실무진 확인 후 단가행 추가)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000163' AND frm_cd='PRF_ACRYL_MINIPART');

COMMIT;
