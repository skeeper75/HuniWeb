#!/usr/bin/env python3
# 접지리플렛(PRD_000048)·와이드 접지리플렛(PRD_000049) 완전 견적 종단 적재본 생성기.
#   = 기존 옵션 레이어(leaflet-fold-options-260703/gen.py build) + L1 기초(사이즈·인쇄비·접지 공정)
#     + 접지 옵션그룹 + 공식 재바인딩.
# 권위 260702 상품마스터 디지털인쇄 시트. 라이브 차원행 참조만(신규 mint 0).
# AMBIG 해소: 접지(fold)=공정축(049 동형 실증). 048 공식 PRF_FOLD_SUM(스텁)→PRF_DGP_E(접지리플렛 family) 재바인딩.
import os, sys

D = os.path.dirname(os.path.abspath(__file__))
OPT_DIR = os.path.join(D, "..", "leaflet-fold-options-260703")
sys.path.insert(0, OPT_DIR)
import gen  # 기존 옵션 레이어 생성 로직 재사용(4그룹 인쇄/종이/코팅/후가공 + 코팅 제약)


def esc(s):
    return s.replace("'", "''")


# ── L1 기초 사양 (권위 260702 실측) ──────────────────────────────────
BASE_PRINT = "PROC_000004"  # 디지털인쇄(mand) — 인쇄비 COMP_PRINT_DIGITAL_S1 발현
# 접지 종류 = 공정(proc_cd) — 라이브 실재, COMP_FOLD_LEAF_* 단가행 존재 확인
FOLDS_048 = [("반접지", "PROC_000107"), ("3단접지", "PROC_000060"),
             ("4단병풍접지", "PROC_000071"), ("4단대문접지", "PROC_000106")]
FOLDS_049 = [("3단접지", "PROC_000060"), ("4단병풍접지", "PROC_000071"),
             ("4단대문접지", "PROC_000106")]  # 049 권위엔 반접지 없음
# 048 사이즈 = A5/A4/A3 (권위 재단사이즈 landscape = 라이브 기존 siz_cd 정확 일치, mint 0)
SIZES_048 = [("SIZ_000049", "A5 210x148", "Y", 1),
             ("SIZ_000051", "A4 297x210", "N", 2),
             ("SIZ_000054", "A3 420x297", "N", 3)]
QTY = (2, 100000, 1)  # min/max/incr (권위 수량)


def proc_upsert(prd, proc, mand, seq):
    return ("INSERT INTO t_prd_product_processes "
            "(prd_cd,proc_cd,mand_proc_yn,disp_seq,del_yn,reg_dt) VALUES "
            f"('{prd}','{proc}','{mand}',{seq},'N',now()) "
            "ON CONFLICT (prd_cd,proc_cd) DO UPDATE SET "
            "mand_proc_yn=EXCLUDED.mand_proc_yn,disp_seq=EXCLUDED.disp_seq,"
            "del_yn='N',upd_dt=now();")


def size_upsert(prd, siz, dflt, seq, mn, mx, incr):
    return ("INSERT INTO t_prd_product_sizes "
            "(prd_cd,siz_cd,dflt_yn,disp_seq,min_qty,max_qty,qty_incr,del_yn,reg_dt) VALUES "
            f"('{prd}','{siz}','{dflt}',{seq},{mn},{mx},{incr},'N',now()) "
            "ON CONFLICT (prd_cd,siz_cd) DO UPDATE SET "
            "dflt_yn=EXCLUDED.dflt_yn,disp_seq=EXCLUDED.disp_seq,min_qty=EXCLUDED.min_qty,"
            "max_qty=EXCLUDED.max_qty,qty_incr=EXCLUDED.qty_incr,del_yn='N',upd_dt=now();")


