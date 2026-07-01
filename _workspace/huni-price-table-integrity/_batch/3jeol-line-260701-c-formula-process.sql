-- =====================================================================
-- 3절 라인 3상품 — 가격공식 바인딩 + PROC_000004 필수공정 — 2026-07-01
-- ★DB 미적재 — DRY-RUN. COMMIT은 인간 승인 + webadmin 실화면 확인 후.
-- 멱등: NOT EXISTS 가드.
-- =====================================================================

-- ---------------------------------------------------------------------
-- A. PROC_000004(디지털인쇄 base 공정) 필수 바인딩 — 3상품 전부
--    근거: COMP_PRINT_DIGITAL_S1의 use_dims=[proc_cd,...]가 PROC_000004로 매칭.
--          공정 미바인딩이면 인쇄비 영구0(직전 18건 base-proc fix·썬캡과 동형).
--    mand_proc_yn='Y'·disp_seq='-1'(자동선택·비표시). t_prd_product_processes.
--    ★[선행성] 이 바인딩이 없으면 -b-prices의 인쇄행 148개가 있어도 인쇄비=0.
-- ---------------------------------------------------------------------
BEGIN;
INSERT INTO t_prd_product_processes (prd_cd,proc_cd,mand_proc_yn,disp_seq,reg_dt,del_yn)
SELECT v.prd_cd,'PROC_000004','Y','-1',now(),'N'
FROM (VALUES ('PRD_000030'),('PRD_000049'),('PRD_000112')) AS v(prd_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_processes x
  WHERE x.prd_cd=v.prd_cd AND x.proc_cd='PROC_000004'
);
-- 검증: SELECT prd_cd,proc_cd,mand_proc_yn FROM t_prd_product_processes
--        WHERE prd_cd IN ('PRD_000030','PRD_000049','PRD_000112') AND proc_cd='PROC_000004';
ROLLBACK;
-- COMMIT;

-- ---------------------------------------------------------------------
-- B. 가격공식 바인딩 (product ↔ frm_cd) — ★CONFIRM 게이트 (상품별 개별 실행)
--    현재 3상품 전부 공식 바인딩 0건 = 견적 0원의 직접 원인.
--    search-before-mint: 전부 기존 공식 재사용(신규 mint 없음).
--    공통(용지+인쇄)은 모든 후보 공식에 포함 → -b-prices 단가행이 그대로 먹힘.
--
--    [030 지그재그엽서] 완제품 600x150(펼침)=지그재그 접지 → 접지형.
--      권고: PRF_DGP_C (용지+인쇄+COMP_FOLD_CARD_2H+오시). fold_card_2H는 min_qty만으로
--            키잉(판형독립)이라 이미 단가행 존재 → 즉시 접지비 합산.
--      대안: 완칼(모양엽서형)로 CONFIRM되면 PRF_DGP_F(용지+인쇄+완칼) — 이 경우 -b의 완칼 carry 활성.
--      ★CONFIRM: 지그재그 접지가 (a)단순 2단fold인지 (b)아코디언 다단인지 — (b)면 PRF_DGP_E 검토.
--
--    [049 와이드 접지리플렛] 접지리플렛(3단 등) → 리플렛 접지형.
--      권고: PRF_DGP_E (용지+인쇄+FOLD_LEAF_3FOLD/4ACC/HALF/4GATE+오시+코팅+가변).
--            예시상품 027/028/029 접지카드가 사용. FOLD_LEAF_*는 판형독립(이미 단가행 존재).
--      ★CONFIRM: PRF_DGP_E는 4개 접지 컴포넌트가 formula_components에 공존 →
--                실 접지타입 택1을 엔진이 어떻게 선택하는지(opt_cd/CPQ) §18 확인 필요.
--                미확인 시 잠정 PRF_DGP_C(단일 fold)로 안전 대체 가능(접지비 과소↑ 대신 과청구 회피).
--
--    [112 와이드벽걸이캘린더] 용지+인쇄 base만 확실.
--      권고: PRF_DGP_INNER (용지+인쇄만) → 기본 견적 즉시 산출(과청구 0).
--      ★타공(펀칭)·링: 국4절 벽걸이캘린더(PRD_000111)가 가격공식 자체가 없음 →
--         복사할 타공 단가 컴포넌트 템플릿 부재. 권위 엑셀 '커팅타공' 시트에 벽걸이캘린더 타공표는
--         있으나 대응 t_prc 컴포넌트가 미배선 → §18 컴포넌트 설계 필요(본 트랙에서 스킵·defer).
--         링블랙=하드웨어 addon → 별도 addon 트랙. 112는 base 견적만 우선 산출.
-- ---------------------------------------------------------------------
BEGIN;
-- 030 — 권고 PRF_DGP_C (CONFIRM 후 실행)
INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note,reg_dt)
SELECT 'PRD_000030','PRF_DGP_C','2026-06-01','3절 지그재그엽서=접지형 260701',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000030');
--   [대안·완칼 CONFIRM 시] frm_cd='PRF_DGP_F'

-- 049 — 권고 PRF_DGP_E (CONFIRM 후 실행; 접지선택 semantics 확인 전 잠정 PRF_DGP_C 대체 가능)
INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note,reg_dt)
SELECT 'PRD_000049','PRF_DGP_E','2026-06-01','3절 와이드 접지리플렛=리플렛접지 260701',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000049');

-- 112 — PRF_DGP_INNER base (타공/링 defer)
INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note,reg_dt)
SELECT 'PRD_000112','PRF_DGP_INNER','2026-06-01','3절 와이드벽걸이캘린더 base(용지+인쇄)·타공/링 §18 defer 260701',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000112');

-- 검증: SELECT prd_cd,frm_cd FROM t_prd_product_price_formulas
--        WHERE prd_cd IN ('PRD_000030','PRD_000049','PRD_000112');
ROLLBACK;
-- COMMIT;
