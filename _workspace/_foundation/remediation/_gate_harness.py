#!/usr/bin/env python3
# 게이트 차원 커버리지 재현 — pricing.py 의 순수 매칭 함수를 verbatim 이식(드리프트 0).
import json
from decimal import Decimal

NON_QTY_DIMS = ("siz_cd", "plt_siz_cd", "print_opt_cd", "mat_cd", "proc_cd", "opt_cd",
                "clr_cd", "coat_side_cnt", "bdl_qty")
TIER_DIMS = ("siz_width", "siz_height", "min_qty")
TIER_UPPER = ("siz_width", "siz_height")
ERR_ABOVE_MAX = "above_max_size"
ERR_BELOW_MIN = "below_min_qty"
ERR_AMBIGUOUS = "ambiguous"
ERR_DUPLICATE = "duplicate"

def _norm(v):
    return None if v is None else str(v)

def _dv_key(row):
    return json.dumps(row.get("dim_vals") or {}, sort_keys=True, ensure_ascii=False)

def _row_matches(row, selections):
    for d in NON_QTY_DIMS:
        rv = row.get(d)
        if rv is None:
            continue
        if _norm(selections.get(d)) != _norm(rv):
            return False
    for k, v in (row.get("dim_vals") or {}).items():
        if _norm(selections.get(k)) != _norm(v):
            return False
    return True

def _combo_key(row):
    return tuple(_norm(row.get(d)) for d in NON_QTY_DIMS) + (_dv_key(row),)

def _tier_val(v, upper=False):
    if v in (None, ""):
        return Decimal("Infinity") if upper else Decimal(0)
    return Decimal(str(v))

def _tier_order_val(dim, selections, qty):
    if dim == "min_qty":
        return Decimal(qty)
    v = selections.get(dim)
    if v in (None, ""):
        return None
    try:
        return Decimal(str(v))
    except Exception:
        return None

def match_component(rows, selections, qty, as_of):
    cand = [r for r in rows
            if (r.get("apply_ymd") or "") <= as_of and _row_matches(r, selections)]
    if not cand:
        return {"row": None, "error": None, "reason": "no_match"}
    combos = {}
    for r in cand:
        combos.setdefault(_combo_key(r), []).append(r)
    if len(combos) > 1:
        return {"row": None, "error": ERR_AMBIGUOUS, "combos": list(combos.keys())}
    grp = next(iter(combos.values()))
    selected = {}
    for dim in TIER_DIMS:
        upper = dim in TIER_UPPER
        ov = _tier_order_val(dim, selections, qty)
        cmp_val = ov if ov is not None else Decimal(0)
        tiers = sorted({_tier_val(r.get(dim), upper) for r in grp})
        if upper:
            eligible = [t for t in tiers if t >= cmp_val]
            if not eligible:
                return {"row": None, "error": ERR_ABOVE_MAX, "max_allowed": str(max(tiers)), "above_dim": dim}
            selected[dim] = min(eligible)
        else:
            eligible = [t for t in tiers if t <= cmp_val]
            if not eligible:
                return {"row": None, "error": ERR_BELOW_MIN, "min_required": str(min(tiers)), "below_dim": dim}
            selected[dim] = max(eligible)
    tier_rows = [r for r in grp
                 if all(_tier_val(r.get(d), d in TIER_UPPER) == selected[d] for d in TIER_DIMS)]
    if not tier_rows:
        return {"row": None, "error": None, "reason": "no_tier_row",
                "selected_w": str(selected["siz_width"]), "selected_h": str(selected["siz_height"])}
    best = max(tier_rows, key=lambda r: r.get("apply_ymd") or "")
    same = [r for r in tier_rows if (r.get("apply_ymd") or "") == (best.get("apply_ymd") or "")]
    if len(same) > 1:
        return {"row": None, "error": ERR_DUPLICATE}
    return {"row": best, "error": None}

clr = json.load(open("/tmp/clr3t_rows.json"))
cor = json.load(open("/tmp/corotto_rows.json"))
prods = json.load(open("/tmp/prods.json"))
AS_OF = "2026-06-26"
QTY = 1

COMP = {
  "PRF_CLR_ACRYL": {"rows": clr, "needs_mat": True},
  "PRF_COROTTO_ACRYL": {"rows": cor, "needs_mat": False},
}
PRD_FRM = {p: "PRF_COROTTO_ACRYL" if p == "PRD_000164" else "PRF_CLR_ACRYL"
           for p in [pr["prd_cd"] for pr in prods]}

