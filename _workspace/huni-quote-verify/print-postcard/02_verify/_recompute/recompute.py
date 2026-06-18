"""hqv recompute harness — uses VERBATIM pure functions from raw/webadmin pricing.py,
feeds live-exported component rows (JSON) instead of Django ORM.

Equivalence basis: match_component / component_subtotal / _row_matches / _combo_key /
_tier_val / _tier_order_val / round_won / apply_discount are imported UNCHANGED from
the real pricing.py (they are ORM-independent). Only _evaluate_formula's data access
(_component_rows via ORM) is replaced by a dict lookup over the exported live rows.
The matching algorithm is therefore identical to the live engine's FORMULA path.
"""
import json, sys, os, importlib.util, types
from decimal import Decimal

HERE = os.path.dirname(os.path.abspath(__file__))
PRICING_PY = "/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/pricing.py"

# --- import the REAL pricing.py pure functions (stub out `catalog.models`) ---
fake_catalog = types.ModuleType("catalog")
fake_models = types.ModuleType("catalog.models")
fake_catalog.models = fake_models
sys.modules["catalog"] = fake_catalog
sys.modules["catalog.models"] = fake_models

spec = importlib.util.spec_from_file_location("pricing", PRICING_PY)
pricing = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pricing)

match_component = pricing.match_component
component_subtotal = pricing.component_subtotal
round_won = pricing.round_won
PRC_TYPE_UNIT = pricing.PRC_TYPE_UNIT
ERR_AMBIGUOUS = pricing.ERR_AMBIGUOUS

with open(os.path.join(HERE, "comp_prices.json"), encoding="utf-8") as f:
    ALL_ROWS = json.load(f)
with open(os.path.join(HERE, "formula_comps.json"), encoding="utf-8") as f:
    FORMULA_COMPS = json.load(f)

from collections import defaultdict
ROWS_BY_COMP = defaultdict(list)
for r in ALL_ROWS:
    row = dict(r)
    if row.get("unit_price") is not None:
        row["unit_price"] = Decimal(str(row["unit_price"]))
    ROWS_BY_COMP[row["comp_cd"]].append(row)


def _match_entry_pure(c, rows, sel, qty, as_of, only):
    comp_cd = c["comp_cd"]
    prc_typ = c["comp_cd__prc_typ_cd"] or PRC_TYPE_UNIT
    m = match_component(rows, sel, qty, as_of)
    entry = {"comp_cd": comp_cd, "comp_nm": c["comp_cd__comp_nm"], "disp_seq": c["disp_seq"],
             "prc_typ": prc_typ, "included": False, "subtotal": Decimal(0),
             "error": m.get("error"), "calc_error": None, "matched_row": None,
             "per_item": None, "tier_min_qty": m.get("tier_min_qty")}
    if m["error"] in (ERR_AMBIGUOUS, pricing.ERR_DUPLICATE, pricing.ERR_BELOW_MIN, pricing.ERR_ABOVE_MAX):
        return entry
    if m["row"] is None:
        return entry
    if only is not None and comp_cd not in only:
        return entry
    row = m["row"]
    try:
        subtotal, per_item = component_subtotal(prc_typ, row["unit_price"], m["tier_min_qty"], qty)
    except Exception as e:
        entry["calc_error"] = str(e); return entry
    entry.update({"included": True, "subtotal": subtotal, "per_item": per_item,
                  "matched_row": {k: row.get(k) for k in
                                  ("comp_price_id","unit_price","min_qty","print_opt_cd",
                                   "plt_siz_cd","siz_cd","coat_side_cnt","mat_cd","proc_cd")}})
    return entry


def evaluate_formula_live(selections, qty, as_of, proc_sels=None):
    total = Decimal(0); out = []
    for c in sorted(FORMULA_COMPS, key=lambda x: x["disp_seq"]):
        rows = ROWS_BY_COMP.get(c["comp_cd"], [])
        use_dims = c["comp_cd__use_dims"] or []
        non_qty = [d for d in use_dims if not (isinstance(d, str) and ":" in d)]
        is_proc = "proc_cd" in non_qty
        if proc_sels is not None and is_proc:
            for ps in proc_sels:
                sel = dict(selections); sel["proc_cd"] = ps.get("proc_cd")
                for k, v in (ps.get("detail") or {}).items(): sel[k] = v
                e = _match_entry_pure(c, rows, sel, qty, as_of, None)
                if e["included"] or e["error"] or e["calc_error"]:
                    out.append(e); total += e["subtotal"]
        else:
            e = _match_entry_pure(c, rows, selections, qty, as_of, None)
            out.append(e); total += e["subtotal"]
    return total, out


