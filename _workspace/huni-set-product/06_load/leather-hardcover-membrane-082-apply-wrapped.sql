-- ═══════════════════════════════════════════════════════════════════════════
-- 082 면지 통합 재설계 — 트랜잭션 래핑 COMMIT본 (가드: 사후검증 통과 시에만 COMMIT)
-- apply-082.sql(8스텝·BEGIN/COMMIT 미내장)을 \i 인라인 → 사후 상태/FK/★USAGE.07/티어 자체검증 → \if COMMIT
-- 게이트 S1~S8 GO + codex 합의(DISAGREE 0) + 인간 승인(082/088 마저 전파) 후 실행. 072/077 파일럿 동형.
-- ★★USAGE.07 링자재(MAT_013/014/015) 불가침 — 가드가 활성 3 불변을 COMMIT 조건으로 강제.
-- ═══════════════════════════════════════════════════════════════════════════
\set ON_ERROR_STOP on
BEGIN;

\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/leather-hardcover-membrane-redesign-260703/082/apply-082.sql

-- ── 사후 자체검증 (한 트랜잭션 내) ────────────────────────────────────────────
-- 목표 상태: 084 자재4/옵션4/그룹1/아이템4 · 082 USAGE.03=0·OPT_066=0·sets=3
--            085/086/087 use_yn=N · ★USAGE.07 링자재 활성 3 불변 · FK 고아 0
--            셋트공식 COMP_BIND_HC_TWINRING 티어 불변(t_prc_* 미변경 실증)
SELECT
  ( (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000084' AND usage_cd='USAGE.03' AND del_yn='N')=4
    AND (SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000084' AND opt_grp_cd='OPT_000066' AND del_yn='N')=1
    AND (SELECT count(*) FROM t_prd_product_options WHERE prd_cd='PRD_000084' AND opt_grp_cd='OPT_000066' AND del_yn='N')=4
    AND (SELECT count(*) FROM t_prd_product_option_items WHERE prd_cd='PRD_000084' AND opt_cd IN ('OPV_000440','OPV_000441','OPV_000442','OPV_000443') AND del_yn='N')=4
    AND (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000082' AND usage_cd='USAGE.03' AND del_yn='N')=0
    AND (SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000082' AND opt_grp_cd='OPT_000066' AND del_yn='N')=0
    AND (SELECT count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000082' AND del_yn='N')=3
    AND (SELECT count(*) FROM t_prd_products WHERE prd_cd IN ('PRD_000085','PRD_000086','PRD_000087') AND use_yn='Y')=0
    -- ★★USAGE.07 링자재 불가침 (활성 3 불변)
    AND (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000082' AND usage_cd='USAGE.07' AND mat_cd IN ('MAT_000013','MAT_000014','MAT_000015') AND del_yn='N')=3
    -- FK 고아 0
    AND (SELECT count(*) FROM t_prd_product_sets s LEFT JOIN t_prd_products p ON p.prd_cd=s.sub_prd_cd
           WHERE s.prd_cd='PRD_000082' AND s.del_yn='N' AND p.prd_cd IS NULL)=0
    -- 셋트공식 티어 불변 (COMP_BIND_HC_TWINRING · 100→8000 등 3티어)
    AND (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_BIND_HC_TWINRING'
           AND ((min_qty=1 AND unit_price=30000.00) OR (min_qty=100 AND unit_price=8000.00) OR (min_qty=1000 AND unit_price=7000.00)))=3
  ) AS all_ok
\gset

\if :all_ok
  \echo '>>> 사후검증 PASS (USAGE.07 링 3 불변·티어 불변·FK 고아 0) — COMMIT'
  COMMIT;
\else
  \echo '>>> 사후검증 FAIL — ROLLBACK (라이브 무변경)'
  ROLLBACK;
\endif
