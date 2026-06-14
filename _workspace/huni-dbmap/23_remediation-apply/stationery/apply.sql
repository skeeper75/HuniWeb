-- =====================================================================
-- 문구(stationery) 라이브 정정 적재본 (apply.sql) · round-13 / 2026-06-14
-- 정답 권위: 원본 엑셀 L1 최신 24_master-extract-260610/stationery-l1.csv
-- [HARD] 실제 COMMIT은 인간 승인 후 실행. 파일은 보유하되 자동 실행 금지.
-- 멱등: WHERE 현재값 가드 / ON CONFLICT DO UPDATE → 재실행 시 0행 또는 동일결과.
-- 비파괴: COMMIT/DDL/DELETE 없음. 고아·중복 연결은 hard-delete 아닌 논리강등(main_cat_yn/use_yn='N'+note).
-- 타임스탬프: INSERT reg_dt=now() / UPDATE upd_dt=now() + note 변경이력.
-- 디지털인쇄 GO 양식(23_remediation-apply/digital-print/apply.sql) 계승.
-- MINOR 개선 반영: UPDATE에 "값이 실제 다를 때만" 가드 → 완전 무동작 멱등.
-- =====================================================================

BEGIN;

-- =====================================================================
-- [즉시적용 1 · W-ST-01] 카테고리 재연결 — 플래너 5상품
-- 진짜 문구 노드(이미 실재·비어있음)에 새 연결 INSERT + 가짜 고아 300 논리강등.
-- PK=(prd_cd,cat_cd) 복합이라 cat_cd UPDATE 불가 → INSERT 신규 + 고아행 논리정리.
-- [HARD·F-ST-G1] 노드 이름순≠prd_cd순 → 커버타입 의미 매칭(Q-ST-B 컨펌 후 실행):
--   소프트(172)→121 · 하드(173)→122 · 레더하드(174)→120 · 레더소프트(175)→119 · 먼슬리(176)→123
-- search-before-mint: CAT_000119~123 전부 라이브 실재(upr=CAT_000008 문구·lvl2). 신규 mint 0.
-- 근거: 라이브 실측 §2(노드 이름=커버타입) · 260610 L1 MES 008 prefix · product-identity ST-01.
-- =====================================================================

-- 1a. 진짜 문구 노드에 정상 연결 INSERT (멱등: ON CONFLICT DO UPDATE)
INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, note, reg_dt, upd_dt)
VALUES
  ('PRD_000172','CAT_000121','Y',1,'정정 2026-06-14: 고아 CAT_000300 플래너→정상 만년다이어리(소프트커버) 008하위',now(),now()),
  ('PRD_000173','CAT_000122','Y',1,'정정 2026-06-14: 고아 CAT_000300→정상 만년다이어리(하드커버) 008하위',now(),now()),
  ('PRD_000174','CAT_000120','Y',1,'정정 2026-06-14: 고아 CAT_000300→정상 만년다이어리(레더하드커버) 008하위',now(),now()),
  ('PRD_000175','CAT_000119','Y',1,'정정 2026-06-14: 고아 CAT_000300→정상 만년다이어리(레더소프트커버) 008하위',now(),now()),
  ('PRD_000176','CAT_000123','Y',1,'정정 2026-06-14: 고아 CAT_000300→정상 먼슬리플래너 008하위',now(),now())
ON CONFLICT (prd_cd, cat_cd) DO UPDATE
  SET main_cat_yn='Y', upd_dt=now(), note=EXCLUDED.note
  WHERE t_prd_product_categories.main_cat_yn IS DISTINCT FROM 'Y';   -- MINOR 가드: 이미 정합이면 0행

-- 1b. 가짜 고아 노드(CAT_000300) 연결 논리강등 (hard-delete 아님 — main_cat_yn='N'+note)
UPDATE t_prd_product_categories
   SET main_cat_yn='N', upd_dt=now(),
       note=COALESCE(note,'')||' | 정정 2026-06-14: 고아 300 메인 해제(정상 노드로 이전)'
 WHERE prd_cd IN ('PRD_000172','PRD_000173','PRD_000174','PRD_000175','PRD_000176')
   AND cat_cd='CAT_000300'
   AND main_cat_yn='Y';   -- 멱등: 이미 N이면 0행

