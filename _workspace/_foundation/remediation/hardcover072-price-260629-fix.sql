-- ============================================================================
-- 하드커버책자(PRD_000072) 세트 가격 종단 — FIX (COMMIT 버전)
-- ★★★ 실행 금지 — 인간 검토용. CONFIRM-COVER-PRICE(실무진 표지단가 확정) + 인간 승인 후에만 실행.
-- 생성: hsp-set-designer 2026-06-29 · 설계: hardcover072-price-design-260629.md
-- DRY-RUN 검증 완료: hardcover072-price-260629-dryrun.sql (PK충돌0·멱등·행수정확·ROLLBACK)
-- 단가: 표지=라이브 역산 verbatim(hc072-cover-probe-260629.csv)·제본=DB 재사용. 날조 0.
--
-- 적재 범위: ① COMP_COVER_HC_PAPER comp+단가행6  ② PRF_BIND_HC_MUSEON 공식+formula_components2
--            ③ PRD_000072 바인딩1.  (내지 가격=BLOCKED·별 트랙)
-- ============================================================================
BEGIN;

-- [1] 표지 전용지 단가 구성요소
INSERT INTO t_prc_price_components
    (comp_cd, comp_nm, comp_typ_cd, note, use_yn, reg_dt, prc_typ_cd, use_dims, del_yn)
VALUES
    ('COMP_COVER_HC_PAPER',
     '표지비 하드커버 전용지(per-book·인쇄+용지+코팅 묶음)',
     NULL,
     '라이브 역산(p02 표지+제본 − 제본 DB)·사이즈독립 per-book 밴드룩업·전용지 1종',
     'Y', now(), 'PRICE_TYPE.01', '["min_qty"]'::jsonb, 'N')
ON CONFLICT (comp_cd) DO NOTHING;

-- [2] 표지 단가행 6밴드 (comp_price_id 40333~40338·역산 verbatim)
INSERT INTO t_prc_component_prices
    (comp_price_id, comp_cd, apply_ymd, min_qty, unit_price, note, reg_dt)
SELECT v.comp_price_id, v.comp_cd, v.apply_ymd, v.min_qty, v.unit_price, v.note, now()
FROM (VALUES
    (40333, 'COMP_COVER_HC_PAPER', '2026-06-01',    1, 4100.00, '표지 전용지 per-book(역산 p02−제본)·수량 1 이상'),
    (40334, 'COMP_COVER_HC_PAPER', '2026-06-01',    4, 2425.00, '표지 전용지 per-book·수량 4 이상'),
    (40335, 'COMP_COVER_HC_PAPER', '2026-06-01',   10, 1910.00, '표지 전용지 per-book·수량 10 이상'),
    (40336, 'COMP_COVER_HC_PAPER', '2026-06-01',   50, 1170.00, '표지 전용지 per-book·수량 50 이상'),
    (40337, 'COMP_COVER_HC_PAPER', '2026-06-01',  100,  969.00, '표지 전용지 per-book·수량 100 이상'),
    (40338, 'COMP_COVER_HC_PAPER', '2026-06-01', 1000,  368.40, '표지 전용지 per-book·수량 1000 이상')
) AS v(comp_price_id, comp_cd, apply_ymd, min_qty, unit_price, note)
WHERE NOT EXISTS (
    SELECT 1 FROM t_prc_component_prices p
    WHERE p.comp_cd = v.comp_cd AND p.apply_ymd = v.apply_ymd AND p.min_qty = v.min_qty
)
ON CONFLICT (comp_price_id) DO NOTHING;

-- [3] 세트 합산 공식
INSERT INTO t_prc_price_formulas
    (frm_cd, frm_nm, note, use_yn, reg_dt)
VALUES
    ('PRF_BIND_HC_MUSEON',
     '하드커버무선 세트공식(제본+표지·per-book 밴드)',
     '세트공식: 제본비(COMP_BIND_HC_MUSEON)+표지(COMP_COVER_HC_PAPER)·copies 평가·이중합산0',
     'Y', now())
ON CONFLICT (frm_cd) DO NOTHING;

-- [4] formula_components 배선 (제본 disp1 + 표지 disp2)
INSERT INTO t_prc_formula_components
    (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES
    ('PRF_BIND_HC_MUSEON', 'COMP_BIND_HC_MUSEON', 1, 'Y', now()),
    ('PRF_BIND_HC_MUSEON', 'COMP_COVER_HC_PAPER', 2, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- [5] 부모 072 → 세트공식 바인딩  (PK=(prd_cd, apply_bgn_ymd))
INSERT INTO t_prd_product_price_formulas
    (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
VALUES
    ('PRD_000072', 'PRF_BIND_HC_MUSEON', '2026-06-01',
     '하드커버책자 세트공식(제본+표지)·set_procs=[{proc_cd:PROC_000023}]', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

-- 사후 검증 (COMMIT 전 눈으로 확인)
SELECT 'comp' chk, count(*) n FROM t_prc_price_components WHERE comp_cd='COMP_COVER_HC_PAPER'
UNION ALL SELECT 'prices', count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_COVER_HC_PAPER'
UNION ALL SELECT 'formula', count(*) FROM t_prc_price_formulas WHERE frm_cd='PRF_BIND_HC_MUSEON'
UNION ALL SELECT 'fc', count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_BIND_HC_MUSEON'
UNION ALL SELECT 'bind', count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000072' AND frm_cd='PRF_BIND_HC_MUSEON';
-- 기대: comp 1·prices 6·formula 1·fc 2·bind 1

COMMIT;

-- ============================================================================
-- UNDO (롤백용·문제 발생 시) — 위 COMMIT을 되돌린다. 신규분만 제거(공유 마스터 미터치).
-- ============================================================================
-- BEGIN;
-- DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000072' AND frm_cd='PRF_BIND_HC_MUSEON';
-- DELETE FROM t_prc_formula_components     WHERE frm_cd='PRF_BIND_HC_MUSEON';
-- DELETE FROM t_prc_price_formulas         WHERE frm_cd='PRF_BIND_HC_MUSEON';
-- DELETE FROM t_prc_component_prices       WHERE comp_cd='COMP_COVER_HC_PAPER';
-- DELETE FROM t_prc_price_components        WHERE comp_cd='COMP_COVER_HC_PAPER';
-- COMMIT;
-- ----------------------------------------------------------------------------
-- COMMIT 후 골든 검증(필수): simulate_set('PRD_000072', copies=50, members=[표지073,내지284,면지074],
--   set_procs=[{proc_cd:'PROC_000023'}]) → set_eval 기여 = (9000+1170)×50 = 508,500 확인.
--   제본 .01 ×copies 실제 곱셈·표지 항상매칭 동시 확인(C트랙 false-positive 가드).
-- ============================================================================
