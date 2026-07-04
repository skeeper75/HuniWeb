-- ============================================================
-- 04  UNDO (백업 복원 · COMMIT 후 회귀가 필요할 때만)
--   전제: 01-backup.sql 을 COMMIT 직전 실행해 z_bak_mcmerge_* 3테이블 보유.
--   범위: 병합 COMMIT(9군 전체 또는 일부)을 백업 시점 상태로 되돌림.
--   ★ 백업 이후 라이브에 다른 변경이 있었다면 부분복원 위험 — 백업 신선도 확인 후 실행.
--   단일 트랜잭션. 기본 ROLLBACK(검증). 실제 복원은 맨 끝 COMMIT 으로 교체(인간 승인).
-- ============================================================
BEGIN;
SET LOCAL statement_timeout = '180s';

-- 백업 실재 하드체크 (없으면 중단)
DO $chk$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM information_schema.tables
   WHERE table_name IN ('z_bak_mcmerge_price_components','z_bak_mcmerge_component_prices','z_bak_mcmerge_formula_components');
  IF n<>3 THEN RAISE EXCEPTION 'UNDO 중단: 백업 테이블 %개(3 기대). 01-backup.sql 선행 필요.', n; END IF;
END $chk$;

-- [1] 단가행 comp_cd 원복 (정본→멤버, PK=comp_price_id 기준 백업값 복원)
UPDATE t_prc_component_prices p
   SET comp_cd = b.comp_cd, upd_dt = now()
  FROM z_bak_mcmerge_component_prices b
 WHERE p.comp_price_id = b.comp_price_id
   AND p.comp_cd <> b.comp_cd;

-- [2] formula_components 원복: 12 PRF 현행 전삭제 후 백업 재삽입 (정본배선 제거·멤버배선/disp_seq 복원)
DELETE FROM t_prc_formula_components
 WHERE frm_cd IN ('PRF_PCB_FIXED','PRF_NAMECARD_PREMIUM','PRF_NAMECARD_PREMIUM_FOIL','PRF_NAMECARD_FOIL',
   'PRF_NAMECARD_WHITE','PRF_NAMECARD_FIXED','PRF_NAMECARD_FIXED_FOIL','PRF_NAMECARD_COAT',
   'PRF_NAMECARD_PEARL','PRF_NAMECARD_PEARL_FOIL','PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE');
INSERT INTO t_prc_formula_components SELECT * FROM z_bak_mcmerge_formula_components;

-- [3] 멤버 26종 카탈로그 원복 (use_yn/del_yn/note/del_dt 복원)
UPDATE t_prc_price_components c
   SET use_yn=b.use_yn, del_yn=b.del_yn, note=b.note, del_dt=b.del_dt, upd_dt=now()
  FROM z_bak_mcmerge_price_components b
 WHERE c.comp_cd = b.comp_cd;

-- [4] 신규 mint 정본 9종 제거 (사전부재였으므로 물리삭제 안전 — 백업엔 없음)
DELETE FROM t_prc_price_components
 WHERE comp_cd IN ('COMP_PCB','COMP_NAMECARD_PREMIUM','COMP_NAMECARD_FOIL','COMP_NAMECARD_WHITE',
   'COMP_NAMECARD_STD','COMP_NAMECARD_COAT','COMP_NAMECARD_PEARL','COMP_NAMECARD_SHAPE','COMP_NAMECARD_MINISHAPE');

-- [검증] 원복 확인
SELECT 'UNDO 정본 잔존(0기대)' lbl, COUNT(*) FROM t_prc_price_components
 WHERE comp_cd IN ('COMP_PCB','COMP_NAMECARD_PREMIUM','COMP_NAMECARD_FOIL','COMP_NAMECARD_WHITE',
   'COMP_NAMECARD_STD','COMP_NAMECARD_COAT','COMP_NAMECARD_PEARL','COMP_NAMECARD_SHAPE','COMP_NAMECARD_MINISHAPE');
SELECT 'UNDO 멤버 use_yn=Y 복원(26기대)' lbl, COUNT(*) FROM t_prc_price_components c
 JOIN z_bak_mcmerge_price_components b USING(comp_cd) WHERE c.use_yn='Y';
SELECT 'UNDO 멤버 단가행 복원(913기대)' lbl, COUNT(*) FROM t_prc_component_prices p
 JOIN z_bak_mcmerge_component_prices b ON p.comp_price_id=b.comp_price_id WHERE p.comp_cd=b.comp_cd;
SELECT 'UNDO fc 원복(48기대)' lbl, COUNT(*) FROM t_prc_formula_components
 WHERE frm_cd IN ('PRF_PCB_FIXED','PRF_NAMECARD_PREMIUM','PRF_NAMECARD_PREMIUM_FOIL','PRF_NAMECARD_FOIL',
   'PRF_NAMECARD_WHITE','PRF_NAMECARD_FIXED','PRF_NAMECARD_FIXED_FOIL','PRF_NAMECARD_COAT',
   'PRF_NAMECARD_PEARL','PRF_NAMECARD_PEARL_FOIL','PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE');

ROLLBACK;  -- 검증 전용. 실제 복원은 COMMIT 으로 교체(인간 승인).
