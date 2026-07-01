-- =====================================================================
-- design-corotto-jibbitz-260701-dryrun.sql
-- 코롯토·지비츠 아크릴 굿즈 고아 구성요소 배선 설계 (DRYRUN·ROLLBACK)
-- 권위: 인쇄상품 가격표 260527 아크릴 B04(지비츠 투명200/스핀600)·B05(코롯토 면적)
-- 안전: BEGIN…ROLLBACK·멱등 NOT EXISTS 가드·실 COMMIT 아님(인간 승인 후 §7 위임)
-- 코롯토(PRD_000164)=이미 배선완료 → 변경 없음(검증 SELECT만). 지비츠(PRD_000156)만 설계.
-- =====================================================================
BEGIN;

-- ---------------------------------------------------------------------
-- [A] 코롯토 PRD_000164 — 검증 전용(변경 0·search-before-mint HIT)
-- ---------------------------------------------------------------------
\echo '=== [A] 코롯토 기배선 검증 (변경 없음) ==='
SELECT 'binding'  AS chk, prd_cd, frm_cd            FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000164';
SELECT 'wire'     AS chk, frm_cd, comp_cd, disp_seq FROM t_prc_formula_components     WHERE frm_cd='PRF_COROTTO_ACRYL';
SELECT 'grid'     AS chk, count(*) AS rows, count(DISTINCT (siz_width||'x'||siz_height)) AS distinct_wh,
                          min(unit_price) AS lo, max(unit_price) AS hi
       FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_COROTTO';
-- 기대: 바인딩 1·wire 1(COMP_ACRYL_COROTTO)·grid rows=36 distinct=36 lo=3600 hi=8400. 재-mint 불요.

-- ---------------------------------------------------------------------
-- [B] 지비츠 PRD_000156 — Path 1 (권장·투명 200 고정가·mint 최소·즉시 PRICE≠0)
-- ---------------------------------------------------------------------
\echo '=== [B] 지비츠 Path1 설계 배선 ==='

-- B1. 구성요소 신설 COMP_ACRYL_ZIBITZ (단가형·min_qty tier)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn, prc_typ_cd, use_dims, del_yn, reg_dt)
SELECT 'COMP_ACRYL_ZIBITZ', '아크릴지비츠 인쇄가공비',
       'PRC_COMPONENT_TYPE.01', '아크릴지비츠 인쇄·가공 포함 고정단가(투명 기본). 사이즈 무관 개당 단가.',
       'Y', 'PRICE_TYPE.01', '["min_qty"]', 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_ZIBITZ');

-- B2. 단가행 (투명 200·verbatim·siz/opt/proc NULL·min_qty=1)
--     comp_price_id 79166 = MAX(79165)+1. 실 COMMIT 시 IDENTITY면 DEFAULT/nextval 사용 + setval 조정([[dbmap-digitalprint-atomic-formula-unbuilt]] setval 함정).
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, min_qty, unit_price, note, reg_dt)
SELECT 79166, 'COMP_ACRYL_ZIBITZ', DATE '2026-06-01', 1, 200.00,
       '아크릴지비츠 투명 기본단가 [260527 아크릴 B04 verbatim]', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_ZIBITZ' AND min_qty=1);

-- B3. 공식 신설 PRF_ZIBITZ_ACRYL
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_ZIBITZ_ACRYL', '아크릴지비츠 공식', '고아 placeholder(PRF_ACRYL_ZIBITZ_TBD) 해소·투명 고정단가', 'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_ZIBITZ_ACRYL');

-- B4. 배선 formula_components
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_ZIBITZ_ACRYL', 'COMP_ACRYL_ZIBITZ', 1, 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_ZIBITZ_ACRYL' AND comp_cd='COMP_ACRYL_ZIBITZ');

