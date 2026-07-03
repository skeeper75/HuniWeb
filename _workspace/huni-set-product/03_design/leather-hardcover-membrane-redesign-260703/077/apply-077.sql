-- ═══════════════════════════════════════════════════════════════════════════
-- 077 레더 하드커버책자 — 면지(면지) 통합 재설계 (072 파일럿 동형 전파) · 멱등 apply
-- §23 Huni-Set-Product · 2026-07-03 · DB 미적재(게이트 GO + 인간 승인 후 load-executor)
-- 트랜잭션 래핑(BEGIN/COMMIT)은 load-executor가 담당 — 본 파일 미내장.
--
-- 목표: 표지078 + 내지285 + 면지(1개=079). 면지색 화/블/그 = 079 내부 택1(자재+옵션).
-- 무손상: PRF_HC_MUSEON_SET / COMP_HC_MUSEON_COVERBIND use_dims=["min_qty"] 자재 미종속
--         → 면지 079/080/081 기여 정확히 0(라이브 실측). set_full_scan 골든 806,119 불변.
-- 순서 [HARD]: 자재[2] → 옵션[3~5] (트리거 fn_chk_opt_item_ref 선행조건) → 부모 은퇴[6~7] → 셋트 정리[8].
-- 072 대비 매핑: 073→078 · 284→285 · 074→079 · 075/076→080/081 · OPT_064→OPT_065 ·
--               OPV_434/435/436→OPV_437/438/439. 자재 MAT_382/383/384 동일.
-- ★077 특이: 부모 USAGE.07 자재 없음(082/088과 달리) → 072와 완전 동형(불가침 이슈 0).
-- ★이전 077 동작화 COMMIT(PRF_HC_MUSEON_SET 바인딩 + 내지 285 mint, 견적0→동작)은 미변경·보존.
-- ═══════════════════════════════════════════════════════════════════════════

-- [1] 면지 멤버 079 리네이밍 (색 특정 제거 → 통합 면지)
UPDATE t_prd_products
   SET prd_nm = '레더 하드커버책자-면지', upd_dt = now()
 WHERE prd_cd = 'PRD_000079' AND prd_nm <> '레더 하드커버책자-면지';

-- [2] 면지 색상 자재 3종을 면지 멤버 079에 적재 = 색 택1의 실동작 수단(구성원 용지 select)
--     ★[5] 옵션아이템 트리거(OPT_REF_DIM.03: prd_cd+mat_cd+usage_cd 실재) 선행조건 — 반드시 먼저.
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn)
VALUES
  ('PRD_000079','MAT_000382','USAGE.03','Y',1, now(),'N'),
  ('PRD_000079','MAT_000383','USAGE.03','N',2, now(),'N'),
  ('PRD_000079','MAT_000384','USAGE.03','N',3, now(),'N')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE
  SET dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq,
      del_yn='N', del_dt=NULL, upd_dt=now();

-- [3] 면지색 옵션그룹을 면지 멤버 079로 이관 (CPQ 계층 · 동일코드 재사용 · PK=prd_cd+opt_grp_cd)
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES ('PRD_000079','OPT_000065','면지색','SEL_TYPE.01',1,1,'Y',1,'Y','N', now())
ON CONFLICT (prd_cd, opt_grp_cd) DO UPDATE
  SET opt_grp_nm=EXCLUDED.opt_grp_nm, sel_typ_cd=EXCLUDED.sel_typ_cd,
      min_sel_cnt=EXCLUDED.min_sel_cnt, max_sel_cnt=EXCLUDED.max_sel_cnt,
      mand_yn=EXCLUDED.mand_yn, disp_seq=EXCLUDED.disp_seq,
      use_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();

-- [4] 옵션(화/블/그) 3종 → 079
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES
  ('PRD_000079','OPV_000437','OPT_000065','화이트','Y',1,'Y','N', now()),
  ('PRD_000079','OPV_000438','OPT_000065','블랙','N',2,'Y','N', now()),
  ('PRD_000079','OPV_000439','OPT_000065','그레이','N',3,'Y','N', now())
