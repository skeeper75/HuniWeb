# -*- coding: utf-8 -*-
"""
가격구성요소 병합 9군 COMMIT SQL 결정론 생성기 (provenance: 라이브 사전실측 배선 2026-07-04).
게이트 4종 하드어서션(RAISE→abort) 내장. FK 위상: 정본 INSERT→단가행 UPDATE→fc 재배선→멤버 논리삭제.
★실 COMMIT 금지 — 산출 파일 헤더에 '인간 승인 전 실행 금지' 명시. 이 스크립트는 파일만 생성(DB 미접속).
"""
import os
OUT = os.path.join(os.path.dirname(__file__), "02-commit")
os.makedirs(OUT, exist_ok=True)

NATKEY = ("apply_ymd,siz_cd,plt_siz_cd,clr_cd,mat_cd,proc_cd,opt_cd,print_opt_cd,"
          "coat_side_cnt,bdl_qty,siz_width,siz_height,min_qty,COALESCE(dim_vals,'{}'::jsonb)::text")

def q(lst):  # SQL IN 목록
    return ", ".join("'%s'" % x for x in lst)

# 각 군 스펙 (라이브 사전실측 verbatim)
GROUPS = [
 dict(mc="MC-02", canon="COMP_NAMECARD_PREMIUM", nm="프리미엄명함A 완제품가 단면(용지포함)",
   prc="PRICE_TYPE.02", dims='["mat_cd", "print_opt_cd", "min_qty"]',
   note="명함 완제품가(용지 포함). 소재·인쇄면·수량을 합산한 1건당 단가표. [차원통합] 통합축=print_opt_cd(면)·mat_cd(종이등급 A/B)",
   members=["COMP_NAMECARD_PREMIUM_S1_MGA","COMP_NAMECARD_PREMIUM_S1_MGB","COMP_NAMECARD_PREMIUM_S2_MGA","COMP_NAMECARD_PREMIUM_S2_MGB"],
   rows=28, formulas=["PRF_NAMECARD_PREMIUM","PRF_NAMECARD_PREMIUM_FOIL"],
   bystanders=[("PRF_NAMECARD_PREMIUM","COMP_PP_VARTEXT_1EA",2),("PRF_NAMECARD_PREMIUM","COMP_PP_VARIMG_1EA",3),("PRF_NAMECARD_PREMIUM","COMP_PP_CORNER_RIGHT",4),
     ("PRF_NAMECARD_PREMIUM_FOIL","COMP_FOIL_SETUP_SMALL",2),("PRF_NAMECARD_PREMIUM_FOIL","COMP_FOIL_PROC_SMALL_STD",3),("PRF_NAMECARD_PREMIUM_FOIL","COMP_FOIL_PROC_SMALL_SPECIAL",4),
     ("PRF_NAMECARD_PREMIUM_FOIL","COMP_PP_VARTEXT_1EA",5),("PRF_NAMECARD_PREMIUM_FOIL","COMP_PP_VARIMG_1EA",6),("PRF_NAMECARD_PREMIUM_FOIL","COMP_PP_CORNER_RIGHT",7)],
   golden="단면·MGA=4500 · 단면·MGB=5000 · 양면·MGA=5500 · 양면·MGB=6500 (q100)"),
 dict(mc="MC-03", canon="COMP_NAMECARD_FOIL", nm="오리지널박명함 완제품가 단면·일반박(종이+동판+박)",
   prc="PRICE_TYPE.02", dims='["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000080"]',
   note="오리지널 박명함 완제품가(종이+동판+박 가공 합산). 인쇄면·박 종류·수량별 단가표. [차원통합] 통합축=print_opt_cd(면)·opt_cd(박종류)",
   members=["COMP_NAMECARD_FOIL_S1_STD","COMP_NAMECARD_FOIL_S1_HOLO","COMP_NAMECARD_FOIL_S2_STD","COMP_NAMECARD_FOIL_S2_HOLO"],
   rows=36, formulas=["PRF_NAMECARD_FOIL"],
   bystanders=[("PRF_NAMECARD_FOIL","COMP_NAMECARD_FOIL_SETUP_S1_STD",2),("PRF_NAMECARD_FOIL","COMP_NAMECARD_FOIL_SETUP_S2_STD",3)],
   golden="단면·일반박 q200=19200 · 단면·홀로 q200=24800 · 양면·일반박 q300=24800 (+SETUP 불변)"),
 dict(mc="MC-04", canon="COMP_NAMECARD_WHITE", nm="화이트인쇄명함 완제품가 단면·무코팅(용지포함)",
   prc="PRICE_TYPE.02", dims='["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"]',
   note="명함 완제품가(용지 포함). 소재·인쇄면·수량을 합산한 1건당 단가표. [차원통합] 통합축=print_opt_cd(면)·opt_cd(코팅유무)",
   members=["COMP_NAMECARD_WHITE_S1W_CL","COMP_NAMECARD_WHITE_S1W_NOCL","COMP_NAMECARD_WHITE_S2W_CL","COMP_NAMECARD_WHITE_S2W_NOCL"],
   rows=4, formulas=["PRF_NAMECARD_WHITE"], bystanders=[],
   golden="단면코팅=16000 · 단면무코팅=14500 · 양면코팅=19000 · 양면무코팅=16000 (q100)"),
 dict(mc="MC-05", canon="COMP_NAMECARD_STD", nm="스탠다드명함 완제품가 단면(용지포함)",
   prc="PRICE_TYPE.02", dims='["mat_cd", "min_qty", "print_opt_cd"]',
   note="명함 완제품가(용지 포함). 소재·인쇄면·수량을 합산한 1건당 단가표. [차원통합] 통합축=print_opt_cd(면)",
   members=["COMP_NAMECARD_STD_S1","COMP_NAMECARD_STD_S2"],
   rows=10, formulas=["PRF_NAMECARD_FIXED","PRF_NAMECARD_FIXED_FOIL"],
   bystanders=[("PRF_NAMECARD_FIXED_FOIL","COMP_FOIL_SETUP_SMALL",2),("PRF_NAMECARD_FIXED_FOIL","COMP_FOIL_PROC_SMALL_STD",3),("PRF_NAMECARD_FIXED_FOIL","COMP_FOIL_PROC_SMALL_SPECIAL",4)],
   golden="단면 MAT_000074 q100=3500 · 양면=4500 (PRF_NAMECARD_FIXED_FOIL=고아공식·상품0·일관성 재배선)"),
 dict(mc="MC-06", canon="COMP_NAMECARD_COAT", nm="코팅명함 완제품가 단면(용지포함)",
   prc="PRICE_TYPE.02", dims='["mat_cd", "min_qty", "print_opt_cd"]',
   note="명함 완제품가(용지 포함). 소재·인쇄면·수량을 합산한 1건당 단가표. [차원통합] 통합축=print_opt_cd(면)",
   members=["COMP_NAMECARD_COAT_S1","COMP_NAMECARD_COAT_S2"],
   rows=4, formulas=["PRF_NAMECARD_COAT"], bystanders=[],
   golden="단면 MAT_000081=5500 · 양면 MAT_000082=6800"),
 dict(mc="MC-07", canon="COMP_NAMECARD_PEARL", nm="펄명함(스타드림) 완제품가 단면(용지포함)",
   prc="PRICE_TYPE.02", dims='["mat_cd", "min_qty", "print_opt_cd"]',
   note="명함 완제품가(용지 포함). 소재·인쇄면·수량을 합산한 1건당 단가표. [차원통합] 통합축=print_opt_cd(면)",
   members=["COMP_NAMECARD_PEARL_S1","COMP_NAMECARD_PEARL_S2"],
   rows=8, formulas=["PRF_NAMECARD_PEARL","PRF_NAMECARD_PEARL_FOIL"],
   bystanders=[("PRF_NAMECARD_PEARL_FOIL","COMP_FOIL_SETUP_SMALL",2),("PRF_NAMECARD_PEARL_FOIL","COMP_FOIL_PROC_SMALL_STD",3),("PRF_NAMECARD_PEARL_FOIL","COMP_FOIL_PROC_SMALL_SPECIAL",4)],
   golden="단면 MAT_000352 q100=9000 · 양면=10000"),
 dict(mc="MC-08", canon="COMP_NAMECARD_SHAPE", nm="모양명함 완제품가 단면(용지포함)",
   prc="PRICE_TYPE.02", dims='["siz_cd", "min_qty", "print_opt_cd"]',
   note="명함 완제품가(용지 포함). 소재·인쇄면·수량을 합산한 1건당 단가표. [차원통합] 통합축=print_opt_cd(면)",
   members=["COMP_NAMECARD_SHAPE_S1","COMP_NAMECARD_SHAPE_S2"],
   rows=2, formulas=["PRF_NAMECARD_SHAPE"], bystanders=[],
   golden="단면 SIZ_000008 q100=18000 · 양면=19000"),
 dict(mc="MC-09", canon="COMP_NAMECARD_MINISHAPE", nm="미니모양명함 완제품가 단면(용지포함)",
   prc="PRICE_TYPE.02", dims='["siz_cd", "min_qty", "print_opt_cd"]',
   note="명함 완제품가(용지 포함). 소재·인쇄면·수량을 합산한 1건당 단가표. [차원통합] 통합축=print_opt_cd(면)",
   members=["COMP_NAMECARD_MINISHAPE_S1","COMP_NAMECARD_MINISHAPE_S2"],
   rows=2, formulas=["PRF_NAMECARD_MINISHAPE"], bystanders=[],
   golden="단면 SIZ_000011 q100=16000 · 양면=17000"),
]

