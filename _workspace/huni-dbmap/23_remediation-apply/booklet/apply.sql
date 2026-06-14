-- =====================================================================
-- 책자(booklet) 라이브 정정 적재본 (apply.sql) · round-13 / 2026-06-14
-- 정답 권위: 원본 엑셀 L1 최신 24_master-extract-260610/booklet-l1.csv (byte동일·유효)
-- [HARD] 실제 COMMIT은 인간 승인 후 실행. 파일은 보유하되 자동 실행 금지.
-- 멱등: WHERE 현재값 조건 / ON CONFLICT DO UPDATE → 재실행 시 0행 또는 동일결과.
-- 비파괴: COMMIT/DDL/DELETE 없음. 고아/잉여 연결은 hard-delete 아닌 논리강등·논리삭제.
-- 타임스탬프: INSERT reg_dt=now() / UPDATE upd_dt=now() / 논리삭제 del_yn='Y'+del_dt=now().
--            note 컬럼 있는 테이블만 "정정 2026-06-14: X→Y" 기록(materials/processes엔 note 부재).
-- 레더 패턴(23_remediation-apply/leather/apply.sql)·디지털 패턴(../digital-print/apply.sql) 계승.
-- 책자 특수성: 반제품=표지+내지 결합 전체관점(Q3). 자재 권위=완제품 usage_cd, 반제품은 빈 껍데기.
-- =====================================================================

BEGIN;

-- =====================================================================
-- [즉시적용 1] BK-CAT — 책자 7상품 전용 잎노드 재연결
-- 각 상품을 자기 전용 잎노드(이미 실재·상품 0=고아)에 새 연결 INSERT + 잘못된 윗칸 연결 main 강등.
-- PK=(prd_cd,cat_cd) 복합 → cat_cd UPDATE 불가 → INSERT 신규 + 기존 연결 논리강등.
-- search-before-mint: CAT_000100/101/102/103/106/107/131 전부 라이브 실재(신설 0).
--   068→중철책자(100,L2)·069→무선책자(101,L2)·070→PUR책자(102,L2)·071→트윈링책자(103,L2)
--   077→레더하드커버책자(106,L3)·082→하드커버링책자(107,L3)·088→레더링바인더(131,L3)
-- 근거: product-identity F-ID-5/BK-CAT · live-diff 카테고리 실측 · 디지털 배경지 296→273 재연결 동형.
-- =====================================================================

-- 1a. 전용 잎노드에 정상 연결 INSERT (멱등: ON CONFLICT DO UPDATE)
INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, note, reg_dt, upd_dt)
VALUES
  ('PRD_000068','CAT_000100','Y',1,'정정 2026-06-14: 책자(L1)→전용 중철책자(L2)',now(),now()),
  ('PRD_000069','CAT_000101','Y',1,'정정 2026-06-14: 책자(L1)→전용 무선책자(L2)',now(),now()),
  ('PRD_000070','CAT_000102','Y',1,'정정 2026-06-14: 책자(L1)→전용 PUR책자(L2)',now(),now()),
  ('PRD_000071','CAT_000103','Y',1,'정정 2026-06-14: 책자(L1)→전용 트윈링책자(L2)',now(),now()),
  ('PRD_000077','CAT_000106','Y',1,'정정 2026-06-14: 하드커버책자(105)→전용 레더하드커버책자(106)',now(),now()),
  ('PRD_000082','CAT_000107','Y',1,'정정 2026-06-14: 하드커버책자(105)→전용 하드커버링책자(107)',now(),now()),
  ('PRD_000088','CAT_000131','Y',1,'정정 2026-06-14: 하드커버책자(105)→전용 레더링바인더(131)',now(),now())
ON CONFLICT (prd_cd, cat_cd) DO UPDATE
  SET main_cat_yn='Y', upd_dt=now(), note=EXCLUDED.note;

-- 1b. 잘못된 윗칸 연결 main 강등 (hard-delete 아님 — main_cat_yn='N'+note)
--     068~071: 책자 lvl1 직결 강등 / 077·082·088: 하드커버책자(105) 잉여 연결 강등.
UPDATE t_prd_product_categories
   SET main_cat_yn='N', upd_dt=now(),
       note=COALESCE(note,'')||' | 정정 2026-06-14: 상위 책자(L1) 직결 main 강등(전용 잎노드로 이전)'
 WHERE prd_cd IN ('PRD_000068','PRD_000069','PRD_000070','PRD_000071')
   AND cat_cd='CAT_000006'
   AND main_cat_yn='Y';   -- 멱등: 이미 N이면 0행

UPDATE t_prd_product_categories
   SET main_cat_yn='N', upd_dt=now(),
       note=COALESCE(note,'')||' | 정정 2026-06-14: 하드커버책자(105) 잉여 연결 main 강등(전용 잎노드로 이전)'
 WHERE prd_cd IN ('PRD_000077','PRD_000082','PRD_000088')
   AND cat_cd='CAT_000105'
   AND main_cat_yn='Y';   -- 멱등: 이미 N이면 0행

-- =====================================================================
-- [즉시적용 2] BK-4 — 떡메모지 097 카테고리 2중 주카테고리 정리
-- 097이 떡메모지(CAT_000129·L3 잎·정답)+노트(CAT_000124·L2 중간)에 둘 다 main='Y'.
-- 노트 연결을 main 강등(떡메모지 단일 주카테고리 유지). 잎노드가 정답이라 노트는 잉여.
-- 근거: product-identity F-ID-3 · live-diff §BK-4 실측(2행 둘 다 main='Y').
-- =====================================================================
UPDATE t_prd_product_categories
   SET main_cat_yn='N', upd_dt=now(),
       note=COALESCE(note,'')||' | 정정 2026-06-14: 노트(L2 중간) 잉여 main 강등(떡메모지 L3 단일 주카테고리)'
 WHERE prd_cd='PRD_000097'
   AND cat_cd='CAT_000124'
   AND main_cat_yn='Y';   -- 멱등: 이미 N이면 0행

