-- ============================================================================
-- ★★ SUPERSEDED (2026-07-02): 폼보드(PRD_000129)는 poster-banner-fix-dryrun.sql 로 대체됨.
--   이 파일의 [A]폼보드=BLOCKED 판정은 사용자 승인 방향 "옵션모델(a) 완성"으로 해소됨
--   (COMP_POSTER_FOAMBOARD_BOARD [mat_cd,siz_cd] 신설·화이트6000/블랙8500 골든).
--   [B]포맥스(PRD_000130) 부분은 별건(여전히 DEFER) — 이 파일 참조 유지.
-- ============================================================================
-- foamboard-fix-dryrun.sql  (§27 배선 서브트랙 — 폼보드/포맥스 orphan)
-- 2026-07-01 · BEGIN…ROLLBACK 전용 · 실 COMMIT 절대 금지
-- ----------------------------------------------------------------------------
-- ★★ 중대 발견 (task 전제 무효화):
--   task는 "PRD_000129 product_sizes = {174,197}만 등록, 315/317 등록하면 발현"
--   전제로 작성됐으나, 라이브는 2026-07-01 18:48~19:00 사이 별도 트랙이
--   PRD_000129(폼보드)에 대해 진행중 재설계를 커밋해 전제가 깨졌다:
--     · product_sizes: 174(A3)/197(A2) 논리삭제 → 315(A3)/198(A2) 캐논 재매핑
--       (§17 basedata-dedup 표시중복 통합: 174·315 둘다 "A3 297x420")
--     · 보드칼라 옵션(OPT-000045: 화이트/블랙보드) 신설 → 자재 MAT_000398/399
--       (A3폼보드 화이트/블랙 5mm) + 공정 PROC_000135(실사가공) 참조
--     · 그러나 그 자재/공정에 단가행(component_prices) 0건 = 가격 미완성
--   결과(시뮬레이터 실측): PRD_000129 A3(315)·A2(198) 모두 final_price=0
--     (공식 PRF_POSTER_FOAMBOARD ← WHITE 컴포넌트는 siz_cd 174/197/293 키인데
--      상품은 315/198만 제공 → NO_MATCH → silent-zero 파손).
--   → design-doc-D의 "siz_cd disjoint(白174↔黑315)" 안전성은 이 재설계로 소멸.
--      BLACK을 지금 배선하면 A3(315)가 BLACK(8500)에 매칭돼 색상선택 무관 오청구,
--      A2(198)는 BLACK(317)와 불일치로 여전히 0 → 파손 미해결.
--   ⇒ 폼보드 배선 = BLOCKED. 진행중 옵션모델 소유 트랙 + §17 dedup + 실무진 조율 필요.
-- ============================================================================

BEGIN;

-- ─────────────────────────────────────────────────────────────────────────
-- [A] 폼보드 PRD_000129  ⟶  BLOCKED (아래 배선 실행 금지 · 주석 보존만)
--   실행 시 오청구/미해결이므로 절대 커밋 금지. 재설계 완료 후 재평가.
--   (참고) 원 task가 요구한 배선 (실행하지 않음):
-- INSERT INTO t_prd_product_sizes(prd_cd,siz_cd,dflt_yn,disp_seq,reg_dt,del_yn)
--   SELECT 'PRD_000129','SIZ_000315','Y',1,now(),'N'
--   WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes WHERE prd_cd='PRD_000129' AND siz_cd='SIZ_000315' AND del_yn='N');
--   -- ↑ 이미 315 존재(dedup). 317(블랙A2)은 상품이 198(A2)을 캐논으로 쓰므로 무의미.
-- INSERT INTO t_prc_formula_components(frm_cd,comp_cd,disp_seq,addtn_yn,reg_dt)
--   SELECT 'PRF_POSTER_FOAMBOARD','COMP_POSTER_FOAMBOARD_BLACK',2,'Y',now()
--   WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOAMBOARD' AND comp_cd='COMP_POSTER_FOAMBOARD_BLACK');
--   -- ↑ 315가 상품 A3이자 BLACK A3키 → 색상 무관 8500 오청구. 금지.

\echo '=== [A] 폼보드 PRD_000129 현재 파손 상태 재확인 (BLOCKED) ==='
\echo '--- product_sizes (활성 315/198, 174/197 삭제됨) ---'
SELECT prd_cd, siz_cd, dflt_yn, del_yn FROM t_prd_product_sizes
 WHERE prd_cd='PRD_000129' ORDER BY siz_cd;
