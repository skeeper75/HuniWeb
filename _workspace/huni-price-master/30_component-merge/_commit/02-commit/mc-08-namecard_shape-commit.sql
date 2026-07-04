-- ============================================================
-- MC-08  COMP_NAMECARD_SHAPE 병합 COMMIT SQL (게이트 4종 하드어서션 내장)
-- provenance: 라이브 사전실측 배선(2026-07-04) · 생성기 gen_commit_sql.py
-- ⚠️⚠️⚠️ 인간 승인 전 실행 금지 ⚠️⚠️⚠️
--   · 이 파일 그대로 실행 = 실 COMMIT(영속). 군별 인간 승인 + webadmin 실화면 확인 후에만.
--   · 롤백전용 DRY-RUN: 맨 끝 'COMMIT;' 을 'ROLLBACK;' 으로 바꿔 실행(영속 없음·게이트만 확인).
-- 골든(불변 기대): 단면 SIZ_000008 q100=18000 · 양면=19000
-- ============================================================
BEGIN;
SET LOCAL statement_timeout = '120s';

-- ===== 사전 게이트 하드어서션 (위반 시 RAISE→트랜잭션 abort) =====
DO $gate$
DECLARE v_canon_pre int; v_member_price int; v_collisions int;
BEGIN
  -- 게이트① 정본+멤버 혼재 0 (정본이 단가행 보유 AND 멤버도 잔존 = 반쯤적용 혼재 → 중단)
  SELECT count(*) INTO v_canon_pre  FROM t_prc_component_prices WHERE comp_cd='COMP_NAMECARD_SHAPE';
  SELECT count(*) INTO v_member_price FROM t_prc_component_prices WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1', 'COMP_NAMECARD_SHAPE_S2');
  IF v_canon_pre>0 AND v_member_price>0 THEN
    RAISE EXCEPTION '게이트① 혼재중단: 정본 COMP_NAMECARD_SHAPE 단가행 %건 + 멤버 단가행 %건 동시존재(반쯤적용 의심).', v_canon_pre, v_member_price;
  END IF;
  -- 게이트③ nat_key(15열) 충돌 0 (멤버 단가행을 정본으로 옮길 때 중복 없음)
  SELECT count(*)-count(DISTINCT (apply_ymd,siz_cd,plt_siz_cd,clr_cd,mat_cd,proc_cd,opt_cd,print_opt_cd,coat_side_cnt,bdl_qty,siz_width,siz_height,min_qty,COALESCE(dim_vals,'{}'::jsonb)::text)) INTO v_collisions
    FROM t_prc_component_prices WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1', 'COMP_NAMECARD_SHAPE_S2');
  IF v_collisions<>0 THEN
    RAISE EXCEPTION '게이트③ nat_key 충돌 %건(0 기대) → 중단.', v_collisions;
  END IF;
END $gate$;

-- [1] 정본 comp 카탈로그 확정 (멱등 UPSERT)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn, prc_typ_cd, use_dims, del_yn, reg_dt)
VALUES ('COMP_NAMECARD_SHAPE', '모양명함 완제품가 단면(용지포함)', 'PRC_COMPONENT_TYPE.06', '명함 완제품가(용지 포함). 소재·인쇄면·수량을 합산한 1건당 단가표. [차원통합] 통합축=print_opt_cd(면)', 'Y', 'PRICE_TYPE.02', '["siz_cd", "min_qty", "print_opt_cd"]', 'N', now())
ON CONFLICT (comp_cd) DO UPDATE SET comp_nm=EXCLUDED.comp_nm, comp_typ_cd=EXCLUDED.comp_typ_cd,
  note=EXCLUDED.note, use_yn='Y', prc_typ_cd=EXCLUDED.prc_typ_cd, use_dims=EXCLUDED.use_dims, del_yn='N', upd_dt=now();

-- [2] 단가행 이관: 멤버 comp_cd → 정본 (분리축 값은 행에 이미 충전·verbatim 불변). 기대 2행(재실행 0=멱등)
UPDATE t_prc_component_prices SET comp_cd='COMP_NAMECARD_SHAPE', upd_dt=now() WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1', 'COMP_NAMECARD_SHAPE_S2');

-- [3] formula_components 재배선: 멤버 배선 DELETE + 정본 seq1 UPSERT(공식별)
DELETE FROM t_prc_formula_components WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1', 'COMP_NAMECARD_SHAPE_S2');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES
  ('PRF_NAMECARD_SHAPE', 'COMP_NAMECARD_SHAPE', 1, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now();

-- [3b] bystander disp_seq 재정렬 (정본=1 뒤로 밀기·삭제 없음)
-- (bystander 없음)

-- [4] 멤버 comp 논리삭제 (hard-delete 금지)
UPDATE t_prc_price_components SET use_yn='N', del_yn='Y', del_dt=now(),
  note='[차원통합→COMP_NAMECARD_SHAPE]', upd_dt=now() WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1', 'COMP_NAMECARD_SHAPE_S2');

-- ===== 사후 게이트 하드어서션 (COMMIT 전·트랜잭션 내) =====
DO $post$
DECLARE v_member_fc int; v_canon_rows int; v_member_price int; v_dup int;
BEGIN
  -- 게이트② 멤버 comp formula 참조 0 (재배선 후)
  SELECT count(*) INTO v_member_fc FROM t_prc_formula_components WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1', 'COMP_NAMECARD_SHAPE_S2');
  IF v_member_fc<>0 THEN RAISE EXCEPTION '게이트② 멤버 fc참조 %건(0 기대) → 중단.', v_member_fc; END IF;
  -- 구조적 골든 등가①: 정본 단가행수 == 이관 기대(2)
  SELECT count(*) INTO v_canon_rows FROM t_prc_component_prices WHERE comp_cd='COMP_NAMECARD_SHAPE';
  IF v_canon_rows<>2 THEN RAISE EXCEPTION '정본 단가행수 %건(기대 2) → 중단.', v_canon_rows; END IF;
  -- 멤버 잔존 단가행 0
  SELECT count(*) INTO v_member_price FROM t_prc_component_prices WHERE comp_cd IN ('COMP_NAMECARD_SHAPE_S1', 'COMP_NAMECARD_SHAPE_S2');
  IF v_member_price<>0 THEN RAISE EXCEPTION '멤버 잔존 단가행 %건(0 기대) → 중단.', v_member_price; END IF;
  -- 구조적 골든 등가②: 정본 내부 nat_key 유일(좌표당 1행·0 중복)
  SELECT count(*)-count(DISTINCT (apply_ymd,siz_cd,plt_siz_cd,clr_cd,mat_cd,proc_cd,opt_cd,print_opt_cd,coat_side_cnt,bdl_qty,siz_width,siz_height,min_qty,COALESCE(dim_vals,'{}'::jsonb)::text)) INTO v_dup
    FROM t_prc_component_prices WHERE comp_cd='COMP_NAMECARD_SHAPE';
  IF v_dup<>0 THEN RAISE EXCEPTION '정본 내부 nat_key 중복 %건(0 기대) → 중단.', v_dup; END IF;
END $post$;

COMMIT;  -- ⚠️ 인간 승인 전 실행 금지. DRY-RUN 시 ROLLBACK 으로 교체.
