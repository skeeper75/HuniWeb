-- 111(국4절 벽걸이캘린더)·108(탁상형220)·109(미니탁상형) 가격공식 배선 -- 2026-07-01
-- 전부 국4절(SIZ_000499) 표준판형 -- 용지/인쇄 단가는 이미 22개 타상품에서 검증되어 라이브 존재(신규 적재 0건).
-- 111: 등록공정 PROC_000021(트윈링제본)이 112와 동일 -- 112용으로 신설한 PRF_DGP_CAL_WIDE(용지+인쇄+COMP_BIND_TWINRING) 그대로 재사용.
-- 108/109: 등록된 공정은 수축포장뿐, 스탠드(삼각대 MAT_000252/254)·링(MAT_000253) 가격 데이터가 라이브 어디에도 없어
--          날조 없이 반영 불가 -- 용지+인쇄만(PRF_DGP_INNER, 기존 6개 상품에서 이미 검증된 공식) 재사용.
--          스탠드/링 단가는 별도 권위 확인 후 보강 대상(미마무리 항목으로 남김).
BEGIN;
-- PRF_DGP_CAL_WIDE 설명을 112 전용에서 범용으로 갱신(재사용 반영)
UPDATE t_prc_price_formulas
   SET note='PRF_DGP_INNER(용지+인쇄) + COMP_BIND_TWINRING(트윈링제본·PROC_000021 매칭). 260701 와이드벽걸이캘린더(112)+벽걸이캘린더(111) 공용.',
       upd_dt=now()
 WHERE frm_cd='PRF_DGP_CAL_WIDE';

INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note,reg_dt)
SELECT 'PRD_000111','PRF_DGP_CAL_WIDE','2026-07-01','국4절 벽걸이캘린더 -- 트윈링제본 공식 배선(112와 공용) 260701',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000111');

INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note,reg_dt)
SELECT 'PRD_000108','PRF_DGP_INNER','2026-07-01','탁상형캘린더(220) -- 용지+인쇄 base 공식 배선(스탠드비는 권위 미확보로 보류) 260701',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000108');

INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note,reg_dt)
SELECT 'PRD_000109','PRF_DGP_INNER','2026-07-01','미니탁상형캘린더 -- 용지+인쇄 base 공식 배선(스탠드비는 권위 미확보로 보류) 260701',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000109');
COMMIT;
