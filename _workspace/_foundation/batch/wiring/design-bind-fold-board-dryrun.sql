-- =============================================================================
-- design-bind-fold-board-dryrun.sql
-- NEEDS_FORMULA 고아 7건(§18) — 엽서북30p·캘린더·접지카드·폼보드/포맥스
-- ★DRY-RUN: BEGIN…ROLLBACK 래핑(절대 COMMIT 아님). 멱등(NOT EXISTS/조건 UPDATE).
-- ★단가값 변경 0(verbatim). 판별차원·배선·선택수단만. 실 COMMIT은 인간 승인 후 §7/dbmap.
-- 활성 = A(엽서북30p)·D(폼보드/포맥스). B(캘린더)·C(접지카드) = BLOCKED(차단 주석만).
-- 산출 2026-07-01 · 생성측(검증·codex·PRICE≠0 실호출은 후속)
-- =============================================================================
BEGIN;

-- =============================================================================
-- A. 엽서북 30p (PRD_000094) — COMP_PCB_S1_30P·S2_30P 【DESIGNABLE】
--   판별차원 = (print_opt_cd 단/양면) × (opt_cd 페이지수). 4조합 disjoint 입증.
-- =============================================================================

-- A.1 [§7 선택수단] 페이지수 옵션그룹 신설 (MAX(opt_grp)=OPT_000079 → OPT_000080)
--     ★코드/채번 최종확정=dbm-axis-staged-load. 아래는 설계값(멱등).
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn,
   disp_seq, use_yn, del_yn, note, reg_dt)
SELECT 'PRD_000094','OPT_000080','페이지수','SEL_TYPE.01',1,1,'Y',
       7,'Y','N','페이지수 택1 필수(20P/30P). 30p 견적 활성화 — §18 NEEDS_FORMULA', now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000094' AND opt_grp_cd='OPT_000080');

-- A.2 [§7 선택수단] 옵션 아이템 2종 (ref_dim_cd=opt_cd → 판별차원 환원)
INSERT INTO t_prd_product_option_items
  (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, qty, use_yn, del_yn, reg_dt)
SELECT 'PRD_000094','OPT_000080',1,'opt_cd','OPV_PCB_PAGE_20P',1,'Y','N',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd='OPT_000080' AND item_seq=1);
INSERT INTO t_prd_product_option_items
  (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, qty, use_yn, del_yn, reg_dt)
SELECT 'PRD_000094','OPT_000080',2,'opt_cd','OPV_PCB_PAGE_30P',1,'Y','N',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000094' AND opt_cd='OPT_000080' AND item_seq=2);

-- A.3 판별차원 충전 — 단가값 불변, opt_cd/print_opt_cd만 채움(멱등: NULL일 때만)
--   20P 234행: opt_cd ← 20P (print_opt_cd는 이미 POPT_000001/2 충전됨)
UPDATE t_prc_component_prices SET opt_cd='OPV_PCB_PAGE_20P', upd_dt=now()
 WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P') AND opt_cd IS NULL;
--   30P 234행: opt_cd ← 30P, print_opt_cd ← comp별(S1=단면 POPT1 / S2=양면 POPT2)
UPDATE t_prc_component_prices SET opt_cd='OPV_PCB_PAGE_30P',
       print_opt_cd='POPT_000001', upd_dt=now()
 WHERE comp_cd='COMP_PCB_S1_30P' AND opt_cd IS NULL;
UPDATE t_prc_component_prices SET opt_cd='OPV_PCB_PAGE_30P',
       print_opt_cd='POPT_000002', upd_dt=now()
 WHERE comp_cd='COMP_PCB_S2_30P' AND opt_cd IS NULL;

-- A.4 use_dims 갱신 — 4 comp 모두 [siz_cd, min_qty, print_opt_cd, opt_cd]
UPDATE t_prc_price_components
   SET use_dims='["siz_cd", "min_qty", "print_opt_cd", "opt_cd"]', upd_dt=now()
 WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P',
                   'COMP_PCB_S1_30P','COMP_PCB_S2_30P');

-- A.5 배선 — PRF_PCB_FIXED ← 30P 2건(disjoint→형제와 동시합산 없음)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_PCB_FIXED','COMP_PCB_S1_30P',3,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_PCB_FIXED' AND comp_cd='COMP_PCB_S1_30P');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_PCB_FIXED','COMP_PCB_S2_30P',4,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_PCB_FIXED' AND comp_cd='COMP_PCB_S2_30P');

