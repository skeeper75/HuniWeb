#!/usr/bin/env python3
"""두 저장소의 CRT.Framework.* 프로젝트 인벤토리를 기계적으로 뽑는다. 읽기전용."""
import os, sys, json, hashlib, glob

Y = glob.glob("/Users/innojini/Dev/CRT.D*.V2")[0]
H = "/Users/innojini/Dev/TS.BackOffice.Huni/Framework"

SKIP = ("/obj/", "/bin/", "/.vs/")


def cs_files(root):
    out = {}
    for dirpath, dirnames, filenames in os.walk(root):
        p = dirpath.replace(os.sep, "/") + "/"
        if any(s in p for s in SKIP):
            continue
        for fn in filenames:
            if not fn.lower().endswith(".cs"):
                continue
            full = os.path.join(dirpath, fn)
            rel = os.path.relpath(full, root).replace(os.sep, "/")
            try:
                b = open(full, "rb").read()
            except OSError:
                continue
            out[rel] = {
                "bytes": len(b),
                "lines": b.count(b"\n") + (1 if b and not b.endswith(b"\n") else 0),
                "md5": hashlib.md5(b).hexdigest(),
            }
    return out


def projects(base):
    return sorted(
        d for d in os.listdir(base)
        if d.startswith("CRT.Framework.") and os.path.isdir(os.path.join(base, d))
    )


res = {"yeolim_root": Y, "huni_root": H, "yeolim": {}, "huni": {}}
for base, key in ((Y, "yeolim"), (H, "huni")):
    for proj in projects(base):
        files = cs_files(os.path.join(base, proj))
        res[key][proj] = {
            "file_count": len(files),
            "line_total": sum(f["lines"] for f in files.values()),
            "files": files,
        }

json.dump(res, open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "inventory.json"), "w"), indent=1)

yset, hset = set(res["yeolim"]), set(res["huni"])
print("=== 프로젝트 집합 ===")
print("공통(%d): %s" % (len(yset & hset), ", ".join(sorted(yset & hset))))
print("열림 전용(%d): %s" % (len(yset - hset), ", ".join(sorted(yset - hset))))
print("후니 전용(%d): %s" % (len(hset - yset), ", ".join(sorted(hset - yset))))
print()
print("=== 공통 9개 파일 단위 차이 ===")
hdr = "%-28s %6s %6s %7s %7s %6s %6s %6s"
print(hdr % ("project", "Y파일", "H파일", "Y줄", "H줄", "동일", "변경", "한쪽"))
for p in sorted(yset & hset):
    yf, hf = res["yeolim"][p]["files"], res["huni"][p]["files"]
    both = set(yf) & set(hf)
    same = sum(1 for f in both if yf[f]["md5"] == hf[f]["md5"])
    diff = len(both) - same
    only = len(set(yf) ^ set(hf))
    print(hdr % (p, len(yf), len(hf), res["yeolim"][p]["line_total"],
                 res["huni"][p]["line_total"], same, diff, only))
