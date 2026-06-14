-- =====================================================================
-- 디자인캘린더(가격포함) 라이브 정정 적재본 (apply.sql) · round-13 / 2026-06-14
-- 정답 권위: 원본 엑셀 L1 최신 24_master-extract-260610/design-calendar-l1.csv
-- [HARD] 실제 COMMIT은 인간 승인 후 실행. 파일은 보유하되 자동 실행 금지.
-- 멱등: WHERE 현재값 조건(값 다를 때만) / ON CONFLICT DO UPDATE → 재실행 시 0행.
-- 비파괴: COMMIT/DDL/DELETE 없음. 자재 제거는 hard-delete 아닌 논리삭제(del_yn='Y').
-- 타임스탬프: UPDATE upd_dt=now() / INSERT reg_dt=now() + note 변경이력(note 있는 테이블만).
-- 디지털인쇄 패턴(23_remediation-apply/digital-print/apply.sql) 계승 + MINOR 개선(완전 무동작 멱등 가드).
-- =====================================================================

BEGIN;

-- =====================================================================
-- [즉시적용 D-01] editor_yn N→Y — 디자인보유 ● 4상품 (탁상/미니/벽걸이/와이드)
-- 디자인캘린더=에디터 surface(고객이 직접 디자인). 엽서(110)는 엑셀 디자인보유 ● 없어 제외.
-- 근거: mapping-final §B B1·Q6(1상품+에디터)·엑셀 AC열 색상 FF31859B(108/109/111/112).
-- file_upload_yn=Y는 유지(업로드+에디터 2채널). 신규 코드값 0·FK 무관.
-- 멱등: WHERE editor_yn='N'(이미 Y면 0행 — 완전 무동작).
-- =====================================================================

UPDATE t_prd_products
   SET editor_yn='Y', upd_dt=now()
 WHERE prd_cd IN ('PRD_000108','PRD_000109','PRD_000111','PRD_000112')
   AND editor_yn IS DISTINCT FROM 'Y';   -- 값 다를 때만(완전 무동작 멱등)

-- =====================================================================
-- [즉시적용 D-02] MES_ITEM_CD NULL→007-0001~5 — 5상품 (1:1·중복 없음)
-- 근거: 엑셀 C3(MES ITEM_CD)·product-master L333-337·라이브 NULL.
-- load_master L261이 None 하드코딩(중복 UNIQUE 회피)했으나 캘린더는 1:1이라 채울 수 있음.
-- 멱등: WHERE "MES_ITEM_CD" IS NULL(이미 채워졌으면 0행).
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

COMMIT;   -- [HARD] 인간 승인 후에만 실제 실행.

-- =====================================================================
-- 위까지가 즉시적용분. 아래는 모두 신규적재/컨펌대기 — 주석 처리(실행 안 함).
-- =====================================================================

-- =====================================================================
-- ============== 신규적재 / 컨펌대기 블록 (실행 금지 · 설계 보존용) ==============
-- =====================================================================

-- --------------------------------------------------------------------
-- [신규적재 D-03] 디자인캘린더 고정가 — 그릇 구조 미결 (Q-DC-A)
-- 엑셀 가격: 탁상 10400/9700·미니 6500·엽서 4000·벽걸이 9900·와이드 24000 (사이즈/페이지별).
-- 라이브 t_prd_product_prices PK=(prd_cd, apply_ymd)·unit_price 단일 → 사이즈/페이지별 다가 담을 칸 부족.
-- → 대표 단일가만 넣으려면(컨펌 후·apply_ymd=오늘):
-- INSERT INTO t_prd_product_prices (prd_cd, apply_ymd, unit_price, note, reg_dt)
-- VALUES ('PRD_000108', to_char(now(),'YYYYMMDD'), 10400, '정정 2026-06-14: 디자인캘린더 고정가(대표)', now()),
--        ('PRD_000109', to_char(now(),'YYYYMMDD'), 6500,  '정정 2026-06-14', now()),
--        ('PRD_000110', to_char(now(),'YYYYMMDD'), 4000,  '정정 2026-06-14', now()),
--        ('PRD_000111', to_char(now(),'YYYYMMDD'), 9900,  '정정 2026-06-14', now()),
--        ('PRD_000112', to_char(now(),'YYYYMMDD'), 24000, '정정 2026-06-14', now())
-- ON CONFLICT (prd_cd, apply_ymd) DO UPDATE SET unit_price=EXCLUDED.unit_price, upd_dt=now(), note=EXCLUDED.note;
--   주의: 사이즈/페이지별 다가는 이 그릇으로 표현 불가 → Q-DC-A 그릇 결정 선행(cpq-plan §2).

