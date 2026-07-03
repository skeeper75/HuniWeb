-- ═══════════════════════════════════════════════════════════════════════════
-- 082 하드커버 링책자 — 면지 통합 재설계 (072/077 파일럿 동형 전파) · 멱등 apply
-- §23 Huni-Set-Product · 2026-07-03 · DB 미적재(게이트 GO + 인간 승인 후 load-executor)
-- 트랜잭션 래핑(BEGIN/COMMIT)은 load-executor가 담당 — 본 파일 미내장.
--
-- 목표: 표지083 + 내지286 + 면지(1개=084). 면지색 화/블/그/★인쇄 = 084 내부 택1(자재+옵션).
-- 무손상: PRF_HC_TWINRING_SET / COMP_BIND_HC_TWINRING use_dims=["proc_cd","min_qty","proc_grp:PROC_000017"]
--         → 자재 미종속. 면지 084/085/086/087 = 공식 없음 → 기여 정확히 0(라이브 실측).
--         set_full_scan 골든 818438(= set_eval 800000 + 내지286 18438) 불변.
-- 순서 [HARD]: 자재[2] → 옵션[3~5] (트리거 fn_chk_opt_item_ref 선행조건) → 부모 은퇴[6~7] → 셋트 정리[8].
--
-- 077 대비 특이 (082):
--   ① 면지 멤버 4개(084화/085블/086그/087★인쇄) — 084 유지·085/086/087 은퇴(077은 3개).
--   ② 면지자재 4종(MAT_382/383/384/★385 인쇄면지) + 옵션 4개(OPV_440~443·★443=인쇄).
--   ③ ★★부모 082 USAGE.07 링자재(MAT_013 화이트링/014 블랙링/015 링메탈링) = 불가침.
--      본 SQL은 usage_cd='USAGE.03' 가드로 링자재를 절대 건드리지 않음(은퇴 대상 아님).
--   ④ MAT_385 인쇄면지는 현재 무공식(인쇄비 0·D-3 후속트랙) → 무손상 보존만(인쇄비 실현 아님).
-- ═══════════════════════════════════════════════════════════════════════════

-- [1] 면지 멤버 084 리네이밍 (색 특정 제거 → 통합 면지)
UPDATE t_prd_products
   SET prd_nm = '하드커버 링책자-면지', upd_dt = now()
 WHERE prd_cd = 'PRD_000084' AND prd_nm <> '하드커버 링책자-면지';

-- [2] 면지 색상 자재 4종을 면지 멤버 084에 적재 = 색 택1의 실동작 수단(구성원 용지 select)
--     ★[5] 옵션아이템 트리거(OPT_REF_DIM.03: prd_cd+mat_cd+usage_cd 실재) 선행조건 — 반드시 먼저.
--     ★MAT_385(인쇄면지) 포함(077 대비 +1). 기본자재(dflt_yn=Y)=MAT_382 화이트면지.
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn)
VALUES
  ('PRD_000084','MAT_000382','USAGE.03','Y',1, now(),'N'),
  ('PRD_000084','MAT_000383','USAGE.03','N',2, now(),'N'),
  ('PRD_000084','MAT_000384','USAGE.03','N',3, now(),'N'),
  ('PRD_000084','MAT_000385','USAGE.03','N',4, now(),'N')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE
  SET dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq,
      del_yn='N', del_dt=NULL, upd_dt=now();

-- [3] 면지색 옵션그룹을 면지 멤버 084로 이관 (CPQ 계층 · 동일코드 재사용 · PK=prd_cd+opt_grp_cd)
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES ('PRD_000084','OPT_000066','면지색','SEL_TYPE.01',1,1,'Y',1,'Y','N', now())
ON CONFLICT (prd_cd, opt_grp_cd) DO UPDATE
  SET opt_grp_nm=EXCLUDED.opt_grp_nm, sel_typ_cd=EXCLUDED.sel_typ_cd,
      min_sel_cnt=EXCLUDED.min_sel_cnt, max_sel_cnt=EXCLUDED.max_sel_cnt,
      mand_yn=EXCLUDED.mand_yn, disp_seq=EXCLUDED.disp_seq,
      use_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();

-- [4] 옵션(화/블/그/★인쇄) 4종 → 084
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES
  ('PRD_000084','OPV_000440','OPT_000066','화이트','Y',1,'Y','N', now()),
  ('PRD_000084','OPV_000441','OPT_000066','블랙','N',2,'Y','N', now()),
  ('PRD_000084','OPV_000442','OPT_000066','그레이','N',3,'Y','N', now()),
  ('PRD_000084','OPV_000443','OPT_000066','인쇄','N',4,'Y','N', now())
