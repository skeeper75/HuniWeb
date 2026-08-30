#!/usr/bin/env python3
"""가격 시뮬레이터 실호출 — 사람이 숫자를 옮겨 적지 않는다.

쓰는 법:
    CK=$(cat /tmp/foil28/ck.txt) python3 sim.py           # 기본 케이스 전부
"""
import json
import os
import urllib.error
import urllib.request

H = "https://huni-admin.printly.co.kr"
CK = os.environ.get("CK") or open('/tmp/foil28/ck.txt').read().strip()
CSRF = dict(p.split('=', 1) for p in CK.split('; '))['csrftoken']
# Cloudflare 가 기본 python UA 를 1010 으로 막는다 — 브라우저 UA 를 그대로 쓴다.
UA = ("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36")


def simulate(prd, selections, qty, procs=None, pages=None):
    body = json.dumps({
        "selections": selections, "qty": qty, "grade_cd": None, "tmpl_cd": None,
        "mode": "lenient", "procs": procs or [], "addons": [], "pages": pages,
    }).encode()
    req = urllib.request.Request(
        f"{H}/admin/price-viewer/{prd}/simulate/", data=body,
        headers={"Content-Type": "application/json", "X-CSRFToken": CSRF,
                 "Cookie": CK, "Referer": f"{H}/admin/price-simulator/",
                 "Origin": H, "User-Agent": UA, "Accept": "application/json"})
    try:
        return json.load(urllib.request.urlopen(req))
    except urllib.error.HTTPError as e:
        raw = e.read().decode("utf-8", "replace")
        try:
            return json.loads(raw)
        except ValueError:
            return {"ok": False, "http_status": e.code, "raw": raw[:800]}


def report(tag, r):
    base = r.get("base") or {}
    frm = (base.get("formula") or {}).get("frm_cd")
    print(f"== {tag}")
    print(f"   final_price={r.get('final_price')}  ok={r.get('ok')}  formula={frm}")
    for c in base.get("components", []):
        if c.get("included"):
            print(f"   + {c.get('comp_nm')}: {c.get('amount')}")
    if r.get("errors"):
        print("   errors:", r["errors"])
    return r.get("final_price")