# MC-01 특수(배치 B): S1_20P만 이관(468) · 고아3 미이관 · 4멤버 tombstone · 468 halt 게이트
MC01 = dict(mc="MC-01", canon="COMP_PCB", nm="엽서북 완제품가 사이즈/양단면/페이지수별 단가",
   prc="PRICE_TYPE.01", dims='["siz_cd", "print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000082"]',
   note="엽서북 완제품가. 인쇄면·페이지수·수량별 1권당 단가표. [차원통합] 통합축=print_opt_cd(면)·opt_cd(페이지)",
   transfer=["COMP_PCB_S1_20P"],   # 이관은 S1_20P만
   tombstone=["COMP_PCB_S1_20P","COMP_PCB_S1_30P","COMP_PCB_S2_20P","COMP_PCB_S2_30P"],
   rows=468, formulas=["PRF_PCB_FIXED"],
   golden="단면20p SIZ_000003 q2=11000×2=22000 · 양면30p q2=12500×2=25000 · 단면20p q2500=2230")

HEADER = """-- ============================================================
-- {mc}  {canon} 병합 COMMIT SQL (게이트 4종 하드어서션 내장)
-- provenance: 라이브 사전실측 배선(2026-07-04) · 생성기 gen_commit_sql.py
-- ⚠️⚠️⚠️ 인간 승인 전 실행 금지 ⚠️⚠️⚠️
--   · 이 파일 그대로 실행 = 실 COMMIT(영속). 군별 인간 승인 + webadmin 실화면 확인 후에만.
--   · 롤백전용 DRY-RUN: 맨 끝 'COMMIT;' 을 'ROLLBACK;' 으로 바꿔 실행(영속 없음·게이트만 확인).
-- 골든(불변 기대): {golden}
-- ============================================================
BEGIN;
SET LOCAL statement_timeout = '120s';
"""

