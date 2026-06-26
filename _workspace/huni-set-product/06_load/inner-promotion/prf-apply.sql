-- ============================================================================
-- 072 하드커버책자 PRF 트랙 — 멱등 적재본 (제안·NOT 실행)
-- 생성: hsp-set-designer 2026-06-26 · DB 미적재 · 실 COMMIT은 게이트 GO + 인간 승인 후 load-executor
-- BEGIN/COMMIT 미내장(load-executor가 단일 트랜잭션 래핑). 전 INSERT = NOT EXISTS 멱등 가드.
-- 전제: vessel apply.sql(PRD_000284 내지 + dims + sets) 선행 COMMIT 완료.
-- 멱등 가드: ON CONFLICT 미사용(NULLS DISTINCT 함정 회피) → NOT EXISTS 명시 가드.
-- ★바인딩(§D)은 DBLPANSU 코드 교정(§6) + 표지 펼침 siz 신설 후에만 해제(현 주석 처리).
-- ============================================================================

-- ===== §A. S2 부활 (양면 내지 단가 복원·verbatim 불변·참조 활성공식 0 확증) =====
UPDATE t_prc_price_components SET del_yn='N', upd_dt=now()
 WHERE comp_cd='COMP_PRINT_DIGITAL_S2' AND del_yn='Y';
-- 멱등: del_yn='Y' 조건부 → 2회 실행해도 1회만. component_prices 212행 불변.

-- ===== §B. 3 PRF 헤더 (t_prc_price_formulas · del_yn 컬럼 없음·use_yn='Y') =====
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT 'PRF_HC_INNER', '하드커버책자 내지(인쇄+용지)',
       '내지 반제품 자기 공식. 내지인쇄(단면 S1/양면 S2)+내지용지. 호출자(뷰)가 미환산 페이지장수(copies*pages) 전달, plate_qty가 판수 환산 1회.', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_HC_INNER');

INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT 'PRF_HC_COVER', '하드커버책자 표지(인쇄+코팅+용지)',
       '표지 구성원 자기 공식. 표지인쇄 S1+무광코팅 단면+표지용지(아트150). 표지 펼침 siz로 pansu=1(1-up·출력매수=copies).', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_HC_COVER');

INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT 'PRF_HC_BODY', '하드커버책자 본체(제본)',
       '셋트 본체 자기 공식=제본만(하드커버무선 PROC_000023). 내지/표지 comp 미배선(이중평가 가드). qty=부수.', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_HC_BODY');

-- ===== §C. formula_components 배선 (7행 · PK=(frm_cd,comp_cd) · 전 comp 재사용) =====
-- PRF_HC_INNER (내지인쇄 S1·S2 + 내지용지)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_HC_INNER','COMP_PRINT_DIGITAL_S1',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_HC_INNER' AND comp_cd='COMP_PRINT_DIGITAL_S1');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_HC_INNER','COMP_PRINT_DIGITAL_S2',2,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_HC_INNER' AND comp_cd='COMP_PRINT_DIGITAL_S2');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_HC_INNER','COMP_PAPER',3,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_HC_INNER' AND comp_cd='COMP_PAPER');

-- PRF_HC_COVER (표지인쇄 S1 + 무광코팅 + 표지용지)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_HC_COVER','COMP_PRINT_DIGITAL_S1',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_HC_COVER' AND comp_cd='COMP_PRINT_DIGITAL_S1');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_HC_COVER','COMP_COAT_MATTE',2,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_HC_COVER' AND comp_cd='COMP_COAT_MATTE');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_HC_COVER','COMP_PAPER',3,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_HC_COVER' AND comp_cd='COMP_PAPER');

-- PRF_HC_BODY (제본만)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_HC_BODY','COMP_BIND_SSABARI',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_HC_BODY' AND comp_cd='COMP_BIND_SSABARI');

-- ===== §D. 바인딩 (t_prd_product_price_formulas · PK=(prd_cd,frm_cd,apply_bgn_ymd)) =====
-- ★★ 주석 처리 — DBLPANSU 코드 교정(§6) + 표지 펼침 siz 신설(CFM-COVER-SPREAD-SIZ) 완료 후에만 해제.
-- 미완 시 내지 ~0.4배·표지 ~0.26배 과소청구(돈 크리티컬). 게이트 GO + 인간 승인 필수.
-- apply_bgn_ymd = 적재일(예 '2026-06-26' — load-executor 실행일로 치환).
/*
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000284','PRF_HC_INNER','2026-06-26','내지 반제품 가격공식(DBLPANSU 코드교정 후)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000284' AND frm_cd='PRF_HC_INNER');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000073','PRF_HC_COVER','2026-06-26','표지 구성원 가격공식(표지펼침 siz 신설 후)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000073' AND frm_cd='PRF_HC_COVER');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000072','PRF_HC_BODY','2026-06-26','셋트 본체 제본 공식'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000072' AND frm_cd='PRF_HC_BODY');
*/
-- END (제안·미실행)
