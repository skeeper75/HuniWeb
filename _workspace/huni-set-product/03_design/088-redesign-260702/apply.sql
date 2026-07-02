-- 088 레더 링바인더 재설계 적재 (Q2 확정: 소재+인쇄비 9,000/부 · member 089 Home-M)
-- 생성 2026-07-02 · hsp-set-design · §23 088 단일 스코프
-- ★ 멱등. BEGIN/COMMIT 미내장 — load-executor가 트랜잭션 래핑(인간 승인 후). COMMIT 실행 금지.
-- 모델: 088 = [표지 소재+인쇄비 9,000/부 (member 089·mint)] + [싸바리 제본비 (부모공식·재사용)]
-- 변경 8행: mint(1~5) + 부모 재배선(6~7) + proc 격리(8)

-- ============================================================
-- (1) mint: 표지 소재+인쇄비 component
-- ============================================================
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, note, use_yn, del_yn)
VALUES ('COMP_LEATHER_RINGBINDER_COVER', '레더 링바인더 표지 소재+인쇄비',
        'PRC_COMPONENT_TYPE.06', 'PRICE_TYPE.01', '["min_qty"]'::jsonb,
        '레더 링바인더 A4 표지 소재+인쇄비 통합(636x374 기준·출력소재관리 0702·flat 9000/부)', 'Y', 'N')
ON CONFLICT (comp_cd) DO UPDATE SET
    comp_nm = EXCLUDED.comp_nm, comp_typ_cd = EXCLUDED.comp_typ_cd,
    prc_typ_cd = EXCLUDED.prc_typ_cd, use_dims = EXCLUDED.use_dims,
    note = EXCLUDED.note, use_yn = 'Y', del_yn = 'N', upd_dt = now();

-- ============================================================
-- (2) mint: 표지 소재+인쇄비 단가행 (flat 9000 @ min_qty=1)
--     comp_price_id = MAX+1 (IDENTITY 없음)·자연키(comp_cd,apply_ymd,min_qty) NOT EXISTS 가드로 멱등
-- ============================================================
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, min_qty, unit_price, note)
SELECT COALESCE((SELECT MAX(comp_price_id) FROM t_prc_component_prices), 0) + 1,
       'COMP_LEATHER_RINGBINDER_COVER', '2026-06-01', 1, 9000,
       '레더 링바인더 A4 소재+인쇄비 636x374 기준 (출력소재관리 0702·verbatim)'
WHERE NOT EXISTS (
    SELECT 1 FROM t_prc_component_prices
    WHERE comp_cd = 'COMP_LEATHER_RINGBINDER_COVER' AND apply_ymd = '2026-06-01' AND min_qty = 1);

-- ============================================================
-- (3) mint: 표지 공식 shell
-- ============================================================
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES ('PRF_LEATHER_RINGBINDER_COVER', '레더 링바인더 표지 소재+인쇄비',
        'member PRD_000089 표지 소재+인쇄비(Home-M)·088 재설계 260702', 'Y')
ON CONFLICT (frm_cd) DO UPDATE SET
    frm_nm = EXCLUDED.frm_nm, note = EXCLUDED.note, use_yn = 'Y', upd_dt = now();

-- ============================================================
-- (4) mint: 표지 공식 ← 표지 component 배선
-- ============================================================
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_LEATHER_RINGBINDER_COVER', 'COMP_LEATHER_RINGBINDER_COVER', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET
    disp_seq = EXCLUDED.disp_seq, addtn_yn = EXCLUDED.addtn_yn, upd_dt = now();

-- ============================================================
-- (5) member 089 표지 ← 표지 공식 바인딩 (현재 089 공식 0건)
-- ============================================================
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000089', 'PRF_LEATHER_RINGBINDER_COVER', '2026-01-01',
        '레더 링바인더 표지 소재+인쇄비(Home-M)·088 재설계 260702')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd = EXCLUDED.frm_cd, note = EXCLUDED.note, upd_dt = now();

-- ============================================================
-- (6) 부모공식 재배선: COVERBIND 배선 제거 (component 자체는 타상품용 보존)
-- ============================================================
DELETE FROM t_prc_formula_components
WHERE frm_cd = 'PRF_LEATHER_RINGBINDER_SET' AND comp_cd = 'COMP_HC_MUSEON_COVERBIND';

-- ============================================================
-- (7) 부모공식 재배선: 싸바리 제본비 배선 추가 (COMP_BIND_SSABARI@PROC_000098 재사용)
-- ============================================================
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_LEATHER_RINGBINDER_SET', 'COMP_BIND_SSABARI', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET
    disp_seq = EXCLUDED.disp_seq, addtn_yn = EXCLUDED.addtn_yn, upd_dt = now();

-- ============================================================
-- (8) 옵션 오염 가드: 088 product_processes = {PROC_000098} 단독 (mand)
--     싸바리 밴드로만 매칭되게 proc_cd 격리 (무선023/트윈링024 미포함)
-- ============================================================
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, del_yn)
VALUES ('PRD_000088', 'PROC_000098', 'Y', 1, 'N')
ON CONFLICT (prd_cd, proc_cd) DO UPDATE SET
    mand_proc_yn = 'Y', disp_seq = EXCLUDED.disp_seq, del_yn = 'N', del_dt = NULL, upd_dt = now();