def run_case(name, selections, qty, proc_sels=None, as_of="2026-06-18"):
    total, comps = evaluate_formula_live(selections, qty, as_of, proc_sels)
    print(f"\n=== {name} (qty={qty}) sel={selections}" +
          (f" proc_sels={proc_sels}" if proc_sels else "") + " ===")
    for e in comps:
        if e["included"]:
            mr = e["matched_row"]
            print(f"  [INCL] {e['comp_cd']:<26} sub={str(e['subtotal']):>12} per={e['per_item']} "
                  f"(up={mr['unit_price']},mq={mr['min_qty']},popt={mr.get('print_opt_cd')},"
                  f"plt={mr.get('plt_siz_cd')},siz={mr.get('siz_cd')},coat={mr.get('coat_side_cnt')},mat={mr.get('mat_cd')})")
        elif e["error"]:
            print(f"  [ERR ] {e['comp_cd']:<26} error={e['error']}")
        elif e["calc_error"]:
            print(f"  [CERR] {e['comp_cd']:<26} {e['calc_error']}")
    print(f"  ---- base_amount(sum included)={total}  final_price=round_won={round_won(total)}")
    return round_won(total), total


if __name__ == "__main__":
    run_case("PC-2-naive-worksize (siz=100x150 단면 종이220g 200매)",
             {"siz_cd": "SIZ_000003", "print_opt_cd": "POPT_000001", "mat_cd": "MAT_000074"}, 200)
    run_case("PC-2-plate 국4절 단면 200매 (plt=siz=SIZ_000499)",
             {"plt_siz_cd": "SIZ_000499", "siz_cd": "SIZ_000499", "print_opt_cd": "POPT_000001", "mat_cd": "MAT_000074"}, 200)
    run_case("양면(POPT_000002) 국4절 200매",
             {"plt_siz_cd": "SIZ_000499", "siz_cd": "SIZ_000499", "print_opt_cd": "POPT_000002", "mat_cd": "MAT_000074"}, 200)
    run_case("PC-3 무광단면코팅 국4절 200매",
             {"plt_siz_cd": "SIZ_000499", "siz_cd": "SIZ_000499", "print_opt_cd": "POPT_000001", "mat_cd": "MAT_000074", "coat_side_cnt": "1"}, 200)
    run_case("anchor 단면 국4절 qty=25",
             {"plt_siz_cd": "SIZ_000499", "siz_cd": "SIZ_000499", "print_opt_cd": "POPT_000001", "mat_cd": "MAT_000074"}, 25)

    # === Supply digital print process PROC_000004 so 인쇄비 fires ===
    print("\n########## WITH proc_cd=PROC_000004 (digital print) IN SELECTIONS ##########")
    run_case("단면 국4절 200매 +proc_cd=PROC_000004",
             {"plt_siz_cd": "SIZ_000499", "siz_cd": "SIZ_000499", "print_opt_cd": "POPT_000001",
              "mat_cd": "MAT_000074", "proc_cd": "PROC_000004"}, 200)
    run_case("양면 국4절 200매 +proc_cd=PROC_000004",
             {"plt_siz_cd": "SIZ_000499", "siz_cd": "SIZ_000499", "print_opt_cd": "POPT_000002",
              "mat_cd": "MAT_000074", "proc_cd": "PROC_000004"}, 200)
    # via proc_sels (engine's real path for proc-group comps)
    print("\n########## VIA proc_sels=[{proc_cd:PROC_000004}] (engine real path) ##########")
    run_case("단면 국4절 200매 proc_sels",
             {"plt_siz_cd": "SIZ_000499", "siz_cd": "SIZ_000499", "print_opt_cd": "POPT_000001", "mat_cd": "MAT_000074"},
             200, proc_sels=[{"proc_cd": "PROC_000004"}])
    # qty=25 to read the per-print-sheet 단가 directly (출력매수=25 for 100x150 at 200매)
    run_case("단면 국4절 qty=25 +proc PROC_000004 (출력매수=25 단가 직접)",
             {"plt_siz_cd": "SIZ_000499", "siz_cd": "SIZ_000499", "print_opt_cd": "POPT_000001",
              "mat_cd": "MAT_000074", "proc_cd": "PROC_000004"}, 25)