-- =====================================================================
-- [즉시적용 3] BK-1 — 떡메모지 097 백색모조120 공통 복제행 논리삭제
-- 백색모조120(MAT_000073)이 내지(USAGE.01)+공통(USAGE.07) 2행. 떡메모지=내지만(표지·링 없음).
-- 공통 복제행만 del_yn='Y' 논리삭제(내지 .01 행 보존). materials엔 note 부재 → del_dt로만 이력.
-- 근거: loadlogic LL-1(용도 빈→USAGE.공통 떨굼) · live-diff §BK-1 · F-GATE-BK-3(전 DB 1건=097만).
-- 멱등: del_yn='N' 조건 → 이미 'Y'면 0행.
-- =====================================================================
UPDATE t_prd_product_materials
   SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000097'
   AND mat_cd='MAT_000073'
   AND usage_cd='USAGE.07'
   AND del_yn='N';

-- =====================================================================
-- [즉시적용 4] BK-2 — 반제품 078 몽블랑130g 자재 오적재 논리삭제
-- 반제품 078(레더하드커버책자-표지)에 레더 아닌 몽블랑130g(MAT_000105) USAGE.01/.02 2행.
-- 반제품은 빈 껍데기여야 정상(자재 권위=완제품 077 usage_cd, 라이브 21 sub_prd 중 078만 자재 보유).
-- 2행 모두 del_yn='Y' 논리삭제(완제품 077 레더 .02 정상이라 표지 자재 손실 없음).
-- 근거: loadlogic LL-4(v03 14에 PRD_000078 잡음 행) · live-diff §BK-2 · Q3 반제품 0행 정상.
-- 멱등: del_yn='N' 조건.
-- =====================================================================
UPDATE t_prd_product_materials
   SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000078'
   AND mat_cd='MAT_000105'
   AND usage_cd IN ('USAGE.01','USAGE.02')
   AND del_yn='N';

-- =====================================================================
-- 위까지가 즉시적용분. 아래는 모두 컨펌대기 — 주석 처리(실행 안 함).
-- =====================================================================

COMMIT;   -- [HARD] 인간 승인 후에만 실제 실행.

-- =====================================================================
-- ============== 컨펌대기 블록 (실행 금지 · 설계 보존용) ==============
-- =====================================================================

-- --------------------------------------------------------------------
-- [컨펌대기 BK-6] 레더 링바인더 088 후공정 — 실제 존재 여부 미확정 (Q-BK-D)
-- 088 공정 0행(제본·수축포장·재단 전무). 제본 없음=정당(D링 결합)이나 수축포장 등 후공정 불명.
-- 다른 책자 8/10이 수축포장(PROC_000076) 보유. 088만 0행 → v03 15에 PRD_000088 공정 행 없음.
-- 후공정 존재 확인 시 아래(수축포장 예시). processes엔 note 부재 → reg_dt로만 이력.
-- INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, del_yn)
-- VALUES ('PRD_000088','PROC_000076','N',9,now(),'N')   -- 수축포장
-- ON CONFLICT (prd_cd,proc_cd) DO NOTHING;

-- --------------------------------------------------------------------
-- [컨펌대기 BK-7] 책자 plate 출력용지규격(폴더) 미적재 (Q-BK-C)
-- plate 32행 전부 output_paper_typ_cd NULL. L1 폴더(C12/C23: 책자/디지털/실사/특수인쇄) 미옮김.
-- 출력용지규격으로 적재할지 / 생산 라우팅 메타(견적 밖)로 둘지 결정 후.
-- 적재 시 OUTPUT_PAPER_TYPE 도메인 코드 매핑 선행(현 load_master는 "있으면 기타" 단순화).
-- UPDATE t_prd_product_plate_sizes SET output_paper_typ_cd='<확정코드>', upd_dt=now()
--  WHERE prd_cd BETWEEN 'PRD_000068' AND 'PRD_000098' AND output_paper_typ_cd IS NULL;

-- --------------------------------------------------------------------
-- [컨펌대기 BK-8] 떡메모지 097 page_rule 3/3/3 잡음 정리 (Q-BK-B)
-- page_rule 3/3/3(무의미) + bundle 50/100권(권위). 진짜 축은 묶음수(권).
-- page_rules엔 del_yn 컬럼 없음 → 논리삭제 불가. 제거는 (a) 행 DELETE 또는 (b) 값 NULL화 결정 필요.
-- (둘 다 컨펌 — DELETE는 비파괴 원칙상 보류, NULL화도 page_min NOT NULL 가능성 점검 선행)
-- 예시(b): UPDATE t_prd_product_page_rules SET note=COALESCE(note,'')||' | 정정: 3/3/3 잡음(묶음수=권위)' WHERE prd_cd='PRD_000097';

-- --------------------------------------------------------------------
-- [컨펌대기 BK-5] 잉여 고아 카테고리 노드 CAT_000297 논리삭제 (Q-BK-E)
-- "레드프린팅 책자 가이드"(upr=NULL·lvl3 고아·상품 0). URL 안내행이 카테고리로 파생된 잡음.
-- t_cat_categories는 use_yn 보유(del_yn 아님)·note 부재 → use_yn='N' 논리삭제. 상품 0이라 안전.
-- 디지털 296/295와 동형 횡단 → 일괄 처리 권장.
-- UPDATE t_cat_categories SET use_yn='N' WHERE cat_cd='CAT_000297' AND use_yn='Y';