def gate_block_std(g):
    members = q(g["members"])
    return f"""
-- ===== 사전 게이트 하드어서션 (위반 시 RAISE→트랜잭션 abort) =====
DO $gate$
DECLARE v_canon_pre int; v_member_price int; v_collisions int;
BEGIN
  -- 게이트① 정본+멤버 혼재 0 (정본이 단가행 보유 AND 멤버도 잔존 = 반쯤적용 혼재 → 중단)
  SELECT count(*) INTO v_canon_pre  FROM t_prc_component_prices WHERE comp_cd='{g["canon"]}';
  SELECT count(*) INTO v_member_price FROM t_prc_component_prices WHERE comp_cd IN ({members});
  IF v_canon_pre>0 AND v_member_price>0 THEN
    RAISE EXCEPTION '게이트① 혼재중단: 정본 {g["canon"]} 단가행 %건 + 멤버 단가행 %건 동시존재(반쯤적용 의심).', v_canon_pre, v_member_price;
  END IF;
  -- 게이트③ nat_key(15열) 충돌 0 (멤버 단가행을 정본으로 옮길 때 중복 없음)
  SELECT count(*)-count(DISTINCT ({NATKEY})) INTO v_collisions
    FROM t_prc_component_prices WHERE comp_cd IN ({members});
  IF v_collisions<>0 THEN
    RAISE EXCEPTION '게이트③ nat_key 충돌 %건(0 기대) → 중단.', v_collisions;
  END IF;
END $gate$;
"""