-- =====================================================================
-- [즉시적용 2 · W-ST-02] 종이(백모조) 용도 .07 공통 → .01 내지
-- 라이브 실측: 백모조 USAGE.07 = v03 14시트 용도 공란 → 공통 fallback(L-ST-A).
-- 도메인 정답=내지(USAGE.01).
-- [HARD·스키마 실측] PK=(prd_cd,mat_cd,usage_cd) → usage_cd는 PK 일부라 in-place UPDATE 불가.
--   → "새 .01 행 INSERT(멱등) + 기존 .07 행 논리삭제(del_yn='Y')"로 처리(비파괴·PK 안전).
-- [HARD·스키마 실측] t_prd_product_materials 에 note 컬럼 **부재**(del_yn/del_dt 보유)
--   → 변경이력은 reg_dt/del_dt + 본 매니페스트로 추적(note 미사용).
-- 근거: col-dict L67 USAGE.01 · 라이브 실측 §3·§schema.
-- 영향 상품(종이 .07): 176·177·178·179·181 백모조100(MAT_000072)
-- 떡메모(097)는 .01 정상행 이미 존재 → .07 중복행만 논리삭제(신규 INSERT 불요).
-- =====================================================================

-- 2a. 백모조100(.07)을 쓰는 5상품: 새 .01 내지행 INSERT (멱등)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn)
VALUES
  ('PRD_000176','MAT_000072','USAGE.01','Y',1,now(),'N'),
  ('PRD_000177','MAT_000072','USAGE.01','Y',1,now(),'N'),
  ('PRD_000178','MAT_000072','USAGE.01','Y',1,now(),'N'),
  ('PRD_000179','MAT_000072','USAGE.01','Y',1,now(),'N'),
  ('PRD_000181','MAT_000072','USAGE.01','Y',1,now(),'N')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;   -- 멱등: 이미 .01 있으면 0행

-- 2b. 기존 .07 공통행 논리삭제 (hard-delete 아님 — del_yn='Y'+del_dt)
UPDATE t_prd_product_materials
   SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd IN ('PRD_000176','PRD_000177','PRD_000178','PRD_000179','PRD_000181')
   AND mat_cd='MAT_000072'   -- 백색모조지 100g
   AND usage_cd='USAGE.07'
   AND del_yn='N';   -- 멱등: 이미 Y면 0행

-- 2c. 떡메모지(097) 백모조120 .07 중복행 논리삭제 (.01 정상행 이미 존재 — 신규 불요)
UPDATE t_prd_product_materials
   SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000097'
   AND mat_cd='MAT_000073'   -- 백색모조지 120g
   AND usage_cd='USAGE.07'
   AND del_yn='N';   -- 멱등: 이미 Y면 0행

COMMIT;   -- [HARD] 인간 승인 후에만 실제 실행. (W-ST-01은 Q-ST-B 매칭 컨펌 선행)

-- =====================================================================
-- 위까지가 즉시적용분. 아래는 모두 컨펌대기/신규적재 — 주석 처리(실행 안 함).
-- =====================================================================

-- =====================================================================
-- ============== 컨펌대기·신규적재 블록 (실행 금지 · 설계 보존용) ==============
-- =====================================================================

-- --------------------------------------------------------------------
-- [신규적재 W-ST-06 / Q-ST-A] 미싱제본 — 제본 family 신설 필요
-- 라이브 제본 PROC_000017 자식 8종(중철18/무선19/PUR20/트윈링21/떡22/하드커버무선23/
--   하드커버트윈링24/레이플랫25)에 미싱제본 부재(실측 §10). 기존 미싱류 2개는 제본 아님:
--   PROC_000030 미싱(upr=NULL 후가공 줄수)·PROC_000074 6단미싱접지(upr=PROC_000056 접지).
-- → search-before-mint 결과 제본 family 재사용 후보 0. (a)신규 mint면 ddl-proposer.
-- (a) 신규 자식 mint 예시 (Q-ST-A (a) 선택 時만 — 채번=MAX+1):
-- INSERT INTO t_proc_processes (proc_cd, proc_nm, upr_proc_cd, reg_dt, del_yn)
-- VALUES ('PROC_0000NN','미싱제본','PROC_000017',now(),'N');   -- NN=채번 MAX+1
-- 이후 172/175/176 연결:
-- INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, del_yn)
-- VALUES ('PRD_000172','PROC_0000NN','Y',5,now(),'N'),
--        ('PRD_000175','PROC_0000NN','Y',5,now(),'N'),
--        ('PRD_000176','PROC_0000NN','N',5,now(),'N')   -- 먼슬리=미싱/중철 택일
-- ON CONFLICT (prd_cd,proc_cd) DO NOTHING;
--   (주의: t_prd_product_processes 에 note 컬럼 없음 → 변경이력은 reg_dt=now()로만 추적)

-- --------------------------------------------------------------------
-- [신규적재 W-ST-08 / Q-ST-H] 면지 — 만년다이어리 하드(173)·레더하드(174)
-- L1 C27 `하드커버(면지?)`. 면지 마스터 실재(실측 §12): 화이트MAT_000001·블랙002·그레이003·인쇄004(.01 종이).
-- search-before-mint=신설 0. 색 3종=variant 컨펌(Q-ST-H).
-- INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, reg_dt)
-- VALUES ('PRD_000173','MAT_000001','USAGE.03',now()), ('PRD_000174','MAT_000001','USAGE.03',now())
-- ON CONFLICT DO NOTHING;   -- USAGE.03=면지(table-spec 확인 필요)

