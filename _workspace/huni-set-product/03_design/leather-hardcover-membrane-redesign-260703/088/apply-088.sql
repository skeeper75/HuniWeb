-- ═══════════════════════════════════════════════════════════════════════════
-- 088 레더 링바인더 — 면지(면지) 통합 재설계 (072/077 파일럿 동형 전파) · 멱등 apply
-- §23 Huni-Set-Product · 2026-07-03 · DB 미적재(게이트 GO + 인간 승인 후 load-executor)
-- 트랜잭션 래핑(BEGIN/COMMIT)은 load-executor가 담당 — 본 파일 미내장.
--
-- 목표: 표지089 + 면지(1개=090). 면지색 화/블/그/인쇄 = 090 내부 택1(자재+옵션). 내지 없음.
-- 무손상: PRF_LEATHER_RINGBINDER_SET use_dims=["min_qty"] 자재 미종속
--         → 면지 090~093 기여 정확히 0(라이브 실측). 현행 골든 34,100/159,100/796,900 불변.
-- 순서 [HARD]: 자재[2] → 옵션[3~5] (트리거 fn_chk_opt_item_ref 선행조건) → 부모 은퇴[6~7] → 셋트 정리[8].
-- 077 대비 매핑: 078→089(표지·본 파일 미터치) · 079→090 · 080/081→091/092(+093 인쇄 4번째) ·
--               OPT_065→OPT_067 · OPV_437/438/439→OPV_444/445/446(+OPV_447 인쇄) · 자재 +MAT_385(인쇄).
--
-- ★★088-redesign-260702 조율 [HARD]: 088-redesign(표지 9,000/부·member 089·싸바리 SSABARI)은
--   라이브 실측 결과 미적재(COMMIT 미실행) 확정. 본 면지 통합은 그 재설계와 완전 직교
--   (member 089/부모공식 배선/product_processes/9,000 mint 미터치 · 겹치는 행 0). 어느 순서로도
--   충돌 없음 · 면지 통합은 두 표지모델(COVERBIND 현행 / SSABARI 재설계) 모두에서 골든 중립.
-- ★★USAGE.07 D링 자재(MAT_247/248/249) = 불가침 · 표지 089 · 싸바리/COVERBIND 미터치.
-- 신규 mint 0 · 물리 DELETE 0.
-- ═══════════════════════════════════════════════════════════════════════════

-- [1] 면지 멤버 090 리네이밍 (색 특정 제거 → 통합 면지)
UPDATE t_prd_products
   SET prd_nm = '레더 링바인더-면지', upd_dt = now()
 WHERE prd_cd = 'PRD_000090' AND prd_nm <> '레더 링바인더-면지';

-- [2] 면지 색상 자재 4종을 면지 멤버 090에 적재 = 색 택1의 실동작 수단(구성원 용지 select)
--     ★[5] 옵션아이템 트리거(OPT_REF_DIM.03: prd_cd+mat_cd+usage_cd 실재) 선행조건 — 반드시 먼저.
--     088 특이: MAT_385(인쇄면지) 4번째 포함(082/088 4색).
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn)
VALUES
  ('PRD_000090','MAT_000382','USAGE.03','Y',1, now(),'N'),
  ('PRD_000090','MAT_000383','USAGE.03','N',2, now(),'N'),
  ('PRD_000090','MAT_000384','USAGE.03','N',3, now(),'N'),
  ('PRD_000090','MAT_000385','USAGE.03','N',4, now(),'N')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE
  SET dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq,
      del_yn='N', del_dt=NULL, upd_dt=now();

-- [3] 면지색 옵션그룹을 면지 멤버 090로 이관 (CPQ 계층 · 동일코드 재사용 · PK=prd_cd+opt_grp_cd)
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES ('PRD_000090','OPT_000067','면지색','SEL_TYPE.01',1,1,'Y',1,'Y','N', now())
ON CONFLICT (prd_cd, opt_grp_cd) DO UPDATE
  SET opt_grp_nm=EXCLUDED.opt_grp_nm, sel_typ_cd=EXCLUDED.sel_typ_cd,
      min_sel_cnt=EXCLUDED.min_sel_cnt, max_sel_cnt=EXCLUDED.max_sel_cnt,
      mand_yn=EXCLUDED.mand_yn, disp_seq=EXCLUDED.disp_seq,
      use_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();