def post_block_std(g):
    members = q(g["members"])
    return f"""
-- ===== 사후 게이트 하드어서션 (COMMIT 전·트랜잭션 내) =====
DO $post$
DECLARE v_member_fc int; v_canon_rows int; v_member_price int; v_dup int;
BEGIN
  -- 게이트② 멤버 comp formula 참조 0 (재배선 후)
  SELECT count(*) INTO v_member_fc FROM t_prc_formula_components WHERE comp_cd IN ({members});
  IF v_member_fc<>0 THEN RAISE EXCEPTION '게이트② 멤버 fc참조 %건(0 기대) → 중단.', v_member_fc; END IF;
  -- 구조적 골든 등가①: 정본 단가행수 == 이관 기대({g["rows"]})
  SELECT count(*) INTO v_canon_rows FROM t_prc_component_prices WHERE comp_cd='{g["canon"]}';
  IF v_canon_rows<>{g["rows"]} THEN RAISE EXCEPTION '정본 단가행수 %건(기대 {g["rows"]}) → 중단.', v_canon_rows; END IF;
  -- 멤버 잔존 단가행 0
  SELECT count(*) INTO v_member_price FROM t_prc_component_prices WHERE comp_cd IN ({members});
  IF v_member_price<>0 THEN RAISE EXCEPTION '멤버 잔존 단가행 %건(0 기대) → 중단.', v_member_price; END IF;
  -- 구조적 골든 등가②: 정본 내부 nat_key 유일(좌표당 1행·0 중복)
  SELECT count(*)-count(DISTINCT ({NATKEY})) INTO v_dup
    FROM t_prc_component_prices WHERE comp_cd='{g["canon"]}';
  IF v_dup<>0 THEN RAISE EXCEPTION '정본 내부 nat_key 중복 %건(0 기대) → 중단.', v_dup; END IF;
END $post$;
"""

