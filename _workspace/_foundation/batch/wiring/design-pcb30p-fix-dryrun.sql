-- =============================================================================
-- design-pcb30p-fix-dryrun.sql
-- 엽서북30p PRD_000094 — NO-GO 폐루프 보정(페이지축 선택수단 교체)
-- 보정: gate-design-260701.md NO-GO + codex ISSUE-1/2.
--   D1 선택수단 무효  : option_items(ref_dim_cd='opt_cd' 무효) → t_prd_product_options(명함 패턴)
--   D2 20p 회귀 위험  : 페이지 옵션 dflt=20P·mand_yn=Y + 원자 COMMIT묶음 → 20p 22,000 불변
--   D3 채번 충돌      : OPT_000080(명함점유) → OPT_000082 / OPV_000491·492 (라이브 MAX 재확인)
-- 라이브 재확인: MAX(opt_grp)=OPT_000079 · MAX(opt_cd)=OPV_000486 · ref_dim 도메인에 opt_cd 부재.
-- ★DRY-RUN: BEGIN…ROLLBACK(절대 COMMIT 아님). 멱등(NOT EXISTS/IS NULL). 단가값 변경 0(verbatim).
-- 실 COMMIT = 인간 승인 후 §7 dbmap(dbm-axis-staged-load / dbm-load-execution). 생성측.
-- =============================================================================
BEGIN;

-- ─────────────────────────────────────────────────────────────────────────
-- [순서 1] 선택수단 먼저 — 페이지수 옵션그룹 + 옵션값(t_prd_product_options 경로)
--   ★명함037·ACRYL_BADGE 실증 경로: _opt_cd_options(price_views L732/762)가
--     t_prd_product_options 에서 읽어 selections['opt_cd']=OPV 공급.
--   ★dflt=20P + mand_yn=Y → 미선택 시 위젯이 20P 자동공급 → 20p 회귀 0(D2).
-- ─────────────────────────────────────────────────────────────────────────
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn,
   disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000094','OPT_000082','페이지수','SEL_TYPE.01',1,1,'Y',
       7,'Y','N','엽서북 페이지수 택1 필수(20P/30P·dflt=20P). 30p 견적 활성화·opt_cd 판별 선택수단. 채번 OPT_000080/081=명함점유 회피→082. §18 폐루프 260701', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups WHERE opt_grp_cd='OPT_000082');

-- 20P = dflt(미선택 시 기본·회귀방지)
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000094','OPV_000491','OPT_000082','20P','Y',1,'Y','N',
       '엽서북 20페이지. 20P body 매칭(S1_20P/S2_20P). 기본 선택.', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_cd='OPV_000491');
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000094','OPV_000492','OPT_000082','30P','N',2,'Y','N',
       '엽서북 30페이지. 30P body 매칭(S1_30P/S2_30P).', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_cd='OPV_000492');

-- ─────────────────────────────────────────────────────────────────────────
-- [순서 2] 판별차원 충전 — 단가값 불변, opt_cd/print_opt_cd 만(멱등 IS NULL 가드)
--   20P 234행(117×2): opt_cd ← 20P (print_opt 기충전)
--   30P 234행(117×2): opt_cd ← 30P, print_opt_cd ← comp별(S1=단면/S2=양면)
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_prc_component_prices SET opt_cd='OPV_000491', upd_dt=now()
 WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P') AND opt_cd IS NULL;          -- 234행
UPDATE t_prc_component_prices SET opt_cd='OPV_000492', print_opt_cd='POPT_000001', upd_dt=now()
 WHERE comp_cd='COMP_PCB_S1_30P' AND opt_cd IS NULL;                                  -- 117행(단면)
UPDATE t_prc_component_prices SET opt_cd='OPV_000492', print_opt_cd='POPT_000002', upd_dt=now()
 WHERE comp_cd='COMP_PCB_S2_30P' AND opt_cd IS NULL;                                  -- 117행(양면)

-- [순서 2b] use_dims 갱신 — 4 comp 모두 판별 4축 + opt_grp 스코프(엔진 매칭 무시·UI 그리드용)
UPDATE t_prc_price_components
   SET use_dims='["siz_cd", "min_qty", "print_opt_cd", "opt_cd", "opt_grp:OPT_000082"]', upd_dt=now()
 WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P',
                   'COMP_PCB_S1_30P','COMP_PCB_S2_30P');

-- ─────────────────────────────────────────────────────────────────────────
-- [순서 3] 배선 — PRF_PCB_FIXED ← 30P 2건(disjoint→형제와 동시합산 0)
-- ─────────────────────────────────────────────────────────────────────────
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_PCB_FIXED','COMP_PCB_S1_30P',3,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_PCB_FIXED' AND comp_cd='COMP_PCB_S1_30P');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_PCB_FIXED','COMP_PCB_S2_30P',4,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_PCB_FIXED' AND comp_cd='COMP_PCB_S2_30P');

-- =============================================================================
-- 검증 SELECT (실행 후 사전점검 — disjoint·배선·골든)
-- =============================================================================
-- 배선(기대 4행): SELECT comp_cd,disp_seq FROM t_prc_formula_components WHERE frm_cd='PRF_PCB_FIXED' ORDER BY disp_seq;
-- 판별 NULL(기대 0): SELECT comp_cd,count(*) FILTER(WHERE opt_cd IS NULL) optnull,count(*) FILTER(WHERE print_opt_cd IS NULL) prtnull FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_PCB_S%' GROUP BY comp_cd;
-- 선택수단(기대 그룹1·옵션2·dflt=20P): SELECT o.opt_cd,o.opt_nm,o.dflt_yn FROM t_prd_product_options o WHERE o.prd_cd='PRD_000094' AND o.opt_grp_cd='OPT_000082' ORDER BY o.disp_seq;
-- 골든: S1_30P SIZ_000003 qty2 → 11500(×2=23,000) / S1_20P → 11000(×2=22,000 불변)

ROLLBACK;  -- ★DRY-RUN — 실 반영 없음. 인간 승인 후 §7/dbmap 에서 COMMIT 으로 교체.
