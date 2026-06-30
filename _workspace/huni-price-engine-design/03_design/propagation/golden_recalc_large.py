#!/usr/bin/env python3
# golden_recalc_large.py — 대형 박 골든 재계산 (pricing.py match_component + component_subtotal 순수함수 추적)
#
# 빌더 숫자를 재사용하지 않고, gen_foil_prop 의 flatten 행 위에서 엔진 의미를 밑바닥부터 재구현해
# 골든 케이스를 재계산한다. 검증가(offgrid-flatten-validation-foil.md)의 순수함수 방식 동형.
#
#  match_component (pricing.py:134-190 의미):
#    - siz_width/siz_height = '이하' 상한 ceiling: 주문값 이상 임계 중 '최소'(없으면 ERR_ABOVE_MAX)
#    - min_qty = '이상' 하한 band: 주문수량 이하 임계 중 '최대'(없으면 ERR_BELOW_MIN)
#    - proc_cd = 정확매칭(단가행 proc_cd == 선택값). 미선택이면 그 comp no_match → 0.
#  component_subtotal (.03 PRICE_TYPE_FLAT, pricing.py:203-204): return up,up → ×qty 0 (band total flat).
import sys
sys.path.insert(0, ".")
import gen_foil_prop as G

ROWS = G.build_prices()

def match(comp_cd, proc_cd, w, h, qty):
    """flatten 행에서 (proc_cd, w-ceiling, h-ceiling, minq-band) 매칭 행 단가 반환. no_match=None."""
    grp = [r for r in ROWS if r["comp_cd"] == comp_cd and r["proc_cd"] == proc_cd]
    if not grp:
        return None, "no_proc_match"
    # width ceiling
    ws = sorted({r["siz_width"] for r in grp if r["siz_width"] is not None})
    hs = sorted({r["siz_height"] for r in grp if r["siz_height"] is not None})
    sel = {}
    if ws:
        elig = [t for t in ws if t >= w]
        if not elig: return None, "ERR_ABOVE_MAX_W"
        sel["w"] = min(elig)
    if hs:
        elig = [t for t in hs if t >= h]
        if not elig: return None, "ERR_ABOVE_MAX_H"
        sel["h"] = min(elig)
    # min_qty band (only for PROC comps; SETUP has min_qty NULL)
    mqs = sorted({r["min_qty"] for r in grp if r["min_qty"] is not None})
    if mqs:
        elig = [t for t in mqs if t <= qty]
        if not elig: return None, "ERR_BELOW_MIN"
        sel["mq"] = max(elig)
    # find row
    for r in grp:
        if r.get("siz_width") == sel.get("w") and r.get("siz_height") == sel.get("h"):
            if "mq" in sel:
                if r.get("min_qty") == sel["mq"]:
                    return r["unit_price"], f"({sel.get('w')},{sel.get('h')},band{sel['mq']})"
            else:
                if r.get("min_qty") is None:
                    return r["unit_price"], f"({sel.get('w')},{sel.get('h')},setup)"
    return None, "no_tier_row"

def foil_total(proc_cd, group, w, h, qty):
    """동판비(SETUP_LARGE) + 박가공비(group=STD|SPECIAL). .03 FLAT → ×qty 0."""
    setup, s_meta = match("COMP_FOIL_SETUP_LARGE", proc_cd, w, h, qty)
    pcomp = "COMP_FOIL_PROC_LARGE_STD" if group == "STD" else "COMP_FOIL_PROC_LARGE_SPECIAL"
    proc, p_meta = match(pcomp, proc_cd, w, h, qty)
    if setup is None or proc is None:
        return 0, f"no_match (setup={s_meta}, proc={p_meta})"
    return setup + proc, f"동판{setup}{s_meta} + 박가공{proc}{p_meta}"

CASES = [
    # (name, proc_cd, group, w, h, qty, expected, note)
    ("G-F1  대형 STD 금유광 90x90 q1000",       "PROC_000038","STD",     90, 90,1000, 138000, ""),
    ("G-F2  대형 SPECIAL 홀로 90x90 q1000",      "PROC_000037","SPECIAL", 90, 90,1000, 168000, ""),
    ("G-F3  대형 STD 은유광 30x30 q10",          "PROC_000039","STD",     30, 30,  10,  66000, ""),
    ("G-F7  대형 SPECIAL 백박→먹유광 170x170 q1000","PROC_000040","SPECIAL",170,170,1000, 314000, "백박046 미등록→먹유광040(동일 SPECIAL E단가)"),
    ("G-F6  off-grid 75x85→ceiling90x90 STD q1000","PROC_000038","STD",   75, 85,1000, 138000, "off-grid 각축 ceiling"),
    ("G-F10 off-band 90x90 q1500(band1000) STD",  "PROC_000038","STD",    90, 90,1500, 138000, ".03 FLAT off-band"),
    ("off-band q899→band500 STD 90x90 q899 회귀",  "PROC_000038","STD",    90, 90, 899, 118000, "band500: C@500=100000+동판18000=118000(.02면 과청구)"),
    ("on-band q500 STD 90x90 q500 (위 회귀 짝)",   "PROC_000038","STD",    90, 90, 500, 118000, "q500=q899 동일=.03 FLAT 입증"),
    ("박-미선택(proc_cd=None) → 0",              None,         "STD",      90, 90,1000,      0, "박 미선택 no_match→0"),
    ("미등록 백박046 직접 → 0",                  "PROC_000046","SPECIAL", 90, 90,1000,      0, "백박046 단가행 미생성→no_match→0"),
]

def main():
    print("=== 대형 박 골든 재계산 (pricing.py 순수함수·flatten 행 추적) ===")
    print(f"{'케이스':<46} {'재계산':>10} {'기대':>10}  판정")
    allpass = True
    for name, proc, grp, w, h, qty, exp, note in CASES:
        if proc is None:
            total, meta = 0, "박 미선택"
        else:
            total, meta = foil_total(proc, grp, w, h, qty)
        ok = (total == exp)
        # off-band q899 special: band for q899 is 500 (≤899 max band among {10,200,500,1000,...}). recompute expected dynamically
        allpass = allpass and ok
        flag = "PASS" if ok else "**FAIL**"
        print(f"{name:<46} {total:>10} {exp:>10}  {flag}   {meta}{('  | '+note) if note else ''}")
    print("\n전체:", "ALL PASS" if allpass else "SOME FAIL")
    return 0 if allpass else 1

if __name__ == "__main__":
    sys.exit(main())
