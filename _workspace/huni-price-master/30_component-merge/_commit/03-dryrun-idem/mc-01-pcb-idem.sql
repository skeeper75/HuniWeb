\set ON_ERROR_STOP on
-- 멱등 실증(롤백전용): mc-01-pcb 본문 2회 적용 후 ROLLBACK. 게이트 RAISE 시 즉시 abort(비0 종료).
BEGIN;
\echo '=== mc-01-pcb PASS 1 ==='
SET LOCAL statement_timeout = '120s';

-- ===== 사전 게이트 하드어서션 (★MC-01 시점종속 언더차지 방어) =====
DO $gate$
DECLARE v_canon_pre int; v_transfer_price int; v_s120p int; v_collisions int;
BEGIN
  -- ★★★ MC-01 halt 게이트: 안전상태만 통과 — 스냅샷상태(각117) 회귀 시 언더차지 즉시중단.
  --   안전상태 = (첫실행: S1_20P=468) OR (이미적용: COMP_PCB=468 AND S1_20P=0). 그 외(예 S1_20P=117) = HALT.
  SELECT count(*) INTO v_s120p    FROM t_prc_component_prices WHERE comp_cd='COMP_PCB_S1_20P';
  SELECT count(*) INTO v_canon_pre FROM t_prc_component_prices WHERE comp_cd='COMP_PCB';
  IF NOT (v_s120p=468 OR (v_canon_pre=468 AND v_s120p=0)) THEN
    RAISE EXCEPTION '★MC-01 HALT: COMP_PCB_S1_20P=%건·COMP_PCB=%건. 안전상태(S1_20P=468 또는 이미적용 COMP_PCB=468&S1_20P=0) 아님 → 07-02 스냅샷(각117) 회귀 의심·즉시중단(부분이관 언더차지 방어).', v_s120p, v_canon_pre;
  END IF;
  -- 게이트① 혼재 0 (정본이 단가행 보유 AND S1_20P도 잔존 = 반쯤적용)
  SELECT count(*) INTO v_transfer_price FROM t_prc_component_prices WHERE comp_cd IN ('COMP_PCB_S1_20P');
  IF v_canon_pre>0 AND v_transfer_price>0 THEN
    RAISE EXCEPTION '게이트① 혼재중단: 정본 COMP_PCB 단가행 %건 + S1_20P %건 동시존재.', v_canon_pre, v_transfer_price;
  END IF;
  -- 게이트③ nat_key 충돌 0 (S1_20P 내부·이관 대상만)
  SELECT count(*)-count(DISTINCT (apply_ymd,siz_cd,plt_siz_cd,clr_cd,mat_cd,proc_cd,opt_cd,print_opt_cd,coat_side_cnt,bdl_qty,siz_width,siz_height,min_qty,COALESCE(dim_vals,'{}'::jsonb)::text)) INTO v_collisions
    FROM t_prc_component_prices WHERE comp_cd IN ('COMP_PCB_S1_20P');
  IF v_collisions<>0 THEN RAISE EXCEPTION '게이트③ nat_key 충돌 %건(0 기대) → 중단.', v_collisions; END IF;
END $gate$;

-- [1] 정본 COMP_PCB 확정 (멱등 UPSERT·라이브 S1_20P 것 승계)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn, prc_typ_cd, use_dims, del_yn, reg_dt)
VALUES ('COMP_PCB', '엽서북 완제품가 사이즈/양단면/페이지수별 단가', 'PRC_COMPONENT_TYPE.06', '엽서북 완제품가. 인쇄면·페이지수·수량별 1권당 단가표. [차원통합] 통합축=print_opt_cd(면)·opt_cd(페이지)', 'Y', 'PRICE_TYPE.01', '["siz_cd", "print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000082"]', 'N', now())
ON CONFLICT (comp_cd) DO UPDATE SET comp_nm=EXCLUDED.comp_nm, comp_typ_cd=EXCLUDED.comp_typ_cd,
  note=EXCLUDED.note, use_yn='Y', prc_typ_cd=EXCLUDED.prc_typ_cd, use_dims=EXCLUDED.use_dims, del_yn='N', upd_dt=now();

-- [2] 단가행 이관: S1_20P(468·전격자·verbatim) → COMP_PCB. 고아 3멤버는 미이관(중복본).
UPDATE t_prc_component_prices SET comp_cd='COMP_PCB', upd_dt=now() WHERE comp_cd IN ('COMP_PCB_S1_20P');

-- [3] formula_components 재배선: PRF_PCB_FIXED → COMP_PCB seq1 (멤버 4종 배선 DELETE)
DELETE FROM t_prc_formula_components WHERE comp_cd IN ('COMP_PCB_S1_20P', 'COMP_PCB_S1_30P', 'COMP_PCB_S2_20P', 'COMP_PCB_S2_30P');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_PCB_FIXED', 'COMP_PCB', 1, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now();

