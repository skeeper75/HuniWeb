-- ═══════════════════════════════════════════════════════════════════════════
-- 088 면지 통합 재설계 — 트랜잭션 래핑 COMMIT본 (가드: 사후검증 통과 시에만 COMMIT)
-- apply-088.sql(8스텝·BEGIN/COMMIT 미내장)을 \i 인라인 → 사후 상태/FK/★USAGE.07 D링/티어 자체검증 → \if COMMIT
-- 게이트 S1~S8 GO + codex 합의(DISAGREE 0) + 인간 승인(082/088 마저 전파) 후 실행. 072/077/082 파일럿 동형.
-- ★★USAGE.07 D링자재(MAT_247/248/249) 불가침 — 가드가 활성 3 불변을 COMMIT 조건으로 강제.
-- ★★088-redesign-260702(089 표지·SSABARI·9,000 mint) 직교 — 본 apply 미터치.
-- ═══════════════════════════════════════════════════════════════════════════
\set ON_ERROR_STOP on
BEGIN;

\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/03_design/leather-hardcover-membrane-redesign-260703/088/apply-088.sql

-- ── 사후 자체검증 (한 트랜잭션 내) ────────────────────────────────────────────
-- 목표 상태: 090 자재4/옵션4/그룹1/아이템4 · 088 USAGE.03=0·OPT_067=0·sets=2(089표지+090면지)
--            091/092/093 use_yn=N · ★USAGE.07 D링자재 활성 3 불변 · FK 고아 0
--            셋트공식 COMP_HC_MUSEON_COVERBIND 티어 불변(t_prc_* 미변경 실증)
SELECT
  ( (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000090' AND usage_cd='USAGE.03' AND del_yn='N')=4
    AND (SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000090' AND opt_grp_cd='OPT_000067' AND del_yn='N')=1
    AND (SELECT count(*) FROM t_prd_product_options WHERE prd_cd='PRD_000090' AND opt_grp_cd='OPT_000067' AND del_yn='N')=4
    AND (SELECT count(*) FROM t_prd_product_option_items WHERE prd_cd='PRD_000090' AND opt_cd IN ('OPV_000444','OPV_000445','OPV_000446','OPV_000447') AND del_yn='N')=4
    AND (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000088' AND usage_cd='USAGE.03' AND del_yn='N')=0
    AND (SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000088' AND opt_grp_cd='OPT_000067' AND del_yn='N')=0
    AND (SELECT count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000088' AND del_yn='N')=2
    AND (SELECT count(*) FROM t_prd_products WHERE prd_cd IN ('PRD_000091','PRD_000092','PRD_000093') AND use_yn='Y')=0
    -- ★★USAGE.07 D링자재 불가침 (활성 3 불변)
    AND (SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000088' AND usage_cd='USAGE.07' AND mat_cd IN ('MAT_000247','MAT_000248','MAT_000249') AND del_yn='N')=3
    -- FK 고아 0
    AND (SELECT count(*) FROM t_prd_product_sets s LEFT JOIN t_prd_products p ON p.prd_cd=s.sub_prd_cd
           WHERE s.prd_cd='PRD_000088' AND s.del_yn='N' AND p.prd_cd IS NULL)=0
    -- 셋트공식 티어 불변 (COMP_HC_MUSEON_COVERBIND · 골든 관련 3티어)
    AND (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_HC_MUSEON_COVERBIND'
           AND ((min_qty=1 AND unit_price=34100.00) OR (min_qty=10 AND unit_price=15910.00) OR (min_qty=100 AND unit_price=7969.00)))=3
  ) AS all_ok
\gset

\if :all_ok
  \echo '>>> 사후검증 PASS (USAGE.07 D링 3 불변·티어 불변·FK 고아 0) — COMMIT'
  COMMIT;
\else
  \echo '>>> 사후검증 FAIL — ROLLBACK (라이브 무변경)'
  ROLLBACK;
\endif
