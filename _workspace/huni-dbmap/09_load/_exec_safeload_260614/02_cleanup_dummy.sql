-- =====================================================================
-- 02_cleanup_dummy.sql — 테스트 더미 정리 (Tier A 인간 승인 큐 B·C)
--   우리 정식 옵션 레이어(OPT_/OPV_ 언더스코어)와 무관한 더미(OPT-/OPV- 하이픈·RULE_001).
--   B: 016 후가공 더미(grp OPT-000005 + opts OPV-000007~010 + items 7행) hard-delete
--      025 RULE_001(금지테스트) constraint hard-delete
--   C: 066 고아 OPV-000006(삭제된 그룹 OPT-000004 가리킴) soft-delete (hard-delete 금지)
--   라이브 실측(2026-06-14): 더미 전건 실재 확인 완료. 우리 정식 016 옵션그룹 4개와 공존(미충돌).
-- =====================================================================

-- ── B-1: 016 후가공 더미 (items → options → group 순, FK 역위상) ──
DELETE FROM t_prd_product_option_items
  WHERE prd_cd='PRD_000016' AND opt_cd IN ('OPV-000007','OPV-000008','OPV-000009','OPV-000010');
DELETE FROM t_prd_product_options
  WHERE prd_cd='PRD_000016' AND opt_cd IN ('OPV-000007','OPV-000008','OPV-000009','OPV-000010');
DELETE FROM t_prd_product_option_groups
  WHERE prd_cd='PRD_000016' AND opt_grp_cd='OPT-000005';

-- ── B-2: 025 RULE_001 금지테스트 constraint ──
DELETE FROM t_prd_product_constraints
  WHERE prd_cd='PRD_000025' AND rule_cd='RULE_001';

-- ── C: 066 고아 옵션 OPV-000006 soft-delete (삭제된 그룹 OPT-000004 가리키는 매달린 행) ──
UPDATE t_prd_product_options
  SET del_yn='Y', del_dt=now(), upd_dt=now(),
      note=COALESCE(note,'')||' [정리 2026-06-14: 삭제된 그룹 OPT-000004 고아 → 소프트삭제]'
WHERE prd_cd='PRD_000066' AND opt_cd='OPV-000006' AND opt_grp_cd='OPT-000004' AND del_yn='N';
