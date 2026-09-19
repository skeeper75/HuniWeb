#!/usr/bin/env python3
"""공개 API(= public/protected 타입·멤버) 단위 차이. 정규식 근사 — 완전한 C# 파서가 아니다.
계산 규칙을 verdict 에 명시하고, 표본은 사람이 재확인한다. 읽기전용."""
import os, re, glob, json, collections

Y = glob.glob("/Users/innojini/Dev/CRT.D*.V2")[0]
H = "/Users/innojini/Dev/TS.BackOffice.Huni/Framework"
SKIP = ("/obj/", "/bin/", "/.vs/")

TYPE_RE = re.compile(
    r"^\s*(?:\[[^\]]*\]\s*)*(public|protected internal|protected)\s+"
    r"(?:static\s+|abstract\s+|sealed\s+|partial\s+|unsafe\s+)*"
    r"(class|struct|interface|enum)\s+([A-Za-z_]\w*)")
MEMBER_RE = re.compile(
    r"^\s*(?:\[[^\]]*\]\s*)*(public|protected internal|protected)\s+"
    r"(?:static\s+|virtual\s+|override\s+|abstract\s+|sealed\s+|readonly\s+|const\s+|"
    r"async\s+|extern\s+|new\s+|unsafe\s+|partial\s+)*"
    r"(?:[\w<>\[\],\.\?]+\s+)?([A-Za-z_]\w*)\s*(\(|\{|=>|;|=)")


def api(root):
    out = collections.defaultdict(set)
    for dp, dn, fn in os.walk(root):
        p = dp.replace(os.sep, "/") + "/"
        if any(s in p for s in SKIP):
            continue
        for f in fn:
            if not f.lower().endswith(".cs") or f.endswith(".Designer.cs"):
                continue
            if f == "AssemblyInfo.cs":
                continue
            rel = os.path.relpath(os.path.join(dp, f), root).replace(os.sep, "/")
            cur = None
            for i, line in enumerate(open(os.path.join(dp, f),
                                          encoding="utf-8-sig", errors="replace"), 1):
                mt = TYPE_RE.match(line)
                if mt:
                    cur = mt.group(3)
                    out["TYPE"].add(cur)
                    continue
                mm = MEMBER_RE.match(line)
                if mm and cur:
                    kind = "M" if mm.group(3) == "(" else "P"
                    out["MEMBER"].add("%s.%s%s" % (cur, mm.group(2),
                                                   "()" if kind == "M" else ""))
    return out


here = os.path.dirname(os.path.abspath(__file__))
rows = []
detail = {}
common = sorted(set(os.listdir(Y)) & set(os.listdir(H)))
common = [c for c in common if c.startswith("CRT.Framework.")]
for p in common:
    ya, ha = api(os.path.join(Y, p)), api(os.path.join(H, p))
    d = {}
    for k in ("TYPE", "MEMBER"):
        d[k] = {"only_yeolim": sorted(ya[k] - ha[k]),
                "only_huni": sorted(ha[k] - ya[k]),
                "both": len(ya[k] & ha[k])}
    detail[p] = d
    rows.append((p, len(ya["TYPE"]), len(ha["TYPE"]),
                 len(d["TYPE"]["only_yeolim"]), len(d["TYPE"]["only_huni"]),
                 len(ya["MEMBER"]), len(ha["MEMBER"]),
                 len(d["MEMBER"]["only_yeolim"]), len(d["MEMBER"]["only_huni"])))

json.dump(detail, open(os.path.join(here, "apidiff.json"), "w"), indent=1, ensure_ascii=False)

hdr = "%-28s %5s %5s %6s %6s | %6s %6s %7s %7s"
print(hdr % ("project", "Y타입", "H타입", "Y전용", "H전용", "Y멤버", "H멤버", "Y전용", "H전용"))
for r in rows:
    print(hdr % r)
print()
print("=== 한쪽에만 있는 공개 타입 (전수) ===")
for p in common:
    oy, oh = detail[p]["TYPE"]["only_yeolim"], detail[p]["TYPE"]["only_huni"]
    if oy or oh:
        print("[%s]" % p)
        if oy:
            print("   열림만: " + ", ".join(oy))
        if oh:
            print("   후니만: " + ", ".join(oh))
