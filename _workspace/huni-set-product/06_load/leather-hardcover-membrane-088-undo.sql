-- ═══════════════════════════════════════════════════════════════════════════
-- 088 면지 통합 재설계 — 롤백(undo) · apply-088.sql 역순 복원
-- 라이브 이전상태(2026-07-03 실측): 면지 4멤버(090/091/092/093) + 부모 OPT_067(화/블/그/인쇄)
--   + 부모 USAGE.03 자재 382/383/384/385. ★USAGE.07 D링(247/248/249)은 apply가 미터치 → undo도 미터치.
-- 트랜잭션 래핑은 load-executor. 090에 자재/옵션이 남으면 무해하나 이전상태로 완전 환원.
-- ═══════════════════════════════════════════════════════════════════════════

-- [8b→] 은퇴 멤버 상품마스터 use_yn 복원
UPDATE t_prd_products SET use_yn='Y', upd_dt=now()
 WHERE prd_cd IN ('PRD_000091','PRD_000092','PRD_000093');
-- [8→] 면지 멤버 091/092/093 셋트 링크 복원
UPDATE t_prd_product_sets SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000088' AND sub_prd_cd IN ('PRD_000091','PRD_000092','PRD_000093');

-- [7→] 부모 088 면지자재(USAGE.03) 복원 (USAGE.07 D링은 미터치)
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000088'
   AND mat_cd IN ('MAT_000382','MAT_000383','MAT_000384','MAT_000385') AND usage_cd='USAGE.03';

-- [6→] 부모 088 면지색 옵션 복원 : group → options → items 순
UPDATE t_prd_product_option_groups SET del_yn='N', use_yn='Y', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000088' AND opt_grp_cd='OPT_000067';
UPDATE t_prd_product_options SET del_yn='N', use_yn='Y', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000088' AND opt_grp_cd='OPT_000067';
UPDATE t_prd_product_option_items SET del_yn='N', use_yn='Y', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000088' AND opt_cd IN ('OPV_000444','OPV_000445','OPV_000446','OPV_000447');

-- [5→][4→][3→] 090로 이관분 제거(이전엔 없었음) — 물리 delete(신규 삽입분이므로 안전)
DELETE FROM t_prd_product_option_items
 WHERE prd_cd='PRD_000090' AND opt_cd IN ('OPV_000444','OPV_000445','OPV_000446','OPV_000447');
DELETE FROM t_prd_product_options
 WHERE prd_cd='PRD_000090' AND opt_grp_cd='OPT_000067';
DELETE FROM t_prd_product_option_groups
 WHERE prd_cd='PRD_000090' AND opt_grp_cd='OPT_000067';

-- [2→] 090 이관 자재 제거(이전엔 없었음)
DELETE FROM t_prd_product_materials
 WHERE prd_cd='PRD_000090'
   AND mat_cd IN ('MAT_000382','MAT_000383','MAT_000384','MAT_000385') AND usage_cd='USAGE.03';

-- [1→] 090 리네이밍 복원
UPDATE t_prd_products SET prd_nm='레더 링바인더-면지(화이트면지)', upd_dt=now()
 WHERE prd_cd='PRD_000090';
