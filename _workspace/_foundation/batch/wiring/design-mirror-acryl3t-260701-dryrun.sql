-- ============================================================================
-- design-mirror-acryl3t-260701-dryrun.sql
-- 미러/거울류 견적0 해소(Part A: 186/187 굿즈 고정가) + COMP_ACRYL_MIRROR3T
-- 고아 처분(Part B: PRF_MIRROR_ACRYL 신설·배선 READY, 바인딩=CONFIRM)
--
-- ★ DRY-RUN 전용: BEGIN … ROLLBACK. 실 COMMIT 없음(인간 승인 후 §7 위임).
-- ★ 단가 = 상품마스터 "굿즈파우치(가격포함)" verbatim(날조 0).
-- ★ 멱등: NOT EXISTS 가드. comp_price_id = IDENTITY(명시 안 함).
-- 실행: psql "$RAILWAY_DB_*" -f 이 파일  (읽기전용 검증·롤백)
-- ============================================================================
BEGIN;

-- ─────────────────────────────────────────────────────────────────────────
-- PART A. 186/187 사각손거울 = 굿즈 고정가(READY)
-- ─────────────────────────────────────────────────────────────────────────

-- A1. price_formulas (동형: PRF_POSTER_ACRYLSTK_MIRROR)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT v.frm_cd, v.frm_nm, v.note, 'Y', now()
FROM (VALUES
  ('PRF_MIRROR_SQHAND',       '사각손거울 완제품가',     '사각손거울 사이즈별 고정가(가격포함 굿즈)'),
  ('PRF_MIRROR_SQHAND_BLACK', '블랙사각손거울 완제품가', '블랙사각손거울 사이즈별 고정가(가격포함 굿즈)')
) AS v(frm_cd, frm_nm, note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd=v.frm_cd);

-- A2. price_components (완제품비.06 · 단가형.01 · use_dims=["siz_cd"])
INSERT INTO t_prc_price_components
  (comp_cd, comp_nm, comp_typ_cd, note, use_yn, prc_typ_cd, use_dims, del_yn, reg_dt)
SELECT v.comp_cd, v.comp_nm, 'PRC_COMPONENT_TYPE.06', v.note, 'Y',
       'PRICE_TYPE.01', '["siz_cd"]', 'N', now()
FROM (VALUES
  ('COMP_MIRROR_GOODS_SQHAND',       '사각손거울 완제품가',     '사각손거울 완제품 통가격. 사이즈별 단가표.'),
  ('COMP_MIRROR_GOODS_SQHAND_BLACK', '블랙사각손거울 완제품가', '블랙사각손거울 완제품 통가격. 사이즈별 단가표.')
) AS v(comp_cd, comp_nm, note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components c WHERE c.comp_cd=v.comp_cd);

-- A3. formula_components (배선)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT v.frm_cd, v.comp_cd, 1, 'N', now()
FROM (VALUES
  ('PRF_MIRROR_SQHAND',       'COMP_MIRROR_GOODS_SQHAND'),
  ('PRF_MIRROR_SQHAND_BLACK', 'COMP_MIRROR_GOODS_SQHAND_BLACK')
) AS v(frm_cd, comp_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc
                  WHERE fc.frm_cd=v.frm_cd AND fc.comp_cd=v.comp_cd);

-- A4. component_prices (verbatim 가격포함 · comp_price_id=IDENTITY)
-- ★IDENTITY 시퀀스가 실 MAX보다 뒤처짐(setval 함정) → 선행 동기화(실 COMMIT도 필수)
SELECT setval(pg_get_serial_sequence('t_prc_component_prices','comp_price_id'),
              (SELECT MAX(comp_price_id) FROM t_prc_component_prices));
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, unit_price, note, reg_dt)
SELECT v.comp_cd, '2026-06-01', v.siz_cd, v.unit_price, v.note, now()
FROM (VALUES
  ('COMP_MIRROR_GOODS_SQHAND',       'SIZ_000384', 5000.00, '사각손거울 S(75x130mm) 완제품가'),
  ('COMP_MIRROR_GOODS_SQHAND',       'SIZ_000386', 5500.00, '사각손거울 M(95x166mm) 완제품가'),
  ('COMP_MIRROR_GOODS_SQHAND',       'SIZ_000388', 6000.00, '사각손거울 L(120x218mm) 완제품가'),
  ('COMP_MIRROR_GOODS_SQHAND_BLACK', 'SIZ_000384', 6000.00, '블랙사각손거울 S(75x130mm) 완제품가'),
  ('COMP_MIRROR_GOODS_SQHAND_BLACK', 'SIZ_000386', 7500.00, '블랙사각손거울 M(95x166mm) 완제품가'),
  ('COMP_MIRROR_GOODS_SQHAND_BLACK', 'SIZ_000388', 9000.00, '블랙사각손거울 L(120x218mm) 완제품가')
) AS v(comp_cd, siz_cd, unit_price, note)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
  WHERE cp.comp_cd=v.comp_cd AND cp.siz_cd=v.siz_cd AND cp.apply_ymd='2026-06-01');

