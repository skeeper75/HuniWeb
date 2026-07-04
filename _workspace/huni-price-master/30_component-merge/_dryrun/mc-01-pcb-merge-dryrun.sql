-- ============================================================
-- MC-01  엽서북 PCB 병합 DRY-RUN (ROLLBACK 전용 · COMMIT 아님 · 멱등)
-- ★특수상황: 라이브가 이미 2026-07-03 IN-PLACE 병합됨(스냅샷 2026-07-02 이후 변동).
--   현재 라이브: COMP_PCB_S1_20P 가 전 격자 468행(4콤보×117) 보유 · use_dims·comp_nm 갱신됨
--   · PRF_PCB_FIXED 는 COMP_PCB_S1_20P 만 배선(disp_seq=1) · 나머지 3 멤버는 고아(배선 0)·중복데이터.
--   → 이중합산 없음(공식이 정본 1개만 배선). 잔여작업 = ① 정본명 규칙 정합(_S1_20P → COMP_PCB 재명명)
--     ② 고아 3멤버 논리삭제.  단가행 재이관은 S1_20P(468행·내부 nat_key 유일) 1건만 → 0 충돌.
-- 실 적용은 인간 승인 후 별도 단계(ROLLBACK → COMMIT).
-- ============================================================
BEGIN;

-- [가드0] S1_20P(정본데이터) 를 COMP_PCB 로 옮길 때 nat_key 충돌 사전검증(0 기대):
WITH moved AS (
  SELECT (apply_ymd,siz_cd,plt_siz_cd,clr_cd,mat_cd,proc_cd,opt_cd,print_opt_cd,coat_side_cnt,bdl_qty,siz_width,siz_height,min_qty,COALESCE(dim_vals,'{}'::jsonb)::text) k
  FROM t_prc_component_prices WHERE comp_cd='COMP_PCB_S1_20P')
SELECT '가드0 nat_key 충돌수(0 기대)' lbl, COUNT(*)-COUNT(DISTINCT k) collisions FROM moved;
-- 고아 3멤버는 재이관하지 않음(데이터가 S1_20P 안에 이미 존재하는 중복본) — 논리삭제만.

-- [1] 정본 COMP_PCB 확정(멱등). comp_nm/use_dims 는 라이브 S1_20P 것 승계(이미 병합 반영됨).
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn, prc_typ_cd, use_dims, del_yn, reg_dt)
VALUES ('COMP_PCB', '엽서북 완제품가 사이즈/양단면/페이지수별 단가', 'PRC_COMPONENT_TYPE.06',
  '엽서북 완제품가. 인쇄면·페이지수·수량별 1권당 단가표. [차원통합] 통합축=print_opt_cd(면)·opt_cd(페이지)', 'Y',
  'PRICE_TYPE.01', '["siz_cd", "print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000082"]', 'N', now())
ON CONFLICT (comp_cd) DO UPDATE SET comp_nm=EXCLUDED.comp_nm, comp_typ_cd=EXCLUDED.comp_typ_cd,
  note=EXCLUDED.note, use_yn='Y', prc_typ_cd=EXCLUDED.prc_typ_cd, use_dims=EXCLUDED.use_dims, del_yn='N', upd_dt=now();

-- [2] 단가행 이관: S1_20P(468행·전 격자·verbatim 불변) → COMP_PCB. 고아 3멤버는 이관 제외(중복본).
UPDATE t_prc_component_prices SET comp_cd='COMP_PCB', upd_dt=now()
 WHERE comp_cd='COMP_PCB_S1_20P';
--   기대 이관 = 468 (재실행 시 0 = 멱등)

-- [3] formula_components 재배선: PRF_PCB_FIXED 의 S1_20P → COMP_PCB
DELETE FROM t_prc_formula_components WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S1_30P','COMP_PCB_S2_20P','COMP_PCB_S2_30P');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_PCB_FIXED','COMP_PCB',1,'Y',now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now();

-- [4] 멤버 4종 논리삭제(hard-delete 금지). S1_20P=정본으로 승격됐으므로 tombstone,
--     고아 3멤버(S1_30P/S2_20P/S2_30P)=중복데이터 보유한 채 논리삭제(rows 는 물리보존).
UPDATE t_prc_price_components SET use_yn='N', del_yn='Y', del_dt=now(),
  note='[차원통합→COMP_PCB]', upd_dt=now()
 WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S1_30P','COMP_PCB_S2_20P','COMP_PCB_S2_30P');

-- [검증] 오염가드
SELECT 'PRF_PCB_FIXED 배선' lbl, string_agg(comp_cd||':'||disp_seq, ', ' ORDER BY disp_seq) FROM t_prc_formula_components WHERE frm_cd='PRF_PCB_FIXED';
SELECT '멤버 잔존배선(0기대)' lbl, COUNT(*) FROM t_prc_formula_components WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S1_30P','COMP_PCB_S2_20P','COMP_PCB_S2_30P');
SELECT '정본 COMP_PCB 단가행수(468기대)' lbl, COUNT(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PCB';
-- 참고: 고아 3멤버(S1_30P/S2_20P/S2_30P)는 각 117행 중복본이 tombstone 으로 남음(무참조·무해).
SELECT '고아3멤버 잔존행(중복본·무참조)' lbl, comp_cd, COUNT(*) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_PCB_S1_30P','COMP_PCB_S2_20P','COMP_PCB_S2_30P') GROUP BY comp_cd;

ROLLBACK;  -- DRY-RUN: 영속화 없음. 실 적용은 인간 승인 후 COMMIT 으로 교체.