-- [4] 옵션(화/블/그/인쇄) 4종 → 090
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
VALUES
  ('PRD_000090','OPV_000444','OPT_000067','화이트','Y',1,'Y','N', now()),
  ('PRD_000090','OPV_000445','OPT_000067','블랙','N',2,'Y','N', now()),
  ('PRD_000090','OPV_000446','OPT_000067','그레이','N',3,'Y','N', now()),
  ('PRD_000090','OPV_000447','OPT_000067','인쇄','N',4,'Y','N', now())
ON CONFLICT (prd_cd, opt_cd) DO UPDATE
  SET opt_grp_cd=EXCLUDED.opt_grp_cd, opt_nm=EXCLUDED.opt_nm, dflt_yn=EXCLUDED.dflt_yn,
      disp_seq=EXCLUDED.disp_seq, use_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();

-- [5] 옵션아이템(자재 ref) → 090  [트리거 통과: 자재는 [2]에서 090에 적재됨]
INSERT INTO t_prd_product_option_items
  (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn, reg_dt)
VALUES
  ('PRD_000090','OPV_000444',1,'OPT_REF_DIM.03','MAT_000382','USAGE.03',1,'Y','N', now()),
  ('PRD_000090','OPV_000445',1,'OPT_REF_DIM.03','MAT_000383','USAGE.03',1,'Y','N', now()),
  ('PRD_000090','OPV_000446',1,'OPT_REF_DIM.03','MAT_000384','USAGE.03',1,'Y','N', now()),
  ('PRD_000090','OPV_000447',1,'OPT_REF_DIM.03','MAT_000385','USAGE.03',1,'Y','N', now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO UPDATE
  SET ref_dim_cd=EXCLUDED.ref_dim_cd, ref_key1=EXCLUDED.ref_key1, ref_key2=EXCLUDED.ref_key2,
      qty=EXCLUDED.qty, use_yn='Y', del_yn='N', del_dt=NULL, upd_dt=now();

-- [6] 부모 088 면지색 옵션 은퇴(이관 완료 → 이중표현 제거) : items → options → group 순
UPDATE t_prd_product_option_items
   SET del_yn='Y', use_yn='N', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000088' AND opt_cd IN ('OPV_000444','OPV_000445','OPV_000446','OPV_000447') AND del_yn='N';
UPDATE t_prd_product_options
   SET del_yn='Y', use_yn='N', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000088' AND opt_grp_cd='OPT_000067' AND del_yn='N';
UPDATE t_prd_product_option_groups
   SET del_yn='Y', use_yn='N', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000088' AND opt_grp_cd='OPT_000067' AND del_yn='N';

-- [7] 부모 088 면지자재(USAGE.03) 은퇴 (셋트공식 use_dims=["min_qty"] 자재 미종속 → 가격 무영향)
--     ★★USAGE.07 D링 자재(MAT_247/248/249)는 절대 미터치 — WHERE에 usage_cd='USAGE.03' + mat 명시로 격리.
UPDATE t_prd_product_materials
   SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000088'
   AND mat_cd IN ('MAT_000382','MAT_000383','MAT_000384','MAT_000385')
   AND usage_cd='USAGE.03' AND del_yn='N';

-- [8] 빈 면지 멤버 091/092/093 은퇴 — 셋트 링크(t_prd_product_sets) 논리삭제 → 090 단일 유지
UPDATE t_prd_product_sets
   SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000088' AND sub_prd_cd IN ('PRD_000091','PRD_000092','PRD_000093') AND del_yn='N';
-- [8b] (선택·정리) 은퇴 멤버 상품마스터 use_yn=N — 셋트전용 상품이라 안전(역참조 0 실측).
UPDATE t_prd_products
   SET use_yn='N', upd_dt=now()
 WHERE prd_cd IN ('PRD_000091','PRD_000092','PRD_000093') AND use_yn='Y';

-- ───────────────────────────────────────────────────────────────────────────
-- 미포함(스코프 밖·불가침): 표지 089 · 부모공식 배선(COVERBIND/SSABARI) · product_processes ·
--   USAGE.07 D링 자재 · 088-redesign mint(9,000 표지). 이들은 088-redesign 트랙 소관.
-- 내지 개수정정 블록(077 [선택])은 088에 내지 멤버 부재로 해당 없음.
