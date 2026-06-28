-- ============================================================================
-- 하드커버책자(PRD_000072) 세트 가격 종단 — DRY-RUN (BEGIN…ROLLBACK·안전)
-- 생성: hsp-set-designer 2026-06-29
-- 설계: hardcover072-price-design-260629.md
-- ★이 스크립트는 ROLLBACK으로 끝나 라이브를 변경하지 않는다. PK충돌0·행수정확·멱등을 실증한다.
-- 실행: psql -f hardcover072-price-260629-dryrun.sql (롤백이므로 안전)
-- 단가: 표지=라이브 역산 verbatim(hc072-cover-probe-260629.csv)·제본=DB 재사용. 날조 0.
-- ============================================================================
BEGIN;

\echo '=== [0] 사전 상태 (신규 대상 부재 확인) ==='
SELECT 'comp_before' AS chk, count(*) FROM t_prc_price_components WHERE comp_cd='COMP_COVER_HC_PAPER';
SELECT 'prices_before' AS chk, count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_COVER_HC_PAPER';
SELECT 'formula_before' AS chk, count(*) FROM t_prc_price_formulas WHERE frm_cd='PRF_BIND_HC_MUSEON';
SELECT 'fc_before' AS chk, count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_BIND_HC_MUSEON';
SELECT 'bind_before' AS chk, count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000072';
SELECT 'maxid_before' AS chk, max(comp_price_id) FROM t_prc_component_prices;

-- ----------------------------------------------------------------------------
-- [1] 표지 전용지 단가 구성요소 (신규 mint·항상매칭형)
-- ----------------------------------------------------------------------------
INSERT INTO t_prc_price_components
    (comp_cd, comp_nm, comp_typ_cd, note, use_yn, reg_dt, prc_typ_cd, use_dims, del_yn)
VALUES
    ('COMP_COVER_HC_PAPER',
     '표지비 하드커버 전용지(per-book·인쇄+용지+코팅 묶음)',
     NULL,
     '라이브 역산(p02 표지+제본 − 제본 DB)·사이즈독립 per-book 밴드룩업·전용지 1종',
     'Y', now(), 'PRICE_TYPE.01', '["min_qty"]'::jsonb, 'N')
ON CONFLICT (comp_cd) DO NOTHING;

-- ----------------------------------------------------------------------------
-- [2] 표지 단가행 6밴드 (comp_price_id 40333~40338·표지 역산 verbatim)
--     멱등 가드: 같은 (comp_cd, apply_ymd, min_qty) 조합이 이미 있으면 INSERT 생략.
--     comp_price_id 는 명시 채번(MAX=40332 → 40333~40338). 충돌 시 NOTHING.
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- [3] 세트 합산 공식 (신규 mint)
-- ----------------------------------------------------------------------------
INSERT INTO t_prc_price_formulas
    (frm_cd, frm_nm, note, use_yn, reg_dt)
VALUES
    ('PRF_BIND_HC_MUSEON',
     '하드커버무선 세트공식(제본+표지·per-book 밴드)',
     '세트공식: 제본비(COMP_BIND_HC_MUSEON)+표지(COMP_COVER_HC_PAPER)·copies 평가·이중합산0',
     'Y', now())
ON CONFLICT (frm_cd) DO NOTHING;

