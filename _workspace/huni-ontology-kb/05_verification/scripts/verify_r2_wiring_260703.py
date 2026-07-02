#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_r2_wiring_260703.py — R2 배선 교정 재현 검증(결정론·토큰0).

라운드2 결함(V2-01/V2-02 016 공정 배선·V2-03 041 085 환각·V2-05 016 addon tmpl)의
"라이브 진실 vs 그래프 배선" 대조를 스크립트로 재현한다(builder 손전사 방지).

라이브 진실 = _foundation/live-snapshot/latest/*.csv (del_yn≠Y)
그래프 배선 = 04_graph/graph.db (build_graph.py 산출)
기대: 016 has_process={7공정 라이브}·041 has_process={5공정 라이브}·085 상품바인딩=0·016 addon tmpl={005,006,009,038,039}.

사용: python3 05_verification/scripts/verify_r2_wiring_260703.py
"""
import os, csv, sqlite3, sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SNAP = os.path.abspath(os.path.join(ROOT, "../_foundation/live-snapshot/latest"))
DB = os.path.join(ROOT, "04_graph", "graph.db")


def live_procs(prd):
    f = os.path.join(SNAP, "t_prd_product_processes.csv")
    return sorted({r["proc_cd"] for r in csv.DictReader(open(f))
                   if r.get("prd_cd") == prd and r.get("del_yn") != "Y"})


def live_addons(prd):
    f = os.path.join(SNAP, "t_prd_product_addons.csv")
    return sorted({r["tmpl_cd"] for r in csv.DictReader(open(f))
                   if r.get("prd_cd") == prd and r.get("del_yn") != "Y"})


def proc85_bindings():
    f = os.path.join(SNAP, "t_prd_product_processes.csv")
    return sum(1 for r in csv.DictReader(open(f))
               if r.get("proc_cd") == "PROC_000085" and r.get("del_yn") != "Y")


def graph_procs(node):
    con = sqlite3.connect(DB)
    rows = con.execute("SELECT dst FROM edge WHERE src=? AND rel='has_process'", (node,)).fetchall()
    con.close()
    # dst = process-PROC_XXXX → PROC_XXXX 추출 (r[0]=문자열 dst)
    return sorted(r[0].replace("process-", "") for r in rows)


def main():
    fails = []
    # 016
    lp16 = live_procs("PRD_000016")
    gp16 = graph_procs("product-016-premium-postcard")
    print(f"[016] live has_process = {lp16}")
    print(f"[016] graph has_process = {gp16}")
    if lp16 != gp16:
        fails.append(f"016 has_process 불일치 live={lp16} graph={gp16}")
    # 041
    lp41 = live_procs("PRD_000041")
    gp41 = graph_procs("product-041-coupon")
    print(f"[041] live has_process = {lp41}")
    print(f"[041] graph has_process = {gp41}")
    if lp41 != gp41:
        fails.append(f"041 has_process 불일치 live={lp41} graph={gp41}")
    # PROC_000085 상품 바인딩 = 0 (환각 방지)
    b85 = proc85_bindings()
    print(f"[085] live product bindings = {b85} (기대 0)")
    if b85 != 0:
        fails.append(f"PROC_000085 상품 바인딩 {b85}≠0")
    con = sqlite3.connect(DB)
    g85 = con.execute("SELECT count(*) FROM edge WHERE rel='has_process' AND dst='process-PROC_000085'").fetchone()[0]
    con.close()
    print(f"[085] graph has_process→085 = {g85} (기대 0·환각 배선 없음)")
    if g85 != 0:
        fails.append(f"graph has_process→085 {g85}≠0(환각 배선 잔존)")
    # 016 addon
    la16 = live_addons("PRD_000016")
    print(f"[016] live addon tmpl = {la16}")
    if la16 != ["TMPL-000005", "TMPL-000006", "TMPL-000009", "TMPL-000038", "TMPL-000039"]:
        fails.append(f"016 addon tmpl 예상과 다름: {la16}")

    print()
    if fails:
        print("VERDICT: FAIL")
        for f in fails:
            print(" -", f)
        sys.exit(1)
    print("VERDICT: PASS (라이브↔그래프 배선 전수 정합·085 환각 0)")


if __name__ == "__main__":
    main()
