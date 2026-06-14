-- =====================================================================
-- 디지털인쇄 라이브 정정 적재본 (apply.sql) · round-13 / 2026-06-14
-- 정답 권위: 원본 엑셀 L1 최신 24_master-extract-260610/digital-print-l1.csv
-- [HARD] 실제 COMMIT은 인간 승인 후 실행. 파일은 보유하되 자동 실행 금지.
-- 멱등: WHERE 현재값 조건 / ON CONFLICT DO UPDATE → 재실행 시 0행 또는 동일결과.
-- 비파괴: COMMIT/DDL/DELETE 없음. 고아 연결은 hard-delete 아닌 논리강등(main_cat_yn='N'+note).
-- 타임스탬프: INSERT reg_dt=now() / UPDATE upd_dt=now() + note 변경이력.
-- 레더 패턴(23_remediation-apply/leather/apply.sql) 계승.
-- =====================================================================

BEGIN;

-- =====================================================================
-- [즉시적용 1] 카테고리 재연결 — 배경지/케이스/헤더택/라벨택 4상품
-- 진짜 포장 노드(이미 실재·비어있음)에 새 연결 INSERT + 가짜 고아 296 연결 논리강등.
-- PK=(prd_cd,cat_cd) 복합이라 cat_cd UPDATE 불가 → INSERT 신규 + 고아행 논리정리.
-- search-before-mint: CAT_000273/274/275/283 전부 라이브 실재(upr=CAT_000012 포장·lvl2).
-- 근거: extraction-plan §축⑥ · product-identity F-ID-3 / F-GATE-1 · 260610 L1 MES 012 prefix.
-- =====================================================================

-- 1a. 진짜 포장 노드에 정상 연결 INSERT (멱등: ON CONFLICT DO UPDATE)
INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, note, reg_dt, upd_dt)
VALUES
  ('PRD_000043','CAT_000273','Y',1,'정정 2026-06-14: 고아 CAT_000296→정상 인쇄배경지(OPP봉투타입) 012하위',now(),now()),
  ('PRD_000044','CAT_000274','Y',1,'정정 2026-06-14: 고아 CAT_000296→정상 인쇄배경지(투명케이스타입) 012하위',now(),now()),
  ('PRD_000045','CAT_000275','Y',1,'정정 2026-06-14: 고아 CAT_000296→정상 인쇄헤더택 012하위',now(),now()),
  ('PRD_000046','CAT_000283','Y',1,'정정 2026-06-14: 고아 CAT_000296→정상 라벨/포장스티커 012하위',now(),now())
ON CONFLICT (prd_cd, cat_cd) DO UPDATE
  SET main_cat_yn='Y', upd_dt=now(),
      note=EXCLUDED.note;

-- 1b. 가짜 고아 노드(CAT_000296) 연결 논리강등 (hard-delete 아님 — main_cat_yn='N'+note)
--     del_yn 컬럼 부재 → 메인 해제로 논리정리. 완전 해제는 컨펌 후 별도(Q-ID-B).
UPDATE t_prd_product_categories
   SET main_cat_yn='N', upd_dt=now(),
       note=COALESCE(note,'')||' | 정정 2026-06-14: 고아 296 메인 해제(정상 노드로 이전)'
 WHERE prd_cd IN ('PRD_000043','PRD_000044','PRD_000045','PRD_000046')
   AND cat_cd='CAT_000296'
   AND main_cat_yn='Y';   -- 멱등: 이미 N이면 0행

-- =====================================================================
-- 위까지가 즉시적용분. 아래는 모두 컨펌대기 — 주석 처리(실행 안 함).
-- =====================================================================

COMMIT;   -- [HARD] 인간 승인 후에만 실제 실행.

-- =====================================================================
-- ============== 컨펌대기 블록 (실행 금지 · 설계 보존용) ==============
-- =====================================================================

-- --------------------------------------------------------------------
-- [컨펌대기 W-05] 상품권 041/042 카테고리 — 정상 상위 노드 미확정 (Q-ID-B)
-- 041/042가 고아 CAT_000295(상품권·upr=NULL)에 연결. 어느 판매 분류 밑에 둘지 미정.
-- 후보: 03 인쇄홍보물 하위 또는 신설. 컨펌 후 1a 패턴으로 재연결.
-- --------------------------------------------------------------------
-- INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, note, reg_dt, upd_dt)
-- VALUES ('PRD_000041','<확정노드>','Y',1,'정정 2026-06-14: 상품권 정상노드 연결',now(),now()),
--        ('PRD_000042','<확정노드>','Y',1,'정정 2026-06-14: 상품권 정상노드 연결',now(),now())
-- ON CONFLICT (prd_cd,cat_cd) DO UPDATE SET main_cat_yn='Y', upd_dt=now();

