#!/usr/bin/env python3
"""판걸이수 교정 before/after 검증 — 앵커 상품 시뮬레이터 판수+가격 + fn_calc_pansu 직접."""
import sys, json
sys.path.insert(0,"_workspace/_foundation/batch")
import lib_huni as H
H.load_env()
sim=H.HuniSim()

# 앵커: (prd, siz_cd, 설명)
ANCHORS=[
 ("PRD_000016","SIZ_000003","프리미엄엽서 100x150 (9→8)"),
 ("PRD_000019","SIZ_000003","투명엽서 100x150 (9→8·자재종속 부분교정)"),
 ("PRD_000031","SIZ_000009","프리미엄명함 90x55 (24→21)"),
 ("PRD_000024","SIZ_000012","포토카드 55x86 (25→21)"),
 ("PRD_000043","SIZ_000034","인쇄배경지 76x120 (10→9)"),
 ("PRD_000046","SIZ_000047","라벨택 40x80 (30→24)"),
 ("PRD_000109","SIZ_000071","미니탁상캘린더 148x60 (14→12)"),
]

def defaults(prd, siz):
    """sim-meta 에서 유효 mat/print_opt 기본 픽 + 디지털인쇄 공정."""
    m=sim.sim_meta(prd)
    sel={"siz_cd":siz}
    # print_opt
    for d in (m.get("dims") or []):
        key=d.get("dim") or d.get("ref_dim_cd")
        opts=d.get("options") or d.get("items") or []
        if key=="print_opt_cd" and opts:
            sel["print_opt_cd"]=opts[0].get("code") or opts[0].get("val") or "POPT_000001"
        if key=="mat_cd" and opts:
            sel["mat_cd"]=opts[0].get("code") or opts[0].get("val")
    sel.setdefault("print_opt_cd","POPT_000001")
    return sel, m

def run(tag):
    print(f"\n===== {tag} =====")
    for prd,siz,desc in ANCHORS:
        try:
            sel,_=defaults(prd,siz)
            r=sim.simulate(prd,sel,120,procs=[{"proc_cd":"PROC_000004"}])
            p=H.price_of(r)
            comps=H.components_of(r)
            pansu=next((ps for cc,cn,sub,ps,ok in comps if ps),None)
            print(f"  {prd} {siz} price={p} pansu={pansu}  | {desc}")
        except Exception as e:
            print(f"  {prd} {siz} ERR {e} | {desc}")

if __name__=="__main__":
    tag=sys.argv[1] if len(sys.argv)>1 else "SNAPSHOT"
    run(tag)