-- B5. 바인딩 교체: PRD_000156 → PRF_ZIBITZ_ACRYL (기존 _TBD 삭제)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000156' AND frm_cd='PRF_ACRYL_ZIBITZ_TBD';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000156', 'PRF_ZIBITZ_ACRYL', DATE '2026-06-28', '아크릴지비츠 — 지비츠공식(dead placeholder 해소)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000156' AND frm_cd='PRF_ZIBITZ_ACRYL');

-- B6. 폐기된 placeholder 공식 use_yn=N (삭제금지·COMP_ACRYL_PENDING_TBD 는 타 상품 공유→보존)
UPDATE t_prc_price_formulas SET use_yn='N', upd_dt=now()
WHERE frm_cd='PRF_ACRYL_ZIBITZ_TBD' AND use_yn<>'N';

\echo '=== [B] Path1 배선 후 확인 ==='
SELECT 'z_comp' AS chk, comp_cd, prc_typ_cd, use_dims FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_ZIBITZ';
SELECT 'z_price' AS chk, comp_price_id, min_qty, unit_price, note FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_ZIBITZ';
SELECT 'z_wire' AS chk, frm_cd, comp_cd, disp_seq FROM t_prc_formula_components WHERE frm_cd='PRF_ZIBITZ_ACRYL';
SELECT 'z_bind' AS chk, prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000156';
-- 기대: 지비츠 투명 수량1=200·수량100=20,000 (validator simulate 재현)

-- ---------------------------------------------------------------------
-- [C] 지비츠 Path 2 (스핀 600 포함·완전 충실·§7 공정 mint 선행 → BLOCKED)
--     아래는 설계 참조(주석)·공정코드 부재로 미실행. 실행 전 CONFIRM/§7 필요.
-- ---------------------------------------------------------------------
-- -- C1. 구성요소 use_dims 를 opt_cd 포함으로 (린넨 COMP_POSTEROPT_LINEN_FINISH 동형)
-- UPDATE t_prc_price_components SET use_dims='["opt_cd","min_qty"]' WHERE comp_cd='COMP_ACRYL_ZIBITZ';
-- -- C2. 투명 단가행에 opt_cd=OPV_000491(투명) 부여 + 스핀 단가행 신설
-- UPDATE t_prc_component_prices SET opt_cd='OPV_000491' WHERE comp_price_id=79166;
-- INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, min_qty, unit_price, opt_cd, note, reg_dt)
-- VALUES (79167,'COMP_ACRYL_ZIBITZ',DATE '2026-06-01',1,600.00,'OPV_000492','아크릴지비츠 스핀단가 [260527 B04 verbatim]',now());
-- -- C3. 선택수단 옵션그룹 가공(택1 mand) + 옵션 투명(dflt)/스핀
-- INSERT INTO t_prd_product_option_groups (prd_cd,opt_grp_cd,opt_grp_nm,sel_typ_cd,min_sel_cnt,max_sel_cnt,mand_yn,disp_seq,use_yn,del_yn,reg_dt)
-- VALUES ('PRD_000156','OPT_000082','가공','SEL_TYPE.01',1,1,'Y',1,'Y','N',now());
-- INSERT INTO t_prd_product_options (prd_cd,opt_cd,opt_grp_cd,opt_nm,dflt_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES
--   ('PRD_000156','OPV_000491','OPT_000082','투명','Y',1,'Y','N',now()),
--   ('PRD_000156','OPV_000492','OPT_000082','스핀','N',2,'Y','N',now());
-- -- C4. option_items ref: OPT_REF_DIM.04(공정) ref_key1=<투명/스핀 공정코드>
-- --     ★BLOCKED: t_proc_processes 에 투명/스핀 공정 부재(search-before-mint 결과).
-- --     → 기초마스터 공정 2 mint(§12/§7 dbmap) 또는 순수 addon 템플릿(§7 CPQ)로 대체 후 실행.

ROLLBACK;
-- =====================================================================
-- DRYRUN 종료. 실 적용은 인간 승인 후 §7(dbm-load-execution): [A]변경0·[B]Path1 실행·[C]Path2 CONFIRM 후.
-- =====================================================================
