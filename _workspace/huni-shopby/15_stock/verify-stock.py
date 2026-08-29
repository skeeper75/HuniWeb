import json,re,pathlib,urllib.request,urllib.error,time,collections
ROOT=pathlib.Path("/Users/innojini/Dev/HuniWeb"); env={}
for line in (ROOT/".env.local").read_text(encoding="utf-8").splitlines():
    m=re.match(r'^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$',line)
    if m: env[m.group(1)]=m.group(2).strip('"\'')
SV=(env.get("SHOPBY_SERVER_API_URL") or "https://server-api.e-ncp.com").rstrip("/")
H={"Content-Type":"application/json","systemKey":env["SHOPBY_SYSTEM_KEY"],
   "version":env.get("SHOPBY_VERSION") or "1.0","Authorization":"Bearer "+env["SHOPBY_SERVER_ACCESS_TOKEN"]}
def call(m,p):
    for a in range(6):
        r=urllib.request.Request(SV+p,headers=H,method=m)
        try:
            with urllib.request.urlopen(r,timeout=30) as x: return x.status,json.loads(x.read().decode())
        except urllib.error.HTTPError as e:
            raw=e.read().decode('utf-8','replace')
            try: bb=json.loads(raw)
            except Exception: return e.code,{}
            if e.code==400 and bb.get("code")=="S0001" and a<5: time.sleep(1+a); continue
            return e.code,bb
snap=json.loads((ROOT/"_workspace/huni-shopby/15_stock/options-snapshot.json").read_text(encoding="utf-8"))
nos=sorted({r["no"] for r in snap if r.get("optionNo")})
c=collections.Counter(); bad=[]
for i,no in enumerate(nos):
    st,d=call("GET",f"/products/{no}")
    if st!=200: bad.append((no,st)); continue
    for o in d.get("mallProductOptionWebModels") or []:
        v=o.get("stockCnt"); c[v]+=1
        if v!=1000000: bad.append((no,o.get("mallOptionNo"),v))
    if (i+1)%100==0: print(f"  ...{i+1}/{len(nos)}")
print(f"\n검증 {len(nos)}상품 · 재고 분포: {dict(c.most_common(5))}")
print(f"1,000,000 아닌 것: {len(bad)}건", bad[:5] if bad else "")
