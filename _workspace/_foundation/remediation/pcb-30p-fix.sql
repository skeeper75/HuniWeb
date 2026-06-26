-- =============================================================================
-- A2 C5-D1 — 094 엽서북 30P 고아배선(저청구) 교정 SQL
-- =============================================================================
-- 트랙       : round-13 교정 (라이브 UPDATE/배선 · 데이터 unit_price 무변경)
-- 권위       : 가격표 260527 엽서북떡메 B01 (페이지=1급 가격축) verbatim
-- 결함       : PRF_PCB_FIXED에 COMP_PCB_S1/S2_30P 미배선(고아) + 페이지 차원 부재
--              → 30P 주문이 20P comp로 silent fallback = 장당 600~800원 저청구
-- 교정구조   : ⓐ dim_vals.page 판별자(20P/30P 배타) + 30P print_opt_cd 보강(단/양면 배타)
-- 엔진수정   : 0 (pricing._row_matches가 dim_vals 정확매칭·NON_QTY print_opt 매칭 이미 지원)
-- 멱등성     : 전 구문 조건부/ON CONFLICT — 재실행 안전
-- 안전       : 단일 트랜잭션 · 라이브 적용은 인간 승인 후 (이 파일은 DRY-RUN 검증본)
-- ★ unit_price·apply_ymd·siz_cd·min_qty 는 한 컬럼도 건드리지 않는다.
-- =============================================================================

BEGIN;

-- -----------------------------------------------------------------------------
-- STEP 1. 페이지 판별 차원(dim_vals.page) 부여 — 4 comp 전 단가행
--   20P comp → {"page":"20"} · 30P comp → {"page":"30"}
--   dim_vals는 _row_matches에서 와일드카드 없는 정확매칭 → 페이지 배타 보장
--   멱등: dim_vals가 아직 page 키 없을 때만 병합(있으면 skip)
-- -----------------------------------------------------------------------------
UPDATE t_prc_component_prices
   SET dim_vals = COALESCE(dim_vals, '{}'::jsonb) || jsonb_build_object('page', '20'),
       upd_dt   = now()
 WHERE comp_cd IN ('COMP_PCB_S1_20P', 'COMP_PCB_S2_20P')
   AND (dim_vals IS NULL OR NOT (dim_vals ? 'page'));

UPDATE t_prc_component_prices
   SET dim_vals = COALESCE(dim_vals, '{}'::jsonb) || jsonb_build_object('page', '30'),
       upd_dt   = now()
 WHERE comp_cd IN ('COMP_PCB_S1_30P', 'COMP_PCB_S2_30P')
   AND (dim_vals IS NULL OR NOT (dim_vals ? 'page'));

-- -----------------------------------------------------------------------------
-- STEP 2. 30P comp의 print_opt_cd 보강 — 단면/양면 배타화(R-3 이중합산 가드)
--   S1_30P(단면) → POPT_000001 · S2_30P(양면) → POPT_000002
--   (20P comp는 이미 print_opt_cd 적재됨 — 손대지 않음)
--   멱등: 아직 NULL인 행만 채움
-- -----------------------------------------------------------------------------
UPDATE t_prc_component_prices
   SET print_opt_cd = 'POPT_000001',  -- 단면
       upd_dt       = now()
 WHERE comp_cd = 'COMP_PCB_S1_30P'
   AND print_opt_cd IS NULL;

UPDATE t_prc_component_prices
   SET print_opt_cd = 'POPT_000002',  -- 양면
       upd_dt       = now()
 WHERE comp_cd = 'COMP_PCB_S2_30P'
   AND print_opt_cd IS NULL;

-- -----------------------------------------------------------------------------
-- STEP 3. 30P comp의 use_dims에 print_opt_cd 추가 (20P와 동형)
--   현재 ["siz_cd","min_qty"] → ["siz_cd","min_qty","print_opt_cd"]
--   ★ page는 use_dims에 넣지 않는다 — dim_vals 경로로 매칭되므로 use_dims 불필요.
--   멱등: print_opt_cd 미포함일 때만 append
-- -----------------------------------------------------------------------------
UPDATE t_prc_price_components
   SET use_dims = use_dims || '["print_opt_cd"]'::jsonb,
       upd_dt   = now()
 WHERE comp_cd IN ('COMP_PCB_S1_30P', 'COMP_PCB_S2_30P')
   AND NOT (use_dims @> '["print_opt_cd"]'::jsonb);

-- -----------------------------------------------------------------------------
-- STEP 4. 30P comp를 PRF_PCB_FIXED 공식에 배선 (addtn_yn=Y · 20P와 동일 합산모델)
--   disp_seq 3,4 (현재 max=2). 멱등: ON CONFLICT DO NOTHING (복합PK frm_cd+comp_cd)
-- -----------------------------------------------------------------------------
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES
  ('PRF_PCB_FIXED', 'COMP_PCB_S1_30P', 3, 'Y', now()),
  ('PRF_PCB_FIXED', 'COMP_PCB_S2_30P', 4, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 검증 SELECT (트랜잭션 내) — 적용 결과 확인
-- -----------------------------------------------------------------------------
\echo '--- formula_components 후(4 comp 기대) ---'
SELECT frm_cd, comp_cd, disp_seq, addtn_yn
  FROM t_prc_formula_components
 WHERE frm_cd = 'PRF_PCB_FIXED' ORDER BY disp_seq;

\echo '--- 30P comp use_dims + print_opt 분포 후 ---'
SELECT comp_cd, use_dims,
       count(*) FILTER (WHERE print_opt_cd IS NOT NULL) AS with_popt,
       count(*) FILTER (WHERE dim_vals ? 'page')        AS with_page
  FROM t_prc_component_prices cp
  JOIN t_prc_price_components pc USING (comp_cd)
 WHERE cp.comp_cd LIKE 'COMP_PCB%'
 GROUP BY comp_cd, use_dims ORDER BY comp_cd;

-- ★ 라이브 적용 시 아래를 COMMIT 으로 교체(인간 승인 후). 검증/DRY-RUN은 ROLLBACK.
ROLLBACK;
