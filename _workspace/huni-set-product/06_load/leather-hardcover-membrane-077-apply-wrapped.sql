-- ═══════════════════════════════════════════════════════════════════════════
-- 077 면지 통합 재설계 — 트랜잭션 래핑 COMMIT본 (가드: 사후검증 통과 시에만 COMMIT)
-- apply-077.sql(8스텝·BEGIN/COMMIT 미내장)을 \i 인라인 → 사후 골든/카운트/FK 자체검증 → \if COMMIT
-- 게이트 S1~S8 GO + codex 합의(072 per-set 전파 4항 독립재실측 CLOSE) + 인간 승인(077) 후 실행.
-- 072 파일럿 동형 전파.
-- ═══════════════════════════════════════════════════════════════════════════
\set ON_ERROR_STOP on
BEGIN;

\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/leather-hardcover-membrane-redesign-260703/077/apply-077.sql

-- ── 사후 자체검증 (한 트랜잭션 내) ────────────────────────────────────────────
-- 목표 상태: 079 자재3/옵션3/그룹1/아이템3 · 077 USAGE.03=0·OPT_065=0·sets=3 · 080/081 use_yn=N
-- 골든 원자: COVERBIND 티어 불변(1/10/100 → 34100/15910/7969) · FK 고아 0
SELECT
  ( (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000079' AND usage_cd='USAGE.03' AND del_yn='N')=3
    AND (SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000079' AND opt_grp_cd='OPT_000065' AND del_yn='N')=1
    AND (SELECT count(*) FROM t_prd_product_options WHERE prd_cd='PRD_000079' AND opt_grp_cd='OPT_000065' AND del_yn='N')=3
    AND (SELECT count(*) FROM t_prd_product_option_items WHERE prd_cd='PRD_000079' AND opt_cd IN ('OPV_000437','OPV_000438','OPV_000439') AND del_yn='N')=3
    AND (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000077' AND usage_cd='USAGE.03' AND del_yn='N')=0
    AND (SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000077' AND opt_grp_cd='OPT_000065' AND del_yn='N')=0
    AND (SELECT count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000077' AND del_yn='N')=3
    AND (SELECT count(*) FROM t_prd_products WHERE prd_cd IN ('PRD_000080','PRD_000081') AND use_yn='Y')=0
    AND (SELECT count(*) FROM t_prd_product_sets s LEFT JOIN t_prd_products p ON p.prd_cd=s.sub_prd_cd
           WHERE s.prd_cd='PRD_000077' AND s.del_yn='N' AND p.prd_cd IS NULL)=0
    AND (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd LIKE '%HC_MUSEON_COVERBIND%'
           AND ((min_qty=1 AND unit_price=34100.00) OR (min_qty=10 AND unit_price=15910.00) OR (min_qty=100 AND unit_price=7969.00)))=3
  ) AS all_ok
\gset

\if :all_ok
  \echo '>>> 사후검증 PASS — COMMIT'
  COMMIT;
\else
  \echo '>>> 사후검증 FAIL — ROLLBACK (라이브 무변경)'
  ROLLBACK;
\endif
