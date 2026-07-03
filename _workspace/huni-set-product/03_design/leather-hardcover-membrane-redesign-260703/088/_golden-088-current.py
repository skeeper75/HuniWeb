#!/usr/bin/env python3
"""Measure CURRENT live 088 golden (COVERBIND model) via real pricing.py helpers.
Live wiring: PRF_LEATHER_RINGBINDER_SET -> COMP_HC_MUSEON_COVERBIND (prc_typ .01, use_dims=[min_qty]).
Members 089~093 have NO formula -> contribute 0. Discount tables on 088 = 0.
Read-only. Establishes baseline that 면지 통합 (4->1 empty members) must preserve.
"""
import os, sys, types, subprocess

def load_env():
    p = os.path.join(os.getcwd(), ".env.local")
    with open(p, encoding="utf-8") as f:
        for ln in f:
            ln = ln.strip()
            if not ln or ln.startswith("#") or "=" not in ln: continue
            k, v = ln.split("=", 1)
            os.environ.setdefault(k.strip(), v.strip().strip('"').strip("'"))
load_env()

def db(sql):
    env = dict(os.environ)
    env["PGPASSWORD"]=os.environ["RAILWAY_DB_PASSWORD"]; env["PGHOST"]=os.environ["RAILWAY_DB_HOST"]
    env["PGPORT"]=os.environ["RAILWAY_DB_PORT"]; env["PGUSER"]=os.environ["RAILWAY_DB_USER"]
    env["PGDATABASE"]=os.environ["RAILWAY_DB_NAME"]
    out = subprocess.run(["psql","-At","-F","\t","-c",sql], env=env, capture_output=True, text=True, timeout=60)
    if out.returncode != 0: raise RuntimeError(out.stderr)
    return [ln.split("\t") for ln in out.stdout.splitlines() if ln]

pkg = types.ModuleType("catalog"); pkg.__path__=[]
models = types.ModuleType("catalog.models"); pkg.models = models
sys.modules["catalog"]=pkg; sys.modules["catalog.models"]=models
sys.path.insert(0, os.path.join(os.getcwd(), "raw/webadmin/webadmin/catalog"))
sys.path.insert(0, os.path.join(os.getcwd(), "raw/webadmin/webadmin"))
import pricing as P
NON_QTY = P.NON_QTY_DIMS

def mkrow(d):
    r = {"comp_price_id": d.get("comp_price_id"), "apply_ymd": d.get("apply_ymd"),
         "unit_price": d.get("unit_price"), "min_qty": d.get("min_qty"),
         "dim_vals": d.get("dim_vals"), "siz_width": d.get("siz_width"), "siz_height": d.get("siz_height")}
    for nd in NON_QTY: r[nd] = d.get(nd)
    return r

cb_rows = []
for cid, mq, up, ay in db(
    "SELECT comp_price_id, min_qty, unit_price, apply_ymd FROM t_prc_component_prices "
    "WHERE comp_cd='COMP_HC_MUSEON_COVERBIND' ORDER BY min_qty::int"):
    cb_rows.append(mkrow({"comp_price_id":int(cid), "min_qty":int(mq), "unit_price":float(up), "apply_ymd":ay}))
cb_prc_typ = "PRICE_TYPE.01"

disc_n = int(db("SELECT count(*) FROM t_prd_product_discount_tables WHERE prd_cd='PRD_000088'")[0][0])
AS_OF = "2026-07-02"

def eval_component(rows, prc_typ, selections, qty):
    m = P.match_component(rows, selections, qty, AS_OF)
    if m.get("error"): return None, f"ERR:{m['error']}"
    if m["row"] is None: return None, f"no_match({m.get('reason')})"
    sub, per = P.component_subtotal(prc_typ, m["row"]["unit_price"], m["tier_min_qty"], qty)
    return float(sub), f"tier_min_qty={m['tier_min_qty']} unit={m['row']['unit_price']}"

print(f"# COVERBIND live rows = {len(cb_rows)} (expect 6)")
print(f"# discount tables on 088 = {disc_n} (expect 0)")
print("copies\tparent_coverbind\tmembers(089-093)\tbase_total\tfinal")
EXPECT = {1:34100, 10:159100, 100:796900}
allok = True
for copies in (1, 10, 100):
    par, pdet = eval_component(cb_rows, cb_prc_typ, {}, copies)
    members = 0
    base = (par or 0) + members
    final = base if disc_n == 0 else None
    exp = EXPECT[copies]
    ok = (final == exp)
    allok = allok and ok
    print(f"{copies}\t{par}\t{members}\t{base}\t{final}  [{pdet}] {'OK' if ok else f'!=EXP {exp}'}")
print("\nCURRENT-GOLDEN (COVERBIND, pre-redesign):", "ALL MATCH" if allok else "MISMATCH")
