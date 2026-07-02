-- 088 레더 링바인더 재설계 — 롤백전용 DRY-RUN (BEGIN…ROLLBACK)
-- 생성 2026-07-02 · hsp-set-design · 적재 가능성·멱등성 실증용 (실 COMMIT 아님)
-- 실행: psql -f apply-dryrun.sql  → 모든 변경 후 ROLLBACK (DB 무변경)
-- apply.sql 본문을 트랜잭션으로 감싸고, 사전/사후 검증 SELECT를 끼워 골든 재계산 근거를 남긴다.

BEGIN;

-- ===== 사전 상태 스냅샷 =====
\echo '--- BEFORE: 부모공식 배선 ---'
SELECT frm_cd, comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components
WHERE frm_cd IN ('PRF_LEATHER_RINGBINDER_SET','PRF_LEATHER_RINGBINDER_COVER') ORDER BY frm_cd, comp_cd;
\echo '--- BEFORE: 089 공식 바인딩 / 088 proc ---'
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000088','PRD_000089') ORDER BY prd_cd;
SELECT prd_cd, proc_cd, mand_proc_yn FROM t_prd_product_processes WHERE prd_cd='PRD_000088';

-- ===== (1) mint 표지 component =====
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, note, use_yn, del_yn)
VALUES ('COMP_LEATHER_RINGBINDER_COVER', '레더 링바인더 표지 소재+인쇄비',
        'PRC_COMPONENT_TYPE.06', 'PRICE_TYPE.01', '["min_qty"]'::jsonb,
        '레더 링바인더 A4 표지 소재+인쇄비 통합(636x374 기준·출력소재관리 0702·flat 9000/부)', 'Y', 'N')
ON CONFLICT (comp_cd) DO UPDATE SET
    comp_nm=EXCLUDED.comp_nm, comp_typ_cd=EXCLUDED.comp_typ_cd, prc_typ_cd=EXCLUDED.prc_typ_cd,
    use_dims=EXCLUDED.use_dims, note=EXCLUDED.note, use_yn='Y', del_yn='N', upd_dt=now();

-- ===== (2) mint 표지 단가행 =====
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, min_qty, unit_price, note)
SELECT COALESCE((SELECT MAX(comp_price_id) FROM t_prc_component_prices),0)+1,
       'COMP_LEATHER_RINGBINDER_COVER','2026-06-01',1,9000,
       '레더 링바인더 A4 소재+인쇄비 636x374 기준 (출력소재관리 0702·verbatim)'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices
    WHERE comp_cd='COMP_LEATHER_RINGBINDER_COVER' AND apply_ymd='2026-06-01' AND min_qty=1);

-- ===== (3) mint 표지 공식 =====
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES ('PRF_LEATHER_RINGBINDER_COVER','레더 링바인더 표지 소재+인쇄비',
        'member PRD_000089 표지 소재+인쇄비(Home-M)·088 재설계 260702','Y')
ON CONFLICT (frm_cd) DO UPDATE SET frm_nm=EXCLUDED.frm_nm, note=EXCLUDED.note, use_yn='Y', upd_dt=now();

-- ===== (4) mint 표지 공식 배선 =====
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_LEATHER_RINGBINDER_COVER','COMP_LEATHER_RINGBINDER_COVER',1,'Y')
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now();

-- ===== (5) member 089 ← 표지 공식 =====
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000089','PRF_LEATHER_RINGBINDER_COVER','2026-01-01',
        '레더 링바인더 표지 소재+인쇄비(Home-M)·088 재설계 260702')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now();

-- ===== (6) 부모공식 COVERBIND 배선 제거 =====
DELETE FROM t_prc_formula_components
WHERE frm_cd='PRF_LEATHER_RINGBINDER_SET' AND comp_cd='COMP_HC_MUSEON_COVERBIND';

-- ===== (7) 부모공식 싸바리 배선 추가 =====
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_LEATHER_RINGBINDER_SET','COMP_BIND_SSABARI',1,'Y')
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now();

-- ===== (8) 088 proc 격리 PROC_000098 =====
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, del_yn)
VALUES ('PRD_000088','PROC_000098','Y',1,'N')
ON CONFLICT (prd_cd, proc_cd) DO UPDATE SET mand_proc_yn='Y', disp_seq=EXCLUDED.disp_seq, del_yn='N', del_dt=NULL, upd_dt=now();

-- ===== 사후 상태 검증 =====
\echo '--- AFTER: 부모공식 배선 (기대: SET→SSABARI, COVERBIND 없음) ---'
SELECT frm_cd, comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components
WHERE frm_cd IN ('PRF_LEATHER_RINGBINDER_SET','PRF_LEATHER_RINGBINDER_COVER') ORDER BY frm_cd, comp_cd;
\echo '--- AFTER: 표지 단가행 (기대: 9000 @ min_qty=1) ---'
SELECT comp_cd, apply_ymd, min_qty, unit_price FROM t_prc_component_prices
WHERE comp_cd='COMP_LEATHER_RINGBINDER_COVER' ORDER BY min_qty;
\echo '--- AFTER: 089 공식 / 088 proc ---'
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000088','PRD_000089') ORDER BY prd_cd;
SELECT prd_cd, proc_cd, mand_proc_yn FROM t_prd_product_processes WHERE prd_cd='PRD_000088' AND del_yn='N';

ROLLBACK;
\echo '=== DRY-RUN 완료 · ROLLBACK 됨 (DB 무변경) ==='