-- [4] 멤버 4종 논리삭제(S1_20P 포함·정본 승격 후 tombstone. 고아 3멤버 중복행 물리보존·무참조)
UPDATE t_prc_price_components SET use_yn='N', del_yn='Y', del_dt=now(),
  note='[차원통합→COMP_PCB]', upd_dt=now() WHERE comp_cd IN ('COMP_PCB_S1_20P', 'COMP_PCB_S1_30P', 'COMP_PCB_S2_20P', 'COMP_PCB_S2_30P');

-- ===== 사후 게이트 하드어서션 =====
DO $post$
DECLARE v_member_fc int; v_canon_rows int; v_transfer_price int; v_dup int;
BEGIN
  -- 게이트② 멤버(4종) fc 참조 0
  SELECT count(*) INTO v_member_fc FROM t_prc_formula_components WHERE comp_cd IN ('COMP_PCB_S1_20P', 'COMP_PCB_S1_30P', 'COMP_PCB_S2_20P', 'COMP_PCB_S2_30P');
  IF v_member_fc<>0 THEN RAISE EXCEPTION '게이트② 멤버 fc참조 %건(0 기대) → 중단.', v_member_fc; END IF;
  -- 구조적 골든 등가①: 정본 단가행수 == 468
  SELECT count(*) INTO v_canon_rows FROM t_prc_component_prices WHERE comp_cd='COMP_PCB';
  IF v_canon_rows<>468 THEN RAISE EXCEPTION '정본 COMP_PCB 단가행수 %건(기대 468) → 중단.', v_canon_rows; END IF;
  -- S1_20P(이관원) 잔존 단가행 0
  SELECT count(*) INTO v_transfer_price FROM t_prc_component_prices WHERE comp_cd IN ('COMP_PCB_S1_20P');
  IF v_transfer_price<>0 THEN RAISE EXCEPTION 'S1_20P 잔존 단가행 %건(0 기대) → 중단.', v_transfer_price; END IF;
  -- 구조적 골든 등가②: 정본 내부 nat_key 유일(0 중복)
  SELECT count(*)-count(DISTINCT (apply_ymd,siz_cd,plt_siz_cd,clr_cd,mat_cd,proc_cd,opt_cd,print_opt_cd,coat_side_cnt,bdl_qty,siz_width,siz_height,min_qty,COALESCE(dim_vals,'{}'::jsonb)::text)) INTO v_dup
    FROM t_prc_component_prices WHERE comp_cd='COMP_PCB';
  IF v_dup<>0 THEN RAISE EXCEPTION '정본 내부 nat_key 중복 %건(0 기대) → 중단.', v_dup; END IF;
END $post$;

\echo '=== mc-01-pcb PASS 2 (idempotency) ==='
SET LOCAL statement_timeout = '120s';

-- ===== 사전 게이트 하드어서션 (★MC-01 시점종속 언더차지 방어) =====
DO $gate$
DECLARE v_canon_pre int; v_transfer_price int; v_s120p int; v_collisions int;
BEGIN
  -- ★★★ MC-01 halt 게이트: 안전상태만 통과 — 스냅샷상태(각117) 회귀 시 언더차지 즉시중단.
  --   안전상태 = (첫실행: S1_20P=468) OR (이미적용: COMP_PCB=468 AND S1_20P=0). 그 외(예 S1_20P=117) = HALT.
  SELECT count(*) INTO v_s120p    FROM t_prc_component_prices WHERE comp_cd='COMP_PCB_S1_20P';
  SELECT count(*) INTO v_canon_pre FROM t_prc_component_prices WHERE comp_cd='COMP_PCB';
  IF NOT (v_s120p=468 OR (v_canon_pre=468 AND v_s120p=0)) THEN
    RAISE EXCEPTION '★MC-01 HALT: COMP_PCB_S1_20P=%건·COMP_PCB=%건. 안전상태(S1_20P=468 또는 이미적용 COMP_PCB=468&S1_20P=0) 아님 → 07-02 스냅샷(각117) 회귀 의심·즉시중단(부분이관 언더차지 방어).', v_s120p, v_canon_pre;
  END IF;
  -- 게이트① 혼재 0 (정본이 단가행 보유 AND S1_20P도 잔존 = 반쯤적용)
  SELECT count(*) INTO v_transfer_price FROM t_prc_component_prices WHERE comp_cd IN ('COMP_PCB_S1_20P');
  IF v_canon_pre>0 AND v_transfer_price>0 THEN
    RAISE EXCEPTION '게이트① 혼재중단: 정본 COMP_PCB 단가행 %건 + S1_20P %건 동시존재.', v_canon_pre, v_transfer_price;
  END IF;
  -- 게이트③ nat_key 충돌 0 (S1_20P 내부·이관 대상만)
  SELECT count(*)-count(DISTINCT (apply_ymd,siz_cd,plt_siz_cd,clr_cd,mat_cd,proc_cd,opt_cd,print_opt_cd,coat_side_cnt,bdl_qty,siz_width,siz_height,min_qty,COALESCE(dim_vals,'{}'::jsonb)::text)) INTO v_collisions
    FROM t_prc_component_prices WHERE comp_cd IN ('COMP_PCB_S1_20P');
  IF v_collisions<>0 THEN RAISE EXCEPTION '게이트③ nat_key 충돌 %건(0 기대) → 중단.', v_collisions; END IF;