-- A5. product_price_formulas (바인딩 · PK=(prd_cd,apply_bgn_ymd))
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT v.prd_cd, v.frm_cd, '2026-06-01', '거울류 굿즈 고정가 배선(견적0 해소)', now()
FROM (VALUES
  ('PRD_000186', 'PRF_MIRROR_SQHAND'),
  ('PRD_000187', 'PRF_MIRROR_SQHAND_BLACK')
) AS v(prd_cd, frm_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas pf
                  WHERE pf.prd_cd=v.prd_cd AND pf.apply_bgn_ymd='2026-06-01');

-- ─────────────────────────────────────────────────────────────────────────
-- PART B. COMP_ACRYL_MIRROR3T = 직접입력형 통용단가 → PRF_MIRROR_ACRYL 신설·배선
--          (READY. 바인딩은 CONFIRM① — 직접입력 미러아크릴 상품 미존재)
-- ─────────────────────────────────────────────────────────────────────────
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_MIRROR_ACRYL', '미러 아크릴 공식', '미러아크릴3T 직접입력형 면적 통용단가(아크릴 B03). 소비상품 CONFIRM 대기.', 'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_MIRROR_ACRYL');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_MIRROR_ACRYL', 'COMP_ACRYL_MIRROR3T', 1, 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
                  WHERE frm_cd='PRF_MIRROR_ACRYL' AND comp_cd='COMP_ACRYL_MIRROR3T');
-- (바인딩 없음: 직접입력 미러아크릴 상품 생성 후 별도 배선 — CONFIRM①)

-- ─────────────────────────────────────────────────────────────────────────
-- 검증 1 — 배선 무결성(186/187 공식→comp→단가행 사슬 완결)
-- ─────────────────────────────────────────────────────────────────────────
\echo '=== V1: 186/187 사슬 (공식/comp/단가행 개수) ==='
SELECT pf.prd_cd, pf.frm_cd, fc.comp_cd, c.prc_typ_cd, c.use_dims,
       count(cp.*) AS price_rows
FROM t_prd_product_price_formulas pf
JOIN t_prc_formula_components fc ON fc.frm_cd=pf.frm_cd
JOIN t_prc_price_components c    ON c.comp_cd=fc.comp_cd
LEFT JOIN t_prc_component_prices cp ON cp.comp_cd=fc.comp_cd
WHERE pf.prd_cd IN ('PRD_000186','PRD_000187')
GROUP BY pf.prd_cd, pf.frm_cd, fc.comp_cd, c.prc_typ_cd, c.use_dims
ORDER BY pf.prd_cd;

-- ─────────────────────────────────────────────────────────────────────────
-- 검증 2 — golden 재현(엔진 단가형 = unit_price × qty, qty=1 · DSC 0%)
-- ─────────────────────────────────────────────────────────────────────────
\echo '=== V2: golden G1~G6 (expected 5000/5500/6000/6000/7500/9000) ==='
SELECT p.prd_cd, p.prd_nm, cp.siz_cd, s.siz_nm, cp.unit_price AS golden_qty1
FROM t_prd_product_price_formulas pf
JOIN t_prd_products p            ON p.prd_cd=pf.prd_cd
JOIN t_prc_formula_components fc  ON fc.frm_cd=pf.frm_cd
JOIN t_prc_component_prices cp    ON cp.comp_cd=fc.comp_cd
JOIN t_siz_sizes s               ON s.siz_cd=cp.siz_cd
WHERE pf.prd_cd IN ('PRD_000186','PRD_000187')
ORDER BY p.prd_cd, cp.unit_price;

-- 검증 3 — disjoint(comp별 siz_cd 유일 → ambiguous 불가)
\echo '=== V3: comp별 siz_cd 중복 여부(0이어야 정상) ==='
SELECT comp_cd, siz_cd, count(*) AS dup
FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_MIRROR_GOODS_SQHAND','COMP_MIRROR_GOODS_SQHAND_BLACK')
GROUP BY comp_cd, siz_cd HAVING count(*)>1;

-- 검증 4 — Part B 배선(고아 해소·바인딩 없음 확인)
\echo '=== V4: PRF_MIRROR_ACRYL 배선 + 바인딩 개수(binding=0=CONFIRM 대기) ==='
SELECT
  (SELECT count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_MIRROR_ACRYL' AND comp_cd='COMP_ACRYL_MIRROR3T') AS wired,
  (SELECT count(*) FROM t_prd_product_price_formulas WHERE frm_cd='PRF_MIRROR_ACRYL') AS bound;

ROLLBACK;
-- ============================================================================
-- 실 적용 시(인간 승인 후 §7): BEGIN→(위 INSERT)→검증→COMMIT.
-- BLOCKED(183/184/185): §7 사이즈(무광75mm·57x91) 선등록 후 동일 패턴으로
--   COMP_MIRROR_GOODS_TIN/COMPACT/CARD + PRF_MIRROR_TIN/COMPACT/CARD +
--   단가 3000/3600/2500 + 바인딩 + DSC_GOODSB_QTY 연결.
-- ============================================================================
