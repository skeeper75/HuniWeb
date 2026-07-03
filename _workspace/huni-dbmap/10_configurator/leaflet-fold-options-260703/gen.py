#!/usr/bin/env python3
# 접지리플렛(PRD_000048)·와이드 접지리플렛(PRD_000049) CPQ 옵션 레이어 SQL 생성기.
# 라이브 차원행(product_materials/processes/print_options)을 참조만 하고 신규 mint 없음.
# 종이 평량 기반 thin(<180g) 판정 = 047 라이브 검증 리스트를 canonical로 채택(같은 mat_cd=같은 평량).
import csv, os, re

D = os.path.dirname(os.path.abspath(__file__))

# 047 R_EXCL_COATING_THIN_PAPER 라이브 제약이 열거한 thin(<180g) 종이 코드 (검증 권위)
THIN_047 = {"MAT_000072","MAT_000073","MAT_000076","MAT_000077","MAT_000078",
            "MAT_000086","MAT_000087","MAT_000088","MAT_000095","MAT_000096",
            "MAT_000097","MAT_000104","MAT_000105","MAT_000106","MAT_000125"}

def weight_of(name):
    m = re.search(r'(\d+)\s*g', name)
    return int(m.group(1)) if m else None

def is_thin(mat_cd, name):
    w = weight_of(name)
    if w is not None:
        return w < 180
    # 평량이 이름에 없으면 047 검증 리스트로 판정
    return mat_cd in THIN_047

def load_papers(path):
    rows = []
    with open(path) as f:
        for r in csv.reader(f):
            if len(r) < 4: continue
            rows.append({"mat_cd": r[1], "mat_nm": r[2], "dflt": r[3]})
    return rows

class Minter:
    def __init__(self, grp_start, opv_start):
        self.g = grp_start; self.v = opv_start
    def grp(self):
        c = f"OPT_{self.g:06d}"; self.g += 1; return c
    def opv(self):
        c = f"OPV_{self.v:06d}"; self.v += 1; return c

# 코팅/후가공 공정 코드 (라이브 실재, 신규 mint 없음)
COAT_PROC = [("유광", "PROC_000014"), ("무광", "PROC_000015")]
FINISH_PROC = [("가변텍스트", "PROC_000031"), ("가변이미지", "PROC_000032")]
USAGE = "USAGE.07"

def esc(s): return s.replace("'", "''")