-- A. 골든 검증쿼리(참고): 30p 단면 100×150 qty2 → 11,500 (×2=23,000)
-- SELECT unit_price FROM t_prc_component_prices
--  WHERE comp_cd='COMP_PCB_S1_30P' AND siz_cd='SIZ_000003' AND min_qty=2;  -- 11500.00


-- =============================================================================
-- D. 폼보드/포맥스 (PRD_000129/130) — BLACK·WHITE5MM 【배선 안전·§7 사이즈 선행】
--   siz_cd disjoint(白174/197/293↔黑315/317·3mm174/197↔5mm315/317) → 배선 무해.
--   ★발현 조건 = product_sizes 315/317 등록(§7/§21). 미등록이면 배선 inert.
-- =============================================================================

-- D.1 배선(disjoint 안전) — 단가값 불변(verbatim)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_POSTER_FOAMBOARD','COMP_POSTER_FOAMBOARD_BLACK',2,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_POSTER_FOAMBOARD' AND comp_cd='COMP_POSTER_FOAMBOARD_BLACK');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_POSTER_FOMEXBOARD','COMP_POSTER_FOMEXBOARD_WHITE5MM',2,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
  WHERE frm_cd='PRF_POSTER_FOMEXBOARD' AND comp_cd='COMP_POSTER_FOMEXBOARD_WHITE5MM');

-- D.2 [§7/§21 선행=발현조건] 변형 사이즈 등록 — 黑보드/5mm A3·A2
--   ★상품구성 소관(§7/§21·dbmap) — 실무진 노출 승인 후 적재. 여기선 dryrun 제안.
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000129','SIZ_000315','N',3,now(),'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes
  WHERE prd_cd='PRD_000129' AND siz_cd='SIZ_000315');
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000129','SIZ_000317','N',4,now(),'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes
  WHERE prd_cd='PRD_000129' AND siz_cd='SIZ_000317');
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000130','SIZ_000315','N',3,now(),'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes
  WHERE prd_cd='PRD_000130' AND siz_cd='SIZ_000315');
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000130','SIZ_000317','N',4,now(),'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes
  WHERE prd_cd='PRD_000130' AND siz_cd='SIZ_000317');

-- D. 골든(참고): 폼보드 블랙 A3(315) qty1 → 8,500 / A2(317) → 14,000
--                포맥스 5mm A3(315) → 10,000 / A2(317) → 16,000


-- =============================================================================
-- B. 캘린더 제본 (PRD_000108~112) — COMP_BIND_CAL_WALL 【BLOCKED — 활성 INSERT 없음】
--   사유: ① 캘린더 가격공식 전무 ② 제본 proc_cd 불일치(comp=99/100/101/102 ↔
--   상품 process=76수축/79타공/21트윈링·탁상형은 제본proc 미할당) → 배선해도 영구
--   no_match(제본비 0) ③ 디지털 본문(장수×) 가격 모델 미설계. 강제 배선 거부[HARD].
--   라우팅: §7(proc 99-102 재할당) → §18(본문 모델+공식) → 실무진(가공가 이중권위).
-- (의도적 미작성: 선행 미충족 상태의 배선은 silent 결함 유발)
-- =============================================================================

-- =============================================================================
-- C. 접지카드 (COMP_FOLD_CARD_3H·6CR) 【BLOCKED — 활성 INSERT 없음】
--   사유: ① 활성 접지경로=PRF_DGP_E + 병렬 COMP_FOLD_LEAF_*(3FOLD 이미 과금) →
--   FOLD_CARD 배선 시 3단접지비 이중과금 ② 접지유형=상품식별(027 2단/029 3단·별공식)
--   이지 옵션택1 아님 ③ 6CR(6단) 호스트 상품 부재 ④ FOLD_CARD=superseded 후보.
--   라우팅: 실무진/goods.asp(권위 패밀리·048 모델·6CR 호스트) 확정 후 §18. 추측 금지.
-- (의도적 미작성: 이중과금 가드)
-- =============================================================================

ROLLBACK;  -- ★DRY-RUN — 실제 반영 없음. 인간 승인 후 §7/dbmap 트랙에서 COMMIT.
