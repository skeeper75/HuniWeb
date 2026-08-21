#!/usr/bin/env python3
"""build_wiring_health.py — 상품별 wiring-health JSON 조립 (SPEC-WIDGET-WIRING-001 M4).

입력: live-snapshot CSV(계층·단가행) + out/sim-meta/*.json(위젯 가시 계층) +
      out/defects/widget-defects.jsonl(M2) + out/defects/price-defects.jsonl(M1 승계).
출력: out/wiring-health/<prd_cd>.json (spec §5 스키마) + out/wiring-health-index.json.

[HARD] 판정은 센서 Defect 승계(재판정 금지). 본 스크립트는 조립·집계만.
reachable_ratio 는 verify_price_coverage 의 any-row-exists 판정을 같은 스냅샷 조인으로
집계한 비율이다(재판정 아님 — 센서 상수·조인 verbatim, tools/verify_price_coverage.py:48-55).

verdict(R5): BROKEN=치명(ANCHOR_DELETED·ZERO_FINAL·NO_SOURCE·NO_FORMULA·ORPHAN·SIM_META_ERROR)
1건 이상 · WARN=비치명만 · OK=단절 0.
"""
from __future__ import annotations
import csv
import json
import pathlib
from collections import Counter, defaultdict

HERE = pathlib.Path(__file__).resolve()
WS = HERE.parent.parent                                   # _workspace/huni-widget-wiring
FND = WS.parent / "_foundation"
SNAP = (FND / "live-snapshot" / "latest").resolve()

EDGES = ["W1", "W2", "W3", "W4", "W5", "C1", "E1", "E2", "E3", "E4"]
FATAL_CODES = {"ANCHOR_DELETED", "ZERO_FINAL", "NO_SOURCE", "NO_FORMULA", "ORPHAN"}

# M1 hdx 보드 차원 → 엣지 매핑(plan §3 승계표)
HDX_EDGE = {"wiring": "E2", "dim_conformance": "E3", "calcability": "E4",
            "option_cpq": "W5", "qty_rule": "E4", "platesize": "E3",
            "price_grid": "E4", "contribution": "E4", "component_merge": "E2",
            "registration": "W5", "linkage": "E2"}

# ref_dim_cd 7차원 매핑 — verify_option_ref_integrity.py:78-95 정본 인용(재정의 아님).
REF_DIM = {
    "OPT_REF_DIM.01": ("siz_cd", "t_prd_product_sizes", "siz_cd"),
    "OPT_REF_DIM.02": ("plt_siz_cd", "t_prd_product_plate_sizes", "siz_cd"),
    "OPT_REF_DIM.03": ("mat_cd", "t_prd_product_materials", "mat_cd"),
    "OPT_REF_DIM.04": ("proc_cd", "t_prd_product_processes", "proc_cd"),
    "OPT_REF_DIM.05": ("bdl_qty", "t_prd_product_bundle_qtys", "bdl_qty"),
    "OPT_REF_DIM.06": ("side_cnt(도수)", None, None),
    "OPT_REF_DIM.07": ("sub_prd_cd", "t_prd_product_sets", "sub_prd_cd"),
}

# verify_price_coverage.py:48-55 상수 인용(집계 재현용)
_SKIP_DIMS = {"min_qty", "plt_siz_cd", "siz_width", "siz_height", "coat_side_cnt"}
_CHECK_DIMS = {"siz_cd", "mat_cd", "print_opt_cd", "opt_cd", "bdl_qty"}