def build(prd_cd, prd_nm, papers, minter):
    """returns (apply_lines, undo_grp_cds, undo_opv_cds, opv_map, coat_opv, thin_codes)"""
    A = []
    A.append(f"-- ===== {prd_nm} ({prd_cd}) =====")
    grp_print = minter.grp(); grp_paper = minter.grp(); grp_coat = minter.grp(); grp_fin = minter.grp()
    groups = [
        (grp_print, "인쇄", "SEL_TYPE.01", 1, 1, "Y", 1),
        (grp_paper, "종이", "SEL_TYPE.01", 1, 1, "Y", 2),
        (grp_coat,  "코팅", "SEL_TYPE.01", 0, 1, "N", 3),
        (grp_fin,   "후가공","SEL_TYPE.02", 0, 2, "N", 4),
    ]
    A.append("-- option_groups")
    for gc, nm, sel, mn, mx, mand, seq in groups:
        A.append(
            "INSERT INTO t_prd_product_option_groups "
            "(prd_cd,opt_grp_cd,opt_grp_nm,sel_typ_cd,min_sel_cnt,max_sel_cnt,mand_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES "
            f"('{prd_cd}','{gc}','{nm}','{sel}',{mn},{mx},'{mand}',{seq},'Y','N',now()) "
            "ON CONFLICT (prd_cd,opt_grp_cd) DO UPDATE SET opt_grp_nm=EXCLUDED.opt_grp_nm,"
            "sel_typ_cd=EXCLUDED.sel_typ_cd,min_sel_cnt=EXCLUDED.min_sel_cnt,max_sel_cnt=EXCLUDED.max_sel_cnt,"
            "mand_yn=EXCLUDED.mand_yn,disp_seq=EXCLUDED.disp_seq,use_yn='Y',del_yn='N',upd_dt=now();")

    opv_rows = []   # (opv, grp, nm, dflt, seq)
    item_rows = []  # (opv, item_seq, ref_dim, ref_key1, ref_key2, qty)
    coat_opv = {}   # nm -> opv  (유광/무광)

    # 인쇄 (양면 = opt_id 1)
    v = minter.opv()
    opv_rows.append((v, grp_print, "양면", "Y", 1))
    item_rows.append((v, 1, "OPT_REF_DIM.06", "1", "", 1))

    # 종이 (자재 .03)
    for i, p in enumerate(papers, start=1):
        v = minter.opv()
        dflt = "Y" if i == 1 else "N"
        opv_rows.append((v, grp_paper, p["mat_nm"], dflt, i))
        item_rows.append((v, 1, "OPT_REF_DIM.03", p["mat_cd"], USAGE, 1))

    # 코팅 (코팅없음=item 없음, 유광/무광=공정 .04)
    v = minter.opv(); opv_rows.append((v, grp_coat, "코팅없음", "Y", 1))  # no item
    for j, (nm, proc) in enumerate(COAT_PROC, start=2):
        v = minter.opv(); opv_rows.append((v, grp_coat, nm, "N", j))
        item_rows.append((v, 1, "OPT_REF_DIM.04", proc, "", 1))
        coat_opv[nm] = v

    # 후가공 (택N, 공정 .04)
    for j, (nm, proc) in enumerate(FINISH_PROC, start=1):
        v = minter.opv(); opv_rows.append((v, grp_fin, nm, "N", j))
        item_rows.append((v, 1, "OPT_REF_DIM.04", proc, "", 1))

    A.append("-- options")
    grp_of = {}
    for v, g, nm, dflt, seq in opv_rows:
        grp_of[v] = g
        A.append(
            "INSERT INTO t_prd_product_options "
            "(prd_cd,opt_cd,opt_grp_cd,opt_nm,dflt_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES "
            f"('{prd_cd}','{v}','{g}','{esc(nm)}','{dflt}',{seq},'Y','N',now()) "
            "ON CONFLICT (prd_cd,opt_cd) DO UPDATE SET opt_grp_cd=EXCLUDED.opt_grp_cd,"
            "opt_nm=EXCLUDED.opt_nm,dflt_yn=EXCLUDED.dflt_yn,disp_seq=EXCLUDED.disp_seq,use_yn='Y',del_yn='N',upd_dt=now();")

    A.append("-- option_items")
    for v, seq, rd, k1, k2, qty in item_rows:
        k2sql = f"'{k2}'" if k2 else "NULL"
        A.append(
            "INSERT INTO t_prd_product_option_items "
            "(prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn,del_yn,reg_dt) VALUES "
            f"('{prd_cd}','{v}',{seq},'{rd}','{k1}',{k2sql},{qty},'Y','N',now()) "
            "ON CONFLICT (prd_cd,opt_cd,item_seq) DO UPDATE SET ref_dim_cd=EXCLUDED.ref_dim_cd,"
            "ref_key1=EXCLUDED.ref_key1,ref_key2=EXCLUDED.ref_key2,qty=EXCLUDED.qty,use_yn='Y',del_yn='N',upd_dt=now();")

    # 제약: 코팅 x thin 종이 금지 (RULE_TYPE.02)
    thin = [p["mat_cd"] for p in papers if is_thin(p["mat_cd"], p["mat_nm"])]
    coat_terms = " ".join([f'{{"in":["{coat_opv["유광"]}",{{"var":"sel_opts"}}]}},{{"in":["{coat_opv["무광"]}",{{"var":"sel_opts"}}]}}'])
    mat_terms = ",".join([f'{{"===":[{{"var":"mat_cd__usage_cd"}},"{c}__{USAGE}"]}}' for c in thin])
    logic = ('{"!":{"and":[{"or":[' + coat_terms + ']},{"or":[' + mat_terms + ']}]}}')
    errmsg = "코팅은 두꺼운 종이(180g 이상)에서만 가능합니다. 종이를 180g 이상으로 바꾸거나 코팅을 빼 주세요."
    A.append("-- constraint: R_EXCL_COATING_THIN_PAPER")
    A.append(
        "INSERT INTO t_prd_product_constraints "
        "(prd_cd,rule_cd,rule_nm,rule_typ_cd,logic,err_msg,use_yn,del_yn,reg_dt) VALUES "
        f"('{prd_cd}','R_EXCL_COATING_THIN_PAPER','[제약조건] 코팅은 두꺼운 종이(180g 이상)에서만 가능',"
        f"'RULE_TYPE.02','{logic}'::jsonb,'{esc(errmsg)}','Y','N',now()) "
        "ON CONFLICT (prd_cd,rule_cd) DO UPDATE SET rule_nm=EXCLUDED.rule_nm,rule_typ_cd=EXCLUDED.rule_typ_cd,"
        "logic=EXCLUDED.logic,err_msg=EXCLUDED.err_msg,use_yn='Y',del_yn='N',upd_dt=now();")
    A.append("")
    grp_cds = [g[0] for g in groups]
    opv_cds = [r[0] for r in opv_rows]
    return A, grp_cds, opv_cds, thin