def fold_group(prd, grp_cd, folds, opv_start, seq):
    """접지 옵션그룹(택1·mand) + 옵션 + 항목(공정 참조). returns (lines, opv_cds)."""
    L = [f"-- 접지 옵션그룹 ({prd})"]
    L.append("INSERT INTO t_prd_product_option_groups "
             "(prd_cd,opt_grp_cd,opt_grp_nm,sel_typ_cd,min_sel_cnt,max_sel_cnt,mand_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES "
             f"('{prd}','{grp_cd}','접지','SEL_TYPE.01',1,1,'Y',{seq},'Y','N',now()) "
             "ON CONFLICT (prd_cd,opt_grp_cd) DO UPDATE SET opt_grp_nm=EXCLUDED.opt_grp_nm,"
             "sel_typ_cd=EXCLUDED.sel_typ_cd,min_sel_cnt=EXCLUDED.min_sel_cnt,max_sel_cnt=EXCLUDED.max_sel_cnt,"
             "mand_yn=EXCLUDED.mand_yn,disp_seq=EXCLUDED.disp_seq,use_yn='Y',del_yn='N',upd_dt=now();")
    opv_cds = []
    v = opv_start
    for i, (nm, proc) in enumerate(folds, start=1):
        opv = f"OPV_{v:06d}"; v += 1
        opv_cds.append(opv)
        dflt = "Y" if i == 1 else "N"
        L.append("INSERT INTO t_prd_product_options "
                 "(prd_cd,opt_cd,opt_grp_cd,opt_nm,dflt_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES "
                 f"('{prd}','{opv}','{grp_cd}','{esc(nm)}','{dflt}',{i},'Y','N',now()) "
                 "ON CONFLICT (prd_cd,opt_cd) DO UPDATE SET opt_grp_cd=EXCLUDED.opt_grp_cd,"
                 "opt_nm=EXCLUDED.opt_nm,dflt_yn=EXCLUDED.dflt_yn,disp_seq=EXCLUDED.disp_seq,"
                 "use_yn='Y',del_yn='N',upd_dt=now();")
        L.append("INSERT INTO t_prd_product_option_items "
                 "(prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn,del_yn,reg_dt) VALUES "
                 f"('{prd}','{opv}',1,'OPT_REF_DIM.04','{proc}',NULL,1,'Y','N',now()) "
                 "ON CONFLICT (prd_cd,opt_cd,item_seq) DO UPDATE SET ref_dim_cd=EXCLUDED.ref_dim_cd,"
                 "ref_key1=EXCLUDED.ref_key1,ref_key2=EXCLUDED.ref_key2,qty=EXCLUDED.qty,"
                 "use_yn='Y',del_yn='N',upd_dt=now();")
    return L, opv_cds, v


