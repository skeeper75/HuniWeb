import json,re,pathlib,urllib.request,urllib.error
ROOT=pathlib.Path("/Users/innojini/Dev/HuniWeb"); env={}
for line in (ROOT/".env.local").read_text(encoding="utf-8").splitlines():
    m=re.match(r'^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$',line)
    if m: env[m.group(1)]=m.group(2).strip('"\'')
SHOP=(env.get("SHOPBY_SHOP_API_URL") or "https://shop-api.e-ncp.com").rstrip("/")
SH={"Content-Type":"application/json","clientId":env["SHOPBY_CLIENT_ID"],
    "platform":env.get("SHOPBY_PLATFORM") or "PC","version":env.get("SHOPBY_VERSION") or "1.0"}
def call(m,p,b=None):
    d=json.dumps(b,ensure_ascii=False).encode() if b is not None else None
    r=urllib.request.Request(SHOP+p,data=d,headers=SH,method=m)
    try:
        with urllib.request.urlopen(r,timeout=25) as x: return x.status,json.loads(x.read().decode())
    except urllib.error.HTTPError as e:
        raw=e.read().decode('utf-8','replace')
        try: return e.code,json.loads(raw)
        except Exception: return e.code,{"raw":raw[:150]}
snap=json.loads((ROOT/"_workspace/huni-shopby/15_stock/options-snapshot.json").read_text(encoding="utf-8"))
picks=[r for r in snap if r.get("optionNo")][:3]
for r in picks:
    print(f"\n[{r['no']}] {str(r.get('nm'))[:24]}")
    for cnt in (10000, 500000, 1000000, 1000001):
        st,b=call("POST","/guest/cart",[{"cartNo":1,"productNo":r["no"],"optionNo":r["optionNo"],"orderCnt":cnt}])
        ok=bool((b or {}).get("deliveryGroups"))
        inv=(b or {}).get("invalidProducts") or []
        rc=""
        if inv:
            o=(inv[0].get("orderProductOptions") or [{}])[0]
            rc=str((o.get("validInfo") or {}).get("errorCode"))
        amt=((b or {}).get("price") or {}).get("totalAmt") if ok else ""
        print(f"    orderCnt={cnt:>9} → {'담김 OK' if ok else '실패 '+rc}")