# 결함코드 → 교정 라우팅(hdx REMEDIATION_CLASS 축 · 값 날조 금지 승계)
REMEDIATION = {
    # review 260822 교정2: ANCHOR_DELETED 는 재키(구코드→신코드) 케이스가 다수 — del_yn 복구는
    # 구코드 중복을 부활시키는 판단 작업 → auto_data 아님, review 로 재분류(auto_data 0건 유지).
    "ANCHOR_DELETED": "review",
    "ANCHOR_MISSING": "needs_design",   # 등록행 신규 = 설계 판단
    "MASTER_DELETED": "review", "MASTER_MISSING": "needs_design",
    "PRICE_MISSING": "needs_authority", "UNCOVERED": "needs_authority",
    "MISSING_DIM": "needs_design", "ZERO_FINAL": "needs_authority",
    "NO_SOURCE": "needs_design", "NO_FORMULA": "needs_design",
    "UNDERCHARGE": "needs_authority", "ENGINE_ERROR": "review",
    "PARENT_DEAD": "review", "ORPHAN_OPT": "review", "ORPHAN_ITEM": "review",
    "EMPTY_GROUP": "review", "XPROD_DUP": "review",
    "RULE_ALWAYS_FALSE": "needs_design", "RULE_DEAD_REF": "review",
    "PRICE_REF_DEAD": "needs_authority", "USEDIMS_REF_DEAD": "needs_design",
    "TRUNCATED": "review", "SIM_META_ERROR": "needs_engine",
}


def load_csv(name):
    with (SNAP / f"{name}.csv").open(encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))


def active(rows):
    return [r for r in rows if r.get("use_yn", "Y") != "N" and r.get("del_yn", "N") != "Y"]


def code_of(summary: str) -> str:
    for c in REMEDIATION:
        if summary.startswith(c):
            return c
    return summary.split()[0] if summary else "?"


