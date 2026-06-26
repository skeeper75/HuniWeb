-- =====================================================================
-- bind-sum-dryrun.sql  —  PRF_BIND_SUM 교정 적재 가능성 + evaluate_price 재계산 실증
-- 롤백 전용: BEGIN … ROLLBACK 으로 감싸 라이브를 절대 변경하지 않는다.
-- 입증: ① 교정 SQL이 무오류 적재 가능(공식/배선/바인딩) ② 멱등(2회차 0행)
--       ③ 교정 후 4책자가 각자 올바른 제본단가로 청구(qty=100 골든 재현).
-- 엔진 정합: 제본 comp prc_typ=PRICE_TYPE.01(단가형) → subtotal = 단가(min_qty=100 tier) × qty.
--            proc_cd = NON_QTY_DIMS 정확매칭(pricing.py:42·82). 상품별 proc=018/019/020/021 고정.
-- =====================================================================
BEGIN;

\echo '###############################################################'
\echo '# STEP 0 — BEFORE(현 라이브): 4책자가 전부 PRF_BIND_SUM(중철comp) 공유'
\echo '###############################################################'
SELECT p.prd_cd, p.frm_cd,
       (SELECT string_agg(fc.comp_cd, ',') FROM t_prc_formula_components fc WHERE fc.frm_cd=p.frm_cd) AS wired_comps
  FROM t_prd_product_price_formulas p
 WHERE p.prd_cd IN ('PRD_000068','PRD_000069','PRD_000070','PRD_000071')
 ORDER BY p.prd_cd;

\echo ''
\echo '# BEFORE 재계산(qty=100) — 각 책자의 바인딩 공식이 그 책자 제본proc로 단가행을 찾나'
\echo '#   068 중철(proc018)=정상 / 069·070·071=no_match=0원 누락 이 보여야 함'
WITH prod(prd_cd, proc_cd, label) AS (
  VALUES ('PRD_000068','PROC_000018','068 중철'),
         ('PRD_000069','PROC_000019','069 무선'),
         ('PRD_000070','PROC_000020','070 PUR'),
         ('PRD_000071','PROC_000021','071 트윈링')
)
SELECT pr.label,
       ppf.frm_cd,
       -- 바인딩 공식의 comp들 중, 이 상품 제본proc(min_qty<=100 최대구간)에 매칭되는 단가 × 100
       COALESCE((
         SELECT cp.unit_price * 100
           FROM t_prc_formula_components fc
           JOIN t_prc_component_prices cp ON cp.comp_cd = fc.comp_cd
          WHERE fc.frm_cd = ppf.frm_cd
            AND cp.proc_cd = pr.proc_cd          -- proc_cd 정확매칭(no_match면 0)
            AND cp.min_qty <= 100
          ORDER BY cp.min_qty DESC               -- 이하 최대구간(=min_qty 100)
          LIMIT 1
       ), 0) AS bind_subtotal_qty100
  FROM prod pr
  JOIN t_prd_product_price_formulas ppf ON ppf.prd_cd = pr.prd_cd
 ORDER BY pr.label;

\echo ''
\echo '###############################################################'
\echo '# STEP 1 — 교정 SQL 적용(공식 신설·배선·바인딩 교정)'
\echo '###############################################################'

INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES
  ('PRF_BIND_MUSEON',  '제본 합산형(무선)',   '무선책자 제본비. 수량구간×무선제본 단가를 상위 공식에 더함.',   'Y'),
  ('PRF_BIND_PUR',     '제본 합산형(PUR)',    'PUR책자 제본비. 수량구간×PUR제본 단가를 상위 공식에 더함.',     'Y'),
  ('PRF_BIND_TWINRING','제본 합산형(트윈링)', '트윈링책자 제본비. 수량구간×트윈링제본 단가를 상위 공식에 더함.','Y')
ON CONFLICT (frm_cd) DO NOTHING;

