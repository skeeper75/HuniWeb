-- =====================================================================
-- 상품악세사리 라이브 정정 적재본 (apply.sql) · round-13 / 2026-06-14
-- 정답 권위: 원본 엑셀 L1 최신 24_master-extract-260610/product-accessory-l1.csv
-- [HARD] 실제 COMMIT은 인간 승인 후 실행. 파일은 보유하되 자동 실행 금지.
-- 멱등: WHERE 현재값 조건 / ON CONFLICT DO UPDATE → 재실행 시 0행 또는 동일결과.
-- 비파괴: COMMIT/DDL/DELETE 없음. 고아 연결은 hard-delete 아닌 논리강등(main_cat_yn='N'+note).
-- 타임스탬프: INSERT reg_dt=now() / UPDATE upd_dt=now() + note 변경이력.
-- 디지털인쇄 패턴(23_remediation-apply/digital-print/apply.sql) 계승 + MINOR 반영
--   (ON CONFLICT 무동작 멱등 — note가 실제 다를 때만 갱신).
-- =====================================================================

BEGIN;

-- =====================================================================
-- [즉시적용 W-01] 카테고리 재연결 — 부자재 15상품 전부
-- 가짜 고아 노드 CAT_000293(상품악세사리·upr=NULL·lvl3)에 묶인 15상품을
-- 진짜 포장(012) 하위 정상 노드에 재연결.
-- 라이브 실측(2026-06-14): 상품명 동명 lvl3 세부노드 11개(277~292) 실재 → 1:1 매칭.
--   세부노드 부재 4상품(008/010/013/015)은 상위 lvl2(276/287)로 연결(무리한 mint 회피·Q-PA-A2).
-- PK=(prd_cd,cat_cd) 복합이라 cat_cd UPDATE 불가 → INSERT 신규 + 고아행 논리강등.
-- search-before-mint: 대상 노드 전부 라이브 실재(신규 mint 0).
-- 근거: product-identity F-PA-2 · correction-manifest PA-01 · 260610 L1 MES 012 prefix
--       · 반례 = PRD_000283(트레싱지봉투 추가상품)이 이미 정상 CAT_000276 연결.
-- =====================================================================

-- 1a. 진짜 포장 정상 노드에 1:1 연결 INSERT (멱등: ON CONFLICT DO UPDATE·note 다를 때만)
INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, note, reg_dt, upd_dt)
VALUES
  ('PRD_000001','CAT_000277','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 OPP접착봉투(012하위)',now(),now()),
  ('PRD_000002','CAT_000278','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 OPP비접착봉투(012하위)',now(),now()),
  ('PRD_000003','CAT_000281','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 트레싱지봉투(012하위)',now(),now()),
  ('PRD_000004','CAT_000280','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 카드봉투(012하위)',now(),now()),
  ('PRD_000005','CAT_000282','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 캘린더봉투(012하위)',now(),now()),
  ('PRD_000006','CAT_000291','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 볼체인(012하위)',now(),now()),
  ('PRD_000007','CAT_000292','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 와이어링(012하위)',now(),now()),
  ('PRD_000008','CAT_000287','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 상품액세서리(천정고리·세부노드 부재→상위 lvl2)',now(),now()),
  ('PRD_000009','CAT_000279','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 투명케이스(012하위)',now(),now()),
  ('PRD_000010','CAT_000276','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 봉투/케이스(행택끈·세부노드 부재→상위 lvl2)',now(),now()),
  ('PRD_000011','CAT_000286','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 자석고정용고무판(012하위)',now(),now()),
  ('PRD_000012','CAT_000288','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 우드거치대(012하위)',now(),now()),
  ('PRD_000013','CAT_000287','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 상품액세서리(우드봉·세부노드 부재→상위 lvl2)',now(),now()),
  ('PRD_000014','CAT_000289','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 우드행거(012하위)',now(),now()),
  ('PRD_000015','CAT_000287','Y',1,'정정 2026-06-14: 고아 CAT_000293→정상 상품액세서리(만년스탬프리필잉크·세부노드 부재→상위 lvl2)',now(),now())
ON CONFLICT (prd_cd, cat_cd) DO UPDATE
  SET main_cat_yn='Y', upd_dt=now(), note=EXCLUDED.note
  WHERE t_prd_product_categories.main_cat_yn IS DISTINCT FROM 'Y'
     OR t_prd_product_categories.note IS DISTINCT FROM EXCLUDED.note;   -- 무동작 멱등(MINOR 반영)

