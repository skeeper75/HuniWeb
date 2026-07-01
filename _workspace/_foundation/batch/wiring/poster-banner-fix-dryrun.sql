-- ============================================================================
-- poster-banner-fix-dryrun.sql  (§27 배선 서브트랙 — 포스터/사인/배너 6상품)
-- 2026-07-02 · BEGIN…ROLLBACK 전용 · 실 COMMIT 절대 금지
-- ----------------------------------------------------------------------------
-- 실무진이 2026-07-01 신규 추가한 자재/공정 옵션이 참조하는 mat_cd/proc_cd 에
-- 단가행이 없어 ① 폼보드·무광시트커팅 파손(0원) ② PET거치대 미과금 상태.
-- 이 스크립트는 6상품을 권위(상품마스터260610 실사시트·인쇄상품가격표260527 verbatim)대로
-- 배선한다. comp_price_id 는 IDENTITY(BY DEFAULT) → 생략(자동채번). 전 INSERT 멱등(NOT EXISTS).
--
--  [파손·돈크리티컬 2건 — 근본원인 동일: §17 dedup 사이즈코드 재매핑]
--   · PRD_000129 폼보드     : base=COMP_POSTER_FOAMBOARD_WHITE 키 174/197/293(구코드)
--                             상품 사이즈는 315/198(신코드) → 전 사이즈 NO_MATCH=0원(실측 확인)
--   · PRD_000140 무광시트커팅: base=COMP_POSTER_SHEETCUT_MATTE 키 172/174/197(구코드)
--                             상품 사이즈 258/315/198(신코드) → 전 사이즈 NO_MATCH=0원(실측 확인)
--  [미과금 1건]
--   · PRD_000136 PET배너 거치대 : 거치대 옵션(실내 MAT_409/실외 MAT_410)에 mat_cd 판별 컴포넌트 부재
--  [무변경·확인 3건]
--   · PRD_000124 린넨 : 마감=COMP_POSTEROPT_LINEN_FINISH(opt_cd 키) 이미 완전 배선(실측 +2000 확인) → NO-OP
--   · PRD_000118 아트프린트 : 코팅 priceV=0(무료·권위)·소재 단일(인화지)=base 포함 → 표시(sel_typ)만
--   · PRD_000143 미러아크릴 : 칼라(골드/실버) 동일가(권위 "미러(골드/실버)" 색상=외형) → 표시(sel_typ)만
-- ============================================================================

BEGIN;

-- ════════════════════════════════════════════════════════════════════════════
-- [1] PRD_000129 폼보드 — 옵션모델(a) 완성 (사용자 승인 방향)
--     보드칼라(화이트/블랙)를 mat_cd 판별로, 사이즈를 siz_cd 로 가격결정.
--     신규 컴포넌트 COMP_POSTER_FOAMBOARD_BOARD use_dims=[mat_cd,siz_cd] (신 키형상).
--     기존 WHITE(seq1)는 no-match(0)로 무해 → 삭제 않고 BOARD(seq2) 가산(순수 additive·안전 undo).
-- ════════════════════════════════════════════════════════════════════════════

-- 1-1) 신규 컴포넌트
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn, reg_dt)
SELECT 'COMP_POSTER_FOAMBOARD_BOARD','폼보드(보드칼라×사이즈) 완제품가','PRC_COMPONENT_TYPE.01','PRICE_TYPE.01','["mat_cd", "siz_cd"]','Y','N',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_FOAMBOARD_BOARD');

-- 1-2) 단가행 4건 (권위 260527 verbatim · 화이트 A3=6000 불변)
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, siz_cd, unit_price, note, reg_dt)
SELECT v.comp_cd, DATE '2026-06-01', v.mat_cd, v.siz_cd, v.unit_price, v.note, now()
FROM (VALUES
  ('COMP_POSTER_FOAMBOARD_BOARD','MAT_000398','SIZ_000315', 6000.00, '폼보드/화이트보드(5mm)/A3 완제품가[출력+코팅+가공 포함] 260527 verbatim'),
  ('COMP_POSTER_FOAMBOARD_BOARD','MAT_000398','SIZ_000198',12000.00, '폼보드/화이트보드(5mm)/A2 완제품가 260527 verbatim'),
  ('COMP_POSTER_FOAMBOARD_BOARD','MAT_000399','SIZ_000315', 8500.00, '폼보드/블랙보드(5mm)/A3 완제품가 260527 verbatim'),
  ('COMP_POSTER_FOAMBOARD_BOARD','MAT_000399','SIZ_000198',14000.00, '폼보드/블랙보드(5mm)/A2 완제품가 260527 verbatim')
) v(comp_cd,mat_cd,siz_cd,unit_price,note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices cp
                  WHERE cp.comp_cd=v.comp_cd AND cp.mat_cd=v.mat_cd AND cp.siz_cd=v.siz_cd);

