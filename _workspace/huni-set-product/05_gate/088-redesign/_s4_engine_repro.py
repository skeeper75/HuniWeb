#!/usr/bin/env python3
"""S4 — run the ACTUAL pricing.py pure matching functions against redesigned-state rows.

Stubs catalog.models so pricing.py imports without Django, then uses its real
match_component + component_subtotal against the post-apply component rows.
Redesigned state: COMP_LEATHER_RINGBINDER_COVER minted (9000@min_qty=1),
COMP_BIND_SSABARI (live, unchanged) wired to parent, 088 proc=PROC_000098.
Read-only: SSABARI rows fetched live via psql; cover row constructed per apply.sql.
"""
import os, sys, types, subprocess, json

# --- env (RAILWAY_DB_*) ---
def load_env():
    p = os.path.join(os.path.dirname(__file__), "..", "..", "..", "..", ".env.local")
    with open(os.path.abspath(p), encoding="utf-8") as f:
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

# --- stub catalog.models so pricing.py imports ---
pkg = types.ModuleType("catalog"); pkg.__path__=[]
models = types.ModuleType("catalog.models")
pkg.models = models
sys.modules["catalog"]=pkg; sys.modules["catalog.models"]=models
sys.path.insert(0, os.path.join(os.getcwd(), "raw/webadmin/webadmin/catalog"))
sys.path.insert(0, os.path.join(os.getcwd(), "raw/webadmin/webadmin"))
import pricing as P   # real engine module (pure helpers usable; ORM funcs unused here)

NON_QTY = P.NON_QTY_DIMS

def mkrow(d):
    """build a row dict with all NON_QTY_DIMS + tier + dim_vals keys (as _component_rows_bulk yields)."""
    r = {"comp_price_id": d.get("comp_price_id"), "apply_ymd": d.get("apply_ymd"),
         "unit_price": d.get("unit_price"), "min_qty": d.get("min_qty"),
         "dim_vals": d.get("dim_vals"), "siz_width": d.get("siz_width"), "siz_height": d.get("siz_height")}
    for nd in NON_QTY: r[nd] = d.get(nd)
    return r

# --- redesigned-state rows ---
# 1) COMP_LEATHER_RINGBINDER_COVER (minted per apply.sql #2): flat 9000 @ min_qty=1, no non-qty dims
cover_rows = [ mkrow({"comp_price_id":88047, "apply_ymd":"2026-06-01", "min_qty":1, "unit_price":9000}) ]
cover_prc_typ = "PRICE_TYPE.01"

# 2) COMP_BIND_SSABARI (live, unchanged) — fetch verbatim
ss_rows = []
for cid, proc, mq, up, dv, ay in db(
    "SELECT comp_price_id, proc_cd, min_qty, unit_price, coalesce(dim_vals::text,''), apply_ymd "
    "FROM t_prc_component_prices WHERE comp_cd='COMP_BIND_SSABARI' ORDER BY proc_cd, min_qty::int"):
    ss_rows.append(mkrow({"comp_price_id":int(cid), "proc_cd":proc, "min_qty":int(mq),
                          "unit_price":float(up), "dim_vals":(json.loads(dv) if dv else None),
                          "apply_ymd":ay}))
ss_prc_typ = "PRICE_TYPE.01"

# 3) discount tables on 088?
disc = db("SELECT count(*) FROM t_prd_product_discount_tables WHERE prd_cd='PRD_000088'")
disc_n = int(disc[0][0])

AS_OF = "2026-07-02"

def eval_component(rows, prc_typ, selections, qty):
    m = P.match_component(rows, selections, qty, AS_OF)
    if m.get("error"): return None, f"ERR:{m['error']}"
    if m["row"] is None: return None, f"no_match({m.get('reason')})"
    sub, per = P.component_subtotal(prc_typ, m["row"]["unit_price"], m["tier_min_qty"], qty)
    return float(sub), f"tier_min_qty={m['tier_min_qty']} unit={m['row']['unit_price']}"

print(f"# discount tables on 088 = {disc_n} (expect 0 -> final=base_total)")
print(f"# COMP_BIND_SSABARI live rows fetched = {len(ss_rows)} (expect 18 = 6 bands x 3 proc)")
print("copies\tmember089_cover\tparent_sabari\tbase_total\tfinal\tdetail")
EXPECT = {1:39000, 10:290000, 100:1800000}
allok = True
for copies in (1, 10, 100):
    # member 089 (cover): selections={}, qty=copies
    cov, cdet = eval_component(cover_rows, cover_prc_typ, {}, copies)
    # parent (sabari): proc branch -> selection proc_cd=PROC_000098, qty=copies
    par, pdet = eval_component(ss_rows, ss_prc_typ, {"proc_cd":"PROC_000098"}, copies)
    # members 090-093 = 0 (no formula)
    base = (cov or 0) + 0 + (par or 0)
    final = base if disc_n == 0 else None
    exp = EXPECT[copies]
    ok = (final == exp)
    allok = allok and ok
    print(f"{copies}\t{cov}\t{par}\t{base}\t{final}\t[cover:{cdet}][sabari:{pdet}] {'OK' if ok else f'!=EXP {exp}'}")

# S8 leak test: if 088 wrongly declared PROC_000023 or 024, would sabari band silently apply?
print("\n# S8 proc-isolation: eval parent with WRONG proc selections (must NOT yield sabari 9000 band)")
for wrong in ("PROC_000023","PROC_000024"):
    par, pdet = eval_component(ss_rows, ss_prc_typ, {"proc_cd":wrong}, 100)
    print(f"  proc={wrong} @100 -> {par} [{pdet}]  (isolated: sabari band would be 9000*100=900000; this is the {wrong} band, distinct)")
# ambiguity test: no proc selection at all
par, pdet = eval_component(ss_rows, ss_prc_typ, {}, 100)
print(f"  proc=NONE @100 -> {par} [{pdet}]  (expect no_match -> parent 0 if set_procs omitted; view derives it from product_processes)")

print("\nRESULT:", "ALL GOLDEN MATCH" if allok else "MISMATCH")
