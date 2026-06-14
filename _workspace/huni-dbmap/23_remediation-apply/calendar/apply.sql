-- =====================================================================
-- 캘린더 라이브 정정 적재본 (apply.sql) · round-13 / 2026-06-14
-- 정답 권위: 원본 엑셀 L1 최신 24_master-extract-260610/calendar-l1.csv · design-calendar-l1.csv
-- [HARD] 실제 COMMIT은 인간 승인 후 실행. 파일은 보유하되 자동 실행 금지.
-- 멱등: WHERE 값이 실제 다를 때만 UPDATE → 재실행 시 0행(완전 무동작·디지털 MINOR 교훈 반영).
-- 비파괴: COMMIT/DDL/DELETE 없음. 잉여 자재행은 hard-delete 아닌 논리삭제(del_yn='Y').
-- 타임스탬프: UPDATE upd_dt=now(). t_prd_products·t_prd_product_processes·materials 에 note 컬럼 없음 → 변경이력은 upd_dt + 본 산출문서로 추적.
-- 디지털인쇄 패턴(23_remediation-apply/digital-print/apply.sql) 계승.
-- =====================================================================

BEGIN;

-- =====================================================================
-- [즉시적용 1] MES_ITEM_CD 채움 — 캘린더 5상품 (C-13)
-- 엑셀 L1 MES칸 007-0001~5가 5상품에 1:1. 라이브는 전량 NULL(load_master L261 None 하드코딩·중복 회피).
-- 라이브 실측: 전역에서 '007-%' MES를 쓰는 행 0건(중복 0) + MES_ITEM_CD UNIQUE 제약 부재 → 안전하게 채움.
-- 멱등: WHERE 현재값이 채울 값과 다를 때만(=NULL일 때만) → 재실행 0행.
-- 근거: extraction-plan §0 헤더 · loadlogic-notes F-5 · correction-manifest C-CAL-13 · L1 MES칸 실측.
-- =====================================================================

UPDATE t_prd_products SET "MES_ITEM_CD"='007-0001', upd_dt=now()
 WHERE prd_cd='PRD_000108' AND "MES_ITEM_CD" IS DISTINCT FROM '007-0001';
UPDATE t_prd_products SET "MES_ITEM_CD"='007-0002', upd_dt=now()
 WHERE prd_cd='PRD_000109' AND "MES_ITEM_CD" IS DISTINCT FROM '007-0002';
UPDATE t_prd_products SET "MES_ITEM_CD"='007-0003', upd_dt=now()
 WHERE prd_cd='PRD_000110' AND "MES_ITEM_CD" IS DISTINCT FROM '007-0003';
UPDATE t_prd_products SET "MES_ITEM_CD"='007-0004', upd_dt=now()
 WHERE prd_cd='PRD_000111' AND "MES_ITEM_CD" IS DISTINCT FROM '007-0004';
UPDATE t_prd_products SET "MES_ITEM_CD"='007-0005', upd_dt=now()
 WHERE prd_cd='PRD_000112' AND "MES_ITEM_CD" IS DISTINCT FROM '007-0005';

-- =====================================================================
-- 위까지가 즉시적용분(MES 5상품). 아래는 모두 신규적재/컨펌대기 — 주석 처리(실행 안 함).
-- =====================================================================

COMMIT;   -- [HARD] 인간 승인 후에만 실제 실행.

-- =====================================================================
-- ============== 신규적재/컨펌대기 블록 (실행 금지 · 설계 보존용) ==============
-- =====================================================================

-- --------------------------------------------------------------------
-- [컨펌대기 C-10] 디자인캘린더 editor_yn=Y — 같은 상품의 에디터 surface 반영 (CL-G)
-- 디자인캘린더=캘린더와 같은 PRD_000108~112. 현 editor_yn=N(캘린더/업로드 surface만 반영).
-- file_upload_yn=Y 유지(2채널). 단순 UPDATE이나 "같은 상품의 두 surface" 정책 컨펌 후.
-- --------------------------------------------------------------------
-- UPDATE t_prd_products SET editor_yn='Y', upd_dt=now()
--  WHERE prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112')
--    AND editor_yn IS DISTINCT FROM 'Y';

-- --------------------------------------------------------------------
-- [컨펌대기 C-03/EXTRA] 탁상/미니 링 블랙 잉여 자재 논리삭제 (CL-B)
-- 탁상(108)/미니(109)는 삼각대 거치(트윈링 아님)인데 MAT_000253 링 블랙이 붙음 = 잉여.
-- hard-delete 금지 → del_yn='Y' 논리삭제. t_prd_product_materials 에 note 없음 → upd_dt만.
-- --------------------------------------------------------------------
-- UPDATE t_prd_product_materials SET del_yn='Y', upd_dt=now()
--  WHERE prd_cd IN ('PRD_000108','PRD_000109') AND mat_cd='MAT_000253'
--    AND del_yn IS DISTINCT FROM 'Y';   -- 멱등: 이미 Y면 0행