ON CONFLICT (prd_cd, opt_cd) DO UPDATE
  SET opt_grp_cd=EXCLUDED.opt_grp_cd, opt_nm=EXCLUDED.opt_nm, dflt_yn=EXCLUDED.dflt_yn,
      disp_seq=EXCLUDED.disp_seq, use_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();

-- [5] 옵션아이템(자재 ref) → 084  [트리거 통과: 자재는 [2]에서 084에 적재됨]
--     ★OPV_443(인쇄) → MAT_385(인쇄면지) USAGE.03 참조.
INSERT INTO t_prd_product_option_items
  (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn, reg_dt)
VALUES
  ('PRD_000084','OPV_000440',1,'OPT_REF_DIM.03','MAT_000382','USAGE.03',1,'Y','N', now()),
  ('PRD_000084','OPV_000441',1,'OPT_REF_DIM.03','MAT_000383','USAGE.03',1,'Y','N', now()),
  ('PRD_000084','OPV_000442',1,'OPT_REF_DIM.03','MAT_000384','USAGE.03',1,'Y','N', now()),
  ('PRD_000084','OPV_000443',1,'OPT_REF_DIM.03','MAT_000385','USAGE.03',1,'Y','N', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO UPDATE
  SET ref_dim_cd=EXCLUDED.ref_dim_cd, ref_key1=EXCLUDED.ref_key1, ref_key2=EXCLUDED.ref_key2,
      qty=EXCLUDED.qty, use_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();

-- [6] 부모 082 면지색 옵션 은퇴(이관 완료 → 이중표현 제거) : items → options → group 순
UPDATE t_prd_product_option_items
   SET del_yn='Y', use_yn='N', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000082' AND opt_cd IN ('OPV_000440','OPV_000441','OPV_000442','OPV_000443') AND del_yn='N';
UPDATE t_prd_product_options
   SET del_yn='Y', use_yn='N', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000082' AND opt_grp_cd='OPT_000066' AND del_yn='N';
UPDATE t_prd_product_option_groups
   SET del_yn='Y', use_yn='N', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000082' AND opt_grp_cd='OPT_000066' AND del_yn='N';

-- [7] 부모 082 면지자재(USAGE.03) 4종 은퇴 (셋트공식 자재 미종속 → 가격 무영향)
--     ★★usage_cd='USAGE.03' 가드 [HARD] — USAGE.07 링자재(MAT_013/014/015)는 절대 건드리지 않음(불가침).
--     MAT_385(인쇄면지)도 USAGE.03이므로 함께 은퇴(084로 이관 완료).
UPDATE t_prd_product_materials
   SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000082'
   AND mat_cd IN ('MAT_000382','MAT_000383','MAT_000384','MAT_000385')
   AND usage_cd='USAGE.03' AND del_yn='N';

-- [8] 빈 면지 멤버 085/086/087 은퇴 — 셋트 링크(t_prd_product_sets) 논리삭제 → 084 단일 유지
--     ★087=인쇄면지 멤버 포함(077 대비 +1). 색/인쇄 택1은 084 내부 자재/옵션으로 발현.
UPDATE t_prd_product_sets
   SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000082' AND sub_prd_cd IN ('PRD_000085','PRD_000086','PRD_000087') AND del_yn='N';
-- [8b] (선택·정리) 은퇴 멤버 상품마스터 use_yn=N — 셋트전용 상품이라 안전(역참조 0 실측).
UPDATE t_prd_products
   SET use_yn='N', upd_dt=now()
 WHERE prd_cd IN ('PRD_000085','PRD_000086','PRD_000087') AND use_yn='Y';

-- ───────────────────────────────────────────────────────────────────────────
-- [선택 · 가격중립] 내지 286 개수필드 의미정정 (§5 072/077과 동형) — 기본 비활성(주석).
--   근거: 현재 min8/max100/incr2 = 페이지수 오등록. page_rule은 부모 082에 별도 보유.
--   효과: 무의미한 "+ 내지 추가" 버튼 제거. 가격 무영향. 내지 페이지가격 실현(semi_role.01)은 별개 §23-inner 트랙.
-- UPDATE t_prd_product_sets
--    SET min_cnt=1, max_cnt=1, cnt_incr=NULL, upd_dt=now()
--  WHERE prd_cd='PRD_000082' AND sub_prd_cd='PRD_000286';
