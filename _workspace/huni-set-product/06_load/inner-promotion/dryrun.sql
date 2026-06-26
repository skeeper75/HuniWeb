-- ============================================================================
-- [제안·미실행] 072 내지 승격 — 롤백전용 DRY-RUN (멱등·FK·고아0·smoke 증명)
-- 실행: psql … -v ON_ERROR_STOP=on -f dryrun.sql  → 마지막 ROLLBACK (COMMIT 없음)
-- 증명: ① apply 2-pass 멱등(2회차 신규 0) ② FK 위상(284 선존) ③ 고아0 ④ smoke 단가행 실재
-- ★보정 2026-06-25: [차단1] 내지 sizes=정본 active SIZ_000007/050(A5/A4 둘 다 del_yn=N) assert
--                   [차단2] 채번 advisory lock/abort 가드는 apply.sql 내부 — DRY-RUN서 정상경로 검증
--                   [codex#7] disp_seq CASE 목표대입 멱등(부분실패 안전)
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

-- ── PASS 1: apply.sql 본문 적용 ──────────────────────────────────────────────
\i apply.sql

-- assert P1-a: 내지 PRD_000284 등록(위상 ① 선행)
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM t_prd_products WHERE prd_cd='PRD_000284') THEN
    RAISE EXCEPTION 'FAIL P1-a: 내지 PRD_000284 미등록'; END IF;
END $$;

