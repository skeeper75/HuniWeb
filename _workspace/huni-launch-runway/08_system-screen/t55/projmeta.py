#!/usr/bin/env python3
"""csproj / packages.config / AssemblyInfo 메타를 뽑는다. 읽기전용."""
import os, re, glob, json

Y = glob.glob("/Users/innojini/Dev/CRT.D*.V2")[0]
H = "/Users/innojini/Dev/TS.BackOffice.Huni/Framework"


def meta(projdir):
    d = {"csproj": None, "tfm": [], "outtype": None, "packages": {},
         "projrefs": [], "asmver": None, "asmname": None, "sdk": False}
    cps = [f for f in os.listdir(projdir) if f.endswith(".csproj")]
    if not cps:
        return d
    cp = os.path.join(projdir, cps[0])
    d["csproj"] = cps[0]
    t = open(cp, encoding="utf-8-sig", errors="replace").read()
    d["sdk"] = "Sdk=" in t.split(">")[0]
    d["tfm"] = re.findall(r"<TargetFrameworkVersion>([^<]+)</", t) + \
        re.findall(r"<TargetFrameworks?>([^<]+)</", t)
    m = re.search(r"<OutputType>([^<]+)</", t)
    d["outtype"] = m.group(1) if m else None
    m = re.search(r"<AssemblyName>([^<]+)</", t)
    d["asmname"] = m.group(1) if m else None
    for pid, pv in re.findall(r'<PackageReference\s+Include="([^"]+)"\s+Version="([^"]+)"', t):
        d["packages"][pid] = pv
    for ref in re.findall(r'<ProjectReference\s+Include="([^"]+)"', t):
        d["projrefs"].append(os.path.basename(ref.replace("\\", "/")))
    # HintPath 기반 구형 참조
    d["hintrefs"] = sorted(set(
        os.path.basename(h.replace("\\", "/"))
        for h in re.findall(r"<HintPath>([^<]+)</HintPath>", t)))
    pc = os.path.join(projdir, "packages.config")
    if os.path.exists(pc):
        for pid, pv in re.findall(r'id="([^"]+)"\s+version="([^"]+)"',
                                  open(pc, encoding="utf-8-sig", errors="replace").read()):
            d["packages"][pid] = pv
    for root, dn, fn in os.walk(projdir):
        if "/obj/" in root.replace(os.sep, "/") or "/bin/" in root.replace(os.sep, "/"):
            continue
        if "AssemblyInfo.cs" in fn:
            t2 = open(os.path.join(root, "AssemblyInfo.cs"), encoding="utf-8-sig",
                      errors="replace").read()
            m = re.search(r'AssemblyVersion\("([^"]+)"\)', t2)
            if m:
                d["asmver"] = m.group(1)
    return d


out = {"yeolim": {}, "huni": {}}
for base, key in ((Y, "yeolim"), (H, "huni")):
    for p in sorted(os.listdir(base)):
        full = os.path.join(base, p)
        if p.startswith("CRT.Framework.") and os.path.isdir(full):
            out[key][p] = meta(full)

here = os.path.dirname(os.path.abspath(__file__))
json.dump(out, open(os.path.join(here, "projmeta.json"), "w"), indent=1)

allp = sorted(set(out["yeolim"]) | set(out["huni"]))
print("%-28s | %-22s | %-22s" % ("project", "열림 TFM/ver/out", "후니 TFM/ver/out"))
for p in allp:
    y, h = out["yeolim"].get(p), out["huni"].get(p)
    def s(x):
        if not x:
            return "(없음)"
        return "%s / %s / %s" % (",".join(x["tfm"]) or "-", x["asmver"] or "-",
                                 x["outtype"] or "-")
    print("%-28s | %-22s | %-22s" % (p, s(y), s(h)))

print("\n=== 패키지 차이(공통 프로젝트) ===")
for p in sorted(set(out["yeolim"]) & set(out["huni"])):
    y, h = out["yeolim"][p]["packages"], out["huni"][p]["packages"]
    keys = sorted(set(y) | set(h))
    rows = [(k, y.get(k, "-"), h.get(k, "-")) for k in keys if y.get(k) != h.get(k)]
    if rows:
        print("[%s]" % p)
        for k, a, b in rows:
            print("   %-46s Y=%-12s H=%s" % (k, a, b))