def main() -> int:
    prods = active(load_csv("t_prd_products"))
    prd_nm = {p["prd_cd"]: p["prd_nm"] for p in prods}
    prd_typ = {p["prd_cd"]: p["prd_typ_cd"] for p in prods}

    # ── 결함 적재 ──
    defects = defaultdict(list)          # prd_cd -> [defect dicts]
    edges_seen = set()
    for path, is_widget in ((WS / "out/defects/widget-defects.jsonl", True),
                            (WS / "out/defects/price-defects.jsonl", False)):
        if not path.exists():
            raise SystemExit(f"결함 파일 부재: {path}")
        for ln in path.read_text(encoding="utf-8").splitlines():
            if not ln.strip():
                continue
            d = json.loads(ln)
            if not isinstance(d.get("evidence"), dict):      # 보드 CSV 승계분은 문자열
                d["evidence"] = {"text": d.get("evidence")} if d.get("evidence") else {}
            edge = d["dimension"] if d["dimension"] in EDGES else HDX_EDGE.get(d["dimension"], d["dimension"])
            d = dict(d, edge=edge, code=code_of(d.get("summary", "")))
            edges_seen.add(edge)
            if d.get("prd_cd"):
                defects[d["prd_cd"]].append(d)
            else:                          # 상품 무관 결함(전역) — index 에만
                defects["*GLOBAL*"].append(d)
    # 센서 환경 FAIL(크래시) 존재 시 해당 라운드 판정 무효 — 전 상품 미평가 강등(review 260822 구멍2)
    env_failed = any(d.get("summary", "").startswith("[환경 FAIL]")
                     for ds_ in defects.values() for d in ds_)

    # ── 스냅샷 계층 재료 ──
    groups_all = load_csv("t_prd_product_option_groups")
    opts_all = load_csv("t_prd_product_options")
    items_all = load_csv("t_prd_product_option_items")
    regs = {}                             # (tbl, prd, val) -> 'N'/'Y'  (live 잔재 포함)
    for _dim, tbl, col in REF_DIM.values():
        if not tbl:
            continue
        for r in load_csv(tbl):
            regs[(tbl, r["prd_cd"], r[col])] = r.get("del_yn", "N")
    price_rows = Counter(r["comp_cd"] for r in load_csv("t_prc_component_prices"))
    grid_vals = defaultdict(set)          # (comp, dim) -> 값 집합
    for r in load_csv("t_prc_component_prices"):
        for d in _CHECK_DIMS:
            if r.get(d):
                grid_vals[(r["comp_cd"], d)].add(r[d])
    frm_bind = {}                          # prd -> (frm_cd, apply_bgn_ymd) 최신
    for r in sorted(load_csv("t_prd_product_price_formulas"), key=lambda x: x["apply_bgn_ymd"]):
        frm_bind[r["prd_cd"]] = (r["frm_cd"], r["apply_bgn_ymd"])
    frm_comps = defaultdict(list)          # frm -> [(comp_cd, use_dims)]
    comps_ud = {r["comp_cd"]: r.get("use_dims") for r in load_csv("t_prc_price_components")}
    for r in load_csv("t_prc_formula_components"):
        if r.get("addtn_yn") != "Y":
            frm_comps[r["frm_cd"]].append((r["comp_cd"], comps_ud.get(r["comp_cd"], "")))
    prod_dim_vals = {}                     # (prd, dim) -> 등록값 집합 (커버리지 집계용)
    for dim, tbl, col in (("siz_cd", "t_prd_product_sizes", "siz_cd"),
                          ("mat_cd", "t_prd_product_materials", "mat_cd"),
                          ("print_opt_cd", "t_prd_product_print_options", "print_opt_cd"),
                          ("opt_cd", "t_prd_product_options", "opt_cd"),
                          ("bdl_qty", "t_prd_product_bundle_qtys", "bdl_qty")):
        for r in load_csv(tbl):
            v = r.get(col)
            if v:
                prod_dim_vals.setdefault((r["prd_cd"], dim), set()).add(v)

    by_prd_g = defaultdict(list)
    for g in groups_all:
        by_prd_g[g["prd_cd"]].append(g)
    by_prd_o = defaultdict(list)
    for o in opts_all:
        by_prd_o[o["prd_cd"]].append(o)
    by_prd_i = defaultdict(list)
    for it in items_all:
        by_prd_i[it["prd_cd"]].append(it)
    simdir = WS / "out" / "sim-meta"

    snap_name = SNAP.name
    outdir = WS / "out" / "wiring-health"
    outdir.mkdir(parents=True, exist_ok=True)
    index, n_broken = [], 0

    for p in prods:
        pc = p["prd_cd"]
        ds = defects.get(pc, [])
        rec = {"prd_cd": pc, "prd_nm": prd_nm[pc], "prd_typ_cd": prd_typ[pc],
               "snapshot": snap_name, "widget": {}, "binding": {}, "formula": {},
               "price": {}, "verdict": "OK", "broken_edges": [],
               "money_impact": {"undercharge": 0, "overcharge": 0, "none": 0, "unknown": 0},
               "remediation": []}

        # sim-meta 하이라키(R4) — 예외 상품은 BROKEN·SIM_META_ERROR
        sim = json.loads((simdir / f"{pc}.json").read_text(encoding="utf-8")) \
            if (simdir / f"{pc}.json").exists() else {"error": "sim-meta 부재"}
        meta = sim.get("meta") or {}
        rec["widget"]["source_hint"] = meta.get("source_hint")
        rec["widget"]["prod_dims"] = [d.get("name") for d in meta.get("prod_dims", [])]
        rec["widget"]["visibility"] = sim.get("visibility")
        # W1→W4 계층(스냅샷 정본) + 센서 결함 부착
        def _item_defects(opt_cd, seq):
            return [{"edge": d["edge"], "code": d["code"]}
                    for d in ds if d.get("evidence", {}).get("opt_cd") == opt_cd
                    and str(d.get("evidence", {}).get("item_seq", seq)) == str(seq)]
        opt_tree = []
        for g in sorted(by_prd_g.get(pc, []), key=lambda x: x.get("disp_seq") or ""):
            if g.get("del_yn") == "Y" or g.get("use_yn") == "N":
                continue
            gnode = {"opt_grp_cd": g["opt_grp_cd"], "opt_grp_nm": g.get("opt_grp_nm"),
                     "sel_typ_cd": g.get("sel_typ_cd"), "mand_yn": g.get("mand_yn"),
                     "defects": [{"edge": d["edge"], "code": d["code"]}
                                 for d in ds
                                 if d["code"] in ("EMPTY_GROUP",)
                                 and d.get("evidence", {}).get("opt_grp_cd") == g["opt_grp_cd"]],
                     "options": []}
            for o in sorted([o for o in by_prd_o.get(pc, [])
                             if o["opt_grp_cd"] == g["opt_grp_cd"] and o.get("del_yn") != "Y"],
                            key=lambda x: x.get("disp_seq") or ""):
                onode = {"opt_cd": o["opt_cd"], "opt_nm": o.get("opt_nm"),
                         "dflt": o.get("dflt_yn") == "Y", "items": []}
                for it in sorted([i for i in by_prd_i.get(pc, [])
                                  if i["opt_cd"] == o["opt_cd"] and i.get("del_yn") != "Y"],
                                 key=lambda x: int(x.get("item_seq") or 0)):
                    spec = REF_DIM.get(it.get("ref_dim_cd"))
                    resolved = None
                    if spec and spec[1]:
                        resolved = regs.get((spec[1], pc, it.get("ref_key1"))) == "N"
                    elif spec:
                        resolved = None                     # 검사불가 차원(도수)
                    onode["items"].append({
                        "item_seq": it.get("item_seq"), "ref_dim_cd": it.get("ref_dim_cd"),
                        "ref_key1": it.get("ref_key1"), "dtl_opt": it.get("dtl_opt"),
                        "resolved": resolved,
                        "defects": _item_defects(o["opt_cd"], it.get("item_seq"))})
                gnode["options"].append(onode)
            opt_tree.append(gnode)
        rec["widget"]["opt_groups"] = opt_tree
        rec["widget"]["constraints"] = [
            {"rule_cd": d.get("evidence", {}).get("rule_cd"),
             "defects": [{"edge": "C1", "code": d["code"]}]}
            for d in ds if d["edge"] == "C1"]

        # 가격축
        frm = frm_bind.get(pc)
        rec["binding"] = {"frm_cd": frm[0] if frm else None,
                          "apply_bgn_ymd": frm[1] if frm else None,
                          "defects": [{"edge": "E1", "code": d["code"]} for d in ds if d["edge"] == "E1"]}
        comp_nodes = []
        for cc, ud in frm_comps.get(frm[0], []) if frm else []:
            comp_nodes.append({"comp_cd": cc, "use_dims": (ud or "").split(",") if ud else [],
                               "price_rows": price_rows.get(cc, 0),
                               "defects": [{"edge": d["edge"], "code": d["code"]}
                                           for d in ds if d.get("comp_cd") == cc]})
        rec["formula"] = {"components": comp_nodes,
                          "defects": [{"edge": "E2", "code": d["code"]} for d in ds if d["edge"] == "E2"]}

        # 커버리지 집계(verify_price_coverage 판정 조인 verbatim — any-row-exists 비율)
        hit = miss = 0
        if frm:
            for cc, ud in frm_comps.get(frm[0], []):
                for d in [x.strip() for x in (ud or "").split(",") if ":" not in x]:
                    if d in _SKIP_DIMS or d not in _CHECK_DIMS:
                        continue
                    gv = grid_vals.get((cc, d))
                    if not gv:
                        continue
                    pv = prod_dim_vals.get((pc, d), set())
                    hit += len(pv & gv)
                    miss += len(pv - gv)
        def _ev(d, *keys, default=None):
            ev = d.get("evidence")
            if isinstance(ev, dict):
                for k in keys:
                    ev = ev.get(k) if isinstance(ev, dict) else None
                    if ev is None:
                        return default
                return ev
            return default                     # price-defects(보드 CSV) 의 evidence 는 문자열
        rec["price"] = {"reachable_ratio": round(hit / (hit + miss), 4) if (hit + miss) else None,
                        "defects": [{"edge": d["edge"], "code": d["code"],
                                     "dim": _ev(d, "finding", "dim"),
                                     "value": (_ev(d, "finding", "values", default=[None]) or [None])[0]}
                                    for d in ds if d["edge"] in ("E4", "E3")]}

        # 축별 검사여부(review 260822 교정3): 가격 센서(coverage·zero)는 PRD_TYPE.01(완제품)만
        # 분모로 본다(verify_price_coverage.py:180 하드코딩·--all-types 플래그 없음 → 원본 수정
        # 금지로 확대 불가 — 가정 기록). 셋트구성원(02)·기성(03)은 E1/E3/E4 미평가.
        eval_edges = set(EDGES) if not env_failed else set(EDGES) - {"W1", "W2", "W3", "W4", "C1", "E4"}
        if prd_typ[pc] != "PRD_TYPE.01":
            eval_edges -= {"E1", "E3", "E4"}
        rec["evaluated_edges"] = sorted(eval_edges)

        # verdict(R5 + 교정3): 결함 0인데 미평가 치명 엣지(E1/E3/E4)가 있으면 NOT_EVALUATED
        fatal = [d for d in ds if d["code"] in FATAL_CODES] + \
                ([{"code": "SIM_META_ERROR"}] if sim.get("error") else [])
        if fatal:
            rec["verdict"] = "BROKEN"
        elif ds:
            rec["verdict"] = "WARN"
        elif not {"E1", "E3", "E4"} <= eval_edges:
            rec["verdict"] = "NOT_EVALUATED"   # 무검사 은폐 금지 — OK 로 보고하지 않는다
        else:
            rec["verdict"] = "OK"
        rec["broken_edges"] = sorted({d["edge"] for d in fatal} |
                                     ({"SIM_META_ERROR"} if sim.get("error") else set()))
        for d in ds:
            rec["money_impact"][d.get("money_impact", "unknown")] = \
                rec["money_impact"].get(d.get("money_impact", "unknown"), 0) + 1
        rec["remediation"] = [{"edge": d["edge"], "class": REMEDIATION.get(d["code"], "review"),
                               "note": d.get("summary", "")[:120]} for d in ds]
        if sim.get("error"):
            rec["remediation"].append({"edge": "SIM_META_ERROR", "class": "needs_engine",
                                       "note": sim["error"][:120]})
        (outdir / f"{pc}.json").write_text(
            json.dumps(rec, ensure_ascii=False, sort_keys=True), encoding="utf-8")
        if rec["verdict"] == "BROKEN":
            n_broken += 1
        index.append({"prd_cd": pc, "prd_nm": prd_nm[pc], "prd_typ_cd": prd_typ[pc],
                      "verdict": rec["verdict"], "broken_edges": rec["broken_edges"],
                      "n_defects": len(ds), "money_impact": rec["money_impact"]})

    # 전역(상품 무관) 결함·엣지 평가 기록(AC5)
    edges_evaluated = sorted(edges_seen | set(EDGES))
    summary = {"snapshot": snap_name, "denominator": len(prods),
               "verdict_counts": dict(Counter(r["verdict"] for r in index)),
               "broken": n_broken, "edges_evaluated": edges_evaluated,
               "global_defects": [{ "edge": d["edge"], "code": d["code"],
                                    "summary": d["summary"][:160]}
                                   for d in defects.get("*GLOBAL*", [])],
               "products": sorted(index, key=lambda r: (r["verdict"] != "BROKEN",
                                                        -r["n_defects"], r["prd_cd"]))}
    (WS / "out" / "wiring-health-index.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"wiring-health {len(prods)}상품 · BROKEN {n_broken} · "
          f"verdict {summary['verdict_counts']} -> {outdir}")
    print(f"edges_evaluated: {edges_evaluated}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