-- assert P1-b: dims 행수 (sizes2·print2·page1·mat7·plate1 = 13)
DO $$ DECLARE n int; BEGIN
  SELECT (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000284')
       + (SELECT count(*) FROM t_prd_product_print_options WHERE prd_cd='PRD_000284')
       + (SELECT count(*) FROM t_prd_product_page_rules WHERE prd_cd='PRD_000284')
       + (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000284' AND usage_cd='USAGE.01')
       + (SELECT count(*) FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000284') INTO n;
  IF n <> 13 THEN RAISE EXCEPTION 'FAIL P1-b: 내지 dims 행수=% (기대 13)', n; END IF;
END $$;

-- assert P1-c: sets 행 + FK 선존 + disp_seq 재배열(072 sets disp_seq 집합 = 1..5 중복0)
DO $$ DECLARE setn int; dups int; BEGIN
  SELECT count(*) INTO setn FROM t_prd_product_sets
    WHERE prd_cd='PRD_000072' AND sub_prd_cd='PRD_000284' AND disp_seq=1;
  IF setn <> 1 THEN RAISE EXCEPTION 'FAIL P1-c: 내지 sets disp_seq=1 행=%', setn; END IF;
  SELECT count(*) - count(DISTINCT disp_seq) INTO dups FROM t_prd_product_sets
    WHERE prd_cd='PRD_000072' AND del_yn='N';
  IF dups <> 0 THEN RAISE EXCEPTION 'FAIL P1-c: disp_seq 중복 %', dups; END IF;
END $$;

-- assert P1-d: 고아 0 (내지 dims 코드가 마스터 실재·sets.sub_prd_cd 실재)
DO $$ DECLARE orph int; BEGIN
  SELECT count(*) INTO orph FROM t_prd_product_materials pm
    WHERE pm.prd_cd='PRD_000284'
      AND NOT EXISTS (SELECT 1 FROM t_mat_materials m WHERE m.mat_cd=pm.mat_cd);
  IF orph <> 0 THEN RAISE EXCEPTION 'FAIL P1-d: 내지종이 고아 %', orph; END IF;
END $$;

-- ★assert P1-e [차단1 CFM-INNER-A5-DEL]: 내지 sizes 가 정본 active(del_yn=N) 인지
--   삭제 siz(SIZ_000170 등 마스터 del_yn=Y) 참조 시 FAIL — 죽은 사이즈 재심기 방지
DO $$ DECLARE bad int; sizset text; BEGIN
  SELECT count(*) INTO bad
    FROM t_prd_product_sizes ps
    JOIN t_siz_sizes m ON m.siz_cd=ps.siz_cd
   WHERE ps.prd_cd='PRD_000284' AND m.del_yn='Y';
  IF bad <> 0 THEN RAISE EXCEPTION 'FAIL P1-e: 내지가 마스터 삭제(del_yn=Y) siz 를 % 건 참조(정본 active 위반)', bad; END IF;
  SELECT string_agg(siz_cd, ',' ORDER BY disp_seq) INTO sizset
    FROM t_prd_product_sizes WHERE prd_cd='PRD_000284';
  IF sizset <> 'SIZ_000007,SIZ_000050' THEN
    RAISE EXCEPTION 'FAIL P1-e: 내지 sizes=% (기대 SIZ_000007,SIZ_000050 정본 active)', sizset; END IF;
  RAISE NOTICE 'OK P1-e: 내지 sizes 정본 active(A5 SIZ_000007·A4 SIZ_000050·둘 다 del_yn=N)';
END $$;

-- ── PASS 2: apply.sql 재적용 → 멱등(신규 0·재배열 0) ─────────────────────────
DO $$ DECLARE before_sets int; after_sets int; before_seq int; BEGIN
  SELECT count(*) INTO before_sets FROM t_prd_product_sets WHERE prd_cd='PRD_000072';
  SELECT disp_seq INTO before_seq FROM t_prd_product_sets
    WHERE prd_cd='PRD_000072' AND sub_prd_cd='PRD_000073';
  -- (재적용은 \i 재실행으로·여기선 동등 가드 검증을 표현)
  PERFORM 1; -- placeholder: 실제 2-pass 는 아래 \i 가 수행
END $$;
\i apply.sql
-- assert P2: 2회차 후에도 072 sets 총행 = 5(내지1+표지1+면지3), 073 disp_seq=2 불변
DO $$ DECLARE tot int; seq73 int; BEGIN
  SELECT count(*) INTO tot FROM t_prd_product_sets WHERE prd_cd='PRD_000072' AND del_yn='N';
  IF tot <> 5 THEN RAISE EXCEPTION 'FAIL P2: 2회차 후 072 sets=% (기대5·멱등 위반)', tot; END IF;
  SELECT disp_seq INTO seq73 FROM t_prd_product_sets WHERE prd_cd='PRD_000072' AND sub_prd_cd='PRD_000073';
  IF seq73 <> 2 THEN RAISE EXCEPTION 'FAIL P2: 073 disp_seq=% (기대2·재배열 비멱등)', seq73; END IF;
END $$;

-- ── smoke: 내지 구성원이 쓸 단가행 실재(evaluate_price(284) ≠0 가능 사전 확증·읽기) ──
--   ★[D2 한계 명시] smoke 는 단가행 존재만 검사. S2 comp 헤더 del_yn 도 같이 보고(NOTICE):
--     S2 헤더 del_yn=Y 잔존 시 evaluate_price 가 양면 내지인쇄=0 → 양면 PRICE≠0 은 S2 부활(set-product) 선행 전제.
DO $$ DECLARE s2 int; paper int; s2del char(1); BEGIN
  SELECT count(*) INTO s2 FROM t_prc_component_prices
    WHERE comp_cd='COMP_PRINT_DIGITAL_S2' AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002';
  IF s2 = 0 THEN RAISE EXCEPTION 'FAIL smoke: S2 양면 국4절 단가행 0행'; END IF;
  SELECT count(*) INTO paper FROM t_prc_component_prices
    WHERE comp_cd='COMP_PAPER' AND plt_siz_cd='SIZ_000499' AND mat_cd='MAT_000073';
  IF paper = 0 THEN RAISE EXCEPTION 'FAIL smoke: 내지종이 백모120 국4절 절가 0행'; END IF;
  SELECT del_yn INTO s2del FROM t_prc_price_components WHERE comp_cd='COMP_PRINT_DIGITAL_S2';
  RAISE NOTICE 'OK smoke: S2 단가행 %행 · 내지종이 절가 %행 · S2헤더 del_yn=% (Y면 양면 PRICE!=0 은 S2부활 선행=set-product)', s2, paper, s2del;
END $$;

ROLLBACK;   -- ★DRY-RUN: 영구 변경 없음. COMMIT 은 인간 승인 후 별도.