-- 1b. 가짜 고아 노드(CAT_000293) 연결 논리강등 (hard-delete 아님 — main_cat_yn='N'+note)
--     del_yn 컬럼 부재 → 메인 해제로 논리정리. 완전 해제는 컨펌 후 별도(Q-PA-A).
UPDATE t_prd_product_categories
   SET main_cat_yn='N', upd_dt=now(),
       note=COALESCE(note,'')||' | 정정 2026-06-14: 고아 293 메인 해제(정상 노드로 이전)'
 WHERE prd_cd IN ('PRD_000001','PRD_000002','PRD_000003','PRD_000004','PRD_000005',
                  'PRD_000006','PRD_000007','PRD_000008','PRD_000009','PRD_000010',
                  'PRD_000011','PRD_000012','PRD_000013','PRD_000014','PRD_000015')
   AND cat_cd='CAT_000293'
   AND main_cat_yn='Y';   -- 멱등: 이미 N이면 0행

-- =====================================================================
-- 위까지가 즉시적용분. 아래는 모두 컨펌대기/신규적재 — 주석 처리(실행 안 함).
-- =====================================================================

COMMIT;   -- [HARD] 인간 승인 후에만 실제 실행.

-- =====================================================================
-- ============== 컨펌대기/신규적재 블록 (실행 금지 · 설계 보존용) ==============
-- =====================================================================

-- --------------------------------------------------------------------
-- [컨펌대기 W-02] 색상 variant 자재 오염 정정 — 색상≠자재 (Q-PA-B)
-- 라이브: 볼체인 8색(MAT_000202~209)·와이어링 3색(210/212/213)·행택끈 3종(217/219/220)
--         ·리필잉크 7색(232~239) = 전부 t_mat_materials MAT_TYPE.10·USAGE.07 (색상 오염).
-- 정답: 색상=t_prd_product_option_items(option_group 택1) · 묶음/용량은 자재명에서 분리(bundle/siz).
-- → option_groups/items 테이블 실재(ddl 불요). 오염 자재행은 논리삭제(del_yn='Y').
-- 단 색상=옵션 vs 별SKU 컨펌(Q-PA-B) 전이라 보류.
-- (a) 색상 옵션 그룹 신설 예시(볼체인):
-- INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, mand_yn, min_sel_cnt, max_sel_cnt, reg_dt)
-- VALUES ('PRD_000006','<신규 OPT-GRP>','색상','SEL_TYP.01','Y',1,1,now()) ON CONFLICT DO NOTHING;
-- INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, qty, use_yn, reg_dt)
-- VALUES ('PRD_000006','<opt>',1,'OPT_REF_DIM.색상','오렌지',1,'Y',now()), ... 8색;
-- (b) 오염 자재행 논리삭제(006/007/010/015 일괄·hard-delete 금지):
-- UPDATE t_prd_product_materials SET use_yn='N', upd_dt=now()
--  WHERE prd_cd IN ('PRD_000006','PRD_000007','PRD_000010','PRD_000015')
--    AND mat_cd IN (SELECT mat_cd FROM t_mat_materials WHERE mat_typ_cd='MAT_TYPE.10');
-- (주의: t_prd_product_materials 변경이력은 upd_dt로만 — note 컬럼 확인 필요)

-- --------------------------------------------------------------------
-- [신규적재 W-03] 부자재 가격 적재 — 가격포함 시트인데 가격 0 (round-2 양식·load-execution)
-- 라이브 t_prc_* 가격 사슬에 부자재 단가 전무(공식 0·component 0).
-- L1 명시 단가: 볼체인 1000·와이어링 500·천정고리 6500·행택끈 3000/4000·우드거치대 4000
--               ·우드봉 7000/9800/12000·우드행거 16000/18000/20000·리필잉크 2500
--               ·트래싱지 6000/12000/28000/… (치수×묶음 격자)·카드봉투 1000/1500.
-- → 고정가형 가격구성요소(t_prc_price_components prc_typ_cd=단가) + 공식(t_prc_price_formulas)
--    + variant 단가(t_prc_component_prices). round-2 양식. dbm-price-import-prep/load-execution 라우팅.
-- (구조: 봉투=치수×묶음 격자 / 색상부자재=색상별 고정가 / 우드=길이별 고정가)

