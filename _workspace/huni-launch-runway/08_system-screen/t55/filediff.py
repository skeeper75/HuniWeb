#!/usr/bin/env python3
"""공통 9개 프로젝트의 파일 단위 상태표를 낸다(동일/변경/한쪽만). 읽기전용."""
import json, os, sys

here = os.path.dirname(os.path.abspath(__file__))
inv = json.load(open(os.path.join(here, "inventory.json")))
common = sorted(set(inv["yeolim"]) & set(inv["huni"]))
only = sys.argv[1] if len(sys.argv) > 1 else None

for p in common:
    if only and only not in p:
        continue
    yf, hf = inv["yeolim"][p]["files"], inv["huni"][p]["files"]
    print("### %s" % p)
    for f in sorted(set(yf) | set(hf)):
        a, b = yf.get(f), hf.get(f)
        if a and b:
            st = "동일" if a["md5"] == b["md5"] else "변경"
            print("  %-4s %-42s Y:%4d줄  H:%4d줄" % (st, f, a["lines"], b["lines"]))
        elif a:
            print("  %-4s %-42s Y:%4d줄  H:  -" % ("열림만", f, a["lines"]))
        else:
            print("  %-4s %-42s Y:   -   H:%4d줄" % ("후니만", f, b["lines"]))
    print()
