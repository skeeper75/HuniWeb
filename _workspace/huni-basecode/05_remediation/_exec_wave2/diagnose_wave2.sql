-- ============================================================================
-- diagnose_wave2.sql — Wave 2 안전 판정 근거 재현 (READ-ONLY SELECT 전용)
-- ----------------------------------------------------------------------------
-- [HARD] 본 파일은 SELECT만 — INSERT/UPDATE/DELETE 0. 쓰기 트랜잭션 아님.
--        Wave 2(R8 인쇄면→print_side·R9 구수→bundle·R7 dtl_opt)가 "라이브 직접
--        축이동 부적격(목적지 행 전무·무손실 소스 부재)"임을 라이브 실측으로 재현.
--        결론은 _deferred.md. 본 파일은 그 근거 SELECT의 재실행 가능본.
-- [HARD] 실 COMMIT 0·축이동 INSERT 0 — 본 wave에 안전 실행본 없음(escalate).
-- ============================================================================

\echo '=== [R8] 인쇄면 14행 → print_side : 소유 상품 + 목적지 print_options 행수 ==='
WITH ps_mat(mat_cd) AS (VALUES
  ('MAT_000271'),('MAT_000272'),('MAT_000290'),('MAT_000291'),('MAT_000309'),
  ('MAT_000311'),('MAT_000313'),('MAT_000316'),('MAT_000317'),('MAT_000318'),
  ('MAT_000332'),('MAT_000333'),('MAT_000334'),('MAT_000336')),
owners AS (SELECT DISTINCT pm.prd_cd FROM t_prd_product_materials pm JOIN ps_mat USING (mat_cd))
SELECT o.prd_cd, p.prd_nm, p.use_yn,
       (SELECT count(*) FROM t_prd_product_print_options po WHERE po.prd_cd=o.prd_cd) AS print_opt_rows
  FROM owners o JOIN t_prd_products p USING (prd_cd)
 ORDER BY o.prd_cd;

\echo '--- [R8] NOT NULL 차단: print_options 필수 도수 컬럼 무소스 증명 ---'
SELECT 'front/back_colrcnt_cd NOT NULL FK → t_clr_color_counts' AS blocker,
       '자재 .09 인쇄면 행에 도수 정보 0 (무손실 소스 없음 → 날조 금지)' AS reason;

\echo ''
\echo '=== [R9] 구수 5행 → bundle : 소유 상품 + 목적지 bundle_qtys 행수 ==='
WITH bd_mat(mat_cd) AS (VALUES
  ('MAT_000277'),('MAT_000278'),('MAT_000279'),('MAT_000280'),('MAT_000294')),
owners AS (SELECT DISTINCT pm.prd_cd FROM t_prd_product_materials pm JOIN bd_mat USING (mat_cd))
SELECT o.prd_cd, p.prd_nm, p.use_yn,
       (SELECT count(*) FROM t_prd_product_bundle_qtys bq WHERE bq.prd_cd=o.prd_cd) AS bundle_rows
  FROM owners o JOIN t_prd_products p USING (prd_cd)
 ORDER BY o.prd_cd;

\echo '--- [R9] 차단: bdl_qty/dflt_yn NOT NULL — dflt 선택·2개1팩 해석 무근거 ---'
SELECT 'dflt_yn NOT NULL + 2개1팩(MAT_000294) bdl_qty 해석' AS blocker,
       '소스 자재행에 dflt 표시·묶음수 정수 해석 없음 (인간/실무진 결정)' AS reason;

\echo ''
\echo '=== [R7] dtl_opt param : 전역 채움 상태 + 대상 상품 option_items 행수 ==='
SELECT count(*) AS total_option_items,
       count(*) FILTER (WHERE dtl_opt IS NOT NULL AND dtl_opt::text NOT IN ('null','{}','')) AS dtl_filled
  FROM t_prd_product_option_items;

\echo '--- [R7] 차단: 대상 상품 option_items 행 0 → UPDATE 대상 부재 + AX-5 범위 미해소 ---'
WITH tgt(prd_cd) AS (VALUES
  ('PRD_000195'),('PRD_000208'),('PRD_000220'),('PRD_000226'),('PRD_000227'),
  ('PRD_000228'),('PRD_000229'),('PRD_000264'),('PRD_000267'),('PRD_000268'),
  ('PRD_000270'),('PRD_000271'),('PRD_000276'),('PRD_000277'),('PRD_000278'),
  ('PRD_000279'),('PRD_000202'),('PRD_000203'),('PRD_000214'))
SELECT (SELECT count(*) FROM t_prd_product_option_items oi JOIN tgt USING (prd_cd)) AS target_option_items_rows,
       'AX-5(이관 범위) 잔여 컨펌 + 목적지 행 0 → 실행 구체 매핑 부재' AS reason;

\echo ''
\echo '=== 가격사슬 무접촉 재확인 (cp 직접 참조 0이어야) ==='
SELECT 'R8_ps_cp_ref' AS chk, count(*) AS refs FROM t_prc_component_prices
 WHERE mat_cd IN ('MAT_000271','MAT_000272','MAT_000290','MAT_000291','MAT_000309',
   'MAT_000311','MAT_000313','MAT_000316','MAT_000317','MAT_000318','MAT_000332',
   'MAT_000333','MAT_000334','MAT_000336');
SELECT 'R9_bd_cp_ref' AS chk, count(*) AS refs FROM t_prc_component_prices
 WHERE mat_cd IN ('MAT_000277','MAT_000278','MAT_000279','MAT_000280','MAT_000294');

\echo ''
\echo '=== 결론: Wave 2 라이브 직접 축이동 실행본 = 0 (전건 escalate · _deferred.md) ==='