-- --------------------------------------------------------------------
-- [컨펌대기 W-04 / Q-ID-A] 봉투/케이스 세트 — 적재 모델 미결
-- 배경지(043/044)가 봉투(PRD_000001/002/009)를 세트 동봉. 봉투 상품·template 실재.
-- 라이브: 배경지 addon 0·sets 0 (sets 테이블 자체는 28행 정상).
-- §correction-manifest Q-ID-A 권고 = (a) sets + (c) CPQ 사이즈매칭 캐스케이드 병행.
-- INSERT INTO t_prd_product_sets (prd_cd, sub_prd_cd, sub_prd_qty, disp_seq, note, reg_dt, del_yn)
-- VALUES ('PRD_000043','PRD_000001',1,1,'정정 2026-06-14: OPP봉투 세트',now(),'N') ON CONFLICT DO NOTHING;
-- 사이즈매칭(배경지 siz↔봉투 siz)은 CPQ constraint 필요(cpq-plan §2). Q-ID-A 컨펌 후.

-- --------------------------------------------------------------------
-- [컨펌대기 W-05/W-10] 사이즈 3축 분해 — 치수×묶음 평면화 (Q-PA-C)
-- 트래싱지(003): 라이브 8 siz(3치수 160x110/100x100/70x100 × 묶음 20/40/100장 평면화).
-- 정답: siz=3치수 + bundle_qtys=묶음수. 봉투류 siz_nm 묶음수("(50장)") 잔존 정리.
-- → siz 축약은 적재된 가격 사슬(치수×묶음 격자) 파손 위험 → schema-design-intent-first.
--    book/굿즈 묶음수 처리 정합 + Q-PA-C 컨펌 후 (기계적 size 삭제 금지·메모리 round-10 교훈).

-- --------------------------------------------------------------------
-- [신규적재/컨펌 W-06] 묶음수 — bundle_qtys 미적재
-- 볼체인 3개1팩·천정고리 2개1세트·행택끈 100개 → 묶음수 칸에 안 들어감(라이브 006/007/008/010=0).
-- INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, qty_unit_cd, disp_seq, reg_dt)
-- VALUES ('PRD_000006',3,'QTY_UNIT.05',1,now()),    -- 3개1팩
--        ('PRD_000008',2,'QTY_UNIT.04',1,now()),    -- 2개1세트
--        ('PRD_000010',100,'QTY_UNIT.01',1,now())   -- 100개
-- ON CONFLICT DO NOTHING;  -- 단위(팩/세트/개) 표준 Q-PA-E 동반.

-- --------------------------------------------------------------------
-- [컨펌대기 W-07 / Q-PA-G] 우드봉·우드행거 길이 variant — 적재처 미결
-- 우드봉 270/360/480mm·우드행거 230/320/440mm(+면끈) → 라이브 siz·material·option 전부 0.
-- (a) 길이=siz(치수형) vs (b) 옵션. 본체가공 옵션 vs 별매 template (domain-research PA-4·캘린더 CL-2 일괄).
-- Q-PA-G 컨펌 후.

-- --------------------------------------------------------------------
-- [컨펌대기 W-08 / Q-PA-D] 카드봉투 색상·이중등록 역할
-- 004(기성 PRD_TYPE.03·색상 siz_nm 합성 "화이트165x115/블랙165x115") vs
-- 281 카드봉투(화이트)·282 카드봉투(블랙)(추가 PRD_TYPE.05·별 PRD·template base).
-- 색상 처리 일원화 + 역할 분리 컨펌. 이중등록 자체는 의도(W-12 CORRECT).

-- --------------------------------------------------------------------
-- [컨펌대기 W-09 / Q-PA-E] 묶음 단위 통일
-- OPP접착봉투(001)=QTY_UNIT.01(EA) vs OPP비접착봉투(002)=QTY_UNIT.02(매) — 같은 "장"인데 단위 혼선.
-- UPDATE t_prd_product_bundle_qtys SET qty_unit_cd='<통일단위>', upd_dt=now()
--  WHERE prd_cd='PRD_000001';  -- 후니 표준 단위 Q-PA-E 결정 후.

-- --------------------------------------------------------------------
-- [컨펌대기 W-11 / Q-PA-F] 천정고리 use_yn=N
-- 라이브 PRD_000008 use_yn=N(비활성)·MES NULL. L1엔 가격 6500 존재.
-- 판매중지 의도면 유지·적재 누락이면 복원:
-- UPDATE t_prd_products SET use_yn='Y', upd_dt=now() WHERE prd_cd='PRD_000008' AND use_yn='N';
-- Q-PA-F 컨펌 후.
