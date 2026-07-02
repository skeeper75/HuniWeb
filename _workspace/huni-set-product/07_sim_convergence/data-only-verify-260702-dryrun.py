# -*- coding: utf-8 -*-
"""094 엽서북 데이터-only 후보 검증 — 라이브 DB 트랜잭션 ROLLBACK 전용 DRY-RUN.

실제 webadmin pricing.py(evaluate_price/evaluate_set_price)를 그대로 import 해
시뮬레이터 뷰(price_simulate_set)가 만드는 페이로드를 충실 재현한다.
모든 데이터 변경은 atomic 블록 안에서 수행 후 강제 ROLLBACK — 라이브 흔적 0.
"""
import os, sys, json
from decimal import Decimal

sys.path.insert(0, "/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
os.environ.setdefault("DJANGO_SECRET_KEY", "dryrun-local-rollback-only")

import django
django.setup()

from django.db import transaction, connection
from catalog import pricing
from catalog import models as M

OUT = {}

def q(sql, params=None):
    with connection.cursor() as cur:
        cur.execute(sql, params or [])
        if cur.description:
            return cur.fetchall()
        return None

class Rollback(Exception):
    pass

def fn_calc_pansu(plate, siz):
    return q("SELECT fn_calc_pansu(%s,%s)", [plate, siz])[0][0]

COPIES = 100
PAGES = 20
PLATE = "SIZ_000499"
SIZ = "SIZ_000003"
POPT = "POPT_000001"
OPT_20P = "OPV_000491"

def build_members(member_extra_sel=None):
    pansu = fn_calc_pansu(PLATE, SIZ)
    sides = 1
    eff = pricing.derive_inner_sheets(COPIES, PAGES, pansu, sides)
    inner_sel = {"siz_cd": SIZ, "mat_cd": "MAT_000109", "print_opt_cd": POPT,
                 "plt_siz_cd": PLATE}
    cover_sel = {"siz_cd": SIZ, "mat_cd": "MAT_000092", "print_opt_cd": POPT}
    if member_extra_sel:
        inner_sel.update(member_extra_sel)
        cover_sel.update(member_extra_sel)
    members = [
        {"sub_prd_cd": "PRD_000095", "role": "SEMI_ROLE.01", "label": "inner",
         "selections": inner_sel, "procs": None, "qty": eff,
         "qty_breakdown": {"mode": "derived", "pansu": pansu, "total_sheets": eff},
         "skip_plate": True},
        {"sub_prd_cd": "PRD_000096", "role": "SEMI_ROLE.02", "label": "cover",
         "selections": cover_sel, "procs": None, "qty": COPIES,
         "qty_breakdown": {"mode": "manual", "qty": COPIES}, "skip_plate": False},
    ]
    return members, pansu, eff

def run_set(set_selections, member_extra_sel=None, copies=COPIES):
    members, pansu, eff = build_members(member_extra_sel)
    res = pricing.evaluate_set_price("PRD_000094", members, set_selections, copies,
                                     grade_cd=None, mode="lenient")
    return {
        "pansu": pansu, "inner_eff_qty": eff,
        "final_price": str(res.get("final_price")),
        "base_total": str(res.get("base_total")),
        "set_eval_source": ((res.get("set_eval") or {}).get("base") or {}).get("source"),
        "set_eval_amount": str(((res.get("set_eval") or {}).get("base") or {}).get("amount")),
        "member_contrib": {m["label"]: str(m.get("contribution")) for m in res.get("members", [])},
        "warnings": res.get("warnings", []),
        "member_evals": [
            {"label": m["label"],
             "source": ((m.get("eval") or {}).get("base") or {}).get("source"),
             "components": [
                 {"comp_cd": c["comp_cd"], "included": c["included"],
                  "error": c.get("error"), "note": c.get("note"),
                  "data_gap": c.get("data_gap"), "subtotal": str(c["subtotal"])}
                 for c in (((m.get("eval") or {}).get("base") or {}).get("components") or [])]}
            for m in res.get("members", [])],
        "set_components": [
            {"comp_cd": c["comp_cd"], "included": c["included"], "error": c.get("error"),
             "note": c.get("note"), "data_gap": c.get("data_gap"), "subtotal": str(c["subtotal"])}
            for c in (((res.get("set_eval") or {}).get("base") or {}).get("components") or [])],
    }

def state_snapshot():
    return {
        "sets": q("SELECT prd_cd, sub_prd_cd, del_yn FROM t_prd_product_sets WHERE prd_cd='PRD_000094' ORDER BY sub_prd_cd"),
        "formula_bind": q("SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000094','PRD_000095','PRD_000096') ORDER BY prd_cd"),
        "use_dims": q("SELECT comp_cd, use_dims::text FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_PCB%%' ORDER BY comp_cd"),
        "direct_price": q("SELECT prd_cd, apply_ymd, unit_price FROM t_prd_product_prices WHERE prd_cd='PRD_000094'"),
    }

UI_SETSEL = {"print_opt_cd": POPT, "opt_cd": OPT_20P}
UI_SETSEL_PLUS_SIZ = dict(UI_SETSEL, siz_cd=SIZ)

OUT["state_before"] = state_snapshot()

OUT["S0a_baseline_ui_faithful"] = run_set(UI_SETSEL)
OUT["S0b_baseline_sizcd_injected"] = run_set(UI_SETSEL_PLUS_SIZ)

# 후보 C: 셋트 구성 해제
try:
    with transaction.atomic():
        q("UPDATE t_prd_product_sets SET del_yn='Y' WHERE prd_cd='PRD_000094'")
        is_set_rows = q("SELECT count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000094' AND del_yn='N'")[0][0]
        single = pricing.evaluate_price({"prd_cd": "PRD_000094"},
                                        {"siz_cd": SIZ, "print_opt_cd": POPT, "opt_cd": OPT_20P},
                                        COPIES, mode="lenient")
        single2 = pricing.evaluate_price({"prd_cd": "PRD_000094"},
                                         {"siz_cd": SIZ, "print_opt_cd": POPT, "opt_cd": OPT_20P},
                                         2, mode="lenient")
        OUT["C_unset_set_membership"] = {
            "is_set_rows_after_update": is_set_rows,
            "single_100qty_final": str(single.get("final_price")),
            "single_100qty_source": (single.get("base") or {}).get("source"),
            "single_2qty_final": str(single2.get("final_price")),
            "warnings": single.get("warnings", []),
        }
        raise Rollback()
except Rollback:
    pass

# 후보 A/(b): 공식 바인딩 094→095 이동
try:
    with transaction.atomic():
        q("DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000094'")
        q("""INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
             VALUES ('PRD_000095','PRF_PCB_FIXED','2026-06-01','DRY-RUN')""")
        OUT["A_rebind_to_inner__ui_faithful"] = run_set({})
        OUT["A_rebind_to_inner__hypothetical_optcd_in_member"] = run_set(
            {}, member_extra_sel={"opt_cd": OPT_20P})
        raise Rollback()
except Rollback:
    pass

# 후보 D: use_dims에서 siz_cd 제거
try:
    with transaction.atomic():
        q("""UPDATE t_prc_price_components
             SET use_dims='["min_qty","print_opt_cd","opt_cd","opt_grp:OPT_000082"]'::jsonb
             WHERE comp_cd LIKE 'COMP_PCB%%'""")
        OUT["D_remove_sizcd_from_use_dims"] = run_set(UI_SETSEL)
        raise Rollback()
except Rollback:
    pass

# 후보 B: 094 직접단가 등록
try:
    with transaction.atomic():
        q("""INSERT INTO t_prd_product_prices (prd_cd, apply_ymd, unit_price, note)
             VALUES ('PRD_000094','2026-06-01',4500,'DRY-RUN')""")
        r100 = run_set(UI_SETSEL, copies=100)
        r2 = run_set(UI_SETSEL, copies=2)
        OUT["B_direct_price"] = {
            "copies_100": {"final": r100["final_price"], "set_source": r100["set_eval_source"]},
            "copies_2": {"final": r2["final_price"], "set_source": r2["set_eval_source"],
                          "authority_expected_2copies": "22000 (2부 x 11,000/부)"},
        }
        raise Rollback()
except Rollback:
    pass

OUT["state_after_all_rollbacks"] = state_snapshot()
OUT["residue_check_identical"] = (OUT["state_before"] == OUT["state_after_all_rollbacks"])

def _default(o):
    return str(o)

print(json.dumps(OUT, ensure_ascii=False, indent=2, default=_default))
