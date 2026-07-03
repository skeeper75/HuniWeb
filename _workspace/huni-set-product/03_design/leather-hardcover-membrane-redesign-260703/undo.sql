-- ═══════════════════════════════════════════════════════════════════════════
-- 072 면지 통합 재설계 — 롤백(undo) · apply.sql 역순 복원
-- 라이브 이전상태(2026-07-03 실측): 면지 3멤버(074/075/076) + 부모 OPT_064 + 부모 자재 382/383/384.
-- 트랜잭션 래핑은 load-executor. 자재/옵션이 074에 남으면 무해하나 이전상태로 완전 환원.
-- ═══════════════════════════════════════════════════════════════════════════

-- [8b→] 은퇴 멤버 상품마스터 use_yn 복원
UPDATE t_prd_products SET use_yn='Y', upd_dt=now()
 WHERE prd_cd IN ('PRD_000075','PRD_000076');
-- [8→] 면지 멤버 075/076 셋트 링크 복원
UPDATE t_prd_product_sets SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000072' AND sub_prd_cd IN ('PRD_000075','PRD_000076');

-- [7→] 부모 072 면지자재 복원
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000072' AND mat_cd IN ('MAT_000382','MAT_000383','MAT_000384') AND usage_cd='USAGE.03';

-- [6→] 부모 072 면지색 옵션 복원 : group → options → items 순
UPDATE t_prd_product_option_groups SET del_yn='N', use_yn='Y', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000072' AND opt_grp_cd='OPT_000064';
UPDATE t_prd_product_options SET del_yn='N', use_yn='Y', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000072' AND opt_grp_cd='OPT_000064';
UPDATE t_prd_product_option_items SET del_yn='N', use_yn='Y', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000072' AND opt_cd IN ('OPV_000434','OPV_000435','OPV_000436');

-- [5→][4→][3→] 074로 이관분 제거(이전엔 없었음) — 물리 delete(신규 삽입분이므로 안전)
DELETE FROM t_prd_product_option_items
 WHERE prd_cd='PRD_000074' AND opt_cd IN ('OPV_000434','OPV_000435','OPV_000436');
DELETE FROM t_prd_product_options
 WHERE prd_cd='PRD_000074' AND opt_grp_cd='OPT_000064';
DELETE FROM t_prd_product_option_groups
 WHERE prd_cd='PRD_000074' AND opt_grp_cd='OPT_000064';

-- [2→] 074 이관 자재 제거(이전엔 없었음)
DELETE FROM t_prd_product_materials
 WHERE prd_cd='PRD_000074' AND mat_cd IN ('MAT_000382','MAT_000383','MAT_000384') AND usage_cd='USAGE.03';

-- [1→] 074 리네이밍 복원
UPDATE t_prd_products SET prd_nm='하드커버책자-면지(화이트면지)', upd_dt=now()
 WHERE prd_cd='PRD_000074';

-- [선택블록→] 내지 개수필드 복원(선택블록 활성화했을 때만)
-- UPDATE t_prd_product_sets SET min_cnt=24, max_cnt=300, cnt_incr=2, upd_dt=now()
--  WHERE prd_cd='PRD_000072' AND sub_prd_cd='PRD_000284';