-- ----------------------------------------------------------------------------
-- [4] formula_components 배선 (제본 disp1 + 표지 disp2)
-- ----------------------------------------------------------------------------
INSERT INTO t_prc_formula_components
    (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES
    ('PRF_BIND_HC_MUSEON', 'COMP_BIND_HC_MUSEON', 1, 'Y', now()),
    ('PRF_BIND_HC_MUSEON', 'COMP_COVER_HC_PAPER', 2, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ----------------------------------------------------------------------------
-- [5] 부모 072 → 세트공식 바인딩 (신규 mint)
-- ----------------------------------------------------------------------------
INSERT INTO t_prd_product_price_formulas
    (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
VALUES
    ('PRD_000072', 'PRF_BIND_HC_MUSEON', '2026-06-01',
     '하드커버책자 세트공식(제본+표지)·set_procs=[{proc_cd:PROC_000023}]', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;  -- PK=(prd_cd, apply_bgn_ymd)·frm_cd 미포함

\echo '=== [6] 사후 행수 검증 (1차 INSERT) ==='
SELECT 'comp_after' AS chk, count(*) AS n, '기대 1' AS expect FROM t_prc_price_components WHERE comp_cd='COMP_COVER_HC_PAPER';
SELECT 'prices_after' AS chk, count(*) AS n, '기대 6' AS expect FROM t_prc_component_prices WHERE comp_cd='COMP_COVER_HC_PAPER';
SELECT 'formula_after' AS chk, count(*) AS n, '기대 1' AS expect FROM t_prc_price_formulas WHERE frm_cd='PRF_BIND_HC_MUSEON';
SELECT 'fc_after' AS chk, count(*) AS n, '기대 2' AS expect FROM t_prc_formula_components WHERE frm_cd='PRF_BIND_HC_MUSEON';
SELECT 'bind_after' AS chk, count(*) AS n, '기대 1' AS expect FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000072' AND frm_cd='PRF_BIND_HC_MUSEON';

\echo '=== [6b] 표지 단가행 내용 검증 (역산 verbatim 일치) ==='
SELECT comp_price_id, min_qty, unit_price FROM t_prc_component_prices
WHERE comp_cd='COMP_COVER_HC_PAPER' ORDER BY min_qty;

-- ----------------------------------------------------------------------------
-- [7] 멱등 재실행 (같은 INSERT 2회째 — 추가행 0·PK충돌0 실증)
-- ----------------------------------------------------------------------------
\echo '=== [7] 멱등 재실행 (2회째·추가행 0 기대) ==='
INSERT INTO t_prc_price_components
    (comp_cd, comp_nm, comp_typ_cd, note, use_yn, reg_dt, prc_typ_cd, use_dims, del_yn)
VALUES
    ('COMP_COVER_HC_PAPER', '표지비 하드커버 전용지(per-book·인쇄+용지+코팅 묶음)', NULL,
     '재실행 테스트', 'Y', now(), 'PRICE_TYPE.01', '["min_qty"]'::jsonb, 'N')
ON CONFLICT (comp_cd) DO NOTHING;

INSERT INTO t_prc_component_prices
    (comp_price_id, comp_cd, apply_ymd, min_qty, unit_price, note, reg_dt)
SELECT v.comp_price_id, v.comp_cd, v.apply_ymd, v.min_qty, v.unit_price, v.note, now()
FROM (VALUES
    (40333, 'COMP_COVER_HC_PAPER', '2026-06-01',    1, 4100.00, 'x'),
    (40338, 'COMP_COVER_HC_PAPER', '2026-06-01', 1000,  368.40, 'x')
) AS v(comp_price_id, comp_cd, apply_ymd, min_qty, unit_price, note)
WHERE NOT EXISTS (
    SELECT 1 FROM t_prc_component_prices p
    WHERE p.comp_cd = v.comp_cd AND p.apply_ymd = v.apply_ymd AND p.min_qty = v.min_qty
)
ON CONFLICT (comp_price_id) DO NOTHING;

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BIND_HC_MUSEON', 'COMP_BIND_HC_MUSEON', 1, 'Y', now()),
       ('PRF_BIND_HC_MUSEON', 'COMP_COVER_HC_PAPER', 2, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
VALUES ('PRD_000072', 'PRF_BIND_HC_MUSEON', '2026-06-01', 'x', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

\echo '=== [7b] 멱등 후 행수 (1차와 동일해야 — 추가행 0) ==='
SELECT 'prices_idem' AS chk, count(*) AS n, '기대 6(불변)' AS expect FROM t_prc_component_prices WHERE comp_cd='COMP_COVER_HC_PAPER';
SELECT 'fc_idem' AS chk, count(*) AS n, '기대 2(불변)' AS expect FROM t_prc_formula_components WHERE frm_cd='PRF_BIND_HC_MUSEON';
SELECT 'bind_idem' AS chk, count(*) AS n, '기대 1(불변)' AS expect FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000072' AND frm_cd='PRF_BIND_HC_MUSEON';

\echo '=== [8] ROLLBACK (라이브 무변경) ==='
ROLLBACK;

\echo '=== DRY-RUN 완료 — 라이브 변경 없음 ==='