\echo '--- 배선된 컴포넌트 (WHITE는 174/197/293 키 = 상품 315/198과 불일치) ---'
SELECT fc.frm_cd, fc.comp_cd,
       (SELECT string_agg(siz_cd,',' ORDER BY siz_cd) FROM t_prc_component_prices cp WHERE cp.comp_cd=fc.comp_cd) AS priced_sizes
  FROM t_prc_formula_components fc WHERE fc.frm_cd='PRF_POSTER_FOAMBOARD';

-- ─────────────────────────────────────────────────────────────────────────
-- [B] 포맥스 PRD_000130  ⟶  기계적으로 안전(disjoint) · 단 DEFER 권고
--   포맥스는 재설계 미착수(product_sizes 174/197=3mm 정상 동작, A3=8500·A2=13000).
--   5mm orphan(COMP_..WHITE5MM: 315/317) 활성 = 사이즈 315/317 등록 + 5mm 배선.
--   siz_cd disjoint(174/197=3mm ↔ 315/317=5mm) → 동시매칭 0 = 기계적 안전.
--   ★그러나: 상품이 "A3(174)"·"A3(315)" 두 개의 거의 동일 표시 사이즈를 노출 →
--     두께(3mm/5mm) 라벨 부재로 UX 혼란 + §17 dedup의 표시중복 지뢰(폼보드를
--     방금 파손시킨 그 패턴). 폼보드가 옵션모델(두께/색상=opt)로 가는 방향과 불일치.
--   ⇒ 아래는 "기계적 유효성 실증용" dryrun. COMMIT 전 옵션모델 정렬 여부 실무진 확정.
-- ─────────────────────────────────────────────────────────────────────────

-- B-1) 사이즈 등록 (멱등 NOT EXISTS)
INSERT INTO t_prd_product_sizes(prd_cd,siz_cd,dflt_yn,disp_seq,reg_dt,del_yn)
  SELECT 'PRD_000130','SIZ_000315','N',3,now(),'N'
  WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes WHERE prd_cd='PRD_000130' AND siz_cd='SIZ_000315' AND del_yn='N');
INSERT INTO t_prd_product_sizes(prd_cd,siz_cd,dflt_yn,disp_seq,reg_dt,del_yn)
  SELECT 'PRD_000130','SIZ_000317','N',4,now(),'N'
  WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes WHERE prd_cd='PRD_000130' AND siz_cd='SIZ_000317' AND del_yn='N');

-- B-2) 5mm 컴포넌트 배선 (멱등 NOT EXISTS · addtn_yn=Y · disjoint)
INSERT INTO t_prc_formula_components(frm_cd,comp_cd,disp_seq,addtn_yn,reg_dt)
  SELECT 'PRF_POSTER_FOMEXBOARD','COMP_POSTER_FOMEXBOARD_WHITE5MM',2,'Y',now()
  WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOMEXBOARD' AND comp_cd='COMP_POSTER_FOMEXBOARD_WHITE5MM');

\echo '=== [B] 포맥스 PRD_000130 dryrun 후 상태 ==='
\echo '--- product_sizes (174/197=3mm + 315/317=5mm) ---'
SELECT prd_cd, siz_cd, dflt_yn, del_yn FROM t_prd_product_sizes
 WHERE prd_cd='PRD_000130' AND del_yn='N' ORDER BY disp_seq, siz_cd;
\echo '--- formula_components (3mm seq1 + 5mm seq2) ---'
SELECT frm_cd, comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components
 WHERE frm_cd='PRF_POSTER_FOMEXBOARD' ORDER BY disp_seq;
\echo '--- disjoint 확인: 각 siz_cd가 몇 개 comp에 매칭되나(1이어야 안전) ---'
SELECT s.siz_cd,
       count(*) FILTER (WHERE cp.comp_cd IS NOT NULL) AS matching_comps
  FROM (SELECT unnest(ARRAY['SIZ_000174','SIZ_000197','SIZ_000315','SIZ_000317']) siz_cd) s
  LEFT JOIN t_prc_component_prices cp
         ON cp.siz_cd=s.siz_cd
        AND cp.comp_cd IN (SELECT comp_cd FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOMEXBOARD')
  GROUP BY s.siz_cd ORDER BY s.siz_cd;

ROLLBACK;
-- ============================================================================
-- 실행: psql … -f foamboard-fix-dryrun.sql  (ROLLBACK로 무커밋)
-- COMMIT 금지. [A]폼보드=BLOCKED, [B]포맥스=DEFER(실무진 옵션모델 정렬 확정 후).
-- ============================================================================