-- --------------------------------------------------------------------
-- [신규적재/컨펌 C-01/C-07] 삼각대 거치 = 공정 (자재 아님) (CL-A)
-- 삼각대(MAT_000252 그레이·MAT_000254 블랙)가 MAT_TYPE.07 자재로 적재. 거치=공정(설계의도 §3 #6).
-- "삼각대 거치" 공정 마스터 부재(라이브 0행 실측) → 먼저 공정 mint 필요(ddl-proposer).
-- 공정 mint 후: product_processes 연결 + 삼각대색=공정 param(cpq-plan §3) / 자재행 del_yn='Y'.
--   1) (ddl-proposer) INSERT INTO t_proc_processes (proc_cd,proc_nm,...) VALUES ('PROC_xxxxxx','삼각대거치',...);
--   2) INSERT INTO t_prd_product_processes (prd_cd,proc_cd,mand_proc_yn,disp_seq,reg_dt,del_yn)
--      VALUES ('PRD_000108','PROC_xxxxxx','N',5,now(),'N'),('PRD_000109','PROC_xxxxxx','N',5,now(),'N')
--      ON CONFLICT (prd_cd,proc_cd) DO NOTHING;
--   3) UPDATE t_prd_product_materials SET del_yn='Y', upd_dt=now()
--      WHERE (prd_cd,mat_cd) IN (('PRD_000108','MAT_000252'),('PRD_000109','MAT_000254'))
--        AND del_yn IS DISTINCT FROM 'Y';

-- --------------------------------------------------------------------
-- [신규적재/컨펌 C-02] 링칼라 = 트윈링제본 공정 param (자재 아님) (CL-B)
-- 벽걸이(111)/와이드(112)는 PROC_000021 트윈링제본 공정 이미 적재. MAT_000253 링=그 공정 색(param).
-- 링칼라 param 적재처(prcs_dtl_opt/ref_param_json) 결정 후 + 자재행 논리삭제.
-- UPDATE t_prd_product_materials SET del_yn='Y', upd_dt=now()
--  WHERE prd_cd IN ('PRD_000111','PRD_000112') AND mat_cd='MAT_000253'
--    AND del_yn IS DISTINCT FROM 'Y';
-- (링칼라=블랙 param은 CPQ option_items 경유 — cpq-plan §3)

-- --------------------------------------------------------------------
-- [신규적재/컨펌 C-05] 장수(낱장 매수) = 고객선택 옵션 + 가격공식 (CL-D)
-- 라이브 page_rules 0·option_groups 0·prices 0. 장수=page_rule 아님(Q12).
-- CPQ option_groups(장수)+option_items(4(8P)/8(16P)/12(24P)/16(32P)…)+가격공식 바인딩.
-- → cpq-plan §1. load-execution(round-6 L2) + 가격공식 컨펌(round-2 디지털 가격엔진 합산).

-- --------------------------------------------------------------------
-- [신규적재/컨펌 C-06] 캘린더가공 택일그룹 (가공없음/우드거치/타공/트윈링) (CL-D)
-- 라이브 option_groups 0. excl_groups 테이블 Phase11 삭제 → option_groups 흡수가 정답.
-- GRP-CAL-가공(SEL_TYPE.01 단일 택1·mand_yn=Y) 6멤버 + 가공별 추가가격(C20: 0/1000/1500/2000/4000).
-- → cpq-plan §2. load-execution(round-6).

-- --------------------------------------------------------------------
-- [신규적재 C-08] 캘린더봉투 addon (★사이즈선택 캐스케이드)
-- 캘린더봉투 PRD_000005(기성상품) 실재. 단 PRD_000005 기준 template 0건 → 사이즈매칭 봉투 template 선적재 선행.
-- addons 컬럼=tmpl_cd(Phase7). 봉투 template 선적재 후 product_addons(prd_cd·tmpl_cd) + ★사이즈 constraint.
-- → cpq-plan §4. load-execution + ddl/데이터(봉투 template).

-- --------------------------------------------------------------------
-- [신규적재 C-09] 우드거치대 = 자재 (Q13)
-- search-before-mint HIT: 우드거치대 자재 마스터 라이브 실재 — MAT_000223(우드거치대·MAT_TYPE.10)·
--   MAT_000034(캘린더부자재 우드거치대·MAT_TYPE.07). 신규 mint 0 → 기존 MAT 재사용.
-- 엽서(110)·디자인 surface 부속 자재 연결:
-- INSERT INTO t_prd_product_materials (prd_cd,mat_cd,usage_cd,dflt_yn,reg_dt,del_yn)
-- VALUES ('PRD_000110','MAT_000034','USAGE.07','N',now(),'N')   -- 어느 MAT(223 vs 034) 권위는 컨펌
-- ON CONFLICT DO NOTHING;

-- --------------------------------------------------------------------
-- [신규적재/가격트랙 C-11] 디자인캘린더 고정가 (4000~24000) (Q15)
-- 라이브 prices 0(전역). 디자인캘린더=고정가형(캘린더=공식엔진과 대비).
-- t_prd_product_prices(prd_cd·apply_ymd·price) 사이즈/페이지별 고정가 적재 → round-2 가격 트랙.
-- (가격 적재는 round-16/가격 트랙 소관 — 여기선 식별만)
