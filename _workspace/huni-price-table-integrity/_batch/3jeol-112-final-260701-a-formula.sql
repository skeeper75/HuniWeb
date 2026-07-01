-- 112(와이드벽걸이캘린더) 가격공식 배선 -- 2026-07-01
-- 라이브 등록공정 PROC_000021(트윈링제본)과 정확히 일치하는 기존 컴포넌트 COMP_BIND_TWINRING
-- (§23 셋트상품 PRD_000071 무선내지 제본에서 이미 검증되어 쓰이는 범용 제본비 컴포넌트) 재사용.
-- 용지/인쇄 3절(SIZ_000475) 단가는 049 작업 때 이미 공유 테이블에 적재 완료(추가 불요).
-- PRF_DGP_INNER(용지+인쇄) 구조에 COMP_BIND_TWINRING만 추가 -- search-before-mint, 신규 컴포넌트 mint 0.
BEGIN;
INSERT INTO t_prc_price_formulas (frm_cd,frm_nm,note,use_yn,reg_dt)
SELECT 'PRF_DGP_CAL_WIDE','디지털인쇄 원자합산형-와이드벽걸이캘린더(트윈링)',
       'PRF_DGP_INNER(용지+인쇄) + COMP_BIND_TWINRING(트윈링제본·PROC_000021 매칭). 260701 와이드벽걸이캘린더(112) 전용 신설.','Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_CAL_WIDE');

INSERT INTO t_prc_formula_components (frm_cd,comp_cd,addtn_yn,disp_seq)
SELECT v.frm_cd, v.comp_cd, v.addtn_yn, v.disp_seq FROM (VALUES
  ('PRF_DGP_CAL_WIDE','COMP_PRINT_DIGITAL_S1','Y',0),
  ('PRF_DGP_CAL_WIDE','COMP_PAPER','Y',1),
  ('PRF_DGP_CAL_WIDE','COMP_BIND_TWINRING','Y',2)
) AS v(frm_cd,comp_cd,addtn_yn,disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components x WHERE x.frm_cd=v.frm_cd AND x.comp_cd=v.comp_cd);

INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note,reg_dt)
SELECT 'PRD_000112','PRF_DGP_CAL_WIDE','2026-07-01','3절 판형이관+트윈링제본 공식 신설 260701',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000112');
COMMIT;