-- 1-3) 공식 배선 (BOARD 가산 · WHITE 는 유지=no-match 0)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_POSTER_FOAMBOARD','COMP_POSTER_FOAMBOARD_BOARD',2,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
                  WHERE frm_cd='PRF_POSTER_FOAMBOARD' AND comp_cd='COMP_POSTER_FOAMBOARD_BOARD');

-- 1-4) 옵션 노출/필수화 — 보드칼라 필수(택1)+화이트 기본(→화이트 6000 불변 보장), 코팅 표시(무료·포함가)
UPDATE t_prd_product_option_groups
   SET sel_typ_cd='SEL_TYPE.01', mand_yn='Y', min_sel_cnt=1, max_sel_cnt=1, upd_dt=now()
 WHERE prd_cd='PRD_000129' AND opt_grp_cd='OPT-000045';
UPDATE t_prd_product_options SET dflt_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000129' AND opt_cd='OPV-000092';   -- 화이트보드 기본선택
UPDATE t_prd_product_option_groups SET sel_typ_cd='SEL_TYPE.01', upd_dt=now()
 WHERE prd_cd='PRD_000129' AND opt_grp_cd='OPT-000044';   -- 코팅(무료·완제품가 포함) 표시만

-- ════════════════════════════════════════════════════════════════════════════
-- [2] PRD_000140 무광시트커팅 — base 사이즈 재키잉 (dedup 신 사이즈코드로 이관)
--     구 172(A4)/174(A3)/197(A2) → 신 258(A4)/315(A3)/198(A2). 값 verbatim(6000/11000/32000).
--     구 행은 상품이 더 이상 제공 안 함 → 무해(삭제 안 함·순수 additive). 색상=외형(무료·컴포넌트 불요).
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, unit_price, note, reg_dt)
SELECT v.comp_cd, DATE '2026-06-01', v.siz_cd, v.unit_price, v.note, now()
FROM (VALUES
  ('COMP_POSTER_SHEETCUT_MATTE','SIZ_000258', 6000.00, '무광시트커팅/A4 완제품가[시트커팅] dedup rekey→258 (260527 verbatim)'),
  ('COMP_POSTER_SHEETCUT_MATTE','SIZ_000315',11000.00, '무광시트커팅/A3 완제품가[시트커팅] dedup rekey→315 (260527 verbatim)'),
  ('COMP_POSTER_SHEETCUT_MATTE','SIZ_000198',32000.00, '무광시트커팅/A2 완제품가[시트커팅] dedup rekey→198 (260527 verbatim)')
) v(comp_cd,siz_cd,unit_price,note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices cp
                  WHERE cp.comp_cd=v.comp_cd AND cp.siz_cd=v.siz_cd);

-- ════════════════════════════════════════════════════════════════════════════
-- [3] PRD_000136 PET배너 — 거치대 add-on 배선 (실내 MAT_409 / 실외 MAT_410)
--     신규 mat_cd 판별 컴포넌트(기존 orphan STAND_IN/OUT 은 use_dims=[]=상시매칭이라 선택구분 불가→재사용 불가).
--     ★값 CONFIRM: 실내 상품마스터260610=10000 vs live orphan STAND_IN=7000 (불일치) — 260610 채택.
--       실외 260610=23000 = live STAND_OUT_S1=23000 (일치·확정). 코팅/4구타공=완제품가 포함(무료).
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn, reg_dt)
SELECT 'COMP_POSTEROPT_PET_BANNER_STAND_SEL','PET배너 거치대(실내/실외) 선택 추가가격','PRC_COMPONENT_TYPE.01','PRICE_TYPE.01','["mat_cd"]','Y','N',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTEROPT_PET_BANNER_STAND_SEL');

INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, unit_price, note, reg_dt)
SELECT v.comp_cd, DATE '2026-06-01', v.mat_cd, v.unit_price, v.note, now()
FROM (VALUES
  ('COMP_POSTEROPT_PET_BANNER_STAND_SEL','MAT_000409',10000.00, 'PET배너 실내용거치대 추가가 [상품마스터260610=10000 · ★live orphan STAND_IN=7000 불일치 CONFIRM]'),
  ('COMP_POSTEROPT_PET_BANNER_STAND_SEL','MAT_000410',23000.00, 'PET배너 실외용거치대 추가가 [260610=23000 = live STAND_OUT_S1=23000 일치·확정]')
) v(comp_cd,mat_cd,unit_price,note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices cp
                  WHERE cp.comp_cd=v.comp_cd AND cp.mat_cd=v.mat_cd);

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_POSTER_PET_BANNER','COMP_POSTEROPT_PET_BANNER_STAND_SEL',2,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
                  WHERE frm_cd='PRF_POSTER_PET_BANNER' AND comp_cd='COMP_POSTEROPT_PET_BANNER_STAND_SEL');

