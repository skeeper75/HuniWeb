-- acryl-area-bind-fix.sql — 아크릴 157~162 면적공식 단일진실원 전환 (라이브 COMMIT)
-- 전제: 운영 배포 확정 — pricing.py _reduce_siz_dims(siz_cd→cut_width/cut_height 환원·L407)이
--       운영(HuniProductPrice2)에 반영됨. 따라서 등록사이즈(siz_cd) 모드 상품도 면적공식이 정답.
-- 처리: ① 157 임시 BYSIZ 데이터모델 전부 폐기(중복) ② 157~162 → PRF_CLR_ACRYL 바인딩(단일진실원=146 선례).
-- 검증: 13 등록사이즈 전부 ceiling 매칭→MAT_043 격자=권위가(9/9 셀 실재·SQL 충실재현 입증).
-- 단가값 0 변경(mint 0)·물리삭제는 임시모델 한정([HARD] 공유 마스터코드 미터치).
BEGIN;

-- 1) 157 임시 BYSIZ 데이터모델 폐기 (FK 위상: 바인딩→단가행→배선→공식→구성요소)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000157' AND frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_component_prices       WHERE comp_cd='COMP_ACRYL_3T_BYSIZ';
DELETE FROM t_prc_formula_components      WHERE frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_price_formulas          WHERE frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_price_components        WHERE comp_cd='COMP_ACRYL_3T_BYSIZ';

-- 2) 157~162 → PRF_CLR_ACRYL 바인딩 (멱등: 기존 동일행 제거 후 삽입)
DELETE FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000160','PRD_000161','PRD_000162')
   AND frm_cd='PRF_CLR_ACRYL';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note) VALUES
 ('PRD_000157','PRF_CLR_ACRYL','2026-06-27','아크릴네임택 — 면적공식 단일진실원(배포된 siz_cd 환원)'),
 ('PRD_000158','PRF_CLR_ACRYL','2026-06-27','아크릴 포카키링 — 면적공식 단일진실원'),
 ('PRD_000159','PRF_CLR_ACRYL','2026-06-27','아크릴 코스터 — 면적공식 단일진실원'),
 ('PRD_000160','PRF_CLR_ACRYL','2026-06-27','아크릴자유형스탠드 — 면적공식 단일진실원'),
 ('PRD_000161','PRF_CLR_ACRYL','2026-06-27','판아크릴 — 면적공식 단일진실원'),
 ('PRD_000162','PRF_CLR_ACRYL','2026-06-27','아크릴포카스탠드 — 면적공식 단일진실원');

COMMIT;
