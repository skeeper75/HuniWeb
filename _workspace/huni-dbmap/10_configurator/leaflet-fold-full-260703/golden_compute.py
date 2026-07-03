#!/usr/bin/env python3
# 048 완전 견적 골든 = 엔진 산식 결정론 복제(라이브 단가행 실측) — COMMIT 전 예측.
# 산식 모델은 라이브 047/049 시뮬레이터 골든으로 검증(오차 0)한 뒤 048에 적용.
import sys, math, os
sys.path.insert(0, "/Users/innojini/Dev/HuniWeb/_workspace/_foundation/batch")
from lib_huni import load_env, db
load_env()

def q1(sql):
    r = db(sql); return r[0] if r else None

def unit_print(plt, popt, plates):
    return float(q1(f"select unit_price from t_prc_component_prices where comp_cd='COMP_PRINT_DIGITAL_S1' and plt_siz_cd='{plt}' and print_opt_cd='{popt}' and min_qty<={plates} order by min_qty desc limit 1")[0])

def unit_paper(plt, mat):
    return float(q1(f"select unit_price from t_prc_component_prices where comp_cd='COMP_PAPER' and plt_siz_cd='{plt}' and mat_cd='{mat}' order by min_qty desc limit 1")[0])

def unit_coat(comp, plt, side, plates):
    r = q1(f"select unit_price from t_prc_component_prices where comp_cd='{comp}' and plt_siz_cd='{plt}' and coat_side_cnt={side} and min_qty<={plates} order by min_qty desc limit 1")
    return float(r[0]) if r else None

def unit_fold(comp, proc, qty):
    return float(q1(f"select unit_price from t_prc_component_prices where comp_cd='{comp}' and proc_cd='{proc}' and min_qty<={qty} order by min_qty desc limit 1")[0])

def pansu(plt, item):
    return int(q1(f"select fn_calc_pansu('{plt}','{item}')")[0])

def price(plt, item_siz, popt, mat, qty, fold=None, coat=None, coat_side=2):
    ps = pansu(plt, item_siz); plates = math.ceil(qty/ps)
    ip = unit_print(plt, popt, plates); pr = round(ip*plates)
    up = unit_paper(plt, mat); pp = round(up*plates)
    total = pr + pp; parts = [("인쇄비", pr, f"{ip}×{plates}매(판걸이{ps})")]
    parts.append(("용지비", pp, f"{up}×{plates}매"))
    if fold:
        comp, proc = fold; uf = unit_fold(comp, proc, qty); fp = round(uf*qty)
        total += fp; parts.append(("접지비", fp, f"{uf}×{qty}부"))
    if coat:
        comp, proc = coat; uc = unit_coat(comp, plt, coat_side, plates); cp = round(uc*plates)
        total += cp; parts.append(("코팅비", cp, f"{uc}×{plates}매(면수{coat_side})"))
    return total, ps, parts

PLT48 = "SIZ_000499"  # 국4절 316x467
FOLD = {"반접지":("COMP_FOLD_LEAF_HALF","PROC_000107"), "3단":("COMP_FOLD_LEAF_3FOLD","PROC_000060"),
        "병풍":("COMP_FOLD_LEAF_4ACC","PROC_000071"), "대문":("COMP_FOLD_LEAF_4GATE","PROC_000106")}

print("=== 모델 검증(라이브 시뮬레이터 골든 대조) ===")
# 047 A4 MAT_074 양면 1000 무접지무코팅 → 라이브 225,320
t,ps,parts = price(PLT48,"SIZ_000172","POPT_000002","MAT_000074",1000)
print(f"[검증]047 A4/백모220/양면/1000  예측={t}  (라이브 225,320)  {'OK' if t==225320 else 'MISMATCH'}")
# 049 3절 MAT_083 양면 3단 1000 → 라이브 639,540
t,ps,parts = price("SIZ_000475","SIZ_000055","POPT_000002","MAT_000083",1000,fold=FOLD["3단"])
print(f"[검증]049 3절/아트150/양면/3단/1000  예측={t}  (라이브 639,540)  {'OK' if t==639540 else 'MISMATCH'}")

print("\n=== 048 접지리플렛 완전 견적 골든(예측) ===")
cases = [
 ("A4 / 아트지150(thin,무코팅) / 양면 / 3단접지 / 1000부", "SIZ_000051","MAT_000078",1000,FOLD["3단"],None),
 ("A4 / 아트지250 / 양면 / 3단접지 / 유광양면코팅 / 1000부", "SIZ_000051","MAT_000081",1000,FOLD["3단"],("COMP_COAT_GLOSSY","PROC_000014")),
 ("A5 / 아트지250 / 양면 / 반접지 / 1000부", "SIZ_000049","MAT_000081",1000,FOLD["반접지"],None),
 ("A3 / 스노우지250 / 양면 / 4단대문접지 / 500부", "SIZ_000054","MAT_000091",500,FOLD["대문"],None),
]
for label, siz, mat, qty, fold, coat in cases:
    t,ps,parts = price(PLT48,siz,"POPT_000002",mat,qty,fold=fold,coat=coat)
    print(f"\n{label}\n  = {t:,}원  (판걸이 {ps})")
    for nm,amt,how in parts:
        print(f"    {nm:6s} {amt:>10,}  [{how}]")

print("\n=== 049 신규 대문접지 골든(PROC_000106 보강 후) ===")
t,ps,parts = price("SIZ_000475","SIZ_000055","POPT_000002","MAT_000083",1000,fold=FOLD["대문"])
print(f"3절 / 아트지150 / 양면 / 4단대문접지 / 1000부 = {t:,}원 (판걸이 {ps})")
for nm,amt,how in parts: print(f"    {nm:6s} {amt:>10,}  [{how}]")