-- --------------------------------------------------------------------
-- [컨펌대기 W-07/W-10/W-13] 전용 커팅/접지 공정 연결 — 형상값 적재처 부재 (Q-DP-D)
-- 완칼(PROC_000053)·접지(PROC_000056) 부모 공정 연결은 가능하나,
-- 형상 세부값(기본형/타공형/사각/원형 등)을 담을 prcs_dtl_opt 류 테이블이 라이브 부재(실측 0건).
-- → 부모 공정만 연결하면 "모양 구분 없는 커팅"이 되어 정보 손실. 형상=CPQ option_items 경유(cpq-plan §3) 권장.
-- 부모 공정 연결만 먼저 적용하려면 아래(형상값은 별도):
-- INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, del_yn)
-- VALUES
--   ('PRD_000043','PROC_000053','N',10,now(),'N'),   -- 배경지OPP 완칼
--   ('PRD_000044','PROC_000056','N',10,now(),'N'),   -- 케이스 접지
--   ('PRD_000046','PROC_000053','N',10,now(),'N')    -- 라벨택 완칼
-- ON CONFLICT (prd_cd,proc_cd) DO NOTHING;
--   (주의: t_prd_product_processes 에 note 컬럼 없음 → 변경이력은 reg_dt=now()로만 추적)

-- --------------------------------------------------------------------
-- [컨펌대기 W-08/W-11] 봉투/케이스 세트 — 적재 모델 미결 (Q-ID-A)
-- (a) sets 모델 예시 (배경지=상품, 봉투=하위). 봉투 상품 PRD는 base_prd_cd로 실재(PRD_000001/002).
--     단 사이즈매칭(6사이즈×매칭봉투)은 단순 sets로 표현 불가 → CPQ constraint 필요(cpq-plan §2).
-- INSERT INTO t_prd_product_sets (prd_cd, sub_prd_cd, sub_prd_qty, disp_seq, note, reg_dt, del_yn)
-- VALUES ('PRD_000043','PRD_000001',1,1,'정정 2026-06-14: OPP봉투 세트',now(),'N')
-- ON CONFLICT DO NOTHING;
-- (b) addon 모델 예시 (엽서와 동형, tmpl_cd 재사용 TMPL-000005 OPP접착봉투):
-- INSERT INTO t_prd_product_addons (prd_cd, tmpl_cd, disp_seq, note, reg_dt)
-- VALUES ('PRD_000043','TMPL-000005',1,'정정 2026-06-14: OPP접착봉투 추가상품',now())
-- ON CONFLICT (prd_cd,tmpl_cd) DO NOTHING;
-- W-11 PP투명케이스: tmpl 부재(검색 0건) → 케이스 상품 신설 선행 필요(데이터 신설, ddl 아님). 컨펌.

-- --------------------------------------------------------------------
-- [컨펌대기 W-06] 박색 8종 — CPQ 옵션 vs 박 본체 공정 추가 (Q-DP-C)
-- 라이브 전역 일관 패턴: 박 쓰는 8상품(027/029/031/034/037/042/069/070) 전부
-- 부모 PROC_000033(박) 없이 자식 8색(037~044)만 연결. 042만의 결함 아님.
-- → 8색=선택옵션(CPQ option_items)으로 보면 부모 박 미연결이 정합일 수 있음.
--   부모 박 공정을 명시 연결하려면(전 8상품 일괄):
-- INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, del_yn)
-- SELECT DISTINCT prd_cd,'PROC_000033','N',9,now(),'N'
--   FROM t_prd_product_processes
--  WHERE proc_cd IN ('PROC_000037','PROC_000038','PROC_000039','PROC_000040',
--                    'PROC_000041','PROC_000042','PROC_000043','PROC_000044')
-- ON CONFLICT (prd_cd,proc_cd) DO NOTHING;

-- --------------------------------------------------------------------
-- [컨펌대기 W-18] 배경지 종이 누락분 — 엑셀 종이 행 재확인 후 (load-execution)
-- 라이브 스노우지250(MAT_000091) 1행. 엑셀 추가 종이 확인 후 누락분 INSERT.
-- INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, ...) VALUES (...) ON CONFLICT DO NOTHING;