def main():
    p48 = load_papers(os.path.join(D, "data", "048-papers.csv"))
    p49 = load_papers(os.path.join(D, "data", "049-papers.csv"))
    m = Minter(147, 556)
    apply_all = ["-- 접지리플렛/와이드 접지리플렛 CPQ 옵션 레이어 (멱등 UPSERT)",
                 "-- 생성기: gen.py · 라이브 차원행 참조만(신규 차원 mint 없음)",
                 "-- 실행 전제: dimension rows(materials/print_options/processes) 라이브 실재 확인됨",
                 "BEGIN;"]
    undo_all = ["-- UNDO: 접지리플렛/와이드 접지리플렛 옵션 레이어 논리삭제(물리 DELETE 금지)", "BEGIN;"]
    summary = []
    for prd_cd, prd_nm, papers in [("PRD_000048","접지리플렛",p48),("PRD_000049","와이드 접지리플렛",p49)]:
        A, grp_cds, opv_cds, thin = build(prd_cd, prd_nm, papers, m)
        apply_all += A
        # undo (soft-delete)
        gl = ",".join(f"'{g}'" for g in grp_cds)
        undo_all.append(f"UPDATE t_prd_product_option_items SET del_yn='Y',del_dt=now() WHERE prd_cd='{prd_cd}' AND opt_cd IN (SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='{prd_cd}' AND opt_grp_cd IN ({gl}));")
        undo_all.append(f"UPDATE t_prd_product_options SET del_yn='Y',del_dt=now() WHERE prd_cd='{prd_cd}' AND opt_grp_cd IN ({gl});")
        undo_all.append(f"UPDATE t_prd_product_option_groups SET del_yn='Y',del_dt=now() WHERE prd_cd='{prd_cd}' AND opt_grp_cd IN ({gl});")
        undo_all.append(f"UPDATE t_prd_product_constraints SET del_yn='Y',del_dt=now() WHERE prd_cd='{prd_cd}' AND rule_cd='R_EXCL_COATING_THIN_PAPER';")
        summary.append((prd_cd, prd_nm, len(grp_cds), len(opv_cds), len(papers), thin))
    apply_all.append("COMMIT;")
    undo_all.append("COMMIT;")

    with open(os.path.join(D, "apply.sql"), "w") as f: f.write("\n".join(apply_all) + "\n")
    with open(os.path.join(D, "undo.sql"), "w") as f: f.write("\n".join(undo_all) + "\n")
    # dryrun = apply wrapped BEGIN..ROLLBACK
    dry = "\n".join(l if l != "COMMIT;" else "ROLLBACK; -- DRY-RUN: 절대 COMMIT 금지" for l in apply_all)
    with open(os.path.join(D, "dryrun.sql"), "w") as f: f.write(dry + "\n")

    print("=== SUMMARY ===")
    for prd_cd, prd_nm, ng, nv, npap, thin in summary:
        print(f"{prd_nm} ({prd_cd}): groups={ng} options={nv} papers={npap} thin(<180g)={len(thin)} -> {thin}")

if __name__ == "__main__":
    main()