print(f"{'prd':12} {'ns':3} {'verdict':8} detail")
verdicts = {}
for pr in sorted(prods, key=lambda x: x["prd_cd"]):
    prd = pr["prd_cd"]
    frm = PRD_FRM[prd]
    rows = COMP[frm]["rows"]
    needs_mat = COMP[frm]["needs_mat"]
    dflt_mat = pr.get("dflt_mat")
    ns = pr["nonspec_yn"]
    fails = []
    cases = []
    if ns == "Y":
        wmn, wmx, hmn, hmx = pr["wmn"], pr["wmx"], pr["hmn"], pr["hmx"]
        for w in (wmn, wmx):
            for h in (hmn, hmx):
                cases.append((f"ns {w}x{h}", w, h))
    else:
        for s in (pr.get("sizes") or []):
            cases.append((f"siz {s['siz_nm']}", s["cut_width"], s["cut_height"]))
    for label, w, h in cases:
        sel = {}
        if needs_mat and dflt_mat:
            sel["mat_cd"] = dflt_mat
        if w is not None:
            sel["siz_width"] = w
        if h is not None:
            sel["siz_height"] = h
        m = match_component(rows, sel, QTY, AS_OF)
        if m["row"] is None:
            reason = m.get("error") or m.get("reason")
            extra = ""
            if reason == "no_tier_row":
                extra = f"(ceil->{m['selected_w']}x{m['selected_h']} 행없음)"
            elif m.get("error") == ERR_ABOVE_MAX:
                extra = f"(>{m['max_allowed']} {m['above_dim']})"
            fails.append(f"{label}:{reason}{extra}")
    verdict = "GO" if not fails else "NO-GO"
    eng_note = " [엔진주의:siz_cd모드-실엔진은w/h미주입]" if ns == "N" else ""
    verdicts[prd] = (verdict, fails, ns)
    print(f"{prd:12} {ns:3} {verdict:8} {('OK' if not fails else '; '.join(fails))}{eng_note}")

print("\n=== 요약(cut_width/height 공급 가정) ===")
go = [p for p,(v,f,n) in verdicts.items() if v=="GO"]
nogo = [p for p,(v,f,n) in verdicts.items() if v=="NO-GO"]
print("GO:", go)
print("NO-GO:", nogo)

print("\n=== nonspec=Y 상품: 선언 범위 내 전수 스윕(incr 격자) 커버 검증 ===")
# incr 격자로 nonspec 범위 전수 — 실제 주문가능한 모든 (w,h)가 매트릭스에 ceil 매칭되는지
prod_meta = {pr["prd_cd"]: pr for pr in prods}
# incr 가져오기 위해 재덤프 필요 — 여기서는 5mm 격자로 근사 스윕(보수적)
import itertools
for pr in sorted(prods, key=lambda x: x["prd_cd"]):
    if pr["nonspec_yn"] != "Y": continue
    prd = pr["prd_cd"]; frm = PRD_FRM[prd]; rows = COMP[frm]["rows"]
    needs_mat = COMP[frm]["needs_mat"]; dflt_mat = pr.get("dflt_mat")
    wmn,wmx,hmn,hmx = pr["wmn"],pr["wmx"],pr["hmn"],pr["hmx"]
    ws = [wmn + 5*i for i in range(int((wmx-wmn)//5)+1)] + [wmx]
    hs = [hmn + 5*i for i in range(int((hmx-hmn)//5)+1)] + [hmx]
    total=0; bad=0; badset=[]
    for w in sorted(set(ws)):
        for h in sorted(set(hs)):
            total+=1
            sel={}
            if needs_mat and dflt_mat: sel["mat_cd"]=dflt_mat
            sel["siz_width"]=w; sel["siz_height"]=h
            m=match_component(rows, sel, QTY, AS_OF)
            if m["row"] is None:
                bad+=1
                if len(badset)<6: badset.append(f"{w}x{h}:{m.get('error') or m.get('reason')}")
    cov = 100*(total-bad)/total if total else 0
    print(f"{prd}  격자{total}점  미커버 {bad}  커버율 {cov:.0f}%  예) {'; '.join(badset)}")

print("\n=== 선례 146 동일 매트릭스 커버 스윕(parity 입증) ===")
import urllib.request  # noop
def sweep(wmn,wmx,hmn,hmx,rows,mat):
    total=bad=0
    for wi in range(int((wmx-wmn)//5)+1):
        for hi in range(int((hmx-hmn)//5)+1):
            w=wmn+5*wi; h=hmn+5*hi; total+=1
            sel={"mat_cd":mat,"siz_width":w,"siz_height":h}
            if match_component(rows,sel,1,"2026-06-26")["row"] is None: bad+=1
    return total,bad
t,b=sweep(20,100,20,100,clr,"MAT_000043")
print(f"PRD_000146(라이브 선례) 격자{t} 미커버{b} 커버율{100*(t-b)/t:.0f}%")