def merge_block_std(g):
    members = q(g["members"])
    fc_vals = ",\n  ".join("('%s', '%s', 1, 'Y', now())" % (f, g["canon"]) for f in g["formulas"])
    by = "\n".join(
      "UPDATE t_prc_formula_components SET disp_seq=%d, upd_dt=now() WHERE frm_cd='%s' AND comp_cd='%s';" % (seq, f, c)
      for (f, c, seq) in g["bystanders"]) or "-- (bystander 없음)"
    return f"""
-- [1] 정본 comp 카탈로그 확정 (멱등 UPSERT)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn, prc_typ_cd, use_dims, del_yn, reg_dt)
VALUES ('{g["canon"]}', '{g["nm"]}', 'PRC_COMPONENT_TYPE.06', '{g["note"]}', 'Y', '{g["prc"]}', '{g["dims"]}', 'N', now())
ON CONFLICT (comp_cd) DO UPDATE SET comp_nm=EXCLUDED.comp_nm, comp_typ_cd=EXCLUDED.comp_typ_cd,
  note=EXCLUDED.note, use_yn='Y', prc_typ_cd=EXCLUDED.prc_typ_cd, use_dims=EXCLUDED.use_dims, del_yn='N', upd_dt=now();

-- [2] 단가행 이관: 멤버 comp_cd → 정본 (분리축 값은 행에 이미 충전·verbatim 불변). 기대 {g["rows"]}행(재실행 0=멱등)
UPDATE t_prc_component_prices SET comp_cd='{g["canon"]}', upd_dt=now() WHERE comp_cd IN ({members});

-- [3] formula_components 재배선: 멤버 배선 DELETE + 정본 seq1 UPSERT(공식별)
DELETE FROM t_prc_formula_components WHERE comp_cd IN ({members});
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES
  {fc_vals}
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now();

-- [3b] bystander disp_seq 재정렬 (정본=1 뒤로 밀기·삭제 없음)
{by}

-- [4] 멤버 comp 논리삭제 (hard-delete 금지)
UPDATE t_prc_price_components SET use_yn='N', del_yn='Y', del_dt=now(),
  note='[차원통합→{g["canon"]}]', upd_dt=now() WHERE comp_cd IN ({members});
"""

for g in GROUPS:
    sql = HEADER.format(**g) + gate_block_std(g) + merge_block_std(g) + post_block_std(g) + \
          "\nCOMMIT;  -- ⚠️ 인간 승인 전 실행 금지. DRY-RUN 시 ROLLBACK 으로 교체.\n"
    fn = os.path.join(OUT, "%s-%s-commit.sql" % (g["mc"].lower().replace("mc-","mc-"), g["canon"].lower().replace("comp_","")))
    open(fn, "w").write(sql)
    print("wrote", fn)