-- --------------------------------------------------------------------
-- [신규적재 D-04] 우드거치대 자재 — 엽서캘린더(110) (재사용·search-before-mint)
-- 엑셀: 디자인 엽서 추가상품=우드거치대 4000. Q13=자재(가공컬럼에 있으나 자재 단일귀속).
-- 라이브 MAT_000034 "캘린더부자재 우드거치대"(MAT_TYPE.07) 실재·미연결 → mint 0, 재사용.
-- INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn)
-- VALUES ('PRD_000110','MAT_000034','USAGE.07','N',99,now(),'N')
-- ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
--   (주의: t_prd_product_materials 에 note 컬럼 없음 → 변경이력=reg_dt=now()로만 추적)

-- --------------------------------------------------------------------
-- [신규적재 D-05] 삼각대 거치 = 공정 — 탁상(108)·미니(109) (Q-DC-B)
-- 라이브: 삼각대(MAT_000252 그레이/254 블랙)가 MAT_TYPE.07 자재로 적재. 정답=거치 공정.
-- 삼각대거치 공정 마스터 부재(거치/삼각대/세움 LIKE 0건) → mint 선행 필요(ddl-proposer).
-- 부모 공정 mint 후:
-- INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, del_yn)
-- VALUES ('PRD_000108','<삼각대거치 신규 PROC>','N',10,now(),'N'),
--        ('PRD_000109','<삼각대거치 신규 PROC>','N',10,now(),'N')
-- ON CONFLICT (prd_cd, proc_cd) DO NOTHING;
-- + 삼각대컬러(그레이/블랙) param은 cpq-plan §3(공정 옵션) — 적재처 결정 후.
-- + 자재행 논리삭제(아래 동시):
-- UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now()
--  WHERE (prd_cd,mat_cd)=('PRD_000108','MAT_000252') AND del_yn='N';
-- UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now()
--  WHERE (prd_cd,mat_cd)=('PRD_000109','MAT_000254') AND del_yn='N';

-- --------------------------------------------------------------------
-- [신규적재 D-06] 페이지/장수 + 캘린더가공 택1 옵션 — 5상품 (cpq-plan §3·§4)
-- 디자인캘린더=고정 페이지(30P/26P/12P/13P)·캘린더가공 택1(삼각대/타공/트윈링/우드/없음).
-- 라이브 option_groups 0행 → CPQ 미적재. 적재는 cpq-plan 설계 + Q12(택1/자유) 후.
-- INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, mand_yn, ...) VALUES (...);

-- --------------------------------------------------------------------
-- [컨펌대기 D-07] 탁상/미니 링 블랙 잉여 자재 — 논리삭제 (Q-DC-C)
-- 탁상/미니=삼각대 거치(트윈링 아님) → MAT_000253 링 부착 자체가 오류.
-- UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now()
--  WHERE prd_cd IN ('PRD_000108','PRD_000109') AND mat_cd='MAT_000253' AND del_yn='N';

-- --------------------------------------------------------------------
-- [컨펌대기 D-08] 벽걸이/와이드 링 → 트윈링제본 공정 param (Q-DC-C)
-- MAT_000253 링칼라=트윈링제본(PROC_000021·이미 적재)의 색 param. 자재행 잉여.
-- 링칼라=블랙 param → prcs_dtl_opt/ref_param_json(cpq-plan §3). 그 후 자재행 논리삭제:
-- UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now()
--  WHERE prd_cd IN ('PRD_000111','PRD_000112') AND mat_cd='MAT_000253' AND del_yn='N';

-- --------------------------------------------------------------------
-- [컨펌대기 D-09/D-10] 미니/와이드 전용 카테고리 재연결 (Q-DC-D)
-- 라이브: 미니(109)→CAT_000112(탁상형)·와이드(112)→CAT_000115(벽걸이).
-- 전용 노드 실재·미연결: CAT_000113(미니탁상)·CAT_000116(와이드벽걸이·lvl3).
-- 재연결 시(디지털 카테고리 패턴 — INSERT 정상 + 기존 main 강등):
-- INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, note, reg_dt, upd_dt)
-- VALUES ('PRD_000109','CAT_000113','Y',1,'정정 2026-06-14: 미니탁상 전용노드',now(),now()),
--        ('PRD_000112','CAT_000116','Y',1,'정정 2026-06-14: 와이드 전용노드',now(),now())
-- ON CONFLICT (prd_cd, cat_cd) DO UPDATE SET main_cat_yn='Y', upd_dt=now(), note=EXCLUDED.note;
-- UPDATE t_prd_product_categories SET main_cat_yn='N', upd_dt=now(),
--        note=COALESCE(note,'')||' | 정정 2026-06-14: 전용노드로 이전'
--  WHERE (prd_cd,cat_cd) IN (('PRD_000109','CAT_000112'),('PRD_000112','CAT_000115')) AND main_cat_yn='Y';
--   ※ 엑셀 구분(탁상형/벽걸이) 유지가 정답일 수도 → Q-DC-D 컨펌 후에만.

-- --------------------------------------------------------------------
-- [컨펌대기 D-11] 디자인캘린더 종이 권위 — 명시 몽블랑190g vs *별도설정 (Q-DC-E)
-- 같은 상품 두 surface의 종이 확정도 충돌. 자재 변경은 컨펌 후(임의 변경 금지).
