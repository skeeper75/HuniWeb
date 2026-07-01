-- calendar-fix-dryrun.sql — 캘린더 제본비 배선 (DRY-RUN: BEGIN ... ROLLBACK)
-- 대상: 108 탁상형·109 미니탁상형(제본비 신규 배선) + 110 엽서캘린더(base 공식 배선)
-- 111/112(벽걸이/와이드)는 이중권위 BLOCKED — 이 스크립트에서 제외(무변경)
-- 실 COMMIT 금지. 멱등(ON CONFLICT/NOT EXISTS). 인간 승인 후 별도 -fix.sql로.
\set ON_ERROR_STOP on
BEGIN;

-- (1) 신규 캘린더-탁상형 전용 공식 (PRF_DGP_CAL_WIDE 동형, 제본만 CAL_WALL로 교체)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
VALUES ('PRF_DGP_CAL_DESK', '디지털인쇄 원자합산형-탁상형캘린더(캘린더제본)',
        '탁상/미니탁상 캘린더: 인쇄비+용지비+캘린더제본비(COMP_BIND_CAL_WALL). 260701 배선', 'Y', now())
ON CONFLICT (frm_cd) DO NOTHING;

-- (2) 공식 구성요소 3종 (인쇄 seq0 + 용지 seq1 + 캘린더제본 seq2), 전부 addtn_yn=Y
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES
  ('PRF_DGP_CAL_DESK','COMP_PRINT_DIGITAL_S1',0,'Y',now()),
  ('PRF_DGP_CAL_DESK','COMP_PAPER',1,'Y',now()),
  ('PRF_DGP_CAL_DESK','COMP_BIND_CAL_WALL',2,'Y',now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- (3) 상품별 제본 공정 등록 (group PROC_000017 내 정확히 1개만 — 이중합산 방지)
--     108 탁상형(220) → PROC_000100(탁상220) / 109 미니 → PROC_000102(미니)
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt) VALUES
  ('PRD_000108','PROC_000100','N',2,now()),
  ('PRD_000109','PROC_000102','N',2,now())
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;

-- (4) 108/109 공식 재바인딩 (PRF_DGP_INNER → PRF_DGP_CAL_DESK)
UPDATE t_prd_product_price_formulas
   SET frm_cd='PRF_DGP_CAL_DESK',
       note='탁상형캘린더(220) -- 인쇄+용지+캘린더제본(CAL_WALL/PROC_000100) 배선 260701',
       upd_dt=now()
 WHERE prd_cd='PRD_000108' AND apply_bgn_ymd='2026-07-01';
UPDATE t_prd_product_price_formulas
   SET frm_cd='PRF_DGP_CAL_DESK',
       note='미니탁상형캘린더 -- 인쇄+용지+캘린더제본(CAL_WALL/PROC_000102) 배선 260701',
       upd_dt=now()
 WHERE prd_cd='PRD_000109' AND apply_bgn_ymd='2026-07-01';

-- (5) 110 엽서캘린더 base 공식 배선 (인쇄+용지, 단면·재단만·제본없음) — 견적0 해소
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
VALUES ('PRD_000110','PRF_DGP_INNER','2026-07-01',
        '엽서캘린더 -- 인쇄+용지 base 배선(단면·재단만·제본없음) 260701', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- === 사후 검증 (트랜잭션 내) ===
\echo '--- 검증1: 공식/구성요소 ---'
SELECT fc.frm_cd, fc.comp_cd, fc.disp_seq, pc.comp_nm
  FROM t_prc_formula_components fc JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
 WHERE fc.frm_cd='PRF_DGP_CAL_DESK' ORDER BY fc.disp_seq;
\echo '--- 검증2: 108/109/110 바인딩 ---'
SELECT prd_cd, frm_cd, apply_bgn_ymd FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000108','PRD_000109','PRD_000110') ORDER BY prd_cd;
\echo '--- 검증3: 108/109 제본 공정(group 000017 내 1개인지) ---'
SELECT pp.prd_cd, pp.proc_cd, p.proc_nm FROM t_prd_product_processes pp
  JOIN t_proc_processes p ON p.proc_cd=pp.proc_cd
 WHERE pp.prd_cd IN ('PRD_000108','PRD_000109') AND p.upr_proc_cd='PROC_000017' AND pp.del_yn='N'
 ORDER BY pp.prd_cd;
\echo '--- 검증4: 108 제본 단가행 매칭(PROC_000100 밴드) ---'
SELECT proc_cd, min_qty, unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_BIND_CAL_WALL' AND proc_cd='PROC_000100' ORDER BY min_qty;

COMMIT;
\echo '=== ROLLBACK 완료 — 실제 변경 없음 ==='