# ---- MC-01 특수 (배치 B) ----
g = MC01
members = q(g["tombstone"]); transfer = q(g["transfer"])
sql = HEADER.format(**g)
sql += f"""
-- ===== 사전 게이트 하드어서션 (★MC-01 시점종속 언더차지 방어) =====
DO $gate$
DECLARE v_canon_pre int; v_transfer_price int; v_s120p int; v_collisions int;
BEGIN
  -- ★★★ MC-01 halt 게이트: 안전상태만 통과 — 스냅샷상태(각117) 회귀 시 언더차지 즉시중단.
  --   안전상태 = (첫실행: S1_20P=468) OR (이미적용: COMP_PCB=468 AND S1_20P=0). 그 외(예 S1_20P=117) = HALT.
  SELECT count(*) INTO v_s120p    FROM t_prc_component_prices WHERE comp_cd='COMP_PCB_S1_20P';
  SELECT count(*) INTO v_canon_pre FROM t_prc_component_prices WHERE comp_cd='{g["canon"]}';
  IF NOT (v_s120p=468 OR (v_canon_pre=468 AND v_s120p=0)) THEN
    RAISE EXCEPTION '★MC-01 HALT: COMP_PCB_S1_20P=%건·COMP_PCB=%건. 안전상태(S1_20P=468 또는 이미적용 COMP_PCB=468&S1_20P=0) 아님 → 07-02 스냅샷(각117) 회귀 의심·즉시중단(부분이관 언더차지 방어).', v_s120p, v_canon_pre;
  END IF;
  -- 게이트① 혼재 0 (정본이 단가행 보유 AND S1_20P도 잔존 = 반쯤적용)
  SELECT count(*) INTO v_transfer_price FROM t_prc_component_prices WHERE comp_cd IN ({transfer});
  IF v_canon_pre>0 AND v_transfer_price>0 THEN
    RAISE EXCEPTION '게이트① 혼재중단: 정본 COMP_PCB 단가행 %건 + S1_20P %건 동시존재.', v_canon_pre, v_transfer_price;
  END IF;
  -- 게이트③ nat_key 충돌 0 (S1_20P 내부·이관 대상만)
  SELECT count(*)-count(DISTINCT ({NATKEY})) INTO v_collisions
    FROM t_prc_component_prices WHERE comp_cd IN ({transfer});
  IF v_collisions<>0 THEN RAISE EXCEPTION '게이트③ nat_key 충돌 %건(0 기대) → 중단.', v_collisions; END IF;
END $gate$;

-- [1] 정본 COMP_PCB 확정 (멱등 UPSERT·라이브 S1_20P 것 승계)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn, prc_typ_cd, use_dims, del_yn, reg_dt)
VALUES ('{g["canon"]}', '{g["nm"]}', 'PRC_COMPONENT_TYPE.06', '{g["note"]}', 'Y', '{g["prc"]}', '{g["dims"]}', 'N', now())
ON CONFLICT (comp_cd) DO UPDATE SET comp_nm=EXCLUDED.comp_nm, comp_typ_cd=EXCLUDED.comp_typ_cd,
  note=EXCLUDED.note, use_yn='Y', prc_typ_cd=EXCLUDED.prc_typ_cd, use_dims=EXCLUDED.use_dims, del_yn='N', upd_dt=now();

-- [2] 단가행 이관: S1_20P(468·전격자·verbatim) → COMP_PCB. 고아 3멤버는 미이관(중복본).
UPDATE t_prc_component_prices SET comp_cd='{g["canon"]}', upd_dt=now() WHERE comp_cd IN ({transfer});

-- [3] formula_components 재배선: PRF_PCB_FIXED → COMP_PCB seq1 (멤버 4종 배선 DELETE)
DELETE FROM t_prc_formula_components WHERE comp_cd IN ({members});
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_PCB_FIXED', '{g["canon"]}', 1, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now();

-- [4] 멤버 4종 논리삭제(S1_20P 포함·정본 승격 후 tombstone. 고아 3멤버 중복행 물리보존·무참조)
UPDATE t_prc_price_components SET use_yn='N', del_yn='Y', del_dt=now(),
  note='[차원통합→COMP_PCB]', upd_dt=now() WHERE comp_cd IN ({members});

-- ===== 사후 게이트 하드어서션 =====
DO $post$
DECLARE v_member_fc int; v_canon_rows int; v_transfer_price int; v_dup int;
BEGIN
  -- 게이트② 멤버(4종) fc 참조 0
  SELECT count(*) INTO v_member_fc FROM t_prc_formula_components WHERE comp_cd IN ({members});
  IF v_member_fc<>0 THEN RAISE EXCEPTION '게이트② 멤버 fc참조 %건(0 기대) → 중단.', v_member_fc; END IF;
  -- 구조적 골든 등가①: 정본 단가행수 == 468
  SELECT count(*) INTO v_canon_rows FROM t_prc_component_prices WHERE comp_cd='{g["canon"]}';
  IF v_canon_rows<>{g["rows"]} THEN RAISE EXCEPTION '정본 COMP_PCB 단가행수 %건(기대 {g["rows"]}) → 중단.', v_canon_rows; END IF;
  -- S1_20P(이관원) 잔존 단가행 0
  SELECT count(*) INTO v_transfer_price FROM t_prc_component_prices WHERE comp_cd IN ({transfer});
  IF v_transfer_price<>0 THEN RAISE EXCEPTION 'S1_20P 잔존 단가행 %건(0 기대) → 중단.', v_transfer_price; END IF;
  -- 구조적 골든 등가②: 정본 내부 nat_key 유일(0 중복)
  SELECT count(*)-count(DISTINCT ({NATKEY})) INTO v_dup
    FROM t_prc_component_prices WHERE comp_cd='{g["canon"]}';
  IF v_dup<>0 THEN RAISE EXCEPTION '정본 내부 nat_key 중복 %건(0 기대) → 중단.', v_dup; END IF;
END $post$;

COMMIT;  -- ⚠️ 인간 승인 전 실행 금지. DRY-RUN 시 ROLLBACK 으로 교체. ★MC-01은 별도 승인(옵션a 재명명).
"""
fn = os.path.join(OUT, "mc-01-pcb-commit.sql")
open(fn, "w").write(sql)
print("wrote", fn)
print("DONE")