UPDATE t_prc_price_formulas
   SET frm_nm = '제본 합산형(중철)',
       note   = '중철책자 제본비. 수량구간×중철제본 단가를 상위 공식에 더함.',
       upd_dt = now()
 WHERE frm_cd = 'PRF_BIND_SUM'
   AND (frm_nm IS DISTINCT FROM '제본 합산형(중철)'
        OR note   IS DISTINCT FROM '중철책자 제본비. 수량구간×중철제본 단가를 상위 공식에 더함.');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES
  ('PRF_BIND_MUSEON',   'COMP_BIND_MUSEON',   1, 'Y'),
  ('PRF_BIND_PUR',      'COMP_BIND_PUR',      1, 'Y'),
  ('PRF_BIND_TWINRING', 'COMP_BIND_TWINRING', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

UPDATE t_prd_product_price_formulas SET frm_cd='PRF_BIND_MUSEON',  upd_dt=now()
 WHERE prd_cd='PRD_000069' AND frm_cd='PRF_BIND_SUM';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_BIND_PUR',     upd_dt=now()
 WHERE prd_cd='PRD_000070' AND frm_cd='PRF_BIND_SUM';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_BIND_TWINRING',upd_dt=now()
 WHERE prd_cd='PRD_000071' AND frm_cd='PRF_BIND_SUM';

\echo ''
\echo '# STEP 1b — 멱등 확인: 같은 INSERT/UPDATE 재실행 → 0행 영향(충돌 무시·조건 불충족)'
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES ('PRF_BIND_MUSEON','제본 합산형(무선)','x','Y')
ON CONFLICT (frm_cd) DO NOTHING;     -- 0 rows
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_BIND_MUSEON','COMP_BIND_MUSEON',1,'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;  -- 0 rows
-- 바인딩 재실행: 이미 PRF_BIND_MUSEON 이므로 WHERE frm_cd='PRF_BIND_SUM' 불충족 → 0행
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_BIND_MUSEON'
 WHERE prd_cd='PRD_000069' AND frm_cd='PRF_BIND_SUM';

\echo ''
\echo '###############################################################'
\echo '# STEP 2 — AFTER: 각 책자가 자기 제본공식·자기 comp로 배선됐나'
\echo '###############################################################'
SELECT p.prd_cd, p.frm_cd,
       (SELECT string_agg(fc.comp_cd, ',') FROM t_prc_formula_components fc WHERE fc.frm_cd=p.frm_cd) AS wired_comps
  FROM t_prd_product_price_formulas p
 WHERE p.prd_cd IN ('PRD_000068','PRD_000069','PRD_000070','PRD_000071')
 ORDER BY p.prd_cd;

\echo ''
\echo '# STEP 2b — AFTER 재계산(qty=100): 4책자 각자 올바른 제본비'
\echo '#   기대: 068=70000 / 069=50000 / 070=200000 / 071=130000  (가격표 verbatim)'
WITH prod(prd_cd, proc_cd, label, golden) AS (
  VALUES ('PRD_000068','PROC_000018','068 중철',   70000),
         ('PRD_000069','PROC_000019','069 무선',   50000),
         ('PRD_000070','PROC_000020','070 PUR',   200000),
         ('PRD_000071','PROC_000021','071 트윈링', 130000)
)
SELECT pr.label, ppf.frm_cd,
       COALESCE((
         SELECT cp.unit_price * 100
           FROM t_prc_formula_components fc
           JOIN t_prc_component_prices cp ON cp.comp_cd = fc.comp_cd
          WHERE fc.frm_cd = ppf.frm_cd
            AND cp.proc_cd = pr.proc_cd
            AND cp.min_qty <= 100
          ORDER BY cp.min_qty DESC
          LIMIT 1
       ), 0) AS bind_subtotal_qty100,
       pr.golden AS expected,
       CASE WHEN COALESCE((
              SELECT cp.unit_price * 100
                FROM t_prc_formula_components fc
                JOIN t_prc_component_prices cp ON cp.comp_cd = fc.comp_cd
               WHERE fc.frm_cd = ppf.frm_cd AND cp.proc_cd = pr.proc_cd AND cp.min_qty <= 100
               ORDER BY cp.min_qty DESC LIMIT 1), 0) = pr.golden
            THEN 'PASS' ELSE 'FAIL' END AS verdict
  FROM prod pr
  JOIN t_prd_product_price_formulas ppf ON ppf.prd_cd = pr.prd_cd
 ORDER BY pr.label;

\echo ''
\echo '# STEP 3 — 동시매칭 가드: 각 바인딩 공식의 comp 수 = 1 이어야(4중 합산 0)'
SELECT frm_cd, count(*) AS comp_cnt
  FROM t_prc_formula_components
 WHERE frm_cd IN ('PRF_BIND_SUM','PRF_BIND_MUSEON','PRF_BIND_PUR','PRF_BIND_TWINRING')
 GROUP BY frm_cd ORDER BY frm_cd;

\echo ''
\echo '# STEP 4 — 범위 가드: 072/HC_*/CAL_*/SSABARI 미접촉 확인(본 교정이 건드리지 않음)'
SELECT 'HC/CAL/SSABARI comps untouched' AS check,
       count(*) FILTER (WHERE comp_cd LIKE 'COMP_BIND_HC%'
                          OR comp_cd LIKE 'COMP_BIND_CAL%'
                          OR comp_cd='COMP_BIND_SSABARI') AS hc_cal_ssabari_in_bind_formulas
  FROM t_prc_formula_components
 WHERE frm_cd IN ('PRF_BIND_SUM','PRF_BIND_MUSEON','PRF_BIND_PUR','PRF_BIND_TWINRING');
-- 기대: 0 (단일책자 제본공식엔 하드커버/캘린더/싸바리 comp 없음)

\echo ''
\echo '###############################################################'
\echo '# ROLLBACK — 라이브 무변경(검증 전용). 실 적용은 bind-sum-fix.sql + 인간 승인'
\echo '###############################################################'
ROLLBACK;
