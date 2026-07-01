-- =============================================================================
-- photocard-fix-dryrun.sql  (DRY-RUN 전용 — BEGIN...ROLLBACK · 실 COMMIT 금지)
-- 포토카드 PRD_000024 — 제작방식(세트/대량) 선택수단 신설 + BULK 고아 배선
-- §27 배선 서브트랙 · 설계: design-photocard-260701.md
-- 선례 동형: pcb30p-fix.sql(엽서북30p) — 와일드카드 comp에 opt_cd 판별축 부여 + 옵션그룹 신설.
--
-- 채번 라이브 재확인(260701): MAX opt_grp=OPT_000083 · MAX opt_cd=OPV_000494
--   → OPT_000084(제작방식) · OPV_000495(세트)/OPV_000496(대량) free.
-- ★[HARD] CLEAR_SET(COMP_PHOTOCARD_CLEAR_SET)은 건드리지 않는다:
--   PRD_000025 투명포토카드(PRF_PHOTOCARD_CLEAR)에만 배선돼 있고 그 상품엔 '제작방식'
--   옵션그룹이 없다. opt_cd를 넣으면 투명포토카드가 견적0으로 회귀 → 범위 밖(교차상품 가드).
-- 단가값 verbatim 유지 — opt_cd 컬럼만 채우는 UPDATE(신규 INSERT/대칭전개 없음).
-- undo = photocard-undo.sql
-- =============================================================================
BEGIN;

-- [순서1] 선택수단 — 제작방식 옵션그룹(택1 필수·dflt=세트 → 위젯 사전선택→세트 회귀0)
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000024','OPT_000084','제작방식','SEL_TYPE.01',1,1,'Y',6,'Y','N',
       '포토카드 제작방식 택1 필수(세트=20장1세트/대량제작·dflt=세트). 대량 견적 활성화·opt_cd 판별 선택수단. §27 배선 260701', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE opt_grp_cd='OPT_000084');

INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000024','OPV_000495','OPT_000084','세트','Y',1,'Y','N','20장 1세트 고정가. COMP_PHOTOCARD_SET 매칭. 기본 선택.', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000024' AND opt_cd='OPV_000495');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000024','OPV_000496','OPT_000084','대량제작','N',2,'Y','N','수량구간 대량가(20~3000장). COMP_PHOTOCARD_BULK 매칭.', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000024' AND opt_cd='OPV_000496');

-- [순서2] 판별차원 충전 (단가값 불변·멱등 IS NULL 가드)
UPDATE t_prc_component_prices SET opt_cd='OPV_000495', upd_dt=now()
 WHERE comp_cd='COMP_PHOTOCARD_SET'  AND opt_cd IS NULL;   -- 1행(세트 20장 6,000)
UPDATE t_prc_component_prices SET opt_cd='OPV_000496', upd_dt=now()
 WHERE comp_cd='COMP_PHOTOCARD_BULK' AND opt_cd IS NULL;   -- 50행(수량구간 대량가)

-- [순서2b] use_dims 갱신 (opt_cd 판별 + opt_grp 스코프=UI 드롭다운용)
UPDATE t_prc_price_components
   SET use_dims='["siz_cd", "bdl_qty", "min_qty", "opt_cd", "opt_grp:OPT_000084"]', upd_dt=now()
 WHERE comp_cd='COMP_PHOTOCARD_SET';
UPDATE t_prc_price_components
   SET use_dims='["min_qty", "opt_cd", "opt_grp:OPT_000084"]', upd_dt=now()
 WHERE comp_cd='COMP_PHOTOCARD_BULK';

-- [순서3] 배선 — PRF_PHOTOCARD_NORMAL ← COMP_PHOTOCARD_BULK(seq2·disjoint by opt_cd)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_PHOTOCARD_NORMAL','COMP_PHOTOCARD_BULK',2,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_PHOTOCARD_NORMAL' AND comp_cd='COMP_PHOTOCARD_BULK');

-- ============================ 검증 ============================
\echo '--- 검증1: 옵션그룹/옵션값 (기대 1그룹 + 2옵션) ---'
SELECT opt_grp_cd,opt_grp_nm,sel_typ_cd,mand_yn,disp_seq FROM t_prd_product_option_groups WHERE opt_grp_cd='OPT_000084';
SELECT opt_cd,opt_nm,dflt_yn FROM t_prd_product_options WHERE opt_grp_cd='OPT_000084' ORDER BY disp_seq;

\echo '--- 검증2: 판별차원 충전 (기대 SET opt_cd=495 1행 · BULK opt_cd=496 50행 · NULL 0) ---'
SELECT comp_cd, opt_cd, count(*) FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_BULK') GROUP BY comp_cd,opt_cd ORDER BY comp_cd;

\echo '--- 검증2b: CLEAR_SET 불변 확인 (기대 opt_cd=NULL 유지) ---'
SELECT comp_cd, opt_cd, count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PHOTOCARD_CLEAR_SET' GROUP BY comp_cd,opt_cd;

\echo '--- 검증3: 배선 (기대 SET seq1 + BULK seq2) ---'
SELECT frm_cd,comp_cd,disp_seq,addtn_yn FROM t_prc_formula_components WHERE frm_cd='PRF_PHOTOCARD_NORMAL' ORDER BY disp_seq;

\echo '--- 검증4: disjoint 시뮬 — 세트선택(opt_cd=495) 매칭행 (기대: SET 1행만) ---'
SELECT comp_cd,opt_cd,min_qty,unit_price FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_BULK')
   AND (opt_cd IS NULL OR opt_cd='OPV_000495') AND min_qty=20;

\echo '--- 검증5: disjoint 시뮬 — 대량선택(opt_cd=496)·qty100 매칭행 (기대: BULK min_qty=100 1행만) ---'
SELECT comp_cd,opt_cd,min_qty,unit_price FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_BULK')
   AND (opt_cd IS NULL OR opt_cd='OPV_000496') AND min_qty=100;

\echo '--- 검증6: 골든 단가 verbatim (합가형 per_item=up/min_qty, subtotal=per_item*qty) ---'
SELECT comp_cd,min_qty,unit_price,
       round(unit_price/min_qty,2) AS per_item,
       round(unit_price/min_qty*min_qty,0) AS subtotal_at_tier
  FROM t_prc_component_prices
 WHERE (comp_cd='COMP_PHOTOCARD_SET' AND min_qty=20)
    OR (comp_cd='COMP_PHOTOCARD_BULK' AND min_qty IN (20,100,500))
 ORDER BY comp_cd,min_qty;

COMMIT;
-- =============================================================================
-- 멱등성: 위 스크립트 재실행 시 INSERT 0 0(NOT EXISTS) · UPDATE 0(opt_cd IS NULL 가드).
-- ★COMMIT 없음 — 실 적재는 인간 승인 후 별도 photocard-fix.sql(§7 트랙).
-- =============================================================================
