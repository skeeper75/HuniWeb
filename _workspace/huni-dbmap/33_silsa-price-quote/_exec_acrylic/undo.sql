-- undo.sql — 아크릴 가로/세로 구간 동형 전환(A1~A3+AW) 실 COMMIT 원복. 단일 트랜잭션·기본 ROLLBACK.
-- [HARD] 실 COMMIT 이 적용된 뒤에만 의미. apply.sh --commit 으로 적재한 변경을 백업 3종 CSV 기준으로 되돌린다.
-- [HARD] 기본 ROLLBACK(아래). 실 원복 COMMIT 은 undo.sh --commit 으로만(인간 승인).
-- 원복 권위 = backup_comp_prices_pre.csv(121행·전환 전 siz_cd 보유) · backup_use_dims_pre.csv(2) · backup_wiring_pre.csv(1).
-- 과삭제 0 보장: A2 신규 삭제는 "백업 CSV에 없던 comp_price_id" 만 — 백업을 임시테이블에 적재해 정확 대조.
\set ON_ERROR_STOP on
BEGIN;

-- 백업을 임시테이블로 적재(원복 권위·과삭제 가드의 기준 집합)
CREATE TEMP TABLE _bk_cp (
  comp_price_id bigint, comp_cd text, siz_cd text,
  siz_width numeric, siz_height numeric, mat_cd text, min_qty integer, unit_price numeric
);
\copy _bk_cp FROM 'backup_comp_prices_pre.csv' WITH CSV HEADER

-- 사전 가드: 백업 121행 = 아크릴 본체 매트릭스 2 comp 전건, 전환 전 siz_cd 보유 확인
DO $$
DECLARE n int; n_nosiz int;
BEGIN
  SELECT count(*) INTO n FROM _bk_cp WHERE comp_cd IN ('COMP_ACRYL_CLEAR3T','COMP_ACRYL_MIRROR3T');
  SELECT count(*) INTO n_nosiz FROM _bk_cp WHERE siz_cd IS NULL OR siz_cd='';
  IF n <> 121 THEN RAISE EXCEPTION 'backup comp_prices rows expected 121, got %', n; END IF;
  IF n_nosiz <> 0 THEN RAISE EXCEPTION 'backup has % rows without siz_cd (전환 전 스냅샷 아님)', n_nosiz; END IF;
END $$;

-- ============================================================
-- A2 원복 (먼저: 신규 INSERT 96 삭제) — 과삭제 0
--   삭제 대상 = 아크릴 본체 2 comp 중 백업 comp_price_id 집합에 없던 행(=A2가 INSERT한 신규).
--   추가 안전: siz_width NOT NULL & siz_cd NULL & apply_ymd='2026-06-01'(GAP 적재 형상)으로 이중 한정.
-- ============================================================
\echo '=== A2 원복: GAP 신규 INSERT 96 삭제 (백업에 없던 comp_price_id만) ==='
DELETE FROM t_prc_component_prices cp
 WHERE cp.comp_cd IN ('COMP_ACRYL_CLEAR3T','COMP_ACRYL_MIRROR3T')
   AND cp.siz_cd IS NULL AND cp.siz_width IS NOT NULL
   AND cp.apply_ymd = '2026-06-01'
   AND NOT EXISTS (SELECT 1 FROM _bk_cp b WHERE b.comp_price_id = cp.comp_price_id);

-- ============================================================
-- A1 원복 (전환 121행: siz_width/siz_height → NULL, siz_cd 복원)
--   백업 comp_price_id 기준 전환 전 siz_cd 복원. unit_price/mat_cd 불변(전환이 안 건드림).
--   멱등: siz_width IS NOT NULL & siz_cd IS NULL 인 백업행만 복원(이미 원복됐으면 0행).
-- ============================================================
\echo '=== A1 원복: 전환 121행 siz_width/height NULL·siz_cd 복원 ==='
UPDATE t_prc_component_prices cp
   SET siz_cd = b.siz_cd, siz_width = NULL, siz_height = NULL, upd_dt = now()
  FROM _bk_cp b
 WHERE cp.comp_price_id = b.comp_price_id
   AND cp.comp_cd IN ('COMP_ACRYL_CLEAR3T','COMP_ACRYL_MIRROR3T')
   AND cp.siz_cd IS NULL AND cp.siz_width IS NOT NULL;

-- ============================================================
-- A3 원복 (use_dims 2 comp → [siz_cd ...] 백업값)
--   멱등: 현재 use_dims @> [siz_width] 인 행만(이미 원복됐으면 0행).
-- ============================================================
\echo '=== A3 원복: use_dims [siz_cd ...] 복원 ==='
UPDATE t_prc_price_components
   SET use_dims = '["siz_cd", "mat_cd", "min_qty"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_ACRYL_CLEAR3T' AND use_dims @> '["siz_width"]'::jsonb;
UPDATE t_prc_price_components
   SET use_dims = '["siz_cd", "mat_cd"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_ACRYL_MIRROR3T' AND use_dims @> '["siz_width"]'::jsonb;

-- ============================================================
-- AW 원복 (배선 disp_seq/addtn_yn → NULL)
--   멱등: disp_seq IS NOT NULL OR addtn_yn IS NOT NULL 인 행만.
-- ============================================================
\echo '=== AW 원복: PRF_CLR_ACRYL→CLEAR3T 배선 disp_seq/addtn_yn NULL 원복 ==='
UPDATE t_prc_formula_components
   SET disp_seq = NULL, addtn_yn = NULL
 WHERE frm_cd = 'PRF_CLR_ACRYL' AND comp_cd = 'COMP_ACRYL_CLEAR3T'
   AND (disp_seq IS NOT NULL OR addtn_yn IS NOT NULL);

-- 사후 검증: 원복 후 아크릴 본체 단가행 = 121(siz_cd 전건)·신규 0
\echo '=== 원복 후 상태 (기대: total 121·siz_cd 121·siz_width 0) ==='
SELECT 'post_total' k, count(*) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_ACRYL_CLEAR3T','COMP_ACRYL_MIRROR3T');
SELECT 'post_sizcd' k, count(*) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_ACRYL_CLEAR3T','COMP_ACRYL_MIRROR3T') AND siz_cd IS NOT NULL;
SELECT 'post_wh' k, count(*) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_ACRYL_CLEAR3T','COMP_ACRYL_MIRROR3T') AND siz_width IS NOT NULL;

-- 기본 = 롤백전용 검증. (실 원복 COMMIT 은 undo.sh --commit 이 ROLLBACK→COMMIT 치환)
ROLLBACK;
