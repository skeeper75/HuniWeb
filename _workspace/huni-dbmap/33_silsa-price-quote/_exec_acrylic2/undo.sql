-- undo.sql — 아크릴 마무리(A5 + 코롯토 B2~B4) 실 COMMIT 원복. 단일 트랜잭션·기본 ROLLBACK.
-- [HARD] 실 COMMIT 이 적용된 뒤에만 의미. 백업 권위 = backup_a5_minqty_pre.csv(81·보정 전 min_qty NULL) + 코롯토 신설 전 부재(comp/formula 0행).
-- [HARD] 기본 ROLLBACK(아래). 실 원복 COMMIT 은 undo.sh --commit 으로만(인간 승인).
-- 과삭제 0: 코롯토 신설(comp/단가행/공식/배선) 전건 = 백업이 부재 확인(신설분만 삭제). A5 원복 = comp_price_id 기준 min_qty→NULL.
\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE _bk_a5 (comp_price_id bigint, comp_cd text, siz_width numeric, siz_height numeric, mat_cd text, min_qty integer, unit_price numeric);
\copy _bk_a5 FROM 'backup_a5_minqty_pre.csv' WITH CSV HEADER

-- 사전 가드: 백업 = A5 보정 전 스냅샷(min_qty 전건 NULL)
DO $$
DECLARE n int; n_notnull int;
BEGIN
  SELECT count(*) INTO n FROM _bk_a5;
  SELECT count(*) INTO n_notnull FROM _bk_a5 WHERE min_qty IS NOT NULL;
  IF n_notnull <> 0 THEN RAISE EXCEPTION 'backup A5 has % rows with non-null min_qty (보정 전 스냅샷 아님)', n_notnull; END IF;
  RAISE NOTICE 'A5 backup rows = %', n;
END $$;

-- ============================================================
-- B4 원복 (배선·공식 삭제) — formula_components 먼저(FK 자식), 그 다음 formula
-- ============================================================
\echo '=== B4 원복: 코롯토 배선 + 공식 삭제 ==='
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_COROTTO_ACRYL' AND comp_cd='COMP_ACRYL_COROTTO';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_COROTTO_ACRYL';

-- ============================================================
-- B3 원복 (코롯토 단가행 21 삭제) — comp 삭제 전(FK 자식)
--   삭제 대상 = COMP_ACRYL_COROTTO 단가행 전건(신설분만·백업 부재 확인). 과삭제 0(다른 comp 무관).
-- ============================================================
\echo '=== B3 원복: 코롯토 단가행 삭제 ==='
DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_COROTTO';

-- ============================================================
-- B2 원복 (코롯토 comp 삭제) — 단가행/배선 삭제 후
-- ============================================================
\echo '=== B2 원복: 코롯토 구성요소 삭제 ==='
DELETE FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_COROTTO';

-- ============================================================
-- A5 원복 (min_qty 1 → NULL) — 백업 comp_price_id 기준(보정 전 NULL 복원)
--   멱등: min_qty=1 인 백업행만(이미 NULL이면 0행). 골든 영향 없음(원복은 결함 상태로 되돌림).
-- ============================================================
\echo '=== A5 원복: .02 단가행 min_qty 1 → NULL 복원 (백업 comp_price_id 기준) ==='
UPDATE t_prc_component_prices cp
   SET min_qty = NULL, upd_dt = now()
  FROM _bk_a5 b
 WHERE cp.comp_price_id = b.comp_price_id
   AND cp.min_qty = 1;

-- 사후 검증
\echo '=== 원복 후 상태 (기대: 코롯토 comp/단가행/공식 0·A5 min_qty NULL 81 복귀) ==='
SELECT 'post_korotto_comp' k, count(*) FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_COROTTO';
SELECT 'post_korotto_rows' k, count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_COROTTO';
SELECT 'post_a5_null' k, count(*) FROM t_prc_component_prices cp JOIN _bk_a5 b ON b.comp_price_id=cp.comp_price_id WHERE cp.min_qty IS NULL;

-- 기본 = 롤백전용 검증. (실 원복 COMMIT 은 undo.sh --commit 이 ROLLBACK→COMMIT 치환)
ROLLBACK;
