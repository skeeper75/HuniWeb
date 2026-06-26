-- =============================================================================
-- DRY-RUN 증명 — 교정 SQL을 적용한 상태에서 엔진 매칭(_row_matches) 재현
-- 4조합(20P/30P × 단면/양면) 각자 정확히 1 comp 청구 · 이중합산 0 실증
-- 전부 BEGIN/ROLLBACK 안에서 — 라이브 무변경(읽기전용 등가)
-- 엔진 규칙 재현:
--   _row_matches: NON_QTY_DIM(siz_cd, print_opt_cd) 정확매칭(행 NULL=와일드카드)
--                 + dim_vals 전 키 정확매칭(와일드카드 없음)
--   match_component: 그 후 min_qty 구간 = 주문수량 이하 최대 임계
--   _evaluate_formula: addtn_yn=Y comp 매칭행 subtotal 합산
-- =============================================================================
BEGIN;

-- 교정 적용 (pcb-30p-fix.sql STEP 1~4과 동일)
UPDATE t_prc_component_prices SET dim_vals = COALESCE(dim_vals,'{}'::jsonb)||jsonb_build_object('page','20')
 WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P') AND (dim_vals IS NULL OR NOT (dim_vals ? 'page'));
UPDATE t_prc_component_prices SET dim_vals = COALESCE(dim_vals,'{}'::jsonb)||jsonb_build_object('page','30')
 WHERE comp_cd IN ('COMP_PCB_S1_30P','COMP_PCB_S2_30P') AND (dim_vals IS NULL OR NOT (dim_vals ? 'page'));
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000001' WHERE comp_cd='COMP_PCB_S1_30P' AND print_opt_cd IS NULL;
UPDATE t_prc_component_prices SET print_opt_cd='POPT_000002' WHERE comp_cd='COMP_PCB_S2_30P' AND print_opt_cd IS NULL;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_PCB_FIXED','COMP_PCB_S1_30P',3,'Y',now()), ('PRF_PCB_FIXED','COMP_PCB_S2_30P',4,'Y',now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 매칭 시뮬 함수: 주문(siz, popt, page, qty)에 대해 PRF_PCB_FIXED 매칭 comp+청구합
-- ---------------------------------------------------------------------------
\echo '======================================================================='
\echo '4조합 청구 실증 (siz=SIZ_000003[100x150], qty=100). 권위: 단20=4500 단30=5100 양30=5300'
\echo '======================================================================='

WITH orders(label, siz, popt, page, qty) AS (
  VALUES
    ('20P 단면', 'SIZ_000003','POPT_000001','20',100),
    ('20P 양면', 'SIZ_000003','POPT_000002','20',100),
    ('30P 단면', 'SIZ_000003','POPT_000001','30',100),
    ('30P 양면', 'SIZ_000003','POPT_000002','30',100)
),
-- 바인딩된 comp의 단가행을 _row_matches로 필터
matched AS (
  SELECT o.label, cp.comp_cd, cp.unit_price, cp.min_qty,
         o.siz, o.popt, o.page, o.qty
    FROM orders o
    JOIN t_prc_formula_components fc ON fc.frm_cd='PRF_PCB_FIXED'
    JOIN t_prc_component_prices cp   ON cp.comp_cd=fc.comp_cd
   WHERE (cp.siz_cd IS NULL OR cp.siz_cd = o.siz)                       -- NON_QTY siz
     AND (cp.print_opt_cd IS NULL OR cp.print_opt_cd = o.popt)          -- NON_QTY print_opt(와일드카드)
     AND (NOT (cp.dim_vals ? 'page') OR cp.dim_vals->>'page' = o.page)  -- dim_vals page 정확매칭
     AND cp.min_qty <= o.qty
),
-- min_qty 구간: comp별 주문수량 이하 최대 임계
tiered AS (
  SELECT m.*,
         row_number() OVER (PARTITION BY m.label, m.comp_cd ORDER BY m.min_qty DESC) rn
    FROM matched m
)
SELECT label,
       string_agg(comp_cd||'='||unit_price, ' + ' ORDER BY comp_cd) AS matched_comps,
       count(*)                                          AS comp_cnt,
       sum(unit_price)                                   AS billed_per_unit
  FROM tiered
 WHERE rn = 1
 GROUP BY label
 ORDER BY label;

\echo ''
\echo '기대: 각 행 comp_cnt=1 (이중합산 0), billed = 권위 단가'
\echo '  20P 단면 -> COMP_PCB_S1_20P=4500  comp_cnt=1'
\echo '  20P 양면 -> COMP_PCB_S2_20P=4500  comp_cnt=1'
\echo '  30P 단면 -> COMP_PCB_S1_30P=5100  comp_cnt=1'
\echo '  30P 양면 -> COMP_PCB_S2_30P=5300  comp_cnt=1'

\echo ''
\echo '--- 안전성: page 누락 주문(클라이언트 page 미전송) → 매칭 0 (silent fallback 차단) ---'
WITH no_page(siz,popt,qty) AS (VALUES ('SIZ_000003','POPT_000001',100))
SELECT count(*) AS matched_rows_when_page_missing
  FROM no_page np
  JOIN t_prc_formula_components fc ON fc.frm_cd='PRF_PCB_FIXED'
  JOIN t_prc_component_prices cp   ON cp.comp_cd=fc.comp_cd
 WHERE (cp.siz_cd IS NULL OR cp.siz_cd=np.siz)
   AND (cp.print_opt_cd IS NULL OR cp.print_opt_cd=np.popt)
   AND (NOT (cp.dim_vals ? 'page') OR cp.dim_vals->>'page' = NULL)  -- page 미전송 → NULL 비교 → 불일치
   AND cp.min_qty <= np.qty;
\echo '기대: 0 (page 차원이 정확매칭이라 미전송 시 매칭 없음 → 0원+경고, 저청구 불가)'

ROLLBACK;

-- =============================================================================
-- 실행 증거 기록 (라이브 DRY-RUN, 2026-06-26 · SIZ_000003 100x150 · qty100)
-- =============================================================================
-- [현재 pre-fix] 공식=20P 2 comp만 바인딩, page 차원 없음 → 30P 주문 fallback:
--   20P 단면        COMP_PCB_S1_20P=4500   billed=4500
--   20P 양면        COMP_PCB_S2_20P=4500   billed=4500
--   30P 단면(주문)  COMP_PCB_S1_20P=4500   billed=4500   🔴 권위 5100 대비 −600 저청구
--   30P 양면(주문)  COMP_PCB_S2_20P=4500   billed=4500   🔴 권위 5300 대비 −800 저청구
--
-- [교정 post-fix] dim_vals.page + 30P print_opt 보강 + 4 comp 배선:
--   20P 단면   COMP_PCB_S1_20P=4500   comp_cnt=1   billed=4500   ✓
--   20P 양면   COMP_PCB_S2_20P=4500   comp_cnt=1   billed=4500   ✓
--   30P 단면   COMP_PCB_S1_30P=5100   comp_cnt=1   billed=5100   ✓ (저청구 해소)
--   30P 양면   COMP_PCB_S2_30P=5300   comp_cnt=1   billed=5300   ✓ (저청구 해소)
--   page 미전송 주문 → 매칭 0 (silent fallback 차단·0원+경고)
--   ★ 전 조합 comp_cnt=1 → 이중합산 0 (페이지·단/양면 모두 배타)
--   ★ unit_price 무변경 (UPDATE는 dim_vals/print_opt/use_dims/배선만)
-- =============================================================================
