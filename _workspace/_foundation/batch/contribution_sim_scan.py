#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""구성요소 런타임 기여 0(silent-0) — simulate 기반 진짜 검출기. §27 배선 F층 v2.

정적 contribution_scan(proc-coverage)은 위젯의 부모→자식 proc 해소·proc detail(줄수)·
base-proc 주입을 못 봐 오시/미싱을 과적발했다(§14 진단·simulate 확증으로 거짓 결함 판명).
진실 오라클 = evaluate_price. ★뷰어 selection 을 충실히 재현한다 — sim_meta 가 주는
부모→자식 해소된 proc 옵션 + detail 스펙 + dflt 를 그대로 써서 "모든 옵션을 선택한"
완전 selection 으로 simulate 하고, 그래도 기여 0인 비목을 잡는다.

판정:
  CORE_ZERO(HIGH)  : 코어 비목(인쇄/용지/제본 등 항상 필요)이 기여 0 → 확정 silent-0(저청구/견적불가)
  PROC_ZERO(HIGH)  : 그 비목의 proc 를 selection 에 넣었는데도 기여 0 → 트리거 선택했으나 미가격
  OPT_NOTSEL(REVIEW): 트리거(코팅 면수·옵션 등 fk차원)를 못 넣어 미검증 → 후보

세트(is_set)는 simulate-set 경로라 분리(SET-SKIP). 미바인딩(공식0)은 wiring_scan 담당.