ON CONFLICT (prd_cd, opt_cd) DO UPDATE
  SET opt_grp_cd=EXCLUDED.opt_grp_cd, opt_nm=EXCLUDED.opt_nm, dflt_yn=EXCLUDED.dflt_yn,
      disp_seq=EXCLUDED.disp_seq, use_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();

-- [5] 옵션아이템(자재 ref) → 079  [트리거 통과: 자재는 [2]에서 079에 적재됨]
INSERT INTO t_prd_product_option_items
  (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn, reg_dt)
VALUES
  ('PRD_000079','OPV_000437',1,'OPT_REF_DIM.03','MAT_000382','USAGE.03',1,'Y','N', now()),
  ('PRD_000079','OPV_000438',1,'OPT_REF_DIM.03','MAT_000383','USAGE.03',1,'Y','N', now()),
  ('PRD_000079','OPV_000439',1,'OPT_REF_DIM.03','MAT_000384','USAGE.03',1,'Y','N', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO UPDATE
  SET ref_dim_cd=EXCLUDED.ref_dim_cd, ref_key1=EXCLUDED.ref_key1, ref_key2=EXCLUDED.ref_key2,
      qty=EXCLUDED.qty, use_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();

-- [6] 부모 077 면지색 옵션 은퇴(이관 완료 → 이중표현 제거) : items → options → group 순
UPDATE t_prd_product_option_items
   SET del_yn='Y', use_yn='N', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000077' AND opt_cd IN ('OPV_000437','OPV_000438','OPV_000439') AND del_yn='N';
UPDATE t_prd_product_options
   SET del_yn='Y', use_yn='N', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000077' AND opt_grp_cd='OPT_000065' AND del_yn='N';
UPDATE t_prd_product_option_groups
   SET del_yn='Y', use_yn='N', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000077' AND opt_grp_cd='OPT_000065' AND del_yn='N';

-- [7] 부모 077 면지자재(USAGE.03) 은퇴 (셋트공식 use_dims=["min_qty"] 자재 미종속 → 가격 무영향)
--     ★077 부모엔 USAGE.07 자재 없음 → USAGE.03만 은퇴(082/088 불가침 이슈 해당 없음).
UPDATE t_prd_product_materials
   SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000077' AND mat_cd IN ('MAT_000382','MAT_000383','MAT_000384')
   AND usage_cd='USAGE.03' AND del_yn='N';

-- [8] 빈 면지 멤버 080/081 은퇴 — 셋트 링크(t_prd_product_sets) 논리삭제 → 079 단일 유지
UPDATE t_prd_product_sets
   SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000077' AND sub_prd_cd IN ('PRD_000080','PRD_000081') AND del_yn='N';
-- [8b] (선택·정리) 은퇴 멤버 상품마스터 use_yn=N — 셋트전용 상품이라 안전(역참조 0 실측).
UPDATE t_prd_products
   SET use_yn='N', upd_dt=now()
 WHERE prd_cd IN ('PRD_000080','PRD_000081') AND use_yn='Y';

-- ───────────────────────────────────────────────────────────────────────────
-- [선택 · 가격중립] 내지 285 개수필드 의미정정 (§5 072와 동형) — 기본 비활성(주석).
--   근거: 현재 min24/max300/incr2 = 페이지수 오등록. page_rule은 부모 077에 별도 보유.
--   효과: 무의미한 "+ 내지 추가" 버튼 제거. 가격 무영향. 내지 페이지가격 실현(semi_role.01)은 별개 §23-inner 트랙.
-- UPDATE t_prd_product_sets
--    SET min_cnt=1, max_cnt=1, cnt_incr=NULL, upd_dt=now()
--  WHERE prd_cd='PRD_000077' AND sub_prd_cd='PRD_000285';