-- ════════════════════════════════════════════════════════════════════════════
-- [4] PRD_000118 아트프린트 · [5] PRD_000143 미러아크릴 — 표시(sel_typ)만 (가격영향 0)
--     118 소재(인화지 단일·base 포함)+인화지 기본선택 / 코팅은 이미 sel_typ 有(무료).
--     143 칼라(골드/실버 동일가·외형) 노출.
-- ════════════════════════════════════════════════════════════════════════════
UPDATE t_prd_product_option_groups SET sel_typ_cd='SEL_TYPE.01', min_sel_cnt=1, max_sel_cnt=1, upd_dt=now()
 WHERE prd_cd='PRD_000118' AND opt_grp_cd='OPT-000043';   -- 소재(필수)
UPDATE t_prd_product_options SET dflt_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000118' AND opt_cd='OPV-000089';       -- 인화지 기본
UPDATE t_prd_product_option_groups SET sel_typ_cd='SEL_TYPE.01', upd_dt=now()
 WHERE prd_cd='PRD_000143' AND opt_grp_cd='OPT-000046';   -- 칼라(외형)

-- ════════════════════════════════════════════════════════════════════════════
-- 검증 SELECT (트랜잭션 내 매칭 증명 — ROLLBACK 前)
-- ════════════════════════════════════════════════════════════════════════════
\echo '=== [1] 폼보드 골든: (mat,siz)→단가 (화이트A3=6000/A2=12000·블랙A3=8500/A2=14000) ==='
SELECT mat_cd, siz_cd, unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_POSTER_FOAMBOARD_BOARD' ORDER BY mat_cd, siz_cd;
\echo '--- 폼보드 공식 배선 (WHITE seq1=no-match0 + BOARD seq2) ---'
SELECT frm_cd, comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components
 WHERE frm_cd='PRF_POSTER_FOAMBOARD' ORDER BY disp_seq;
\echo '--- 폼보드 보드칼라 옵션 필수화+화이트기본 확인 ---'
SELECT g.opt_grp_cd, g.mand_yn, g.sel_typ_cd, o.opt_cd, o.opt_nm, o.dflt_yn
  FROM t_prd_product_option_groups g JOIN t_prd_product_options o
    ON o.prd_cd=g.prd_cd AND o.opt_grp_cd=g.opt_grp_cd
 WHERE g.prd_cd='PRD_000129' AND g.opt_grp_cd='OPT-000045' ORDER BY o.disp_seq;

\echo '=== [2] 시트커팅 골든: siz→단가 (A4/258=6000·A3/315=11000·A2/198=32000) ==='
SELECT siz_cd, unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_POSTER_SHEETCUT_MATTE' AND siz_cd IN ('SIZ_000258','SIZ_000315','SIZ_000198')
 ORDER BY siz_cd;

\echo '=== [3] PET거치대 골든: mat→추가가 (실내409=10000·실외410=23000) + 공식 배선 ==='
SELECT mat_cd, unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_POSTEROPT_PET_BANNER_STAND_SEL' ORDER BY mat_cd;
SELECT frm_cd, comp_cd, disp_seq FROM t_prc_formula_components
 WHERE frm_cd='PRF_POSTER_PET_BANNER' ORDER BY disp_seq;

\echo '=== [4/5] 표시 sel_typ 반영 확인 (118 소재·143 칼라) ==='
SELECT prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, mand_yn FROM t_prd_product_option_groups
 WHERE (prd_cd='PRD_000118' AND opt_grp_cd='OPT-000043') OR (prd_cd='PRD_000143' AND opt_grp_cd='OPT-000046')
 ORDER BY prd_cd;

ROLLBACK;
-- ============================================================================
-- 실행: psql "$RAILWAY..." -f poster-banner-fix-dryrun.sql   (ROLLBACK=무커밋)
-- 실 COMMIT 은 인간 승인 + webadmin 가격시뮬레이터 실화면(제외0·PRICE≠0) 확인 후.
-- COMMIT 판: BEGIN 유지 + 끝 ROLLBACK→COMMIT (또는 poster-banner-fix.sql 파생).
-- ============================================================================
