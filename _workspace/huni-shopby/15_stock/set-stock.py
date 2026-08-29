import json,re,pathlib,urllib.request,urllib.error,time
ROOT=pathlib.Path("/Users/innojini/Dev/HuniWeb"); env={}
for line in (ROOT/".env.local").read_text(encoding="utf-8").splitlines():
    m=re.match(r'^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$',line)
    if m: env[m.group(1)]=m.group(2).strip('"\'')
SV=(env.get("SHOPBY_SERVER_API_URL") or "https://server-api.e-ncp.com").rstrip("/")
H={"Content-Type":"application/json","systemKey":env["SHOPBY_SYSTEM_KEY"],
   "version":env.get("SHOPBY_VERSION") or "1.0","Authorization":"Bearer "+env["SHOPBY_SERVER_ACCESS_TOKEN"]}
def call(m,p,b=None):
    d=json.dumps(b,ensure_ascii=False).encode() if b is not None else None
    for a in range(6):
        r=urllib.request.Request(SV+p,data=d,headers=H,method=m)
        try:
            with urllib.request.urlopen(r,timeout=40) as x:
                raw=x.read().decode(); return x.status,(json.loads(raw) if raw else None)
        except urllib.error.HTTPError as e:
            raw=e.read().decode('utf-8','replace')
            try: bb=json.loads(raw)
            except Exception: return e.code,{"raw":raw[:150]}
            if e.code==400 and bb.get("code")=="S0001" and a<5:
                time.sleep(1+a); continue
            return e.code,bb
TARGET=1000000
snap=json.loads((ROOT/"_workspace/huni-shopby/15_stock/options-snapshot.json").read_text(encoding="utf-8"))
opts=[r for r in snap if r.get("optionNo") and r.get("deleteYn")!="Y"]
print(f"대상 옵션 {len(opts)}건 → stock={TARGET}")
B=50; okc=0; fails=[]
for i in range(0,len(opts),B):
    chunk=opts[i:i+B]
    body={"options":[{"optionNo":o["optionNo"],"stock":TARGET} for o in chunk]}
    st,b=call("PUT","/products/options/stock-with-id",body)
    f=(b or {}).get("failures") or []
    if st in (200,207) and not f: okc+=len(chunk)
    else:
        fails.append((st,f[:3],len(chunk)))
        okc+=len(chunk)-len(f)
    print(f"  {i+1:>4}~{i+len(chunk):>4} → {st} 실패 {len(f)}건")
    time.sleep(0.3)
print(f"\n성공 {okc}/{len(opts)}")
if fails: print("실패 상세:", fails[:3])