-- --------------------------------------------------------------------
-- [컨펌대기 W-ST-09 / Q-ST-I=BK-3] 실버링 — 스프링노트(177)·수첩(178)
-- L1 C27 `실버링`. 마스터 실재(실측 §12): MAT_000016 링 실버링(.04 금속·라이브 0상품 연결=고아).
-- (a)링 부속 자재 재연결(USAGE.07) vs (b)트윈링 링색 param. 컨펌 후:
-- INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, reg_dt)
-- VALUES ('PRD_000177','MAT_000016','USAGE.07',now()), ('PRD_000178','MAT_000016','USAGE.07',now())
-- ON CONFLICT DO NOTHING;

-- --------------------------------------------------------------------
-- [컨펌대기 W-ST-03 / Q-ST-E=Q9] 표지 코팅 평면화 분해
-- 라이브: MAT_000260 "아트250 + 무광코팅"(USAGE.02) 한 행 + PROC_000015 무광 별도 연결(의미 중복).
-- 자재명을 "아트250"만으로 분리 시 가격 영향 검증 동반(컨펌·횡단 코팅 family 통일 Q9).
-- (자재 마스터명 UPDATE는 다른 상품도 참조하므로 광범위 영향 → 별도 결정)

-- --------------------------------------------------------------------
-- [컨펌대기 W-ST-05 / Q-ST-F] 떡제본 mand 통일
-- 라이브: 떡메모지(097) 떡제본 mand=N · 메모패드(179) 떡제본 mand=Y (불일치=결함 증거).
-- 떡제본 필수 여부 도메인 판단 후 일관 UPDATE:
-- UPDATE t_prd_product_processes SET mand_proc_yn='<N또는Y>'
--  WHERE proc_cd='PROC_000022' AND prd_cd IN ('PRD_000097','PRD_000179')
--    AND mand_proc_yn <> '<N또는Y>';   -- 멱등 가드

-- --------------------------------------------------------------------
-- [컨펌대기 W-ST-07 / Q-ST-G=Q-BK-B] 떡메모지 page 3/3/3 정리
-- 라이브 097 page_rule 3/3/3(실측 §5). 떡제본 낱장 page 무의미. 묶음수(50/100권)가 진짜 축.
-- 정리(use_yn=N·note) vs 장수3 유지(ST2-4). 침묵 삭제 금지(round-10 교훈) → escalate.

-- --------------------------------------------------------------------
-- [컨펌대기 W-ST-12 / Q-ST-L] B세트 — 만년다이어리 하드(173)·레더하드(174)
-- 표지 하드보드 sub_prd + sets(책자 하드커버 패턴) vs parent usage 자재만. 라이브 sets 0행.
-- 자재 권위=parent usage_cd라 sub_prd 없이 parent 자재로도 가능(booklet Q3 병행).

-- --------------------------------------------------------------------
-- [컨펌대기 W-ST-15 / Q-ST-M] 떡메모지 묶음수 dflt 중복
-- 라이브 097: bdl_qty 50권·100권 둘 다 dflt_yn=Y(실측 §7b). 택1인데 기본 2개.
-- size별(90x90→50·70x120→100) 정합이면 유지, 아니면 1개만 Y:
-- UPDATE t_prd_product_bundle_qtys SET dflt_yn='N' WHERE prd_cd='PRD_000097' AND bdl_qty=100 AND dflt_yn='Y';

-- --------------------------------------------------------------------
-- [컨펌대기 W-ST-16 / Q-ST-C=Q-BK-C] 폴더→출력용지규격
-- 라이브 output_paper_typ_cd NULL. C12/C24 폴더(디지털인쇄/특수인쇄)=인쇄방식 라우팅.
-- 출력용지규격 적재 vs 견적밖 라우팅 메타. booklet GAP-PAPER 동형.

-- --------------------------------------------------------------------
-- [컨펌대기 W-ST-10/11/13a] PVC커버·합지보드·내지 — 부속/공통풀 자재
-- PVC(메모 힌트)·합지보드(메모)·내지 일부 빈값. 부속 등록/공통풀 전개 컨펌 후 INSERT.

-- --------------------------------------------------------------------
-- [컨펌대기 W-ST-14 / Q-ST-N] 가격 — round-2 트랙 책임 (load_master 밖)
-- 라이브 t_prd_product_prices 0행(실측 §8). 고정가(9000/12000/4500…)+떡메모 매트릭스.
-- 본 라운드는 경로만 명시. 실 적재=round-2 양식(고정형 PRF + product_prices).
