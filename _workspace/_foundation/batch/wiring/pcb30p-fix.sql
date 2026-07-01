-- =============================================================================
-- pcb30p-fix.sql  (실 COMMIT본 — 인간 승인 하 2026-07-01)
-- 엽서북30p PRD_000094 — 30P 고아 배선 + 페이지 판별 선택수단(opt_cd)
-- 설계: design-pcb30p-fix-260701.md (E1/E2/E6 PASS·codex 검토·3차 재진단 확정)
-- dryrun 실증: design-pcb30p-fix-dryrun.sql (멱등·검증1~4 통과·골든단가 6/6 verbatim)
-- 백엔드 경로 검증: pricing.py:920(set_selections→evaluate_price)·price_views.py:1921(passthrough)
--   ·1333-1368(sim_meta opt_grp 스코프→opt_cd 드롭다운) 코드 확인 완료.
-- 채번 라이브 재확인(260701): MAX opt_grp=OPT_000081·MAX opt_cd=OPV_000490 → 082/491/492 free.
-- undo = pcb30p-undo.sql · use_dims 백업 = pcb30p-usedims-backup-260701.tsv
-- =============================================================================
BEGIN;

-- [순서1] 선택수단 — 페이지수 옵션그룹 + 옵션값(dflt=20P·mand_yn=Y → 위젯 사전선택→20p 회귀0)
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000094','OPT_000082','페이지수','SEL_TYPE.01',1,1,'Y',7,'Y','N',
       '엽서북 페이지수 택1 필수(20P/30P·dflt=20P). 30p 견적 활성화·opt_cd 판별 선택수단. 채번082=명함080/081 회피. §27 배선 260701', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE opt_grp_cd='OPT_000082');

INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000094','OPV_000491','OPT_000082','20P','Y',1,'Y','N','엽서북 20페이지. 20P body 매칭(S1_20P/S2_20P). 기본 선택.', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_cd='OPV_000491');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000094','OPV_000492','OPT_000082','30P','N',2,'Y','N','엽서북 30페이지. 30P body 매칭(S1_30P/S2_30P).', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_cd='OPV_000492');

-- [순서2] 판별차원 충전 (단가값 불변·멱등 IS NULL 가드)
UPDATE t_prc_component_prices SET opt_cd='OPV_000491', upd_dt=now()
 WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P') AND opt_cd IS NULL;               -- 234행
UPDATE t_prc_component_prices SET opt_cd='OPV_000492', print_opt_cd='POPT_000001', upd_dt=now()
 WHERE comp_cd='COMP_PCB_S1_30P' AND opt_cd IS NULL;                                       -- 117행(단면)
UPDATE t_prc_component_prices SET opt_cd='OPV_000492', print_opt_cd='POPT_000002', upd_dt=now()
 WHERE comp_cd='COMP_PCB_S2_30P' AND opt_cd IS NULL;                                       -- 117행(양면)

-- [순서2b] use_dims 갱신 (opt_grp 스코프=UI 그리드용·엔진 매칭 무시)
UPDATE t_prc_price_components
   SET use_dims='["siz_cd", "min_qty", "print_opt_cd", "opt_cd", "opt_grp:OPT_000082"]', upd_dt=now()
 WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P','COMP_PCB_S1_30P','COMP_PCB_S2_30P');

-- [순서3] 배선 — PRF_PCB_FIXED ← 30P 2건(disjoint)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_PCB_FIXED','COMP_PCB_S1_30P',3,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_PCB_FIXED' AND comp_cd='COMP_PCB_S1_30P');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_PCB_FIXED','COMP_PCB_S2_30P',4,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_PCB_FIXED' AND comp_cd='COMP_PCB_S2_30P');

COMMIT;
