-- _dryrun_verify.sql — 라이브 롤백전용 DRY-RUN 2-pass 멱등·불변·잔존0 실증 (검증 전용, 미커밋).
-- 로더가 BEGIN; ... ; ROLLBACK 으로 감싼다. note 컬럼만 변경. 가격행 불변.
\set ON_ERROR_STOP on

-- 정정 전 기준값 — 단가행 가격/축 무결성 지문 + 정의행 prc_typ 분포
\echo '=== 정정 전 단가행 가격/축 지문 + 정의행 prc_typ 분포 ==='
SELECT 'cp_fingerprint_before' AS k,
  (sum(unit_price)::text||'|'||sum(coalesce(bdl_qty,0))::text||'|'||sum(coalesce(min_qty,0))::text
   ||'|'||md5(string_agg(coalesce(siz_cd,'')||coalesce(clr_cd,'')||coalesce(mat_cd,'')||coalesce(proc_cd,'')||coalesce(opt_cd,'')||coalesce(apply_ymd::text,''), ',' ORDER BY comp_price_id))) AS v
  FROM t_prc_component_prices
UNION ALL SELECT 'pc_prctyp_dist_before', string_agg(prc_typ_cd||':'||c, ', ' ORDER BY prc_typ_cd)
  FROM (SELECT prc_typ_cd, count(*) c FROM t_prc_price_components GROUP BY prc_typ_cd) t;

-- PASS 1 — psql이 각 UPDATE 문마다 'UPDATE N' 을 출력(권위적 변경 행수)
\echo '=== PASS1 (각 UPDATE N = 실변경 행수) ==='
\i 01_update_notes.sql

-- PASS1 후 note 전역 지문 (PASS2 멱등 비교용)
\echo '=== PASS1 후 note 전역 지문 ==='
SELECT 'note_md5_after_pass1' AS k,
  md5( (SELECT string_agg(coalesce(note,''), '|' ORDER BY comp_cd) FROM t_prc_price_components)
    || (SELECT string_agg(coalesce(note,''), '|' ORDER BY comp_price_id) FROM t_prc_component_prices) ) AS v;

-- 정정 후 가격 불변 검사 (지문이 before와 동일해야 함 = note 외 컬럼 불변)
\echo '=== 정정 후 단가행 지문 + 정의행 prc_typ 분포 (before와 동일해야 함) ==='
SELECT 'cp_fingerprint_after' AS k,
  (sum(unit_price)::text||'|'||sum(coalesce(bdl_qty,0))::text||'|'||sum(coalesce(min_qty,0))::text
   ||'|'||md5(string_agg(coalesce(siz_cd,'')||coalesce(clr_cd,'')||coalesce(mat_cd,'')||coalesce(proc_cd,'')||coalesce(opt_cd,'')||coalesce(apply_ymd::text,''), ',' ORDER BY comp_price_id))) AS v
  FROM t_prc_component_prices
UNION ALL SELECT 'pc_prctyp_dist_after', string_agg(prc_typ_cd||':'||c, ', ' ORDER BY prc_typ_cd)
  FROM (SELECT prc_typ_cd, count(*) c FROM t_prc_price_components GROUP BY prc_typ_cd) t;

-- 전역 전문용어 잔존 (FLAG_UNCLEAR 제외 — 본 번들엔 0건)
\echo '=== PASS1 후 전역 전문용어 잔존 (0 기대) ==='
SELECT 'comp_jargon_left' AS k, count(*)::text FROM t_prc_price_components
  WHERE note ~ 'siz-corrected|comp_typ|PRC_COMPONENT_TYPE|round-2|clr=NULL|별색=공정|옵션=comp흡수|SIZ_[0-9]|MAT_[0-9]|PROC_[0-9]|mat_cd|siz_cd|C-[0-9]|≥'
UNION ALL SELECT 'cp_jargon_left', count(*)::text FROM t_prc_component_prices
  WHERE note ~ 'siz-corrected|comp_typ|PRC_COMPONENT_TYPE|round-2|clr=NULL|별색=공정|옵션=comp흡수|SIZ_[0-9]|MAT_[0-9]|PROC_[0-9]|mat_cd|siz_cd|C-[0-9]|≥';

-- PASS 2 (멱등) — 같은 스크립트 재실행. 모든 UPDATE N = 0 기대.
\echo '=== PASS2 (멱등 재실행 — 모든 UPDATE 0 기대) ==='
\i 01_update_notes.sql
\echo '=== PASS2 후 note 전역 지문 (PASS1 후와 동일 = delta 0) ==='
SELECT 'note_md5_after_pass2' AS k,
  md5( (SELECT string_agg(coalesce(note,''), '|' ORDER BY comp_cd) FROM t_prc_price_components)
    || (SELECT string_agg(coalesce(note,''), '|' ORDER BY comp_price_id) FROM t_prc_component_prices) ) AS v;

\echo '=== 교정 예시 6종 (롤백 전, 트랜잭션 내) ==='
SELECT comp_cd, left(note,80) FROM t_prc_price_components WHERE comp_cd IN
  ('COMP_ACRYL_CLEAR15T','COMP_BIND_JUNGCHEOL','COMP_NAMECARD_STD_S1','COMP_TTEOKME','COMP_POSTER_BANNER_NORMAL','COMP_ENV_MAKING')
  ORDER BY comp_cd;