END $gate$;

-- [1] 정본 COMP_PCB 확정 (멱등 UPSERT·라이브 S1_20P 것 승계)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn, prc_typ_cd, use_dims, del_yn, reg_dt)
VALUES ('COMP_PCB', '엽서북 완제품가 사이즈/양단면/페이지수별 단가', 'PRC_COMPONENT_TYPE.06', '엽서북 완제품가. 인쇄면·페이지수·수량별 1권당 단가표. [차원통합] 통합축=print_opt_cd(면)·opt_cd(페이지)', 'Y', 'PRICE_TYPE.01', '["siz_cd", "print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000082"]', 'N', now())
ON CONFLICT (comp_cd) DO UPDATE SET comp_nm=EXCLUDED.comp_nm, comp_typ_cd=EXCLUDED.comp_typ_cd,
  note=EXCLUDED.note, use_yn='Y', prc_typ_cd=EXCLUDED.prc_typ_cd, use_dims=EXCLUDED.use_dims, del_yn='N', upd_dt=now();

-- [2] 단가행 이관: S1_20P(468·전격자·verbatim) → COMP_PCB. 고아 3멤버는 미이관(중복본).
UPDATE t_prc_component_prices SET comp_cd='COMP_PCB', upd_dt=now() WHERE comp_cd IN ('COMP_PCB_S1_20P');

-- [3] formula_components 재배선: PRF_PCB_FIXED → COMP_PCB seq1 (멤버 4종 배선 DELETE)
DELETE FROM t_prc_formula_components WHERE comp_cd IN ('COMP_PCB_S1_20P', 'COMP_PCB_S1_30P', 'COMP_PCB_S2_20P', 'COMP_PCB_S2_30P');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_PCB_FIXED', 'COMP_PCB', 1, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now();

-- [4] 멤버 4종 논리삭제(S1_20P 포함·정본 승격 후 tombstone. 고아 3멤버 중복행 물리보존·무참조)
UPDATE t_prc_price_components SET use_yn='N', del_yn='Y', del_dt=now(),
  note='[차원통합→COMP_PCB]', upd_dt=now() WHERE comp_cd IN ('COMP_PCB_S1_20P', 'COMP_PCB_S1_30P', 'COMP_PCB_S2_20P', 'COMP_PCB_S2_30P');

-- ===== 사후 게이트 하드어서션 =====
DO $post$
DECLARE v_member_fc int; v_canon_rows int; v_transfer_price int; v_dup int;
BEGIN
  -- 게이트② 멤버(4종) fc 참조 0
  SELECT count(*) INTO v_member_fc FROM t_prc_formula_components WHERE comp_cd IN ('COMP_PCB_S1_20P', 'COMP_PCB_S1_30P', 'COMP_PCB_S2_20P', 'COMP_PCB_S2_30P');
  IF v_member_fc<>0 THEN RAISE EXCEPTION '게이트② 멤버 fc참조 %건(0 기대) → 중단.', v_member_fc; END IF;
  -- 구조적 골든 등가①: 정본 단가행수 == 468
  SELECT count(*) INTO v_canon_rows FROM t_prc_component_prices WHERE comp_cd='COMP_PCB';
  IF v_canon_rows<>468 THEN RAISE EXCEPTION '정본 COMP_PCB 단가행수 %건(기대 468) → 중단.', v_canon_rows; END IF;
  -- S1_20P(이관원) 잔존 단가행 0
  SELECT count(*) INTO v_transfer_price FROM t_prc_component_prices WHERE comp_cd IN ('COMP_PCB_S1_20P');
  IF v_transfer_price<>0 THEN RAISE EXCEPTION 'S1_20P 잔존 단가행 %건(0 기대) → 중단.', v_transfer_price; END IF;
  -- 구조적 골든 등가②: 정본 내부 nat_key 유일(0 중복)
  SELECT count(*)-count(DISTINCT (apply_ymd,siz_cd,plt_siz_cd,clr_cd,mat_cd,proc_cd,opt_cd,print_opt_cd,coat_side_cnt,bdl_qty,siz_width,siz_height,min_qty,COALESCE(dim_vals,'{}'::jsonb)::text)) INTO v_dup
    FROM t_prc_component_prices WHERE comp_cd='COMP_PCB';
  IF v_dup<>0 THEN RAISE EXCEPTION '정본 내부 nat_key 중복 %건(0 기대) → 중단.', v_dup; END IF;
END $post$;

\echo '=== mc-01-pcb 2PASS 통과 → 멱등·게이트OK ==='
ROLLBACK;