[HARD] 라이브 읽기전용(simulate=읽기). DB 미적재. 교정은 §18→§7 인간 승인.
재실행: python3 contribution_sim_scan.py [prd_cd] [--qty N] [--snap dir]
"""
from __future__ import annotations
import csv, json, pathlib, re, sys
import lib_huni as H

# 변형(택일) 토큰 — 단면/양면·등급·코팅종류 등. base 비목명 도출용(변형 그룹화).
_VARIANT = re.compile(r'단면|양면|유광|무광|무코팅|홀로그램|홀로|트윙클|은유광|일반|MGA|MGB|S1|S2|\(용지포함\)|·')


def _base_name(nm):
    s = _VARIANT.sub('', nm or '')
    s = re.sub(r'[AB](?=\s|완|$|\()', '', s)   # 등급 A/B
    return re.sub(r'\s+', '', s)

HERE = pathlib.Path(__file__).resolve().parent
FND = HERE.parent
SNAP_ROOT = FND / "live-snapshot"
OUT_DIR = HERE / "wiring"
CORE_KW = ("인쇄", "용지", "제본")
NOTDEL = lambda r: r.get("del_yn", "N") != "Y"


def _read_csv(p):
    if not p.exists():
        return []
    with p.open(encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))


def resolve_snap(arg):
    if arg:
        q = pathlib.Path(arg)
        if q.exists():
            return q
        return SNAP_ROOT / arg if (SNAP_ROOT / arg).exists() else None
    latest = SNAP_ROOT / "latest"
    return latest.resolve() if latest.exists() else (sorted(SNAP_ROOT.glob("snap_*")) or [None])[-1]


def _detail_value(spec):
    """proc detail 입력스펙 → 대표값(트리거 발현용·0 아님)."""
    out = {}
    for inp in spec or []:
        k = inp.get("key")
        if not k:
            continue
        t = inp.get("type")
        vals = inp.get("values")
        if vals:
            out[k] = vals[0]
        elif t == "integer" or t == "number":
            out[k] = min(int(inp.get("max") or 1), 1) or 1   # 1줄/1개(발현)
        elif t == "boolean":
            out[k] = "Y"
        else:
            out[k] = "1"
    return out


def build_selection(meta):
    """sim_meta → (selection, proc_sels). fk=dflt(없으면 첫), proc=전 옵션 detail 채워 발현."""
    sel = {}
    proc_sels = []
    for d in meta.get("prod_dims", []):
        opts = d.get("options") or []
        if not opts:
            continue
        if d.get("kind") == "proc":
            for o in opts:
                proc_sels.append({"proc_cd": o["v"], "detail": _detail_value(o.get("detail"))})
        else:
            dflt = next((o["v"] for o in opts if o.get("dflt")), opts[0]["v"])
            sel[d["name"]] = dflt
    # 비규격(자유치수) — nonspec 범위 중앙값 공급(있으면)
    ns = meta.get("nonspec") or {}
    if ns.get("enabled") or ns.get("nonspec_yn") == "Y":
        for axis, lo, hi in (("siz_width", "width_min", "width_max"),
                             ("siz_height", "height_min", "height_max")):
            mn, mx = ns.get(lo), ns.get(hi)
            if mn and mx:
                sel[axis] = int((float(mn) + float(mx)) / 2)
    return sel, proc_sels


def scan(prd_only, qty, snap):
    fc = _read_csv(snap / "t_prc_formula_components.csv")
    cp = _read_csv(snap / "t_prc_component_prices.csv")
    pcs = _read_csv(snap / "t_prc_price_components.csv")
    pf = _read_csv(snap / "t_prd_product_price_formulas.csv")
    comp_nm = {r["comp_cd"]: r.get("comp_nm", "") for r in pcs if r.get("comp_cd")}
    comp_del = {r["comp_cd"] for r in pcs if r.get("del_yn") == "Y"}
    rows_cnt = {}
    for r in cp:
        c = r.get("comp_cd")
        if c:
            rows_cnt[c] = rows_cnt.get(c, 0) + 1
    comp_procs = {}
    for r in cp:
        c, pc = r.get("comp_cd"), r.get("proc_cd")
        if c and pc:
            comp_procs.setdefault(c, set()).add(pc)
    frm_comps = {}
    for r in fc:
        f, c = r.get("frm_cd"), r.get("comp_cd")
        if f and c:
            frm_comps.setdefault(f, []).append(c)
    prod_frm = {}
    for r in pf:
        p, f = r.get("prd_cd"), r.get("frm_cd")
        if p and f:
            prod_frm.setdefault(p, f)

    sim = H.HuniSim()
    targets = [prd_only] if prd_only else sorted(prod_frm)
    defects, prod_rows, errors, sets = [], [], [], []

    for prd in targets:
        frm = prod_frm.get(prd)
        if not frm:
            continue
        try:
            meta = sim.sim_meta(prd)
        except Exception as e:
            errors.append({"prd_cd": prd, "stage": "meta", "error": str(e)[:100]}); continue
        if meta.get("is_set"):
            sets.append(prd); continue
        sel, proc_sels = build_selection(meta)
        sel_procs = {p["proc_cd"] for p in proc_sels}
        try:
            res = sim.simulate(prd, sel, qty, procs=proc_sels or None)
        except Exception as e:
            errors.append({"prd_cd": prd, "stage": "sim", "error": str(e)[:100]}); continue
        contributed = {}
        for cc, cn, sub, p, ok in H.components_of(res):
            try:
                s = float(sub) if sub is not None else 0
            except (TypeError, ValueError):
                s = 0
            if ok and s > 0:
                contributed[cc] = s
        wired = [c for c in frm_comps.get(frm, [])
                 if c not in comp_del and rows_cnt.get(c, 0) > 0]
        # ★변형(택일) 그룹 가드: 같은 base 비목(단면/양면·등급 A/B·유광/무광 변형)은 한 selection 에
        #   하나만 매칭(나머지 0 정상). base 그룹 중 하나라도 기여하면 그 그룹 전체 제외(FP 방지).
        grp_contributed = {}
        for c in wired:
            b = _base_name(comp_nm.get(c, ""))
            grp_contributed[b] = grp_contributed.get(b, False) or (c in contributed)
        n_def = 0
        for c in wired:
            if c in contributed:
                continue
            nm = comp_nm.get(c, "")
            if grp_contributed.get(_base_name(nm)):
                continue   # 같은 변형그룹의 다른 비목이 기여 = 택일 정상
            core = any(k in nm for k in CORE_KW) and "별색" not in nm
            proc_exercised = bool(comp_procs.get(c, set()) & sel_procs)
            if core:
                kind, conf = "CORE_ZERO", "HIGH"
            elif proc_exercised:
                kind, conf = "PROC_ZERO", "HIGH"
            else:
                kind, conf = "OPT_NOTSEL", "REVIEW"
            defects.append([prd, frm, c, nm, rows_cnt.get(c, 0), kind, conf])
            if conf == "HIGH":
                n_def += 1
        prod_rows.append({"prd_cd": prd, "frm_cd": frm, "final_price": H.price_of(res),
                          "wired": len(wired), "contributed": len(contributed), "high_zero": n_def})

    hi = sum(1 for d in defects if d[6] == "HIGH")
    summary = {
        "snap": snap.name, "qty": qty, "scanned": len(prod_rows),
        "set_skipped": len(sets), "errors": len(errors),
        "high_silent_zero": hi,
        "high_products": len({d[0] for d in defects if d[6] == "HIGH"}),
        "review": sum(1 for d in defects if d[6] == "REVIEW"),
        "verdict": "GO(코어 기여 정합)" if hi == 0 else f"NO-GO(코어 silent-0 {hi}건)",
    }
    return {"summary": summary, "defects": defects, "products": prod_rows,
            "errors": errors, "sets": sets}


def main():
    args = sys.argv[1:]
    prd_only, qty, snap_arg = None, 100, None
    i = 0
    while i < len(args):
        a = args[i]
        if a == "--qty" and i + 1 < len(args):
            qty = int(args[i+1]); i += 2
        elif a == "--snap" and i + 1 < len(args):
            snap_arg = args[i+1]; i += 2
        elif not a.startswith("--"):
            prd_only = a; i += 1
        else:
            i += 1
    H.load_env()
    snap = resolve_snap(snap_arg)
    if not snap:
        sys.exit("스냅샷 없음")
    r = scan(prd_only, qty, snap)
    s = r["summary"]
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    with (OUT_DIR / "sim-contribution-defects.csv").open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["prd_cd", "frm_cd", "comp_cd", "comp_nm", "price_rows", "kind", "conf"])
        w.writerows(r["defects"])
    (OUT_DIR / "sim-contribution-summary.json").write_text(
        json.dumps(r, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"[sim_scan] snap={s['snap']} scanned={s['scanned']} set_skip={s['set_skipped']} "
          f"err={s['errors']} CORE/PROC_ZERO(HIGH)={s['high_silent_zero']}"
          f"({s['high_products']}상품) REVIEW={s['review']} => {s['verdict']}")
    print(f"  -> {OUT_DIR/'sim-contribution-defects.csv'}")


if __name__ == "__main__":
    main()