def main():
    p48 = gen.load_papers(os.path.join(OPT_DIR, "data", "048-papers.csv"))
    p49 = gen.load_papers(os.path.join(OPT_DIR, "data", "049-papers.csv"))

    A = ["-- ============================================================",
         "-- 접지리플렛(PRD_000048)·와이드 접지리플렛(PRD_000049) 완전 견적 종단 적재본",
         "--   생성기: gen_full.py · 권위 260702 · 라이브 차원행 참조만(신규 mint 0)",
         "--   구성: L1 기초(공식·인쇄비·접지공정·사이즈) + 옵션레이어(인쇄/종이/코팅/후가공) + 접지 옵션그룹 + 코팅 제약",
         "--   AMBIG 해소: 접지=공정축(049 동형). 048 공식 PRF_FOLD_SUM(스텁)→PRF_DGP_E 재바인딩",
         "-- ============================================================",
         "BEGIN;",
         "",
         "-- ===== [L1] 접지리플렛(PRD_000048) 기초 =====",
         "-- 공식 재바인딩: PRF_FOLD_SUM(접지비 카드 2단 단일=스텁) → PRF_DGP_E(디지털인쇄 원자합산형E 접지카드·접지리플렛)",
         "UPDATE t_prd_product_price_formulas SET frm_cd='PRF_DGP_E',"
         "note='접지리플렛 동형 재바인딩(스텁 PRF_FOLD_SUM→접지리플렛 family PRF_DGP_E) 260703',upd_dt=now() "
         "WHERE prd_cd='PRD_000048';",
         "-- 인쇄비 배선: 디지털인쇄 base 공정(mand) — 부재 시 인쇄비 영구 0",
         proc_upsert("PRD_000048", BASE_PRINT, "Y", -1)]
    for i, (nm, proc) in enumerate(FOLDS_048, start=1):
        A.append(f"-- 접지 공정: {nm}")
        A.append(proc_upsert("PRD_000048", proc, "N", i))
    A.append("-- 사이즈(A5/A4/A3) — 권위 재단사이즈 landscape = 라이브 siz_cd 정확 일치")
    for siz, nm, dflt, seq in SIZES_048:
        A.append(f"-- {nm}")
        A.append(size_upsert("PRD_000048", siz, dflt, seq, *QTY))

    A += ["", "-- ===== [L1] 와이드 접지리플렛(PRD_000049) 기초 =====",
          "-- 공식 PRF_DGP_E 이미 바인딩(변경 없음) · 사이즈 SIZ_000055(3절) 이미 적재",
          "-- 접지 공정 보강: 4단대문접지(권위 있으나 라이브 부재)"]
    A.append(proc_upsert("PRD_000049", "PROC_000106", "N", 2))

    # ── 옵션 레이어(기존 gen.build): 인쇄/종이/코팅/후가공 + 코팅 제약 ──
    A += ["", "-- ===== [L2] 옵션 레이어(인쇄·종이·코팅·후가공) + 코팅×두께 제약 ====="]
    m = gen.Minter(147, 556)  # 기존 스펙과 동일 채번 유지(048=OPT147-150/OPV556-605, 049=OPT151-154/OPV606-616)
    undo_opt = []
    for prd_cd, prd_nm, papers in [("PRD_000048", "접지리플렛", p48),
                                    ("PRD_000049", "와이드 접지리플렛", p49)]:
        B, grp_cds, opv_cds, thin = gen.build(prd_cd, prd_nm, papers, m)
        A += B
        undo_opt.append((prd_cd, grp_cds))

    # ── 접지 옵션그룹(신규 OPT_000155/156, OPV_000617~) ──
    A += ["", "-- ===== [L2] 접지 옵션그룹(택1·필수) — 접지 공정 UI 선택 ====="]
    fold_undo = []
    v = 617
    L, opv48, v = fold_group("PRD_000048", "OPT_000155", FOLDS_048, v, 5)
    A += L; fold_undo.append(("PRD_000048", "OPT_000155"))
    L, opv49, v = fold_group("PRD_000049", "OPT_000156", FOLDS_049, v, 5)
    A += L; fold_undo.append(("PRD_000049", "OPT_000156"))
    A += ["", "COMMIT;"]

    # ── UNDO (논리삭제·물리 DELETE 금지) ──
    U = ["-- UNDO: 접지리플렛·와이드 접지리플렛 완전 견적 종단 적재 되돌리기(논리삭제)",
         "BEGIN;",
         "-- 공식 원복(048): PRF_DGP_E → PRF_FOLD_SUM",
         "UPDATE t_prd_product_price_formulas SET frm_cd='PRF_FOLD_SUM',upd_dt=now() WHERE prd_cd='PRD_000048';",
         "-- L1 processes/sizes 논리삭제(추가분만)"]
    for _, proc in FOLDS_048:
        U.append(f"UPDATE t_prd_product_processes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND proc_cd='{proc}';")
    U.append("UPDATE t_prd_product_processes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND proc_cd='PROC_000004';")
    for siz, _, _, _ in SIZES_048:
        U.append(f"UPDATE t_prd_product_sizes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000048' AND siz_cd='{siz}';")
    U.append("UPDATE t_prd_product_processes SET del_yn='Y',del_dt=now() WHERE prd_cd='PRD_000049' AND proc_cd='PROC_000106';")
    U.append("-- 접지 옵션그룹 논리삭제")
    for prd, grp in fold_undo:
        U.append(f"UPDATE t_prd_product_option_items SET del_yn='Y',del_dt=now() WHERE prd_cd='{prd}' AND opt_cd IN (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='{prd}' AND opt_grp_cd='{grp}');")
        U.append(f"UPDATE t_prd_product_options SET del_yn='Y',del_dt=now() WHERE prd_cd='{prd}' AND opt_grp_cd='{grp}';")
        U.append(f"UPDATE t_prd_product_option_groups SET del_yn='Y',del_dt=now() WHERE prd_cd='{prd}' AND opt_grp_cd='{grp}';")
    U.append("-- 옵션 레이어(인쇄/종이/코팅/후가공) + 코팅 제약 논리삭제")
    for prd, grp_cds in undo_opt:
        gl = ",".join(f"'{g}'" for g in grp_cds)
        U.append(f"UPDATE t_prd_product_option_items SET del_yn='Y',del_dt=now() WHERE prd_cd='{prd}' AND opt_cd IN (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='{prd}' AND opt_grp_cd IN ({gl}));")
        U.append(f"UPDATE t_prd_product_options SET del_yn='Y',del_dt=now() WHERE prd_cd='{prd}' AND opt_grp_cd IN ({gl});")
        U.append(f"UPDATE t_prd_product_option_groups SET del_yn='Y',del_dt=now() WHERE prd_cd='{prd}' AND opt_grp_cd IN ({gl});")
        U.append(f"UPDATE t_prd_product_constraints SET del_yn='Y',del_dt=now() WHERE prd_cd='{prd}' AND rule_cd='R_EXCL_COATING_THIN_PAPER';")
    U.append("COMMIT;")

    with open(os.path.join(D, "apply-full.sql"), "w") as f:
        f.write("\n".join(A) + "\n")
    with open(os.path.join(D, "undo.sql"), "w") as f:
        f.write("\n".join(U) + "\n")
    dry = "\n".join(l if l != "COMMIT;" else "ROLLBACK; -- DRY-RUN: COMMIT 금지" for l in A)
    with open(os.path.join(D, "dryrun.sql"), "w") as f:
        f.write(dry + "\n")

    print(f"apply-full.sql lines={len(A)}  fold_opv 048={opv48} 049={opv49}  next_opv={v}")


if __name__ == "__main__":
    main()
